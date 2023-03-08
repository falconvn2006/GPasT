unit uClient;

interface

uses
  Windows, SysUtils, Classes, DB, DBClient, StrUtils, uCommon, Main_Dm, Dialogs,
  IBODataset, Load_Frm, GinkoiaStyle_Dm, IBSQL, IBStoredProc, uDefs, IBQuery, uLog;

type
  TClient = Class(TThread)
    private
      iCodeCorrection: Integer;
      bRepriseTicket: boolean;
      bEnabledProcessold : Boolean;

      bRetirePtVirg: boolean;

      sPathClients      : string;
      sPathLienClients  : string;
      sPathComptes      : string;
      sPathFidelite     : string;
      sPathBonAchats    : string;

      sEtat1: string;
      sEtat2: string;
      sError: string;
      iMaxProgress: integer;
      iProgress: integer;
      iTraitement: integer;
      NbTraitement: integer;

      LigneLecture: string;

      cds_Magasin: TClientDataSet;

      cds_Clients     : TStringList;
      cds_LienClients : TStringList;
      cds_Comptes     : TStringList;
      cds_Fidelite    : TStringList;
      cds_BonAchats   : TStringList;

      StProc_Client       : TIBSQL;
      StProc_LienClients  : TIBSQL;
      StProc_Compte       : TIBSQL;
      StProc_Fidelite     : TIBSQL;
      StProc_BonAchats    : TIBSQL;

      StProc_Correction : TIBSQL;

      procedure DoLog(const sVal: String; const aLvl: TLogLevel);
      function LoadFile:Boolean;

      function GetValueClientsImp(AChamp: string): string;
      function GetValueLienClientsImp(AChamp: string): string;
      function GetValueComptesImp(AChamp: string): string;
      function GetValueFideliteImp(AChamp: string): string;
      function GetValueBonAchatsImp(AChamp: string): string;

      procedure AjoutInfoLigne(ALigne: string; ADefColonne: array of string);

      function TraiterClients:Boolean;
      function TraiterLienClientsProPart:Boolean;
      function TraiterComptes:Boolean;
      function TraiterFidelite:Boolean;
      function TraiterBonAchats:Boolean;

      function CorrectionAvoir:Boolean;
      function CorrectionLienFidBa:Boolean;

      //Mise à jour de la fenêtre d'attente
      procedure InitFrm;          // initilisation
      procedure InitExecute;      // début execution
      procedure UpdateFrm;        // Mise à jour
      procedure ErrorFrm;         // traitement des erreurs
      procedure EndFrm;           // fin du traitement
      procedure InitProgressFrm ; // initialisation progression
      procedure UpdProgressFrm ;  // maj progression

      //*********************************//
    public
      bError: boolean;
      constructor Create(aCreateSuspended, aEnabledProcess, aRepriseTicket :Boolean; Const aCodeCorrection :Integer = 0);
      destructor Destroy; override;
      procedure InitThread(ARetirePtVirg: boolean; aPathClient, aPathComptes,
                            aPathFidelite, aPathBonAchats, aPathLienClient : string);

    protected
      procedure Execute; override;

  End;

implementation

uses
  Graphics;

{ TClient }

procedure TClient.AjoutInfoLigne(ALigne: string; ADefColonne: array of string);
var
  sLigne: string;
  NBre: integer;
begin
  LigneLecture := ALigne;
  sLigne := ALigne;
  if (bRetirePtVirg) and (sLigne<>'') and (sLigne[Length(sLigne)]=';') then
    sLigne := Copy(sLigne, 1, Length(sLigne)-1);

  if (sLigne<>'') and (sLigne[1]='"') then
  begin
    Nbre := 1;
    while Pos('";"', sLigne)>0 do
    begin
      sLigne := Copy(sLigne, Pos('";"', sLigne)+2, Length(sLigne));
      Inc(Nbre);
    end;
  end
  else
  begin
    Nbre := 1;
    while Pos(';', sLigne)>0 do
    begin
      sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
      Inc(Nbre);
    end;
  end;

  if High(ADefColonne)<>(Nbre-1) then
    Raise Exception.Create('Nombre de champs invalide par rapport à l''entête:'+#13#10+
                           '  - Moins de champ: surement un retour chariot dans la ligne'+#13#10+
                           '  - Plus de champ: surement un ; ou un " de trop dans la ligne');
end;

function TClient.CorrectionAvoir: Boolean;
var
  iCteID: integer;
  iCltID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  iMagID: integer;
  CodeMag: string;

  LstParam  : TStringList;
begin
  Result := true;

  iMaxProgress := cds_Comptes.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Comptes_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  //Backup des paramètres
  LstParam := TStringList.Create;
  NbRech := Dm_Main.ListeIDComptes.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    LstParam.Add('Voici la liste des Avoirs corrigés');
    i := 1;
    try
      NbEnre := cds_Comptes.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Comptes[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Comptes[i], Comptes_COL);

          // magasin
          CodeMag := GetValueComptesImp('CODE_MAG');
          iMagID := 0;
          if (CodeMag<>'') and cds_Magasin.Locate('MAG_CODEADH', CodeMag, []) then
            iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheComptesID(GetValueComptesImp('CODE'), NbRech);

          // Correction si déjà créé
          if (LRechID<>-1) then
          begin
            LRechID := Dm_Main.GetComptesID(GetValueComptesImp('CODE'));
            if not(Dm_Main.TransacCli.InTransaction) then
              Dm_Main.TransacCli.StartTransaction;

            //Traitement des Avoirs
            StProc_Correction.Close;
            StProc_Correction.ParamByName('CTEID').AsInteger          := LRechID;
            StProc_Correction.ParamByName('CTEMAGID').AsInteger       := iMagID;
            StProc_Correction.ParamByName('CTECREDIT').AsDouble       := ConvertStrToFloat(GetValueComptesImp('CREDIT'));
            StProc_Correction.ParamByName('CTEDEBIT').AsDouble        := ConvertStrToFloat(GetValueComptesImp('DEBIT'));
            StProc_Correction.ExecQuery;

             // récupération du nouvel ID Compte
            iCteID := StProc_Correction.FieldByName('CTEID_2').AsInteger;

            if (LRechID <> iCteID) then
            begin
              LstParam.Add( GetValueComptesImp('CODE') +
                            GetValueComptesImp('LIBELLE') +
                            GetValueComptesImp('DATE') +
                            ': Non modifié car non trouvé en base de donnée.');
            end
            else
            begin
              LstParam.Add( GetValueComptesImp('CODE') +
                            GetValueComptesImp('LIBELLE') +
                            GetValueComptesImp('DATE') +
                            ': Modifié.');
            end;

            StProc_Correction.Close;

            Dm_Main.TransacCli.Commit;
          end
          else
          begin
            //Nouvelle ligne
            LstParam.Add( GetValueComptesImp('CODE') +
                          GetValueComptesImp('LIBELLE') +
                          GetValueComptesImp('DATE') +
                          ': Nouvelle ligne non ajouté.');
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacCli.InTransaction) then
          Dm_Main.TransacCli.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeComptesID;
    StProc_Correction.Close;
    LstParam.SaveToFile(Dm_Main.ReperSavID + 'Correction_Avoir' + FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstParam);
  end;
end;

function TClient.CorrectionLienFidBa: Boolean;
var
  iTkeID: Integer;
  iCltID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  iMagID: integer;
  CodeMag: string;

  LstParam  : TStringList;
begin
  Result := true;

  iMaxProgress := cds_Fidelite.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Fidelite_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  //Backup des paramètres
  LstParam := TStringList.Create;
  NbRech := Dm_Main.ListeIDFidelite.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    LstParam.Add('Voici la liste des lien Fidélité corrigés');
    i := 1;
    try
      NbEnre := cds_Fidelite.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Fidelite[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Fidelite[i], Fidelite_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheFideliteID(GetValueFideliteImp('CODE'), NbRech);

          // Correction si déjà créé
          if (LRechID<>-1) then
          begin
            LRechID := Dm_Main.GetFideliteID(GetValueFideliteImp('CODE'));
            if not(Dm_Main.TransacCli.InTransaction) then
              Dm_Main.TransacCli.StartTransaction;

            //Traitement Fid
            StProc_Correction.Close;
            StProc_Correction.ParamByName('FIDID').AsInteger := LRechID;
            StProc_Correction.ParamByName('BACID').AsInteger := 0;
            StProc_Correction.ParamByName('CODE_SESSION').AsString := '9' + GetValueFideliteImp('CODE_SESSION');
            StProc_Correction.ParamByName('NUM_TICKET').AsString := GetValueFideliteImp('NUM_TICKET');
            StProc_Correction.ExecQuery;

             // récupération du nouvel ID Compte
            iTkeID := StProc_Correction.FieldByName('TKEID').AsInteger;

            if (iTkeID <> 0) then
            begin
              LstParam.Add( GetValueFideliteImp('CODE') + ';' +
                            GetValueFideliteImp('CODE_SESSION') + ';' +
                            GetValueFideliteImp('NUM_TICKET') + ';' +
                            IntToStr(iTkeID) +
                            ': Lien avec le ticket fait.');
            end
            else
            begin
              LstParam.Add( GetValueFideliteImp('CODE') + ';' +
                            GetValueFideliteImp('CODE_SESSION') + ';' +
                            GetValueFideliteImp('NUM_TICKET') + ';' +
                            IntToStr(iTkeID) +
                            ': Lien avec le ticket non fait cat pas trouvé.');
            end;

            StProc_Correction.Close;

            Dm_Main.TransacCli.Commit;
          end
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacCli.InTransaction) then
          Dm_Main.TransacCli.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeComptesID;
    StProc_Correction.Close;
    LstParam.SaveToFile(Dm_Main.ReperSavID + 'Correction_FID' + FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstParam);
  end;

  iMaxProgress := cds_BonAchats.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + BonAchats_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  //Backup des paramètres
  LstParam := TStringList.Create;
  NbRech := Dm_Main.ListeIDBonAchats.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    LstParam.Add('Voici la liste des lien BonAchat corrigés');
    i := 1;
    try
      NbEnre := cds_BonAchats.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_BonAchats[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_BonAchats[i], BonAchats_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheBonAchatsID(GetValueBonAchatsImp('CODE'), NbRech);

          // Correction si déjà créé
          if (LRechID<>-1) then
          begin
            LRechID := Dm_Main.GetBonAchatsID(GetValueBonAchatsImp('CODE'));
            if not(Dm_Main.TransacCli.InTransaction) then
              Dm_Main.TransacCli.StartTransaction;

            //Traitement Fid
            StProc_Correction.Close;
            StProc_Correction.ParamByName('FIDID').AsInteger := 0;
            StProc_Correction.ParamByName('BACID').AsInteger := LRechID;
            StProc_Correction.ParamByName('CODE_SESSION').AsString := GetValueBonAchatsImp('CODE_SESSION');
            StProc_Correction.ParamByName('NUM_TICKET').AsString := GetValueBonAchatsImp('NUM_TICKET');
            StProc_Correction.ExecQuery;

             // récupération du nouvel ID Compte
            iTkeID := StProc_Correction.FieldByName('TKEID').AsInteger;

            if (iTkeID <> 0) then
            begin
              LstParam.Add( GetValueBonAchatsImp('CODE') + ';' +
                            GetValueBonAchatsImp('CODE_SESSION') + ';' +
                            GetValueBonAchatsImp('NUM_TICKET') + ';' +
                            IntToStr(iTkeID) +
                            ': Lien avec le ticket fait.');
            end
            else
            begin
              LstParam.Add( GetValueBonAchatsImp('CODE') + ';' +
                            GetValueBonAchatsImp('CODE_SESSION') + ';' +
                            GetValueBonAchatsImp('NUM_TICKET') + ';' +
                            IntToStr(iTkeID) +
                            ': Lien avec le ticket non fait cat pas trouvé.');
            end;

            StProc_Correction.Close;

            Dm_Main.TransacCli.Commit;
          end
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacCli.InTransaction) then
          Dm_Main.TransacCli.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeComptesID;
    StProc_Correction.Close;
    LstParam.SaveToFile(Dm_Main.ReperSavID + 'Correction_BA' + FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstParam);
  end;
end;

constructor TClient.Create(aCreateSuspended, aEnabledProcess, aRepriseTicket:Boolean;
  Const aCodeCorrection :Integer = 0);
var
  sSql : string;
begin
  inherited Create(aCreateSuspended);

  bRepriseTicket := aRepriseTicket;
  iCodeCorrection := aCodeCorrection;

  bError := false;

  FreeOnTerminate := true;
  Priority := tpHigher;
  bEnabledProcessold := aEnabledProcess;

  sEtat1 := '';
  sEtat2 := '';
  sError := '';
  NbTraitement := 5;

  cds_Clients     := TStringList.Create;
  cds_LienClients := TStringList.Create;
  cds_Comptes     := TStringList.Create;
  cds_Fidelite    := TStringList.Create;
  cds_BonAchats   := TStringList.Create;

  Dm_Main.TransacCli.Active := true;

  // magasin en mémoire
  cds_Magasin := TClientDataSet.Create(nil);
  cds_Magasin.FieldDefs.Add('MAG_ID',ftInteger,0);
  cds_Magasin.FieldDefs.Add('MAG_CODEADH',ftString,32);
  cds_Magasin.CreateDataSet;
  cds_Magasin.LogChanges := False;
  cds_Magasin.Open;

  // Clients
  StProc_Client := TIBSQL.Create(nil);
  with StProc_Client do
  begin
    Database := Dm_Main.Database;
    Transaction := Dm_Main.TransacCli;
    ParamCheck := True;
    SQL.Add(cSql_MG10_CLIENT);
    Prepare;
  end;

  // Lien Clients
  StProc_LienClients := TIBSQL.Create(nil);
  with StProc_LienClients do
  begin
    Database := Dm_Main.Database;
    Transaction := Dm_Main.TransacCli;
    ParamCheck := True;
    SQL.Add(cSql_MG10_LIEN_CLIENT);
    Prepare;
  end;

  // Comptes
  StProc_Compte := TIBSQL.Create(nil);
  with StProc_Compte do
  begin
    Database := Dm_Main.Database;
    Transaction := Dm_Main.TransacCli;
    ParamCheck := True;
    SQL.Add(cSql_MG10_COMPTE);
    Prepare;
  end;

  // Fidélité
  StProc_Fidelite := TIBSQL.Create(nil);
  with StProc_Fidelite do
  begin
    Database := Dm_Main.Database;
    Transaction := Dm_Main.TransacCli;
    ParamCheck := True;
    SQL.Add(cSql_MG10_FIDELITE);
    Prepare;
  end;

  // Bon d'achats
  StProc_BonAchats := TIBSQL.Create(nil);
  with StProc_BonAchats do
  begin
    Database := Dm_Main.Database;
    Transaction := Dm_Main.TransacCli;
    ParamCheck := True;
    SQL.Add(cSql_MG10_BONACHATS);
    Prepare;
  end;

  // Correction Divers
  StProc_Correction := TIBSQL.Create(nil);
  with StProc_Correction do
  begin
    Database := Dm_Main.Database;
    Transaction := Dm_Main.TransacCli;
    ParamCheck := True;
    case aCodeCorrection of
      0, 1 : SQL.Add(cSql_MG10_CORRECTION_AVOIR);
      2 : SQL.Add(cSql_MG10_CORRECTION_FID_BA);
    end;

    Prepare;
  end;
end;

procedure TClient.DoLog(const sVal: String; const aLvl: TLogLevel);
begin
  uLog.Log.Log('uClient', 'log', sVal, aLvl, False, -1, ltLocal);
end;

destructor TClient.Destroy;
begin
  inherited;

  Dm_Main.TransacCli.Active := false;

  if Assigned(cds_Clients) then
    FreeAndNil(cds_Clients);
  if Assigned(cds_LienClients) then
    FreeAndNil(cds_LienClients);
  if Assigned(cds_Comptes) then
    FreeAndNil(cds_Comptes);
  if Assigned(cds_Fidelite) then
    FreeAndNil(cds_Fidelite);
  if Assigned(cds_BonAchats) then
    FreeAndNil(cds_BonAchats);

  FreeAndNil(cds_Magasin);
  FreeAndNil(StProc_Client);
  FreeAndNil(StProc_LienClients);
  FreeAndNil(StProc_Compte);
  FreeAndNil(StProc_Fidelite);
  FreeAndNil(StProc_BonAchats);
  FreeAndNil(StProc_Correction);
end;

procedure TClient.UpdateFrm;
begin
  Frm_Load.Lab_EtatCli1.Caption := sEtat1;
  Frm_Load.Lab_EtatCli2.Caption := sEtat2;
  Frm_Load.Lab_EtatCli2.Hint := sEtat2;
end;

procedure TClient.UpdProgressFrm;
begin
  Frm_Load.Lab_EtatCli2.Caption := sEtat2;
  Frm_Load.Lab_EtatCli2.Hint := sEtat2;
  Frm_Load.pb_EtatCli.Position := iProgress;
end;

procedure TClient.EndFrm;
var
  bm: tbitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(0, bm);
    Frm_Load.img_Clients.Picture := nil;
    Frm_Load.img_Clients.Picture.Assign(bm);
    Frm_Load.img_Clients.Transparent := false;
    Frm_Load.img_Clients.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
  Frm_Load.Lab_EtatCli1.Caption := 'Importation';
  Frm_Load.Lab_EtatCli2.Caption := 'Terminé';
  Frm_Load.Lab_EtatCli2.Hint := '';
end;

procedure TClient.ErrorFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(10, bm);
    Frm_Load.img_Clients.Picture := nil;
    Frm_Load.img_Clients.Picture.Assign(bm);
    Frm_Load.img_Clients.Transparent := false;
    Frm_Load.img_Clients.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
  Frm_Load.DoErreurCli(sError);
end;

procedure TClient.Execute;
var
  bContinue: boolean;
  tTot: TDateTime;
  tProc: TDateTime;
  tpListeDelai: TStringList;
begin
  inherited;

  bError := false;
  bContinue := true;
  tpListeDelai:= TStringList.Create;
  tTot := Now;
  try
    iTraitement := 0;
    Synchronize(InitExecute);

    // Chargement des fichiers;
    if bContinue then
    begin
      tProc := Now;
      bContinue := LoadFile;
      tpListeDelai.Add('  Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Client - Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    case iCodeCorrection of
      0 :
      begin
        // Clients
        if bContinue then
        begin
          tProc := Now;
          bContinue := TraiterClients;
          tpListeDelai.Add('  Client: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
          if Dm_Main.GetDoMail(AllMail) then
            SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Client - Client: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
        end;

        if not(bRepriseTicket) then
        begin
          // Clients
          if bContinue then
          begin
            tProc := Now;
            bContinue := TraiterLienClientsProPart;
            tpListeDelai.Add('  Lien Client: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Client - Lien Client: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
          end;
        end;

        // Comptes
        if bContinue then
        begin
          tProc := Now;
          bContinue := TraiterComptes;
          tpListeDelai.Add('  Comptes: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
          if Dm_Main.GetDoMail(AllMail) then
            SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Client - Comptes: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
        end;

        if not(bRepriseTicket) then
        begin
          // Bon d'achats
          if bContinue and (Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport]) then
          begin
            tProc := Now;
            bContinue := TraiterBonAchats;
            tpListeDelai.Add('  Bon d''achats: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Client - Bon d''achats: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
          end;

          // Fidélité
          if bContinue and (Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport]) then
          begin
            tProc := Now;
            bContinue := TraiterFidelite;
            tpListeDelai.Add('  Fidélité: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            if Dm_Main.GetDoMail(AllMail) then
              SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Client - Fidélité: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
          end;
        end;
      end;

      1 :
      begin
        //Correction des Avoir
        inc(iTraitement); //Client
        tProc := Now;
        bContinue := CorrectionAvoir;
        tpListeDelai.Add('  Avoir: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Client - Correction Avoir: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
        inc(iTraitement); //Bon d'achats
        inc(iTraitement); //Fidélité
      end;

      2 :
      begin
        //Correction lien Fid et Ba
        inc(iTraitement); //Client
        inc(iTraitement); //Compte
        tProc := Now;
        bContinue := CorrectionLienFidBa;
        tpListeDelai.Add('  Lien Fid Ba: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
        if Dm_Main.GetDoMail(AllMail) then
          SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Client - Correction Lien Fid Ba: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
        inc(iTraitement); //Bon d'achats
      end;
    end;

    if sError<>'' then
    begin
      tpListeDelai.Add(sError);
      if Dm_Main.GetDoMail(ErreurMail) then
        SendEmail(Dm_Main.GetMailLst, '[ALERT - ERREUR] - ' + Dm_Main.GetSubjectMail,'Client - ' + sError);
    end;

    tpListeDelai.Add('');
    tpListeDelai.Add('');
    tpListeDelai.Add('Temps total: '+formatdatetime('hh:nn:ss:zzz', now-tTot));
    if Dm_Main.GetDoMail(CliArtHistBonRAtelier) then
        SendEmail(Dm_Main.GetMailLst, '[Fin Client] - ' + Dm_Main.GetSubjectMail,'Client - Temps total: '+formatdatetime('hh:nn:ss:zzz', now-tTot));

    try
      tpListeDelai.SaveToFile(Dm_Main.ReperBase + Dm_Main.GetSubjectMail + '_Delai_Import_Cli_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    except
    end;

    if bContinue then
      Synchronize(EndFrm);
  finally
    bError := not(bContinue);
    FreeAndNil(tpListeDelai);
  end;
end;

function TClient.GetValueBonAchatsImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, BonAchats_COL, LigneLecture, bRetirePtVirg);
end;

function TClient.GetValueClientsImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Clients_COL, LigneLecture, bRetirePtVirg);
end;

function TClient.GetValueComptesImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Comptes_COL, LigneLecture, bRetirePtVirg);
end;

function TClient.GetValueFideliteImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Fidelite_COL, LigneLecture, bRetirePtVirg);
end;

function TClient.GetValueLienClientsImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, LienClients_COL, LigneLecture, bRetirePtVirg);
end;

procedure TClient.InitExecute;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(3, bm);
    Frm_Load.img_Clients.Picture:=nil;
    Frm_Load.img_Clients.Picture.Assign(bm);
    Frm_Load.img_Clients.Transparent := false;
    Frm_Load.img_Clients.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
end;

procedure TClient.InitFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(11, bm);
    Frm_Load.img_Clients.Picture:=nil;
    Frm_Load.img_Clients.Picture.Assign(bm);
    Frm_Load.img_Clients.Transparent := false;
    Frm_Load.img_Clients.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
  Frm_Load.Lab_EtatCli1.Caption := 'Initialisation';
  Frm_Load.Lab_EtatCli2.Caption := '';
  Frm_Load.Lab_EtatCli2.Hint := '';
end;

procedure TClient.InitProgressFrm;
begin
  Frm_Load.pb_EtatCli.Position := 0;
  Frm_Load.pb_EtatCli.Max := iMaxProgress;
end;

procedure TClient.InitThread(ARetirePtVirg: boolean; aPathClient, aPathComptes,
  aPathFidelite, aPathBonAchats, aPathLienClient: string);
begin
  Synchronize(InitFrm);

  bRetirePtVirg := ARetirePtVirg;

  sPathClients      := aPathClient;
  sPathLienClients  := aPathLienClient;
  sPathComptes      := aPathComptes;
  sPathFidelite     := aPathFidelite;
  sPathBonAchats    := aPathBonAchats;
end;

function TClient.LoadFile: Boolean;
var
  Que_Tmp: TIBQuery;
begin
  result := true;

  cds_Clients.Clear;
  cds_Comptes.Clear;

  sEtat1 := 'Chargement:';

  Que_Tmp := TIbQuery.Create(nil);
  try
    try
      Que_Tmp.Database := dm_Main.Database;
      // mise en mémoire de la liste des magasins
      sEtat2 := 'Magasin ';
      Synchronize(UpdateFrm);
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
    except
      on E: Exception do
      begin
        Result := False;
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  finally
    Que_Tmp.Close;
    FreeAndNil(Que_Tmp);
  end;

  // Chargement Clients
  try
    sEtat2 := 'Fichier ' + Clients_CSV;
    Synchronize(UpdateFrm);
    cds_Clients.LoadFromFile(sPathClients);
    Dm_Main.LoadListeClientID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  if not(bRepriseTicket) then
  begin
    // Chargement LienClients
    try
      sEtat2 := 'Fichier ' + LienClients_CSV;
      Synchronize(UpdateFrm);
      cds_LienClients.LoadFromFile(sPathLienClients);
      Dm_Main.LoadListeLienClientID;
    except
      on E:Exception do
      begin
        Result := False;
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  end;

  // Chargement Comptes
  try
    sEtat2 := 'Fichier ' + Comptes_CSV;
    Synchronize(UpdateFrm);
    cds_Comptes.LoadFromFile(sPathComptes);
    Dm_Main.LoadListeComptesID;
  except
    on E: Exception do
    begin
      Result := False;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  if not(bRepriseTicket) then
  begin
    // Chargement Fidélité
    try
      sEtat2 := 'Fichier ' + Fidelite_CSV;
      Synchronize(UpdateFrm);
      cds_Fidelite.LoadFromFile(sPathFidelite);
      Dm_Main.LoadListeFideliteID;
    except
      on E: Exception do
      begin
        Result := False;
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(ErrorFrm);
        exit;
      end;
    end;

    // Chargement Bon Achats
    try
      sEtat2 := 'Fichier ' + BonAchats_CSV;
      Synchronize(UpdateFrm);
      cds_BonAchats.LoadFromFile(sPathBonAchats);
      Dm_Main.LoadListeBonAchatsID;
    except
      on E: Exception do
      begin
        Result := False;
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  end;
end;

function TClient.TraiterBonAchats: Boolean;
var
  iCltID: integer;
  iBacID: integer;
  iMagID: integer;
//  iFidID: integer;
  CodeMag: string;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Delai: DWord;
begin
  Result := true;

  iMaxProgress := cds_BonAchats.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + BonAchats_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  Delai := GetTickCount;
  NbRech := Dm_Main.ListeIDBonAchats.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_BonAchats.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) or ((GetTickCount-Delai)>2500) then
        begin
          Synchronize(UpdProgressFrm);
          Delai := GetTickCount;
        end;

        if cds_BonAchats[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_BonAchats[i], BonAchats_COL);

          // magasin
          CodeMag := GetValueBonAchatsImp('CODE_MAG');
          iMagID := 0;
          if (CodeMag<>'') and cds_Magasin.Locate('MAG_CODEADH', CodeMag, []) then
            iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;

          //Recherche du client
          iCltID := Dm_Main.GetClientID(GetValueBonAchatsImp('CODE_CLIENT'));
          if iCltID=-1 then
            iCltID := 0;

//          //Recherche du Fid
//          iFidID := Dm_Main.GetFideliteID(GetValueBonAchatsImp('CODE_FID'));
//          if iFidID=-1 then
//            iFidID := 0;

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheBonAchatsID(GetValueBonAchatsImp('CODE'), NbRech);

          // création si pas déjà créé
          if (LRechID=-1) and (GetValueBonAchatsImp('CODE')<>'') then
          begin
            if not(Dm_Main.TransacCli.InTransaction) then
              Dm_Main.TransacCli.StartTransaction;

            //Traitement des Clients
            StProc_BonAchats.Close;
            StProc_BonAchats.ParamByName('CLTID').AsInteger       := iCltID;
            StProc_BonAchats.ParamByName('MONTANT').AsFloat       := StrToFloat(GetValueBonAchatsImp('MONTANT'));
            StProc_BonAchats.ParamByName('TKEID').AsInteger       := 0;
            StProc_BonAchats.ParamByName('CODE_POSTE').AsString   := GetValueBonAchatsImp('CODE_POSTE');
            StProc_BonAchats.ParamByName('CODE_SESSION').AsString := GetValueBonAchatsImp('CODE_SESSION');
            StProc_BonAchats.ParamByName('NUM_TICKET').AsString   := GetValueBonAchatsImp('NUM_TICKET');
            StProc_BonAchats.ParamByName('MAGID').AsInteger       := iMagID;
//            StProc_BonAchats.ParamByName('FIDID').AsInteger       := iFidID;
            StProc_BonAchats.ExecQuery;

            // récupération du nouvel ID Client
            iBacID := StProc_BonAchats.FieldByName('BACID').AsInteger;
            Dm_Main.AjoutInListeBonAchatsID(GetValueBonAchatsImp('CODE'), iBacID);

            StProc_BonAchats.Close;

            Dm_Main.TransacCli.Commit;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacCli.InTransaction) then
          Dm_Main.TransacCli.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeBonAchatsID;
    StProc_BonAchats.Close;
  end;
end;

function TClient.TraiterClients: Boolean;
var
  sAdresse: string;
  iCltID: integer;
  iMagID: integer;
  CodeMag: string;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Delai: DWord;
begin
  Result := true;

  iMaxProgress := cds_Clients.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Clients_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  Delai := GetTickCount;
  NbRech := Dm_Main.ListeIDClient.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Clients.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) or ((GetTickCount-Delai)>2500) then
        begin
          Synchronize(UpdProgressFrm);
          Delai := GetTickCount;
        end;

        if cds_Clients[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Clients[i], Clients_COL);

          // magasin
          CodeMag := GetValueClientsImp('CODE_MAG');
          iMagID := 0;
          if (CodeMag<>'') and cds_Magasin.Locate('MAG_CODEADH', CodeMag, []) then
            iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheClientID(GetValueClientsImp('CODE'), NbRech);

          // création si pas déjà créé
          if (LRechID=-1)
           and (GetValueClientsImp('CODE')<>'')
           and (GetValueClientsImp('NOM_RS1')<>'') then
          begin
            if not(Dm_Main.TransacCli.InTransaction) then
              Dm_Main.TransacCli.StartTransaction;

            sAdresse := GetValueClientsImp('ADR1')+#13#10+
                        GetValueClientsImp('ADR2')+#13#10+
                        GetValueClientsImp('ADR3');

            //Traitement des Clients
            StProc_Client.Close;
            StProc_Client.ParamByName('IMPREFSTR').AsString   := GetValueClientsImp('CODE');
            StProc_Client.ParamByName('CLTTYPE').AsInteger    := StrToIntDef(GetValueClientsImp('TYPE'),0);
            StProc_Client.ParamByName('CLTNOM').AsString      := GetValueClientsImp('NOM_RS1');
            StProc_Client.ParamByName('CLTPRENOM').AsString   := GetValueClientsImp('PREN_RS2');
            StProc_Client.ParamByName('CIVNOM').AsString      := GetValueClientsImp('CIV');
            StProc_Client.ParamByName('ADRLIGNE').AsString    := sAdresse;
            StProc_Client.ParamByName('VILCP').AsString       := GetValueClientsImp('CP');
            StProc_Client.ParamByName('VILNOM').AsString      := GetValueClientsImp('VILLE');
            StProc_Client.ParamByName('PAYNOM').AsString      := GetValueClientsImp('PAYS');
            StProc_Client.ParamByName('CLTCOMPTA').AsString   := GetValueClientsImp('CODE_COMPTABLE');
            StProc_Client.ParamByName('CLTCOMMENT').AsString  := GetValueClientsImp('COM');
            StProc_Client.ParamByName('ADRTEL').AsString      := GetValueClientsImp('TEL');
            StProc_Client.ParamByName('ADRFAX').AsString      := GetValueClientsImp('FAX_TTRAV');
            StProc_Client.ParamByName('ADRGSM').AsString      := GetValueClientsImp('PORTABLE');
            StProc_Client.ParamByName('ADREMAIL').AsString    := GetValueClientsImp('EMAIL');
            StProc_Client.ParamByName('CB_NATIONAL').AsString := GetValueClientsImp('CB_NATIONAL');
            StProc_Client.ParamByName('ICLNOM1').AsString     := GetValueClientsImp('CLASS1');
            StProc_Client.ParamByName('ICLNOM2').AsString     := GetValueClientsImp('CLASS2');
            StProc_Client.ParamByName('ICLNOM3').AsString     := GetValueClientsImp('CLASS3');
            StProc_Client.ParamByName('ICLNOM4').AsString     := GetValueClientsImp('CLASS4');
            StProc_Client.ParamByName('ICLNOM5').AsString     := GetValueClientsImp('CLASS5');
            StProc_Client.ParamByName('CLTMAGID').AsInteger   := iMagID;
            StProc_Client.ParamByName('CB_INTERNE').AsString  := GetValueClientsImp('CB_INTERNE');
            StProc_Client.ParamByName('CLI_NUMERO').AsString  := GetValueClientsImp('CLI_NUMERO');
            StProc_Client.ExecQuery;

            // récupération du nouvel ID Client
            iCltID := StProc_Client.FieldByName('CLTID').AsInteger;
            Dm_Main.AjoutInListeClientID(GetValueClientsImp('CODE'), iCltID);

            StProc_Client.Close;

            Dm_Main.TransacCli.Commit;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacCli.InTransaction) then
          Dm_Main.TransacCli.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeClientID;
    StProc_Client.Close;

  end;
end;

function TClient.TraiterComptes: Boolean;
var
  iCteID: integer;
  iCltID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  iMagID: integer;
  CodeMag: string;
  vCode, vLibelle, vDate : string;
begin
  Result := true;

  iMaxProgress := cds_Comptes.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Comptes_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDComptes.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Comptes.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Comptes[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Comptes[i], Comptes_COL);

          vCode := GetValueComptesImp('CODE');
          vLibelle := GetValueComptesImp('LIBELLE');
          vDate := GetValueComptesImp('DATE');

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheComptesID(vCode + vLibelle + vDate, NbRech);

          // création si pas déjà créé
          if ((LRechID=-1) or bRepriseTicket)
           and (vCode<>'')
           and (vDate<>'') then
          begin
            // magasin
            CodeMag := GetValueComptesImp('CODE_MAG');
            iMagID := 0;
            if (CodeMag<>'') and cds_Magasin.Locate('MAG_CODEADH', CodeMag, []) then
              iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;

            if not(Dm_Main.TransacCli.InTransaction) then
              Dm_Main.TransacCli.StartTransaction;

            iCltID := Dm_Main.GetClientID(vCode);
            if iCltID=-1 then
              iCltID := 0;
            //Traitement des Comptes
            StProc_Compte.Close;
            StProc_Compte.ParamByName('CLTID').AsInteger          := iCltID;
            StProc_Compte.ParamByName('CTEMAGID').AsInteger       := iMagID;
            StProc_Compte.ParamByName('CTELIBELLE').AsString      := vLibelle;
            StProc_Compte.ParamByName('CTEDATE').AsDateTime       := StrToDateTime(vDate);
            StProc_Compte.ParamByName('CTECREDIT').AsDouble       := ConvertStrToFloat(GetValueComptesImp('CREDIT'));
            StProc_Compte.ParamByName('CTEDEBIT').AsDouble        := ConvertStrToFloat(GetValueComptesImp('DEBIT'));
            if bRepriseTicket then
            begin
              StProc_Compte.ParamByName('CTELETTRAGE').AsInteger    := 0;
              StProc_Compte.ParamByName('CTELETTRAGENUM').AsString  := '';
            end
            else
            begin
              StProc_Compte.ParamByName('CTELETTRAGE').AsInteger    := StrToInt(GetValueComptesImp('LETTRAGE'));
              StProc_Compte.ParamByName('CTELETTRAGENUM').AsString  := GetValueComptesImp('LETNUM');
            end;
            StProc_Compte.ParamByName('CTEORIGINE').AsInteger     := StrToInt(GetValueComptesImp('ORIGINE'));
            StProc_Compte.ExecQuery;

             // récupération du nouvel ID Compte
            iCteID := StProc_Compte.FieldByName('CTEID').AsInteger;
            Dm_Main.AjoutInListeComptesID(vCode + vLibelle + vDate, iCteID);

            StProc_Compte.Close;

            Dm_Main.TransacCli.Commit;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacCli.InTransaction) then
          Dm_Main.TransacCli.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeComptesID;
    StProc_Compte.Close;
  end;
end;

function TClient.TraiterFidelite: Boolean;
var
  iCltID: integer;
  iMagID: integer;
  iFidID: integer;
  iBacID: integer;
  CodeMag: string;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Delai: DWord;
begin
  Result := true;

  iMaxProgress := cds_Fidelite.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + Fidelite_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  Delai := GetTickCount;
  NbRech := Dm_Main.ListeIDFidelite.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Fidelite.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) or ((GetTickCount-Delai)>2500) then
        begin
          Synchronize(UpdProgressFrm);
          Delai := GetTickCount;
        end;

        if cds_Fidelite[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Fidelite[i], Fidelite_COL);

          // magasin
          CodeMag := GetValueFideliteImp('CODE_MAG');
          iMagID := 0;
          if (CodeMag<>'') and cds_Magasin.Locate('MAG_CODEADH', CodeMag, []) then
            iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;

          //Recherche du client
          iCltID := Dm_Main.GetClientID(GetValueFideliteImp('CODE_CLIENT'));
          if iCltID=-1 then
            iCltID := 0;

          //Recherche d'un bon d'achat
          iBacID := Dm_Main.GetBonAchatsID(GetValueFideliteImp('CODE_BA'));
          if iBacID=-1 then
            iBacID := 0;

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheFideliteID(GetValueFideliteImp('CODE'), NbRech);

          // création si pas déjà créé
          if (LRechID=-1) and (GetValueFideliteImp('CODE')<>'') then
          begin
            if not(Dm_Main.TransacCli.InTransaction) then
              Dm_Main.TransacCli.StartTransaction;

            //Traitement de la Fidélité
            StProc_Fidelite.Close;
            StProc_Fidelite.ParamByName('TKEID').AsInteger        := 0;
            StProc_Fidelite.ParamByName('CODE_POSTE').AsString    := GetValueFideliteImp('CODE_POSTE');
            StProc_Fidelite.ParamByName('CODE_SESSION').AsString  := GetValueFideliteImp('CODE_SESSION');
            StProc_Fidelite.ParamByName('NUM_TICKET').AsString    := GetValueFideliteImp('NUM_TICKET');
            StProc_Fidelite.ParamByName('POINT').AsInteger        := StrToIntDef(GetValueFideliteImp('POINT'),0);
            StProc_Fidelite.ParamByName('FIDDATE').AsDateTime     := StrToDateTime(GetValueFideliteImp('DATE'));
            StProc_Fidelite.ParamByName('MAGID').AsInteger        := iMagID;
            StProc_Fidelite.ParamByName('BACID').AsInteger        := iBacID;
            StProc_Fidelite.ParamByName('CLTID').AsInteger        := iCltID;
            StProc_Fidelite.ParamByName('MANUEL').AsInteger       := StrToIntDef(GetValueFideliteImp('MANUEL'),0);
            StProc_Fidelite.ExecQuery;

            // récupération du nouvel ID Client
            iFidID := StProc_Fidelite.FieldByName('FIDID').AsInteger;
            Dm_Main.AjoutInListeFideliteID(GetValueFideliteImp('CODE'), iFidID);

            StProc_Fidelite.Close;

            Dm_Main.TransacCli.Commit;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacCli.InTransaction) then
          Dm_Main.TransacCli.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeFideliteID;
    StProc_Fidelite.Close;
  end;
end;

function TClient.TraiterLienClientsProPart: Boolean;
var
  iCltIDPro: Integer;
  iCltIDPart: Integer;
  iPRMID: Integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Delai: DWord;
begin
  Result := true;

  iMaxProgress := cds_LienClients.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  if AvancePc>1000 then
    AvancePc := 1000;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + LienClients_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  Delai := GetTickCount;
  NbRech := Dm_Main.ListeIDLienClient.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_LienClients.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) or ((GetTickCount-Delai)>2500) then
        begin
          Synchronize(UpdProgressFrm);
          Delai := GetTickCount;
        end;

        if cds_LienClients[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_LienClients[i], LienClients_COL);

          //ID Client Pro
          iCltIDPro := Dm_Main.GetClientID(GetValueLienClientsImp('CODEPRO'));
          if iCltIDPro=-1 then
            iCltIDPro := 0;

          //ID Client Part
          iCltIDPart := Dm_Main.GetClientID(GetValueLienClientsImp('CODEPART'));
          if iCltIDPart=-1 then
            iCltIDPart := 0;

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheLienClientID(GetValueLienClientsImp('CODEPRO')+GetValueLienClientsImp('CODEPART'), NbRech);

          // création si pas déjà créé
          if (LRechID=-1)
           and (GetValueLienClientsImp('CODEPRO')<>'')
           and (GetValueLienClientsImp('CODEPART')<>'') then
          begin
            if not(Dm_Main.TransacCli.InTransaction) then
              Dm_Main.TransacCli.StartTransaction;

            //Traitement des Clients
            StProc_LienClients.Close;
            StProc_LienClients.ParamByName('CLTIDPRO').AsInteger  := iCltIDPro;
            StProc_LienClients.ParamByName('CLTIDPART').AsInteger := iCltIDPart;
            StProc_LienClients.ParamByName('DATEDEBUT').AsDate    := StrToDate(GetValueLienClientsImp('DATEDEBUT'));
            StProc_LienClients.ParamByName('DATEFIN').AsDate      := StrToDate(GetValueLienClientsImp('DATEFIN'));
            StProc_LienClients.ExecQuery;

            // récupération du nouvel ID Client
            iPRMID := StProc_LienClients.FieldByName('PRMID').AsInteger;

            Dm_Main.AjoutInListeLienClientID(GetValueLienClientsImp('CODEPRO')+GetValueLienClientsImp('CODEPART'), iPRMID);

            StProc_LienClients.Close;

            Dm_Main.TransacCli.Commit;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacCli.InTransaction) then
          Dm_Main.TransacCli.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeLienClientID;
    StProc_LienClients.Close;
  end;
end;

end.


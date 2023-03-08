unit GKEasyComptageExport.Thread.Traitement;

interface

uses
  System.Classes,
  System.Types,
  System.SysUtils,
  System.DateUtils,
  Data.DB,
  FireDAC.Comp.Client,
  UMapping,
  GKEasyComptageExport.Ressources,
  GKEasyComptageExport.Methodes;

type
  TThreadTraitement = class(TThread)
  private
    { Déclarations privées }
    FOblBoCaisse      : TOblBoCaisse;
    FDateEnCours      : TDateTime;
    FTrancheEnCours   : Integer;
    procedure Progression();
    procedure Journaliser(AMessage: String; ANiveau: TNiveau = NivDetail);
  protected
    { Déclarations protégées }
    procedure Execute(); override;
  public
    { Déclarations publiques }
    Configuration     : TConfig;
    Fichier           : TFileName;
    DateDebut         : TDateTime;
    DateFin           : TDateTime;
    EffacerDatesInf   : Boolean;
    MagId             : Integer;
    QueCodeAdherant   : ^TFDQuery;
    QueNbTickets      : ^TFDQuery;
    QueChiffreAffaire : ^TFDQuery;
    QueNbVendeurs     : ^TFDQuery;
    TraitementOk      : Boolean;
  end;

implementation

uses
  GKEasyComptageExport.Form.Main;

{ TThreadTraitement }

procedure TThreadTraitement.Execute();
var
  dDateSupp       : TDate;
  dDateLigne      : TDate;
  i               : Integer;
  LnBoCaisse      : TBoCaisse;
  sCodeAdh        : String;
  PeriodeTranche  : TPeriodeTranche;
begin
  TraitementOk := False;
  // Charge le fichier en mémoire
  FOblBoCaisse  := TOblBoCaisse.Create();
  try
    try
      if ImportBoCaisse(Fichier, FOblBoCaisse) then
      begin
        // Suppression des lignes dont la date est inférieure à la date suppérieur
        if EffacerDatesInf then
        begin
          dDateSupp := DateDebut - Configuration.Jours;

          for i := FOblBoCaisse.Count - 1 downto 0 do
          begin
            if TryIso8601BasicToDate(FOblBoCaisse[i].sDateJour, TDateTime(dDateLigne)) then
            begin
              if CompareDate(dDateLigne, dDateSupp) = LessThanValue then
                FOblBoCaisse.Delete(i);
            end;
          end;
        end;

        // Arrête le thread si annulé
        if Self.Terminated then
        begin
          TraitementOk := False;
          Exit;
        end;

        // Arrête le thread si un autre programme bloque la connexion
        if MapGinkoia.Backup
          or MapGinkoia.LiveUpdate
          or MapGinkoia.MajAuto
          or MapGinkoia.Script then
        begin
          TraitementOk := False;
          raise EErreurIBTraitement.Create(RS_ERR_TRAITEMENT);
        end;

        // Récupère le code adhérant du magasin
        try
          if QueCodeAdherant.Active then
            QueCodeAdherant.Close();
          QueCodeAdherant.ParamByName('MAGID').AsInteger  := MagId;
          QueCodeAdherant.Open();

          if not(QueCodeAdherant.IsEmpty) then
            sCodeAdh := QueCodeAdherant.FieldByName('MAG_CODEADH').AsString
          else begin
            TraitementOk := False;
            raise EErreurIBTraitement.Create(RS_ERR_REQUETE_CODEADH);
          end;
        finally
          QueCodeAdherant.Close();
        end;

        // Arrête le thread si annulé
        if Self.Terminated then
        begin
          TraitementOk := False;
          Exit;
        end;

        // Arrête le thread si un autre programme bloque la connexion
        if MapGinkoia.Backup
          or MapGinkoia.LiveUpdate
          or MapGinkoia.MajAuto
          or MapGinkoia.Script then
        begin
          TraitementOk := False;
          raise EErreurIBTraitement.Create(RS_ERR_TRAITEMENT);
        end;

        // Récupère toute les lignes de comptage depuis DateDebut
        FDateEnCours  := DateDebut;
        TraitementOk  := True;

        while (CompareDateTime(FDateEnCours, DateFin) <= EqualsValue)
          and TraitementOk do
        begin
          LnBoCaisse      := TBoCaisse.Create();
          FTrancheEnCours := CalculTranche(FDateEnCours);
          PeriodeTranche  := CalculPeriode(FDateEnCours, FTrancheEnCours);

          // Met à jour la progression
          Progression();

          // Ajout la nouvelle ligne
          // Initialise les valeurs de base
          LnBoCaisse.sCodePDV   := sCodeAdh;
          LnBoCaisse.sDateJour  := FormatDateTime('YYYYMMDD', FDateEnCours);
          LnBoCaisse.iNTranche  := FTrancheEnCours;

          // Récupère le nombre de ticket sur la période
          try
            if QueNbTickets.Active then
              QueNbTickets.Close();

            QueNbTickets.ParamByName('MAGID').AsInteger   := MagId;
            QueNbTickets.ParamByName('DEBUT').AsDateTime  := PeriodeTranche.dDateDebut;
            QueNbTickets.ParamByName('FIN').AsDateTime    := PeriodeTranche.dDateFin;
            QueNbTickets.Open();

            LnBoCaisse.iNbTickets  := QueNbTickets.FieldByName('RESULTAT').AsInteger;
          finally
            QueNbTickets.Close();
          end;

          // Arrête le thread si annulé
          if Self.Terminated then
          begin
            TraitementOk := False;
            Exit;
          end;

          // Arrête le thread si un autre programme bloque la connexion
          if MapGinkoia.Backup
            or MapGinkoia.LiveUpdate
            or MapGinkoia.MajAuto
            or MapGinkoia.Script then
          begin
            TraitementOk := False;
            raise EErreurIBTraitement.Create(RS_ERR_TRAITEMENT);
          end;

          // Récupère le CA, sans les bons d'achat, sur la période
          try
            if QueChiffreAffaire.Active then
              QueChiffreAffaire.Close();

            QueChiffreAffaire.ParamByName('MAGID').AsInteger   := MagId;
            QueChiffreAffaire.ParamByName('DEBUT').AsDateTime  := PeriodeTranche.dDateDebut;
            QueChiffreAffaire.ParamByName('FIN').AsDateTime    := PeriodeTranche.dDateFin;
            QueChiffreAffaire.Open();

            if not(QueChiffreAffaire.FieldByName('RESULTAT').IsNull) then
              LnBoCaisse.fCA := QueChiffreAffaire.FieldByName('RESULTAT').AsCurrency
            else
              LnBoCaisse.fCA := 0;
          finally
            QueChiffreAffaire.Close();
          end;

          // Arrête le thread si annulé
          if Self.Terminated then
          begin
            TraitementOk := False;
            Exit;
          end;

          // Arrête le thread si un autre programme bloque la connexion
          if MapGinkoia.Backup
            or MapGinkoia.LiveUpdate
            or MapGinkoia.MajAuto
            or MapGinkoia.Script then
          begin
            TraitementOk := False;
            raise EErreurIBTraitement.Create(RS_ERR_TRAITEMENT);
          end;

          // Récupère le nombre de vendeur
          try
            if QueNbVendeurs.Active then
              QueNbVendeurs.Close();

            QueNbVendeurs.ParamByName('MAGID').AsInteger   := MagId;
            QueNbVendeurs.ParamByName('DEBUT').AsDateTime  := PeriodeTranche.dDateDebut;
            QueNbVendeurs.ParamByName('FIN').AsDateTime    := PeriodeTranche.dDateFin;
            QueNbVendeurs.Open();

            LnBoCaisse.iNbVendeur := QueNbVendeurs.FieldByName('RESULTAT').AsInteger;
          finally
            QueNbVendeurs.Close();
          end;

          // Arrête le thread si annulé
          if Self.Terminated then
          begin
            TraitementOk := False;
            Exit;
          end;

          // Arrête le thread si un autre programme bloque la connexion
          if MapGinkoia.Backup
            or MapGinkoia.LiveUpdate
            or MapGinkoia.MajAuto
            or MapGinkoia.Script then
          begin
            TraitementOk := False;
            raise EErreurIBTraitement.Create(RS_ERR_TRAITEMENT);
          end;

          FOblBoCaisse.Add(LnBoCaisse);

          // Enregistre le fichier
          TraitementOk := ExportBoCaisse(Fichier, FOblBoCaisse)
            and ImportBoCaisse(Fichier, FOblBoCaisse);

          if TraitementOk then
          begin
            GCONFIGAPP.dPrevAction := IncMinute(FDateEnCours, 30);

            // Enregistre les nouvelles dates dans le fichier INI
            EnregistreFichierIni();
          end;

          FDateEnCours  := IncMinute(FDateEnCours, 15);
        end;
      end;
    except
      on E: Exception do
        Journaliser(Format('Erreur'#160': %s - %s.', [E.ClassName, E.Message]));
    end;
  finally
    FreeAndNil(FOblBoCaisse);
  end;
end;

procedure TThreadTraitement.Progression();
begin
  Journaliser(Format(RS_INFO_TRAITEMENT,
                [FormatDateTime('DD/MM/YYYY hh:mm:ss', DateDebut),
                  FormatDateTime('DD/MM/YYYY hh:mm:ss', DateFin),
                  FormatDateTime('DD/MM/YYYY hh:mm:ss', FDateEnCours),
                  FTrancheEnCours]));

  // Envoi un message à la form principale
  Synchronize(
    procedure
    begin
      FormMain.StbStatut.Panels[0].Text := Format(RS_INFO_TRAITEMENT,
        [FormatDateTime('DD/MM/YYYY hh:mm:ss', DateDebut),
          FormatDateTime('DD/MM/YYYY hh:mm:ss', DateFin),
          FormatDateTime('DD/MM/YYYY hh:mm:ss', FDateEnCours),
          FTrancheEnCours]);
    end
  );
end;

procedure TThreadTraitement.Journaliser(AMessage: String; ANiveau: TNiveau = NivDetail);
begin
  // Envoi un message au journal de l'application
  Synchronize(procedure
  begin
    FormMain.Journaliser(AMessage, ANiveau);
  end);
end;

end.

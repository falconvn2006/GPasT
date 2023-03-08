unit MigrationReferentiel.Thread.Extraction;

interface

uses
  System.Classes,
  System.SysUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  Data.DB,
  MigrationReferentiel.Ressources;

type
  TThreadExtraction = class(TCustomMigrationThread)
  strict private
    { Déclarations strictement privées }
    // Extrait le TFDQuery dans un fichier CSV
    procedure ExportDataSetToDVS(ADataSet: TFDQuery; const AFichier: TFileName);
  protected
    { Déclarations protégées }
    procedure Execute(); override;
  public
    { Déclarations publiques }
    Fichier        : TFileName;
    TypeReferentiel: TTypeReferentiel;
    constructor Create(CreateSuspended: Boolean); override;
  end;

implementation

{ TThreadExtraction }

constructor TThreadExtraction.Create(CreateSuspended: Boolean);
begin
  inherited;

  // Initialise le message d'erreur
  FErreur    := False;
  FMsgErreur := '';

  // Créer les composants pour les requêtes SQL
  FDConnection                        := TFDConnection.Create(nil);
  FDConnection.UpdateOptions.ReadOnly := True;
  FDQuery                             := TFDQuery.Create(nil);
  FDQuery.Connection                  := FDConnection;
  FDQuery.UpdateOptions.ReadOnly      := True;
end;

procedure TThreadExtraction.Execute();
begin
  try
    // Initialise le message d'erreur
    FErreur    := False;
    FMsgErreur := '';

{$REGION 'Paramètrage de la connexion'}
    Progression(RS_MSG_PARAM_CONNECT);
    Journaliser(Format(RS_MSG_PARAM_CONNECT_PARAMS, [Serveur, Port, BaseDonnees, Utilisateur, MotPasse]));

    if (Serveur = '') or (BaseDonnees = '') then
      raise EBaseDonnees.Create(RS_ERREUR_BASEDONNEES);

    FDConnection.Params.Clear();
    FDConnection.Params.Values['DriverID']  := 'IB';
    FDConnection.Params.Values['Protocol']  := 'TCPIP';
    FDConnection.Params.Values['User_Name'] := Utilisateur;
    FDConnection.Params.Values['Password']  := MotPasse;
    FDConnection.Params.Values['Server']    := Serveur;
    FDConnection.Params.Values['Port']      := IntToStr(Port);
    FDConnection.Params.Values['Database']  := BaseDonnees;

    FDQuery.Connection        := FDConnection;
    FDQuery.FetchOptions.Mode := fmAll;
{$ENDREGION 'Paramètrage de la connexion'}
    if Terminated then
      Exit;

{$REGION 'Extraction du fichier'}
    Progression(RS_MSG_EXTRACTION);
    Journaliser(Format(RS_MSG_EXTRACTION_NOM, [Fichier]));

    try
      FDQuery.SQL.Clear();
      case TypeReferentiel of
        trMarques:
          begin
            FDQuery.SQL.Add('SELECT DISTINCT MRK_CODE, MRK_NOM');
            FDQuery.SQL.Add('FROM ARTMARQUE');
            FDQuery.SQL.Add('  JOIN K ON (K_ID = MRK_ID AND K_ENABLED = 1 AND K_ID != 0)');
            FDQuery.SQL.Add('ORDER BY MRK_NOM;');
          end;
        trFournisseurs:
          begin
            FDQuery.SQL.Add('SELECT DISTINCT FOU_CODE, FOU_NOM');
            FDQuery.SQL.Add('FROM ARTFOURN');
            FDQuery.SQL.Add('  JOIN K ON (K_ID = FOU_ID AND K_ENABLED = 1 AND FOU_ID != 0)');
            FDQuery.SQL.Add('ORDER BY FOU_NOM;');
          end;
        trNomenclature:
          begin
            FDQuery.SQL.Add('SELECT DISTINCT UNI_CODE, UNI_NOM, SEC_CODE, SEC_NOM, RAY_CODE,');
            FDQuery.SQL.Add('       RAY_NOM, FAM_CODE, FAM_NOM, SSF_CODE, SSF_NOM, SSF_CODEFINAL');
            FDQuery.SQL.Add('FROM NKLUNIVERS');
            FDQuery.SQL.Add('  JOIN K KUNI         ON (KUNI.K_ID = UNI_ID AND KUNI.K_ENABLED = 1 AND KUNI.K_ID != 0)');
            FDQuery.SQL.Add('  JOIN NKLSECTEUR     ON (SEC_UNIID = UNI_ID)');
            FDQuery.SQL.Add('  JOIN K KSEC         ON (KSEC.K_ID = SEC_ID AND KSEC.K_ENABLED = 1 AND KSEC.K_ID != 0)');
            FDQuery.SQL.Add('  JOIN NKLRAYON       ON (RAY_SECID = SEC_ID)');
            FDQuery.SQL.Add('  JOIN K KRAY         ON (KRAY.K_ID = RAY_ID AND KRAY.K_ENABLED = 1 AND KRAY.K_ID != 0)');
            FDQuery.SQL.Add('  JOIN NKLFAMILLE     ON (FAM_RAYID = RAY_ID)');
            FDQuery.SQL.Add('  JOIN K KFAM         ON (KFAM.K_ID = FAM_ID AND KFAM.K_ENABLED = 1 AND KFAM.K_ID != 0)');
            FDQuery.SQL.Add('  JOIN NKLSSFAMILLE   ON (SSF_FAMID = FAM_ID)');
            FDQuery.SQL.Add('  JOIN K KSSF         ON (KSSF.K_ID = SSF_ID AND KSSF.K_ENABLED = 1 AND KSSF.K_ID != 0)');
            FDQuery.SQL.Add('ORDER BY UNI_NOM, SEC_NOM, RAY_NOM, FAM_NOM, SSF_NOM;');
          end;
      end;

      ExportDataSetToDVS(FDQuery, Fichier);

      if Terminated then
        Exit;
    finally
      FDConnection.Close();
    end;
{$ENDREGION 'Extraction du fichier'}
  except
    on E: Exception do
    begin
      FErreur    := True;
      FMsgErreur := Format('%s'#160': %s.', [E.ClassName, E.Message]);
      Journaliser(RS_ERREUR_EXTRACTION + sLineBreak + FMsgErreur, NivArret);
    end;
  end;
end;

procedure TThreadExtraction.ExportDataSetToDVS(ADataSet: TFDQuery; const AFichier: TFileName);
var
  slLigne : TStringList;
  tfSortie: TextFile;
  i       : Integer;
begin
  // Charge le fichier à enregistrer
  AssignFile(tfSortie, AFichier);

{$I-} // Évite les exceptions pour l'édition du fichier
  Rewrite(tfSortie);
{$I+}
  try
    // Ouvre la requête si elle est fermée
    if not(ADataSet.Active) then
      ADataSet.Open();

    if Terminated then
      Exit;

    Progression(RS_MSG_EXTRACTION, 0, ADataSet.RecordCount);
    Journaliser(Format(RS_MSG_ENR_FICHIER, [AFichier]));

    // Va au premier enregistrement
    ADataSet.First();

    if Terminated then
      Exit;

    // Créer la liste des valeurs
    slLigne                 := TStringList.Create();
    slLigne.Delimiter       := ';';
    slLigne.QuoteChar       := '''';
    slLigne.StrictDelimiter := True;

    // Enregistre les noms des champs
    slLigne.Clear();
    for i := 0 to ADataSet.Fields.Count - 1 do
      slLigne.Add(AnsiQuotedStr(ADataSet.Fields[i].FieldName, '"'));
    Writeln(tfSortie, slLigne.DelimitedText);

    if Terminated then
      Exit;

    // Enregistre les valeurs
    while not(ADataSet.Eof) do
    begin
      Progression(Format(RS_MSG_EXTRACTION_NB, [ADataSet.RecNo, ADataSet.RecordCount]), ADataSet.RecNo);

      slLigne.Clear();

      for i := 0 to ADataSet.Fields.Count - 1 do
      begin
        if ADataSet.Fields[i].DataType = ftString then
          slLigne.Add(AnsiQuotedStr(ADataSet.Fields[i].AsString, '"'))
        else
          slLigne.Add(ADataSet.Fields[i].AsString);
      end;

      Writeln(tfSortie, slLigne.DelimitedText);

      ADataSet.Next();

      if Terminated then
        Exit;
    end;
  finally
    // Ferme le fichier enregistré
    CloseFile(tfSortie);

    FreeAndNil(slLigne);
  end;
end;

end.

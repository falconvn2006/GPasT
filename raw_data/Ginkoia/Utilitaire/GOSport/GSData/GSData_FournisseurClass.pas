unit GSData_FournisseurClass;

interface

uses GSData_MainClass, GSData_TErreur, GSData_Types, GSDataImport_DM, StrUtils,
     DBClient, SysUtils, IBODataset, Db, Variants, Classes;

type
  TFournisseurClass = class(TMainClass)
  private
    FFileImport : String;
  public
    procedure import;override;
    function DoMajTable : Boolean;override;

     // Permet de récupérer l'id d'un code
    function GetIdByCode(ACode : String ; ACenCode : Integer) : Integer;override;

    constructor Create;override;
    destructor Destroy;override;

  end;


implementation

{ TFournisseurClass }

constructor TFournisseurClass.Create;
begin
  inherited;

end;


destructor TFournisseurClass.Destroy;
begin

  inherited;
end;

function TFournisseurClass.DoMajTable: Boolean;
var
    Erreur : TErreur;
begin
  // Intégration des données fournisseur
  FIboQuery.Close;
  FIboQuery.SQL.Clear;
  FIboQuery.SQL.Add('Select * from GOS_SETARTFOURN(:PFOUCODE, :PFOUNOM, :PFOUTYPE, :PFOUGROS,');
  FIboQuery.SQL.Add(' :PFOUCENTRALE, :PFOUACTIVE, :PFOUIDREF, :PPAYNOM, :PVILNOM, :PVILCP,');
  FIboQuery.SQL.Add(' :PADRLIGNE, :PADRTEL, :PADRFAX, :PADREMAIL)');

  Fcds.First;
  LabCaption('Intégration des données fournisseur');
  while not Fcds.EOF do
  begin
    With FIboQuery do
    Try
      IB_Transaction.StartTransaction;
      Close;
      ParamCheck := True;
      ParamByName('PFOUCODE').AsString      := FCds.FieldByName('FOU_CODE').AsString;
      ParamByName('PFOUNOM').AsString       := FCds.FieldByName('FOU_NOM').AsString;
      ParamByName('PFOUTYPE').AsInteger     := FCds.FieldByName('FOU_TYPE').AsInteger;
      ParamByName('PFOUGROS').AsInteger     := FCds.FieldByName('FOU_GROS').AsInteger;
      ParamByName('PFOUCENTRALE').AsInteger := FCds.FieldByName('FOU_CENTRALE').AsInteger;
      ParamByName('PFOUACTIVE').AsInteger   := FCds.FieldByName('FOU_ACTIVE').AsInteger;
      ParamByName('PFOUIDREF').AsInteger    := FCds.FieldByName('FOU_IDREF').AsInteger;
      ParamByName('PPAYNOM').AsString       := Fcds.FieldByName('PAY_NOM').AsString;
      ParamByName('PVILNOM').AsString       := Fcds.FieldByName('VIL_NOM').AsString;
      ParamByName('PVILCP').AsString        := FCds.FieldByName('VIL_CP').AsString;
      ParamByName('PADRLIGNE').AsString     := FCds.FieldByName('ADR_LIGNE').AsString;
      ParamByName('PADRTEL').AsString       := FCds.FieldByName('ADR_TEL').AsString;
      ParamByName('PADRFAX').AsString       := Fcds.FieldByName('ADR_FAX').AsString;
      ParamByName('PADREMAIL').AsString     := Fcds.FieldByName('ADR_EMAIL').AsString;
      Open;

      if RecordCount > 0 then
      begin
        Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,FieldByName('FMAJ').AsInteger);

        FCds.Edit;
        FCds.FieldByName('FOU_ID').AsInteger := FieldByName('FOU_ID').AsInteger;
        Fcds.Post;
      end;
      IB_Transaction.Commit;
    Except on E:Exception do
      begin
        IB_Transaction.Rollback;
        Erreur := TErreur.Create;
        Erreur.AddError(FFileImport,'Intégration',E.Message,0,teFournisseur,0,'');
        GERREURS.Add(Erreur);
        IncError;
      end;
    end;
    Fcds.Next;
    BarPosition(FCds.RecNo * 100 Div FCds.RecordCount);
  end;
end;

function TFournisseurClass.GetIdByCode(ACode: String ; ACenCode : Integer): Integer;
begin
  if FCds.Active and FCds.Locate('FOU_CODE',ACode,[loCaseInsensitive]) then
    Result := FCds.FieldByName('FOU_ID').AsInteger
  else begin
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select FOU_ID From ARTFOURN');
      SQL.Add('  join K on K_ID = FOU_ID and K_Enabled = 1');
      SQL.Add('Where FOU_CODE = :PFOUCODE');
      ParamCheck := True;
      ParamByName('PFOUCODE').AsString := ACode;
      Open;

      if RecordCount > 0 then
        Result := fieldByName('FOU_ID').AsInteger
      else
        Result := 0;
    end;
  end;

  if Result <= 0 then
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from GOS_SETARTFOURN(:PFOUCODE, :PFOUNOM, :PFOUTYPE, :PFOUGROS,');
      SQL.Add(' :PFOUCENTRALE, :PFOUACTIVE, :PFOUIDREF, :PPAYNOM, :PVILNOM, :PVILCP,');
      SQL.Add(' :PADRLIGNE, :PADRTEL, :PADRFAX, :PADREMAIL)');
      ParamCheck := True;
      ParamByName('PFOUCODE').AsString      := FCds.FieldByName('FOU_CODE').AsString;
      ParamByName('PFOUNOM').AsString       := FCds.FieldByName('FOU_NOM').AsString;
      ParamByName('PFOUTYPE').AsInteger     := FCds.FieldByName('FOU_TYPE').AsInteger;
      ParamByName('PFOUGROS').AsInteger     := FCds.FieldByName('FOU_GROS').AsInteger;
      ParamByName('PFOUCENTRALE').AsInteger := FCds.FieldByName('FOU_CENTRALE').AsInteger;
      ParamByName('PFOUACTIVE').AsInteger   := FCds.FieldByName('FOU_ACTIVE').AsInteger;
      ParamByName('PFOUIDREF').AsInteger    := FCds.FieldByName('FOU_IDREF').AsInteger;
      ParamByName('PPAYNOM').AsString       := Fcds.FieldByName('PAY_NOM').AsString;
      ParamByName('PVILNOM').AsString       := Fcds.FieldByName('VIL_NOM').AsString;
      ParamByName('PVILCP').AsString        := FCds.FieldByName('VIL_CP').AsString;
      ParamByName('PADRLIGNE').AsString     := FCds.FieldByName('ADR_LIGNE').AsString;
      ParamByName('PADRTEL').AsString       := FCds.FieldByName('ADR_TEL').AsString;
      ParamByName('PADRFAX').AsString       := Fcds.FieldByName('ADR_FAX').AsString;
      ParamByName('PADREMAIL').AsString     := Fcds.FieldByName('ADR_EMAIL').AsString;
      Open;

      if Recordcount > 0 then
      begin
        FCds.Edit;
        FCds.FieldByName('FOU_ID').AsInteger := FieldByName('FOU_ID').AsInteger;
        Fcds.Post;

        Result := FieldByName('FOU_ID').AsInteger;
      end
      else
        raise Exception.Create(Format('Aucun fournisseur trouvé pour le code %s',[ACode]));
    end;
end;




procedure TFournisseurClass.import;
var
  Erreur : TErreur;
  i : Integer;
  sPrefixe : String;
  iCentrale : Integer ;
begin
  case FMagType of
    mtCourir :    iCentrale := CTE_COURIR ;
    mtGoSport :   iCentrale := CTE_GOSPORT ;
  end;
  // Récupération du nom de fichier
  for i := Low(FilesPath) to High(FilesPath) do
  begin
    sPrefixe := Copy(FilesPath[i],1,6);
    case AnsiIndexStr(UpperCase(sPrefixe),['ADRFRN']) of
      0: FFileImport := FilesPath[i];
    end;
  end;

  // Création des champs du dataset en mémoire
  CreateField(['FOU_ID','FOU_NOM','FOU_GROS','FOU_CODE', 'FOU_TYPE', 'VIL_NOM','VIL_CP', 'ADR_LIGNE',
               'FOU_CENTRALE','FOU_ACTIVE', 'FOU_IDREF', 'PAY_NOM', 'ADR_TEL', 'ADR_FAX', 'ADR_EMAIL'],
              [ftInteger, ftString, ftInteger, ftString, ftInteger, ftString, ftString, ftString,
               ftInteger, ftInteger, ftInteger, ftString, ftString, ftString, ftString]);
  ClientDataset.AddIndex('Idx','FOU_CODE',[]);
  ClientDataset.IndexName := 'Idx';


   LabCaption('Importation du fichier ' + FFileImport);
  // Importation des données dans le Cds
  With DM_GSDataImport.cds_ADRFRN do
  begin
    FCount := Recordcount;

    First;
    while not EOF do
    begin
      try
        FCds.Append;
        FCds.FieldByName('FOU_ID').AsInteger       := -1;
        FCds.FieldByName('FOU_NOM').AsString       := FieldByName('02_LIBELLE').AsString;
        FCds.FieldByName('FOU_GROS').AsInteger     := 1;
        FCds.FieldByName('FOU_CODE').AsString      := FieldByName('01_CODE_SITE').AsString;
        FCds.FieldByName('VIL_NOM').AsString       := FieldByName('10_VILLE').AsString;
        FCds.FieldByName('VIL_CP').AsString        := FieldByName('09_CODE_POSTAL').AsString;
        FCds.FieldByName('ADR_LIGNE').AsString     := Trim(Format('%s %s %s %s',[FieldByName('07_NUM_RUE').AsString,
                                                                                 FieldByName('08_RUE').AsString,
                                                                                 FieldByName('05_INFO_ADR1').AsString,
                                                                                 FieldByName('06_INFO_ADR2').AsString]));
        FCds.FieldByName('FOU_CENTRALE').AsInteger := iCentrale ;
        if assigned(FieldByName('11_ACTIF')) and (FieldByName('11_ACTIF').AsString = '0') then
        begin                                              // On test pour voir si c'est à '0', car si ce champ n'est pas
          FCds.FieldByName('FOU_ACTIVE').AsInteger   := 0; // présent dans le fichier (ex: mags GoSport), la valeur est vide.
          FCds.FieldByName('FOU_IDREF').AsInteger    := 0; // Dans ce cas là on laisse activé.
        end
        else
        begin
          FCds.FieldByName('FOU_ACTIVE').AsInteger   := 1;
          FCds.FieldByName('FOU_IDREF').AsInteger    := 1;
        end;
        FCds.FieldByName('PAY_NOM').AsString       := 'FRANCE';
        FCds.FieldByName('ADR_TEL').AsString       := '';
        FCds.FieldByName('ADR_FAX').AsString       := '';
        FCds.FieldByName('ADR_EMAIL').AsString     := '';

        {$REGION 'fonctionnement du FOU_TYPE'}
          // Si le (03) Type de site = E mettre  2
          // Si le (03) Type de site = M alors :
          // -	Si (04) Type magasin = X Mettre 3
          // -	Sinon Mettre 4
        {$ENDREGION}
        if Trim(FieldbyName('03_TYPE_SITE').AsString) = 'E' then
          FCds.FieldByName('FOU_TYPE').AsInteger := 2
        else
          if Trim(FieldbyName('04_TYPE_MAGASIN').AsString) = 'X' then
            FCds.FieldByName('FOU_TYPE').AsInteger := 4
          else
            FCds.FieldByName('FOU_TYPE').AsInteger := 3;
        Fcds.Post;
      Except on E:Exception do
        begin
          FCds.Cancel;
          Erreur := TErreur.Create;
          Erreur.AddError(FFileImport,'Importation',E.Message,RecNo,teFournisseur,0,'');
          GERREURS.Add(Erreur);
          IncError;
        end;
      end;
      Next;
      BarPosition(RecNo * 100 Div Recordcount);
    end;
  end;
end;

end.

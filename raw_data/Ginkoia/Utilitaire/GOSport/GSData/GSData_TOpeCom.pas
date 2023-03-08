unit GSData_TOpeCom;

interface

uses GSData_MainClass, GSData_TErreur, GSData_Types, GSDataImport_DM, StrUtils,
     DBClient, SysUtils, IBODataset, Db, Variants, DateUtils, Types;

type
  TOpeCom = class(TMainClass)
    private
      FOpeCom      : TMainClass;
      FOPECOM_File : String;
      FQueOpeCom: TIBOQuery;

      function  IndiqueIdTypeCDV : Integer;

      function  DB_MAJ_OpeCom : Boolean;
    public
      procedure Import; override;
      function  DoMajTable : Boolean; override;

      function GetIdByCode (ACode : string ; ACenCode : Integer) : Integer;override;

      Constructor Create; override;
      Destructor  Destroy; override;
    published
      property Que_OpeCom : TIBOQuery read FQueOpeCom write FQueOpeCom;

      property OpeCom : TMainClass read FOpeCom write FOpeCom;
  end;


implementation

Constructor TOpeCom.Create;
begin
  Inherited;

  FOpeCom := TMainClass.Create;
end;

Destructor TOpeCom.Destroy;
begin
  FOpeCom.Free;

  Inherited;
end;


//------------------------------------------------------------------------------
//                                                                 +-----------+
//                                                                 |   Import  |
//                                                                 +-----------+
//------------------------------------------------------------------------------

//------------------------------------------------------------------> Import

procedure TOpeCom.Import;
var
  vIx, vIdType : Integer;
  vPrefixe     : String;
  vErreur      : TErreur;
  iCentrale    : Integer ;

  {$REGION ' RenseignerOpeCom '}
  procedure RenseignerOpeCom(vpActionTable : TTypeActionTable; vpIdType, vpIdOpeCom, vpCentrale : Integer);
  begin
    with FOpeCom.ClientDataset do
    begin
      Append;

      FieldByName('OCT_ID').AsInteger       := vpIdOpeCom;
      FieldByName('OCT_NOM').AsString       := DM_GSDataImport.cds_OPECOM.FieldByName('LIBELLE').AsString;
      FieldByName('OCT_COMMENT').AsString   := '';
      FieldByName('OCT_DEBUT').AsDateTime   := DM_GSDataImport.cds_OPECOM.FieldByName('DATE_DEBUT').AsDateTime;
      FieldByName('OCT_FIN').AsDateTime     := DM_GSDataImport.cds_OPECOM.FieldByName('DATE_FIN').AsDateTime;
      FieldByName('OCT_TYPID').AsInteger    := vpIdType;

      if not DM_GSDataImport.cds_OPECOM.FieldByName('TYPE_OC').IsNull then
        FieldByName('OCT_WEB').AsInteger    := DM_GSDataImport.cds_OPECOM.FieldByName('TYPE_OC').AsInteger
      else
        FieldByName('OCT_WEB').AsInteger    := 0;

      FieldByName('OCT_CENTRALE').AsInteger := vpCentrale ;
      FieldByName('OCT_CODE').AsString      := DM_GSDataImport.cds_OPECOM.FieldByName('CODE_OPERATION').AsString;
      FieldByName('OCT_TYPEPRIX').AsInteger := 0;
      FieldByName('ACTIONTABLE').AsInteger  := Ord(vpActionTable);

      Post;
    end;
  end;
  {$ENDREGION 'RenseignerOpeCom'}
begin

  case FMagType of
    mtCourir:   iCentrale := CTE_COURIR ;
    mtGoSport:  iCentrale := CTE_GOSPORT ;
  end;

  // Mise du nom de fichier en variable générale
  for vIx := Low(FilesPath) to High(FilesPath) do
  begin
    vPrefixe := Copy(FilesPath[vIx],1,6);
    case AnsiIndexStr(UpperCase(vPrefixe),['OPECOM']) of
      0 : FOPECOM_File := FilesPath[vIx];
    end;
  end;

  // Initialisation des CDS et des tables
  // Création du CDS OpeCom (venant du fichier) en mémoire
  FOpeCom.CreateField(['OCT_ID','OCT_NOM','OCT_COMMENT','OCT_DEBUT','OCT_FIN','OCT_TYPID',
                       'OCT_WEB','OCT_CENTRALE','OCT_CODE', 'OCT_TYPEPRIX', 'ACTIONTABLE'],
                       [ftInteger, ftString, ftString, ftDate, ftDate, ftInteger,
                        ftInteger, ftInteger, ftString, ftInteger, ftInteger]);
  FOpeCom.ClientDataset.AddIndex('Idx','OCT_CODE',[]);
  FOpeCom.ClientDataset.IndexName := 'Idx';

  FQueOpeCom.Close;
  FQueOpeCom.Open;

  {$REGION ' Initialisation du type '}
  // on récupère l'Id du type CDV
  vIdType := IndiqueIdTypeCDV;

  // Si l'Id n'est pas correcte, on sort
  if vIdType <= 0 then
  begin
    {$REGION ' Gestion des erreurs '}
    with FOpeCOM.ClientDataset do
    begin
      vErreur := TErreur.Create;
      vErreur.AddError(FOPECOM_File, 'OpéCom',
                       'Import échoué : Impossible de trouver l''ID du type.',
                       0, teOpeCom, 0,'');
      GErreurs.Add(vErreur);
      IncError ;
    end;
    {$ENDREGION 'Gestion des erreurs'}

    Exit;
  end;
  {$ENDREGION ' Initialisation du type '}

  // Recopie dans FOpeCom depuis le fichier
  with DM_GSDataImport.cds_OPECOM do
  begin
    FCount := RecordCount;

    First;

    LabCaption('Importation du fichier ' + FOPECOM_File);
    BarPosition(0);

    while not Eof do
    begin
      // est ce que l'OpeCom existe déjà ?
      if not FQueOpeCom.Locate('OCT_CODE', DM_GSDataImport.cds_OPECOM.FieldByName('CODE_OPERATION').AsString, [loCaseInsensitive]) then
        RenseignerOpeCom(ttatInsert, vIdType, 0, iCentrale)
      else
        // Vérification que les données n'ont pas changé.
        if (Trim(Uppercase(FQueOpeCom.FieldByName('OCT_NOM').AsString)) = Trim(Uppercase(DM_GSDataImport.cds_OPECOM.FieldByName('LIBELLE').AsString))) or
           (CompareDate(FQueOpeCom.FieldByName('OCT_DEBUT').AsDateTime,DM_GSDataImport.cds_OPECOM.FieldByName('DATE_DEBUT').AsDateTime) <> EqualsValue) or
           (CompareDate(FQueOpeCom.FieldByName('OCT_FIN').AsDateTime,DM_GSDataImport.cds_OPECOM.FieldByName('DATE_FIN').AsDateTime) <> EqualsValue) then
          RenseignerOpeCom(ttatUpdate, vIdType, FQueOpeCom.FieldByName('OCT_ID').AsInteger, iCentrale)
        else
          RenseignerOpeCom(ttatNull, vIdType, FQueOpeCom.FieldByName('OCT_ID').AsInteger, iCentrale);

      Next;
      BarPosition(RecNo * 100 Div RecordCount);
    end;
  end;
end;

//------------------------------------------------------------------------------
//                                                        +--------------------+
//                                                        |   Test d'unicité   |
//                                                        +--------------------+
//------------------------------------------------------------------------------

//--------------------------------------------------------> IndiqueIdTypeCDV

function TOpeCom.IndiqueIdTypeCDV : Integer;
begin
  Result := 0;

  with FIboQuery do
  begin
    SQL.Clear;

    try
      SQL.Add(' select TYP_ID');
      SQL.Add(' from GENTYPCDV ');
      SQL.Add(' where TYP_COD = 3');
      SQL.Add(' and   TYP_CATEG = 5');

      Open;

      if not IsEmpty then
        Result := FieldByName('TYP_ID').AsInteger;

      Close;
    except
      Result := -1;
    end;
  end;
end;

//------------------------------------------------------------------------------
//                                                              +--------------+
//                                                              |  DoMajTable  |
//                                                              +--------------+
//------------------------------------------------------------------------------

//--------------------------------------------------------------> DoMajTable

function TOpeCom.DoMajTable : Boolean;
begin
  with FOpeCom.ClientDataset do
  begin
    try
      First;

      LabCaption('Création/Mise à jour des opérations commerciales');
      BarPosition(0);

      while not EOF do
      begin
        // on enregistre en table
        DB_MAJ_OpeCom;

        Next;
        BarPosition(RecNo * 100 Div RecordCount);
      end;

    except on E:Exception do
      raise Exception.Create('TOpeCom -> ' + E.Message);
    end;
  end;
end;


function TOpeCom.GetIdByCode(ACode: string ; ACenCode : Integer): Integer;
begin
  if not FOpeCOM.ClientDataset.Active or not FOpeCOM.ClientDataset.Locate('OCT_CODE',ACode,[loCaseInsensitive]) then
  begin
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select OCT_ID FROM OCTETE');
      SQL.Add('  Join K on K_ID = OCT_ID and K_Enabled = 1');
      SQL.Add('Where OCT_CODE = :PCODE');
      SQL.Add('  and OCT_CENTRALE = :CENCODE');
      ParamCheck := True;
      ParamByName('PCODE').AsString := ACode;
      ParamByName('CENCODE').AsInteger :=ACenCode ;
      Open;

      if not IsEmpty then
        Result := FieldByName('OCT_ID').AsInteger
      else
        raise Exception.Create('Pas d''offre commerciale disponible pour le code ' + ACode);
    end;
  end
  else
    Result := FOpeCom.FieldByName('OCT_ID').AsInteger;
end;

//------------------------------------------------------------------------------
//                                                          +------------------+
//                                                          |   Action table   |
//                                                          +------------------+
//------------------------------------------------------------------------------

//-----------------------------------------------------------> DB_MAJ_OpeCom

function TOpeCom.DB_MAJ_OpeCom : Boolean;
var
  vErreur : TErreur;
begin
  with FIboQuery do
  begin
    IB_Transaction.StartTransaction;
    Close;
    SQL.Clear;

    try
      // Execution de la proc stockée et récupération de l'IdOpeCom crée si on insert
      if TTypeActionTable(FOpeCOM.FieldByName('ACTIONTABLE').AsInteger) in [ttatInsert, ttatUpdate] then
      begin
        SQL.Add(' select * ');

        if FBaseVersion = 1
          then SQL.Add(' from GOS_MAJOPECOM(:OCT_ID, :OCT_CODE, :OCT_DATEDEBUT, :OCT_DATEFIN, :OCT_NOM, :OCT_WEB, :ACTIONTABLE)');
        if FBaseVersion = 2
          then SQL.Add(' from GOS_MAJOPECOM(:OCT_ID, :OCT_CODE, :OCT_DATEDEBUT, :OCT_DATEFIN, :OCT_NOM, :OCT_WEB, :ACTIONTABLE, :CENCODE)');

        ParamCheck := True;
        ParamByName('OCT_ID').AsInteger         := FOpeCOM.FieldByName('OCT_ID').AsInteger;
        ParamByName('OCT_CODE').AsString        := FOpeCOM.FieldByName('OCT_CODE').AsString;
        ParamByName('OCT_DATEDEBUT').AsDateTime := FOpeCOM.FieldByName('OCT_DEBUT').AsDateTime;
        ParamByName('OCT_DATEFIN').AsDateTime   := FOpeCOM.FieldByName('OCT_FIN').AsDateTime;
        ParamByName('OCT_NOM').AsString         := FOpeCOM.FieldByName('OCT_NOM').AsString;
        ParamByName('OCT_WEB').AsInteger        := FOpeCOM.FieldByName('OCT_WEB').AsInteger;
        ParamByName('ACTIONTABLE').AsInteger    := FOpeCOM.FieldByName('ACTIONTABLE').AsInteger;
        if FBaseVersion = 2
          then ParamByName('CENCODE').AsInteger        := FOpeCOM.FieldByName('OCT_CENTRALE').AsInteger;

        Open;

        if not IsEmpty then
        begin
          Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
          Inc(FMajCount,  FieldByName('FMAJ').AsInteger);

          if FOpeCOM.FieldByName('ACTIONTABLE').AsInteger = 1 then
          begin
            FOpeCOM.Edit;
            FOpeCOM.FieldByName('OCT_ID').AsInteger := FieldByName('NEWID').AsInteger;
            FOpeCOM.Post;
          end;
        end;
      end;

      // Création de la liaison OC/Magasin seulement pour COURIR
  //CAF
      if MAG_MODE = mtCAF then
//        if FOpeCOM.FieldByName('OCT_CENTRALE').AsInteger = CTE_COURIR then
      begin
    //    if FOpeCom.FieldByName('ACTIONTABLE').AsInteger = 1 then
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select * from GOS_OPECOMMAG(:POCTID, :PMAGID)');
          ParamCheck := True;
          ParamByName('POCTID').AsInteger := FOpeCOM.FieldByName('OCT_ID').AsInteger;
          ParamByName('PMAGID').AsInteger := MAG_ID;
          Open;

          if not IsEmpty then
            Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        end;
      end;

      Close;

      Result := True;

      IB_Transaction.Commit;
    except on E:Exception do
      begin
       {$REGION ' Gestion des erreurs '}

        IB_Transaction.Rollback;

        Result := False;

        with FOpeCOM.ClientDataset do
        begin
          vErreur := TErreur.Create;
          vErreur.AddError(FOPECOM_File, 'OpéCom',
                           'MAJ_OpéCom échouée : CODE: ' + FieldByName('OCT_CODE').AsString,
                           RecNo, teOpeCom, 0,'');
          GErreurs.Add(vErreur);
          IncError ;
        end;
        {$ENDREGION 'Gestion des erreurs'}
      end;
    end;
  end;
end;


end.

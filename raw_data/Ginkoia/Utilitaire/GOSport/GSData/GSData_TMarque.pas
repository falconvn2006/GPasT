unit GSData_TMarque;

interface

uses GSData_MainClass, GSData_TErreur, GSData_Types, GSDataImport_DM,
     DBClient, SysUtils, IBODataset, Db, Variants, strUtils;

type
  TMarque = class(TMainClass)
    private
      FMARQUE      : TMainClass;
      FARTMRKFOURN : TMainClass;

      FMARQUE_File : String;
      FMarqueTable: TIboQuery;

      function  MarqueExisteDeja : Boolean;
      function  LibelleMarqueIdentique : Boolean;
      function  RelationExiste(vpIdMarque, vpIdFournisseur : Integer) : Boolean;
      function  FournisseurPrincipalExiste(vpIdMarque : Integer) : Boolean;

      function  DB_MAJ_Marque : Boolean;
      function  DB_Insert_RelationMarque(vpIdMarque, vpIdFournisseur,
                                         vpPrincipal : Integer; var vpIdRelation : Integer) : Boolean;

      procedure CDS_AjouterRelationMarque(vpIdRelation, vpIdMarque,
                                          vpIdFournisseur, vpPrincipal : Integer);
    public
      procedure Import; override;
      function  DoMajTable : Boolean; override;

      Constructor Create; override;
      Destructor Destroy; override;

      function GetIdByCode(ACode : String ; ACenCode : Integer) : Integer;override;
    published
      property MarqueTable : TIboQuery read FMarqueTable write FMarqueTable;
  end;


implementation

Constructor TMarque.Create;
begin
  Inherited;

  FMARQUE      := TMainClass.Create;
  FARTMRKFOURN := TMainClass.Create;
end;

Destructor TMarque.Destroy;
begin
  FMARQUE.Free;
  FARTMRKFOURN.Free;

  Inherited;
end;

//------------------------------------------------------------------------------
//                                                                 +-----------+
//                                                                 |   Import  |
//                                                                 +-----------+
//------------------------------------------------------------------------------

//------------------------------------------------------------------> Import

procedure TMarque.Import;
  procedure RenseignerMarque(vpActionTable : TTypeActionTable; vpIdMarque : Integer);
  begin
    with FMARQUE.ClientDataset do
    begin
      Append;

      FieldByName('MRK_ID').AsInteger       := vpIdMarque;
      FieldByName('MRK_NOM').AsString       := DM_GSDataImport.cds_MARQUE.FieldByName('LIBELLE_MARQUE').AsString;
      FieldByName('MRK_IDREF').AsInteger    := 0;
      FieldByName('MRK_CONDITION').AsString := '';
      FieldByName('MRK_CODE').AsString      := DM_GSDataImport.cds_MARQUE.FieldByName('CODE_MARQUE').AsString;
      FieldByName('MRK_ACTIVE').AsInteger   := 1;
      FieldByName('MRK_PROPRE').AsInteger   := 0;
      case FMagType of
        mtCourir:  FieldByName('MRK_CENTRALE').AsInteger := CTE_COURIR ;
        mtGoSport: FieldByName('MRK_CENTRALE').AsInteger := CTE_GOSPORT ;
      end;
      FieldByName('ACTIONTABLE').AsInteger  := Ord(vpActionTable);

      Post;
    end;
  end;
var
  vIx      : Integer;
  vPrefixe : String;
begin

  {$REGION 'Mise du nom de fichier en variable générale'}
  for vIx := Low(FilesPath) to High(FilesPath) do
  begin
    vPrefixe := Copy(FilesPath[vIx],1,6);
    case AnsiIndexStr(UpperCase(vPrefixe),['MARQUE']) of
      0 : FMARQUE_File := FilesPath[vIx];
    end;
  end;
  {$ENDREGION 'Mise du nom de fichier en variable générale'}

  {$REGION 'Initialisation des CDS'}
  // Création du CDS Marque (venant du fichier) en mémoire
  FMARQUE.CreateField(['MRK_ID','MRK_NOM','MRK_IDREF','MRK_CONDITION','MRK_CODE',
                       'MRK_ACTIVE','MRK_PROPRE','MRK_CENTRALE','ACTIONTABLE'],
                       [ftInteger, ftString, ftInteger, ftString, ftString,
                        ftInteger, ftInteger, ftInteger, ftInteger]);
  FMARQUE.ClientDataset.AddIndex('Idx','MRK_CODE',[]);
  FMARQUE.ClientDataset.IndexName := 'Idx';

  // Création du CDS ArtMrkFourn (depuis Ginkoia) en mémoire
  FARTMRKFOURN.CreateField(['FMK_ID','FMK_MRKID','FMK_FOUID','FMK_PRIN'],
                          [ftInteger, ftInteger, ftInteger, ftInteger]);
  FARTMRKFOURN.ClientDataset.AddIndex('Idx','FMK_MRKID',[]);
  FARTMRKFOURN.ClientDataset.IndexName := 'Idx';

  {$ENDREGION 'Initialisation des CDS'}

  FMarqueTable.Close;
  FMarqueTable.Open;

  {$REGION 'Recopie dans FMARQUE depuis le fichier'}
  with DM_GSDataImport.cds_MARQUE do
  begin
    FCount := Recordcount;

    First;

    LabCaption('Importation du fichier ' + FMARQUE_File);
    BarPosition(0);

    while not Eof do
    begin
      if not MarqueExisteDeja then
        RenseignerMarque(ttatInsert, 0)
      else
        if not LibelleMarqueIdentique then
          RenseignerMarque(ttatUpdate, FMarqueTable.FieldByName('MRK_ID').AsInteger);

      Next;
      BarPosition(RecNo * 100 Div RecordCount);
    end;
  end;
  {$ENDREGION 'Chargement de FMARQUE'}

  {$REGION 'Chargement de FARTMRKFOURN depuis Ginkoia'}
 { with FIboQuery do
  begin
    SQL.Clear;

    LabCaption('Création des fichiers de comparaison ');
    BarPosition(0);

    try
      SQL.Add(' select *');
      SQL.Add(' from  ARTMRKFOURN');
      SQL.Add(' join K on K_Id = FMK_Id and K_ENABLED = 1');
      SQL.Add(' where FMK_ID <> 0');

      Open;

      while not EoF do
      begin
        FARTMRKFOURN.ClientDataset.Append;

        FARTMRKFOURN.ClientDataset.FieldByName('FMK_ID').AsInteger    := FieldByName('FMK_ID').AsInteger;
        FARTMRKFOURN.ClientDataset.FieldByName('FMK_MRKID').AsInteger := FieldByName('FMK_MRKID').AsInteger;
        FARTMRKFOURN.ClientDataset.FieldByName('FMK_FOUID').AsInteger := FieldByName('FMK_FOUID').AsInteger;
        FARTMRKFOURN.ClientDataset.FieldByName('FMK_PRIN').AsInteger  := FieldByName('FMK_PRIN').AsInteger;

        FARTMRKFOURN.ClientDataset.Post;

        Next;
        BarPosition(RecNo * 100 Div RecordCount);
      end;

      Close;

    except
      FARTMRKFOURN.ClientDataset.EmptyDataSet;
    end;
  end; }
  {$ENDREGION 'Chargement de FARTMRKFOURN'}
end;

//------------------------------------------------------------------------------
//                                                        +--------------------+
//                                                        |   Test d'unicité   |
//                                                        +--------------------+
//------------------------------------------------------------------------------
      {$REGION ' Test d''unicité'}
//--------------------------------------------------------> MarqueExisteDeja

function TMarque.MarqueExisteDeja : Boolean;
var
  vCode : String;
begin
  vCode  := DM_GSDataImport.cds_MARQUE.FieldByName('CODE_MARQUE').AsString;
  Result := FMarqueTable.Locate('MRK_CODE', vCode, [loCaseInsensitive]);
end;

//--------------------------------------------------> LibelleMarqueIdentique

function TMarque.LibelleMarqueIdentique : Boolean;
begin
  if Trim(Uppercase(FMarqueTable.FieldByName('MRK_NOM').AsString))
  =  Trim(Uppercase(DM_GSDataImport.cds_MARQUE.FieldByName('LIBELLE_MARQUE').AsString)) then
    Result := True
  else
    Result := False;
end;

//----------------------------------------------------------> RelationExiste

function TMarque.RelationExiste(vpIdMarque,
vpIdFournisseur : Integer) : Boolean;
begin
  Result := FARTMRKFOURN.ClientDataset.Locate('FMK_MRKID; FMK_FOUID',
             VarArrayOf([IntToStr(vpIdMarque), IntToStr(vpIdFournisseur)]), [loCaseInsensitive]);
end;

//----------------------------------------------> FournisseurPrincipalExiste

function TMarque.FournisseurPrincipalExiste(vpIdMarque : Integer) : Boolean;
begin
  Result := FARTMRKFOURN.ClientDataset.Locate('FMK_MRKID; FMK_PRIN',
             VarArrayOf([IntToStr(vpIdMarque), '1']), [loCaseInsensitive]);
end;

function TMarque.GetIdByCode(ACode: String ; ACenCode : Integer): Integer;
begin
  if FMARQUE.ClientDataset.Active and FMARQUE.ClientDataset.locate('MRK_CODE',ACode,[loCaseInsensitive]) then
    Result := FMARQUE.FieldByName('MRK_ID').AsInteger
  else begin
    if FMarqueTable.Locate('MRK_CODE',ACode,[loCaseInsensitive]) then
      Result := FMarqueTable.FieldByName('MRK_ID').AsInteger
    else begin
      With FIboQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select MRK_ID from ARTMARQUE');
        SQL.Add('  join K on K_ID = MRK_ID and K_Enabled = 1');
        SQL.Add('Where MRK_CODE = :PMRKCODE');
        ParamCheck := True;
        ParamByName('PMRKCODE').AsString := ACode;
        Open;

        if RecordCount > 0 then
          Result := FieldByName('MRK_ID').AsInteger
        else
          raise Exception.Create('Marque non trouvée : ' + ACode);
      end;
    end;
  end;
end;
      {$ENDREGION ' Test d''unicité'}
//------------------------------------------------------------------------------
//                                                              +--------------+
//                                                              |  DoMajTable  |
//                                                              +--------------+
//------------------------------------------------------------------------------

//--------------------------------------------------------------> DoMajTable

function TMarque.DoMajTable : Boolean;
var
  vIdMarque, vIdFournisseur, vPrincipal, vIdRelation : Integer;
begin

  {$REGION 'Initialisation des variables'}
//  try
//    GetGenParam(16, 9, vIdFournisseur, True);
//  except
//    on E:Exception do
//    raise Exception.Create('TMarque -> ' + E.Message);
//  end;
  {$ENDREGION 'Initialisation des CDS et des variables'}

  with FMarque do
  begin
    try
      LabCaption('Création/Mise à jour des marques');
      BarPosition(0);

      First;

      while not EOF do
      begin
        // on enregistre en table
        if DB_MAJ_Marque then
        begin
          vIdMarque := FieldByName('MRK_Id').AsInteger;

          {$REGION 'Traitement '}
//          if not RelationExiste(vIdMarque, vIdFournisseur) then
//            vPrincipal := 1
//          else
//            if FournisseurPrincipalExiste(vIdMarque) then
//              vPrincipal := 0
//            else
//              vPrincipal := 1;
//
//          // On insert la relation en table avec le code Principal correspondant
//          // La function renvoie en var l'Id de la relation
//          DB_Insert_RelationMarque(vIdMarque, vIdFournisseur, vPrincipal, vIdRelation);
//
//          // si l'insertion est OK, on ajoute la nouvelle relation au CDS
//          if vIdRelation <> 0 then
//            CDS_AjouterRelationMarque(vIdRelation, vIdMarque,
//                                      vIdFournisseur, vPrincipal);
           {$ENDREGION 'Initialisation des variables'}
        end;
        FMarque.Next;
        BarPosition(ClientDataset.RecNo * 100 Div ClientDataset.RecordCount);
      end;

    except on E:Exception do
      begin
        IncError ;
        raise Exception.Create('TMarque -> ' + E.Message);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//                                                          +------------------+
//                                                          |   Action table   |
//                                                          +------------------+
//------------------------------------------------------------------------------

//-----------------------------------------------------------> DB_MAJ_Marque

function TMarque.DB_MAJ_Marque : Boolean;
var
  vErreur : TErreur;
begin
  with FIboQuery do
  begin
    IB_Transaction.StartTransaction;

    Close;
    SQL.Clear;

    try
      // Execution de la proc stockée et récupération de l'IdMarque crée si on insert
      SQL.Add(' select * ');
      if FBaseVersion = 1
        then SQL.Add(' from GOS_MAJMARQUE(:MRKID, :MRKCODE, :MRKNOM, :ACTIONTABLE)');
      if FBaseVersion = 2
        then SQL.Add(' from GOS_MAJMARQUE(:MRKID, :MRKCODE, :MRKNOM, :ACTIONTABLE, :CENCODE)');

      ParamCheck := True;
      ParamByName('MRKID').AsInteger       := FMARQUE.FieldByName('MRK_ID').AsInteger;
      ParamByName('MRKCODE').AsString      := FMARQUE.FieldByName('MRK_CODE').AsString;
      ParamByName('MRKNOM').AsString       := FMARQUE.FieldByName('MRK_NOM').AsString;
      ParamByName('ACTIONTABLE').AsInteger := FMARQUE.FieldByName('ACTIONTABLE').AsInteger;
      if FBaseVersion = 2
        then ParamByName('CENCODE').AsInteger     := FMARQUE.FieldByName('MRK_CENTRALE').AsInteger;

      Open;

      if not IsEmpty then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        Inc(FMajCount,    FieldByName('FMAJ').AsInteger);

        if FMARQUE.ClientDataset.FieldByName('ACTIONTABLE').AsInteger = ord(ttatInsert) then
        begin
          FMARQUE.Edit;
          FMARQUE.FieldByName('MRK_ID').AsInteger := FieldByName('MRKID').AsInteger;
          FMARQUE.Post;
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

        with FMARQUE.ClientDataset do
        begin
          vErreur := TErreur.Create;
          vErreur.AddError(FMARQUE_File, 'Marque',
                           'MAJ_Marque échouée : ' + FieldByName('MRK_CODE').AsString,
                           RecNo, teMarque, 0,'');
          GErreurs.Add(vErreur);
          IncError;
        end;
        {$ENDREGION 'Gestion des erreurs'}
      end;
    end;
  end;
end;

//------------------------------------------------> DB_Insert_RelationMarque

function TMarque.DB_Insert_RelationMarque(vpIdMarque, vpIdFournisseur,
vpPrincipal : Integer; var vpIdRelation : Integer) : Boolean;
var
  vErreur : TErreur;
begin
  vpIdRelation := 0;

  with FIboQuery do
  begin
    IB_Transaction.StartTransaction;

    Close;
    SQL.Clear;

    try
      // Execution de la proc stockée et récupération de l'IdRelation ainsi crée
      SQL.Add(' select *  ');
      SQL.Add(' from GOS_INSERTRELATIONMARQUE(:MRKID, :FOUID, :PRINCIPAL)');

      ParamCheck := True;
      ParamByName('MRKID').AsInteger     := vpIdMarque;
      ParamByName('FOUID').AsInteger     := vpIdFournisseur;
      ParamByName('PRINCIPAL').AsInteger := vpPrincipal;

      Open;

      if not IsEmpty then
      begin
        Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
        vpIdRelation := FieldByName('FMKID').AsInteger;
      end;

      Close;

      Result := True;

      IB_Transaction.Commit;
    except on E:Exception do
      begin
       {$REGION ' Gestion des erreurs '}

        IB_Transaction.Rollback;

        Result := False;

        vpIdRelation := 0;

        with FMARQUE.ClientDataset do
        begin
          vErreur := TErreur.Create;
          vErreur.AddError(FMARQUE_File, 'Marque',
                           'Insertion relation échouée pour la marque : ' + IntToStr(vpIdMarque),
                            vpIdMarque, teMarque, 0,'');
          GErreurs.Add(vErreur);
          IncError;
        end;
        {$ENDREGION 'Gestion des erreurs'}
      end;
    end;
  end;
end;

//-----------------------------------------------> CDS_AjouterRelationMarque

procedure TMarque.CDS_AjouterRelationMarque(vpIdRelation, vpIdMarque,
vpIdFournisseur, vpPrincipal : Integer);
begin
  with FARTMRKFOURN.ClientDataset do
  begin
    Append;

    FieldByName('FMK_ID').AsInteger    := vpIdRelation;
    FieldByName('FMK_MRKID').AsInteger := vpIdMarque;
    FieldByName('FMK_FOUID').AsInteger := vpIdFournisseur;
    FieldByName('FMK_PRIN').AsInteger  := vpPrincipal;

    Post;
  end;
end;


end.

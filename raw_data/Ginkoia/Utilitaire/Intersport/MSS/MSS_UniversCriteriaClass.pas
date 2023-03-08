unit MSS_UniversCriteriaClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;

type
  TUniversCriteria = Class(TMainClass)
  Private
    FNKLSecteur,
    FNKLRayon,
    FNKLFamille,
    FNKLSSfamille,
    FNKLFedas,
    FNKLAXEAXE : TMainClass;

    FType : String;
    FACTID: Integer;
    FUNIID: Integer;
  Public
    procedure Import;override;
    constructor Create;override;
    Destructor Destroy;override;
    function ClearIdField : Boolean;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    // Permet de récupérer l'Id du secteur de l'enregistrement en cours
    function GetSecteur(UNI_ID : Integer) : Integer;
    function GetRayon(SEC_ID, UNI_ID : Integer) : Integer;
    function GetFamille(RAY_ID : Integer) : Integer;
    function GetSSFamille : Integer;
  published
    property NKLSecteur : TMainClass read FNKLSecteur;
    property NKLRayon   : TMainClass read FNKLRayon;
    property NKLFamille : TMainClass read FNKLFamille;
    property NKLSSFamille : TMainClass read FNKLSSfamille;
    property Fedas        : TMainClass read FNKLFedas;

    Property ACT_ID : Integer read FACTID;
    Property UNI_ID : Integer read FUNIID;
  End;

implementation

{ TUniversCriteria }

function TUniversCriteria.ClearIdField: Boolean;
begin
  Result := False;
  FUNIID := -1;
  try
    Result := FNKLSecteur.ClearIdField;
    Result := Result and FNKLRayon.ClearIdField;;
    Result := Result and FNKLFamille.ClearIdField;
    Result := Result and FNKLSSfamille.ClearIdField;
  Except on E:Exception do
    raise Exception.Create('ClearIdField ' + FTitle + ' -> ' + E.Message);
  end;
end;

constructor TUniversCriteria.Create;
begin
  inherited Create;
  FNKLSecteur := TMainClass.Create;
  FNKLSecteur.Title := 'Secteur';
  FNKLRayon   := TMainClass.Create;
  FNKLRayon.Title := 'Rayon';
  FNKLFamille := TMainClass.Create;
  FNKLFamille.Title := 'Famille';
  FNKLSSfamille := TMainClass.Create;
  FNKLSSfamille.Title := 'SSFamille';
  FNKLFedas     := TMainClass.Create;
  FNKLAXEAXE    := TMainClass.Create;

  FACTID := -1;
  FUNIID := -1;
end;

destructor TUniversCriteria.Destroy;
begin
  FNKLAXEAXE.Free;
  FNKLFedas.Free;
  FNKLSSfamille.Free;
  FNKLFamille.Free;
  FNKLRayon.Free;
  FNKLSecteur.Free;

  inherited;
end;

function TUniversCriteria.DoMajTable(ADoMaj : Boolean): Boolean;
var
  SEC_ID, RAY_ID, FAM_ID, SSF_ID, TCT_ID, TVA_ID : Integer;
  IMP_REFSTR, DOS_STRING : String;
  iAjout, iMaj : Integer;
begin
  {$REGION 'Récupération du domaine'}
    Try
      GetGenParam(12,15,FACTID);
    Except
      on ENOTFIND do raise Exception.Create('Domaine non trouvé');
      on ECFGERROR do raise Exception.Create('Domaine : configuration incorrecte (valeur 0)');
      on E:Exception do raise Exception.Create(E.Message);
    End;
  {$ENDREGION}

  {$REGION 'Récupération de l''univers'}
  Try
    GetGenParam(12,16,FUNIID);
  Except
    on ENOTFIND do raise Exception.Create('Axe non trouvé');
    on ECFGERROR do raise Exception.Create('Axe : configuration incorrecte (valeur 0)');
    on E:Exception do raise Exception.Create(E.Message);
  End;
  {$ENDREGION}

  // Type comptable
  Try
    GetGenParam(12,3,TCT_ID);
  Except
    on ENOTFIND do raise Exception.Create('Type comptable non trouvé');
    on ECFGERROR do raise Exception.Create('Type comptable : configuration incorrecte (valeur 0)');
    on E:Exception do raise Exception.Create(E.Message);
  End;

  // TVA par defaut
  GetGenParam(12,1,TVA_ID,False);

  // récupération des données axe
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select AXX_ID, AXX_SSFID1, AXX_SSFID2, SSF_CODEFINAL from NKLAXEAXE');
    SQL.Add('  Join K on K_ID = AXX_ID and K_Enabled = 1');
    SQL.Add('  Join NKLSSFAMILLE on SSF_ID = AXX_SSFID2');
    SQL.Add('Where AXX_CENTRALE = 1');
    Open;

    First;
    FNKLAXEAXE.ClientDataSet.EmptyDataSet;
    while not Eof do
    begin
      FNKLAXEAXE.ClientDataSet.Append;
      FNKLAXEAXE.FieldByName('AXX_ID').AsInteger       := FieldByName('AXX_ID').AsInteger;
      FNKLAXEAXE.FieldByName('SSF_ID').AsInteger       := FieldByName('AXX_SSFID1').AsInteger;
      FNKLAXEAXE.FieldByName('SSFID_FEDAS').AsInteger  := FieldByName('AXX_SSFID2').AsInteger;
      FNKLAXEAXE.FieldByName('SSFCODE_FEDAS').AsString := FieldByName('SSF_CODEFINAL').AsString;
      FNKLAXEAXE.FieldByName('Deleted').AsInteger      := 1;
      FNKLAXEAXE.ClientDataSet.Post;

      Next;
    end; // while
  end; // with

  // Traitement des secteurs
  FNKLSecteur.First;

  while not FNKLSecteur.Eof do
  begin
    Try
      SEC_ID := GetSecteur(FUNIID);

    Except on E:Exception do
      FErrLogs.Add('NKLSECTEUR -> ' + FNKLSecteur.FieldByName('Aggregationleveloneid').AsString + ' ' +
                   FNKLSecteur.FieldByName('Aggregationlevelonedenotation').AsString + ' - ' + E.Message);
    End;
    FNKLSecteur.ClientDataSet.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLSecteur.ClientDataSet.RecNo * 100 Div FNKLSecteur.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // traitement des Rayon
  FNKLRayon.ClientDataSet.First;
  while not FNKLRayon.ClientDataSet.Eof do
  begin
    Try
//      IMP_REFSTR := FNKLRayon.ClientDataSet.FieldByName('LVL1ID').AsString + '/' + FNKLRayon.ClientDataSet.FieldByName('Aggregationleveltwoid').AsString;

      FNKLSecteur.First;
      if FNKLSecteur.ClientDataSet.Locate('Aggregationleveloneid',FNKLRayon.FieldByName('LVL1ID').AsString,[loCaseInsensitive]) then
      begin
        SEC_ID := FNKLSecteur.FieldByName('SEC_ID').AsInteger;
        if SEC_ID = -1 then
          raise Exception.Create('NKLRayon -> Id Secteur invalide');
      end
      else
        raise Exception.Create('NKLRayon -> Secteur introuvable :' + FNKLRayon.FieldByName('LVL1ID').AsString);

      RAY_ID := GetRayon(SEC_ID,FUNIID);

    Except on E:Exception do
      FErrLogs.Add('NKLRAYON -> ' + E.Message);
    End;
    FNKLRayon.ClientDataSet.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLRayon.ClientDataSet.RecNo * 100 Div FNKLRayon.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // gestion de la famille
  FNKLFamille.First;
  while not FNKLFamille.Eof do
  begin
    try
      FNKLRayon.First;
      if FNKLRayon.ClientDataSet.Locate('LVL1ID;Aggregationleveltwoid',
                                         VarArrayOf([FNKLFamille.FieldByName('LVL1ID').AsString,
                                         FNKLFamille.FieldByName('LVL2ID').AsString]),
                                         [loCaseInsensitive]) then
      begin
        RAY_ID := FNKLRayon.ClientDataSet.FieldByName('RAY_ID').AsInteger;
        if RAY_ID = -1 then
          raise Exception.Create('NKLRayon -> Id rayon incorrect');
      end
      else
        raise Exception.Create('NKLRayon -> Rayon non trouvé : ' + FNKLFamille.FieldByName('LVL1ID').AsString + '/' +
                                                                   FNKLFamille.FieldByName('LVL2ID').AsString);
     FAM_ID := GetFamille(RAY_ID);
    Except on E:Exception do
      FErrLogs.Add('NKLFAMILLE -> ' + E.Message);
    End;
    FNKLFamille.ClientDataSet.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLFamille.ClientDataSet.RecNo * 100 Div FNKLFamille.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // Gestion de la sousfamille
  FNKLSSfamille.First;
  while not FNKLSSfamille.Eof do
  begin
    try
      FNKLFamille.First;
      if FNKLFamille.ClientDataSet.Locate('LVL1ID;LVL2ID;Aggregationlevelthreeid',
                                         VarArrayOf([FNKLSSFamille.FieldByName('LVL1ID').AsString,
                                         FNKLSSFamille.FieldByName('LVL2ID').AsString,
                                         FNKLSSFamille.FieldByName('LVL3ID').AsString]),
                                         [loCaseInsensitive]) then
      begin
        FAM_ID := FNKLFamille.FieldByName('FAM_ID').AsInteger;
        if FAM_ID = -1 then
          raise Exception.Create('NKLFamille -> Id Famille incorrect');
      end
      else
        raise Exception.Create('NKLFamille -> Rayon non trouvé : ' + FNKLSSFamille.FieldByName('LVL1ID').AsString + '/' +
                                                                   FNKLSSFamille.FieldByName('LVL2ID').AsString);

      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_UNIVERSCRITERIA_SSFAMILLE';
        ParamCheck := True;
        ParamByName('FAM_ID').AsInteger       := FAM_ID;
        ParamByName('ID').AsString            := IMP_REFSTR;
        ParamByName('Denotation').AsString    := FNKLSSfamille.FieldByName('Aggregationlevelfourdenotation').AsString;
        ParamByName('SSFTCTID').AsInteger     := TCT_ID;
        ParamByName('SSFTVAID').AsInteger     := TVA_ID;
        ParamByName('SSF_IDREF').AsInteger    := StrToInt(FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString);
        if ParamByName('SSF_IDREF').AsInteger = 0 then
          ParamByName('SSF_IDREF').AsInteger  := 1;

        ParamByName('SSF_CODE').AsString      := FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString;
        ParamByName('SSF_CODENIV').AsString   := FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString;
        ParamByName('SSF_CODEFINAL').AsString := FNKLSSFamille.FieldByName('LVL1ID').AsString +
                                                 FNKLSSFamille.FieldByName('LVL2ID').AsString +
                                                 FNKLSSFamille.FieldByName('LVL3ID').AsString +
                                                 FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString;
        ParamByName('SSF_ORDREAFF').AsInteger := StrToInt(FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString);
        ParamByName('SSF_VISIBLE').AsInteger  := 1;
        ParamByName('SSF_TGTCODE').AsString   := FNKLSSFamille.FieldByName('Msr').AsString;
        Open;

        if RecordCount > 0 then
        begin
          SSF_ID := FieldByName('SSF_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;
      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FNKLSSFamille.ClientDataSet.Edit;
      FNKLSSFamille.ClientDataSet.FieldByName('SSF_ID').AsInteger := SSF_ID;
      FNKLSSFamille.ClientDataSet.Post;

    Except on E:Exception do
      FErrLogs.Add('NKLSSFamille -> ' + FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString + ' ' +
                   FNKLSSfamille.FieldByName('Aggregationlevelfourdenotation').AsString + ' - ' + E.Message);
    End;

    FNKLSSfamille.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLSSfamille.ClientDataSet.RecNo * 100 Div FNKLSSfamille.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // traitement Fedas
  FNKLFedas.First;
  while ADoMaj and (not FNKLFedas.Eof) do
  begin
    try
//      if (IsInGenImport(CIMPNUM_FEDAS,FNKLFedas.FieldByName('Aggregationlevelfourigiic').AsString) = -1) then
      begin
        FNKLSSfamille.First;
        if FNKLSSfamille.ClientDataSet.Locate('LVL1ID;LVL2ID;LVL3ID;Aggregationlevelfourid',
           VarArrayOf([FNKLFedas.FieldByName('LVL1ID').AsString,
                       FNKLFedas.FieldByName('LVL2ID').AsString,
                       FNKLFedas.FieldByName('LVL3ID').AsString,
                       FNKLFedas.FieldByName('LVL4ID').AsString]),[loCaseInsensitive]) then
        begin
          SSF_ID := FNKLSSfamille.FieldByName('SSF_ID').AsInteger;
          if SSF_ID = -1 then
            raise Exception.Create('NKLSSFAMILLE -> Id SSFamille non créée : ' + FNKLFedas.FieldByName('LVL1ID').AsString + '/' +
                                                                                 FNKLFedas.FieldByName('LVL2ID').AsString + '/' +
                                                                                 FNKLFedas.FieldByName('LVL3ID').AsString + '/' +
                                                                                 FNKLFedas.FieldByName('LVL4ID').AsString);
          // Vérification que la relation n'existe pas déjà
          if FNKLAXEAXE.ClientDataSet.Locate('SSF_ID;SSFCODE_FEDAS',VarArrayOf([SSF_ID, FNKLFedas.FieldByName('Aggregationlevelfourigiic').AsString]),[loCaseInsensitive]) then
          begin
            FNKLAXEAXE.ClientDataSet.Edit;
            FNKLAXEAXE.FieldByName('Deleted').AsInteger := 0;
            FNKLAXEAXE.ClientDataSet.Post;
          end
          else begin
            With FStpQuery do
            begin
              Close;
              StoredProcName := 'MSS_UNIVERSCRITERIA_NKLAXEAXE';
              ParamCheck := True;
              ParamByName('SSFID').AsInteger := SSF_ID;
              ParamByName('SSFCODE').AsString := FNKLFedas.FieldByName('Aggregationlevelfourigiic').AsString;
              Open;

              if FieldByName('AXX_ID').AsInteger = -1 then
                raise Exception.Create('AXE non créé : ' + FNKLFedas.FieldByName('Aggregationlevelfourigiic').AsString);
            end;
          end;

        end
        else
          raise Exception.Create('NKLSSFAMILLE -> Sous Famille non trouvée' + FNKLFedas.FieldByName('LVL1ID').AsString + '/' +
                       FNKLFedas.FieldByName('LVL2ID').AsString + '/' +
                       FNKLFedas.FieldByName('LVL3ID').AsString + '/' +
                       FNKLFedas.FieldByName('LVL4ID').AsString );
      end;
    Except on E:Exception do
      FErrLogs.Add(FNKLFedas.FieldByName('Aggregationlevelfourigiic').AsString + ' - ' + E.Message);
    End;

    FNKLFedas.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLFedas.ClientDataSet.RecNo * 100 Div FNKLFedas.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // Suppression des liaisons obsolètes
  FNKLAXEAXE.First;
  while not FNKLAXEAXE.EOF do
  begin
    try
      if FNKLAXEAXE.FieldByName('Deleted').AsInteger = 1 then
      begin
        With FIboQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,1)');
          ParamCheck := True;
          ParamByName('ID').AsInteger := FNKLAXEAXE.FieldByName('AXX_ID').AsInteger;
          ExecSQL;
//          FErrLogs.Add('Suppression ' + FNKLAXEAXE.FieldByName('AXX_ID').AsString);
        end;
      end;
    Except on E:Exception do
      FErrLogs.Add(Format('Erreur de suppression AXE %d SSFID1 %d SSFID2 %d',[FNKLAXEAXE.FieldByName('AXX_ID').AsInteger,FNKLAXEAXE.FieldByName('SSF_ID').AsInteger,FNKLAXEAXE.FieldByName('SSFID_FEDAS').AsInteger]));
    end;
    FNKLAXEAXE.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLAXEAXE.ClientDataSet.RecNo * 100 Div FNKLAXEAXE.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;
end;

function TUniversCriteria.GetFamille (RAY_ID : Integer): Integer;
var
  IMP_REFSTR : String;
  FAM_ID, iAjout, iMaj : Integer;
begin
  FAM_ID := -1;
  try
     With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_UNIVERSCRITERIA_FAMILLE';
        ParamCheck := True;
        ParamByName('RAY_ID').AsInteger       := RAY_ID;
        ParamByName('ID').AsString            := FNKLFamille.FieldByName('Aggregationlevelthreeid').AsString;
        ParamByName('Denotation').AsString    := FNKLFamille.FieldByName('Aggregationlevelthreedenotation').AsString;
        ParamByName('FAM_IDREF').AsInteger    := StrToInt(FNKLFamille.FieldByName('Aggregationlevelthreeid').AsString);
        ParamByName('FAM_ORDREAFF').AsInteger := StrToInt(FNKLFamille.FieldByName('Aggregationlevelthreeid').AsString);
        ParamByName('FAM_CODENIV').AsString   := FNKLFamille.FieldByName('LVL1ID').AsString +
                                                 FNKLFamille.FieldByName('LVL2ID').AsString +
                                                 FNKLFamille.FieldByName('Aggregationlevelthreeid').AsString;
        Open;

        if RecordCount > 0 then
        begin
          FAM_ID := FieldByName('FAM_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;
      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FNKLFamille.ClientDataSet.Edit;
      FNKLFamille.ClientDataSet.FieldByName('FAM_ID').AsInteger := FAM_ID;
      FNKLFamille.ClientDataSet.Post;

    Result := FAM_ID;
  Except on E:Exception do
    raise Exception.Create('GetFamille -> ' + FNKLFamille.ClientDataSet.FieldByName('Aggregationlevelthreeid').AsString + ' ' +
                 FNKLFamille.ClientDataSet.FieldByName('Aggregationlevelthreedenotation').AsString + ' - ' + E.Message);
  End;
end;

function TUniversCriteria.GetRayon(SEC_ID,UNI_ID : Integer) : Integer;
var
  IMP_REFSTR : String;
  RAY_ID, iAjout, iMaj : Integer;
begin
  RAY_ID := -1;
  Try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_UNIVERSCRITERIA_RAYON';
      ParamCheck := True;
      ParamByName('SEC_ID').AsInteger       := SEC_ID;
      ParamByName('UNI_ID').AsInteger       := UNI_ID;
      ParamByName('ID').AsString            := FNKLRayon.FieldByName('Aggregationleveltwoid').AsString;
      ParamByName('Denotation').AsString    := FNKLRayon.FieldByName('Aggregationleveltwodenotation').AsString;
      ParamByName('RAY_IDREF').AsInteger    := StrToInt(FNKLRayon.FieldByName('Aggregationleveltwoid').AsString);
      ParamByName('RAY_ORDREAFF').AsInteger := StrToInt(FNKLRayon.FieldByName('Aggregationleveltwoid').AsString);
      ParamByName('RAY_CODENIV').AsString   := FNKLRayon.FieldByName('LVL1ID').AsString +
                                               FNKLRayon.FieldByName('Aggregationleveltwoid').AsString;
      Open;

      if RecordCount > 0 then
      begin
        RAY_Id := FieldByName('RAY_ID').AsInteger;
        iAjout := FieldbyName('FAJOUT').AsInteger;
        iMaj   := FieldByName('FMAJ').AsInteger;
      end
      else
        raise Exception.Create('Aucune donnée retournée');
    end;
    Inc(FInsertCount,iAjout);
    Inc(FMajCount,iMaj);

    FNKLRayon.ClientDataSet.Edit;
    FNKLRayon.ClientDataSet.FieldByName('RAY_ID').AsInteger := RAY_ID;
    FNKLRayon.ClientDataSet.Post;

    Result := RAY_ID;

  Except on E:Exception do
    raise Exception.Create('GetRayon -> ' + FNKLRayon.ClientDataSet.FieldByName('Aggregationleveltwoid').AsString + ' ' +
                 FNKLRayon.ClientDataSet.FieldByName('Aggregationleveltwodenotation').AsString + ' - ' + E.Message);
  End;
end;

function TUniversCriteria.GetSecteur(UNI_ID : Integer): Integer;
var
  SEC_ID, iAjout, iMaj : Integer;
begin
  SEC_ID := -1;
  Try
      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_UNIVERSCRITERIA_SECTEUR';
        ParamCheck := True;
        ParamByName('UNI_ID').AsInteger := UNI_ID;
        ParamByName('ID').AsString      := FNKLSecteur.FieldByName('Aggregationleveloneid').AsString;
        ParamByName('SEC_NOM').AsString := FNKLSecteur.FieldByName('Aggregationlevelonedenotation').AsString;
        ParamByName('SEC_IDREF').AsInteger := StrToInt(FNKLSecteur.FieldByName('Aggregationleveloneid').AsString);
        ParamByName('SEC_ORDREAFF').AsInteger := StrToInt(FNKLSecteur.FieldByName('Aggregationleveloneid').AsString);
        ParamByName('SEC_VISIBLE').AsInteger := FNKLSecteur.FieldByName('Barred').AsInteger;
        Open;

        if RecordCount > 0 then
        begin
          SEC_ID := FieldByName('SEC_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;

      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FNKLSecteur.ClientDataSet.Edit;
      FNKLSecteur.ClientDataSet.FieldByName('SEC_ID').AsInteger := SEC_ID;
      FNKLSecteur.ClientDataSet.Post;
    Result := SEC_ID;
  Except on E:Exception do
    raise Exception.Create('GetSecteur -> ' + FNKLSecteur.ClientDataSet.FieldByName('Aggregationleveloneid').AsString + ' ' +
                 FNKLSecteur.ClientDataSet.FieldByName('Aggregationlevelonedenotation').AsString + ' - ' + E.Message);
  End;
end;

function TUniversCriteria.GetSSFamille: Integer;
VAR
  IMP_REFSTR : String;
  SSF_ID, UNI_ID, SEC_ID, RAY_ID, FAM_ID : Integer;
  iAjout, iMaj : Integer;
  TCT_ID, TVA_ID : Integer;
  DOS_STRING : String;

begin
  SSF_ID := -1;

  // Type comptable
  Try
    GetGenParam(12,3,TCT_ID);
  Except
    on ENOTFIND do raise Exception.Create('Type comptable non trouvé');
    on ECFGERROR do raise Exception.Create('Type comptable : configuration incorrecte (valeur 0)');
    on E:Exception do raise Exception.Create(E.Message);
  End;

  // TVA par defaut
  GetGenParam(12,1,TVA_ID, False);

  SEC_ID := GetSecteur(FUNIID);
  RAY_ID := GetRayon(SEC_ID,FUNIID);
  FAM_ID := GetFamille(RAY_ID);

  try
   With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_UNIVERSCRITERIA_SSFAMILLE';
        ParamCheck := True;
        ParamByName('FAM_ID').AsInteger       := FAM_ID;
        ParamByName('ID').AsString            := IMP_REFSTR;
        ParamByName('Denotation').AsString    := FNKLSSfamille.FieldByName('Aggregationlevelfourdenotation').AsString;
        ParamByName('SSFTCTID').AsInteger     := TCT_ID;
        ParamByName('SSFTVAID').AsInteger     := TVA_ID;
        ParamByName('SSF_IDREF').AsInteger    := StrToInt(FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString);
        if ParamByName('SSF_IDREF').AsInteger = 0 then
          ParamByName('SSF_IDREF').AsInteger  := 1;

        ParamByName('SSF_CODE').AsString      := FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString;
        ParamByName('SSF_CODENIV').AsString   := FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString;
        ParamByName('SSF_CODEFINAL').AsString := FNKLSSFamille.FieldByName('LVL1ID').AsString +
                                                 FNKLSSFamille.FieldByName('LVL2ID').AsString +
                                                 FNKLSSFamille.FieldByName('LVL3ID').AsString +
                                                 FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString;
        ParamByName('SSF_ORDREAFF').AsInteger := StrToInt(FNKLSSfamille.FieldByName('Aggregationlevelfourid').AsString);
        ParamByName('SSF_VISIBLE').AsInteger  := 1;
        ParamByName('SSF_TGTCODE').AsString   := FNKLSSFamille.FieldByName('Msr').AsString;
        Open;

        if RecordCount > 0 then
        begin
          SSF_ID := FieldByName('SSF_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;
      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FNKLSSFamille.ClientDataSet.Edit;
      FNKLSSFamille.ClientDataSet.FieldByName('SSF_ID').AsInteger := SSF_ID;
      FNKLSSFamille.ClientDataSet.Post;


    Result := SSF_ID;
  Except on E:Exception do
    raise Exception.Create('GetSSFamille -> ' + FNKLSSfamille.ClientDataSet.FieldByName('Aggregationlevelfourid').AsString + ' ' +
                 FNKLSSfamille.ClientDataSet.FieldByName('Aggregationlevelfourdenotation').AsString + ' - ' + E.Message);
  End;

end;

procedure TUniversCriteria.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  eUniverscriterialistNode,
  eAggregationgroupNode,
  eAggregationlvloneNode,
  eAggregationlvltwoNode,
  eAggregationlvlthreeNode,
  eAggregationlvlfourNode,
  eAggregationlvlfoudgiicNode,
  eAggreationlvlFourGiicElem : IXMLNode;

  LevelOneID, LevelOneDenotation, Barred, SECID : TFieldCFG;
  LevelTwoL1ID, LevelTwoID, LevelTwoDenotation, RAYID : TFieldCFG;
  LevelThreeL1ID, LevelThreeL2ID, LevelThreeID, LeveThreeDenotation, FAMID : TFieldCFG;
  LevelFourL1ID, LevelFourL2ID, LevelFourL3ID, LevelFourId, LevelFourDenotation, SSFID, FDMSR : TFieldCFG;
  FedasL1ID, FedasL2ID, FedasL3ID, FedasL4ID, FedasGiic : TFieldCFG;

  AXX_ID, SSFID_FEDAS, SSFCODE_FEDAS, Deleted : TFieldCFG;

  i : integer;
begin
  // Définition du champs du Dataset
  LevelOneID.FieldName := 'Aggregationleveloneid';
  LevelOneID.FieldType := ftString;
  LevelOneDenotation.FieldName := 'Aggregationlevelonedenotation';
  LevelOneDenotation.FieldType := ftString;
  Barred.FieldName             := 'Barred';
  Barred.FieldType             := ftInteger;
  SECID.FieldName              := 'SEC_ID';
  SECID.FieldType              := ftInteger;

  LevelTwoL1ID.FieldName       := 'LVL1ID';
  LevelTwoL1ID.FieldType       := ftString;
  LevelTwoID.FieldName         := 'Aggregationleveltwoid';
  LevelTwoID.FieldType         := ftString;
  LevelTwoDenotation.FieldName := 'Aggregationleveltwodenotation';
  LevelTwoDenotation.FieldType := ftString;
  RAYID.FieldName              := 'RAY_ID';
  RAYID.FieldType              := ftInteger;

  LevelThreeL1ID.FieldName     := 'LVL1ID';
  LevelThreeL1ID.FieldType     := ftString;
  LevelThreeL2ID.FieldName     := 'LVL2ID';
  LevelThreeL2ID.FieldType     := ftString;
  LevelThreeID.FieldName       := 'Aggregationlevelthreeid';
  LevelThreeID.FieldType       := ftString;
  LeveThreeDenotation.FieldName := 'Aggregationlevelthreedenotation';
  LeveThreeDenotation.FieldType := ftString;
  FAMID.FieldName               := 'FAM_ID';
  FAMID.FieldType               := ftInteger;


  LevelFourL1ID.FieldName       := 'LVL1ID';
  LevelFourL1ID.FieldType       := ftString;
  LevelFourL2ID.FieldName       := 'LVL2ID';
  LevelFourL2ID.FieldType       := ftString;
  LevelFourL3ID.FieldName       := 'LVL3ID';
  LevelFourL3ID.FieldType       := ftString;
  LevelFourId.FieldName         := 'Aggregationlevelfourid';
  LevelFourId.FieldType         := ftString;
  LevelFourDenotation.FieldName := 'Aggregationlevelfourdenotation';
  LevelFourDenotation.FieldType := ftString;
  SSFID.FieldName               := 'SSF_ID';
  SSFID.FieldType               := ftInteger;
  FDMSR.FieldName               := 'MSR';
  FDMSR.FieldType               := ftString;

  FedasL1ID.FieldName           := 'LVL1ID';
  FedasL1ID.FieldType           := ftString;
  FedasL2ID.FieldName           := 'LVL2ID';
  FedasL2ID.FieldType           := ftString;
  FedasL3ID.FieldName           := 'LVL3ID';
  FedasL3ID.FieldType           := ftString;
  FedasL4ID.FieldName           := 'LVL4ID';
  FedasL4ID.FieldType           := ftString;
  FedasGiic.FieldName           := 'Aggregationlevelfourigiic';
  FedasGiic.FieldType           := ftString;

  // Création des champs
  FNKLSecteur.FieldNameID := 'SEC_ID';
  FNKLSecteur.CreateField([LevelOneID, LevelOneDenotation,Barred, SECID]);
  FNKLSecteur.ClientDataSet.AddIndex('Idx',LevelOneID.FieldName,[]);
  FNKLSecteur.ClientDataSet.IndexName := 'Idx';
  FNKLSecteur.KTB_ID := CKTBID_NKLSECTEUR;
  FNKLSecteur.IboQuery := FIboQuery;
  FNKLSecteur.StpQuery := FStpQuery;

  FNKLRayon.FieldNameID := 'RAY_ID';
  FNKLRayon.CreateField([LevelTwoL1ID, LevelTwoID, LevelTwoDenotation, RAYID]);
  FNKLRayon.ClientDataSet.AddIndex('Idx',LevelTwoL1ID.FieldName + ';' + LevelTwoID.FieldName,[]);
  FNKLRayon.ClientDataSet.IndexName := 'Idx';
  FNKLRayon.KTB_ID := CKTBID_NKLRAYON;
  FNKLRayon.IboQuery := FIboQuery;
  FNKLRayon.StpQuery := FStpQuery;

  FNKLFamille.FieldNameID := 'FAM_ID';
  FNKLFamille.CreateField([LevelThreeL1ID, LevelThreeL2ID, LevelThreeID, LeveThreeDenotation, FAMID]);
  FNKLFamille.ClientDataSet.AddIndex('Idx',LevelThreeL1ID.FieldName + ';' + LevelThreeL2ID.FieldName + ';' + LevelThreeID.FieldName,[]);
  FNKLFamille.ClientDataSet.IndexName := 'Idx';
  FNKLFamille.KTB_ID := CKTBID_NKLFAMILLE;
  FNKLFamille.IboQuery := FIboQuery;
  FNKLFamille.StpQuery := FStpQuery;

  FNKLSSfamille.FieldNameID := 'SSF_ID';
  FNKLSSfamille.CreateField([LevelFourL1ID, LevelFourL2ID, LevelFourL3ID, LevelFourId, LevelFourDenotation, SSFID, FDMSR]);
  FNKLSSfamille.ClientDataSet.AddIndex('Idx',LevelFourL1ID.FieldName + ';' + LevelFourL2ID.FieldName + ';' + LevelFourL3ID.FieldName + ';' + LevelFourId.FieldName,[]);
  FNKLSSfamille.ClientDataSet.IndexName := 'Idx';
  FNKLSSfamille.KTB_ID := CKTBID_NKLSSFAMILLE;
  FNKLSSfamille.IboQuery := FIboQuery;
  FNKLSSfamille.StpQuery := FStpQuery;

  FNKLFedas.FieldNameID := '';
  FNKLFedas.KTB_ID      := 0;
  FNKLFedas.CreateField([FedasL1ID, FedasL2ID, FedasL3ID, FedasL4ID, FedasGiic]);
  FNKLFedas.IboQuery := FIboQuery;
  FNKLFedas.StpQuery := FStpQuery;

  // table temporaire pour la gestion des liaisons
  AXX_ID.FieldName        := 'AXX_ID';
  AXX_ID.FieldType        := ftInteger;
  SSFID_FEDAS.FieldName   := 'SSFID_FEDAS';
  SSFID_FEDAS.FieldType   := ftInteger;
  SSFCODE_FEDAS.FieldName := 'SSFCODE_FEDAS';
  SSFCODE_FEDAS.FieldType := ftString;
  Deleted.FieldName       := 'Deleted';
  Deleted.FieldType       := ftInteger;

  FNKLAXEAXE.FieldNameID := '';
  FNKLAXEAXE.KTB_ID := 0;
  FNKLAXEAXE.CreateField([AXX_ID, SSFID, SSFID_FEDAS, SSFCODE_FEDAS, Deleted]);
  FNKLAXEAXE.IboQuery := FIboQuery;
  FNKLAXEAXE.StpQuery := FStpQuery;

  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      // récupération du type de fichier
      FType := XmlStrToStr(nXmlBase.ChildValues['Type']);

      eUniverscriterialistNode := nXmlBase.ChildNodes.FindNode('Universcriterialist');
      eAggregationgroupNode := eUniverscriterialistNode.ChildNodes['Aggregationgroup'];
      while eAggregationgroupNode <> nil do
      begin
        eAggregationlvloneNode := eAggregationgroupNode.ChildNodes.FindNode('Aggregationlevelone');
        while eAggregationlvloneNode <> nil do
        begin
          With FNKLSecteur.ClientDataSet do
          begin
            Append;
            FieldByName('Aggregationleveloneid').AsString := XmlStrToStr(eAggregationlvloneNode.ChildValues['Aggregationleveloneid']);
            FieldByName('Aggregationlevelonedenotation').AsString := XmlStrToStr(eAggregationlvloneNode.ChildValues['Aggregationlevelonedenotation']);
            if UpperCase(XmlStrToStr(eAggregationlvloneNode.ChildValues['Barred'])) = 'TRUE' then
              FieldByName('Barred').AsInteger := 1
            else
              FieldByName('Barred').AsInteger := 0;
            Post;
          end;

          eAggregationlvltwoNode := eAggregationlvloneNode.ChildNodes.FindNode('Aggregationleveltwo');
          while eAggregationlvltwoNode <> nil do
          begin
            With FNKLRayon.ClientDataSet do
            begin
              Append;
              FieldByName('LVL1ID').AsString := XmlStrToStr(eAggregationlvloneNode.ChildValues['Aggregationleveloneid']);
              FieldByName('Aggregationleveltwoid').AsString := XmlStrToStr(eAggregationlvltwoNode.ChildValues['Aggregationleveltwoid']);
              FieldByName('Aggregationleveltwodenotation').AsString := XmlStrToStr(eAggregationlvltwoNode.ChildValues['Aggregationleveltwodenotation']);
              Post;
            end;

            eAggregationlvlthreeNode := eAggregationlvltwoNode.ChildNodes.FindNode('Aggregationlevelthree');
            while eAggregationlvlthreeNode <> nil do
            begin
              with FNKLFamille.ClientDataSet do
              begin
                Append;
                FieldByName('LVL1ID').AsString := XmlStrToStr(eAggregationlvloneNode.ChildValues['Aggregationleveloneid']);
                FieldByName('LVL2ID').AsString := XmlStrToStr(eAggregationlvltwoNode.ChildValues['Aggregationleveltwoid']);
                FieldByName('Aggregationlevelthreeid').AsString := XmlStrToStr(eAggregationlvlthreeNode.ChildValues['Aggregationlevelthreeid']);
                FieldByName('Aggregationlevelthreedenotation').AsString := XmlStrToStr(eAggregationlvlthreeNode.ChildValues['Aggregationlevelthreedenotation']);
                Post;
              end;

              eAggregationlvlfourNode := eAggregationlvlthreeNode.ChildNodes.FindNode('Aggregationlevelfour');
              while eAggregationlvlfourNode <> nil do
              begin
                With FNKLSSfamille.ClientDataSet do
                begin
                  Append;
                  FieldByName('LVL1ID').AsString := XmlStrToStr(eAggregationlvloneNode.ChildValues['Aggregationleveloneid']);
                  FieldByName('LVL2ID').AsString := XmlStrToStr(eAggregationlvltwoNode.ChildValues['Aggregationleveltwoid']);
                  FieldByName('LVL3ID').AsString := XmlStrToStr(eAggregationlvlthreeNode.ChildValues['Aggregationlevelthreeid']);
                  FieldByName('Aggregationlevelfourid').AsString := XmlStrToStr(eAggregationlvlfourNode.ChildValues['Aggregationlevelfourid']);
                  FieldByName('Aggregationlevelfourdenotation').AsString := XmlStrToStr(eAggregationlvlfourNode.ChildValues['Aggregationlevelfourdenotation']);
                  FieldByName('MSR').AsString := '';
                  Post;
                end;

                eAggregationlvlfoudgiicNode := eAggregationlvlfourNode.ChildNodes.FindNode('Aggregationlevelfourigiiclist');
                for i := 0 to eAggregationlvlfoudgiicNode.ChildNodes.Count -1 do
                begin
                  eAggreationlvlFourGiicElem := eAggregationlvlfoudgiicNode.ChildNodes.Get(i);
                  With FNKLFedas.ClientDataSet do
                  begin
                    Append;
                    FieldByName('LVL1ID').AsString := XmlStrToStr(eAggregationlvloneNode.ChildValues['Aggregationleveloneid']);
                    FieldByName('LVL2ID').AsString := XmlStrToStr(eAggregationlvltwoNode.ChildValues['Aggregationleveltwoid']);
                    FieldByName('LVL3ID').AsString := XmlStrToStr(eAggregationlvlthreeNode.ChildValues['Aggregationlevelthreeid']);
                    FieldByName('LVL4ID').AsString := XmlStrToStr(eAggregationlvlfourNode.ChildValues['Aggregationlevelfourid']);
                    FieldByName('Aggregationlevelfourigiic').AsString := XmlStrToStr(eAggreationlvlFourGiicElem.NodeValue);
                    Post;
                  end;
                end;
                eAggregationlvlfourNode := eAggregationlvlfourNode.NextSibling;
              end;
              eAggregationlvlthreeNode := eAggregationlvlthreeNode.NextSibling;
            end;
            eAggregationlvltwoNode := eAggregationlvltwoNode.NextSibling;
          end;
          eAggregationlvloneNode := eAggregationlvloneNode.NextSibling;
        end;
        eAggregationgroupNode := eAggregationgroupNode.NextSibling;
      end;
    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := Nil;
    TXMLDocument(Xml).Free;
  end;

end;


end.

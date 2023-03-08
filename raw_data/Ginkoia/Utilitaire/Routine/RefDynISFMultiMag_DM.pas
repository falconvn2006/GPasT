//--------------------------------------------------------- ATTENTION ------------------------------------------------------------------------------
// Cette unité est similaire dans GINKOIA et dans l'utilitaire interclub.
// Si une modification est faite sur cette unité, il faut mettre à jour dans les 2 projets.
//--------------------------------------------------------------------------------------------------------------------------------------------------

unit RefDynISFMultiMag_DM;

interface

uses
  SysUtils, InvokeRegistry, DB, Classes, Rio, SOAPHTTPClient, IBODataset, DBClient, DateUtils, Math, StrUtils, Variants, Contnrs, Types, Windows,
  IPasserelleRefDynISFMultiMag;

type
  TWebResultMultiMag = record
    IsOK: Boolean;
    ArtId: String;
    ArtNumero: String;
    TexteSimple: String;
    Texte: TStringList;
  end;

  TTypeChamp = class
    public
      Nom: String;
      TypeChamp: TFieldType;
      Obligatoire: Boolean;

      constructor Create(const sNom: String; const nTypeChamp: Integer; const bObligatoire: Boolean);
  end;

  TRefDynISFMultiMag_DM = class(TDataModule)
    HTTPRIO: THTTPRIO;
    ClientDataSet: TClientDataSet;
    ClientDataSetmodele: TStringField;
    ClientDataSetmodelenumber: TStringField;
    ClientDataSetcouleur: TStringField;
    ClientDataSetcollection: TStringField;
    
    {$IF CompilerVersion>=22}
      procedure HTTPRIO1BeforeExecute(const MethodName: String; SOAPRequest: TStream);
    {$ELSE}
      procedure HTTPRIOBeforeExecute(const MethodName: String; var SOAPRequest: WideString);
    {$IFEND}
    procedure HTTPRIOAfterExecute(const MethodName: String; SOAPResponse: TStream);

  private
    FQuery: TIBOQuery;
    FUrl, FUser, FPwd, FGuid, FRefArt, FCodeMarque, FCollection, FCodeAdh: WideString;
    FCheminLogs, FFichierLog: String;
    FClient: IPasserelleRefDyn;
    FReponse: TRefDynResponse;
    FRapport: TStringList;

    procedure AjoutLog(const sLigne: String);
    function GetTable(const sTrigramme: String; var ListeChamps: TObjectList): String;
    procedure GetChampsTable(const sTable: String; var ListeChamps: TObjectList);
    function FormateValeur(const sChamp, sValeur: String; ListeChamps: TObjectList): String;
//    function ComparaisonValeurs(Query: TIBOQuery; ListeValeurs: TStringList): Boolean;
    function GetChrono(const sArtID: String): String;
    function Importation(ListeTraite: TStringList; const bFull: Boolean): TWebResultMultiMag;   overload;

  public
    constructor Create(Query: TIBOQuery; const sUrl, sLogin, sPassword: WideString; const sCheminLogs: String);   reintroduce;
    function CallWebservice(const sGuid, sRefArt, sCodeMarque, sCollection, sCodeAdh: WideString): TDataSet;
    function Importation: TWebResultMultiMag;   overload;
    function Importation(ListeTraite: TStringList): TWebResultMultiMag;   overload;
    destructor Destroy;   override;
  end;

var
  DM_RefDynISFMultiMag: TRefDynISFMultiMag_DM;

implementation

{ TTypeChamp }

constructor TTypeChamp.Create(const sNom: String; const nTypeChamp: Integer; const bObligatoire: Boolean);
begin
  Nom := UpperCase(sNom);

  case nTypeChamp of
    14, 37, 40:
      TypeChamp := ftString;

    7, 8, 16:
      TypeChamp := ftInteger;

    10, 11, 27:
      TypeChamp := ftFloat;

    12:
      TypeChamp := ftDate;

    13:
      TypeChamp := ftTime;

    35:
      TypeChamp := ftTimeStamp;
  end;

  Obligatoire := bObligatoire;
end;

{$R *.dfm}

constructor TRefDynISFMultiMag_DM.Create(Query: TIBOQuery; const sUrl, sLogin, sPassword: WideString; const sCheminLogs: String);
var
  sr: TSearchRec;
  DateFichier: TDateTime;
begin
  inherited Create(nil);

  FQuery := Query;
  Furl := sUrl;
  Fuser := sLogin;
  Fpwd := sPassword;
  FCheminLogs := sCheminLogs;
  FFichierLog := IncludeTrailingPathDelimiter(FCheminLogs) + 'RefDynISFMultiMag ' + FormatDateTime('yyyy-mm-dd_hh-nn-ss-zzz', Now) + '.log';

  FClient := nil;
  FReponse := nil;
  FRapport := TStringList.Create;

  // Purge logs.
  if SysUtils.FindFirst(IncludeTrailingPathDelimiter(FCheminLogs) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(sr.Name <> '.') and (sr.Name <> '..') and ((sr.Attr and faDirectory) <> faDirectory) then
      begin
        if(LowerCase(ExtractFileExt(sr.Name)) = '.log') or (LowerCase(ExtractFileExt(sr.Name)) = '.xml') then
        begin
          FileAge(IncludeTrailingPathDelimiter(FCheminLogs) + sr.Name, DateFichier);

          // Si antérieur à 3 mois.
          if CompareDateTime(DateFichier, IncMonth(Now, -3)) = LessThanValue then
            SysUtils.DeleteFile(sr.Name);
        end;
      end;
    until SysUtils.FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;
end;

{$IF CompilerVersion>=22}
procedure TRefDynISFMultiMag_DM.HTTPRIO1BeforeExecute(const MethodName: String; SOAPRequest: TStream);
var
  Fichier: TFileStream;
begin
  if FCheminLogs <> '' then
  begin
    try
      Fichier := TFileStream.Create(IncludeTrailingPathDelimiter(FCheminLogs) + FormatDateTime('yyyy-mm-dd_hh-nn-ss-zzz', Now) + '-Ask.xml', fmCreate, fmShareDenyWrite);
      SOAPRequest.Seek(0, soFromBeginning);
      Fichier.CopyFrom(SOAPRequest, SOAPRequest.Size);
    finally
      FreeAndNil(Fichier);
    end;
  end;
end;
{$ELSE}
procedure TRefDynISFMultiMag_DM.HTTPRIOBeforeExecute(const MethodName: String; var SOAPRequest: WideString);
var
  Texte: TStringList;
begin
  // Erreur Delphi 2007.
  SOAPRequest := StringReplace(SOAPRequest, '<IsInput>', '<IsInput xmlns="">', []);

  if FCheminLogs <> '' then
  begin
    if not DirectoryExists(ExtractFilePath(FCheminLogs)) then
     ForceDirectories(ExtractFilePath(FCheminLogs));
    Texte := TStringList.Create;
    try
      Texte.Add(SOAPRequest);
      Texte.SaveToFile(IncludeTrailingPathDelimiter(FCheminLogs) + FormatDateTime('yyyy-mm-dd_hh-nn-ss-zzz', Now) + '-Ask.xml');
    finally
      FreeAndNil(Texte);
    end;
  end;
end;
{$IFEND}

procedure TRefDynISFMultiMag_DM.HTTPRIOAfterExecute(const MethodName: String; SOAPResponse: TStream);
var
  Fichier: TFileStream;
begin
  if FCheminLogs <> '' then
  begin
    try
      Fichier := TFileStream.Create(IncludeTrailingPathDelimiter(FCheminLogs) + FormatDateTime('yyyy-mm-dd_hh-nn-ss-zzz', Now) + '-Ret.xml', fmCreate, fmShareDenyWrite);
      SOAPResponse.Seek(0, soFromBeginning);
      Fichier.CopyFrom(SOAPResponse, SOAPResponse.Size);
    finally
      FreeAndNil(Fichier);
    end;
  end;
end;

procedure TRefDynISFMultiMag_DM.AjoutLog(const sLigne: String);
var
  F: TextFile;
begin
  AssignFile(F, FFichierLog);
  try
    if FileExists(FFichierLog) then
      Append(F)
    else
      Rewrite(F);

    Writeln(F, '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz', Now) + ']  ' + sLigne);
  finally
    CloseFile(F);
  end;
end;

function TRefDynISFMultiMag_DM.CallWebservice(const sGuid, sRefArt, sCodeMarque, sCollection, sCodeAdh: WideString): TDataSet;
var
  vInput: TRefDynInput;
  i: Integer;
begin
  FGuid := sGuid;
  FRefArt := sRefArt;
  FCodeMarque := sCodeMarque;
  FCollection := sCollection;
  FCodeAdh := sCodeAdh;

  HTTPRIO.HTTPWebNode.UserName := FUser;
  HTTPRIO.HTTPWebNode.Password := FPwd;
  AjoutLog('Appel web-service :  GetIPasserelleRefDyn.');
  FClient := GetIPasserelleRefDyn(False, FUrl, HTTPRIO);

  if Assigned(FClient) then
  begin
    vInput := TRefDynInput.Create;
    vInput.Guid := FGuid;
    vInput.User := FUser;
    vInput.Password := FPwd;
    vInput.RefArt := FRefArt;
    vInput.CodeMarque := FCodeMarque;
    vInput.Collection := FCollection;
    vInput.CodeAdh := FCodeAdh;

    // Appel web-service.
    AjoutLog('Appel web-service :  Get_Catalog.');
    FReponse := FClient.Get_Catalog(vInput);

    if Assigned(FReponse) then
    begin
      try
        if not FReponse.IsOK then
        begin
          AjoutLog('# Erreur retour :  ' + FReponse.Erreur);
          raise Exception.Create('Erreur retour :  ' + FReponse.Erreur);
        end;
        if not Assigned(FReponse.Catalogue) then
        begin
          AjoutLog('# Erreur retour :  pas de catalogue !');
          raise Exception.Create('Erreur retour :  pas de catalogue !');
        end;

        if Length(FReponse.Catalogue.MODELLIST) > 0 then
        begin
          AjoutLog('   Liste :  ' + IntToStr(Length(FReponse.Catalogue.MODELLIST)) + '.');
          ClientDataSet.Close;
          ClientDataSet.Open;

          for i:=Low(FReponse.Catalogue.MODELLIST) to High(FReponse.Catalogue.MODELLIST) do
          begin
            ClientDataSet.Append;
            ClientDataSet.FieldByName('MODELE').AsString := FReponse.Catalogue.MODELLIST[i].DENOTATION;
            ClientDataSet.FieldByName('MODELENUMBER').AsString := Trim(FReponse.Catalogue.MODELLIST[i].MODELNUMBER);
            ClientDataSet.FieldByName('COULEUR').AsString := Trim(FReponse.Catalogue.MODELLIST[i].COLORLIST.COLORDENOTATION);
            ClientDataSet.FieldByName('COLLECTION').AsString := Trim(FReponse.Catalogue.MODELLIST[i].COLL);
            ClientDataSet.Post;
          end;
        end
        else
          AjoutLog('   Liste vide.');
      finally
        FreeAndNil(FReponse);
      end;
    end
    else
    begin
      AjoutLog('   Échec de l''appel à [Get_Catalog]: pas de réponse !');
      raise Exception.Create('Échec de l''appel à [Get_Catalog]: pas de réponse !');
    end;
  end
  else
  begin
    AjoutLog('   Échec de l''appel à [GetIPasserelleRefDyn]: pas de réponse !');
    raise Exception.Create('Échec de l''appel à [GetIPasserelleRefDyn]: pas de réponse !');
  end;

  Result := ClientDataSet;
end;

function TRefDynISFMultiMag_DM.Importation: TWebResultMultiMag;
begin
  Result := Importation(nil, True);
end;

function TRefDynISFMultiMag_DM.Importation(ListeTraite: TStringList): TWebResultMultiMag;
begin
  Result := Importation(ListeTraite, False);
end;

function TRefDynISFMultiMag_DM.GetTable(const sTrigramme: String; var ListeChamps: TObjectList): String;
begin
  Result := '';
  ListeChamps.Clear;

  if sTrigramme = 'ART' then
    Result := 'ARTARTICLE'
  else if sTrigramme = 'ARF' then
    Result := 'ARTREFERENCE'
  else if sTrigramme = 'ARX' then
    Result := 'ARTRELATIONAXE'
  else if sTrigramme = 'CAR' then
    Result := 'ARTCOLART'
  else if sTrigramme = 'CLG' then
    Result := 'TARCLGFOURN'
  else if sTrigramme = 'PVT' then
    Result := 'TARPRIXVENTE'   
  else if sTrigramme = 'TPV' then
    Result := 'TYPTARIFPRIXVTE'
  else if sTrigramme = 'COU' then
    Result := 'PLXCOULEUR'
  else if sTrigramme = 'CBI' then
    Result := 'ARTCODEBARRE'
  else if sTrigramme = 'TTV' then
    Result := 'PLXTAILLESTRAV'
  else if sTrigramme = 'AAT' then
    Result := 'ARTATTRIBUT'
  else if sTrigramme = 'AAV' then
    Result := 'ARTATTRIBVAL'
  else if sTrigramme = 'AAR' then
    Result := 'ARTATTRIBRELATION';

  if Result <> '' then
    GetChampsTable(Result, ListeChamps);
end;

procedure TRefDynISFMultiMag_DM.GetChampsTable(const sTable: String; var ListeChamps: TObjectList);
begin
  ListeChamps.Clear;

  // Recherche des champs de la table.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select RDB$RELATION_FIELDS.RDB$FIELD_NAME, RDB$FIELDS.RDB$FIELD_TYPE, RDB$NULL_FLAG');
  FQuery.SQL.Add('from RDB$RELATION_FIELDS');
  FQuery.SQL.Add('left join RDB$FIELDS on (RDB$RELATION_FIELDS.RDB$FIELD_SOURCE = RDB$FIELDS.RDB$FIELD_NAME)');
  FQuery.SQL.Add('where RDB$RELATION_NAME = upper(:NOM_TABLE)');
  FQuery.SQL.Add('and (RDB$SYSTEM_FLAG is null or RDB$SYSTEM_FLAG = 0)');
  FQuery.SQL.Add('order by RDB$FIELD_POSITION');
  try
    FQuery.ParamByName('NOM_TABLE').AsString := sTable;
    FQuery.Open;
  except
    on E: Exception do
    begin
      FQuery.IB_Transaction.Rollback;
      raise Exception.Create('Erreur :  la recherche des champs de la table [' + sTable + '] a échoué !' + #13#10 + E.Message);
    end;
  end;
  if not FQuery.IsEmpty then
  begin
    FQuery.First;
    while not FQuery.Eof do
    begin
      ListeChamps.Add(TTypeChamp.Create(FQuery.FieldByName('RDB$FIELD_NAME').AsString, FQuery.FieldByName('RDB$FIELD_TYPE').AsInteger, (FQuery.FieldByName('RDB$NULL_FLAG').AsInteger = 1)));
      FQuery.Next;
    end;
  end;
end;

function TRefDynISFMultiMag_DM.FormateValeur(const sChamp, sValeur: String; ListeChamps: TObjectList): String;
var
  i: Integer;
  sJour, sMois, sAnnee: String;
begin
  Result := sValeur;
  for i:=0 to Pred(ListeChamps.Count) do
  begin
    if TTypeChamp(ListeChamps[i]).Nom = sChamp then
    begin
      case TTypeChamp(ListeChamps[i]).TypeChamp of
        ftString:
          begin
            if sValeur = '' then
            begin
              if not TTypeChamp(ListeChamps[i]).Obligatoire then
                Result := 'null';
            end
            else
              Result := QuotedStr(sValeur);
          end;

        ftInteger:
          begin
            if sValeur = '' then
            begin
              if not TTypeChamp(ListeChamps[i]).Obligatoire then
                Result := 'null';
            end;
          end;

        ftFloat:
          begin
            if sValeur = '' then
            begin
              if not TTypeChamp(ListeChamps[i]).Obligatoire then
                Result := 'null';
            end
            else
              Result := StringReplace(sValeur, ',', '.', []);
          end;

        ftTimeStamp:
          begin
            if sValeur = '' then
            begin
              if not TTypeChamp(ListeChamps[i]).Obligatoire then
                Result := 'null';
            end
            else
            begin
              sJour := LeftStr(sValeur, 2);
              sMois := Copy(sValeur, 4, 2);
              sAnnee := Copy(sValeur, 7, 4);
              Result := QuotedStr(sAnnee + '-' + sMois + '-' + sJour + IfThen(Length(sValeur) > 10, ' ' + Copy(sValeur, 12, Length(sValeur))));
            end;
          end;
      end;

      Break;
    end;
  end;
end;

{function TRefDynISFMultiMag_DM.ComparaisonValeurs(Query: TIBOQuery; ListeValeurs: TStringList): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Query.FieldCount = ListeValeurs.Count then
  begin
    for i:=0 to Pred(Query.FieldCount) do
    begin
      if Query.Fields[i].AsString <> ListeValeurs[i] then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end; }

function TRefDynISFMultiMag_DM.GetChrono(const sArtID: String): String;
begin
  Result := '';

  // Recherche du chrono.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select ARF_CHRONO');
  FQuery.SQL.Add('from ARTREFERENCE');
  FQuery.SQL.Add('join K on (K_ID = ARF_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('where ARF_ARTID = :ARTID');
  try
    FQuery.ParamByName('ARTID').AsString := sArtID;
    FQuery.Open;
  except
    on E: Exception do
    begin
      FQuery.IB_Transaction.Rollback;
      AjoutLog('   Erreur :  la recherche du chrono a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
      raise Exception.Create('Erreur :  la recherche du chrono a échoué !' + #13#10 + E.Message);
    end;
  end;
  if not FQuery.IsEmpty then
    Result := FQuery.FieldByName('ARF_CHRONO').AsString;
end;

function TRefDynISFMultiMag_DM.Importation(ListeTraite: TStringList; const bFull: Boolean): TWebResultMultiMag;
var
  nNbErreur, i, j, k, l: Integer;
  ListeInsert, ListeUpdate, ListeValeurs: TStringList;
  vInput: TRefDynInput;
  ListeChampsK, ListeChamps: TObjectList;
  sTable, sArtID, sChrono, sChamps, sValeurs, sTmp: String;
  bNouveauModele, bMaj: Boolean;
begin
  Result.IsOK := True;
  Result.ArtId := '';
  Result.ArtNumero := '';
  Result.TexteSimple := '';

  nNbErreur := 0;      sArtID := '';      sChrono := '';
  ListeInsert := TStringList.Create;
  ListeUpdate := TStringList.Create;
  try
    try
      if not Assigned(FClient) then
        raise Exception.Create('Erreur :  objet [IPasserelleRefDyn] non créé !');

      vInput := TRefDynInput.Create;
      vInput.Guid := FGuid;
      vInput.User := FUser;
      vInput.Password := FPwd;
      vInput.RefArt := FRefArt;
      vInput.CodeMarque := FCodeMarque;
      vInput.Collection := FCollection;
      vInput.CodeAdh := FCodeAdh;
      if Assigned(ListeTraite) then
      begin
        for i:=0 to Pred(ListeTraite.Count) do
          vInput.AjoutListe(ListeTraite[i]);
      end;

      // Appel web-service.
      if bFull then
      begin
        AjoutLog('Appel web-service :  ImportationFull.');
        FReponse := FClient.ImportationFull(vInput);
      end
      else
      begin
        AjoutLog('Appel web-service :  Importation.');
        FReponse := FClient.Importation(vInput);
      end;

      if Assigned(FReponse) then
      begin
        if not FReponse.IsOK then
        begin
          AjoutLog('# Erreur retour :  ' + FReponse.Erreur);
          raise Exception.Create('Erreur retour :  ' + FReponse.Erreur);
        end;
        if not Assigned(FReponse.Catalogue) then
        begin
          AjoutLog('# Erreur retour :  pas de catalogue !');
          raise Exception.Create('Erreur retour :  pas de catalogue !');
        end;

        ListeChampsK := TObjectList.Create;
        ListeChamps := TObjectList.Create;
        ListeValeurs := TStringList.Create;
        try
          GetChampsTable('K', ListeChampsK);

          // Parcours des modèles.
          for i:=Low(FReponse.Catalogue.MODELLIST) to High(FReponse.Catalogue.MODELLIST) do
          begin
            bNouveauModele := False;      sChrono := '';
            AjoutLog('Modèle [Réf = ' + FReponse.Catalogue.MODELLIST[i].Modelnumber + ' - Nom = ' + FReponse.Catalogue.MODELLIST[i].DENOTATION + ']:');   
            if Length(FReponse.Catalogue.MODELLIST[i].SQL) = 0 then
            begin
              AjoutLog('   Pas à traiter.' + #13#10);
              Continue;
            end;

            FQuery.IB_Transaction.StartTransaction;
            try
              // Parcours des tables.
              for j:=Low(FReponse.Catalogue.MODELLIST[i].SQL) to High(FReponse.Catalogue.MODELLIST[i].SQL) do
              begin
                sTable := GetTable(FReponse.Catalogue.MODELLIST[i].SQL[j].TRIGRAMME, ListeChamps);
                if sTable = '' then
                begin
                  FQuery.IB_Transaction.Rollback;
                  AjoutLog('   Erreur :  table inconnue pour [' + FReponse.Catalogue.MODELLIST[i].SQL[j].TRIGRAMME + '] !');
                  raise Exception.Create('Erreur :  table inconnue pour [' + FReponse.Catalogue.MODELLIST[i].SQL[j].TRIGRAMME + '] !');
                end;

                // Si pas nouveau modèle, et table à ne pas traiter.
                if(not bNouveauModele) and ((sTable = 'ARTATTRIBUT') or (sTable = 'ARTATTRIBVAL') or (sTable = 'ARTATTRIBRELATION')) then
                  Continue;

                for k:=Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES) to High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES) do
                begin
                  if sTable = 'ARTARTICLE' then
                    sArtID := IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID);

                  // Contrôle du K.
                  FQuery.Close;
                  FQuery.SQL.Clear;
                  FQuery.SQL.Add('select K_ENABLED');
                  FQuery.SQL.Add('from K');
                  FQuery.SQL.Add('join ' + sTable + ' on (K_ID = ' + FReponse.Catalogue.MODELLIST[i].SQL[j].TRIGRAMME + '_ID)');
                  FQuery.SQL.Add('where K_ID = :KID');
                  try
                    FQuery.ParamByName('KID').AsInteger := FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID;
                    FQuery.Open;
                  except
                    on E: Exception do
                    begin
                      FQuery.IB_Transaction.Rollback;
                      AjoutLog('   Erreur :  le contrôle du K a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                      raise Exception.Create('Erreur :  le contrôle du K [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                    end;
                  end;
                  if FQuery.IsEmpty then
                  begin
                    AjoutLog('   Contrôle du K [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] table [' + sTable + ']: n''existe pas.');

                    if sTable = 'ARTARTICLE' then
                      bNouveauModele := True;

                    // Gestion table.
                    sChamps := '';      sValeurs := '';
                    for l:=Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA) to High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA) do
                    begin
                      sChamps := sChamps + IfThen(l > Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA), ', ') + FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].NOM;
                      sValeurs := sValeurs + IfThen(l > Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA), ', ') + FormateValeur(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].NOM, FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].VALUE, ListeChamps);

                      if UpperCase(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].NOM) = 'ARF_CHRONO' then
                      begin
                        sChrono := FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].VALUE;
                        if ListeInsert.IndexOf(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].VALUE) = -1 then
                          ListeInsert.Add(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].VALUE);
                      end;
                    end;

                    if sChrono = '' then
                      sChrono := GetChrono(sArtID);

                    // Ajout enregistrement dans table.
                    FQuery.Close;
                    FQuery.SQL.Clear;
                    FQuery.SQL.Add('insert into ' + sTable);
                    FQuery.SQL.Add('(' + sChamps + ')');
                    FQuery.SQL.Add('values(' + sValeurs + ')');
                    try
                      FQuery.ExecSQL;
                    except
                      on E: Exception do
                      begin
                        FQuery.IB_Transaction.Rollback;
                        AjoutLog('   Erreur :  l''ajout dans ' + sTable + ' a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                        raise Exception.Create('Erreur :  l''ajout dans ' + sTable + ' [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                      end;
                    end;

                    AjoutLog('   Ajout dans ' + sTable + ' :' + #13#10 + FQuery.SQL.Text);

                    // Gestion table K.
                    sChamps := '';      sValeurs := '';
                    for l:=Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K) to High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K) do
                    begin
                      sChamps := sChamps + IfThen(l > Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K), ', ') + FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].NOM;
                      if UpperCase(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].NOM) = 'K_VERSION' then
                        sValeurs := sValeurs + IfThen(l > Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K), ', ') + FormateValeur(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].NOM, '-' + FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].VALUE, ListeChampsK)
                      else
                        sValeurs := sValeurs + IfThen(l > Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K), ', ') + FormateValeur(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].NOM, FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].VALUE, ListeChampsK);
                    end;

                    // Ajout du K.
                    FQuery.Close;
                    FQuery.SQL.Clear;
                    FQuery.SQL.Add('insert into K');
                    FQuery.SQL.Add('(' + sChamps + ')');
                    FQuery.SQL.Add('values(' + sValeurs + ')');
                    try
                      FQuery.ExecSQL;
                    except
                      on E: Exception do
                      begin
                        FQuery.IB_Transaction.Rollback;
                        AjoutLog('   Erreur :  l''ajout du K a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                        raise Exception.Create('Erreur :  l''ajout du K [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                      end;
                    end;

                    AjoutLog('   Ajout du K (' + sTable + '):' + #13#10 + FQuery.SQL.Text);

                    if(sTable <> 'ARTARTICLE') and (sTable <> 'ARTREFERENCE') and (ListeUpdate.IndexOf(sChrono) = -1) and (ListeInsert.IndexOf(sChrono) = -1) then
                      ListeUpdate.Add(sChrono);
                  end
                  else      // ID existe dans table K.
                  begin
                    bMaj := False;

                    // Si enregistrement actif.
                    if FQuery.FieldByName('K_ENABLED').AsInteger = 1 then
                      AjoutLog('   Contrôle du K [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] table [' + sTable + ']: existe déjà.')
                    else if FQuery.FieldByName('K_ENABLED').AsInteger = 0 then
                    begin
                      AjoutLog('   Contrôle du K [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] table [' + sTable + ']: existe déjà à l''état supprimé.');

                      // Ré-activation du K.
                      FQuery.Close;
                      FQuery.SQL.Clear;
                      FQuery.SQL.Add('update K');
                      FQuery.SQL.Add('set K_ENABLED = 1');
                      FQuery.SQL.Add('where K_ID = ' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID));
                      try
                        FQuery.ExecSQL;
                      except
                        on E: Exception do
                        begin
                          FQuery.IB_Transaction.Rollback;
                          AjoutLog('   Erreur :  la ré-activation du K a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                          raise Exception.Create('Erreur :  la ré-activation du K [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                        end;
                      end;

                      AjoutLog('   Ré-activation du K (' + sTable + '):' + #13#10 + FQuery.SQL.Text);
                      bMaj := True;
                    end;

                    // Gestion maj table 'PLXCOULEUR'.
                    if sTable = 'PLXCOULEUR' then
                    begin
                      sValeurs := '';
                      for l:=Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA) to High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA) do
                      begin
                        if UpperCase(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].NOM) = 'COU_CODE' then
                        begin
                          sValeurs := FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].VALUE;
                          Break;
                        end;
                      end;

                      // Recherche du code de la couleur.
                      FQuery.Close;
                      FQuery.SQL.Clear;
                      FQuery.SQL.Add('select COU_CODE');
                      FQuery.SQL.Add('from PLXCOULEUR');
                      FQuery.SQL.Add('join K on (K_ID = COU_ID and K_ENABLED = 1)');
                      FQuery.SQL.Add('where COU_ID = :COUID');
                      try
                        FQuery.ParamByName('COUID').AsInteger := FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID;
                        FQuery.Open;
                      except
                        on E: Exception do
                        begin
                          FQuery.IB_Transaction.Rollback;
                          AjoutLog('   Erreur :  la recherche du code de la couleur a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                          raise Exception.Create('Erreur :  la recherche du code de la couleur [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                        end;
                      end;
                      if FQuery.IsEmpty then
                      begin
                        FQuery.IB_Transaction.Rollback;
                        AjoutLog('   Erreur :  couleur inconnue !' + #13#10#13#10 + FQuery.SQL.Text);
                        raise Exception.Create('Erreur :  couleur [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] inconnue !');
                      end
                      else
                      begin
                        // Si code différent.
                        if FQuery.FieldByName('COU_CODE').AsString <> sValeurs then
                        begin
                          // Maj du code de la couleur.
                          FQuery.Close;
                          FQuery.SQL.Clear;
                          FQuery.SQL.Add('update PLXCOULEUR');
                          FQuery.SQL.Add('set COU_CODE = ' + FormateValeur('COU_CODE', sValeurs, ListeChamps));
                          FQuery.SQL.Add('where COU_ID = ' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID));
                          try
                            FQuery.ExecSQL;
                          except
                            on E: Exception do
                            begin
                              FQuery.IB_Transaction.Rollback;
                              AjoutLog('   Erreur :  la maj du code de la couleur a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                              raise Exception.Create('Erreur :  la maj du code de la couleur [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                            end;
                          end;
                          AjoutLog('   Maj du code de la couleur (' + sTable + '):' + #13#10 + FQuery.SQL.Text);

                          // Gestion table K.
                          sChamps := '';
                          for l:=(Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K) + 1) to High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K) do
                            sChamps := sChamps + FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].NOM + ' = ' + FormateValeur(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].NOM, FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].VALUE, ListeChampsK) + IfThen(l < High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K), ', ');

                          // Maj du K.
                          FQuery.Close;
                          FQuery.SQL.Clear;
                          FQuery.SQL.Add('update K');
                          FQuery.SQL.Add('set ' + sChamps);
                          FQuery.SQL.Add('where K_ID = ' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID));
                          try
                            FQuery.ExecSQL;
                          except
                            on E: Exception do
                            begin
                              FQuery.IB_Transaction.Rollback;
                              AjoutLog('   Erreur :  la maj du K a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                              raise Exception.Create('Erreur :  la maj du K [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                            end;
                          end;

                          AjoutLog('   Maj du K (' + sTable + '):' + #13#10 + FQuery.SQL.Text);
                          bMaj := True;
                        end;
                      end;                      
                    end;

{                    // Gestion maj table 'ARTATTRIBRELATION'.
                    if sTable = 'ARTATTRIBRELATION' then
                    begin
                      sChamps := '';      ListeValeurs.Clear;
                      for l:=(Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA) + 1) to High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA) do
                      begin
                        sChamps := sChamps + FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].NOM + IfThen(l < High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA), ', ');
                        ListeValeurs.Add(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].VALUE);
                      end;

                      // Recherche des valeurs des champs.
                      FQuery.Close;
                      FQuery.SQL.Clear;
                      FQuery.SQL.Add('select ' + sChamps);
                      FQuery.SQL.Add('from ' + sTable);
                      FQuery.SQL.Add('join K on (K_ID = ' + FReponse.Catalogue.MODELLIST[i].SQL[j].TRIGRAMME + '_ID and K_ENABLED = 1)');
                      FQuery.SQL.Add('where ' + FReponse.Catalogue.MODELLIST[i].SQL[j].TRIGRAMME + '_ID = :ID');
                      try
                        FQuery.ParamByName('ID').AsInteger := FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID;
                        FQuery.Open;
                      except
                        on E: Exception do
                        begin
                          FQuery.IB_Transaction.Rollback;
                          AjoutLog('   Erreur :  la recherche des valeurs des champs de ' + sTable + ' a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                          raise Exception.Create('Erreur :  la recherche des valeurs des champs de ' + sTable + ' [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                        end;
                      end;
                      if FQuery.IsEmpty then
                      begin
                        FQuery.IB_Transaction.Rollback;
                        AjoutLog('   Erreur :  enregistrement (' + sTable + ') inconnu !' + #13#10#13#10 + FQuery.SQL.Text);
                        raise Exception.Create('Erreur :  enregistrement (' + sTable + ') [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] inconnu !');
                      end
                      else
                      begin
                        // Si différence.
                        if ComparaisonValeurs(FQuery, ListeValeurs) then
                        begin
                          sValeurs := '';
                          for l:=(Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA) + 1) to High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA) do
                            sValeurs := sValeurs + FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].NOM + ' = ' + FormateValeur(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].NOM, FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA[l].VALUE, ListeChamps) + IfThen(l < High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].DATA), ', ');

                          // Maj table.
                          FQuery.Close;
                          FQuery.SQL.Clear;
                          FQuery.SQL.Add('update ' + sTable);
                          FQuery.SQL.Add('set ' + sValeurs);
                          FQuery.SQL.Add('where ' + FReponse.Catalogue.MODELLIST[i].SQL[j].TRIGRAMME + '_ID = ' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID));
                          try
                            FQuery.ExecSQL;
                          except
                            on E: Exception do
                            begin
                              FQuery.IB_Transaction.Rollback;
                              AjoutLog('   Erreur :  la maj dans ' + sTable + ' a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                              raise Exception.Create('Erreur :  la maj dans ' + sTable + ' [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                            end;
                          end;
                          AjoutLog('   Maj dans ' + sTable + ' :' + #13#10 + FQuery.SQL.Text);

                          // Gestion table K.
                          sChamps := '';
                          for l:=(Low(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K) + 1) to High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K) do
                            sChamps := sChamps + FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].NOM + ' = ' + FormateValeur(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].NOM, FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K[l].VALUE, ListeChampsK) + IfThen(l < High(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].K), ', ');

                          // Maj du K.
                          FQuery.Close;
                          FQuery.SQL.Clear;
                          FQuery.SQL.Add('update K');
                          FQuery.SQL.Add('set ' + sChamps);
                          FQuery.SQL.Add('where K_ID = ' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID));
                          try
                            FQuery.ExecSQL;
                          except
                            on E: Exception do
                            begin
                              FQuery.IB_Transaction.Rollback;
                              AjoutLog('   Erreur :  la maj du K a échoué !' + #13#10 + E.Message + #13#10#13#10 + FQuery.SQL.Text);
                              raise Exception.Create('Erreur :  la maj du K [' + IntToStr(FReponse.Catalogue.MODELLIST[i].SQL[j].LIGNES[k].ID) + '] a échoué !' + #13#10 + E.Message);
                            end;
                          end;

                          AjoutLog('   Maj du K (' + sTable + '):' + #13#10 + FQuery.SQL.Text);
                          bMaj := True;
                        end;
                      end;
                    end; }

                    if sChrono = '' then
                      sChrono := GetChrono(sArtID);

                    if bMaj and (ListeUpdate.IndexOf(sChrono) = -1) and (ListeInsert.IndexOf(sChrono) = -1) then
                      ListeUpdate.Add(sChrono);
                  end;
                end;
              end;

              FQuery.IB_Transaction.Commit;
              AjoutLog('   Validation en base' + IfThen(sChrono <> '', ' (' + sChrono + ')') + '.' + #13#10);
            except
              on E: Exception do
              begin
                if FQuery.IB_Transaction.InTransaction then
                  FQuery.IB_Transaction.Rollback;

                sTmp := '      - réf ' + FReponse.Catalogue.MODELLIST[i].Modelnumber + ' :' + #13#10 + E.Message;
                FRapport.Append(sTmp);
                Inc(nNbErreur);
              end;
            end;
          end;
        finally
          FreeAndNil(ListeValeurs);
          FreeAndNil(ListeChampsK);
          FreeAndNil(ListeChamps);
          FreeAndNil(FReponse);
        end;
      end
      else
      begin
        AjoutLog('   Échec de l''appel à [' + IfThen(bFull, 'ImportationFull', 'Importation') + ']: pas de réponse !');
        raise Exception.Create('Échec de l''appel à [' + IfThen(bFull, 'ImportationFull', 'Importation') + ']: pas de réponse !');
      end;
    except
      on E: Exception do
      begin
        FRapport.Append('      - ' + E.Message);
      end;
    end;

    if nNbErreur > 0 then
    begin
      FRapport.Insert(0, IntToStr(nNbErreur) + IfThen(nNbErreur > 1, ' modèles', ' modèle') + ' en erreur :');
      Result.IsOK := False;
      Result.TexteSimple := IntToStr(nNbErreur) + IfThen(nNbErreur > 1, ' erreurs', ' erreur') + ' :  ' + FRapport[1];
    end
    else
      FRapport.Insert(0, '0 modèle en erreur.');

    if ListeUpdate.Count > 0 then
    begin
      ListeUpdate.Sort;
      sTmp := IntToStr(ListeUpdate.Count) + IfThen(ListeUpdate.Count > 1, ' modèles', ' modèle') + ' mis-à-jour :' + #13#10;
      for i:=0 to Pred(ListeUpdate.Count) do
        sTmp := sTmp + ListeUpdate[i] + #13#10;

      FRapport.Insert(0, sTmp);
    end
    else
      FRapport.Insert(0, '0 modèle mis-à-jour.');

    if ListeInsert.Count > 0 then
    begin
      ListeInsert.Sort;
      sTmp := IntToStr(ListeInsert.Count) + IfThen(ListeInsert.Count > 1, ' modèles ajoutés', ' modèle ajouté') + ' :  [' + ListeInsert[0] + ']';
      if ListeInsert.Count > 1 then
        sTmp := sTmp + ' à [' + ListeInsert[ListeInsert.Count - 1] + ']';

      FRapport.Insert(0, sTmp);
    end
    else
      FRapport.Insert(0, '0 modèle ajouté.');
  finally
    FreeAndNil(ListeInsert);
  end;

  Result.ArtId := sArtID;
  Result.ArtNumero := sChrono;
  Result.Texte := FRapport;
end;

destructor TRefDynISFMultiMag_DM.Destroy;
begin
  FRapport.Free;

  inherited;
end;

end.


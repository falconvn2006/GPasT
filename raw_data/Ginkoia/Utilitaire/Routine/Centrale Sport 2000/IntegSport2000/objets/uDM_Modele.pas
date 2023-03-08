unit uDM_Modele;

interface

uses SysUtils, ComObj, Classes, XMLIntf, XMLDoc, Contnrs, StrUtils, Variants,
  uModele, uCouleur, uCollection, uPrixAchat, uPrixVente, uLiaisonCollectionModele, uFournisseur, uGestionBDD, uTaille;

type
  TDM_Modele = class
  private
    FQuery: TMyQuery;

    procedure ControlesGrilleTaillesMarque(Modele: TModele);
    function GetAssociatedModele(const nIDSP2K: Integer; const bGestionFusion: Boolean): TModele;   overload;
    function GetAssociatedModele(const nCodeMarque: Integer; const sRefMrk: String; const nGtfid: Integer; const bGestionFusion: Boolean): TModele;   overload;
    procedure PostControle(Modele: TModele; aQuery: TMyQuery);

  public
    constructor Create(aQuery: TMyQuery);
    procedure save_Modeles(listModeles: TObjectList; aQuery: TMyQuery);
    procedure save_Modele(modele: TModele; aQuery: TMyQuery);
    function ModeleExiste(const nArtID: Integer; const bGestionFusion: Boolean): Boolean;
    function GetAssociatedModele(Modele: TModele; const bGestionFusion: Boolean): TModele;   overload;
    function GetModeleDestination(Modele: TModele): TModele;
    procedure EnrichirGenImport(Modele: TModele; const nIDRef: Integer);
    procedure Desarchiver(Modele: TModele);
  end;

implementation

constructor TDM_Modele.Create(aQuery: TMyQuery);
begin
  if not Assigned(aQuery) then
    raise Exception.Create('Erreur :  pas de query !');
  FQuery := aQuery;
end;

procedure TDM_Modele.save_Modeles(listModeles: TObjectList; aQuery: TMyQuery);
var
  i: Integer;
begin
  for i:=0 to listModeles.Count-1 do
    save_Modele((listModeles.Items[i] as TModele), aQuery);
end;

procedure TDM_Modele.save_Modele(modele: TModele; aQuery: TMyQuery);
var
  collection: TCollection;
  prixAchat: TPrixAchat;
  prixVente: TPrixVente;
  artcolart: TLiaisonCollectionModele;
  j: Integer;
begin
  // Creation des collections du modele
  if(modele.listCollection <> nil) and (modele.listCollection.Count > 0)then
  begin
    for j:=0 to modele.listCollection.Count-1 do
    begin
      // Creation des collections et enrichissement des liaisons -------------
      collection := modele.listCollection.Items[j] as TCollection;
      // on se limite à la création d une collection
      if (not collection.isExist) then
      begin
        collection.doSave(aQuery);
      end;
      artcolart := TLiaisonCollectionModele.create(modele,collection);
      artcolart.doLoadByArtidColid(aQuery);
      //on lie la collection et le modele
      if (not artcolart.isExist) then
      begin
        artcolart.doSave(aQuery);
      end;
    end;
  end;
  //Gestion des prix d'achat -------------
  IF (modele.listPrixAchat<>nil) then
  begin
    for j:=0 to modele.listPrixAchat.Count-1 do
    begin
      prixAchat := modele.listPrixAchat.items[j] as TPrixAchat;
      if (prixAchat.Artid <> 0) then
      begin
        prixAchat.doSave(aQuery);
      end;
    end;
  end;
  //Gestion des prix de vente -------------
  if (modele.listPrixVente <> nil) then
  begin
    for j:=0 to modele.listPrixVente.Count-1 do
    begin
      prixVente := modele.listPrixVente.items[j] as TprixVente;
      // Il est interdit de modifier un prix de vente
      if (not prixVente.isExist) then
      begin
        if (prixVente.Artid <> 0) then
        begin
          prixVente.doSave(aQuery);
        end;
      end;
    end;
  end;

  PostControle(Modele, aQuery);
end;

procedure TDM_Modele.PostControle(Modele: TModele; aQuery: TMyQuery);
var
  Query: TMyQuery;
  nClgID: Integer;
begin
  // Recherche des déclinaisons du modèle (tarifs fournisseurs).
  aQuery.Close;
  aQuery.SQL.Clear;
  aQuery.SQL.Add('select CLG_ARTID, CLG_TGFID, CLG_COUID');
  aQuery.SQL.Add('from TARCLGFOURN');
  aQuery.SQL.Add('join K on (K_ID = CLG_ID and K_ENABLED = 1)');
  aQuery.SQL.Add('where CLG_ARTID = :ARTID');
  aQuery.SQL.Add('group by CLG_ARTID, CLG_TGFID, CLG_COUID');
  aQuery.SQL.Add('order by CLG_ARTID, CLG_TGFID, CLG_COUID');
  try
    aQuery.ParamByName('ARTID').AsInteger := Modele.Id;
    aQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  if not aQuery.IsEmpty then
  begin
    Query := TMyQuery.Create(nil);
    try
      Query.IB_Connection := aQuery.IB_Connection;

      aQuery.First;
      while not aQuery.Eof do
      begin
        // Recherche si tarif fournisseur principal.
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('select CLG_ID');
        Query.SQL.Add('from TARCLGFOURN');
        Query.SQL.Add('join K on (K_ID = CLG_ID and K_ENABLED = 1)');
        Query.SQL.Add('where CLG_ARTID = :ARTID');
        Query.SQL.Add('and CLG_TGFID = :TGFID');
        Query.SQL.Add('and CLG_COUID = :COUID');
        Query.SQL.Add('and CLG_PRINCIPAL = 1');
        try
          Query.ParamByName('ARTID').AsInteger := Modele.Id;
          Query.ParamByName('TGFID').AsInteger := aQuery.FieldByName('CLG_TGFID').AsInteger;
          Query.ParamByName('COUID').AsInteger := aQuery.FieldByName('CLG_COUID').AsInteger;
          Query.Open;
        except
          on E: Exception do
          begin

            Exit;
          end;
        end;
        if Query.IsEmpty then
        begin
          // Recherche d'un tarif fournisseur.
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('select CLG_ID');
          Query.SQL.Add('from TARCLGFOURN');
          Query.SQL.Add('join K on (K_ID = CLG_ID and K_ENABLED = 1)');
          Query.SQL.Add('where CLG_ARTID = :ARTID');
          Query.SQL.Add('and CLG_TGFID = :TGFID');
          Query.SQL.Add('and CLG_COUID = :COUID');
          Query.SQL.Add('rows 1');
          try
            Query.ParamByName('ARTID').AsInteger := Modele.Id;
            Query.ParamByName('TGFID').AsInteger := aQuery.FieldByName('CLG_TGFID').AsInteger;
            Query.ParamByName('COUID').AsInteger := aQuery.FieldByName('CLG_COUID').AsInteger;
            Query.Open;
          except
            on E: Exception do
            begin

              Exit;
            end;
          end;
          if not Query.IsEmpty then
          begin
            nClgID := Query.FieldByName('CLG_ID').AsInteger;

            // Maj en principal.
            Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('update TARCLGFOURN');
            Query.SQL.Add('set CLG_PRINCIPAL = 1');
            Query.SQL.Add('where CLG_ID = :CLGID');
            try
              Query.ParamByName('CLGID').AsInteger := nClgID;
              Query.ExecSQL;
            except
              on E: Exception do
              begin

                Exit;
              end;
            end;

            // Maj K.
            Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('execute procedure pr_updatek(:CLGID, 0)');
            try
              Query.ParamByName('CLGID').AsInteger := nClgID;
              Query.ExecSQL;
            except
              on E: Exception do
              begin

                Exit;
              end;
            end;
          end;
        end;

        aQuery.Next;
      end;
    finally
      Query.Free;
    end;
  end;
end;

function TDM_Modele.ModeleExiste(const nArtID: Integer; const bGestionFusion: Boolean): Boolean;
var
  Modele, ModeleFusion: TModele;
begin
  Result := False;

  // Recherche du modèle.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select ART_ID');
  FQuery.SQL.Add('from ARTARTICLE');
  FQuery.SQL.Add('join K on (K_ID = ART_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('where ART_ID = :ARTID');
  FQuery.SQL.Add('and ART_ID <> 0');
  try
    FQuery.ParamByName('ARTID').AsInteger := nArtID;
    FQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  if not FQuery.IsEmpty then
  begin
    Modele := TModele.Create;
    Modele.Id := FQuery.FieldByName('ART_ID').AsInteger;
    Modele.doLoad(FQuery);

    // Si modèle fusionné.
    if(bGestionFusion) and (Modele.FusArtId > 0) then
    begin
      ModeleFusion := GetModeleDestination(Modele);
      if Assigned(ModeleFusion) then
      begin
        Result := True;
        if ModeleFusion <> Modele then
          ModeleFusion.Free;
      end;
    end
    else
      Result := True;

    Modele.Free;
  end;
end;

procedure TDM_Modele.ControlesGrilleTaillesMarque(Modele: TModele);
begin
  // Recherche de la grille de taille.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select TTV_ID');
  FQuery.SQL.Add('from PLXTAILLESTRAV');
  FQuery.SQL.Add('join K on (K_ID = TTV_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('where TTV_ID = :TTVID');
  try
    FQuery.ParamByName('TTVID').AsInteger := Modele.GtfId;
    FQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  if FQuery.IsEmpty then
  begin
    if(Modele.ListeTailles.Count > 0) and (Modele.ListeTailles[0] is TTaille) then
    begin
      // Recherche de la grille de taille.
      FQuery.Close;
      FQuery.SQL.Clear;
      FQuery.SQL.Add('select TGF_GTFID');
      FQuery.SQL.Add('from PLXTAILLESGF');
      FQuery.SQL.Add('join K on (K_ID = TGF_ID and K_ENABLED = 1)');
      FQuery.SQL.Add('where TGF_ID = :TGFID');
      try
        FQuery.ParamByName('TGFID').AsInteger := TTaille(Modele.ListeTailles[0]).Id;
        FQuery.Open;
      except
        on E: Exception do
        begin

          Exit;
        end;
      end;
      if not FQuery.IsEmpty then
        Modele.GtfId := FQuery.FieldByName('TGF_GTFID').AsInteger;
    end
    else
      raise Exception.Create('Erreur :  pas de tailles !');
  end;

  // Recherche du lien de la marque.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select IMP_REF');
  FQuery.SQL.Add('from GENIMPORT');
  FQuery.SQL.Add('join K on (K_ID = IMP_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('where IMP_KTBID = -11111392');
  FQuery.SQL.Add('and IMP_NUM = :IDMRK');
  try
    FQuery.ParamByName('IDMRK').AsInteger := Modele.Mrkid;
    FQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  if not FQuery.IsEmpty then
    Modele.Mrkid := FQuery.FieldByName('IMP_REF').AsInteger
  else
  begin
    // Recherche de la marque.
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Add('select MRK_ID');
    FQuery.SQL.Add('from ARTMARQUE');
    FQuery.SQL.Add('join K on (K_ID = MRK_ID and K_ENABLED = 1)');
    FQuery.SQL.Add('where upper(MRK_NOM) = upper(:MRKNOM)');
    try
      FQuery.ParamByName('MRKNOM').AsString := Modele.MrkNom;
      FQuery.Open;
    except
      on E: Exception do
      begin

        Exit;
      end;
    end;
    if not FQuery.IsEmpty then
      Modele.Mrkid := FQuery.FieldByName('MRK_ID').AsInteger
    else if Modele.isExist then
      raise Exception.Create('Erreur :  marque inconnue !');
  end;
end;

function TDM_Modele.GetAssociatedModele(Modele: TModele; const bGestionFusion: Boolean): TModele;
begin
  // Recherche par l'identifiant centrale.
  Result := GetAssociatedModele(Modele.Idref, bGestionFusion);
  if not Assigned(Result) then
  begin
    ControlesGrilleTaillesMarque(Modele);

    // Recherche par la marque et la grille de taille.
    Result := GetAssociatedModele(Modele.Mrkid, Modele.RefMrk, Modele.GtfId, bGestionFusion);
    if Assigned(Result) then
    begin
      // Ajout dans GENIMPORT.
      EnrichirGenImport(Result, Modele.Idref);
    end;
  end
  else
    Result.Idref := Modele.Idref;
end;

function TDM_Modele.GetAssociatedModele(const nIDSP2K: Integer; const bGestionFusion: Boolean): TModele;
var
  Modele: TModele;
begin
  Result := nil;

  // Recherche du modèle (GENIMPORT).
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select IMP_GINKOIA');
  FQuery.SQL.Add('from GENIMPORT join K on (K_ID = IMP_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('join ARTARTICLE on (IMP_GINKOIA = ART_ID) join K on (K_ID = ART_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('where IMP_REF = :IDREF');
  FQuery.SQL.Add('and IMP_GINKOIA <> 0');
  FQuery.SQL.Add('and IMP_NUM = 4');
  try
    FQuery.ParamByName('IDREF').AsInteger := nIDSP2K;
    FQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  if not FQuery.IsEmpty then
  begin
    Modele := TModele.Create;
    Modele.Id := FQuery.FieldByName('IMP_GINKOIA').AsInteger;
    Modele.doLoad(FQuery);

    // Si modèle fusionné.
    if(bGestionFusion) and (Modele.FusArtId > 0) then
    begin
      Result := GetModeleDestination(Modele);
      Result.FusionEtGrilleTailleDiff := (Result.GtfId <> Modele.GtfId);
      if Result.FusionEtGrilleTailleDiff then
        Result.ChronoSourceFusion := Modele.ArfChrono;

      if Modele <> Result then
        Modele.Free;
    end
    else
      Result := Modele;
  end
  else
  begin
    // Recherche du modèle.
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Add('select ART_ID,');
    FQuery.SQL.Add('case');
    FQuery.SQL.Add('   when ART_FUSARTID > 0 then 0');
    FQuery.SQL.Add('   else 1');
    FQuery.SQL.Add('end as FUSION');
    FQuery.SQL.Add('from ARTARTICLE');
    FQuery.SQL.Add('join K on (K_ID = ART_ID and K_ENABLED = 1)');
    FQuery.SQL.Add('join ARTREFERENCE on (ARF_ARTID = ART_ID)');
    FQuery.SQL.Add('where ART_IDREF = :IDREF');
    FQuery.SQL.Add('and ART_ID <> 0');
    FQuery.SQL.Add('order by ARF_ARCHIVER, FUSION, ARF_CREE desc');
    FQuery.SQL.Add('rows 1');
    try
      FQuery.ParamByName('IDREF').AsInteger := nIDSP2K;
      FQuery.Open;
    except
      on E: Exception do
      begin

        Exit;
      end;
    end;
    if not FQuery.IsEmpty then
    begin
      Modele := TModele.Create;
      Modele.Id := FQuery.FieldByName('ART_ID').AsInteger;
      Modele.doLoad(FQuery);

      // Ajout dans GENIMPORT.
      EnrichirGenImport(Modele, nIDSP2K);

      // Si modèle fusionné.
      if(bGestionFusion) and (Modele.FusArtId > 0) then
      begin
        Result := GetModeleDestination(Modele);
        Result.FusionEtGrilleTailleDiff := (Result.GtfId <> Modele.GtfId);
        if Result.FusionEtGrilleTailleDiff then
          Result.ChronoSourceFusion := Modele.ArfChrono;

        if Modele <> Result then
          Modele.Free;
      end
      else
        Result := Modele;
    end;
  end;
end;

function TDM_Modele.GetAssociatedModele(const nCodeMarque: Integer; const sRefMrk: String; const nGtfid: Integer; const bGestionFusion: Boolean): TModele;
var
  Modele: TModele;
begin
  Result := nil;

  // Recherche du modèle.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select ART_ID,');
  FQuery.SQL.Add('case');
  FQuery.SQL.Add('   when ART_FUSARTID > 0 then 0');
  FQuery.SQL.Add('   else 1');
  FQuery.SQL.Add('end as FUSION');
  FQuery.SQL.Add('from ARTARTICLE');
  FQuery.SQL.Add('join K on (K_ID = ART_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('join ARTREFERENCE on (ARF_ARTID = ART_ID)');
  FQuery.SQL.Add('where ART_MRKID = :MRKID');
  FQuery.SQL.Add('and ART_REFMRK = :REFMRK');
  FQuery.SQL.Add('and ART_GTFID = :GTFID');
  FQuery.SQL.Add('and ART_ID <> 0');
  FQuery.SQL.Add('order by ARF_ARCHIVER, FUSION, ARF_CREE desc');
  FQuery.SQL.Add('rows 1');
  try
    FQuery.ParamByName('MRKID').AsInteger := nCodeMarque;
    FQuery.ParamByName('REFMRK').AsString := sRefMrk;
    FQuery.ParamByName('GTFID').AsInteger := nGtfid;
    FQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  if not FQuery.IsEmpty then
  begin
    Modele := TModele.Create;
    Modele.Id := FQuery.FieldByName('ART_ID').AsInteger;
    Modele.doLoad(FQuery);

    // Si modèle fusionné.
    if(bGestionFusion) and (Modele.FusArtId > 0) then
    begin
      Result := GetModeleDestination(Modele);
      Result.FusionEtGrilleTailleDiff := (Result.GtfId <> Modele.GtfId);
      if Result.FusionEtGrilleTailleDiff then
        Result.ChronoSourceFusion := Modele.ArfChrono;

      if Modele <> Result then
        Modele.Free;
    end
    else
      Result := Modele;
  end;
end;

function TDM_Modele.GetModeleDestination(Modele: TModele): TModele;
var
  nArtID, nArtIDDest: Integer;
begin
  Result := nil;
  nArtID := Modele.FusArtId;
  nArtIDDest := 0;

  // Tant que modèle fusionné dans un autre.
  while(nArtID > 0) do
  begin
    nArtIDDest := nArtID;

    // Recherche du modèle destination de la fusion.
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Add('select ART_FUSARTID');
    FQuery.SQL.Add('from ARTARTICLE join K on (K_ID = ART_ID and K_ENABLED = 1)');
    FQuery.SQL.Add('join ARTREFERENCE on (ARF_ARTID = ART_ID) join K on (K_ID = ARF_ID and K_ENABLED = 1)');
    FQuery.SQL.Add('where ARF_ARCHIVER <> 0');
    FQuery.SQL.Add('and ART_FUSARTID is not null');
    FQuery.SQL.Add('and ART_FUSARTID > 0');
    FQuery.SQL.Add('and ART_ID = :ARTID');
    try
      FQuery.ParamByName('ARTID').AsInteger := nArtID;
      FQuery.Open;
    except
      on E: Exception do
      begin

        Exit;
      end;
    end;
    if not FQuery.IsEmpty then
      nArtID := FQuery.FieldByName('ART_FUSARTID').AsInteger
    else
      nArtID := 0;
  end;

  if nArtIDDest > 0 then
  begin
    Result := TModele.Create;
    Result.Id := nArtIDDest;
    Result.doLoad(FQuery);
  end
  else
    Result := Modele;
end;

procedure TDM_Modele.EnrichirGenImport(Modele: TModele; const nIDRef: Integer);
var
  nImpID: Integer;
begin
  // Recherche du lien.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select IMP_ID');
  FQuery.SQL.Add('from GENIMPORT');
  FQuery.SQL.Add('join K on (K_ID = IMP_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('where IMP_KTBID = -11111375');
  FQuery.SQL.Add('and IMP_REF = :ARTID');
  FQuery.SQL.Add('and IMP_NUM = :IDREF');
  try
    FQuery.ParamByName('ARTID').AsInteger := Modele.Id;
    FQuery.ParamByName('IDREF').AsInteger := nIDRef;
    FQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  if FQuery.IsEmpty then
  begin
    // Recherche du lien du modèle centrale.
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Add('select IMP_ID');
    FQuery.SQL.Add('from GENIMPORT');
    FQuery.SQL.Add('join K on (K_ID = IMP_ID and K_ENABLED = 1)');
    FQuery.SQL.Add('where IMP_KTBID = -11111375');
    FQuery.SQL.Add('and IMP_NUM = :IDREF');
    try
      FQuery.ParamByName('IDREF').AsInteger := nIDRef;
      FQuery.Open;
    except
      on E: Exception do
      begin

        Exit;
      end;
    end;
    if not FQuery.IsEmpty then
    begin
      nImpID := FQuery.FieldByName('IMP_ID').AsInteger;

      // Maj lien.
      FQuery.Close;
      FQuery.SQL.Clear;
      FQuery.SQL.Add('update GENIMPORT');
      FQuery.SQL.Add('set IMP_REF = :ARTID');
      FQuery.SQL.Add('where IMP_ID = :IMPID');
      try
        FQuery.ParamByName('ARTID').AsInteger := Modele.Id;
        FQuery.ParamByName('IMPID').AsInteger := nImpID;
        FQuery.ExecSQL;
      except
        on E: Exception do
        begin

          Exit;
        end;
      end;

      // Maj K.
      FQuery.Close;
      FQuery.SQL.Clear;
      FQuery.SQL.Add('execute procedure pr_updatek(:IMPID, 0)');
      try
        FQuery.ParamByName('IMPID').AsInteger := nImpID;
        FQuery.ExecSQL;
      except
        on E: Exception do
        begin

          Exit;
        end;
      end;
    end
    else
    begin
      // Ajout lien.
      FQuery.Close;
      FQuery.SQL.Clear;
      FQuery.SQL.Add('insert into GENIMPORT');
      FQuery.SQL.Add('(IMP_ID, IMP_KTBID, IMP_GINKOIA, IMP_REF, IMP_NUM, IMP_REFSTR)');
      FQuery.SQL.Add('values((select ID from pr_newk(''GENIMPORT'')), -11111375, :ARTID, :IDREF, 4, '''')');
      try
        FQuery.ParamByName('ARTID').AsInteger := Modele.Id;
        FQuery.ParamByName('IDREF').AsInteger := nIDRef;
        FQuery.ExecSQL;
      except
        on E: Exception do
        begin

          Exit;
        end;
      end;
    end;
  end;
end;

procedure TDM_Modele.Desarchiver(Modele: TModele);
begin
  if Modele.FusArtId > 0 then
    raise Exception.Create('Erreur :  modèle fusionné !');

  // Désarchive modèle.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('update ARTREFERENCE');
  FQuery.SQL.Add('set ARF_ARCHIVER = 0');
  FQuery.SQL.Add('where ARF_ID = :ARFID');
  try
    FQuery.ParamByName('ARFID').AsInteger := Modele.ArfID;
    FQuery.ExecSQL;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;

  // Maj K.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('execute procedure pr_updatek(:ARFID, 0)');
  try
    FQuery.ParamByName('ARFID').AsInteger := Modele.ArfID;
    FQuery.ExecSQL;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;

  Modele.Archive := False;
end;

end.


unit RefDynSP2K;

interface

uses XMLDoc, XMLIntf, SysUtils,
  uModele, uCollection, uPrixVente, uPrixAchat, uLiaisonCollectionModele, uDM_Modele, refDynSP2K_XmlToObj, uGestionBDD;

type
  TRefDynSP2K = class(TObject)
    private
      FQuery: TMyQuery;
      FModele: TModele;

    public
      constructor Create(AQuery: TMyQuery);   overload;
      procedure ChargeXmlSP2K(fichier: String);
      procedure saveDB();
      destructor Destroy;   override;

      procedure GetFournIdMethode(FournIdMethode: EGetFournId);
      procedure SetArtId(ArtId: Integer);
      procedure SetMrkId(MrkId: Integer);
  end;

implementation

constructor TRefDynSP2K.Create(AQuery: TMyQuery);
begin
  inherited Create;

  FQuery := AQuery;
  FModele := TModele.Create();
end;

procedure TRefDynSP2K.ChargeXmlSP2K(fichier: String);
var
  xmlObj : IXMLLISTE_ITEMType;
  tarif : IXMLTARIFType;
  document : IXMLDocument;

  cpt : Integer;
  vprixVente : TPrixVente;
  vprixAchat : TPrixAchat;
  vcollection : TCollection;
  px, pxnego, pxvi, collnom : string;
begin
  document := TXMLDocument.Create(nil);
  document.LoadFromXML(fichier);

  xmlObj := GetLISTE_ITEM(document);

  // gestion de la collection
  if (xmlObj.ITEM.COLLECTION <> '') then
  begin
    collnom := xmlObj.ITEM.COLLECTION;
  end
  else if (xmlObj.ITEM.SAISON <> '') then
  begin
    // Si le noeud 'Collection' est vide, on prend la saison
    collnom := xmlObj.ITEM.SAISON;
  end;

  // Si 'Collection' et 'Saison' vide => on n'associe pas l'article à une collection
  if (collnom <> '') then
  begin
    vcollection := TCollection.create();
    vcollection.NOM := collnom;
    vcollection.doLoadFromNom(FQuery);
    if not vcollection.isExist then
    begin
      vcollection.REFDYNA := 0;
      vcollection.NOVISIBLE := 0;
    end;
    FModele.listCollection.Add(vcollection);
  end;

  // chargement des prix
  for cpt := 0 to xmlObj.ITEM.TARIFS.Count - 1 do
  begin
    tarif := xmlObj.ITEM.TARIFS.TARIF[cpt];
    if (tarif.Fournisseur <> '') then
    begin
      px := tarif.PVI;
      if (px = '') then px := Char('0');
      px := StringReplace(px, ',', '.', [rfReplaceAll]);

      vprixVente := TPrixVente.create();
      vprixVente.Artid := FModele.Id;
      vprixVente.Px := StrToFloat(px);
      vprixVente.doLoadFromArtId(FQuery);
      if not vprixVente.isExist then
      begin
        vprixVente.Tvtid := 0;
        vprixVente.Tgfid := 0;
      end;
      FModele.listPrixVente.Add(vprixVente);

      if (tarif.PxNormalFournisseur = '') then
      begin
        px := tarif.PATARIF;
        pxnego := tarif.PANET;
        pxvi := tarif.PBARRE;
      end
      else
      begin
        px := tarif.PxNormalFournisseur;
        pxnego := tarif.PCESSION;
        pxvi := tarif.PVI;
      end;

      if (px = '') then px := Char('0');
      px := StringReplace(px, ',', '.', [rfReplaceAll]);
      if (pxnego = '') then pxnego := px;
      pxnego := StringReplace(pxnego, ',', '.', [rfReplaceAll]);
      if (pxvi = '') then pxvi := Char('0');
      pxvi := StringReplace(pxvi, ',', '.', [rfReplaceAll]);

      vprixAchat := TPrixAchat.create();
      vprixAchat.Artid := FModele.Id;

      if not Assigned(FModele.GetFournIdMethode) then
        raise Exception.Create('methode GetFournId non definit')
      else
        vprixAchat.Fouid := FModele.GetFournIdMethode(IntToStr(tarif.IDFOURNISSEUR), tarif.Fournisseur, tarif.ADR1_Fournisseur, tarif.ADR2_Fournisseur, FModele.Mrkid);

      vprixAchat.doLoadFromArtIdFouId(FQuery);
      vprixAchat.Px := StrToFloat(px);
      vprixAchat.Pxnego := StrToFloat(pxnego);
      vprixAchat.Pxvi := StrToFloat(pxvi);

      if not vprixAchat.isExist then
      begin
        vprixAchat.Tgfid := 0;
        vprixAchat.Ra1 := 0;
        vprixAchat.Ra2 := 0;
        vprixAchat.Ra3 := 0;
        vprixAchat.Taxe := 0;
        vprixAchat.Principal := 1;
      end;
      FModele.listPrixAchat.Add(vprixAchat);
    end;
      //todo : log car prix non integré
  end;
end;

procedure TRefDynSP2K.saveDB();
var
//   modele : TModele;
//   collection : TCollection;
//   prixAchat : TPrixAchat;
//   prixVente : TPrixVente;
//   artcolart : TLiaisonCollectionModele ;
   DMModele: TDM_Modele;
//   j: integer;
begin
  DMModele := TDM_Modele.Create(FQuery);
  try
    DMModele.save_Modele(FModele, FQuery);
  finally
    DMModele.Free;
  end;
   //Creation des collections du modele
//   if(Fmodel.listCollection<>nil) and (Fmodel.listCollection.Count>0)then
//   begin
//      for j :=0 to Fmodel.listCollection.Count-1 do
//      begin
//         //Creation des collections et enrichissement des liaisons -------------
//         collection := Fmodel.listCollection.Items[j] as TCollection;
//         //on se limite à la création d une collection
//         if (not collection.isExist) then
//         begin
//            collection.doSave(FQuery);
//         end;
//         artcolart := TLiaisonCollectionModele.create(Fmodel,collection);
//         artcolart.doLoadByArtidColid(FQuery);
//         //on lie la collection et le modele
//         if (not artcolart.isExist) then
//         begin
//            artcolart.doSave(FQuery);
//         end;
//      end;
//   end;
//   //Gestion des prix d'achat -------------
//   IF (Fmodel.listPrixAchat<>nil) then
//   begin
//     for j := 0 to Fmodel.listPrixAchat.Count - 1 do
//     begin  
//        prixAchat := Fmodel.listPrixAchat.items[j] as TPrixAchat;
//        prixAchat.doSave(FQuery);
//     end;
//   end;
//   //Gestion des prix de vente -------------
//   if (Fmodel.listPrixVente<>nil) then
//   begin
//     for j := 0 to Fmodel.listPrixVente.Count - 1 do
//     begin
//        prixVente := Fmodel.listPrixVente.items[j] as TprixVente;
//        // Il est interdit de modifier un prix de vente
//        if (not prixVente.isExist) then
//        begin
//           prixVente.doSave(FQuery);
//        end;
//     end;
//   end;
end;

procedure TRefDynSP2K.GetFournIdMethode(FournIdMethode: EGetFournId);
begin
  FModele.GetFournIdMethode := FournIdMethode;
end;

procedure TRefDynSP2K.SetArtId(ArtId: Integer);
begin
  FModele.Id := ArtId;
end;  

procedure TRefDynSP2K.SetMrkId(MrkId: Integer);
begin
  FModele.Mrkid := MrkId;
end;

destructor TRefDynSP2K.Destroy;
begin
  FModele.Free;

  inherited;
end;

end.


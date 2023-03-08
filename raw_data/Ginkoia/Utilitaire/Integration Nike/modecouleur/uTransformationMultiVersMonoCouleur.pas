unit uTransformationMultiVersMonoCouleur;

interface
uses SysUtils,
  ComObj,
  Classes,
  XMLIntf,
  XMLDoc,
  contnrs,
  StrUtils;

type
  TTransformationMultiVersMonoCouleur = class
  private

  const
    //Identifiants des balises XML
    sArtItems = 'ARTICLE.XML';
    sArtItem = 'ITEM';
    sArtItemID = 'ITEMID';
    sArtRFOU = 'RFOU';
    sArtCouleurs = 'COULEURS';
    sArtCouleur = 'COULEUR';
    sArtCouleurIdcoloris = 'IDCOLORIS';
    sArtCouleurCodeColoris = 'CODECOLORIS';
    sBarItems = 'BARFOU.XML';
    sBarCouleurIdcoloris = 'IDCOLORIS';
    sBarCouleurCodeColoris = 'CODECOLORIS';
    sBarRFOU = 'RFOU';
    sBarArticleid = 'ARTICLEID';
    sBarItemID = 'ITEMID';
    sDcdItems = 'DCDEFOU.XML';
    sDcdRfou = 'RFOU';
    sDcdCouleurIdcoloris = 'IDCOLORIS';
    sDcdCouleurCodeColoris = 'CODECOLORIS';
    sDcdItemID = 'ITEMID';


/// Retourne le noeud couleurs de l item
function getNodeCouleurs(nodeArtItem: IXMLNode): IXMLNode;
/// Exporter le fichier original multi et sauvegarder le message transformé en mono couleur
procedure exporterTransformationVersFichier(xml: IXMLDocument; filePath: string);
///Mettre a jour des identifiants des references pour le mode de gestion mono couleur
procedure UpdateIdentifiantsArt(item: IXMLNode);
///Mettre a jour des identifiants des references pour le mode de gestion mono couleur
procedure UpdateIdentifiantsBar(artItem: IXMLNode; barXml: IXMLDocument);
procedure UpdateIdentifiantsDcd(artItem: IXMLNode; dcdXml: IXMLDocument);

public

/// Transformer les fichiers XML depuis le mode Multi couleurs vers le mode Mono Couleurs
procedure TransformerXmlMultiVersMonoCouleurs(artFilePath: string; barFilePath: string; dcdFilePath: string);

  end;

implementation

uses
  Variants,
  VarUtils;

//------------------------------------------------------------------------------------------------------------------
// ------------------- PUBLIC---------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

/// Transformer les fichiers XML depuis le mode Multi couleurs vers le mode Mono Couleurs

procedure TTransformationMultiVersMonoCouleur.TransformerXmlMultiVersMonoCouleurs(artFilePath: string; barFilePath: string; dcdFilePath: string);
var
  xmlART: IXMLDocument;
  xmlBAR: IXMLDocument;
  xmlDCD: IXMLDocument;
  hasCommandes: boolean;
  nodeItems, nodeItem, nodeCouleurs, nodeCouleur, nodeItemTemp, nodeCouleurTemp, nodeCouleursTemp: IXMLNode;
  listNodesCouleurs: TObjectList;
  i: integer;
  rfouArt, codecolorisArt, idcolorisArt: string;
begin
  nodeItems := nil;
  nodeItem := nil;
  nodeCouleurs := nil;
  nodeCouleur := nil;
  hasCommandes := fileExists(dcdFilePath);
  // chargement des données XML des fichiers dans les variables XMLDocuments
  xmlART := TXMLDocument.Create(nil);
  xmlART.LoadFromFile(artFilePath);
  xmlBAR := TXMLDocument.Create(nil);
  xmlBAR.LoadFromFile(barFilePath);
  if (hasCommandes) then
  begin
    xmlDCD := TXMLDocument.Create(nil);
    xmlDCD.LoadFromFile(dcdFilePath);
  end
  else
  begin
    xmlDCD := nil;
  end;

  if ((xmlART <> nil) and (xmlBAR <> nil)) then
  begin
    //xmlART.Active := true; // a verifier
    nodeITems := xmlART.DocumentElement;
    if (nodeITems <> nil) and (nodeITems.NodeName = sArtItems) then
    begin
      for i := 0 to nodeItems.ChildNodes.Count - 1 do
      begin
        nodeItem := nodeITems.ChildNodes.get(i);
        // recuperation des noeuds de couleur
        nodeCouleurs := getNodeCouleurs(nodeItem);
        // Pour chaque couleur additionnelle, nous allons construire une nouvelle fiche modele
        if (nodeCouleurs.HasChildNodes) then
        begin
          while nodeCouleurs.ChildNodes.Count > 1 do
          begin
            nodeCouleur := nodeCouleurs.ChildNodes.First;
            //suppression de la couleur de l ensemble des couleurs de la fiche modele initiale
            nodeCouleurs.ChildNodes.Remove(nodeCouleur);
            //construction d un nouveau noeud pour une nouvelle fiche article mono couleur
            nodeItemTemp := nodeItem.CloneNode(true);
            nodeCouleursTemp := getNodeCouleurs(nodeItemTemp);
            nodeCouleursTemp.ChildNodes.Clear;
            //ajout de la couleur a la nouvelle fiche modele
            nodeCouleursTemp.ChildNodes.Add(nodeCouleur);
            nodeITems.ChildNodes.add(nodeItemTemp);
            UpdateIdentifiantsArt(nodeItemTemp);
            //Mise a jour des codes barres associés
            UpdateIdentifiantsBar(nodeItemTemp, xmlBAR);
            UpdateIdentifiantsDcd(nodeItemTemp, xmlDCD);
          end;
          UpdateIdentifiantsArt(nodeItem);
          UpdateIdentifiantsBar(nodeItem, xmlBAR);
          UpdateIdentifiantsDcd(nodeItem, xmlDCD);
        end;
      end;
      exporterTransformationVersFichier(xmlART, artFilePath);
      exporterTransformationVersFichier(xmlBAR, barFilePath);
      exporterTransformationVersFichier(xmlDCD, dcdFilePath);
    end;
  end;
end;

//------------------------------------------------------------------------------------------------------------------
// ------------------- PRIVATE ------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

/// Retourne le noeud couleurs de l item

function TTransformationMultiVersMonoCouleur.getNodeCouleurs(nodeArtItem: IXMLNode): IXMLNode;
var
  node: IXMLNode;
  i: integer;
begin
  node := nil;
  Result := nil;
  if (nodeArtItem <> nil) then
  begin
    //recherche du noeud COULEURS
    for i := 0 to nodeArtItem.ChildNodes.Count - 1 do
    begin
      node := nodeArtItem.ChildNodes.get(i);
      if (node.NodeName = sArtCouleurs) and (Result = nil) then
      begin
        Result := node;
      end;
    end;
  end;
end;

/// Exporter le fichier original multi et sauvegarder le message transformé en mono couleur

procedure TTransformationMultiVersMonoCouleur.exporterTransformationVersFichier(xml: IXMLDocument; filePath: string);
begin
  if (xml <> nil) and (filePath <> '') then
  begin
    RenameFile(filePath, filePath + '.multi');
    xml.SaveToFile(filePath);
  end;
end;

///Mettre a jour des identifiants des references pour le mode de gestion mono couleur

procedure TTransformationMultiVersMonoCouleur.UpdateIdentifiantsArt(item: IXMLNode);
var
  rfouOld, itemidOld, codecolorisOld, idcolorisOld: string;
  rfouNew, itemidNew, codecolorisNew, idcolorisNew: string;
  nodeCouleurs, nodeCouleur: IXMLNode;
begin
  nodeCouleurs := getNodeCouleurs(item);
  nodeCouleur := nodeCouleurs.ChildNodes.First;
  //mise a jour des valeurs des champs du noeud ART
  rfouOld := VarToStr(item.ChildNodes.FindNode(sArtRFOU).NodeValue);
  codecolorisOld := VarToStr(nodeCouleur.ChildNodes.FindNode(sArtCouleurCodeColoris).NodeValue);
  idcolorisOld := VarToStr(nodeCouleur.ChildNodes.FindNode(sArtCouleurIdcoloris).NodeValue);
  rfouNew := rfouOld + '-' + codecolorisOld;
  itemidNew := idcolorisOld;
  item.ReadOnly := false;
  item.ChildNodes.FindNode(sArtRFOU).NodeValue := rfouNew;
  item.ChildNodes.FindNode(sArtItemID).NodeValue := itemidNew;
end;

///Mettre a jour des identifiants des references pour le mode de gestion mono couleur

procedure TTransformationMultiVersMonoCouleur.UpdateIdentifiantsBar(artItem: IXMLNode; barXml: IXMLDocument);
var
  rfouArt, rfouArtAvantTransformation, codecolorisArt, idColorisArt: string;
  rfouBar, itemidBar, codecolorisBar, idcolorisBar: string;
  nodeCouleursArt, nodeCouleurArt: IXMLNode;
  nodeCouleursBar, nodeCouleurBar: IXMLNode;
  root, nodeItemBar: IXMLNode;
  i: integer;
  isArtBarLinked: boolean;
begin
  // recuperation des valeurs utiles dans le noeud de l'item ART
  rfouArt := VarToStr(artItem.ChildNodes.FindNode(sArtRFOU).NodeValue);
  nodeCouleursArt := getNodeCouleurs(artItem);
  nodeCouleurArt := nodeCouleursArt.ChildNodes.First;
  codecolorisArt := VarToStr(nodeCouleurArt.ChildNodes.FindNode(sArtCouleurCodeColoris).NodeValue);
  idColorisArt := VarToStr(nodeCouleurArt.ChildNodes.FindNode(sArtCouleurIdcoloris).NodeValue);
  //recupérer la valeur originale de la valeur rfou de l ART
  rfouArtAvantTransformation := stringreplace(rfouArt, '-' + codecolorisArt, '', [rfReplaceAll, rfIgnoreCase]);
  // parcours des item BAR et mise a jour si lie a la fiche modele
  root := barXml.DocumentElement;
  if (root <> nil) and (root.NodeName = sBarItems) then
  begin
    for i := 0 to root.ChildNodes.Count - 1 do
    begin
      nodeItemBar := root.ChildNodes.get(i);
      rfouBar := VarToStr(nodeItemBar.ChildNodes.FindNode(sBarRFOU).NodeValue);
      codecolorisBar := VarToStr(nodeItemBar.ChildNodes.FindNode(sBarCouleurCodeColoris).NodeValue);
      idcolorisBar := VarToStr(nodeItemBar.ChildNodes.FindNode(sBarCouleurIdcoloris).NodeValue);
      isArtBarLinked := ((rfouBar = rfouArtAvantTransformation + '*' + codecolorisArt) and (idColorisArt = idcolorisBar) and (codecolorisArt = codecolorisBar));
      if (isArtBarLinked) then
      begin
        nodeItemBar.ChildNodes.FindNode(sBarItemID).NodeValue := idColorisArt;
        nodeItemBar.ChildNodes.FindNode(sBarRFOU).NodeValue := rfouArtAvantTransformation + '-' + codecolorisArt + '*' + codecolorisArt;
        nodeItemBar.ChildNodes.FindNode(sBarArticleid).NodeValue := idColorisArt;
      end;
    end;
  end;
end;

///Mettre a jour des identifiants des references pour le mode de gestion mono couleur

procedure TTransformationMultiVersMonoCouleur.UpdateIdentifiantsDcd(artItem: IXMLNode; dcdXml: IXMLDocument);
var
  rfouArt, rfouArtAvantTransformation, codecolorisArt, idColorisArt: string;
  rfouDcd, itemidDcd, codecolorisDcd, idcolorisDcd: string;
  nodeCouleursArt, nodeCouleurArt: IXMLNode;
  nodeCouleursDcd, nodeCouleurDcd: IXMLNode;
  root, nodeItemBar: IXMLNode;
  i: integer;
  isArtDcdLinked: boolean;
begin
  // recuperation des valeurs utiles dans le noeud de l'item ART
  rfouArt := VarToStr(artItem.ChildNodes.FindNode(sArtRFOU).NodeValue);
  nodeCouleursArt := getNodeCouleurs(artItem);
  nodeCouleurArt := nodeCouleursArt.ChildNodes.First;
  codecolorisArt := VarToStr(nodeCouleurArt.ChildNodes.FindNode(sArtCouleurCodeColoris).NodeValue);
  idColorisArt := VarToStr(nodeCouleurArt.ChildNodes.FindNode(sArtCouleurIdcoloris).NodeValue);
  //recupérer la valeur originale de la valeur rfou de l ART
  rfouArtAvantTransformation := stringreplace(rfouArt, '-' + codecolorisArt, '', [rfReplaceAll, rfIgnoreCase]);
  if (dcdXml <> nil) then
  begin
    // parcours des item DCD et mise a jour si lie a la fiche modele
    root := dcdXml.DocumentElement;
    if (root <> nil) and (root.NodeName = sDcdItems) then
    begin
      for i := 0 to root.ChildNodes.Count - 1 do
      begin
        nodeItemBar := root.ChildNodes.get(i);
        rfouDcd := VarToStr(nodeItemBar.ChildNodes.FindNode(sDcdRfou).NodeValue);
        codecolorisDcd := VarToStr(nodeItemBar.ChildNodes.FindNode(sDcdCouleurCodeColoris).NodeValue);
        idcolorisDcd := VarToStr(nodeItemBar.ChildNodes.FindNode(sDcdCouleurIdcoloris).NodeValue);
        isArtDcdLinked := ((rfouDcd = rfouArtAvantTransformation + '*' + codecolorisArt) and (idColorisArt = idcolorisDcd) and (codecolorisArt = codecolorisDcd));
        if (isArtDcdLinked) then
        begin
          nodeItemBar.ChildNodes.FindNode(sDcdRfou).NodeValue := rfouArtAvantTransformation + '-' + codecolorisArt + '*' + codecolorisArt;
        end;
      end;
    end;
  end;
end;

end.


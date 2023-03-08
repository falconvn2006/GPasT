unit Yellis_DM;

interface

uses
  SysUtils, Classes, Forms, DB, UPost, Variants, IB_Components, IBODataSet,
  Provider, Contnrs, DBClient, Xmlxform, xmldom, Main_Frm, Dialogs,
  XMLDoc, XMLIntf, Constante_CBR, Erreur_CBR;

type
  TFYellis_DM = class(TDataModule)
    cds_Fichiers: TClientDataSet;
    cds_Fichiersid_fic: TIntegerField;
    cds_Fichiersid_ver: TIntegerField;
    cds_Fichiersfichier: TWideStringField;
    cds_Fichierscrc: TStringField;
    cds_Version: TClientDataSet;
    cds_Specifique: TClientDataSet;
    cds_Clients: TClientDataSet;
    cds_PlageMAJ: TClientDataSet;
    cds_Histo: TClientDataSet;
    cds_Clientsid: TIntegerField;
    cds_Clientssite: TStringField;
    cds_Clientsnom: TStringField;
    cds_Clientsversion: TIntegerField;
    cds_Clientspatch: TIntegerField;
    cds_Clientsversion_max: TIntegerField;
    cds_Clientsspe_patch: TIntegerField;
    cds_Clientsspe_fait: TIntegerField;
    cds_Clientsbckok: TDateTimeField;
    cds_Clientsdernbck: TDateTimeField;
    cds_Clientsresbck: TStringField;
    cds_Clientsblockmaj: TIntegerField;
    cds_Clientsnompournous: TStringField;
    cds_Clientsdernbckok: TIntegerField;
    cds_Clientsbasepantin: TIntegerField;
    cds_Clientspriseencompte: TIntegerField;
    cds_Clientsclt_machine: TStringField;
    cds_Clientsclt_centrale: TStringField;
    cds_Clientsclt_guid: TStringField;
    cds_Clientsnewid: TIntegerField;
    cds_Specifiquespe_id: TIntegerField;
    cds_Specifiquespe_cltid: TIntegerField;
    cds_Specifiquespe_fichier: TStringField;
    cds_Specifiquespe_fait: TIntegerField;
    cds_Specifiquespe_date: TDateField;
    cds_Specifiquenewid: TIntegerField;
    cds_Versionid: TIntegerField;
    cds_Versionversion: TStringField;
    cds_Versionnomversion: TStringField;
    cds_Versionpatch: TIntegerField;
    cds_VersionEAI: TStringField;
    cds_Versionnewid: TIntegerField;
    cds_Histoid: TIntegerField;
    cds_Histoid_cli: TIntegerField;
    cds_Histoladate: TDateTimeField;
    cds_Histoaction: TIntegerField;
    cds_Histoactionstr: TStringField;
    cds_Histoval1: TIntegerField;
    cds_Histoval2: TIntegerField;
    cds_Histoval3: TIntegerField;
    cds_Histostr1: TStringField;
    cds_Histostr2: TStringField;
    cds_Histostr3: TStringField;
    cds_Histofait: TIntegerField;
    cds_Histonewid: TIntegerField;
    cds_PlageMAJplg_id: TIntegerField;
    cds_PlageMAJplg_datedeb: TDateTimeField;
    cds_PlageMAJplg_datefin: TDateTimeField;
    cds_PlageMAJplg_cltid: TIntegerField;
    cds_PlageMAJplg_versionmax: TIntegerField;
    cds_PlageMAJnewid: TIntegerField;
    cds_Fichiersnewid: TIntegerField;
  private
    function  XmlStrToFloat(Value: OleVariant): Extended;
    function  XmlStrToDate(Value: OleVariant): TDateTime;
    function  XmlStrToInt(Value: OleVariant; DefaultInt : Integer = 0): Integer;
    function  XmlStrToStr(Value: OleVariant): string;

    function  ChargementXML_Clients   (vpCDS : TClientDataSet; vpNoeud : IXMLNode) : Integer;
    function  ChargementXML_Fichiers  (vpCDS : TClientDataSet; vpNoeud : IXMLNode) : Integer;
    function  ChargementXML_Histo     (vpCDS : TClientDataSet; vpNoeud : IXMLNode) : Integer;
    function  ChargementXML_PlageMAJ  (vpCDS : TClientDataSet; vpNoeud : IXMLNode) : Integer;
    function  ChargementXML_specifique(vpCDS : TClientDataSet; vpNoeud : IXMLNode) : Integer;
    function  ChargementXML_Version   (vpCDS : TClientDataSet; vpNoeud : IXMLNode) : Integer;

//    function  CopierYellisVersMaintenance(vpTable : TTypeMaTable) : Boolean;

//    function  ViderTable(vpQuery : TIB_Cursor; vpTable : String) : Boolean;
//    function  IndiqueClientDataSet(vpTable : TTypeMaTable) : TClientDataSet;
//
//    function  Add_SQL(vpTable : TTypeMaTable;
//                      vpQueryDestination : TIB_Cursor) : Integer;
//
//    function  SQL_Emetteur(vpQueryOrigine : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
//    function  SQL_Fichiers(vpQueryOrigine : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
//    function  SQL_Histo(vpQueryOrigine : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
//    function  SQL_PlageMAJ(vpQueryOrigine : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
//    function  SQL_Specifique(vpQueryOrigine : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
//    function  SQL_Version(vpQueryOrigine : TClientDataSet; vpQueryDestination : TIB_Cursor) : Integer;
  public
    function  RecuperationXML(vpRepertoireXML : String; vpTable : TTypeMaTable) : Integer;

    function  ChargementXML(vpChemin : String; vpProvenance : TTypeTableProvenance) : Integer;
  end;

var
  FYellis_DM: TFYellis_DM;

implementation

{$R *.dfm}

uses Maintenance_DM;


//------------------------------------------------------------------------------
//                                                             +---------------+
//                                                             |   FORMATAGE   |
//                                                             +---------------+
//------------------------------------------------------------------------------
{$REGION ' Formatage des XML'}
function TFYellis_DM.XmlStrToStr(Value: OleVariant): string;
begin
  if not VarIsNull(Value) and not VarIsType(Value,varUnknown) then
    Result := Trim(Value)
  else
    Result := '';
end;

function TFYellis_DM.XmlStrToFloat(Value: OleVariant): Extended;
var
  TpS: string;
begin
  try
    if VarIsNull(Value) or VarIsType(Value,varUnknown) then
    begin
      Result := 0;
      Exit;
    end;

    //test si les bons caractères sont mis au bon endroit
    //mechant mais, ils n'ont qu'à prendre ATIPIC
    TpS := XmlStrToStr(Value);
    if Pos(',', TpS)>0 then  //il ne faut pas de virgule !
    begin
      raise Exception.Create(TpS + ' ne doit pas avoir de , comme séparateur décimal');
    end;

    TpS[Pos('.',TpS)] := DecimalSeparator;
    Result := StrToFloat(TpS);

  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TFYellis_DM.XmlStrToDate(Value: OleVariant): TDateTime;
var
  d, m, y : Word;
  TpS: string;
begin
  Result := 0;

  if Value = '0' then
  begin
    Result := EncodeDate(1899, 12, 30);
    Exit;
  end;

  if not VarIsNull(Value) and not VarIsType(Value,varUnknown) then
  begin
    try
      y := StrToIntDef(Copy(Value, 1, 4), 1899);
      m := StrToIntDef(Copy(Value, 6, 2), 1);
      d := StrToIntDef(Copy(Value, 9, 2), 1);

      Result := EncodeDate(y, m, d);

    except on E:Exception do
      raise Exception.Create('XmlStrToDate -> ' + E.Message);
    end;
  end;
end;

function TFYellis_DM.XmlStrToInt(Value: OleVariant; DefaultInt : Integer): Integer;
begin
  try
    if Not VarIsNull(Value) and not VarIsType(Value,varUnknown) then
      Result := StrToIntDef(Trim(Value),DefaultInt)
    else
      Result := DefaultInt;

  except on E:Exception do
    raise Exception.Create(E.Message);
  end;
end;
{$ENDREGION ' Formatage '}
//------------------------------------------------------------------------------
//                                                     +-----------------------+
//                                                     |   RECUPERATION  XML   |
//                                                     +-----------------------+
//------------------------------------------------------------------------------
{$REGION ' Récupération XML '}
//---------------------------------------------------------> RecuperationXML

function TFYellis_DM.RecuperationXML(vpRepertoireXML : String;
vpTable : TTypeMaTable) : Integer;
var
  TC    : TConnexion;
  vStrl : TStringList;
begin
  Result := 0;
  TC     := TConnexion.create;
  vStrl  := TStringList.Create;

  try
    // Récupération du fichier XML
    case vpTable.TypeProvenance of
      tpClients    : vStrl.Add(TC.Select('select * from clients where id > '        + IntToStr(vpTable.Last_Id)));
      tpFichiers   : vStrl.Add(TC.Select('select * from fichiers where id_fic > '   + IntToStr(vpTable.Last_Id)));
      tpHisto      : vStrl.Add(TC.Select('select * from histo where id > '          + IntToStr(vpTable.Last_Id)) + ' and ladate >= ''20130101''');
      tpPlageMAJ   : vStrl.Add(TC.Select('select * from plageMAJ where plg_id > '   + IntToStr(vpTable.Last_Id)));
      tpSpecifique : vStrl.Add(TC.Select('select * from specifique where spe_id > ' + IntToStr(vpTable.Last_Id)));
      tpVersion    : vStrl.Add(TC.Select('select * from version  where id > '       + IntToStr(vpTable.Last_Id)));
    end;

    // copie en local vers le répértoire crée
    case vpTable.TypeProvenance of
      tpClients    : vStrl.SaveToFile(vpRepertoireXML + '\Yellis_Clients.xml');
      tpFichiers   : vStrl.SaveToFile(vpRepertoireXML + '\Yellis_Fichiers.xml');
      tpHisto      : vStrl.SaveToFile(vpRepertoireXML + '\Yellis_Histo.xml');
      tpPlageMAJ   : vStrl.SaveToFile(vpRepertoireXML + '\Yellis_PlageMAJ.xml');
      tpSpecifique : vStrl.SaveToFile(vpRepertoireXML + '\Yellis_Specifique.xml');
      tpVersion    : vStrl.SaveToFile(vpRepertoireXML + '\Yellis_Version.xml');
    end;

    // copie vers les CDS
    case vpTable.TypeProvenance of
      tpClients    : Result := ChargementXML(vpRepertoireXML + '\Yellis_Clients.xml',    vpTable.TypeProvenance);
      tpFichiers   : Result := ChargementXML(vpRepertoireXML + '\Yellis_Fichiers.xml',   vpTable.TypeProvenance);
      tpHisto      : Result := ChargementXML(vpRepertoireXML + '\Yellis_Histo.xml',      vpTable.TypeProvenance);
      tpPlageMAJ   : Result := ChargementXML(vpRepertoireXML + '\Yellis_PlageMAJ.xml',   vpTable.TypeProvenance);
      tpSpecifique : Result := ChargementXML(vpRepertoireXML + '\Yellis_Specifique.xml', vpTable.TypeProvenance);
      tpVersion    : Result := ChargementXML(vpRepertoireXML + '\Yellis_Version.xml',    vpTable.TypeProvenance);
    end;

  finally
    freeandNil(vStrl);
    TC.Free;
  end;
end;

//-----------------------------------------------------------> ChargementXML

function TFYellis_DM.ChargementXML(vpChemin : String;
vpProvenance : TTypeTableProvenance) : Integer;
var
  vXml : IXMLDocument;
  vNoeudLigne, vXmlBase, vNoeudXML : IXMLNode;
begin
  Result := 0;

  // Si le fichier n'existe pas, on sort
  if not FileExists(vpChemin) then
    raise Exception.Create('fichier : "' + vpChemin + '" non trouvé');

  try
  // Gestion du Xml
    try
      vXml := TXMLDocument.Create(nil);

      vXml.LoadFromFile(vpChemin);
      vXml.Options := vXml.Options - [doNodeAutoCreate];

      vXmlBase := vXml.DocumentElement;

      // on pointe vers le noeud <LIGNES>
      vNoeudXML   := vXmlBase.ChildNodes.Nodes[1];
      vNoeudLigne := vNoeudXML.ChildNodes['LIGNE'];

      // on enregistre les données dans le ClientDataSet
      case vpProvenance of
        tpClients    : Result := ChargementXML_Clients(cds_Clients, vNoeudLigne);
        tpFichiers   : Result := ChargementXML_Fichiers(cds_Fichiers, vNoeudLigne);
        tpHisto      : Result := ChargementXML_Histo(cds_Histo, vNoeudLigne);
        tpPlageMAJ   : Result := ChargementXML_PlageMAJ(cds_PlageMAJ, vNoeudLigne);
        tpSpecifique : Result := ChargementXML_Specifique(cds_Specifique, vNoeudLigne);
        tpVersion    : Result := ChargementXML_Version(cds_Version, vNoeudLigne);
      end;
    except
      Result := -1;
    end;

  finally
    vXml := nil;
    TXMLDocument(vXml).Free;
  end;
end;
{$ENDREGION ' Récupération XML '}
//------------------------------------------------------------------------------
//                                                            +----------------+
//                                                            |   CHARGEMENT   |
//                                                            +----------------+
//------------------------------------------------------------------------------
{$REGION ' Chargement '}
//---------------------------------------------------> ChargementXML_Clients

function TFYellis_DM.ChargementXML_Clients(vpCDS : TClientDataSet;
vpNoeud  : IXMLNode) : Integer;
var
  vErreur : TErreur;
begin
  Result := 0;

  try
    with vpCDS do
    begin
      EmptyDataSet;

      Close;
      Open;

      while vpNoeud <> nil do
      begin
        try
          Append;

          FieldByName('id').AsInteger            := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['id']);
          FieldByName('site').AsString           := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['site']);
          FieldByName('nom').AsString            := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['nom']);
          FieldByName('version').AsInteger       := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['version']);
          FieldByName('patch').AsInteger         := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['patch']);
          FieldByName('version_max').AsInteger   := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['version_max']);
          FieldByName('spe_patch').AsInteger     := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['spe_patch']);
          FieldByName('spe_fait').AsInteger      := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['spe_fait']);
          FieldByName('bckok').AsDateTime        := FYellis_DM.XmlStrToDate(vpNoeud.ChildValues['bckok']);
          FieldByName('dernbck').AsDateTime      := FYellis_DM.XmlStrToDate(vpNoeud.ChildValues['dernbck']);
          FieldByName('resbck').AsString         := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['resbck']);
          FieldByName('blockmaj').AsInteger      := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['blockmaj']);
          FieldByName('nompournous').AsString    := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['nompournous']);
          FieldByName('dernbckok').AsInteger     := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['dernbckok']);
          FieldByName('basepantin').AsInteger    := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['basepantin']);
          FieldByName('priseencompte').AsInteger := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['priseencompte']);
          FieldByName('clt_machine').AsString    := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['clt_machine']);
          FieldByName('clt_centrale').AsString   := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['clt_centrale']);
          FieldByName('clt_guid').AsString       := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['clt_GUID']);
          FieldByName('newid').AsInteger         := 0;

          Post;
        except
          // Si on ne parvient pas à lire la ligne, on ecrit le log mais on continue
          on E : Exception do
          begin
            {$REGION ' Ecriture du log d''erreur '}
            vErreur := TErreur.Create;
            vErreur.AddError('Clients', 'Chargement-XML',
            'Erreur durant le chargement de la ligne :' + intToStr(vpCDS.RecNo)
            + chr(13) + E.Message, vpCDS.RecNo, 0);
            vgObjlLog.Add(vErreur);
            {$ENDREGION}
          end;
        end;

        vpNoeud := vpNoeud.NextSibling;
      end;

      Result := RecordCount;
    end;

  except
    // Si une erreur générale est levée, on sort du chargement
    raise Exception.Create('Import Erreur Clients');
    Result := -1;
  end;
end;

//---------------------------------------------------> ChargementXML_Fichier

function TFYellis_DM.ChargementXML_Fichiers(vpCDS : TClientDataSet;
vpNoeud  : IXMLNode) : Integer;
var
  vErreur : TErreur;
begin
  Result := 0;

  try
    with vpCDS do
    begin
      EmptyDataSet;

      Close;
      Open;

      while vpNoeud <> nil do
      begin
        try
          Append;

          FieldByName('id_fic').AsInteger := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['id_fic']);
          FieldByName('id_ver').AsInteger := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['id_ver']);
          FieldByName('fichier').AsString := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['fichier']);
          FieldByName('crc').AsString     := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['crc']);
          FieldByName('newid').AsInteger  := 0;

          Post;

        except
          // Si on ne parvient pas à lire la ligne, on ecrit le log mais on continue
          on E : Exception do
          begin
            {$REGION ' Ecriture du log d''erreur '}
            vErreur := TErreur.Create;
            vErreur.AddError('Fichiers', 'Chargement-XML',
            'Erreur durant le chargement de la ligne :' + intToStr(vpCDS.RecNo)
            + chr(13) + E.Message, vpCDS.RecNo, 0);
            vgObjlLog.Add(vErreur);
            {$ENDREGION}
          end;
        end;

        vpNoeud := vpNoeud.NextSibling;
      end;

      Result := RecordCount;
    end;

  except
    // Si une erreur générale est levée, on sort du chargement
    raise Exception.Create('Import Erreur Fichiers');
    Result := -1;
  end;
end;


//-----------------------------------------------------> ChargementXML_Histo

function TFYellis_DM.ChargementXML_Histo(vpCDS : TClientDataSet;
vpNoeud  : IXMLNode) : Integer;
var
  vErreur : TErreur;
begin
  Result := 0;

  try
    with vpCDS do
    begin
      EmptyDataSet;

      Close;
      Open;

      while vpNoeud <> nil do
      begin
        try
          Append;

          FieldByName('id').AsInteger       := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['id']);
          FieldByName('id_cli').AsInteger   := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['id_cli']);
          FieldByName('ladate').AsDateTime  := FYellis_DM.XmlStrToDate(vpNoeud.ChildValues['ladate']);
          FieldByName('action').AsInteger   := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['action']);
          FieldByName('actionstr').AsString := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['actionstr']);
          FieldByName('val1').AsInteger     := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['val1']);
          FieldByName('val2').AsInteger     := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['val2']);
          FieldByName('val3').AsInteger     := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['val3']);
          FieldByName('str1').AsString      := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['str1']);
          FieldByName('str2').AsString      := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['str2']);
          FieldByName('str3').AsString      := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['str3']);
          FieldByName('fait').AsInteger     := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['fait']);
          FieldByName('newid').AsInteger    := 0;

          Post;

        except
          // Si on ne parvient pas à lire la ligne, on ecrit le log mais on continue
          on E : Exception do
          begin
            {$REGION ' Ecriture du log d''erreur '}
            vErreur := TErreur.Create;
            vErreur.AddError('Histo', 'Chargement-XML',
            'Erreur durant le chargement de la ligne :' + intToStr(vpCDS.RecNo)
            + chr(13) + E.Message, vpCDS.RecNo, 0);
            vgObjlLog.Add(vErreur);
            {$ENDREGION}
          end;
        end;

        vpNoeud := vpNoeud.NextSibling;
      end;

      Result := RecordCount;
    end;

  except
    // Si une erreur générale est levée, on sort du chargement
    raise Exception.Create('Import Erreur Histo');
    Result := -1;
  end;
end;

//--------------------------------------------------> ChargementXML_PalgeMAJ

function TFYellis_DM.ChargementXML_PlageMAJ(vpCDS : TClientDataSet;
vpNoeud  : IXMLNode) : Integer;
var
  vErreur : TErreur;
begin
  Result := 0;

  try
    with vpCDS do
    begin
      EmptyDataSet;

      Close;
      Open;

      while vpNoeud <> nil do
      begin
        try
          Append;

          FieldByName('plg_id').AsInteger         := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['plg_id']);
          FieldByName('plg_datedeb').AsDateTime   := FYellis_DM.XmlStrToDate(vpNoeud.ChildValues['plg_datedeb']);
          FieldByName('plg_datefin').AsDateTime   := FYellis_DM.XmlStrToDate(vpNoeud.ChildValues['plg_datefin']);
          FieldByName('plg_cltid').AsInteger      := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['plg_cltid']);
          FieldByName('plg_versionmax').AsInteger := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['plg_versionmax']);
          FieldByName('newid').AsInteger          := 0;

          Post;

        except
          // Si on ne parvient pas à lire la ligne, on ecrit le log mais on continue
          on E : Exception do
          begin
            {$REGION ' Ecriture du log d''erreur '}
            vErreur := TErreur.Create;
            vErreur.AddError('PlageMAJ', 'Chargement-XML',
            'Erreur durant le chargement de la ligne :' + intToStr(vpCDS.RecNo)
            + chr(13) + E.Message, vpCDS.RecNo, 0);
            vgObjlLog.Add(vErreur);
            {$ENDREGION}
          end;
        end;

        vpNoeud := vpNoeud.NextSibling;
      end;

      Result := RecordCount;
    end;

  except
    // Si une erreur générale est levée, on sort du chargement
    raise Exception.Create('Import Erreur PlageMAG');
    Result := -1;
  end;
end;

//------------------------------------------------> ChargementXML_Specifique

function TFYellis_DM.ChargementXML_Specifique(vpCDS : TClientDataSet;
vpNoeud  : IXMLNode) : Integer;
var
  vErreur : TErreur;
begin
  Result := 0;

  try
    with vpCDS do
    begin
      EmptyDataSet;

      Close;
      Open;

      while vpNoeud <> nil do
      begin
        try
          Append;

          FieldByName('spe_id').AsInteger     := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['spe_id']);
          FieldByName('spe_cltid').AsInteger  := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['spe_cltid']);
          FieldByName('spe_fichier').AsString := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['spe_fichier']);
          FieldByName('spe_fait').AsInteger   := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['spe_fait']);
          FieldByName('spe_date').AsDateTime  := FYellis_DM.XmlStrToDate(vpNoeud.ChildValues['spe_date']);
          FieldByName('newid').AsInteger      := 0;

          Post;
        except
          // Si on ne parvient pas à lire la ligne, on ecrit le log mais on continue
          on E : Exception do
          begin
            {$REGION ' Ecriture du log d''erreur '}
            vErreur := TErreur.Create;
            vErreur.AddError('Specifique', 'Chargement-XML',
            'Erreur durant le chargement de la ligne :' + intToStr(vpCDS.RecNo)
            + chr(13) + E.Message, vpCDS.RecNo, 0);
            vgObjlLog.Add(vErreur);
            {$ENDREGION}
          end;
        end;

        vpNoeud := vpNoeud.NextSibling;
      end;

      Result := RecordCount;
    end;

  except
    // Si une erreur générale est levée, on sort du chargement
    raise Exception.Create('Import Erreur Specifique');
    Result := -1;
  end;
end;

//---------------------------------------------------> ChargementXML_Version

function TFYellis_DM.ChargementXML_Version(vpCDS : TClientDataSet;
vpNoeud  : IXMLNode) : Integer;
var
  vErreur : TErreur;
begin
  Result := 0;

  try
    with vpCDS do
    begin
      EmptyDataSet;

      Close;
      Open;

      while vpNoeud <> nil do
      begin
        try
          Append;

          FieldByName('id').AsInteger        := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['id']);
          FieldByName('version').AsString    := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['version']);
          FieldByName('nomversion').AsString := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['nomversion']);
          FieldByName('patch').AsInteger     := FYellis_DM.XmlStrToInt(vpNoeud.ChildValues['patch']);
          FieldByName('EAI').AsString        := FYellis_DM.XmlStrToStr(vpNoeud.ChildValues['EAI']);
          FieldByName('newid').AsInteger     := 0;

          Post;
        except
          // Si on ne parvient pas à lire la ligne, on ecrit le log mais on continue
          on E : Exception do
          begin
            {$REGION ' Ecriture du log d''erreur '}
            vErreur := TErreur.Create;
            vErreur.AddError('Version', 'Chargement-XML',
            'Erreur durant le chargement de la ligne :' + intToStr(vpCDS.RecNo)
            + chr(13) + E.Message, vpCDS.RecNo, 0);
            vgObjlLog.Add(vErreur);
            {$ENDREGION}
          end;
        end;

        vpNoeud := vpNoeud.NextSibling;
      end;

      Result := RecordCount;
    end;

  except
    // Si une erreur générale est levée, on sort du chargement
    raise Exception.Create('Import Erreur Version');
    Result := -1;
  end;
end;
{$ENDREGION ' Chargement '}


//             +-------------------------------------------+
//             |  CBR - Version plus utile pour le moment  |
//             +-------------------------------------------+

{$REGION ' CBR - Version de copie simple de Yellis vers maintenance (sans ConsoMonitor) '}
//-----------------------------------------------------------> CopierLaTable

//function TFYellis_DM.CopierYellisVersMaintenance(vpTable : TTypeMaTable) : Boolean;
//var
//  vLig, vNbLigne, vMonId   : Integer;
//  vNbErreur, vNbTraite     : Integer;
//  vIdSansErreur, vIdTraite : Integer;
//  vDetailErreur : String;
//  vTableACopier : TClientDataSet;
//  vQueryTEMP : TIB_Cursor;
//begin
//  Result        := False;
//  vNbErreur     := 0;
//  vNbTraite     := 0;
//  vIdTraite     := vpTable.Last_IdSVG;
//  vIdSansErreur := vpTable.Last_IdSVG;
//  vDetailErreur := '';
//
//  vQueryTEMP := TIB_Cursor.Create(self);
//
//  vQueryTEMP.IB_Connection  := FMaintenance_DM.IbC_Maintenance;
//  vQueryTEMP.IB_Transaction := FMaintenance_DM.IBT_Maj;
//{                                  // Si le vidage de la table a échoué, on sort
//  if not ViderTable(vQueryTEMP, vpTable.Libelle) then
//  begin
//    FMain.RenseignerLog(vpTable.Libelle, 0, 0, 'Impossible de vider la table');
//    Exit;
//  end;   }
//
//  vTableACopier := IndiqueClientDataSet(vpTable);
//                                  // Si l'initialisation de la table a échoué, on sort
//  if vTableACopier = nil then
//  begin
//    ShowMessage('Table non trouvée');
//    Exit;
//  end;
//                                  // on se place sur le premier enregistrement de la table
//  vTableACopier.First;
//
//  with vQueryTEMP do
//    while not vTableACopier.Eof do
//    begin
//      SQL.Clear;
//
//      IB_Transaction.StartTransaction;
//
//      try                         // écrit la commande SQL et ramène l'ID de la ligne insérée
//        vMonId := Add_SQL(vpTable, vQueryTEMP);
//
//        ExecSQL;
//
//        Close;
//
//        IB_Transaction.Commit;
//                                  // Si Enregistrement OK, on conserve l'ID
//        vIdTraite := vMonId;
//      except
//        INC(vNbErreur);
//
//        vIdSansErreur := vIdTraite;
//        vDetailErreur := vDetailErreur + ',' + IntToStr(vMonId);
//
//        IB_Transaction.RollBack;
//      end;
//
//      INC(vNbTraite);
//
//      vTableACopier.Next;
//    end;
//
//  // On stock les infos pour les logs et pour la table pour l'enregistrer ensuite
//  FMain.RenseignerLog(vpTable.Libelle, vNbTraite, vNbErreur, vDetailErreur);
//  FMain.RenseignerTable(vpTable, vIdTraite, vIdSansErreur);
//
//  Result := True;
//end;
//
////-----------------------------------------------------> IndiqueTableACopier
//
//function TFYellis_DM.IndiqueClientDataSet(vpTable : TTypeMaTable) : TClientDataSet;
//var
//  vMonCDS : TClientDataSet;
//begin
//  vMonCDS := nil;
//
//  case vpTable.TypeProvenance of
//    tpClients    : vMonCDS := cds_Clients;
//    tpFichiers   : vMonCDS := cds_Fichiers;
//    tpHisto      : vMonCDS := cds_Histo;
//    tpPlageMAJ   : vMonCDS := cds_PlageMAJ;
//    tpSpecifique : vMonCDS := cds_Specifique;
//    tpVersion    : vMonCDS := cds_Version;
//  end;
//
//  Result := vMonCDS;
//end;
//
////--------------------------------------------------------------> ViderTable
//
//function TFYellis_DM.ViderTable(vpQuery : TIB_Cursor; vpTable : String) : Boolean;
//begin
//  with vpQuery do
//  begin
//    SQL.Clear;
//    IB_Transaction.StartTransaction;
//
//    try
//      try
//        SQL.Add(' DELETE');
//        SQL.Add(' FROM ' + vpTable);
//
//        ExecSQL;
//
//        Close;
//
//        IB_Transaction.Commit;
//
//        Result := True;
//      except
//        Result := False;
//
//        IB_Transaction.RollBack;
//      end;
//
//    finally
//      //
//    end;
//  end;
//end;

////-----------------------------------------------------------------> Add_SQL
//
//function TFYellis_DM.Add_SQL(vpTable : TTypeMaTable; vpQueryDestination : TIB_Cursor) : Integer;
//begin
//  Result := 0;
//
//  case vpTable.TypeProvenance of
//    tpClients    : Result := SQL_Emetteur  (cds_Clients,    vpQueryDestination);
//    tpFichiers   : Result := SQL_Fichiers  (cds_Fichiers,   vpQueryDestination);
//    tpHisto      : Result := SQL_Histo     (cds_Histo,      vpQueryDestination);
//    tpPlageMAJ   : Result := SQL_PlageMAJ  (cds_PlageMAJ,   vpQueryDestination);
//    tpSpecifique : Result := SQL_Specifique(cds_Specifique, vpQueryDestination);
//    tpVersion    : Result := SQL_Version   (cds_Version,    vpQueryDestination);
//  end;
//end;
//
////------------------------------------------------------------> SQL_Emetteur
//
//function TFYellis_DM.SQL_Emetteur(vpQueryOrigine: TClientDataSet;
//vpQueryDestination : TIB_Cursor) : Integer;
//var
//  vMonId, vNewIdVersion : Integer;
//begin
//  if not (vpQueryOrigine.Active) then
//    vpQueryOrigine.Open;
//
//  with vpQueryDestination do
//  begin
//    SQL.Clear;
//
//    vMonId := FMain.GenID('EMETTEUR');
//
//    if vMonId <> 0 then
//      if cds_Version.Locate('id', vpQueryOrigine.FieldByName('version').AsInteger, []) then
//      begin
//        vNewIdVersion := cds_Version.FieldByName('newid').AsInteger;
//
//        SQL.Add(' INSERT INTO EMETTEUR ');
//        SQL.Add(' (EMET_ID, EMET_NOM, VER_ID, EMET_PATCH,  ');
//        SQL.Add(' ,EMET_VERSION_MAX, EMET_SPE_PATCH, EMET_SPE_FAIT ');
//        SQL.Add(' ,EMET_BCKOK, EMET_DERNBCK, EMET_RESBCK, EMET_GUID, EMET_idYellis) ');
//        SQL.Add(' VALUES ');
//        SQL.Add('(' + IntToStr(vMonId));
//        SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('nom').AsString));
//        SQL.Add(',' + IntToStr(vNewIdVersion));
//        SQL.Add(',' + vpQueryOrigine.FieldByName('patch').AsString);
//        SQL.Add(',' + vpQueryOrigine.FieldByName('version_max').AsString);
//        SQL.Add(',' + vpQueryOrigine.FieldByName('spe_patch').AsString);
//        SQL.Add(',' + vpQueryOrigine.FieldByName('spe_fait').AsString);
//        SQL.Add(',' + QuotedStr(DateToStr(vpQueryOrigine.FieldByName('bckok').AsDateTime)));
//        SQL.Add(',' + QuotedStr(DateToStr(vpQueryOrigine.FieldByName('dernbck').AsDateTime)));
//        SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('resbck').AsString));
//        SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('clt_guid').AsString) + ')');
//
//        vpQueryOrigine.FieldByName('NewId').AsInteger := vMonId;
//      end;
//  end;
//
//  Result := vMonId;
//end;
//
////------------------------------------------------------------> SQL_Fichiers
//
//function TFYellis_DM.SQL_Fichiers(vpQueryOrigine: TClientDataSet;
//vpQueryDestination : TIB_Cursor) : Integer;
//var
//  vMonId, vNewIdVersion : Integer;
//begin
//  if not (vpQueryOrigine.Active) then
//    vpQueryOrigine.Open;
//
//  with vpQueryDestination do
//  begin
//    SQL.Clear;
//
//    vMonId := FMain.GenID('FICHIERS');
//
//    if vMonId <> 0 then
//      if cds_Version.Locate('id', vpQueryOrigine.FieldByName('id_ver').AsInteger, []) then
//      begin
//        vNewIdVersion := cds_Version.FieldByName('newid').AsInteger;
//
//        SQL.Add(' INSERT INTO FICHIERS ');
//        SQL.Add(' (FIC_ID, VER_ID, FIC_FICHIER, FIC_CRC) ');
//        SQL.Add(' VALUES ');
//        SQL.Add('(' + IntToStr(vMonId));
//        SQL.Add(',' + IntToStr(vNewIdVersion));
//        SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('fichier').AsString));
//        SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('crc').AsString) + ')');
//
//        vpQueryOrigine.FieldByName('NewId').AsInteger := vMonId;
//      end;
//  end;
//
//  Result := vMonId;
//end;
//
////---------------------------------------------------------------> SQL_Histo
//
//function TFYellis_DM.SQL_Histo(vpQueryOrigine: TClientDataSet;
//vpQueryDestination : TIB_Cursor) : Integer;
//var
//  vMonId, vNewIdClient : Integer;
//begin
//  if not (vpQueryOrigine.Active) then
//    vpQueryOrigine.Open;
//
//  with vpQueryDestination do
//  begin
//    SQL.Clear;
//
//    vMonId := FMain.GenID('HISTO');
//
//    if vMonId <> 0 then
//      if cds_Clients.Locate('id', vpQueryOrigine.FieldByName('id_cli').AsInteger, []) then
//      begin
//        vNewIdClient := cds_Clients.FieldByName('newid').AsInteger;
//
//        SQL.Add(' INSERT INTO HISTO ');
//        SQL.Add(' (HISTO_ID, EMET_ID, HISTO_LADATE, HISTO_ACTION,  ');
//        SQL.Add(' ,HISTO_ACTIONSTR, HISTO_VAL1, HISTO_VAL2, HISTO_VAL3 ');
//        SQL.Add(' ,HISTO_STR1, HISTO_STR2, HISTO_STR3, HISTO_FAIT) ');
//        SQL.Add(' VALUES ');
//        SQL.Add('(' + IntToStr(vMonId));
//        SQL.Add(',' + IntToStr(vNewIdClient));
//        SQL.Add(',' + QuotedStr(DateToStr(vpQueryOrigine.FieldByName('ladate').AsDateTime)));
//        SQL.Add(',' + vpQueryOrigine.FieldByName('action').AsString);
//        SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('actionstr').AsString));
//        SQL.Add(',' + vpQueryOrigine.FieldByName('val1').AsString);
//        SQL.Add(',' + vpQueryOrigine.FieldByName('val2').AsString);
//        SQL.Add(',' + vpQueryOrigine.FieldByName('val3').AsString);
//        SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('str1').AsString));
//        SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('str').AsString));
//        SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('str').AsString));
//        SQL.Add(',' + vpQueryOrigine.FieldByName('fait').AsString + ')');
//
//        vpQueryOrigine.FieldByName('NewId').AsInteger := vMonId;
//      end;
//  end;
//
//  Result := vMonId;
//end;
//
////------------------------------------------------------------> SQL_PlageMAJ
//
//function TFYellis_DM.SQL_PlageMAJ(vpQueryOrigine: TClientDataSet;
//vpQueryDestination : TIB_Cursor) : Integer;
//var
//  vMonId, vNewIdClient : Integer;
//begin
//  if not (vpQueryOrigine.Active) then
//    vpQueryOrigine.Open;
//
//  with vpQueryDestination do
//  begin
//    SQL.Clear;
//
//    vMonId := FMain.GenID('PLAGEMAJ');
//
//    if vMonId <> 0 then
//      if cds_Clients.Locate('id', vpQueryOrigine.FieldByName('plg_cltid').AsInteger, []) then
//      begin
//        vNewIdClient := cds_Clients.FieldByName('newid').AsInteger;
//
//        SQL.Add(' INSERT INTO PLAGEMAJ ');
//        SQL.Add(' (PLG_ID, EMET_ID, PLG_DATEDEB, PLG_DATEFIN, PLG_VERSIONMAX) ');
//        SQL.Add(' VALUES ');
//        SQL.Add('(' + IntToStr(vMonId));
//        SQL.Add(',' + IntToStr(vNewIdClient));
//        SQL.Add(',' + QuotedStr(DateToStr(vpQueryOrigine.FieldByName('plg_datedeb').AsDateTime)));
//        SQL.Add(',' + QuotedStr(DateToStr(vpQueryOrigine.FieldByName('plg_datefin').AsDateTime)));
//        SQL.Add(',' + vpQueryOrigine.FieldByName('plg_versionmax').AsString + ')');
//
//        vpQueryOrigine.FieldByName('NewId').AsInteger := vMonId;
//      end;
//  end;
//
//  Result := vMonId;
//end;
//
////----------------------------------------------------------> SQL_Specifique
//
//function TFYellis_DM.SQL_Specifique(vpQueryOrigine: TClientDataSet;
//vpQueryDestination : TIB_Cursor) : Integer;
//var
//  vMonId, vNewIdClient : Integer;
//begin
//  if not (vpQueryOrigine.Active) then
//    vpQueryOrigine.Open;
//
//  with vpQueryDestination do
//  begin
//    SQL.Clear;
//
//    vMonId := FMain.GenID('SPECIFIQUE');
//
//    if vMonId <> 0 then
//      if cds_Clients.Locate('id', vpQueryOrigine.FieldByName('spe_cltid').AsInteger, []) then
//      begin
//        vNewIdClient := cds_Clients.FieldByName('newid').AsInteger;
//
//        SQL.Add(' INSERT INTO SPECIFIQUE ');
//        SQL.Add(' (SPE_ID, EMET_ID, SPE_FICHIER, SPE_FAIT, SPE_DATE) ');
//        SQL.Add(' VALUES ');
//        SQL.Add('(' + IntToStr(vMonId));
//        SQL.Add(',' + IntToStr(vNewIdClient));
//        SQL.Add(',' + QuotedStr(DateToStr(vpQueryOrigine.FieldByName('plg_datedeb').AsDateTime)));
//        SQL.Add(',' + QuotedStr(DateToStr(vpQueryOrigine.FieldByName('plg_datefin').AsDateTime)));
//        SQL.Add(',' + vpQueryOrigine.FieldByName('plg_versionmax').AsString + ')');
//
//        vpQueryOrigine.FieldByName('NewId').AsInteger := vMonId;
//      end;
//  end;
//
//  Result := vMonId;
//end;
//
////-------------------------------------------------------------> SQL_Version
//
//function TFYellis_DM.SQL_Version(vpQueryOrigine: TClientDataSet;
//vpQueryDestination : TIB_Cursor) : Integer;
//var
//  vMonId : Integer;
//begin
//  if not (vpQueryOrigine.Active) then
//    vpQueryOrigine.Open;
//
//  with vpQueryDestination do
//  begin
//    SQL.Clear;
//
//    vMonId := FMain.GenID('VERSION');
//
//    if vMonId <> 0 then
//    begin
//      SQL.Add(' INSERT INTO VERSION ');
//      SQL.Add(' (VER_ID, VER_VERSION, VER_NOMVERSION, VER_PATCH, VER_EAI) ');
//      SQL.Add(' VALUES ');
//      SQL.Add('(' + IntToStr(vMonId));
//      SQL.Add(',' + vpQueryOrigine.FieldByName('version').AsString);
//      SQL.Add(',' + QuotedStr(DateToStr(vpQueryOrigine.FieldByName('nomversion').AsDateTime)));
//      SQL.Add(',' + vpQueryOrigine.FieldByName('patch').AsString);
//      SQL.Add(',' + QuotedStr(vpQueryOrigine.FieldByName('EAI').AsString) + ')');
//
//      vpQueryOrigine.FieldByName('NewId').AsInteger := vMonId;
//    end;
//  end;
//
//  Result := vMonId;
//end;

{$ENDREGION}

end.

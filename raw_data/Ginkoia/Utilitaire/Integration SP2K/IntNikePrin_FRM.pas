//$Log:
// 5    Utilitaires1.4         31/03/2010 15:35:17    Thierry Fleisch Ajout
//      d'un mail de rapport en pi?ce jointe
// 4    Utilitaires1.3         31/03/2010 12:18:00    Thierry Fleisch
//      Correction probl?me mail
// 3    Utilitaires1.2         16/02/2010 16:31:04    Lionel ABRY     Maj
// 2    Utilitaires1.1         16/02/2010 12:11:56    Lionel ABRY    
//      Modifications apr?s premiers test
// 1    Utilitaires1.0         15/02/2010 15:41:31    Lionel ABRY     
//$
//$NoKeywords$
//
UNIT IntNikePrin_FRM;

INTERFACE

USES

  XMLCursor,
  ShellApi,
  StdXML_TLB,
  registry,
  Inifiles,
  //ConfNike_frm,
  uRapport,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  Menus,
  Db,
  dxmdaset,
  IBCustomDataSet,
  IBStoredProc,
  IBDatabase,
  IBQuery,
  LMDCustomComponent,
  LMDContainerComponent,
  LMDBaseDialog,
  LMDAboutDlg,
  ExtCtrls;

TYPE
  TFrm_IntNikePrin = CLASS(TForm)
    Pb1: TProgressBar;
    Pb2: TProgressBar;
    Lab_Etat1: TLabel;
    Lab_etat2: TLabel;
    MemFou: TdxMemData;
    MemFouITEMID: TStringField;
    MemFouCFOU: TStringField;
    MemFouLFOU: TStringField;
    MenEntTail: TdxMemData;
    MenEntTailITEMID: TStringField;
    MenEntTailCTAI: TStringField;
    MenEntTailLTAI: TStringField;
    MenLigTail: TdxMemData;
    MenLigTailITEMID: TStringField;
    MenLigTailTAILLE: TStringField;
    MenArt: TdxMemData;
    MenArtITEMID: TStringField;
    MenArtLIBELLE: TStringField;
    MenArtCCOU: TStringField;
    MenArtCR1: TStringField;
    MenArtCFAM: TStringField;
    MenArtCSAI: TStringField;
    MenArtANNEE: TStringField;
    MenArtCTAI: TStringField;
    MenArtCFOU: TStringField;
    MenArtRFOU: TStringField;
    MenArtMARQUE: TStringField;
    MenArtLIBFRS: TStringField;
    MenArtFEDAS: TStringField;
    MenArtPA: TStringField;
    MenArtPV: TStringField;
    MenCB: TdxMemData;
    MenCBITEMID: TStringField;
    MenCBRFOU: TStringField;
    MenCBGESCOM: TStringField;
    MenCBLTAI: TStringField;
    MenCBBARRE: TStringField;
    MenEntCom: TdxMemData;
    MenEntComITEMID: TStringField;
    MenEntComNUMCDE: TStringField;
    MenEntComCFOU: TStringField;
    MenEntComDCDE: TStringField;
    MenEntComCMAG: TStringField;
    MenEntComDLIV: TStringField;
    MenEntComCSAI: TStringField;
    MenEntComANNEE: TStringField;
    MenEntComLLCLI: TStringField;
    MenEntComLADR1: TStringField;
    MenEntComLCPOS: TStringField;
    MenEntComLVILLES: TStringField;
    MenLigCom: TdxMemData;
    MenLigComITEMID: TStringField;
    MenLigComNUMCDE: TStringField;
    MenLigComRFOU: TStringField;
    MenLigComLTAIL: TStringField;
    MenLigComQTE: TStringField;
    MenLigComPA: TStringField;
    MenLigTailTRAVAIL: TIntegerField;
    MenEntTailVALIDE: TIntegerField;
    Data: TIBDatabase;
    Tran: TIBTransaction;
    IBST_NewKey: TIBStoredProc;
    QRY_Div: TIBQuery;
    Qry_Div2: TIBQuery;
    MenEntTailGTF_ID: TIntegerField;
    MenLigTailTGF_ID: TIntegerField;
    MemFouFOU_ID: TIntegerField;
    MemFouMRK_ID: TIntegerField;
    MenArtSSF_ID: TIntegerField;
    MenArtART_ID: TIntegerField;
    MenArtARF_ID: TIntegerField;
    MenArtFOU_ID: TIntegerField;
    MenArtMRK_ID: TIntegerField;
    MenArtGTF_ID: TIntegerField;
    IBST_CB: TIBStoredProc;
    MenEntComMAG_ID: TIntegerField;
    MenSSF: TdxMemData;
    MenSSFSSF_ID: TIntegerField;
    MenSSFSSF_NOM: TStringField;
    MenSSFSSF_FEDAS: TStringField;
    MemD_ArtCol: TdxMemData;
    MemD_ArtColArt: TdxMemData;
    MemD_ArtColCOL_ID: TIntegerField;
    MemD_ArtColCOL_NOM: TStringField;
    MemD_ArtColArtCAR_ID: TIntegerField;
    MemD_ArtColArtCAR_ARTID: TIntegerField;
    MemD_ArtColArtCAR_COLID: TIntegerField;
    MenSSFSSF_OK: TIntegerField;
    MemD_Marque: TdxMemData;
    MemD_MarqueMARQUE: TStringField;
    MemD_MarqueMRK_ID: TIntegerField;
    MemD_Liais: TdxMemData;
    MemD_LiaisFOU_ID: TIntegerField;
    MemD_LiaisMRK_ID: TIntegerField;
    MemD_COU: TdxMemData;
    MemD_COUIDCOLORIS: TStringField;
    MemD_COUCODECOLORIS: TStringField;
    MemD_COUDESCRIPTIF: TStringField;
    MemD_COUITEMID: TStringField;
    MenLigComCODECOLORIS: TStringField;
    MemD_COUCOU_ID: TIntegerField;
    MemD_COUART_ID: TIntegerField;
    MenCBCODECOLORIS: TStringField;
    MenArtCATMAN: TStringField;
    MenCBARTICLEID: TStringField;
    MenLigComARTICLEID: TStringField;
    MenEntTailNOM: TStringField;
    MemFouIDMARQUE: TStringField;
    MemFouIDFOURNISSEUR: TStringField;
    MenLigTailCODETAILLE: TStringField;
    MenArtIDMARQUE: TStringField;
    MenArtIDFOURNISSEUR: TStringField;
    MenArtPANET: TStringField;
    MenArtCOLLECTION: TStringField;
    MenArtGENRESP2K: TStringField;
    MenArtREFERENCECENTRALE: TStringField;
    MenCBIDCOLORIS: TStringField;
    MenCBCODETAILLE: TStringField;
    MenEntComIDMARQUE: TStringField;
    MenEntComIDFOURNISSEUR: TStringField;
    MenLigComIDCOLORIS: TStringField;
    MenLigComCODETAILLE: TStringField;
    MenLigComPANET: TStringField;
    MemD_MarqueIDMARQUE: TStringField;
    MemFouMARQUE: TStringField;
    MemD_COUVALIDE: TIntegerField;
    MenArtGRE_ID: TIntegerField;
    MenArtPVI: TStringField;
    MemD_Genre: TdxMemData;
    MemD_GenreGRE_ID: TIntegerField;
    MemD_GenreGRE_NOM: TStringField;
    MemD_GenreGRE_SEXE: TIntegerField;
    MenArtWEB: TStringField;
    MenArtACTIVITE: TStringField;
    MenArtSPECIFICITE: TStringField;
    MemD_Web: TdxMemData;
    MemD_WebICL_ID: TIntegerField;
    MemD_WebICL_NOM: TStringField;
    MemD_ACTIVITE: TdxMemData;
    MemD_Specifique: TdxMemData;
    MemD_ACTIVITEICL_NOM: TStringField;
    MemD_SpecifiqueICL_ID: TIntegerField;
    MemD_SpecifiqueICL_NOM: TStringField;
    MemD_ACTIVITEICL_ID: TIntegerField;
    Tim_Integrer: TTimer;
    Que_Identite: TIBQuery;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE Tim_IntegrerTimer(Sender: TObject);
  PRIVATE
    FluxJanvier2008: Boolean;
    FluxEM: Boolean;
    FUNCTION Traitement(rep: STRING): integer;
    FUNCTION Verif(S: STRING): Boolean;
    FUNCTION UneClef: Integer;
    PROCEDURE QRY(S: ARRAY OF STRING);
    PROCEDURE Importe(NOM: STRING);
    FUNCTION InsertK(Clef: Integer; Table: STRING): TStringList;
    PROCEDURE AjouteScr(Script: TstringList; S: ARRAY OF STRING);
    PROCEDURE AjouteScrQry(Script: TstringList; Table, Champs,
      Valeur: STRING; Valu: ARRAY OF CONST);
    PROCEDURE MajScrQry(Script: TstringList; Table, Champs: STRING; Valu: ARRAY OF CONST; Cle, CleValeur: STRING);
    FUNCTION AjoutCleScript(Script: TstringList; TABLE: STRING): Integer;
    PROCEDURE QRYEVO(Quoi, Table, Ref, Where: STRING);
    FUNCTION transforme(XML: IXMLCursor): TStringList;
    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
    LesFichiers: TstringList;
    //    QttMaxArt: Integer;

    RepXML, repxml1, repxml2, Lame, emplacement: STRING;
    Labase: STRING;
    CPA_ID: Integer; // A paramètrer
    SAISON: Integer;
    TYP_ID: Integer;
    pasFEDAS: Integer;
    Resultat: TstringList;
    ResRapportcourt : TStringList;
    ParametrageAFaire: Boolean;
    traite : boolean; //signale si le traitement c'est bien déroulé ou pas
  END;

VAR
  Frm_IntNikePrin: TFrm_IntNikePrin;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TFrm_IntNikePrin.FormCreate(Sender: TObject);
BEGIN
  DecimalSeparator := '.';
  lab_etat1.caption := '';
  lab_etat2.caption := '';

  pasFEDAS := 0;
  CPA_ID := 234;
  TYP_ID := -101408013;
END;

FUNCTION TFrm_IntNikePrin.UneClef: Integer;
BEGIN
  IBST_NewKey.Prepare;
  IBST_NewKey.ExecProc;
  Result := IBST_NewKey.Parambyname('NEWKEY').AsInteger;
  IBST_NewKey.UnPrepare;
  IBST_NewKey.Close;
END;

PROCEDURE TFrm_IntNikePrin.QRY(S: ARRAY OF STRING);
VAR
  i: Integer;
BEGIN
  QRY_Div.Close;
  QRY_Div.sql.Clear;
  FOR i := 0 TO High(S) DO
    QRY_Div.sql.Add(S[i]);
  QRY_Div.Open;
END;

PROCEDURE TFrm_IntNikePrin.QRYEVO(Quoi, Table, Ref, Where: STRING);
BEGIN
  QRY_Div.Close;
  QRY_Div.sql.Clear;
  QRY_Div.sql.Add('SELECT ' + Quoi);
  IF ref <> '' THEN
    QRY_Div.sql.Add('From ' + Table + ' Join k on (K_ID=' + ref + ' and k_enabled=1)')
  ELSE
    QRY_Div.sql.Add('From ' + Table);
  IF where <> '' THEN
    QRY_Div.sql.Add('WHERE K_ID<>0 AND ' + where);
  QRY_Div.Open;
END;

FUNCTION TFrm_IntNikePrin.Verif(S: STRING): Boolean;

  PROCEDURE Insertion(table: TdxMemData; V: ARRAY OF STRING);
  VAR
    i: integer;
  BEGIN
    Table.Append;
    FOR i := 0 TO High(V) DO
      table.fields[i + 1].AsString := trim(V[i]);
    table.post;
  END;

  FUNCTION enreal(s: STRING): STRING;
  BEGIN
    WHILE pos(',', S) > 0 DO
      S[Pos(',', s)] := '.';
    result := s;
  END;

  PROCEDURE traiteFichier(S: STRING);
  VAR
    tsl: tstringlist;
    S1: STRING;
    i: integer;
  BEGIN
    tsl := tstringlist.create;
    tsl.loadfromfile(S);
    IF Copy(TSL[0], 1, length('<?xml version=')) = '<?xml version=' THEN
      tsl.delete(0);
    S1 := tsl.text;
    WHILE pos('&', S1) > 0 DO
    BEGIN
      I := pos('&', S1);
      IF (copy(S1, i, 4) <> '&lt;') AND
        (copy(S1, i, 4) <> '&gt;') AND
        (copy(S1, i, 5) <> '&amp;') AND
        (copy(S1, i, 2) <> '&#') AND
        (copy(S1, i, 7) <> '&quote;') AND
        (copy(S1, i, 6) <> '&quot;') THEN
      BEGIN
        delete(S1, i, 1);
        insert('¤ù¤amp;', S1, i);
      END
      ELSE
      BEGIN
        delete(S1, i, 1);
        insert('¤ù¤', S1, i);
      END;
    END;
    WHILE pos('¤ù¤', S1) > 0 DO
    BEGIN
      I := pos('¤ù¤', S1);
      delete(S1, i, 3);
      insert('&', S1, i);
    END;
    WHILE pos('"', S1) > 0 DO
    BEGIN
      I := pos('"', S1);
      delete(S1, i, 1);
      insert('&quot;', S1, i);
    END;

    WHILE pos('&quote;', S1) > 0 DO
    BEGIN
      I := pos('&quote;', S1);
      delete(S1, i, length('&quote;'));
      insert('&quot;', S1, i);
    END;

    WHILE pos(#0, S1) > 0 DO
    BEGIN
      I := pos(#0, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#1, S1) > 0 DO
    BEGIN
      I := pos(#1, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#2, S1) > 0 DO
    BEGIN
      I := pos(#2, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#3, S1) > 0 DO
    BEGIN
      I := pos(#3, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#4, S1) > 0 DO
    BEGIN
      I := pos(#4, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#5, S1) > 0 DO
    BEGIN
      I := pos(#5, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#6, S1) > 0 DO
    BEGIN
      I := pos(#6, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#7, S1) > 0 DO
    BEGIN
      I := pos(#7, S1);
      delete(S1, i, 1);
    END;

    WHILE pos(#8, S1) > 0 DO
    BEGIN
      I := pos(#8, S1);
      delete(S1, i, 1);
    END;

    tsl.text := S1;

    IF Copy(TSL[0], 1, length('<?xml version=')) <> '<?xml version=' THEN
      tsl.Insert(0, '<?xml version="1.0" encoding="ISO-8859-1"?>');
    tsl.SaveTofile(S);
    tsl.free;
  END;

VAR
  Document: IXMLCursor;
  PassXML: IXMLCursor;
  PassXML2: IXMLCursor;
  PassXML3: IXMLCursor;
  ITEMID: STRING;
  i: integer;
  ART: STRING;
  GTAIL: STRING;
  ok, TOC, PbTaille2008, Design: boolean;
  //FOU_ID: Integer;
  enl1: integer;
  enl2: integer;
  enl3: integer;
  tsl: TstringList;
  tsl2: TstringList;
  first: boolean;
  testtsl: tstringlist;
  testS: STRING;
  CFOU, IDMRK, IDFOUR, PVB, PV, PANet, TailleNom, CouNom: STRING;
  sTmp : String;
BEGIN
  result := true;
  MemFou.Close;
  MemFou.Open;
  MenEntTail.Close;
  MenEntTail.Open;
  MenLigTail.Close;
  MenLigTail.Open;
  sTmp := '<H2><CENTER>' + 'Importation de ' + S + '</H2></CENTER>';
  Resultat.Add(sTmp);
  ResRapportcourt.Add(sTmp);
  sTmp := '<H3><CENTER>' + 'Le ' + DateTostr(Date) + '</H3></CENTER>';
  Resultat.Add(sTmp);
  ResRapportcourt.Add(sTmp);

  Document := TXMLCursor.Create;
  IF fileExists(RepXML + 'FOU_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des fournisseurs';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'FOU_' + S + '.XML');
    Document.Load(RepXML + 'FOU_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;

    // Sandrine 07-01-2008 : Identifier si c'est le nouveau format de fichier
    testtsl := TStringList.create;
    testtsl.LoadFromFile(RepXML + 'FOU_' + S + '.XML');
    FluxJanvier2008 := (pos('<IDMARQUE', testtsl.Text) <> 0);
    testtsl.free;

    CFOU := UPPERCASE(COPY(S, 1, pos('_', S) - 1));
    // Sandrine 07-01-2008 : Stocker dans MemFou les ID marque et Fou
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      IF (TRIM(PassXML.GetValue('CFOU')) = '') THEN
        Insertion(MemFou, [PassXML.GetValue('ITEMID'), CFOU, CFOU, PassXML.GetValue('IDMARQUE'), PassXML.GetValue('IDFOURNISSEUR'), CFOU])
      ELSE
      BEGIN
        IF (TRIM(PassXML.GetValue('MARQUE')) = '') THEN
          Insertion(MemFou, [PassXML.GetValue('ITEMID'), PassXML.GetValue('CFOU'), PassXML.GetValue('LFOU'), PassXML.GetValue('IDMARQUE'), PassXML.GetValue('IDFOURNISSEUR'), PassXML.GetValue('CFOU')])
        ELSE
          Insertion(MemFou, [PassXML.GetValue('ITEMID'), PassXML.GetValue('CFOU'), PassXML.GetValue('LFOU'), PassXML.GetValue('IDMARQUE'), PassXML.GetValue('IDFOURNISSEUR'), PassXML.GetValue('MARQUE')]);
      END;
      PassXML.next;
    END;
  END
  ELSE
  BEGIN
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'FOU_' + S + '.XML' + ' N''existe pas Impossible de continuer</B></FONT><BR>');
    result := false;
  END;
  IF fileExists(RepXML + 'TAI_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des tailles';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'TAI_' + S + '.XML');
    Document.Load(RepXML + 'TAI_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;
    PbTaille2008 := False;
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      ITEMID := PassXML.GetValue('ITEMID');
      TailleNom := '';
      TailleNom := PassXML.GetValue('NOM');
      IF (TailleNom = '') THEN
      BEGIN
        TailleNom := 'IMPORT SP2000 - ' + ITEMID;
      END;
      // Sandrine 07-01-2008 : possibilité de travailler avec les grilles de tailles Ginkoia
      Insertion(MenEntTail, [ItemID, PassXML.GetValue('CTAI'), PassXML.GetValue('LTAI'), '0', TailleNom]);
      IF NOT (FluxJanvier2008 OR PbTaille2008) THEN
      BEGIN
        I := 1;
        testtsl := TStringList.create;
        testtsl.LoadFromFile(RepXML + 'TAI_' + S + '.XML');
        PbTaille2008 := (pos('<T' + Inttostr(i), testtsl.Text) = 0);
        testtsl.free;
        IF NOT PbTaille2008 THEN
        BEGIN
          WHILE PassXML.GetValue('T' + Inttostr(i)) <> '' DO
          BEGIN
            Insertion(MenLigTail, [ItemID, PassXML.GetValue('T' + Inttostr(i)), '0']);
            Inc(I);
          END;
        END;
      END;
      IF (FluxJanvier2008 OR PbTaille2008) THEN
      BEGIN
        PassXML3 := PassXML.Select('TAILLES');
        PassXML3 := PassXML3.Select('TAILLE');
        WHILE NOT PassXML3.eof DO
        BEGIN
          IF (PassXML3.GetValue('NOM') <> '') THEN
          BEGIN
            IF (PassXML3.GetValue('CODETAILLE') = '0') THEN
              Insertion(MenLigTail, [ItemID, PassXML3.GetValue('NOM'), '0', '0', ''])
            ELSE Insertion(MenLigTail, [ItemID, PassXML3.GetValue('NOM'), '0', '0', PassXML3.GetValue('CODETAILLE')])
          END;
          PassXML3.next;
        END
      END;
      PassXML.next;
    END;
  END
  ELSE
  BEGIN
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'TAI_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false;
  END;
  MenArt.Close;
  MenArt.Open;
  MemD_COU.Close;
  MemD_COU.Open;
  IF fileExists(RepXML + 'ART_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des Articles';
    Lab_etat2.Update;
    testtsl := TStringList.create;
    testtsl.LoadFromFile(RepXML + 'ART_' + S + '.XML');
    IF pos('<COULEURS', testtsl.Text) = 0 THEN
    BEGIN
      testtsl.free;
      Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'ART_' + S + '.XML' + ' Est incorrect </B></FONT><BR>');
      URapport.untraitement.descriptionIncident := URapport.untraitement.descriptionIncident + #13#10 + ' Le fichier article est une ancienne version, veuillez le reconstruire avec le nouveau CD';
      result := false;
    END
    ELSE
    BEGIN
      // Sandrine 07-01-2008 : Identifier si le PVB existe ==> TOC
      TOC := (pos('<PVB', testtsl.Text) <> 0);
      // Sandrine 30-06-2008 : Gestion du DESIGN
      Design := (pos('<DESIGN', testtsl.Text) <> 0);
      // Sandrine 29-07-2009 : Gestion des champs Espace Montagne
      FluxEM := (pos('<WEB', testtsl.Text) <> 0);
      testtsl.free;
      traiteFichier(RepXML + 'ART_' + S + '.XML');
      Document.Load(RepXML + 'ART_' + S + '.XML');
      PassXML := Document.Select('ITEM');
      pb2.Position := 0;
      pb2.Max := PassXML.Count;
      WHILE NOT PassXML.eof DO
      BEGIN
        pb2.Position := pb2.Position + 1;
        // Recupertration des couleurs
        PassXML2 := PassXML.Select('COULEURS');
        PassXML2 := PassXML2.Select('COULEUR');
        tsl := transforme(PassXML.select('*'));
        WHILE NOT PassXML2.eof DO
        BEGIN
          tsl2 := transforme(PassXML2.select('*'));
          CouNom := tsl2.Values['DESCRIPTIF'];
          // Sandrine 30-06-2008 : Gestion du DESIGN
          IF (Design AND (tsl2.Values['DESIGN'] <> '')) THEN
            CouNom := tsl2.Values['DESCRIPTIF'] + ' [' + tsl2.Values['DESIGN'] + ']';
          Insertion(MemD_COU, [tsl2.Values['IDCOLORIS'], tsl2.Values['CODECOLORIS'], CouNom, tsl.Values['ITEMID']]);
          tsl2.free;
          PassXML2.Next;
        END;
        // à valider ???
        IF trim(tsl.Values['CFAM']) = '' THEN
          tsl.Values['CFAM'] := tsl.Values['CSAI'] + '/' + tsl.Values['ANNEE'];
        // ancien format la ref fourn est suivie de *Code_Couleur ==> faire le ménage !
        IF pos('*', tsl.Values['RFOU']) > 0 THEN
          tsl.Values['RFOU'] := Copy(tsl.Values['RFOU'], 1, pos('*', tsl.Values['RFOU']) - 1);
        IF (TRIM(tsl.Values['CFOU']) = '') THEN
          // Si pas de fournisseur cf. ligne 595 = lire le nom du fournisseur sur le nom du fichier
          tsl.Values['CFOU'] := CFOU;
        IF (TRIM(tsl.Values['MARQUE']) = '') THEN
          tsl.Values['MARQUE'] := CFOU;

        PV := enreal(tsl.Values['PV']);
        PVB := '0';
        IF (TOC AND (tsl.Values['PVB'] <> '') AND (NOT ((enreal(tsl.Values['PVB']) = '0') OR (enreal(tsl.Values['PVB']) = '1')))) THEN
        BEGIN
          PV := enreal(tsl.Values['PVB']);
          PVB := enreal(tsl.Values['PV']);
        END;

        IF NOT FluxJanvier2008 THEN
        BEGIN
          Insertion(MenArt, [tsl.Values['ITEMID'], tsl.Values['LIBELLE'],
            tsl.Values['CCOU'], tsl.Values['CR1'], tsl.Values['CFAM'],
              tsl.Values['CSAI'], tsl.Values['ANNEE'], tsl.Values['CTAI'],
              tsl.Values['CFOU'], tsl.Values['RFOU'], tsl.Values['MARQUE'],
              tsl.Values['LIBFRS'], tsl.Values['FEDAS'], enreal(tsl.Values['PA']), enreal(tsl.Values['PA']),
              PV, PVB,
              tsl.Values['CATMAN']]);
        END
        ELSE
        BEGIN
          PAnet := tsl.Values['PANET'];
          IF ((enreal(PAnet) = '0') OR (enreal(PAnet) = '1')) THEN
            PAnet := tsl.Values['PA'];
          IF NOT FluxEM THEN
          BEGIN
            Insertion(MenArt, [tsl.Values['ITEMID'], tsl.Values['LIBELLE'],
              tsl.Values['CCOU'], tsl.Values['CR1'], tsl.Values['CFAM'],
                tsl.Values['CSAI'], tsl.Values['ANNEE'], tsl.Values['CTAI'],
                tsl.Values['CFOU'], tsl.Values['RFOU'], tsl.Values['MARQUE'],
                tsl.Values['LIBFRS'], tsl.Values['FEDAS'], enreal(tsl.Values['PA']), enreal(PAnet),
                PV, PVB,
                tsl.Values['CATMAN'],
                tsl.Values['REFERENCECENTRALE'],
                tsl.Values['IDMARQUE'],
                tsl.Values['IDFOURNISSEUR'],
                tsl.Values['COLLECTION'],
                tsl.Values['GENRESP2K']]);
          END
          ELSE
          BEGIN // Sandrine 29-07-2009 : Gestion des champs Espace Montagne
            Insertion(MenArt, [tsl.Values['ITEMID'], tsl.Values['LIBELLE'],
              tsl.Values['CCOU'], tsl.Values['CR1'], tsl.Values['CFAM'],
                tsl.Values['CSAI'], tsl.Values['ANNEE'], tsl.Values['CTAI'],
                tsl.Values['CFOU'], tsl.Values['RFOU'], tsl.Values['MARQUE'],
                tsl.Values['LIBFRS'], tsl.Values['FEDAS'], enreal(tsl.Values['PA']), enreal(PAnet),
                PV, PVB,
                tsl.Values['CATMAN'],
                tsl.Values['REFERENCECENTRALE'],
                tsl.Values['IDMARQUE'],
                tsl.Values['IDFOURNISSEUR'],
                tsl.Values['COLLECTION'],
                tsl.Values['GENRESP2K'],
                tsl.Values['WEB'],
                tsl.Values['ACTIVITE'],
                tsl.Values['SPECIFICITE']]);
          END;
        END;

        tsl.free;
        PassXML.next;
      END;
    END;
  END
  ELSE
  BEGIN
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'ART_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false;
  END;
  MenCB.Close;
  MenCB.Open;
  IF fileExists(RepXML + 'BAR_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des Codes Barres';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'BAR_' + S + '.XML');
    Document.Load(RepXML + 'BAR_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      tsl := transforme(PassXML.select('*'));
      IF tsl.values['BARRE'] <> '' THEN
      BEGIN
        IF NOT FluxJanvier2008 THEN
          Insertion(MenCB, [tsl.values['ITEMID'], tsl.values['RFOU'],
            tsl.values['GESCOM'], tsl.values['LTAI'], tsl.values['BARRE'],
              tsl.values['CODECOLORIS'], tsl.values['ARTICLEID']])
        ELSE
          Insertion(MenCB, [tsl.values['ITEMID'], tsl.values['RFOU'],
            tsl.values['GESCOM'], tsl.values['LTAI'], tsl.values['BARRE'],
              tsl.values['CODECOLORIS'], tsl.values['ARTICLEID'],
              tsl.values['IDCOLORIS'], tsl.values['CODETAILLE']]);
      END;
      PassXML.next;
      tsl.free;
    END;
  END
  ELSE
  BEGIN
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'BAR_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false;
  END;
  MenEntCom.Close;
  MenEntCom.Open;
  IF fileExists(RepXML + 'ECD_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des Entête de commande';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'ECD_' + S + '.XML');
    Document.Load(RepXML + 'ECD_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      IDMRK := '';
      IDFOUR := '';
      IF FluxJanvier2008 THEN
      BEGIN
        IDMRK := PassXML.GetValue('IDMARQUE');
        IDFOUR := PassXML.GetValue('IDFOURNISSEUR');
      END;

      IF (TRIM(PassXML.GetValue('CFOU')) = '') THEN
        Insertion(MenEntCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          CFOU, PassXML.GetValue('DCDE'), PassXML.GetValue('CMAG'),
            PassXML.GetValue('DLIV'), PassXML.GetValue('CSAI'), PassXML.GetValue('ANNEE'),
            PassXML.GetValue('LLCLI'), PassXML.GetValue('LADR1'), PassXML.GetValue('LCPOS'),
            PassXML.GetValue('LVILLES')])
      ELSE IF ((IDMRK = '') AND (IDFOUR = '')) THEN
        Insertion(MenEntCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          PassXML.GetValue('CFOU'), PassXML.GetValue('DCDE'), PassXML.GetValue('CMAG'),
            PassXML.GetValue('DLIV'), PassXML.GetValue('CSAI'), PassXML.GetValue('ANNEE'),
            PassXML.GetValue('LLCLI'), PassXML.GetValue('LADR1'), PassXML.GetValue('LCPOS'),
            PassXML.GetValue('LVILLES')])
      ELSE
        Insertion(MenEntCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          PassXML.GetValue('CFOU'), PassXML.GetValue('DCDE'), PassXML.GetValue('CMAG'),
            PassXML.GetValue('DLIV'), PassXML.GetValue('CSAI'), PassXML.GetValue('ANNEE'),
            PassXML.GetValue('LLCLI'), PassXML.GetValue('LADR1'), PassXML.GetValue('LCPOS'),
            PassXML.GetValue('LVILLES'), IDMRK, IDFOUR]);

      PassXML.next;
    END;
  END
  ELSE
  BEGIN
    { modification pour l'importation des articles seul
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'ECD_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false; }
  END;
  MenLigCom.Close;
  MenLigCom.Open;
  IF fileExists(RepXML + 'DCD_' + S + '.XML') THEN
  BEGIN
    Lab_etat2.Caption := 'Lecture des lignes de commande';
    Lab_etat2.Update;
    traiteFichier(RepXML + 'DCD_' + S + '.XML');
    Document.Load(RepXML + 'DCD_' + S + '.XML');
    PassXML := Document.Select('ITEM');
    pb2.Position := 0;
    pb2.Max := PassXML.Count;
    WHILE NOT PassXML.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      IF NOT FluxJanvier2008 THEN
      BEGIN
        Insertion(MenLigCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          PassXML.GetValue('RFOU'), PassXML.GetValue('LTAIL'),
            PassXML.GetValue('QTE'), enreal(PassXML.GetValue('PA')),
            PassXML.GetValue('CODECOLORIS'),
            PassXML.GetValue('ARTICLEID'),
            enreal(PassXML.GetValue('PA'))]);
      END
      ELSE
      BEGIN
        Insertion(MenLigCom, [PassXML.GetValue('ITEMID'), PassXML.GetValue('NUMCDE'),
          PassXML.GetValue('RFOU'), PassXML.GetValue('LTAIL'),
            PassXML.GetValue('QTE'), enreal(PassXML.GetValue('PA')),
            PassXML.GetValue('CODECOLORIS'),
            PassXML.GetValue('ARTICLEID'),
            PassXML.GetValue('PANET'),
            PassXML.GetValue('IDCOLORIS'),
            PassXML.GetValue('CODETAILLE')]);
      END;
      PassXML.next;
    END;
  END
  ELSE
  BEGIN
    { modification pour l'importation des articles seul
    Resultat.Add('<FONT COLOR="red"><B>Le fichier ' + RepXML + 'DCD_' + S + '.XML' + ' N''existe pas. Impossible de continuer</B></FONT><BR>');
    result := false;
    }
  END;
  Document := NIL;

  IF result THEN
  BEGIN
    // retraitement des fichiers
    // faire sauter les articles qui n'appartiennenent pas a une commande (avec les codes barres)
    // marquer les tailles travaillées
    // supprimer les couleurs pas commandées
    resultat.add('Données présentes dans les fichiers d''importation<BR>');
    resultat.add('<PRE>');
    resultat.add(Format('%6d %s', [MemFou.RecordCount, 'Fournisseur(s)']));
    resultat.add(Format('%6d %s', [MenEntTail.RecordCount, 'Grille(s) de tailles']));
    resultat.add(Format('%6d %s', [MenArt.RecordCount, 'Article(s)']));
    resultat.add(Format('%6d %s', [MenCB.RecordCount, 'Code(s) Barre']));
    // modification pour les importations d'articles seuls
    IF fileExists(RepXML + 'ECD_' + S + '.XML') THEN
      resultat.add(Format('%6d %s', [MenEntCom.RecordCount, 'Commande(s)']));
    resultat.add('</PRE>');
    resultat.add('<P>');
    resultat.add('Vérifications des données');
    resultat.add('<PRE>');
    // modification pour les importations d'articles seuls
    IF fileExists(RepXML + 'ECD_' + S + '.XML') THEN
    BEGIN
      TRY
        //récupèrer les infos du mag
        data.open;
      EXCEPT ON Stan: Exception DO
        BEGIN
          URapport.unTraitement.descriptionIncident := Stan.message;
          SignalerIncident('Problème de connection à la base de donnée : ', URapport.unTraitement);
          result := false;
          EXIT;
        END;
      END;
      Lab_etat2.Caption := 'Traitement des Commandes ';
      Lab_etat2.Update;
      pb2.Position := 0;
      pb2.Max := MenEntCom.RecordCount;
      enl1 := 0;
      enl2 := 0;
      MenEntCom.First;
      WHILE NOT MenEntCom.eof DO
      BEGIN
        pb2.Position := pb2.Position + 1;
        QRYEVO('MAG_ID', 'GENMAGASIN', 'MAG_ID', 'MAG_CODEADH=' + QuotedStr(MenEntComCMAG.AsString));
        { pour les tests enlever l'accolade de fin pour ne pas tester le code Adh }

        IF qry_div.IsEmpty THEN
        BEGIN
          resultat.add('traitement interrompu par la présence d''un code adhérent inconnu');
          Resultat.Add('Importation avec problème');
          URapport.untraitement.descriptionIncident := URapport.untraitement.descriptionIncident + #13#10 + ' Le code adhérent des fichiers n''est pas le code adhérent attendu';
          result := false;
          EXIT;
          MenLigCom.First;
          WHILE NOT MenLigCom.eof DO
          BEGIN
            IF MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString THEN
            BEGIN
              MenLigCom.Delete;
              inc(enl1);
            END
            ELSE
              MenLigCom.Next;
          END;
          MenEntCom.delete;
        END
        ELSE {}
        BEGIN
          MenEntCom.Edit;
          MenEntComMAG_ID.Asinteger := qry_div.Fields[0].AsInteger;
          MenEntCom.Post;
          { plus de test sur le numéro de commande
                 QRYEVO('FOU_ID', 'ARTFOURN', 'FOU_ID', 'FOU_NOM=' + QuotedStr(MenEntComCFOU.AsString));
               if not qry_div.IsEmpty then
               begin
                  FOU_ID := qry_div.Fields[0].AsInteger;
                  QRYEVO('CDE_ID', 'COMBCDE', 'CDE_ID',
                     Format('CDE_FOUID=%d and CDE_NUMFOURN=%s', [FOU_ID, QuotedStr(MenEntComNUMCDE.AsString)]));
                  if not qry_div.IsEmpty then
                  begin
                     MenLigCom.First;
                     while not MenLigCom.eof do
                     begin
                        if MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString then
                        begin
                           MenLigCom.Delete;
                           Inc(enl2);
                        end
                        else
                           MenLigCom.Next;
                     end;
                     MenEntCom.delete;
                  end
                  else
                     MenEntCom.next;
               end
               else
               {}
          MenEntCom.next;
        END;
      END;
      IF enl1 > 0 THEN
        resultat.add(Format('%6d %s', [Enl1, 'commande(s) enlevée(s) car code adhérent inconnu']));
      IF enl2 > 0 THEN
        resultat.add(Format('%6d %s', [Enl2, 'commande(s) enlevée(s) car déjà présente(s)']));
      Data.close;

      Lab_etat2.Caption := 'Traitement des articles ';
      Lab_etat2.Update;
      pb2.Position := 0;
      pb2.Max := MenArt.RecordCount;
      enl1 := 0;
      enl2 := 0;
      enl3 := 0;
      MenArt.first;
      first := true;
      WHILE NOT menart.eof DO
      BEGIN
        pb2.Position := pb2.Position + 1;
        // vérification que l'art est dans une ligne de commande
        ART := MenArtITEMID.AsString;
        GTAIL := MenArtCTAI.AsString;
        ok := false;
        MenLigCom.First;
        WHILE NOT MenLigCom.Eof DO
        BEGIN
          IF ART = MenLigComARTICLEID.AsString THEN
          BEGIN
            IF first OR (MenEntTailITEMID.AsString <> GTAIL) THEN
            BEGIN
              MenEntTail.First;
              WHILE NOT (MenEntTail.Eof) AND (MenEntTailITEMID.AsString <> GTAIL) DO
                MenEntTail.Next;
              IF (MenEntTailITEMID.AsString = GTAIL) THEN
              BEGIN
                MenEntTail.edit;
                MenEntTailVALIDE.AsInteger := 1;
                MenEntTail.Post;
              END;
            END;
            ok := True;
            MenLigTail.First;
            WHILE NOT (MenLigTail.eof) AND ((MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) OR
              (MenLigTailTAILLE.AsString <> MenLigComLTAIL.AsString)) DO
              MenLigTail.Next;

            IF (MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) OR
              (MenLigTailTAILLE.AsString <> MenLigComLTAIL.AsString) THEN
            BEGIN
              URapport.untraitement.descriptionIncident := URapport.untraitement.descriptionIncident + #13#10 + ' Article : ' + ART + ' dans la grille de taille '
                + MenEntTailITEMID.AsString + ', la taille ' + MenLigComLTAIL.AsString + ' commandée n''existe pas';
              resultat.add('traitement interrompu par la présence d''un code taille inconnu');
              resultat.add('Article : ' + ART + ' dans la grille de taille ' + MenEntTailITEMID.AsString + ', la taille ' + MenLigComLTAIL.AsString + ' commandée n''existe pas');
              Resultat.Add('Importation avec problème');
              result := false;

              EXIT;
            END;
            MenLigTail.edit;
            MenLigTailTRAVAIL.asinteger := 1;
            MenLigTail.Post;
            first := false;
            // Valider les couleurs commandée
            MemD_COU.First;
            IF FluxJanvier2008 AND (MenLigComIDCOLORIS.AsString <> '') THEN
              WHILE NOT (MemD_COU.Eof) AND
                ((MemD_COUITEMID.AsString <> ART) OR
                (MemD_COUIDCOLORIS.AsString <> MenLigComIDCOLORIS.AsString)) DO
                MemD_COU.next
            ELSE
              WHILE NOT (MemD_COU.eof) AND
                ((MemD_COUITEMID.AsString <> ART) OR (MemD_COUCODECOLORIS.AsString <> MenLigComCODECOLORIS.AsString)) DO
                MemD_COU.next;

            IF (MemD_COUITEMID.AsString <> ART) AND
              (MemD_COUCODECOLORIS.AsString <> MenLigComCODECOLORIS.AsString) THEN
            BEGIN
              URapport.untraitement.descriptionIncident := URapport.untraitement.descriptionIncident + #13#10 + URapport.untraitement.descriptionIncident + ' Article : ' + ART + '  La couleur '
                + MenLigComCODECOLORIS.AsString + ' commandée, n''existe pas en fiche article';
              resultat.add('traitement interrompu par la présence d''un code couleur inconnu');
              resultat.add('Article : ' + ART + '  La couleur ' + MenLigComCODECOLORIS.AsString + ' commandée, n''existe pas en fiche article');
              Resultat.Add('Importation avec problème');
              result := false;

              EXIT;
            END;
            MemD_COU.edit;
            MemD_COUVALIDE.asinteger := 1;
            MemD_COU.Post;

          END;
          MenLigCom.Next;
        END;
        IF NOT ok THEN
        BEGIN
          // suppression des CB non utilisé
          MenCB.first;
          WHILE NOT MenCB.eof DO
          BEGIN
            IF MenCBRFOU.AsString = art THEN
            BEGIN
              MenCB.Delete;
              Inc(enl2);
            END
            ELSE
              MenCB.Next;
          END;
          // suppression des Couleurs non utilisé
          MemD_COU.First;
          WHILE NOT MemD_COU.eof DO
          BEGIN
            IF MemD_COUITEMID.AsString = art THEN
            BEGIN
              MemD_COU.Delete;
              Inc(enl3);
            END
            ELSE
              MemD_COU.Next;
          END;
          menart.Delete;
          Inc(enl1);
        END
        ELSE
          menart.Next;
      END;
      IF enl1 > 0 THEN
        resultat.add(Format('%6d %s', [Enl1, 'articles enlevés car inexistant dans une commande']));
      IF enl2 > 0 THEN
        resultat.add(Format('%6d %s', [Enl2, 'codes barres enlevés suite à la non prise en compte de l''article']));
      IF enl3 > 0 THEN
        resultat.add(Format('%6d %s', [Enl3, 'couleurs enlevés suite à la non prise en compte de l''article']));

      testtsl := tstringlist.create;
      Lab_etat2.Caption := 'Vérification des commandes ';
      Lab_etat2.Update;
      MenEntCom.First;
      first := true;
      pb2.Position := 0;
      pb2.Max := MenEntCom.RecordCount;
      WHILE NOT MenEntCom.Eof DO
      BEGIN
        pb2.Position := pb2.Position + 1;
        MenLigCom.First;
        WHILE NOT MenLigCom.Eof DO
        BEGIN
          IF MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString THEN
          BEGIN
            // recherche de l'article
            MenArt.First;
            WHILE NOT (MenArt.eof) AND (MenArtITEMID.AsString <> MenLigComARTICLEID.AsString) DO
              MenArt.Next;
            // si pas trouvé sortie en erreur
            IF MenArtITEMID.AsString <> MenLigComARTICLEID.AsString THEN
            BEGIN
              IF first THEN
                resultat.add('<P>');
              testS := MenLigComRFOU.AsString + ';' + MenLigComNUMCDE.AsString;
              first := false;
              result := false;
              IF testtsl.indexof(testS) < 0 THEN
              BEGIN
                testtsl.add(testS);
                resultat.add('L''article ' + MenLigComRFOU.AsString + ' de la commande ' + MenLigComNUMCDE.AsString + ' n''existe pas');
              END;
            END;
          END;
          MenLigCom.next;
        END;
        MenEntCom.Next;
      END;
      testtsl.free;
      IF NOT result THEN
      BEGIN
        resultat.add('Impossible de continuer <br />');
        Resultat.Add('<b>Importation avec problème</b><br />');
        EXIT;
      END;
      Lab_etat2.Caption := 'Traitement des grilles de taille';
      Lab_etat2.Update;
      pb2.Position := 0;
      pb2.Max := MenEntTail.RecordCount;
      MenEntTail.First;
      enl1 := 0;
      WHILE NOT MenEntTail.eof DO
      BEGIN
        pb2.Position := pb2.Position + 1;
        IF MenEntTailVALIDE.AsInteger = 0 THEN
        BEGIN
          // supprimer les tailles associées
          MenLigTail.First;
          WHILE NOT MenLigTail.eof DO
          BEGIN
            IF MenLigTailITEMID.AsString = MenEntTailITEMID.AsString THEN
              MenLigTail.delete
            ELSE
              MenLigTail.Next;
          END;
          MenEntTail.delete;
          Inc(enl1);
        END
        ELSE
          MenEntTail.next;
      END;
      IF enl1 > 0 THEN
        resultat.add(Format('%6d %s', [Enl1, 'grille de taille enlevées car ne correspondant à aucun article en commande']));
      resultat.Add('</PRE>');

      resultat.add('<P>');
      resultat.add('Après nettoyage des fiches inutiles pour l''intégration<BR>');
      resultat.add('<PRE>');
      resultat.add(Format('%6d %s', [MemFou.RecordCount, 'Fournisseurs']));
      resultat.add(Format('%6d %s', [MenEntTail.RecordCount, 'Grilles de tailles']));
      resultat.add(Format('%6d %s', [MenArt.RecordCount, 'Articles']));
      resultat.add(Format('%6d %s', [MenCB.RecordCount, 'Codes Barre']));
      resultat.add(Format('%6d %s', [MenEntCom.RecordCount, 'Commande(s)']));
      resultat.add('</PRE>');
    END
    ELSE // Si pas de commande, créer toutes les couleurs
    BEGIN
      MemD_COU.First;
      WHILE NOT (MemD_COU.eof) DO
      BEGIN
        MemD_COU.edit;
        MemD_COUVALIDE.asinteger := 1;
        MemD_COU.Post;

        MemD_COU.next;
      END;
    END;

    resultat.add('<P>');
    //    IF MenArt.RecordCount > QttMaxArt THEN
    //    BEGIN
    //      resultat.add('traitement interrompu, pour des raisons de sauvegarde des données, nous ne pouvons intégrer que ' + Inttostr(QttMaxArt) + ' articles');
    //      Resultat.Add('Importation avec problème');
    //      result := false;
    //      EXIT;
    //    END;
    resultat.add('<BR>');
    ResRapportcourt.Add('<BR>');
    IF result THEN
    BEGIN
      TRY
        Importe(S);
        sTmp := 'Importation terminée avec succès';
        Resultat.Add(sTmp);
        ResRapportcourt.Add(sTmp);
      EXCEPT
        ON E: Exception DO
        BEGIN
          Resultat.Add('Importation avec problème<BR>');
          result := false;
          Resultat.Add(E.Message);
          SignalerIncident('Problème lors de l''importation : ' + E.message, URapport.unTraitement);
        END;
      END;
    END;
  END;
END;

PROCEDURE TFrm_IntNikePrin.Tim_IntegrerTimer(Sender: TObject);
BEGIN
  Tim_Integrer.enabled := false;
  Traitement(repxml1);
  Close;
END;

FUNCTION TFrm_IntNikePrin.Traitement(rep: STRING): integer;
VAR
  f: Tsearchrec;
  i: Integer;
  s: STRING;
  ok : boolean;
BEGIN
  result := 0;
  repxml := rep;
  FluxJanvier2008 := False;
  FluxEM := False;
  // recherche les fichiers a traiter
  // le premier c'est FOU_xxx
  LesFichiers := TStringList.create;
  Resultat := TstringList.Create;
  ResRapportcourt := TStringList.Create;
  ok := true;
  traite := false;
  forcedirectories(RepXML);
  IF FindFirst(RepXML + 'FOU*.XML', faAnyFile, F) = 0 THEN
  BEGIN
    REPEAT
      S := F.Name;
      IF FileExists(RepXML + 'INTEGRES\' + S) THEN
      BEGIN
        //        IF Application.MessageBox(Pchar('Le fichier ' + S + ' a déjà été traité,'#10#13'êtes-vous sur de vouloir le traiter de nouveau ?'), 'Importation', MB_YESNO + MB_DEFBUTTON2) = mrno THEN
        //        BEGIN
        //          ok := false;
        //          BREAK;
        //        END;
      END;
      S := Copy(S, 5, 255);
      S := Copy(S, 1, Pos('.', S) - 1);
      LesFichiers.add(S);
    UNTIL FindNext(F) <> 0;
  END;
  FindClose(F);
  IF ok AND (LesFichiers.Count > 0) THEN
  BEGIN
    Resultat.Add('<HTML>');
    Resultat.Add('<head>');
    Resultat.Add('<title>' + 'Importation ' + Datetostr(Date) + '</title>');
    Resultat.Add('</head>');
    Resultat.Add('<body>');
    ResRapportcourt.Text := Resultat.Text;
    //    Resultat.Add('<FONT SIZE="-2">');
    //    Resultat.Add('Ce document est sauvegardé dans le répertoire de votre importation, il peut être imprimé par le menu fichier imprimer ou par la combinaison de touches CTRL-P<BR>');
    //    Resultat.Add('</FONT>');

    Pb1.Position := 0;
    pb1.Max := LesFichiers.Count;

    TRY
      //récupèrer les infos du mag
      data.open;
    EXCEPT ON Stan: Exception DO
      BEGIN
        SignalerIncident('Problème de connection à la base de donnée : ' + Stan.message, URapport.unTraitement);
        result := 0;
        exit;
      END;
    END;
    Que_Identite.Close;
    Que_Identite.sql.Clear;
    Que_Identite.sql.Add('select MAG_Enseigne,VIL_NOM, ADR_TEL, ADR_EMAIL from genmagasin ' +
      'join k on (K_ID=MAG_ID and K_ENABLED=1) ' +
      'Join Genadresse on (ADR_ID=MAG_ADRID) ' +
      'Join GenVille on (VIL_ID=ADR_VILID) ' +
      'where MAG_CODEADH=' + '''' + unTraitement.CodeAdherent + '''');
    Que_Identite.open;
    WITH unTraitement DO
    BEGIN
      NomMag := TrimRight(Que_identite.Fields[0].AsString);
      Ville := TrimRight(Que_identite.Fields[1].AsString);
      Telephone := TrimRight(Que_identite.Fields[2].AsString);
      AdrEmail := TrimRight(Que_identite.Fields[3].AsString);
    END;
    Que_Identite.close;
    Data.Close;

    FOR i := 0 TO LesFichiers.Count - 1 DO
    BEGIN
      Pb1.position := i + 1;
      Lab_etat1.caption := 'Vérification de ' + LesFichiers[i];
      Lab_etat1.Update;
      traite := Verif(LesFichiers[i]);
      IF traite THEN
      BEGIN
        ForceDirectories(RepXML + 'INTEGRES');
        DeleteFile(RepXML + 'INTEGRES\ART_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'ART_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\ART_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'INTEGRES\BAR_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'BAR_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\BAR_' + LesFichiers[i] + '.XML'));
        // modification pour les importations d'articles seul
        IF FileExists(RepXML + 'DCD_' + LesFichiers[i] + '.XML') THEN
        BEGIN
          DeleteFile(RepXML + 'INTEGRES\DCD_' + LesFichiers[i] + '.XML');
          MoveFile(Pchar(RepXML + 'DCD_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\DCD_' + LesFichiers[i] + '.XML'));
        END;
        IF FileExists(RepXML + 'ECD_' + LesFichiers[i] + '.XML') THEN
        BEGIN
          DeleteFile(RepXML + 'INTEGRES\ECD_' + LesFichiers[i] + '.XML');
          MoveFile(Pchar(RepXML + 'ECD_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\ECD_' + LesFichiers[i] + '.XML'));
        END;
        DeleteFile(RepXML + 'INTEGRES\FOU_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'FOU_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\FOU_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'INTEGRES\TAI_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'TAI_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'INTEGRES\TAI_' + LesFichiers[i] + '.XML'));
        result := LesFichiers.count;
      END
      ELSE
      BEGIN
        ForceDirectories(RepXML + 'PROBLEMES');
        DeleteFile(RepXML + 'PROBLEMES\ART_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'ART_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\ART_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\BAR_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'BAR_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\BAR_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\DCD_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'DCD_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\DCD_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\ECD_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'ECD_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\ECD_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\FOU_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'FOU_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\FOU_' + LesFichiers[i] + '.XML'));
        DeleteFile(RepXML + 'PROBLEMES\TAI_' + LesFichiers[i] + '.XML');
        MoveFile(Pchar(RepXML + 'TAI_' + LesFichiers[i] + '.XML'), Pchar(RepXML + 'PROBLEMES\TAI_' + LesFichiers[i] + '.XML'));
        result := -1;
      END;

      Resultat.Add('<P>');
    END;
    Resultat.Add('</body>');
    ResRapportcourt.Add('</body>');
    Resultat.Add('</HTML>');
    ResRapportcourt.Add('</HTML>');

    uRapport.unTraitement.RapportHtml := uRapport.unTraitement.RapportHtml + FormatDateTime('YYYY"-"MM"-"DD" "HH"H"NN', now) + '.HTML';
    Resultat.Savetofile(uRapport.unTraitement.RapportHtml);
    if FileExists(ExtractFilePath(uRapport.unTraitement.RapportHtml) + 'Rapport.html') then
      DeleteFile(ExtractFilePath(uRapport.unTraitement.RapportHtml) + 'Rapport.html');
    ResRapportcourt.SaveToFile(ExtractFilePath(uRapport.unTraitement.RapportHtml) + 'Rapport.html');
    IF traite THEN
    BEGIN
      envoyerMailIntegration(uRapport.unTraitement);
    END
    ELSE
    BEGIN
      signalerIncident('Erreur lors de l''intégration des données. (Voir rapport Ci joint)', URapport.unTraitement);
    END;
  END;
  Lab_etat1.caption := '';
  Lab_etat1.Update;
  Pb1.Position := 0;

  LesFichiers.free;
  Resultat.free;
  ResRapportcourt.free;
END;

FUNCTION TFrm_IntNikePrin.InsertK(Clef: Integer; Table: STRING): TStringList;
BEGIN
  Table := Uppercase(Table);
  Qry_Div2.Close;
  WITH Qry_Div2.Sql DO
  BEGIN
    Clear;
    Add('SELECT KTB_ID FROM KTB Where KTB_NAME = ' + QuotedStr(table));
  END;
  Qry_Div2.Open;
  result := tstringList.create;
  result.Add('Insert Into K');
  result.Add(' (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
  result.Add(' VALUES ');
  result.Add(' (' + IntToStr(Clef) + ',' + IntToStr(Clef) + ',' + Qry_Div2.Fields[0].AsString + ',' + IntToStr(Clef) + ',1,-1,-1,Current_Date,0,''01/01/1980'',-1,Current_Date,' + IntToStr(Clef) + ',' + IntToStr(Clef) + ')');
  Qry_Div2.Close;
END;

PROCEDURE TFrm_IntNikePrin.AjouteScrQry(Script: TstringList; Table, Champs, Valeur: STRING; Valu: ARRAY OF CONST);
BEGIN
  AjouteScr(Script, ['INSERT INTO ' + Table + '(' + Champs + ') Values',
    Format('(' + Valeur + ')', Valu)]);
END;

PROCEDURE TFrm_IntNikePrin.MajScrQry(Script: TstringList; Table, Champs: STRING; Valu: ARRAY OF CONST; Cle, CleValeur: STRING);
BEGIN
  AjouteScr(Script, ['UPDATE ' + Table + ' SET ', Format(Champs, Valu),
    ' WHERE ' + Cle + '=' + CleValeur]);
  AjouteScr(Script, ['UPDATE K SET K_Version = Gen_ID(General_Id,1), KMA_LOCK_ID=Gen_ID(General_Id,0), KSE_LOCK_ID=Gen_ID(General_Id,0),KRH_ID=Gen_ID(General_Id,0), K_UPDATED =CURRENT_TIMESTAMP WHERE K_ID=' + CleValeur]);
END;

PROCEDURE TFrm_IntNikePrin.AjouteScr(Script: TstringList; S: ARRAY OF STRING);
VAR
  i: integer;
BEGIN
  FOR i := 0 TO high(S) DO
    Script.add(S[i]);
  Script.Add('¤¤¤');
END;

FUNCTION TFrm_IntNikePrin.AjoutCleScript(Script: TstringList; TABLE: STRING): Integer;
VAR
  Pass: TstringList;
BEGIN
  Result := UneClef;
  Pass := InsertK(result, Table);
  Script.AddStrings(Pass);
  Pass.free;
  Script.Add('¤¤¤');
END;

PROCEDURE TFrm_IntNikePrin.Importe(NOM: STRING);
VAR
  i, j, k: integer;
  TGT_ID: Integer;
  GTF_ID: Integer;
  Script: TstringList;
  FOU_ID, FOD_ID, MRK_ID: Integer;
  RAY_ID, FAM_ID, SSF_ID: Integer;
  UNI_ID: Integer;
  TVA_ID: Integer;
  TCT_ID: Integer;
  ART_ID, ARF_ID, COU_ID: Integer;
  MAG_ID: Integer;
  TGF_ID: Integer;
  GRE_ID, SEXE, REFERENCECENTRALE: Integer;
  S: STRING;
  COL_ID: Integer;
  CDE_ID: Integer;
  CDL_ID: Integer;
  Prix: Double;
  NumCDE, NumCDE_Fou: STRING;
  EXE_ID: Integer;
  DATE_COM: STRING;
  DATE_LIV: STRING;
  Chrono: STRING;
  Premier: STRING;
  Dernier: STRING;
  CC, CL: STRING;
  Ok: Boolean;
  LaMarque, UNI: STRING;
  remise, Px, PvI: Double;
  ARTIDREF, GTFIDREF: Integer;
  IDWeb, WebId, IdAct, IdSpec, ClaId, CitId: Integer;
BEGIN
  Script := TstringList.Create;
  MenSSF.close;
  MenSSF.Open;
  data.open;
  MemD_Genre.close;
  MemD_Genre.Open;
  // Fabrication du script d'importation
  // Même ordre que Husky 1° grille de taille
  // recherche de la catégorie IMPORT SP2000
  QRY(['SELECT TGT_ID FROM PLXTYPEGT',
    ' join k on (K_id=TGT_ID and K_ENABLED=1)',
      'Where TGT_NOM = ''REFERENCEMENT''']);
  IF QRY_Div.IsEmpty THEN
  BEGIN
    QRY(['SELECT MAX(TGT_ORDREAFF)+10 FROM PLXTYPEGT',
      ' join k on (K_id=TGT_ID and K_ENABLED=1)']);
    TGT_ID := AjoutCleScript(Script, 'PLXTYPEGT');
    IF QRY_Div.fields[0].IsNull THEN
      AjouteScrQry(Script, 'PLXTYPEGT', 'TGT_ID,TGT_NOM,TGT_ORDREAFF', '%d,''REFERENCEMENT'',%s',
        [TGT_ID, '1'])
    ELSE
      AjouteScrQry(Script, 'PLXTYPEGT', 'TGT_ID,TGT_NOM,TGT_ORDREAFF', '%d,''REFERENCEMENT'',%s',
        [TGT_ID, QRY_Div.fields[0].AsString]);
  END
  ELSE
    TGT_ID := QRY_Div.fields[0].AsInteger;
  Lab_etat2.Caption := 'Création des grilles de tailles';
  Lab_etat2.Update;
  pb2.Position := 0;
  pb2.Max := MenEntTail.recordcount;

  // Ajout des grilles de tailles
  IF FluxJanvier2008 THEN
  BEGIN
    MenLigTail.First;
    WHILE NOT MenLigTail.eof DO
    BEGIN
      IF (MenLigTailCODETAILLE.AsString <> '') THEN
      BEGIN
        QRY(['SELECT TGF_ID, TGF_GTFID', 'From PLXTAILLESGF Join k on (K_ID=TGF_ID and K_ENABLED=1)',
          'WHERE TGF_ID<>0 and TGF_ID = ' + QuotedStr(UpperCase(MenLigTailCODETAILLE.AsString))]);
        IF NOT (Qry_div.IsEmpty) THEN
        BEGIN
          MenLigTail.edit;
          MenLigTailTGF_ID.Asinteger := qry_div.Fields[0].AsInteger;
          MenLigTail.Post;
          GTF_ID := qry_div.Fields[1].AsInteger;
          // mettre l'id de la Grille de taille
          MenEntTail.first;
          WHILE NOT MenEntTail.eof DO
          BEGIN
            IF (MenLigTailITEMID.AsString = MenEntTailITEMID.AsString) THEN
            BEGIN
              MenEntTail.Edit;
              MenEntTailGTF_ID.AsInteger := GTF_ID;
              MenEntTail.Post;
            END;
            MenEntTail.next;
          END;
        END;
      END;
      MenLigTail.next;
    END
  END;
  // dans tous les cas on refait un tour pour traiter tout ce qui ne rentre pas dans
  // les grilles Native Ginkoia ==> comme avant quoi !!
  MenEntTail.first;
  WHILE NOT MenEntTail.eof DO
  BEGIN
    pb2.Position := pb2.Position + 1;
    // GRILLE DE TAILLE
    // Si GTF_ID n'est pas défini c'est que la grille est a crée
    IF ((MenEntTailGTF_ID.AsInteger = 0) OR (MenEntTailGTF_ID.asString = '')) THEN
    BEGIN
      QRY(['SELECT GTF_ID', 'From PLXGTF Join k on (K_ID=GTF_ID and K_ENABLED=1)',
        'WHERE GTF_ID<>0 and ((UPPER(GTF_NOM) = ' + QuotedStr(UpperCase(MenEntTailNOM.AsString)) + ') or (UPPER(GTF_NOM) CONTAINING ' + QuotedStr(UpperCase(MenEntTailITEMID.AsString)) + '))']);
      IF Qry_div.IsEmpty THEN
      BEGIN
        QRY(['SELECT MAX(GTF_ORDREAFF)+10 FROM PLXGTF',
          ' join k on (K_id=GTF_ID and K_ENABLED=1)']);
        GTF_ID := AjoutCleScript(Script, 'PLXGTF');
        // Sandrine : 2008 07 01 - tester si IDREF n'est pas un INTEGER
        TRY
          GTFIDREF := MenEntTailITEMID.AsInteger;
        EXCEPT
          GTFIDREF := 0;
        END;
        AjouteScrQry(Script, 'PLXGTF', 'GTF_ID, GTF_IDREF, GTF_NOM, GTF_TGTID, GTF_ORDREAFF, GTF_IMPORT',
          '%d,%d,%s,%d,%s,1', [GTF_ID, GTFIDREF, QuotedStr(UpperCase(MenEntTailNOM.AsString)), TGT_ID, QRY_Div.fields[0].AsString]);
      END
      ELSE GTF_ID := Qry_div.Fields[0].AsInteger;
      MenEntTail.Edit;
      MenEntTailGTF_ID.AsInteger := GTF_ID;
      MenEntTail.Post;
    END
    ELSE GTF_ID := MenEntTailGTF_ID.AsInteger;

    // TAILLE de la grille
    MenLigTail.First;
    QRYEVO('(MAX (TGF_ORDREAFF)+1)*10, Count(*)+1', 'PLXTAILLESGF', 'TGF_ID', format('TGF_GTFID=%d', [GTF_ID]));
    IF qry_div.Fields[0].IsNull THEN
      J := 10
    ELSE
      j := qry_div.Fields[0].AsInteger;
    IF qry_div.Fields[1].IsNull THEN
      K := 1
    ELSE
      K := qry_div.Fields[1].AsInteger;
    WHILE NOT MenLigTail.eof DO
    BEGIN
      // Si TGF_ID n'est pas défini c'est que la taille est a crée
      IF ((MenLigTailTGF_ID.AsInteger = 0) OR (MenLigTailTGF_ID.AsString = '')) THEN
      BEGIN
        IF MenLigTailITEMID.AsString = MenEntTailITEMID.AsString THEN
        BEGIN
          QRYEVO('TGF_ID', 'PLXTAILLESGF', 'TGF_ID',
            format('UPPER(TGF_NOM) =%s and TGF_GTFID=%d', [QuotedStr(UpperCase(MenLigTailTAILLE.AsString)), GTF_ID]));
          IF qry_div.isempty THEN
          BEGIN
            i := AjoutCleScript(Script, 'PLXTAILLESGF');
            AjouteScrQry(Script, 'PLXTAILLESGF',
              'TGF_ID,TGF_GTFID,TGF_IDREF,TGF_TGFID,TGF_NOM,TGF_CORRES,TGF_ORDREAFF,TGF_STAT',
              '%d,%d,0,%d,%s,'''',%d,%d',
              [i, GTF_ID, i, QuotedStr(UpperCase(MenLigTailTAILLE.AsString)), j, k]);
            inc(j, 10);
            inc(k);
            MenLigTail.edit;
            MenLigTailTGF_ID.Asinteger := i;
            MenLigTail.Post;
          END
          ELSE
          BEGIN
            MenLigTail.edit;
            MenLigTailTGF_ID.Asinteger := qry_div.Fields[0].AsInteger;
            MenLigTail.Post;
          END;
        END;
      END;
      MenLigTail.Next;
    END;
    MenEntTail.next;
  END;
  // Ajout des fournisseurs
  Lab_etat2.Caption := 'Création des fournisseurs';
  Lab_etat2.Update;
  pb2.Position := 0;
  pb2.Max := MemFou.recordcount;
  MemFou.First;
  MemD_Marque.Close;
  MemD_Marque.Open;
  MemD_Liais.close;
  MemD_Liais.open;
  WHILE NOT MemFou.Eof DO
  BEGIN
    pb2.Position := pb2.Position + 1;
    FOU_ID := 0;
    IF FluxJanvier2008 THEN
    BEGIN
      QRYEVO('IMP_GINKOIA', 'GENIMPORT', 'IMP_ID', 'IMP_NUM=4 and IMP_KTBID=-11111385 and IMP_REF=' + QuotedStr(UpperCase(MemFouIDFOURNISSEUR.AsString)));
      IF NOT (qry_div.isempty) THEN
      BEGIN
        FOU_ID := qry_div.Fields[0].AsInteger;
      END;
    END;
    IF (FOU_ID = 0) THEN
    BEGIN
      QRYEVO('FOU_ID', 'ARTFOURN', 'FOU_ID', 'UPPER(FOU_NOM)=' + QuotedStr(UpperCase(MemFouCFOU.AsString)));
      IF qry_div.isempty THEN
      BEGIN
        i := AjoutCleScript(Script, 'GENADRESSE');
        AjouteScrQry(Script, 'GENADRESSE',
          'ADR_ID,ADR_LIGNE,ADR_VILID,ADR_TEL,ADR_FAX,ADR_GSM,ADR_EMAIL,ADR_COMMENT',
          '%d,'''',0,'''','''','''','''',''''', [i]);
        FOU_ID := AjoutCleScript(Script, 'ARTFOURN');
        AjouteScrQry(Script, 'ARTFOURN',
          'FOU_ID,FOU_IDREF,FOU_NOM,FOU_ADRID,FOU_TEL,FOU_FAX,FOU_EMAIL,FOU_REMISE,FOU_GROS,FOU_CDTCDE,FOU_CODE,FOU_TEXTCDE',
          '%d,1,%s,%d,'''','''','''',0,0,'''','''',''''',
          [FOU_ID, QuotedStr(UpperCase(MemFouCFOU.AsString)), i]);
        FOD_ID := AjoutCleScript(Script, 'ARTFOURNDETAIL');
        AjouteScrQry(Script, 'ARTFOURNDETAIL',
          'FOD_ID,FOD_FOUID,FOD_MAGID,FOD_FTOID,FOD_MRGID,FOD_CPAID',
          '%d,%d,0,0,0,0',
          [FOD_ID, FOU_ID]);
      END
      ELSE
        Fou_ID := qry_div.Fields[0].AsInteger;
      // Mettre à jour GENIMPORT
      IF FluxJanvier2008 THEN
      BEGIN
        i := AjoutCleScript(Script, 'GENIMPORT');
        AjouteScrQry(Script, 'GENIMPORT',
          'IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REF,IMP_NUM',
          '%d,-11111385,%d,%d,4',
          [i, FOU_ID, MemFouIDFOURNISSEUR.AsInteger]);
      END;
    END;

    MRK_ID := 0;
    LaMarque := UpperCase(MemFouMARQUE.AsString);
    IF FluxJanvier2008 THEN
    BEGIN
      QRYEVO('IMP_GINKOIA', 'GENIMPORT', 'IMP_ID', 'IMP_NUM=4 and IMP_KTBID=-11111392 and IMP_REF=' + QuotedStr(UpperCase(MemFouIDMARQUE.AsString)));
      IF NOT (qry_div.isempty) THEN
      BEGIN
        MRK_ID := qry_div.Fields[0].AsInteger;
        MemD_Marque.insert;
        MemD_MarqueMARQUE.AsString := LaMarque;
        MemD_MarqueMRK_ID.Asinteger := MRK_ID;
        MemD_MarqueIDMARQUE.AsString := MemFouIDMARQUE.AsString;
        MemD_Marque.post
      END;
    END;
    IF (MRK_ID = 0) THEN
    BEGIN
      IF (LaMarque = '') THEN
        LaMarque := UpperCase(MemFouCFOU.AsString);
      QRYEVO('MRK_ID', 'ARTMARQUE', 'MRK_ID', 'UPPER(MRK_NOM)=' + QuotedStr(LaMarque));
      IF qry_div.isempty THEN
      BEGIN
        MRK_ID := AjoutCleScript(Script, 'ARTMARQUE');
        AjouteScrQry(Script, 'ARTMARQUE',
          'MRK_ID,MRK_IDREF,MRK_NOM,MRK_CONDITION,MRK_CODE',
          '%d,1,%s,'''',''''',
          [MRK_ID, QuotedStr(LaMarque)]);
        MemD_Marque.insert;
        MemD_MarqueMARQUE.AsString := LaMarque;
        MemD_MarqueMRK_ID.Asinteger := MRK_ID;
        MemD_MarqueIDMARQUE.AsString := MemFouIDMARQUE.AsString;
        MemD_Marque.post
      END
      ELSE
      BEGIN
        MRK_ID := qry_div.Fields[0].AsInteger;
        MemD_Marque.first;
        WHILE NOT (MemD_Marque.eof) AND (UpperCase(MemD_MarqueMARQUE.AsString) <> LaMarque) DO
          MemD_Marque.next;
        IF MemD_Marque.eof THEN
        BEGIN
          MemD_Marque.insert;
          MemD_MarqueMARQUE.AsString := LaMarque;
          MemD_MarqueMRK_ID.Asinteger := MRK_ID;
          MemD_MarqueIDMARQUE.AsString := MemFouIDMARQUE.AsString;
          MemD_Marque.post
        END;
      END;
      // Mettre à jour GENIMPORT
      IF FluxJanvier2008 THEN
      BEGIN
        i := AjoutCleScript(Script, 'GENIMPORT');
        AjouteScrQry(Script, 'GENIMPORT',
          'IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REF,IMP_NUM',
          '%d,-11111392,%d,%d,4',
          [i, MRK_ID, MemFouIDMARQUE.AsInteger]);
      END;
    END;

    MemFou.edit;
    MemFouFOU_ID.AsInteger := FOU_ID;
    MemFouMRK_ID.AsInteger := MRK_ID;
    MemFou.Post;
    QRYEVO('FMK_ID', 'ARTMRKFOURN', 'FMK_ID', Format('FMK_FOUID=%d and FMK_MRKID=%d', [FOU_ID, MRK_ID]));
    IF qry_div.isempty THEN
    BEGIN
      // regarder si la marque est déja ref avec un fou principal
      QRYEVO('FMK_ID', 'ARTMRKFOURN', 'FMK_ID', Format('FMK_MRKID=%d AND FMK_PRIN=1', [MRK_ID]));
      IF qry_div.isempty THEN
      BEGIN
        i := AjoutCleScript(Script, 'ARTMRKFOURN');
        AjouteScrQry(Script, 'ARTMRKFOURN',
          'FMK_ID,FMK_FOUID,FMK_MRKID,FMK_PRIN',
          '%d,%d,%d,1',
          [I, FOU_ID, MRK_ID]);
      END
      ELSE
      BEGIN
        i := AjoutCleScript(Script, 'ARTMRKFOURN');
        AjouteScrQry(Script, 'ARTMRKFOURN',
          'FMK_ID,FMK_FOUID,FMK_MRKID,FMK_PRIN',
          '%d,%d,%d,0',
          [I, FOU_ID, MRK_ID]);
      END;
    END;
    MemD_Liais.insert;
    MemD_LiaisFOU_ID.AsInteger := FOU_ID;
    MemD_LiaisMRK_ID.AsInteger := MRK_ID;
    MemD_Liais.Post;

    MemFou.Next;
  END;
  // Création des paramétres
  QRYEVO('TVA_ID', 'ARTTVA', 'TVA_ID', 'TVA_TAUX=19.6');
  TVA_ID := qry_div.Fields[0].AsInteger;
  QRYEVO('TCT_ID', 'ARTTYPECOMPTABLE', 'TCT_ID', 'TCT_CODE=1');
  TCT_ID := qry_div.Fields[0].AsInteger;

  // recherche de l'univers

  QRYEVO('DOS_STRING', 'GENDOSSIER', 'DOS_ID', 'DOS_NOM=''UNIVERS_REF''');
  UNI := '';
  UNI := qry_div.Fields[0].AsString;
  QRYEVO('UNI_ID', 'NKLUNIVERS', 'UNI_ID', 'UNI_NOM=' + QuotedStr(UNI));
  UNI_ID := qry_div.Fields[0].AsInteger;
  QRYEVO('RAY_ID', 'NKLRAYON', 'RAY_ID', 'RAY_NOM=''REFERENCEMENT''');
  IF qry_div.IsEmpty THEN
  BEGIN
    QRYEVO('MAX(RAY_ORDREAFF)+1', 'NKLRAYON', 'RAY_ID', '');
    i := qry_div.Fields[0].AsInteger;
    RAY_ID := AjoutCleScript(Script, 'NKLRAYON');
    AjouteScrQry(Script, 'NKLRAYON',
      'RAY_ID,RAY_UNIID,RAY_IDREF,RAY_NOM,RAY_ORDREAFF,RAY_VISIBLE,RAY_SECID',
      '%d,%d,0,''REFERENCEMENT'',%d,1,0', [RAY_ID, UNI_ID, i]);
  END
  ELSE
    RAY_ID := qry_div.Fields[0].AsInteger;
  QRYEVO('FAM_ID', 'NKLFAMILLE', 'FAM_ID', Format('FAM_NOM=''REFERENCEMENT'' AND FAM_RAYID=%d', [RAY_ID]));
  IF qry_div.IsEmpty THEN
  BEGIN
    QRYEVO('MAX(FAM_ORDREAFF)+1', 'NKLFAMILLE', 'FAM_ID', '');
    i := qry_div.Fields[0].AsInteger;
    FAM_ID := AjoutCleScript(Script, 'NKLFAMILLE');
    AjouteScrQry(Script, 'NKLFAMILLE',
      'FAM_ID,FAM_RAYID,FAM_IDREF,FAM_NOM,FAM_ORDREAFF,FAM_VISIBLE,FAM_CTFID',
      '%d,%d,0,''REFERENCEMENT'',%d,1,0',
      [FAM_ID, RAY_ID, i]);
  END
  ELSE
    FAM_ID := qry_div.Fields[0].AsInteger;
  Lab_etat2.Caption := 'Création de la nomenclature';
  Lab_etat2.Update;
  pb2.Position := 0;
  pb2.Max := Menart.recordcount;
  // Pour chaque article vérification de la présence de la sous famille
  Menart.First;
  WHILE NOT Menart.Eof DO
  BEGIN
    pb2.Position := pb2.Position + 1;
    // pas de code fedas  on cherche sur le nom de la sous famille
    IF trim(MenArtFEDAS.AsString) = '' THEN
    BEGIN
      MenSSF.first;
      WHILE NOT (MenSSF.eof) AND
        ((UpperCase(MenSSFSSF_NOM.AsString) <> UpperCase(MenArtCFAM.AsString))
        OR (MenSSFSSF_FEDAS.AsString <> '')) DO
        MenSSF.next;
      // pas de nom de ssfamille
      IF (UpperCase(MenSSFSSF_NOM.AsString) <> UpperCase(MenArtCFAM.AsString)) OR (MenSSFSSF_FEDAS.AsString <> '') THEN
      BEGIN
        QRYEVO('SSF_ID', 'NKLSSFAMILLE', 'SSF_ID', Format('SSF_FAMID=%d AND SSF_NOM=%s', [FAM_ID, quotedStr(UpperCase(MenArtCFAM.AsString))]));
        IF qry_div.IsEmpty THEN
        BEGIN
          QRYEVO('MAX(SSF_ORDREAFF)+1', 'NKLSSFAMILLE', 'SSF_ID', '');
          i := qry_div.Fields[0].AsInteger;
          SSF_ID := AjoutCleScript(Script, 'NKLSSFAMILLE');
          AjouteScrQry(Script, 'NKLSSFAMILLE',
            'SSF_ID,SSF_FAMID,SSF_IDREF,SSF_NOM,SSF_ORDREAFF,SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID',
            '%d,%d,0,%s,%d,1,0,%d,%d',
            [SSF_ID, FAM_ID, quotedStr(UpperCase(MenArtCFAM.AsString)), i, TVA_ID, TCT_ID]);
        END
        ELSE
          SSF_ID := qry_div.Fields[0].AsInteger;
        // Migartion : MenSSF.AppendRecord([null, SSF_ID, UpperCase(MenArtCFAM.AsString), '', 0]);
        MenSSF.AppendRecord([NIL, SSF_ID, UpperCase(MenArtCFAM.AsString), '', 0]);
      END
      ELSE
        SSF_ID := MenSSFSSF_ID.AsInteger;
    END
    ELSE // Il y a un code fedas ou ID NK Espace Montagne
    BEGIN
      SSF_ID := 0;
      MenSSF.first;
      WHILE NOT (MenSSF.eof) AND (MenSSFSSF_FEDAS.AsString <> MenArtFEDAS.AsString) DO
        MenSSF.next;
      IF MenSSFSSF_FEDAS.AsString <> MenArtFEDAS.AsString THEN
      BEGIN
        // trouver la référence FEDA
        QRYEVO('SSF_ID', 'NKLSSFAMILLE', 'SSF_ID', Format('SSF_IDREF=%s', [MenArtFEDAS.AsString]));
        IF qry_div.IsEmpty THEN
        BEGIN
          // Si pas trouvé et "Autre Nomenclature" coché ==> Espace Montagne recherche directement SSF_ID
          IF (pasFEDAS = 1) THEN
          BEGIN
            QRYEVO('SSF_ID', 'NKLSSFAMILLE', 'SSF_ID', Format('SSF_ID=%s', [MenArtFEDAS.AsString]));
            IF qry_div.IsEmpty THEN
              SSF_ID := 0
            ELSE
            BEGIN
              SSF_ID := qry_div.Fields[0].AsInteger;
              MenSSF.AppendRecord([NIL, SSF_ID, UpperCase(MenArtCFAM.AsString), MenArtFEDAS.AsString, 0]);
            END;
          END;
          IF (SSF_ID = 0) THEN
          BEGIN
            // Si pas trouvé regarde si la famille existe sans code fedas
            MenSSF.first;
            WHILE NOT (MenSSF.eof) AND ((UpperCase(MenSSFSSF_NOM.AsString) <> UpperCase(MenArtCFAM.AsString)) OR (MenSSFSSF_FEDAS.AsString <> '')) DO
              MenSSF.next;
            IF (UpperCase(MenSSFSSF_NOM.AsString) <> UpperCase(MenArtCFAM.AsString)) OR (MenSSFSSF_FEDAS.AsString <> '') THEN
            BEGIN
              QRYEVO('SSF_ID', 'NKLSSFAMILLE', 'SSF_ID', Format('SSF_FAMID=%d AND SSF_NOM=%s', [FAM_ID, quotedStr(UpperCase(MenArtCFAM.AsString))]));
              IF qry_div.IsEmpty THEN
              BEGIN
                QRYEVO('MAX(SSF_ORDREAFF)+1', 'NKLSSFAMILLE', 'SSF_ID', '');
                i := qry_div.Fields[0].AsInteger;
                SSF_ID := AjoutCleScript(Script, 'NKLSSFAMILLE');
                AjouteScrQry(Script, 'NKLSSFAMILLE',
                  'SSF_ID,SSF_FAMID,SSF_IDREF,SSF_NOM,SSF_ORDREAFF,SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID',
                  '%d,%d,0,%s,%d,1,0,%d,%d',
                  [SSF_ID, FAM_ID, quotedStr(UpperCase(MenArtCFAM.AsString)), i, TVA_ID, TCT_ID]);
              END
              ELSE
                SSF_ID := qry_div.Fields[0].AsInteger;
              MenSSF.AppendRecord([NIL, SSF_ID, UpperCase(MenArtCFAM.AsString), '', 0]);
            END
            ELSE
              SSF_ID := MenSSFSSF_ID.AsInteger;
          END;
        END
        ELSE
        BEGIN
          SSF_ID := qry_div.Fields[0].AsInteger;
          MenSSF.AppendRecord([NIL, SSF_ID, UpperCase(MenArtCFAM.AsString), MenArtFEDAS.AsString, 0]);
        END;
      END
      ELSE
        SSF_ID := MenSSFSSF_ID.AsInteger;
    END;

    IF MenSSFSSF_OK.asinteger = 0 THEN
    BEGIN
      //Prob de visibilité des famille
      QRY_Div.Close;
      QRY_Div.sql.Clear;
      QRY_Div.sql.add('Select SSF_ID, FAM_ID, RAY_ID, SSF_VISIBLE, Fam_visible, RAY_visible');
      QRY_Div.sql.add('from NKLSSFAMILLE Join k on (k_id=SSF_ID and K_ENABLED=1)');
      QRY_Div.sql.add('join nklfamille on (fam_id=ssf_famid)');
      QRY_Div.sql.add('join nklrayon on (ray_id=fam_rayid)');
      QRY_Div.sql.add('where SSF_ID<>0 and SSF_id=' + Inttostr(SSF_ID));
      QRY_Div.Open;
      IF NOT QRY_Div.IsEmpty THEN
      BEGIN
        IF QRY_Div.fields[3].AsInteger = 0 THEN
        BEGIN
          AjouteScr(Script, ['Update NKLSSFAMILLE set SSF_VISIBLE=1 where SSF_ID=' + QRY_Div.fields[0].AsString]);
          AjouteScr(Script, ['Update K Set K_Version=GEN_ID(GENERAL_ID,1) Where K_ID=' + QRY_Div.fields[0].AsString]);
        END;
        IF QRY_Div.fields[4].AsInteger = 0 THEN
        BEGIN
          AjouteScr(Script, ['Update nklfamille set fam_VISIBLE=1 where fam_ID=' + QRY_Div.fields[1].AsString]);
          AjouteScr(Script, ['Update K Set K_Version=GEN_ID(GENERAL_ID,1) Where K_ID=' + QRY_Div.fields[1].AsString]);
        END;
        IF QRY_Div.fields[5].AsInteger = 0 THEN
        BEGIN
          AjouteScr(Script, ['Update nklrayon set ray_VISIBLE=1 where ray_ID=' + QRY_Div.fields[2].AsString]);
          AjouteScr(Script, ['Update K Set K_Version=GEN_ID(GENERAL_ID,1) Where K_ID=' + QRY_Div.fields[2].AsString]);
        END;
      END;
      MenSSF.edit;
      MenSSFSSF_OK.asinteger := 1;
      MenSSF.Post;
    END;

    //recherche du fournisseur
    FOU_ID := 0;
    IF (FluxJanvier2008 AND
      (MenArtIDFOURNISSEUR.AsString <> '') AND (MenArtIDFOURNISSEUR.AsInteger <> 0)) THEN
    BEGIN
      MemFou.First;
      WHILE NOT (MemFou.eof) AND (MemFouIDFOURNISSEUR.AsInteger <> MenArtIDFOURNISSEUR.AsINTEGER) DO
        MemFou.next;
      IF (MemFouIDFOURNISSEUR.AsInteger = MenArtIDFOURNISSEUR.AsINTEGER) THEN
        FOU_ID := MemFouFOU_ID.AsInteger;
    END;
    IF (FOU_ID = 0) THEN
    BEGIN
      MemFou.First;
      WHILE NOT (MemFou.eof) AND (UpperCase(MemFouCFOU.AsString) <> UpperCase(MenArtCFOU.AsString)) DO
        MemFou.next;
      IF UpperCase(MemFouCFOU.AsString) <> UpperCase(MenArtCFOU.AsString) THEN
      BEGIN
        RAISE Exception.Create('Incohérence entre le fichier des fournisseurs et celui des articles, pour l''artcile ' + MenArtRFOU.AsString + ' et pour le fournisseur ' + MenArtCFOU.AsString + ', traitement interrompu');
      END;
      FOU_ID := MemFouFOU_ID.AsInteger;
    END;

    // ICI faut rechercher si la MARQUE pour prendre le MRK_ID
    MRK_ID := 0;
    IF (FluxJanvier2008 AND
      (MenArtIDMARQUE.asString <> '') AND (MenArtIDMARQUE.AsInteger <> 0)) THEN
    BEGIN
      MemD_Marque.First;
      WHILE NOT (MemD_Marque.eof)
        AND (MemD_MarqueIDMARQUE.AsInteger <> MenArtIDMARQUE.AsINTEGER) DO
        MemD_Marque.next;
      IF (MemD_MarqueIDMARQUE.AsInteger = MenArtIDMARQUE.AsINTEGER) THEN
        MRK_ID := MemD_MarqueMRK_ID.AsInteger;
    END;
    IF (MRK_ID = 0) THEN
    BEGIN
      MemD_Marque.first;
      WHILE NOT (MemD_Marque.eof) AND (UpperCase(MemD_MarqueMARQUE.asString) <> UpperCase(MenArtMARQUE.AsString)) DO
        MemD_Marque.Next;
      IF UpperCase(MemD_MarqueMARQUE.asString) <> UpperCase(MenArtMARQUE.AsString) THEN
      BEGIN
        // SI on la trouve pas faut la créer
        // avec liaison au fou principal le fournisseur en cours
        QRYEVO('MRK_ID', 'ARTMARQUE', 'MRK_ID', 'MRK_NOM=' + QuotedStr(UpperCase(MenArtMARQUE.AsString)));
        IF qry_div.isempty THEN
        BEGIN
          MRK_ID := AjoutCleScript(Script, 'ARTMARQUE');
          AjouteScrQry(Script, 'ARTMARQUE',
            'MRK_ID,MRK_IDREF,MRK_NOM,MRK_CONDITION,MRK_CODE',
            '%d,1,%s,'''',''''',
            [MRK_ID, QuotedStr(UpperCase(MenArtMARQUE.AsString))]);
          i := AjoutCleScript(Script, 'ARTMRKFOURN');
          AjouteScrQry(Script, 'ARTMRKFOURN',
            'FMK_ID,FMK_FOUID,FMK_MRKID,FMK_PRIN',
            '%d,%d,%d,1',
            [I, FOU_ID, MRK_ID]);
          MemD_Liais.insert;
          MemD_LiaisFOU_ID.AsInteger := FOU_ID;
          MemD_LiaisMRK_ID.AsInteger := MRK_ID;
          MemD_Liais.Post;

          // Mettre à jour GENIMPORT
          IF FluxJanvier2008 THEN
          BEGIN
            i := AjoutCleScript(Script, 'GENIMPORT');
            AjouteScrQry(Script, 'GENIMPORT',
              'IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REF,IMP_NUM',
              '%d,-11111392,%d,%d,4',
              [i, MRK_ID, MenArtIDMARQUE.AsInteger]);
          END;
        END
        ELSE
          MRK_ID := qry_div.Fields[0].AsInteger;
        MemD_Marque.insert;
        MemD_MarqueMARQUE.AsString := UpperCase(MenArtMARQUE.AsString);
        MemD_MarqueMRK_ID.Asinteger := MRK_ID;
        MemD_MarqueIDMARQUE.AsString := MenArtIDMARQUE.AsString;
        MemD_Marque.post;
      END
      ELSE
        MRK_ID := MemD_MarqueMRK_ID.Asinteger;
    END;

    MemD_Liais.first;
    WHILE NOT (MemD_Liais.eof) AND ((MemD_LiaisFOU_ID.asinteger <> FOU_ID) OR (MemD_LiaisMRK_ID.asinteger <> MRK_ID)) DO
      MemD_Liais.Next;
    IF MemD_Liais.eof THEN
    BEGIN
      // Puis faut chercher la liaison FOU/MRK
      // SI on la trouve pas faut la créer
      QRYEVO('FMK_ID', 'ARTMRKFOURN', 'FMK_ID', Format('FMK_FOUID=%d and FMK_MRKID=%d', [FOU_ID, MRK_ID]));
      IF qry_div.isempty THEN
      BEGIN
        i := AjoutCleScript(Script, 'ARTMRKFOURN');
        AjouteScrQry(Script, 'ARTMRKFOURN',
          'FMK_ID,FMK_FOUID,FMK_MRKID,FMK_PRIN',
          '%d,%d,%d,0',
          [I, FOU_ID, MRK_ID]);
      END;
      MemD_Liais.insert;
      MemD_LiaisFOU_ID.AsInteger := FOU_ID;
      MemD_LiaisMRK_ID.AsInteger := MRK_ID;
      MemD_Liais.Post;
    END;

    // rechercher la grille de taille
    MenEntTail.First;
    WHILE NOT (MenEntTail.eof) AND (UpperCase(MenEntTailITEMID.AsString) <> UpperCase(MenArtCTAI.AsString)) DO
      MenEntTail.Next;
    IF (UpperCase(MenEntTailITEMID.AsString) <> UpperCase(MenArtCTAI.AsString)) THEN
    BEGIN
      RAISE Exception.Create('Incohérence entre le fichier des tailles et celui des articles, pour l''artcile ' + MenArtRFOU.AsString + ' et pour la taille ' + MenArtCTAI.AsString + ', traitement interrompu');
    END;

    //Recherche du Genre
    GRE_ID := 0;
    SEXE := 0;
    MemD_Genre.First;
    WHILE NOT (MemD_Genre.eof) AND (UpperCase(MemD_GenreGRE_NOM.AsString) <> UpperCase(MenArtGENRESP2K.AsString)) DO
      MemD_Genre.Next;
    IF (UpperCase(MenArtGENRESP2K.AsString) = '') OR (UpperCase(MemD_GenreGRE_NOM.AsString) <> UpperCase(MenArtGENRESP2K.AsString)) THEN
    BEGIN
      QRY(['SELECT GRE_ID FROM ARTGENRE',
        ' join k on (K_id=GRE_ID and K_ENABLED=1)',
          'Where GRE_ID<>0 AND UPPER(GRE_NOM) = ' + QuotedStr(UpperCase(MenArtGENRESP2K.AsString))]);
      IF QRY_Div.IsEmpty THEN
      BEGIN
        IF ((UpperCase(MenArtFEDAS.AsString) <> '') AND (Length(MenArtFEDAS.AsString) = 6)) THEN
        BEGIN
          SEXE := StrToInt(Copy(MenArtFEDAS.AsString, 6, 1));
          CASE SEXE OF
            0, 4, 7: SEXE := 1;
            5, 8: SEXE := 2;
            6, 9: SEXE := 3;
          END;
        END
        ELSE SEXE := 1;

        IF (UpperCase(MenArtGENRESP2K.AsString) = '') THEN
        BEGIN
          QRY(['SELECT MIN(GRE_ID) FROM ARTGENRE',
            'join k on (K_id=GRE_ID and K_ENABLED=1)',
              'Where GRE_ID<>0 AND GRE_SEXE = ' + IntToStr(SEXE)]);
          IF NOT QRY_Div.IsEmpty THEN
            GRE_ID := QRY_Div.fields[0].AsInteger;
        END
        ELSE
        BEGIN
          GRE_ID := AjoutCleScript(Script, 'ARTGENRE');
          AjouteScrQry(Script, 'ARTGENRE', 'GRE_ID,GRE_IDREF,GRE_NOM,GRE_SEXE', '%d,1,%s,%d',
            [GRE_ID, QuotedStr(UpperCase(MenArtGENRESP2K.AsString)), SEXE]);
          MemD_Genre.insert;
          MemD_GenreGRE_ID.AsInteger := GRE_ID;
          MemD_GenreGRE_NOM.AsString := UpperCase(MenArtGENRESP2K.AsString);
          MemD_Genre.Post;
        END
      END
      ELSE
      BEGIN
        GRE_ID := QRY_Div.fields[0].AsInteger;
        MemD_Genre.insert;
        MemD_GenreGRE_ID.AsInteger := GRE_ID;
        MemD_GenreGRE_NOM.AsString := UpperCase(MenArtGENRESP2K.AsString);
        MemD_Genre.Post;
      END;
    END
    ELSE GRE_ID := MemD_GenreGRE_ID.AsInteger;

    Menart.Edit;
    MenartSSF_ID.AsInteger := SSF_ID;
    MenArtFOU_ID.AsInteger := FOU_ID;
    MenArtMRK_ID.AsInteger := MRK_ID;
    MenArtGTF_ID.AsInteger := MenEntTailGTF_ID.AsInteger;
    MenArtGRE_ID.AsInteger := GRE_ID;
    Menart.Post;

    Menart.Next;
  END;

  QRYEVO('MAG_ID', 'GENMAGASIN', 'MAG_ID', 'MAG_ID<>0');
  MAG_ID := qry_div.Fields[0].AsInteger;

  // Création des articles
  Lab_etat2.Caption := 'Création des articles';
  Lab_etat2.Update;
  pb2.Position := 0;
  pb2.Max := Menart.recordcount;
  Menart.First;
  premier := '';
  dernier := '';
  // Sandrine 29-07-2009 : Gestion des champs Espace Montagne
  // Recup du classement WEB
  WebId := 0;
  WHILE NOT Menart.Eof DO
  BEGIN
    pb2.Position := pb2.Position + 1;
    QRYEVO('ARF_ARTID, ARF_ID',
      'ARTREFERENCE JOIN ARTARTICLE ON (ART_ID=ARF_ARTID)', 'ARF_ID',
      Format('ARF_ARCHIVER=0 AND ART_REFMRK=%s and ART_MRKID=%d and ART_GTFID=%d', [QuotedStr(UpperCase(MenartRFOU.AsString)), MenArtMRK_ID.AsInteger, MenArtGTF_ID.AsInteger]));
    IF qry_div.IsEmpty THEN
    BEGIN
      QRY(['SELECT NEWNUM FROM ART_CHRONO']);
      Chrono := QRY_Div.Fields[0].AsString;
      IF Premier = '' THEN
        Premier := Chrono;
      Dernier := Chrono;

      // Sandrine 29-07-2009 : Gestion des champs Espace Montagne
      // Recup du classement WEB
      IF FluxEM THEN
      BEGIN
        IdWeb := 0;
        // Classement Web
        IF (MenArtWEB.AsString = '1') AND (WebId = 0) THEN
        BEGIN
          MemD_WEB.open;
          MemD_WEB.first;
          WHILE NOT (MemD_WEB.eof) AND (UpperCase(MemD_WEBICL_NOM.AsString) <> 'WEB') DO
            MemD_WEB.next;
          IF (MemD_WEB.eof) AND (UpperCase(MemD_WEBICL_NOM.AsString) <> 'WEB') THEN
          BEGIN
            QRY(['select MIN(ICL_ID)',
              'from ARTCLASSEMENT',
                'join ARTCLAITEM on (cit_claid=cla_id)',
                'join ARTITEMC on (icl_id=cit_iclid)',
                'join k on (K_ID=ICL_ID and K_ENABLED=1)',
                'where CLA_TYPE=''ART'' and CLA_NUM=5 and UPPER(ICL_NOM)=''WEB''']);
            IF NOT QRY_Div.IsEmpty THEN
            BEGIN
              WebId := QRY_Div.fields[0].AsInteger;
            END
            ELSE
            BEGIN
              // Recup du classement 5
              QRY(['select CLA_ID',
                'from ARTCLASSEMENT',
                  'join k on (K_ID=CLA_ID and K_ENABLED=1)',
                  'where CLA_TYPE=''ART'' and CLA_NUM=5']);
              IF NOT QRY_Div.IsEmpty THEN
                ClaID := QRY_Div.fields[0].AsInteger;

              WebId := AjoutCleScript(Script, 'ARTITEMC');
              AjouteScrQry(Script, 'ARTITEMC', 'ICL_ID,ICL_NOM', '%d,%s',
                [WebId, 'WEB']);

              CitId := AjoutCleScript(Script, 'ARTCLAITEM');
              AjouteScrQry(Script, 'ARTCLAITEM', 'CIT_ID,CIT_ICLID,CIT_CLAID', '%d,%d,%d',
                [CitId, WebId, ClaId]);
            END;
            MemD_WEB.insert;
            MemD_WEBICL_ID.AsInteger := WebId;
            MemD_WEBICL_NOM.AsString := 'WEB';
            MemD_WEB.Post;
          END
          ELSE
          BEGIN
            WebId := MemD_WEBICL_ID.AsInteger;
          END;
          IDWeb := WebId;
        END
        ELSE
        BEGIN
          IF (MenArtWEB.AsString = '1') THEN IDWeb := WebId ELSE IDWeb := 0;
        END;

        // Classement Activite
        IdAct := 0;
        IF (MenArtACTIVITE.AsString <> '') THEN
        BEGIN
          MemD_ACTIVITE.open;
          MemD_ACTIVITE.first;
          WHILE NOT (MemD_ACTIVITE.eof) AND (UpperCase(MemD_ACTIVITEICL_NOM.AsString) <> UpperCase(MenArtACTIVITE.AsString)) DO
            MemD_ACTIVITE.next;
          IF (MemD_ACTIVITE.eof) AND (UpperCase(MemD_ACTIVITEICL_NOM.AsString) <> UpperCase(MenArtACTIVITE.AsString)) THEN
          BEGIN
            QRY(['select MIN(ICL_ID)',
              'from ARTCLASSEMENT',
                'join ARTCLAITEM on (cit_claid=cla_id)',
                'join ARTITEMC on (icl_id=cit_iclid)',
                'join k on (K_ID=ICL_ID and K_ENABLED=1)',
                'where CLA_TYPE=''ART'' and CLA_NUM=1 and UPPER(ICL_NOM)=' + QuotedStr(UpperCase(MenArtACTIVITE.AsString))]);
            IF NOT QRY_Div.IsEmpty THEN
              IdAct := QRY_Div.fields[0].AsInteger
            ELSE
            BEGIN
              // Recup du classement 1
              QRY(['select CLA_ID',
                'from ARTCLASSEMENT',
                  'join k on (K_ID=CLA_ID and K_ENABLED=1)',
                  'where CLA_TYPE=''ART'' and CLA_NUM=1']);
              IF NOT QRY_Div.IsEmpty THEN
                ClaID := QRY_Div.fields[0].AsInteger;

              IdAct := AjoutCleScript(Script, 'ARTITEMC');
              AjouteScrQry(Script, 'ARTITEMC', 'ICL_ID,ICL_NOM', '%d,%s',
                [IdAct, QuotedStr(MenArtACTIVITE.AsString)]);

              CitId := AjoutCleScript(Script, 'ARTCLAITEM');
              AjouteScrQry(Script, 'ARTCLAITEM', 'CIT_ID,CIT_ICLID,CIT_CLAID', '%d,%d,%d',
                [CitId, IdAct, ClaId]);
            END;
            MemD_ACTIVITE.insert;
            MemD_ACTIVITEICL_ID.AsInteger := IdAct;
            MemD_ACTIVITEICL_NOM.AsString := MenArtACTIVITE.AsString;
            MemD_ACTIVITE.Post;
          END
          ELSE IdAct := MemD_ACTIVITEICL_ID.AsInteger;
        END;

        // Calssement Spécifique
        IdSpec := 0;
        IF (MenArtSPECIFICITE.AsString <> '') THEN
        BEGIN
          MemD_Specifique.open;
          MemD_Specifique.first;
          WHILE NOT (MemD_Specifique.eof) AND (UpperCase(MemD_SpecifiqueICL_NOM.AsString) <> UpperCase(MenArtSPECIFICITE.AsString)) DO
            MemD_Specifique.next;
          IF (MemD_Specifique.eof) AND (UpperCase(MemD_SpecifiqueICL_NOM.AsString) <> UpperCase(MenArtSPECIFICITE.AsString)) THEN
          BEGIN
            QRY(['select MIN(ICL_ID)',
              'from ARTCLASSEMENT',
                'join ARTCLAITEM on (cit_claid=cla_id)',
                'join ARTITEMC on (icl_id=cit_iclid)',
                'join k on (K_ID=ICL_ID and K_ENABLED=1)',
                'where CLA_TYPE=''ART'' and CLA_NUM=3 and UPPER(ICL_NOM)=' + QuotedStr(UpperCase(MenArtSPECIFICITE.AsString))]);
            IF NOT QRY_Div.IsEmpty THEN
              IdSpec := QRY_Div.fields[0].AsInteger
            ELSE
            BEGIN
              // Recup du classement 3
              QRY(['select CLA_ID',
                'from ARTCLASSEMENT',
                  'join k on (K_ID=CLA_ID and K_ENABLED=1)',
                  'where CLA_TYPE=''ART'' and CLA_NUM=3']);
              IF NOT QRY_Div.IsEmpty THEN
                ClaID := QRY_Div.fields[0].AsInteger;

              IdSpec := AjoutCleScript(Script, 'ARTITEMC');
              AjouteScrQry(Script, 'ARTITEMC', 'ICL_ID,ICL_NOM', '%d,%s',
                [IdSpec, QuotedStr(MenArtSPECIFICITE.AsString)]);

              CitId := AjoutCleScript(Script, 'ARTCLAITEM');
              AjouteScrQry(Script, 'ARTCLAITEM', 'CIT_ID,CIT_ICLID,CIT_CLAID', '%d,%d,%d',
                [CitId, IdSpec, ClaId]);
            END;
            MemD_Specifique.insert;
            MemD_SpecifiqueICL_ID.AsInteger := IdSpec;
            MemD_SpecifiqueICL_NOM.AsString := MenArtSPECIFICITE.AsString;
            MemD_Specifique.Post;
          END
          ELSE IdSpec := MemD_SpecifiqueICL_ID.AsInteger;
        END
      END;

      ART_ID := AjoutCleScript(Script, 'ARTARTICLE');
      ARF_ID := AjoutCleScript(Script, 'ARTREFERENCE');
      IF (MenArtREFERENCECENTRALE.AsString = '') THEN
        REFERENCECENTRALE := 0
      ELSE REFERENCECENTRALE := MenArtREFERENCECENTRALE.AsInteger;
      // Test ITEMID chez Nike c'est un varchar !!
      TRY
        ARTIDREF := MenArtITEMID.AsInteger;
      EXCEPT
        ARTIDREF := 0;
      END;
      AjouteScrQry(Script, 'ARTARTICLE',
        'ART_ID,ART_IDREF,ART_NOM,ART_ORIGINE,ART_DESCRIPTION,ART_MRKID,ART_REFMRK,' +
        'ART_SSFID,ART_PUB,ART_GTFID,ART_SESSION,ART_GREID,ART_THEME,ART_GAMME,' +
        'ART_CODECENTRALE,ART_TAILLES,ART_POS,ART_GAMPF,ART_POINT,ART_GAMPRODUIT,' +
        'ART_SUPPRIME,ART_REFREMPLACE,ART_GARID,ART_CODEGS,ART_COMENT1,ART_COMENT2,' +
        'ART_COMENT3,ART_COMENT4,ART_COMENT5',
        '%d,%d,%s,1,%s,%s,%s,' +
        '%d,0,%d,'''',%d,'''','''',' +
        ''''','''','''','''','''','''',' +
        '%d,%d,2,0,'''','''',' +
        '%s,%s,%s',
        [ART_ID, ARTIDREF, QuotedStr(MenArtLIBFRS.AsString), QuotedStr(MenArtLIBELLE.AsString), MenArtMRK_ID.AsString, QuotedStr(UpperCase(MenArtRFOU.AsString)),
        MenArtSSF_ID.AsInteger, MenArtGTF_ID.AsInteger, MenArtGRE_ID.AsInteger, MenArtCATMAN.AsInteger, REFERENCECENTRALE, QuotedStr(MenArtLIBELLE.AsString), QuotedStr(MenArtLIBELLE.AsString), QuotedStr(MenArtFEDAS.AsString)]);
      AjouteScrQry(Script, 'ARTREFERENCE',
        'ARF_ID,ARF_ARTID,ARF_CATID,ARF_TVAID,ARF_TCTID,ARF_ICLID1,' +
        'ARF_ICLID2,ARF_ICLID3,ARF_ICLID4,ARF_ICLID5,ARF_CREE,' +
        'ARF_MODIF,ARF_CHRONO,ARF_DIMENSION,ARF_DEPRECIATION,' +
        'ARF_VIRTUEL,ARF_SERVICE,ARF_COEFT,ARF_STOCKI,ARF_VTFRAC,' +
        'ARF_CDNMT,ARF_CDNMTQTE,ARF_UNITE,ARF_CDNMTOBLI,ARF_GUELT,' +
        'ARF_CPFA,ARF_FIDELITE,ARF_ARCHIVER,ARF_FIDPOINT,ARF_FIDDEBUT,' +
        'ARF_FIDFIN,ARF_DEPTAUX,ARF_DEPDATE,ARF_DEPMOTIF,ARF_CGTID,' +
        'ARF_GLTMONTANT,ARF_GLTPXV,ARF_GLTMARGE,ARF_GLTDEBUT,ARF_GLTFIN,' +
        'ARF_MAGORG,ARF_CATALOG',
        '%d,%d,0,%d,%d,%d,' +
        '0,%d,0,%d,Current_Date,' +
        'Current_Date,%s,1,0,' +
        '0,0,0,0,0,' +
        '0,0,0,0,0,' +
        '0,1,0,0,Null,' +
        'Null,0,null,0,0,' +
        '0,0,0,Null,Null,' +
        '%d,0',
        [ARF_ID, ART_ID, TVA_ID, TCT_ID, Idact, IdSpec, Idweb, QuotedStr(Chrono), MAG_ID]);
      // Création des couleurs
      MemD_COU.first;
      WHILE (NOT MemD_COU.Eof) AND (MemD_COUITEMID.AsString <> MenartITEMID.AsString) DO
        MemD_COU.next;
      WHILE (NOT MemD_COU.Eof) AND (MemD_COUITEMID.AsString = MenartITEMID.AsString) DO
      BEGIN
        IF (MemD_COUVALIDE.AsInteger = 1) THEN
        BEGIN
          COU_ID := AjoutCleScript(Script, 'PLXCOULEUR');
          CC := MemD_COUCODECOLORIS.AsString;
          CL := MemD_COUDESCRIPTIF.AsString;
          AjouteScrQry(Script, 'PLXCOULEUR',
            'COU_ID,COU_ARTID,COU_IDREF,COU_GCSID,COU_CODE,COU_NOM',
            '%d,%d,%d,0,%s,%s',
            [COU_ID, ART_ID, -1, quotedStr(CC), quotedStr(CL)]);
          MemD_COU.Edit;
          MemD_COUCOU_ID.AsInteger := COU_ID;
          MemD_COUART_ID.AsInteger := ART_ID;
          MemD_COU.Post;
        END;
        MemD_COU.next;
      END;
      // Création du prix catalogue  (Attention à la mAJ si l'article Existe déja ligne: )
      i := AjoutCleScript(Script, 'TARCLGFOURN');
      IF ((MenArtPA.AsFloat = 0) OR (MenArtPA.AsFloat = 1)) THEN
      BEGIN
        IF (MenArtPA.AsFloat = 1) THEN
          Px := MenArtPA.AsFloat / 100
        ELSE Px := 0;
        RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix d''ACHAT est inexploitable ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
      END;

      IF ((MenArtPANET.AsFloat = 0) OR (MenArtPANET.AsFloat = 1)) THEN
      BEGIN
        IF (MenArtPANET.AsFloat = 1) THEN
          Px := MenArtPANET.AsFloat / 100
        ELSE Px := 0;
        RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix d''ACHAT NET est ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
      END;

      IF ((MenArtPVI.AsFloat = 0) OR (MenArtPVI.AsFloat = 1)) THEN
        PvI := 0
      ELSE PvI := MenArtPVI.AsFloat / 100;

      AjouteScrQry(Script, 'TARCLGFOURN',
        'CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,' +
        'CLG_RA2,CLG_RA3,CLG_TAXE,CLG_PRINCIPAL',
        '%d,%d,%d,0,%.2f,%.2f,%.2f,0,0,0,0,1',
        [i, ART_ID, MenArtFOU_ID.AsInteger, MenArtPA.AsFloat / 100, MenArtPANET.AsFloat / 100, PvI]);

      //      // Création du prix vente
      //      if ((MenArtPV.AsString = '') or (MenArtPV.AsFloat = 0) or (MenArtPV.AsFloat = 1)) then
      //      begin
      //        if (MenArtPV.AsString = '') then
      //          raise Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix de VENTE est VIDE ! Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
      //        if (MenArtPV.AsFloat = 1) then
      //          Px := MenArtPV.AsFloat / 100
      //        else Px := 0;
      //        raise Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix de VENTE est de ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
      //      end;
      //      i := AjoutCleScript(Script, 'TARPRIXVENTE');
      //      AjouteScrQry(Script, 'TARPRIXVENTE',
      //        'PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX',
      //        '%d,0,%d,0,%.2f',
      //        [i, ART_ID, MenArtPV.AsFloat / 100]);
    END
    ELSE
    BEGIN //Si l'article existe, on ne recrée que les couleurs manquantes
      //MAJ du prix d'achat Catalogue
      ART_ID := qry_div.Fields[0].AsInteger;
      ARF_ID := qry_div.Fields[1].AsInteger;
      MemD_COU.first;
      WHILE (NOT MemD_COU.Eof) AND (MemD_COUITEMID.AsString <> MenartITEMID.AsString) DO
        MemD_COU.next;
      WHILE (NOT MemD_COU.Eof) AND (MemD_COUITEMID.AsString = MenartITEMID.AsString) DO
      BEGIN
        IF (MemD_COUVALIDE.AsInteger = 1) THEN
        BEGIN
          QRYEVO('COU_ID', 'PLXCOULEUR', 'COU_ID', Format('COU_ARTID=%d and COU_CODE=%s', [ART_ID, Quotedstr(MemD_COUCODECOLORIS.AsString)]));
          IF qry_div.IsEmpty THEN
          BEGIN
            COU_ID := AjoutCleScript(Script, 'PLXCOULEUR');
            CC := MemD_COUCODECOLORIS.AsString;
            CL := MemD_COUDESCRIPTIF.AsString;
            AjouteScrQry(Script, 'PLXCOULEUR',
              'COU_ID,COU_ARTID,COU_IDREF,COU_GCSID,COU_CODE,COU_NOM',
              '%d,%d,%d,0,%s,%s',
              [COU_ID, ART_ID, -1, quotedStr(CC), quotedStr(CL)]);
          END
          ELSE
            COU_ID := qry_div.Fields[0].AsInteger;
          MemD_COU.Edit;
          MemD_COUCOU_ID.AsInteger := COU_ID;
          MemD_COUART_ID.AsInteger := ART_ID;
          MemD_COU.Post;
        END;
        MemD_COU.next;
      END;

      // MAJ du prix catalogue
      IF ((MenArtPA.AsFloat <> 0) AND (MenArtPA.AsFloat <> 1)) THEN
      BEGIN
        IF ((MenArtPANET.AsFloat <> 0) AND (MenArtPANET.AsFloat <> 1)) THEN
        BEGIN
          IF ((MenArtPVI.AsFloat = 0) OR (MenArtPVI.AsFloat = 1)) THEN
            PvI := 0
          ELSE PvI := MenArtPVI.AsFloat / 100;

          // Recherche le Prix catalogue et faire la maj si le prix est différent
          QRYEVO('CLG_ID,CLG_PX',
            'TARCLGFOURN', 'CLG_ID',
            Format('CLG_ARTID=%d and CLG_FOUID=%d and CLG_TGFID=0', [ART_ID, MenArtFOU_ID.AsInteger]));
          IF qry_div.IsEmpty THEN
          BEGIN
            i := AjoutCleScript(Script, 'TARCLGFOURN');
            AjouteScrQry(Script, 'TARCLGFOURN',
              'CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,' +
              'CLG_RA2,CLG_RA3,CLG_TAXE,CLG_PRINCIPAL',
              '%d,%d,%d,0,%.2f,%.2f,%.2f,0,0,0,0,1',
              [i, ART_ID, MenArtFOU_ID.AsInteger, MenArtPA.AsFloat / 100, MenArtPANET.AsFloat / 100, PvI]);
          END
          ELSE
          BEGIN
            i := qry_div.Fields[0].AsInteger;
            IF (qry_div.Fields[1].AsFloat <> (MenArtPA.AsFloat / 100)) THEN
            BEGIN
              IF ((MenArtPV.AsString = '') OR (MenArtPV.AsFloat = 0) OR (MenArtPV.AsFloat = 1)) THEN
              BEGIN
                Px := 0;
              END
              ELSE Px := MenArtPV.AsFloat / 100;

              MajScrQry(Script, 'TARCLGFOURN',
                'CLG_PX=%.2f, CLG_PXNEGO=%.2f, CLG_PXVI=%.2f',
                [MenArtPA.AsFloat / 100, MenArtPANET.AsFloat / 100, Px],
                'CLG_ID', IntToStr(i));
            END;
          END;
        END;
      END;
    END;

    //Stan
    // Maj du prix vente si prix de vente inexixtant
    // Recherche le Prix de vente, s'il  existe déjà ne rien faire
    QRYEVO('PVT_ID,PVT_PX',
      'TARPRIXVENTE', 'PVT_ID',
      Format('PVT_ARTID=%d  and PVT_TGFID=0 and PVT_TVTID=0', [ART_ID]));
    IF qry_div.IsEmpty THEN
    BEGIN
      // Maj du prix vente si prix de vente inexixtant
      IF ((MenArtPV.AsString = '') OR (MenArtPV.AsFloat = 0) OR (MenArtPV.AsFloat = 1)) THEN
      BEGIN
        IF (MenArtPV.AsString = '') THEN
          RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix de VENTE est VIDE ! Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
        IF (MenArtPV.AsFloat = 1) THEN
          Px := MenArtPV.AsFloat / 100
        ELSE Px := 0;
        RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix de VENTE est de ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
      END;
      i := AjoutCleScript(Script, 'TARPRIXVENTE');
      AjouteScrQry(Script, 'TARPRIXVENTE',
        'PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX',
        '%d,0,%d,0,%.2f',
        [i, ART_ID, MenArtPV.AsFloat / 100]);
    END;
    //Stan

    Menart.Edit;
    MenartART_ID.AsInteger := ART_ID;
    MenArtARF_ID.AsInteger := ARF_ID;
    Menart.Post;
    //Création de la collection si besoin
    IF FluxJanvier2008 THEN
      S := QuotedStr(UpperCase(MenArtCOLLECTION.AsString))
    ELSE
      S := QuotedStr(UpperCase(MenArtCSAI.AsString) + ' ' + UpperCase(MenArtANNEE.AsString));
    MemD_ArtCol.open;
    MemD_ArtCol.first;
    WHILE NOT (MemD_ArtCol.eof) AND (UpperCase(MemD_ArtColCOL_NOM.AsString) <> S) DO
      MemD_ArtCol.next;
    IF (MemD_ArtCol.eof) AND (UpperCase(MemD_ArtColCOL_NOM.AsString) <> S) THEN
    BEGIN
      QRYEVO('COL_ID', 'ARTCOLLECTION', 'COL_ID',
        Format('COL_ID<>0 AND UPPER(COL_NOM)=%s', [S]));
      IF qry_div.IsEmpty THEN
      BEGIN
        COL_ID := AjoutCleScript(Script, 'ARTCOLLECTION');
        AjouteScrQry(Script, 'ARTCOLLECTION', 'COL_ID,COL_NOM,COL_NOVISIBLE', '%d,%s,0', [COL_ID, S]);
      END
      ELSE
        COL_ID := qry_div.Fields[0].asInteger;
      MemD_ArtCol.AppendRecord([NIL, COL_ID, S]);
    END
    ELSE
      COL_ID := MemD_ArtColCOL_ID.asinteger;
    MemD_ArtColArt.Open;
    MemD_ArtColArt.first;
    WHILE NOT (MemD_ArtColArt.eof) AND (
      (MemD_ArtColArtCAR_ARTID.AsInteger <> ART_ID) OR
      (MemD_ArtColArtCAR_COLID.AsInteger <> COL_ID)) DO
      MemD_ArtColArt.Next;
    IF (MemD_ArtColArt.eof) AND (
      (MemD_ArtColArtCAR_ARTID.AsInteger <> ART_ID) OR
      (MemD_ArtColArtCAR_COLID.AsInteger <> COL_ID)) THEN
    BEGIN
      QRYEVO('CAR_ID', 'ARTCOLART', 'CAR_ID',
        Format('CAR_ARTID=%d and CAR_COLID=%d', [ARt_ID, COL_ID]));
      IF qry_div.IsEmpty THEN
      BEGIN
        I := AjoutCleScript(Script, 'ARTCOLART');
        AjouteScrQry(Script, 'ARTCOLART', 'CAR_ID,CAR_ARTID,CAR_COLID', '%d,%d,%d', [i, ART_ID, COL_ID]);
      END
      ELSE i := qry_div.Fields[0].asInteger;
      MemD_ArtColArt.AppendRecord([NIL, i, ART_ID, COL_ID]);
    END;
    // Entete de la grille de taille
    MenEntTail.First;
    WHILE NOT MenEntTail.eof AND (MenEntTailITEMID.AsString <> MenArtCTAI.AsString) DO
      MenEntTail.Next;
    // Création des codes barres de l'article de type 1
    IF (MenEntTailITEMID.AsString = MenArtCTAI.AsString) THEN
    BEGIN
      MenLigTail.first;
      WHILE NOT MenLigTail.eof DO
      BEGIN
        IF MenLigTailITEMID.AsString = MenEntTailITEMID.AsString THEN
        BEGIN
          TGF_ID := MenLigTailTGF_ID.AsInteger;
          MEMD_COU.First;
          WHILE (NOT MEMD_COU.eof) AND (MemD_COUART_ID.AsInteger <> ART_ID) DO
            MEMD_COU.Next;
          WHILE (NOT MEMD_COU.eof) AND (MemD_COUART_ID.AsInteger = ART_ID) DO
          BEGIN
            COU_ID := MemD_COUCOU_ID.AsInteger;
            QRYEVO('CBI_ID', 'ARTCODEBARRE', 'CBI_ID',
              Format('CBI_TYPE=1 and CBI_ARFID=%d and CBI_TGFID=%d and CBI_COUID=%d', [ARF_ID, TGF_ID, COU_ID]));
            IF qry_div.IsEmpty THEN
            BEGIN
              // création du code barre
              i := AjoutCleScript(Script, 'ARTCODEBARRE');
              IBST_CB.Prepare;
              IBST_CB.ExecProc;
              S := QuotedStr(IBST_CB.Parambyname('NEWNUM').AsString);
              IBST_CB.UnPrepare;
              IBST_CB.Close;
              AjouteScrQry(Script, 'ARTCODEBARRE',
                'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC',
                '%d,%d,%d,%d,%s,1,0,0,0',
                [i, ARF_ID, TGF_ID, COU_ID, s]);
            END;
            MEMD_COU.Next;
          END;
        END;
        MenLigTail.next;
      END;
    END
    ELSE
      RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' impossible de trouver la grille de taille : ' + MenArtCTAI.AsString + ' dans le fichier TAI_xx.xml');

    // Si le CB existe déjà on ne le prend pas
    MenCB.first;
    WHILE NOT MenCB.Eof DO
    BEGIN
      IF (trim(MenCBBARRE.AsString) = '') THEN
        MenCB.Delete
      ELSE IF (MenCBARTICLEID.AsString = MenArtITEMID.AsString) THEN
      BEGIN
        MEMD_COU.First;
        IF FluxJanvier2008 THEN
        BEGIN
          IF (MenCBIDCOLORIS.AsString <> '') THEN
            WHILE (NOT MEMD_COU.eof)
              AND ((MemD_COUART_ID.AsInteger <> ART_ID)
              OR (MenCBIDCOLORIS.AsString <> MemD_COUIDCOLORIS.AsString)) DO
              MEMD_COU.Next;
        END;
        IF (MenCBIDCOLORIS.AsString = '') THEN
          IF (MenCBCODECOLORIS.AsString <> '') THEN
            WHILE (NOT MEMD_COU.eof)
              AND ((MemD_COUART_ID.AsInteger <> ART_ID)
              OR (MenCBCODECOLORIS.AsString <> MemD_COUCODECOLORIS.AsString)) DO
              MEMD_COU.Next;

        IF (MemD_COUART_ID.AsInteger = ART_ID)
          AND (MenCBIDCOLORIS.AsString = MemD_COUIDCOLORIS.AsString)
          AND (MenCBCODECOLORIS.AsString = MemD_COUCODECOLORIS.AsString) THEN
        BEGIN
          COU_ID := MemD_COUCOU_ID.AsInteger;
          MenLigTail.first;
          WHILE NOT MenLigTail.eof DO
          BEGIN
            IF (MenLigTailITEMID.AsString = MenEntTailITEMID.AsString) THEN
            BEGIN
              IF FluxJanvier2008 AND (MenCBCODETAILLE.AsString <> '')
                AND (MenLigTailCODETAILLE.AsString = MenCBCODETAILLE.AsString) THEN
              BEGIN
                TGF_ID := MenLigTailTGF_ID.AsInteger;
                QRYEVO('CBI_ID', 'ARTCODEBARRE', 'CBI_ID',
                  Format('CBI_CB=%s and CBI_ARFID=%d', [QuotedStr(MenCBBARRE.AsString), ARF_ID]));
                IF qry_div.IsEmpty THEN
                BEGIN
                  // création du code barre
                  i := AjoutCleScript(Script, 'ARTCODEBARRE');
                  S := QuotedStr(MenCBBARRE.AsString);
                  AjouteScrQry(Script, 'ARTCODEBARRE',
                    'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC',
                    '%d,%d,%d,%d,%s,3,0,0,0',
                    [i, ARF_ID, TGF_ID, COU_ID, s]);
                END;
              END
              ELSE IF (MenLigTailTAILLE.AsString = MenCBLTAI.AsString) THEN
              BEGIN
                TGF_ID := MenLigTailTGF_ID.AsInteger;
                QRYEVO('CBI_ID', 'ARTCODEBARRE', 'CBI_ID',
                  Format('CBI_CB=%s and CBI_ARFID=%d', [QuotedStr(MenCBBARRE.AsString), ARF_ID]));
                IF qry_div.IsEmpty THEN
                BEGIN
                  // création du code barre
                  i := AjoutCleScript(Script, 'ARTCODEBARRE');
                  S := QuotedStr(MenCBBARRE.AsString);
                  AjouteScrQry(Script, 'ARTCODEBARRE',
                    'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC',
                    '%d,%d,%d,%d,%s,3,0,0,0',
                    [i, ARF_ID, TGF_ID, COU_ID, s]);
                END
              END
            END;
            MenLigTail.next;
          END
        END
      END;
      MenCB.Next;
    END;
    Menart.Next;
  END;
  IF premier <> '' THEN
  BEGIN
    IF dernier <> premier THEN
    begin
      resultat.add('Intégration des articles ' + premier + ' à ' + dernier + '<BR>');
      ResRapportcourt.Add('Intégration des articles ' + premier + ' à ' + dernier + '<BR>');
    end
    ELSE begin
      resultat.add('Intégration de l''article ' + premier + '<BR>');
      ResRapportcourt.Add('Intégration de l''article ' + premier + '<BR>');
    end;
  END
  ELSE begin
    resultat.add('Pas d''article à intégrer' + '<BR>');
    ResRapportcourt.Add('Pas d''article à intégrer' + '<BR>');
  end;

  //Intégration des commandes
  IF MenEntCom.RecordCount > 0 THEN
  BEGIN
    QRYEVO('EXE_ID', 'GENEXERCICECOMMERCIAL', 'EXE_ID',
      Format('%s between EXE_DEBUT and EXE_FIN', [Quotedstr(FormatDatetime('MM/DD/YYYY', Date))]));
    IF QRY_Div.IsEmpty THEN
      QRYEVO('EXE_ID', 'GENEXERCICECOMMERCIAL', 'EXE_ID',
        'EXE_ID<>0 ORDER BY EXE_DEBUT DESC');
    EXE_ID := QRY_Div.Fields[0].AsInteger;
    Lab_etat2.Caption := 'Création des Commandes';
    Lab_etat2.Update;
    pb2.Position := 0;
    pb2.Max := MenEntCom.recordcount;
    MenEntCom.First;
    Premier := '';
    Dernier := '';
    WHILE NOT MenEntCom.Eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      Prix := 0;
      MenLigCom.First;
      WHILE NOT MenLigCom.Eof DO
      BEGIN
        IF MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString THEN
        BEGIN

          IF ((MenLigComPANET.AsFloat = 0) OR (MenLigComPANET.AsFloat = 1)) THEN
          BEGIN
            IF (MenLigComPANET.AsFloat = 1) THEN
              Px := MenLigComPANET.AsFloat / 100
            ELSE Px := 0;
            RAISE Exception.Create('Dans la commande n° ' + MenEntComNUMCDE.AsString + 'pour l''Artcile ' + MenLigComRFOU.asString + ' le prix d''ACHAT NET est ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
          END;

          IF ((MenArtPV.AsFloat = 0) OR (MenArtPV.AsFloat = 1)) THEN
          BEGIN
            IF (MenArtPV.AsFloat = 1) THEN
              Px := MenArtPV.AsFloat / 100
            ELSE Px := 0;
            RAISE Exception.Create('Article : ' + MenArtRFOU.asstring + ' le prix de VENTE est de ' + FloatToStr(Px) + '€. Allez dans Gestion JA, retirez cet article de votre commande, et régénérez votre commande.');
          END;

          Prix := prix + (MenLigComPANET.AsInteger / 100) * MenLigComQTE.AsInteger
        END;
        MenLigCom.next;
      END;

      // attention on trouve uniquement la marque !!
      MemFou.First;
      IF FluxJanvier2008 AND (MenEntComIDFOURNISSEUR.AsString <> '') THEN
        WHILE NOT (MemFou.EOF) AND (MenEntComIDFOURNISSEUR.AsString <> MemFouIDFOURNISSEUR.AsString) DO
          MemFou.Next
      ELSE
        WHILE NOT (MemFou.EOF) AND (MenEntComCFOU.AsString <> MemFouMARQUE.AsString) DO
          MemFou.Next;

      CDE_ID := AjoutCleScript(Script, 'COMBCDE');
      QRY(['SELECT NEWNUM FROM BC_NEWNUM']);
      NumCDE := QRY_Div.Fields[0].AsString;
      IF Premier = '' THEN
        Premier := NumCDE;
      Dernier := NumCDE;

      S := MenEntComDCDE.AsString;
      DATE_COM := QuotedStr(Copy(S, 5, 2) + '/' + Copy(S, 7, 2) + '/' + Copy(S, 1, 4));

      S := MenEntComDLIV.AsString;
      DATE_LIV := QuotedStr(Copy(S, 5, 2) + '/' + Copy(S, 7, 2) + '/' + Copy(S, 1, 4));

      //            IF nom = 'OPERATIONSP_NOEL 2006_2006' THEN date_liv := QuotedStr('11/01/2006');
      //            IF nom = 'OPERATIONSP_RENTREE DES CLUBS 06_2006' THEN date_liv := QuotedStr('08/01/2006');
      //            IF nom = 'OPERATIONSP_RENTREE DES CLASSES 06_2006' THEN date_liv := QuotedStr('07/01/2006');
      IF pos('*', MenEntComNUMCDE.AsString) <> 0 THEN
        NumCDE_Fou := Copy(MenEntComNUMCDE.AsString, 0, pos('*', MenEntComNUMCDE.AsString) - 1)
      ELSE NumCDE_Fou := MenEntComNUMCDE.AsString;

      AjouteScrQry(Script, 'COMBCDE',
        'CDE_ID,CDE_NUMERO,CDE_SAISON,CDE_EXEID,CDE_CPAID,' +
        'CDE_MAGID,CDE_FOUID,CDE_NUMFOURN,CDE_DATE,CDE_REMISE,' +
        'CDE_TVAHT1,CDE_TVATAUX1,CDE_TVA1,CDE_TVAHT2,CDE_TVATAUX2,' +
        'CDE_TVA2,CDE_TVAHT3,CDE_TVATAUX3,CDE_TVA3,CDE_TVAHT4,' +
        'CDE_TVATAUX4,CDE_TVA4,CDE_TVAHT5,CDE_TVATAUX5,CDE_TVA5,' +
        'CDE_FRANCO,CDE_MODIF,CDE_LIVRAISON,CDE_OFFSET,CDE_REMGLO,' +
        'CDE_ARCHIVE,CDE_REGLEMENT,CDE_TYPID,CDE_NOTVA',
        '%d,%s,%d,%d,%d,' +
        '%s,%s,%s,%s,0,' +
        '%.2f,19.6,%.2f*0.196,0,0,' +
        '0,0,0,0,0,' +
        '0,0,0,0,0,' +
        '1,0,%s,0,0,' +
        '0,Null, %d,0',
        [CDE_ID, QuotedStr(NumCDE), SAISON, EXE_ID, CPA_ID,
        MenEntComMAG_ID.AsString, MemFouFOU_ID.AsString, QuotedStr(NumCDE_Fou), DATE_COM,
          Prix, prix, DATE_LIV, TYP_ID]);
      MenLigCom.First;
      WHILE NOT MenLigCom.Eof DO
      BEGIN
        IF MenLigComNUMCDE.AsString = MenEntComNUMCDE.AsString THEN
        BEGIN
          // recherche de l'article
          MenArt.First;
          WHILE NOT (MenArt.eof) AND (MenArtITEMID.AsString <> MenLigComARTICLEID.AsString) DO
            MenArt.Next;
          // si pas trouvé sortie en erreur
          IF MenArtITEMID.AsString <> MenLigComARTICLEID.AsString THEN
          BEGIN
            RAISE Exception.Create('Incohérence entre le fichier des articles et celui des commandes pour la commande ' + MenLigComNUMCDE.AsString + ', traitement interrompu <br /> article ' + MenLigComRFOU.AsString + ' inexistant');
          END;
          ART_ID := MenArtART_ID.AsInteger;

          MemD_COU.First;
          IF FluxJanvier2008 AND (MenLigComIDCOLORIS.AsString <> '') THEN
            WHILE NOT (MemD_COU.Eof) AND
              ((MemD_COUART_ID.AsInteger <> ART_ID) OR
              (MenLigComIDCOLORIS.AsString <> MemD_COUIDCOLORIS.AsString)) DO
              MemD_COU.next
          ELSE
            WHILE NOT (MemD_COU.Eof) AND
              ((MemD_COUART_ID.AsInteger <> ART_ID) OR
              (MenLigComCODECOLORIS.AsString <> MemD_COUCODECOLORIS.AsString)) DO
              MemD_COU.next;

          IF (MemD_COUART_ID.AsInteger <> ART_ID) OR
            (MenLigComCODECOLORIS.AsString <> MemD_COUCODECOLORIS.AsString) THEN
          BEGIN
            RAISE Exception.Create('Incohérence entre le fichier des articles et celui des commandes pour la commande ' + MenLigComNUMCDE.AsString + ', traitement interrompu <br /> article ' + MenLigComRFOU.AsString + ' couleur ' + MenLigComCODECOLORIS.AsString + ' inexistant');
          END;
          COU_ID := MemD_COUCOU_ID.AsInteger;
          // recherche de la grille de taille
          MenEntTail.First;
          WHILE NOT MenEntTail.eof
            AND (MenEntTailITEMID.AsString <> MenArtCTAI.AsString) DO
            MenEntTail.Next;
          // recherche de la taille
          IF (MenEntTailITEMID.AsString = MenArtCTAI.AsString) THEN
          BEGIN
            MenLigTail.first;
            IF FluxJanvier2008 AND (MenLigComCODETAILLE.AsString <> '') AND (MenLigComCODETAILLE.AsString <> '0') THEN
              WHILE NOT (MenLigTail.Eof) AND ((MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) OR
                (MenLigTailCODETAILLE.AsString <> MenLigComCODETAILLE.AsString)) DO
                MenLigTail.Next
            ELSE
              WHILE NOT (MenLigTail.Eof) AND ((MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) OR
                (MenLigTailTAILLE.AsString <> MenLigComLTAIL.AsString)) DO
                MenLigTail.Next;
          END;
          IF (MenLigTailTAILLE.AsString <> MenLigComLTAIL.AsString) THEN
          BEGIN
            RAISE Exception.Create('Incohérence entre le fichier des tailles et celui des commandes pour la commande ' + MenLigComNUMCDE.AsString + ', traitement interrompu <br /> article ' + MenLigComRFOU.AsString + ' taille ' + MenLigComLTAIL.AsString + ' incoherante');
          END;
          TGF_ID := MenLigTailTGF_ID.Asinteger;

          QRYEVO('TTV_ID', 'PLXTAILLESTRAV', 'TTV_ID',
            Format('TTV_ARTID=%d and TTV_TGFID=%d', [ART_ID, TGF_ID]));
          IF QRY_Div.isempty THEN
          BEGIN
            i := AjoutCleScript(Script, 'PLXTAILLESTRAV');
            AjouteScrQry(Script, 'PLXTAILLESTRAV',
              'TTV_ID,TTV_ARTID,TTV_TGFID',
              '%d, %d, %d',
              [I, ART_ID, TGF_ID]);
          END;

          remise := 100 * (1 - ((MenLigComPANET.AsFloat / 100) / (MenLigComPA.AsFloat / 100)));
          CDL_ID := AjoutCleScript(Script, 'COMBCDEL');
          AjouteScrQry(Script, 'COMBCDEL',
            'CDL_ID,CDL_CDEID,CDL_ARTID,CDL_TGFID,CDL_COUID,' +
            'CDL_QTE,CDL_PXCTLG,CDL_REMISE1,CDL_REMISE2,CDL_REMISE3,' +
            'CDL_PXACHAT,CDL_TVA,CDL_PXVENTE,CDL_OFFSET,CDL_LIVRAISON,' +
            'CDL_TARTAILLE,CDL_VALREMGLO',
            '%d,%d,%d,%d,%d,' +
            '%s,%.2f,%.2f,0,0,' +
            '%.2f,19.6,%.2f,0,%s,' +
            '0,0',
            [CDL_ID, CDE_ID, ART_ID, TGF_ID, COU_ID,
            MenLigComQTE.AsString, MenLigComPA.AsFloat / 100, remise,
              MenLigComPANET.AsFloat / 100, MenArtPV.AsFloat / 100, DATE_LIV]);
          MenLigCom.Delete;
        END
        ELSE
          MenLigCom.next;
      END;
      MenEntCom.Next;
    END;

    IF premier <> '' THEN
    BEGIN
      IF dernier <> premier THEN
      BEGIN
        resultat.add('Intégration des commandes ' + premier + ' à ' + dernier + '<BR>');
        ResRapportcourt.Add('Intégration des commandes ' + premier + ' à ' + dernier + '<BR>');
        URapport.unTraitement.resultat := 'Intégration des commandes ' + premier + ' à ' + dernier;
      END
      ELSE
      BEGIN
        resultat.add('Intégration de la commande ' + premier + '<BR>');
        ResRapportcourt.Add('Intégration de la commande ' + premier + '<BR>');
        URapport.unTraitement.resultat := 'Intégration de la commande ' + premier;
      END;
    END
    ELSE
    BEGIN
      resultat.add('Pas de commande à intégrer' + '<BR>');
      URapport.unTraitement.resultat := 'Pas de commande à intégrer';
      signalerIncident('Aucune commande intégrée dans la base', URapport.unTraitement);
    END;
  END
  ELSE
  BEGIN
    // pas de commande création des tailles travaillées pour tous les articles
    Lab_etat2.Caption := 'Finalisation des fiches articles';
    Lab_etat2.Update;
    pb2.Position := 0;
    pb2.Max := MenArt.recordcount;
    MenArt.first;
    WHILE NOT MenArt.eof DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      ART_ID := MenArtART_ID.AsInteger;
      // recherche de la grille de taille
      MenEntTail.First;
      WHILE (NOT MenEntTail.eof) AND (MenEntTailITEMID.AsString <> MenArtCTAI.AsString) DO
        MenEntTail.Next;
      // recherche de la taille
      IF (MenEntTailITEMID.AsString = MenArtCTAI.AsString) THEN
      BEGIN
        MenLigTail.first;
        WHILE (NOT MenLigTail.eof) AND (MenLigTailITEMID.AsString <> MenEntTailITEMID.AsString) DO
          MenLigTail.Next;
        WHILE (NOT MenLigTail.eof) AND (MenLigTailITEMID.AsString = MenEntTailITEMID.AsString) DO
        BEGIN
          TGF_ID := MenLigTailTGF_ID.Asinteger;

          QRYEVO('TTV_ID', 'PLXTAILLESTRAV', 'TTV_ID',
            Format('TTV_ARTID=%d and TTV_TGFID=%d', [ART_ID, TGF_ID]));
          IF QRY_Div.isempty THEN
          BEGIN
            i := AjoutCleScript(Script, 'PLXTAILLESTRAV');
            AjouteScrQry(Script, 'PLXTAILLESTRAV',
              'TTV_ID,TTV_ARTID,TTV_TGFID',
              '%d, %d, %d',
              [I, ART_ID, TGF_ID]);
          END;
          MenLigTail.Next;
        END;
      END;
      MenArt.next;
    END;
  END;
  IF Tran.InTransaction THEN
    tran.rollback;
  TRY
    Tran.StartTransaction;
    QRY_Div.Close;
    QRY_Div.Sql.Clear;
    Lab_etat2.Caption := 'Validation du travail';
    Lab_etat2.Update;
    //  Script.Savetofile(RepXML + Nom + '.SQL');
    pb2.Position := 0;
    pb2.Max := Script.Count;
    FOR i := 0 TO Script.Count - 1 DO
    BEGIN
      pb2.Position := pb2.Position + 1;
      IF Script[i] <> '¤¤¤' THEN
        QRY_Div.Sql.Add(Script[i])
      ELSE
      BEGIN
        QRY_Div.ExecSQL;
        QRY_Div.Sql.Clear;
      END;
    END;
  EXCEPT
    Script.free;
    Lab_etat2.Caption := '';
    Lab_etat2.Update;
    pb2.Position := 0;
    tran.Rollback;
    RAISE;
  END;
  tran.Commit;
  Script.free;
  Lab_etat2.Caption := '';
  Lab_etat2.Update;
  pb2.Position := 0;
END;

PROCEDURE TFrm_IntNikePrin.FormShow(Sender: TObject);
BEGIN
  Tim_Integrer.enabled := true;
END;

FUNCTION TFrm_IntNikePrin.transforme(XML: IXMLCursor): TStringList;
VAR
  s, ss: STRING;
BEGIN
  result := tstringlist.create;
  WHILE NOT XML.eof DO
  BEGIN
    S := XML.GetName;
    SS := XML.XML;
    Delete(SS, 1, length(S) + 2);
    delete(ss, pos('<', ss), length(ss));
    IF SS = '>' THEN
      SS := '';
    result.values[S] := SS;
    XML.next;
  END;
END;

END.


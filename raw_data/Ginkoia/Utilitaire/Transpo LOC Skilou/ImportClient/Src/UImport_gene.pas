//$Log:
// 1    Utilitaires1.0         04/05/2012 09:53:00    Christophe HENRAT 
//$
//$NoKeywords$
//
UNIT UImport_gene;

INTERFACE

USES
  Xml_Unit,
  IcXMLParser,
  inifiles,
  ShellApi,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Buttons,
  StdCtrls,
  Db,
  IBCustomDataSet,
  IBQuery,
  IBDatabase,
  IBSQL,
  IBStoredProc,
  ComCtrls,
  RzBorder,
  dxmdaset,
  RzShellDialogs,
  ExtCtrls;

TYPE
  TArtTailCoul = RECORD
    iArtId, iTgfId, iCouId, iGtfId: Integer;
    sGtfNom: STRING;
  END;

TYPE
  TForm1 = CLASS(TForm)
    Label1: TLabel;
    ed_Rep: TEdit;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    ed_Base: TEdit;
    SpeedButton2: TSpeedButton;
    Od: TOpenDialog;
    OdXml: TOpenDialog;
    Button4: TButton;
    Base: TIBDatabase;
    Tran_lect: TIBTransaction;
    Tran_ecr: TIBTransaction;
    Qry: TIBQuery;
    Sql: TIBSQL;
    IBST_CB: TIBStoredProc;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Pb: TProgressBar;
    cb_chrono: TCheckBox;
    Chk_NoncreateArt: TCheckBox;
    Chk_TaillesTrav: TCheckBox;
    Chk_ControleNK: TCheckBox;
    Chk_SelectMag: TCheckBox;
    Chk_TestGT: TCheckBox;
    RzBorder1: TRzBorder;
    Chk_LCVMag: TCheckBox;
    MemD_TrierCB: TdxMemData;
    MemD_TrierCBCode_art: TStringField;
    MemD_TrierCBTaille: TStringField;
    MemD_TrierCBcouleur: TStringField;
    MemD_TrierCBEAN: TStringField;
    MemD_TrierCBQtte: TStringField;
    MemD_TrierPrix: TdxMemData;
    MemD_TrierPrixCode_Art: TStringField;
    MemD_TrierPrixTaille: TStringField;
    MemD_TrierPrixPxCatalogue: TStringField;
    MemD_TrierPrixPx_Achat: TStringField;
    MemD_TrierPrixPx_Vente: TStringField;
    MemD_TrierPrixCode_Fou: TStringField;
    Label5: TLabel;
    ed_Toc: TEdit;
    Button8: TButton;
    RzBorder2: TRzBorder;
    MemD_TOC: TdxMemData;
    MemD_TOCCB: TStringField;
    MemD_TOCPV: TFloatField;
    IBSql_Import: TIBSQL;
    Op: TRzSelectFolderDialog;
    Rgr_TypeCB: TRadioGroup;
    Rgr_TypeOP: TRadioGroup;
    Btn_1: TButton;
    Lab_1: TLabel;
    Btn_2: TButton;
    Chk_TaillesTrav0: TCheckBox;
    PROCEDURE SpeedButton1Click(Sender: TObject);
    PROCEDURE ArtXlsClick(Sender: TObject);
    PROCEDURE ArtCsvClick(Sender: TObject);
    PROCEDURE SpeedButton2Click(Sender: TObject);
    PROCEDURE ArtXMLClick(Sender: TObject);
    PROCEDURE Button4Click(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE CltXlsClick(Sender: TObject);
    PROCEDURE CltCSVClick(Sender: TObject);
    PROCEDURE CltXMLClick(Sender: TObject);
    PROCEDURE Button8Click(Sender: TObject);
    PROCEDURE Btn_1Click(Sender: TObject);
    PROCEDURE Chk_TaillesTravClick(Sender: TObject);
    PROCEDURE Btn_2Click(Sender: TObject);
  PRIVATE
    FUNCTION tslChamps(S: STRING; num: integer): STRING;
    FUNCTION tslChampsPrix(S: STRING; num: integer): STRING;
    PROCEDURE AddValue(tsl: tstringlist; TAG, Value: STRING); OVERLOAD;
    PROCEDURE AddValue(VAR fich: textfile; TAG, Value: STRING); OVERLOAD;
    FUNCTION chercheVal(tsl: tstringlist; num: integer;
      valeur: STRING): integer;
    FUNCTION Traitechaine(s: STRING): STRING;
    PROCEDURE ImportXml(Xml: STRING; SelectMag: Boolean; Nbr: Integer = 0);
    PROCEDURE ImportClientXml(Xml: STRING);
    FUNCTION ImportMarque(Art, Marque: TIcXMLElement): boolean;
    FUNCTION ImportFou(Art, Fou: TIcXMLElement): boolean;
    FUNCTION ImportAdr(Adr: TIcXMLElement): STRING;
    FUNCTION ImportGT(Art, GT: TIcXMLElement): Boolean;
    FUNCTION ImportFAM(Art: TIcXMLElement): Boolean;
    PROCEDURE UpdateK(kid: STRING);
    FUNCTION datefr_enus(unedate: STRING): STRING;
    FUNCTION GetMagasinID(): integer;
    FUNCTION GetFilePath(AName: STRING; ANum: Integer): STRING;
    FUNCTION StrToId(S: STRING): Integer;
    PROCEDURE ImportStockXml(ADefaultMagId: integer);
    PROCEDURE TraiteFicStock(AFile: STRING; ADefaultMagId: integer);
    FUNCTION Stock_GetCouId(AArtid:Integer;  ACouId, ACouNom: STRING): Integer;
    FUNCTION Stock_GetTgfId(ATgfId, ATgfNom, AGtfId: STRING): Integer;
    FUNCTION Stock_GetArticle(ACB, AArtId, AArtChrono: STRING): TArtTailCoul;
    FUNCTION Stock_GetMagId(AMagId: STRING; ADefaultMagId: Integer): Integer;
    PROCEDURE Stock_VerifTtv(ATgfId, AArtId: STRING; ACodeArt, AChrono, ATgfNom, AGtfNom: STRING);

    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
    leXml: TmonXML;
    leXmlR: TmonXML;
    Log: textfile;
    lesfou: tstringlist;
  END;

VAR
  Form1: TForm1;

IMPLEMENTATION
USES
  ChxMag_frm,
  UCommon;
{$R *.DFM}

PROCEDURE TForm1.SpeedButton1Click(Sender: TObject);
VAR
  ini: tinifile;
BEGIN
  op.SelectedFolder.PathName := ed_Rep.Text;
  IF op.Execute THEN
  BEGIN
    ed_Rep.Text := IncludeTrailingBackslash(op.SelectedFolder.PathName);
    ini := tinifile.Create(changefileext(application.exename, '.ini'));
    ini.writestring('DIRECTORY', 'PATH', ed_Rep.Text);
    ini.free;
  END;
END;

FUNCTION TForm1.Traitechaine(s: STRING): STRING;
VAR
  i: integer;
BEGIN
  WHILE pos('&', S) > 0 DO
    s[pos('&', S)] := #07;
  WHILE pos(#07, S) > 0 DO
  BEGIN
    i := pos(#07, S);
    delete(s, i, 1);
    insert('et', s, i);
  END;
  WHILE pos('<', S) > 0 DO
  BEGIN
    i := pos('<', S);
    delete(s, i, 1);
    insert('inf', s, i);
  END;
  WHILE pos('>', S) > 0 DO
  BEGIN
    i := pos('>', S);
    delete(s, i, 1);
    insert('sup', s, i);
  END;
  //  WHILE pos ('"', S) > 0 DO
  //  BEGIN
  //    i := pos ('"', S) ;
  //    delete (s, i, 1) ;
  //    insert ('&quot;', s, i) ;
  //  END;
  //  WHILE pos ('''', S) > 0 DO
  //  BEGIN
  //    i := pos ('''', S) ;
  //    delete (s, i, 1) ;
  //    insert ('&apos;', s, i) ;
  //  END;
  result := S;
END;

PROCEDURE TForm1.AddValue(VAR fich: textfile; TAG, Value: STRING);
BEGIN
  IF Value = '' THEN
    writeln(fich, '<' + TAG + '/>')
  ELSE
    writeln(fich, '<' + TAG + '>' + Traitechaine(Value) + '</' + TAG + '>');
END;

PROCEDURE TForm1.AddValue(tsl: tstringlist; TAG: STRING; Value: STRING);
BEGIN
  IF Value = '' THEN
    tsl.add('<' + TAG + '/>')
  ELSE
    tsl.add('<' + TAG + '>' + Traitechaine(Value) + '</' + TAG + '>');
END;

FUNCTION TForm1.chercheVal(tsl: tstringlist; num: integer; valeur: STRING): integer;
VAR
  i: integer;
BEGIN
  valeur := UPPERCASE(trim(valeur));
  FOR i := 1 TO tsl.count - 1 DO
  BEGIN
    IF UPPERCASE(trim(tslChamps(tsl[i], num))) = valeur THEN
    BEGIN
      result := i;
      EXIT;
    END;
  END;
  result := -1;
END;

FUNCTION TForm1.tslChamps(S: STRING; num: integer): STRING;
VAR
  i: integer;
  j: integer;
BEGIN
  WHILE num > 1 DO
  BEGIN
    IF (length(s) > 0) AND (s[1] = '"') THEN
    BEGIN
      // on cherche le prochain ; ou fin qui n'est pas dans les "
      i := 1;
      j := 0;
      WHILE i < length(s) DO
      BEGIN
        IF s[i] = '"' THEN
          inc(j);
        IF NOT (odd(j)) AND (s[i] = ';') THEN
          break;
        inc(i);
      END;
      delete(s, 1, i);
    END
    ELSE IF pos(';', S) > 0 THEN
      delete(S, 1, pos(';', S))
    ELSE
      S := '';
    dec(num);
  END;
  IF (length(s) > 0) AND (s[1] = '"') THEN
  BEGIN
    // on cherche le prochain ; ou fin qui n'est pas dans les "
    i := 1;
    j := 0;
    WHILE i < length(s) DO
    BEGIN
      IF s[i] = '"' THEN
        inc(j);
      IF NOT (odd(j)) AND (s[i] = ';') THEN
        break;
      inc(i);
    END;
    s := copy(s, 1, i);
    IF s[length(s)] = ';' THEN
      delete(s, length(s), 1);
    IF length(s) > 0 THEN
      delete(s, 1, 1);
    IF (length(s) > 0) AND (s[length(s)] = '"') THEN
      delete(s, length(s), 1);
    WHILE pos('""', s) > 0 DO
    BEGIN
      i := pos('""', s);
      delete(s, i, 1);
    END;
    result := s;
  END
  ELSE IF pos(';', S) > 0 THEN
    result := Copy(S, 1, pos(';', S) - 1)
  ELSE
    result := trim(S);
END;

FUNCTION TForm1.tslChampsPrix(S: STRING; num: integer): STRING;
VAR
  i: integer;
BEGIN
  result := tslChamps(S, num);
  i := pos(',', result);
  IF i > 0 THEN // remplacer la , par un .
  BEGIN
    result := concat(Copy(result, 1, (i - 1)), '.', Copy(result, (i + 1), (Length(result) + 1)))
  END
END;

PROCEDURE TForm1.ArtXlsClick(Sender: TObject);
VAR
  tslart: tstringlist;
  tslcb: tstringlist;
  tslfou: tstringlist;
  tslGDT: tstringlist;
  tslMrk: tstringlist;
  tslPx: tstringlist;
  tslTai: tstringlist;
  iart: integer;
  lesart: textfile;

  PosMrk: integer;
  PosFou: integer;
  PosGDT: integer;
  PosCb: Integer;
  PosPrix: Integer;

  S: STRING;
  tsl: tstringList;
  tsl2: tstringList;

  i: integer;
  lig1, lig2: STRING;
BEGIN
  IF fileexists(ed_rep.text + 'Article.csv') AND
    fileexists(ed_rep.text + 'Code_Barre.csv') AND
    fileexists(ed_rep.text + 'fournisseurs.csv') AND
    fileexists(ed_rep.text + 'Grille_de_taille.csv') AND
    fileexists(ed_rep.text + 'Marque.csv') AND
    fileexists(ed_rep.text + 'Prix.csv') AND
    fileexists(ed_rep.text + 'taille.csv') THEN
  BEGIN
    tslart := tstringlist.create;
    ;
    tslcb := tstringlist.create;
    tslfou := tstringlist.create;
    tslGDT := tstringlist.create;
    tslMrk := tstringlist.create;
    tslPx := tstringlist.create;
    tslTai := tstringlist.create;

    tslart.LoadFromFile(ed_rep.text + 'Article.csv');
    tslcb.LoadFromFile(ed_rep.text + 'Code_Barre.csv');
    tslfou.LoadFromFile(ed_rep.text + 'fournisseurs.csv');
    tslGDT.LoadFromFile(ed_rep.text + 'Grille_de_taille.csv');
    tslMrk.LoadFromFile(ed_rep.text + 'Marque.csv');
    tslTai.LoadFromFile(ed_rep.text + 'taille.csv');

    assignfile(LesArt, ed_rep.text + 'RESULT.XML');
    rewrite(lesart);
    writeln(lesart, '<ARTICLES>');
    FOR iart := 1 TO tslart.count - 1 DO
    BEGIN
      writeln(lesart, '<ARTICLE>');
      AddValue(lesart, 'CODE', tslChamps(tslart[iart], 1));
      writeln(lesart, '<MARQUE>');
      // recherche de la marque
      S := tslChamps(tslart[iart], 2);
      IF S <> '' THEN
      BEGIN
        PosMrk := chercheVal(tslMrk, 3, S);
        IF PosMrk <> -1 THEN
        BEGIN
          IF tslMrk.Objects[PosMrk] <> NIL THEN
          BEGIN
            // déja recherché
            writeln(lesart, tstringlist(tslMrk.Objects[PosMrk]).Text);
          END
          ELSE
          BEGIN
            tsl := tstringList.create;
            tslMrk.Objects[PosMrk] := tsl;
            AddValue(tsl, 'CODE', tslChamps(tslMrk[PosMrk], 1));
            AddValue(tsl, 'NOM', tslChamps(tslMrk[PosMrk], 3));
            tsl.add('<FOURNISSEUR>');
            S := tslChamps(tslMrk[PosMrk], 2);
            IF S <> '' THEN
            BEGIN
              posfou := chercheVal(tslFou, 2, S);
              IF posfou <> -1 THEN
              BEGIN
                IF tslFou.Objects[posfou] <> NIL THEN
                BEGIN
                  tsl.add(Tstringlist(tslFou.Objects[posfou]).Text);
                END
                ELSE
                BEGIN
                  tsl2 := tstringlist.create;
                  tslFou.Objects[posfou] := tsl2;
                  AddValue(tsl2, 'CODE', tslchamps(tslFou[posfou], 1));
                  AddValue(tsl2, 'NOM', tslchamps(tslFou[posfou], 2));
                  tsl2.add('<ADRESSE>');
                  AddValue(tsl2, 'LIGNE1', tslchamps(tslFou[posfou], 3));
                  AddValue(tsl2, 'LIGNE2', tslchamps(tslFou[posfou], 4));
                  AddValue(tsl2, 'LIGNE3', tslchamps(tslFou[posfou], 5));
                  AddValue(tsl2, 'CP', tslchamps(tslFou[posfou], 6));
                  AddValue(tsl2, 'VILLE', tslchamps(tslFou[posfou], 7));
                  AddValue(tsl2, 'PAYS', tslchamps(tslFou[posfou], 8));
                  AddValue(tsl2, 'TEL', tslchamps(tslFou[posfou], 9));
                  AddValue(tsl2, 'FAX', tslchamps(tslFou[posfou], 10));
                  AddValue(tsl2, 'PORTABLE', tslchamps(tslFou[posfou], 11));
                  AddValue(tsl2, 'EMAIL', tslchamps(tslFou[posfou], 12));
                  AddValue(tsl2, 'COMMENTAIRE', tslchamps(tslFou[posfou], 13));
                  tsl2.add('</ADRESSE>');
                  AddValue(tsl2, 'NUM_CLT_FOU', tslchamps(tslFou[posfou], 14));
                  AddValue(tsl2, 'COND_PAIE', tslchamps(tslFou[posfou], 15));
                  tsl.add(tsl2.text);
                END;
              END;
            END;
            tsl.add('</FOURNISSEUR>');
            writeln(lesart, tsl.text);
          END;
        END;
      END;
      writeln(lesart, '</MARQUE>');

      // recherche de la grille de tailles
      writeln(lesart, '<GRILLE_TAILLES>');
      S := UPPERCASE(trim(tslChamps(tslart[iart], 3)));
      IF s <> '' THEN
      BEGIN
        PosGDT := chercheVal(tslGDT, 2, S);
        IF PosGDT <> -1 THEN
        BEGIN
          IF tslGDT.Objects[PosGDT] <> NIL THEN
          BEGIN
            writeln(lesart, Tstringlist(tslGDT.Objects[PosGDT]).text);
          END
          ELSE
          BEGIN
            tsl := tstringlist.create;
            tslGDT.Objects[PosGDT] := tsl;
            AddValue(tsl, 'CODE', tslChamps(tslGDT[PosGDT], 1));
            AddValue(tsl, 'NOM_GRILLE', tslChamps(tslGDT[PosGDT], 2));
            tsl.add('<TAILLES>');
            FOR i := 1 TO tslTai.count - 1 DO
            BEGIN
              IF UPPERCASE(trim(tslChamps(tslTai[i], 1))) = S THEN
              BEGIN
                tsl.add('<TAILLE>');
                IF (tslChamps(tslTai[i], 2) = '') THEN
                  AddValue(tsl, 'NOM', 'UNIQUE')
                ELSE
                  AddValue(tsl, 'NOM', tslChamps(tslTai[i], 2));
                tsl.add('</TAILLE>');
              END;
            END;
            tsl.add('</TAILLES>');
            writeln(lesart, tsl.text);
          END;
        END;
      END;
      writeln(lesart, '</GRILLE_TAILLES>');

      AddValue(lesart, 'CODE_FOU', tslChamps(tslart[iart], 4));
      AddValue(lesart, 'NOM', tslChamps(tslart[iart], 5));
      AddValue(lesart, 'DESCRIPTION', tslChamps(tslart[iart], 6));
      writeln(lesart, '<SS_FAMILLE>');
      AddValue(lesart, 'NOM', tslChamps(tslart[iart], 9));
      writeln(lesart, '<FAMILLE>');
      AddValue(lesart, 'NOM', tslChamps(tslart[iart], 8));
      writeln(lesart, '<RAYON>');
      AddValue(lesart, 'NOM', tslChamps(tslart[iart], 7));
      writeln(lesart, '</RAYON>');
      writeln(lesart, '</FAMILLE>');
      writeln(lesart, '</SS_FAMILLE>');
      AddValue(lesart, 'GENRE', tslChamps(tslart[iart], 10));
      AddValue(lesart, 'CLASSEMENT1', tslChamps(tslart[iart], 11));
      AddValue(lesart, 'CLASSEMENT2', tslChamps(tslart[iart], 12));
      AddValue(lesart, 'CLASSEMENT3', tslChamps(tslart[iart], 13));
      AddValue(lesart, 'CLASSEMENT4', tslChamps(tslart[iart], 14));
      AddValue(lesart, 'CLASSEMENT5', tslChamps(tslart[iart], 15));

      writeln(lesart, '<COULEURS>');
      i := 16;
      REPEAT
        S := tslChamps(tslart[iart], i);
        IF s <> '' THEN
        BEGIN
          writeln(lesart, '<COULEUR>');
          AddValue(lesart, 'NOM', S);
          writeln(lesart, '</COULEUR>');
        END;
        inc(i);
      UNTIL s = '';
      writeln(lesart, '</COULEURS>');
      writeln(lesart, '<CODE_BARRES>');
      PosCb := chercheVal(tslcb, 1, tslChamps(tslart[iart], 5));
      IF PosCb <> -1 THEN
      BEGIN
        lig1 := tslcb[PosCb];
        inc(PosCb);
        REPEAT
          inc(PosCb);
          Lig2 := tslcb[PosCb];
          IF tslChamps(tslart[iart], 5) = tslChamps(lig2, 1) THEN
          BEGIN
            i := 3;
            WHILE tslChamps(lig1, i) <> '' DO
            BEGIN
              IF (tslChamps(lig2, i) <> '') OR (tslChamps(lig2, i + 1) <> '') THEN
              BEGIN
                writeln(lesart, '<CODE_BARRE>');

                AddValue(lesart, 'TAILLE', tslChamps(lig1, i));
                AddValue(lesart, 'COULEUR', tslChamps(lig2, 2));
                AddValue(lesart, 'EAN', tslChamps(lig2, i));
                AddValue(lesart, 'QTTE', tslChamps(lig2, i));
                writeln(lesart, '</CODE_BARRE>');
              END;
              inc(i, 2);
            END;
          END;
        UNTIL (tslChamps(tslart[iart], 5) <> tslChamps(lig2, 1)) OR (PosCb = tslcb.count - 1);
      END;
      writeln(lesart, '</CODE_BARRES>');

      writeln(lesart, '<LESPRIX>');
      PosPrix := chercheVal(tslPx, 1, tslChamps(tslart[iart], 6));
      IF posprix <> -1 THEN
      BEGIN
        Lig1 := tslPx[PosPrix];
        i := 2;
        WHILE tslChamps(lig1, i) <> '' DO
        BEGIN
          IF (tslChamps(tslPx[PosPrix + 1], i) <> '') OR
            (tslChamps(tslPx[PosPrix + 2], i) <> '') THEN
          BEGIN
            writeln(lesart, '<LEPRIX>');
            AddValue(lesart, 'TAILLE', tslChamps(lig1, i));
            AddValue(lesart, 'PXCATALOG', tslChampsPrix(tslPx[PosPrix + 1], i));
            AddValue(lesart, 'PXVTE', tslChampsPrix(tslPx[PosPrix + 3], i));
            AddValue(lesart, 'PXACH', tslChampsPrix(tslPx[PosPrix + 2], i));
            writeln(lesart, '</LEPRIX>');
          END;
          inc(i);
        END;
      END;

      writeln(lesart, '</LESPRIX>');

      writeln(lesart, '</ARTICLE>');
    END;
    writeln(lesart, '</ARTICLES>');
    closefile(lesart);

    tslart.free;
    tslcb.free;
    tslfou.free;
    tslGDT.free;
    tslMrk.free;
    tslPx.free;
    tslTai.free;
    ImportXml(ed_rep.text + 'result.xml', Chk_SelectMag.Checked);
  END
  ELSE
  BEGIN
    application.messagebox('Certains fichiers n''existent pas, vérifier votre chemin d''importation', 'ATTENTION', Mb_OK);
  END;
END;

PROCEDURE TForm1.ArtCsvClick(Sender: TObject);
VAR
  tslart: tstringlist;
  tslcb: tstringlist;
  tslfou: tstringlist;
  tslGDT: tstringlist;
  tslMrk: tstringlist;
  tslPx: tstringlist;
  tslTai: tstringlist;
  iart: integer;
  lesart: TextFile;
  PosMrk: integer;
  PosFou: integer;
  PosGDT: integer;
  PosCb: Integer;
  PosPrix: Integer;

  S: STRING;
  tsl: tstringList;
  tsl2: tstringList;

  i: integer;
  lig1: STRING;

  nbart, nbartT: integer;
  nbfich: integer;
  SSFedas: Integer;
  iartLCV: STRING;
  TauxTVA: STRING;
BEGIN
  IF trim(ed_Base.text) = '' THEN
    Application.messagebox('Pas de base, importation terminée', ' Fin ', mb_ok)
  ELSE IF NOT fileexists(ed_Base.text) THEN
    Application.messagebox('La base n''existe pas , importation terminée', ' Fin ', mb_ok)
  ELSE
  BEGIN

    IF fileexists(ed_rep.text + 'fourn.csv') AND
      fileexists(ed_rep.text + 'Marque.csv') AND
      fileexists(ed_rep.text + 'Gr_Taille.csv') AND
      fileexists(ed_rep.text + 'Gr_Taille_Lig.csv') AND
      fileexists(ed_rep.text + 'Articles.csv') AND
      fileexists(ed_rep.text + 'Code_barre.csv') AND
      fileexists(ed_rep.text + 'Prix.csv') THEN
    BEGIN
      tslart := tstringlist.create;
      tslcb := tstringlist.create;
      tslfou := tstringlist.create;
      tslGDT := tstringlist.create;
      tslMrk := tstringlist.create;
      tslPx := tstringlist.create;
      tslTai := tstringlist.create;

      tslart.LoadFromFile(ed_rep.text + 'Articles.csv');
      //      tslart.Delete(0);
            // trier avant de charger Code_Barre
      MemD_TrierCB.DelimiterChar := ';';
      MemD_TrierCB.LoadFromTextFile(ed_rep.text + 'Code_Barre.csv');
      MemD_TrierCB.SaveToTextFile(ed_rep.text + 'Code_Barre2.csv');
      MemD_TrierCB.close;
      tslcb.LoadFromFile(ed_rep.text + 'Code_barre2.csv');
      //      tslcb.Delete(0);

      tslfou.LoadFromFile(ed_rep.text + 'fourn.csv');
      //      tslfou.Delete(0);
      tslGDT.LoadFromFile(ed_rep.text + 'Gr_Taille.csv');
      //      tslGDT.Delete(0);
      tslMrk.LoadFromFile(ed_rep.text + 'Marque.csv');
      //      tslMrk.Delete(0);
            // trier avant de charger Prix
      MemD_TrierPrix.DelimiterChar := ';';
      MemD_TrierPrix.LoadFromTextFile(ed_rep.text + 'Prix.csv');
      MemD_TrierPrix.SaveToTextFile(ed_rep.text + 'Prix2.csv');
      MemD_TrierPrix.close;
      tslPx.LoadFromFile(ed_rep.text + 'Prix2.csv');
      //      tslPx.Delete(0);

      tslTai.LoadFromFile(ed_rep.text + 'Gr_Taille_Lig.csv');
      //      tslTai.Delete(0);

      assignfile(lesart, ed_rep.text + 'result.xml');

      // Besion de se connecter à la base pour tester la NK !!
      Base.close;
      Base.DatabaseName := ed_base.text;
      Base.Open;
      tran_lect.active := true;

      nbart := 0;
      nbfich := 0;
      rewrite(lesart);
      writeln(lesart, '<?xml version="1.0" encoding="ISO-8859-1"?>');
      writeln(lesart, '<ARTICLES>');
      FOR iart := 1 TO tslart.count - 1 DO
      BEGIN
        inc(nbart);
        IF nbart > 1000 THEN
        BEGIN
          writeln(lesart, '</ARTICLES>');
          closefile(lesart);
          inc(nbfich);
          assignfile(lesart, ed_rep.text + 'result' + inttostr(nbfich) + '.xml');
          rewrite(lesart);
          writeln(lesart, '<?xml version="1.0" encoding="ISO-8859-1"?>');
          writeln(lesart, '<ARTICLES>');
          nbart := 0;
        END;
        writeln(lesart, '<ARTICLE>');
        AddValue(lesart, 'CODE', tslChamps(tslart[iart], 1));
        writeln(lesart, '<MARQUE>');
        // recherche de la marque
        S := tslChamps(tslart[iart], 2);
        IF S <> '' THEN
        BEGIN
          PosMrk := chercheVal(tslMrk, 1, S);
          IF PosMrk <> -1 THEN
          BEGIN
            IF tslMrk.Objects[PosMrk] <> NIL THEN
            BEGIN
              // déja recherché
              writeln(lesart, tstringlist(tslMrk.Objects[PosMrk]).Text);
            END
            ELSE
            BEGIN
              tsl := tstringList.create;
              tslMrk.Objects[PosMrk] := tsl;
              AddValue(tsl, 'CODE', tslChamps(tslMrk[PosMrk], 1));
              AddValue(tsl, 'NOM', tslChamps(tslMrk[PosMrk], 3));
              tsl.add('<FOURNISSEUR>');
              S := tslChamps(tslMrk[PosMrk], 2);
              IF S <> '' THEN
              BEGIN
                posfou := chercheVal(tslFou, 1, S);
                IF posfou <> -1 THEN
                BEGIN
                  IF tslFou.Objects[posfou] <> NIL THEN
                  BEGIN
                    tsl.add(Tstringlist(tslFou.Objects[posfou]).Text);
                  END
                  ELSE
                  BEGIN
                    tsl2 := tstringlist.create;
                    tslFou.Objects[posfou] := tsl2;
                    AddValue(tsl2, 'CODE', tslchamps(tslFou[posfou], 1));
                    AddValue(tsl2, 'NOM', tslchamps(tslFou[posfou], 2));
                    tsl2.add('<ADRESSE>');
                    AddValue(tsl2, 'LIGNE1', tslchamps(tslFou[posfou], 3));
                    AddValue(tsl2, 'LIGNE2', tslchamps(tslFou[posfou], 4));
                    AddValue(tsl2, 'LIGNE3', tslchamps(tslFou[posfou], 5));
                    AddValue(tsl2, 'CP', tslchamps(tslFou[posfou], 6));
                    AddValue(tsl2, 'VILLE', tslchamps(tslFou[posfou], 7));
                    AddValue(tsl2, 'PAYS', tslchamps(tslFou[posfou], 8));
                    AddValue(tsl2, 'TEL', tslchamps(tslFou[posfou], 9));
                    AddValue(tsl2, 'FAX', tslchamps(tslFou[posfou], 10));
                    AddValue(tsl2, 'PORTABLE', tslchamps(tslFou[posfou], 11));
                    AddValue(tsl2, 'EMAIL', tslchamps(tslFou[posfou], 12));
                    AddValue(tsl2, 'COMMENTAIRE', tslchamps(tslFou[posfou], 13));
                    tsl2.add('</ADRESSE>');
                    AddValue(tsl2, 'NUM_CLT_FOU', tslchamps(tslFou[posfou], 14));
                    AddValue(tsl2, 'COND_PAIE', tslchamps(tslFou[posfou], 15));
                    tsl.add(tsl2.text);
                  END;
                END;
              END;
              tsl.add('</FOURNISSEUR>');
              writeln(lesart, tsl.text);
            END;
          END;
        END;
        writeln(lesart, '</MARQUE>');

        // recherche de la grille de tailles
        writeln(lesart, '<GRILLE_TAILLES>');
        S := UPPERCASE(trim(tslChamps(tslart[iart], 3)));
        IF s <> '' THEN
        BEGIN
          PosGDT := chercheVal(tslGDT, 1, S);
          IF PosGDT <> -1 THEN
          BEGIN
            IF tslGDT.Objects[PosGDT] <> NIL THEN
            BEGIN
              writeln(lesart, Tstringlist(tslGDT.Objects[PosGDT]).text);
            END
            ELSE
            BEGIN
              tsl := tstringlist.create;
              tslGDT.Objects[PosGDT] := tsl;
              AddValue(tsl, 'CODE', tslChamps(tslGDT[PosGDT], 1));
              AddValue(tsl, 'NOM_GRILLE', tslChamps(tslGDT[PosGDT], 2));
              AddValue(tsl, 'TYPE_GRILLE', tslChamps(tslGDT[PosGDT], 3));
              tsl.add('<TAILLES>');
              FOR i := 1 TO tslTai.count - 1 DO
              BEGIN
                IF tslChamps(tslTai[i], 1) = S THEN
                BEGIN
                  tsl.add('<TAILLE>');
                  IF (tslChamps(tslTai[i], 2) = '') THEN
                    AddValue(tsl, 'NOM', 'UNIQUE')
                  ELSE
                    AddValue(tsl, 'NOM', tslChamps(tslTai[i], 2));
                  tsl.add('</TAILLE>');
                END;
              END;
              tsl.add('</TAILLES>');
              writeln(lesart, tsl.text);
            END;
          END;
        END;
        writeln(lesart, '</GRILLE_TAILLES>');

        AddValue(lesart, 'CODE_FOU', tslChamps(tslart[iart], 4));
        AddValue(lesart, 'NOM', tslChamps(tslart[iart], 5));
        AddValue(lesart, 'DESCRIPTION', tslChamps(tslart[iart], 6));
        AddValue(lesart, 'DATE', tslChamps(tslart[iart], 38));
        TRY
          IF (tslChamps(tslart[iart], 37) = 'OUI') THEN
            AddValue(lesart, 'FIDELITE', '1')
          ELSE AddValue(lesart, 'FIDELITE', '0')
        EXCEPT
          AddValue(lesart, 'FIDELITE', '1'); // si le champs n'est pas traité, c'est oui par défaut....
        END;
        TRY
          AddValue(lesart, 'COMENT1', tslChamps(tslart[iart], 40));
        EXCEPT
          AddValue(lesart, 'COMENT1', '');
        END;
        TRY
          AddValue(lesart, 'COMENT2', tslChamps(tslart[iart], 41));
        EXCEPT
          AddValue(lesart, 'COMENT2', '');
        END;
        TRY
          // attention la valeur sera de type FLOTA donc '.' et non ','
          TauxTVA := tslChamps(tslart[iart], 42);
          IF (pos(',', TauxTVA) <> 0) THEN
            TauxTVA := StringReplace(TauxTVA, ',', '.', []);
          AddValue(lesart, 'TVA', TauxTVA);
        EXCEPT
          AddValue(lesart, 'TVA', '');
        END;

        // Si le code FEDAS est présent faire une recherche
        SSFedas := 0;
        TRY
          SSFedas := StrToInt(tslChamps(tslart[iart], 16));
        EXCEPT
          SSFedas := 0;
        END;

        IF (SSFedas <> 0) THEN
        BEGIN
          qry.close;
          qry.sql.text := 'SELECT SSF_NOM, FAM_NOM, RAY_NOM  ' +
            'FROM NKLRAYON JOIN K KR on (KR.K_ID=RAY_ID and KR.K_ENABLED=1) ' +
            'JOIN NKLFAMILLE on (FAM_RAYID=RAY_ID) JOIN K KF on (KF.K_ID=FAM_ID and KF.K_ENABLED=1) ' +
            'JOIN NKLSSFAMILLE on (SSF_FAMID=FAM_ID) JOIN K KSF on (KSF.K_ID=SSF_ID and KSF.K_ENABLED=1) ' +
            'WHERE SSF_IDREF=' + QuotedStr(tslChamps(tslart[iart], 16));
          qry.Open;
          IF NOT (qry.IsEmpty) THEN
          BEGIN
            writeln(lesart, '<SS_FAMILLE>');
            AddValue(lesart, 'NOM', qry.Fields[0].AsString);
            writeln(lesart, '<FAMILLE>');
            AddValue(lesart, 'NOM', qry.Fields[1].AsString);
            writeln(lesart, '<RAYON>');
            AddValue(lesart, 'NOM', qry.Fields[2].AsString);
            writeln(lesart, '</RAYON>');
            writeln(lesart, '</FAMILLE>');
            writeln(lesart, '</SS_FAMILLE>');
          END
          ELSE // CAS SANS FEDAS - IDEM CI DESSOUS
            SSFedas := 0;
        END;
        // CAS SANS FEDAS
        IF (SSFedas = 0) THEN
        BEGIN
          writeln(lesart, '<SS_FAMILLE>');
          AddValue(lesart, 'NOM', tslChamps(tslart[iart], 9));
          writeln(lesart, '<FAMILLE>');
          AddValue(lesart, 'NOM', tslChamps(tslart[iart], 8));
          writeln(lesart, '<RAYON>');
          AddValue(lesart, 'NOM', tslChamps(tslart[iart], 7));
          writeln(lesart, '</RAYON>');
          writeln(lesart, '</FAMILLE>');
          writeln(lesart, '</SS_FAMILLE>');
        END;
        AddValue(lesart, 'GENRE', tslChamps(tslart[iart], 10));
        AddValue(lesart, 'CLASSEMENT1', tslChamps(tslart[iart], 11));
        AddValue(lesart, 'CLASSEMENT2', tslChamps(tslart[iart], 12));
        AddValue(lesart, 'CLASSEMENT3', tslChamps(tslart[iart], 13));
        AddValue(lesart, 'CLASSEMENT4', tslChamps(tslart[iart], 14));
        AddValue(lesart, 'CLASSEMENT5', tslChamps(tslart[iart], 15));

        TRY
          AddValue(lesart, 'COLLECTION', tslChamps(tslart[iart], 39));
        EXCEPT
          AddValue(lesart, 'COLLECTION', '');
        END;

        writeln(lesart, '<COULEURS>');
        i := 17;
        REPEAT
          S := TRIM(tslChamps(tslart[iart], i));
          IF ((i = 17) AND (s = '')) THEN
            s := 'UNICOLOR';
          IF s <> '' THEN
          BEGIN
            writeln(lesart, '<COULEUR>');
            AddValue(lesart, 'NOM', S);
            writeln(lesart, '</COULEUR>');
          END;
          inc(i);
        UNTIL s = '';
        writeln(lesart, '</COULEURS>');
        writeln(lesart, '<CODE_BARRES>');
        // regarder PB si CB pas consécutif !!!!
        PosCb := chercheVal(tslcb, 1, tslChamps(tslart[iart], 1));
        IF PosCb <> -1 THEN
        BEGIN
          WHILE (PosCb < tslcb.count)
            AND (TRIM(tslChamps(tslart[iart], 1)) = TRIM(tslChamps(tslcb[PosCb], 1))) DO // car le fichier a été trié avant
          BEGIN
            lig1 := tslcb[PosCb];
            writeln(lesart, '<CODE_BARRE>');
            IF (tslChamps(lig1, 2) = '') THEN
              AddValue(lesart, 'TAILLE', 'UNIQUE')
            ELSE
              AddValue(lesart, 'TAILLE', tslChamps(lig1, 2));
            IF (TRIM(tslChamps(lig1, 3)) = '') THEN
              AddValue(lesart, 'COULEUR', 'UNICOLOR')
            ELSE
              AddValue(lesart, 'COULEUR', TRIM(tslChamps(lig1, 3)));
            AddValue(lesart, 'EAN', TRIM(tslChamps(lig1, 4)));
            AddValue(lesart, 'QTTE', tslChamps(lig1, 5));
            writeln(lesart, '</CODE_BARRE>');
            inc(PosCb);
          END;
        END;
        writeln(lesart, '</CODE_BARRES>');

        writeln(lesart, '<LESPRIX>');
        PosPrix := chercheVal(tslPx, 1, tslChamps(tslart[iart], 1));
        IF posprix <> -1 THEN
        BEGIN
          WHILE (posprix < tslPx.count) AND
            (tslChamps(tslart[iart], 1) = tslChamps(tslPx[PosPrix], 1)) DO // car le fichier a été trié avant
          BEGIN
            writeln(lesart, '<LEPRIX>');
            IF (tslChamps(tslPx[PosPrix], 2) = '') THEN
              AddValue(lesart, 'TAILLE', 'UNIQUE')
            ELSE AddValue(lesart, 'TAILLE', tslChamps(tslPx[PosPrix], 2));
            AddValue(lesart, 'PXCATALOG', tslChampsPrix(tslPx[PosPrix], 3));
            AddValue(lesart, 'PXVTE', tslChampsPrix(tslPx[PosPrix], 5));
            AddValue(lesart, 'PXACH', tslChampsPrix(tslPx[PosPrix], 4));
            AddValue(lesart, 'CODE_FOU', tslChamps(tslPx[PosPrix], 6));
            writeln(lesart, '</LEPRIX>');
            inc(posprix);
          END;
        END
        ELSE
        BEGIN
          IF Chk_LCVMag.Checked THEN
          BEGIN
            iartLCV := copy(tslChamps(tslart[iart], 1), 0, 5);
            PosPrix := chercheVal(tslPx, 1, iartLCV);
            IF posprix <> -1 THEN
            BEGIN
              WHILE (posprix < tslPx.count) AND
                (iartLCV = tslChamps(tslPx[PosPrix], 1)) DO
              BEGIN
                writeln(lesart, '<LEPRIX>');
                IF (tslChamps(tslPx[PosPrix], 2) = '') THEN
                  AddValue(lesart, 'TAILLE', 'UNIQUE')
                ELSE AddValue(lesart, 'TAILLE', tslChamps(tslPx[PosPrix], 2));
                AddValue(lesart, 'PXCATALOG', tslChampsPrix(tslPx[PosPrix], 3));
                AddValue(lesart, 'PXVTE', tslChampsPrix(tslPx[PosPrix], 5));
                AddValue(lesart, 'PXACH', tslChampsPrix(tslPx[PosPrix], 4));
                AddValue(lesart, 'CODE_FOU', tslChamps(tslPx[PosPrix], 6));
                writeln(lesart, '</LEPRIX>');
                inc(posprix);
              END;
            END;
          END;
        END;

        writeln(lesart, '</LESPRIX>');

        writeln(lesart, '</ARTICLE>');
      END;
      writeln(lesart, '</ARTICLES>');
      closefile(lesart);

      tslart.free;
      tslcb.free;
      tslfou.free;
      tslGDT.free;
      tslMrk.free;
      tslPx.free;
      tslTai.free;
      ImportXml(ed_rep.text + 'result.xml', Chk_SelectMag.Checked, Nbfich);
    END
    ELSE
    BEGIN
      application.messagebox('Certains fichiers n''existent pas, vérifier votre chemin d''importation', 'ATTENTION', Mb_OK);
    END;
  END;
  Base.close;
END;

PROCEDURE TForm1.SpeedButton2Click(Sender: TObject);
BEGIN
  IF od.Execute THEN
    ed_Base.Text := od.FileName;
END;

FUNCTION TForm1.Stock_GetArticle(ACB, AArtId, AArtChrono: STRING): TArtTailCoul;
BEGIN
  Result.iArtId := 0;
  Result.iTgfId := 0;
  Result.iGtfId := 0;
  Result.iCouId := 0;

  // Recherche par code barre
  IF ACB <> '' THEN
  BEGIN
    // Recherche sur type 1 (CB Ginkoia)
    Qry.Close;
    Qry.SQL.Text := 'SELECT ART_ID, ART_GTFID, GTF_NOM, CBI_TGFID, CBI_COUID' +
      '  FROM ARTCODEBARRE' +
      '  JOIN K ON (K_ID=CBI_ID AND K_ENABLED=1)' +
      '  JOIN ARTREFERENCE ON (CBI_ARFID=ARF_ID)' +
      '  JOIN ARTARTICLE ON (ARF_ARTID=ART_ID)' +
      '  JOIN PLXGTF ON (GTF_ID=ART_GTFID)' +
      ' WHERE CBI_TYPE = 1' +
      '   AND CBI_CB = ' + ACB;
    Qry.Open;

    // Recherche sur type 3 (Cb Fournisseurs)
    IF Qry.IsEmpty THEN
    BEGIN
      Qry.Close;
      Qry.SQL.Text := 'SELECT ART_ID, ART_GTFID, GTF_NOM, CBI_TGFID, CBI_COUID' +
        '  FROM ARTCODEBARRE' +
        '  JOIN K ON (K_ID=CBI_ID AND K_ENABLED=1)' +
        '  JOIN ARTREFERENCE ON (CBI_ARFID=ARF_ID)' +
        '  JOIN ARTARTICLE ON (ARF_ARTID=ART_ID)' +
        '  JOIN PLXGTF ON (GTF_ID=ART_GTFID)' +
        ' WHERE CBI_TYPE = 3' +
        '   AND CBI_CB = ' + ACB;
      Qry.Open;
    END;

    Result.iArtId := Qry.Fields[0].AsInteger;
    Result.iGtfId := Qry.Fields[1].AsInteger;
    Result.sGtfNom := Qry.Fields[2].AsString;
    Result.iTgfId := Qry.Fields[3].AsInteger;
    Result.iCouId := Qry.Fields[4].AsInteger;
  END;

  IF Result.iArtId = 0 THEN
  BEGIN
    IF AArtId <> '' THEN
    BEGIN
      // Recherche de l'article par ID
      Qry.Close;
      Qry.SQL.Text := 'SELECT ART_ID, ART_GTFID, GTF_NOM'
        + '  FROM ARTARTICLE'
        + '  JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)'
        + '  JOIN PLXGTF ON (GTF_ID=ART_GTFID)'
        + ' WHERE ART_ID <> 0'
        + '   AND ART_ID = ' + AArtId;
      Qry.Open;

      Result.iArtId := Qry.Fields[0].AsInteger;
      Result.iGtfId := Qry.Fields[1].AsInteger;
      Result.sGtfNom := Qry.Fields[2].AsString;
    END;

    IF Result.iArtId = 0 THEN
    BEGIN
      IF AArtChrono <> '' THEN
      BEGIN
        // Recherche article par Chrono
        Qry.Close;
        Qry.SQL.Text := 'SELECT ART_ID, ART_GTFID, GTF_NOM' +
          '  FROM ARTARTICLE' +
          '  JOIN K ON (K_ID=ART_ID AND K_ENABLED=1)' +
          '  JOIN ARTREFERENCE ON (ARF_ARTID=ART_ID)' +
          '  JOIN PLXGTF ON (GTF_ID=ART_GTFID)' +
          ' WHERE ART_ID <> 0' +
          '   AND ARF_CHRONO = ' + QuotedStr(AArtChrono);
        Qry.Open;

        Result.iArtId := Qry.Fields[0].AsInteger;
        Result.iGtfId := Qry.Fields[1].AsInteger;
        Result.sGtfNom := Qry.Fields[2].AsString;
      END;
    END;
  END;
END;

FUNCTION TForm1.Stock_GetCouId(AArtId:Integer; ACouId, ACouNom: STRING): Integer;
BEGIN
  Result := 0;

  IF ACouId <> '' THEN
  BEGIN
    Qry.Close;
    Qry.SQL.Text := 'SELECT COU_ID' +
      '  FROM PLXCOULEUR' +
      '       JOIN K ON (K_ID=COU_ID AND K_ENABLED=1)' +
      ' WHERE COU_ID <> 0' +
      '   AND COU_ID = ' + ACouId;
    Qry.Open;

    Result := Qry.Fields[0].AsInteger;
  END;

  // Si pas trouvé
  IF Result = 0 THEN
  BEGIN
    // Vide = unicolor
    IF ACouNom = '' THEN
      ACouNom := 'UNICOLOR';

    // Recherche de la couleur par libellé
    Qry.Close;
    Qry.SQL.Text := 'SELECT COU_ID' +
      '  FROM PLXCOULEUR' +
      '       JOIN K ON (K_ID=COU_ID AND K_ENABLED=1)' +
      ' WHERE COU_ID <> 0'+
      '   AND COU_ARTID = ' + IntTostr(AArtId) +
      '   AND UPPER(COU_NOM) = ' + QuotedStr(UpperCase(ACouNom));
    Qry.Open;

    Result := Qry.Fields[0].AsInteger;
  END;
END;

FUNCTION TForm1.Stock_GetMagId(AMagId: STRING; ADefaultMagId: Integer): Integer;
BEGIN
  // Récup de l'id Magasin
  TRY
    Result := StrToInt(AMagId)
  EXCEPT
    Result := 0;
  END;

  IF Result = 0 THEN
    Result := ADefaultMagId;

  // Vérifie que l'id existe bien dans la base
  Qry.Close;
  Qry.SQL.Text := 'SELECT MAG_ID' +
    '  FROM GENMAGASIN' +
    '       JOIN K ON (K_ID=MAG_ID AND K_ENABLED=1)' +
    ' WHERE MAG_ID = ' + IntToStr(Result);
  Qry.Open;

  Result := Qry.Fields[0].AsInteger;

END;

FUNCTION TForm1.Stock_GetTgfId(ATgfId, ATgfNom, AGtfId: STRING): Integer;
BEGIN
  Result := 0;

  IF AGtfId = '' THEN
    EXIT;

  // Recherche de la taille dans la grille de taille par ID
  IF ATgfId <> '' THEN
  BEGIN
    Qry.Close;
    Qry.SQL.Text := 'SELECT TGF_ID' +
      '  FROM PLXTAILLESGF' +
      '       JOIN K ON (K_ID=TGF_ID AND K_ENABLED=1)' +
      ' WHERE TGF_ID <> 0' +
      '   AND TGF_GTFID = ' + AGtfId +
      '   AND TGF_ID = ' + ATgfId;
    Qry.Open;

    Result := Qry.Fields[0].AsInteger;
  END;

  // Si pas trouvé
  IF Result = 0 THEN
  BEGIN
    // Vide = taille unique
    IF ATgfNom = '' THEN
      ATgfNom := 'UNIQUE';

    // Recherche de la taille dans la grille de taille par Libellé
    Qry.Close;
    Qry.SQL.Text := 'SELECT TGF_ID' +
      '  FROM PLXTAILLESGF' +
      '       JOIN K ON (K_ID=TGF_ID AND K_ENABLED=1)' +
      ' WHERE TGF_ID <> 0' +
      '   AND TGF_GTFID = ' + AGtfId +
      '   AND UPPER(TGF_NOM) = ' + QuotedStr(UpperCase(ATgfNom));
    Qry.Open;

    Result := Qry.Fields[0].AsInteger;
  END;
END;

PROCEDURE TForm1.Stock_VerifTtv(ATgfId, AArtId: STRING; ACodeArt, AChrono, ATgfNom, AGtfNom: STRING);
VAR
  iId: Integer;
BEGIN
  IF (ATgfId <> '0') AND (AArtId <> '0') THEN
  BEGIN
    Qry.Close;
    Qry.SQL.Text := 'SELECT TTV_ID' +
      '  FROM PLXTAILLESTRAV' +
      '       JOIN K ON (K_ID=TTV_ID AND K_ENABLED=1)' +
      ' WHERE TTV_TGFID =' + ATgfId +
      '   AND TTV_ARTID = ' + AArtId;
    Qry.Open;

    IF Qry.IsEmpty THEN
    BEGIN
      // Creation TTV
      qry.close;
      qry.Sql.text := 'SELECT ID FROM PR_NEWK (''PLXTAILLESTRAV'')';
      qry.open;

      iId := qry.fields[0].AsInteger;
      sql.sql.text := 'INSERT INTO PLXTAILLESTRAV ' +
        '(TTV_ID, TTV_ARTID, TTV_TGFID)' +
        ' VALUES' +
        ' (' + IntToStr(iId) + ',' + AArtId + ',' + ATgfId + ')';
      sql.ExecQuery;

      writeln(Log, '<STOCK>');
      AddValue(Log, 'CODE', ACodeArt);
      AddValue(Log, 'CHRONO', AChrono);
      AddValue(Log, 'TAILLE', ATgfNom);
      AddValue(Log, 'GRILLE_TAILLE', AGtfNom);
      AddValue(Log, 'INFO', 'Taille ajoutée aux tailles travaillées');
      writeln(Log, '</STOCK>');
    END;
  END;
END;

FUNCTION TForm1.StrToId(S: STRING): Integer;
BEGIN
  TRY
    Result := StrToInt(S);
  EXCEPT
    Result := 0;
  END;
END;

FUNCTION TForm1.ImportAdr(Adr: TIcXMLElement): STRING;
VAR
  Pays: STRING;
  idP: STRING;
  idV: STRING;
  idA: STRING;

  S: STRING;
  Tel, fax, port, email, com: STRING;
BEGIN
  // on cherche le pays
  Pays := UPPERCASE(TRIM(leXml.ValueTag(adr, 'PAYS')));
  tel := TRIM(leXml.ValueTag(adr, 'TEL'));
  fax := TRIM(leXml.ValueTag(adr, 'FAX'));
  IF fax = '' THEN
    fax := TRIM(leXml.ValueTag(adr, 'TEL_TRAV'));
  port := TRIM(leXml.ValueTag(adr, 'PORTABLE'));
  email := TRIM(leXml.ValueTag(adr, 'EMAIL'));
  com := TRIM(leXml.ValueTag(adr, 'COMMENTAIRE'));
  IF pays = '' THEN pays := 'FRANCE';

  qry.close;
  qry.sql.text := 'Select PAY_ID from GENPAYS join K on (K_ID=PAY_ID and K_Enabled=1) Where UPPER(PAY_NOM)=' + QuotedStr(Pays);
  qry.Open;
  IF qry.IsEmpty THEN
  BEGIN
    // création du pays
    qry.close;
    qry.sql.text := 'SELECT ID FROM PR_NEWK (''GENPAYS'')';
    qry.Open;
    idp := qry.Fields[0].AsString;
    Sql.SQL.text := 'INSERT INTO GENPAYS (PAY_ID, PAY_NOM) VALUES (' + idp + ',' + QuotedStr(pays) + ')';
    Sql.ExecQuery;
  END
  ELSE
    idp := qry.Fields[0].AsString;
  // on cherche le CP+VILLE
  qry.close;
  qry.sql.text := 'Select VIL_ID from GENVILLE join K on (K_ID=VIL_ID and K_Enabled=1) ' +
    '  Where VIL_PAYID=' + idp +
    ' and VIL_CP=' + QuotedStr(TRIM(leXml.ValueTag(adr, 'CP'))) +
    ' and UPPER(VIL_NOM)= UPPER(' + QuotedStr(TRIM(leXml.ValueTag(adr, 'VILLE'))) + ')';
  qry.Open;
  IF qry.IsEmpty THEN
  BEGIN
    qry.close;
    qry.sql.text := 'SELECT ID FROM PR_NEWK (''GENVILLE'')';
    qry.Open;
    idV := qry.Fields[0].AsString;
    Sql.SQL.text := 'INSERT INTO GENVILLE (VIL_ID, VIL_NOM, VIL_CP, VIL_PAYID) VALUES (' +
      idV + ',' + QuotedStr(UPPERCASE(leXml.ValueTag(adr, 'VILLE'))) +
      ',' + QuotedStr(leXml.ValueTag(adr, 'CP')) + ',' + idP + ')';
    Sql.ExecQuery;
  END
  ELSE
    idV := qry.fields[0].asString;
  qry.close;
  qry.sql.text := 'SELECT ID FROM PR_NEWK (''GENADRESSE'')';
  qry.Open;
  ida := qry.Fields[0].AsString;
  qry.Close;
  S := leXml.ValueTag(adr, 'LIGNE1');
  IF leXml.ValueTag(adr, 'LIGNE2') <> '' THEN
    S := S + #10 + leXml.ValueTag(adr, 'LIGNE2');
  IF leXml.ValueTag(adr, 'LIGNE3') <> '' THEN
    S := S + #10 + leXml.ValueTag(adr, 'LIGNE3');
  Sql.sql.Text := 'Insert into GENADRESSE ' +
    ' (ADR_ID, ADR_LIGNE, ADR_VILID, ADR_TEL, ADR_FAX, ADR_GSM, ADR_EMAIL, ADR_COMMENT) ' +
    ' Values ' +
    ' (' + ida + ',' + QuotedStr(UPPERCASE(S)) + ',' + IdV + ',' + QuotedStr(Tel) + ',' + QuotedStr(fax) + ',' + QuotedStr(port) + ',' +
    QuotedStr(email) + ',' + QuotedStr(com) + ')';
  sql.ExecQuery;
  result := ida;
END;

FUNCTION TForm1.ImportFou(Art, Fou: TIcXMLElement): boolean;
VAR
  Code: STRING;
  Nom: STRING;
  pass, Adr: TIcXMLElement;
  idA: STRING;
  idf: STRING;
  idfd: STRING;
  idcon: STRING;
  CPAID: STRING;
  S, impid: STRING;
BEGIN
  IF fou = NIL THEN
  BEGIN
    result := false;
    //        LeXml.AddNode('ERREUR', 'Impossible de créer un article sans fournisseur', art);
    writeln(Log, '<ARTICLE>');
    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
    AddValue(Log, 'ERREUR', 'Impossible de créer un article sans fournisseur');
    writeln(Log, '</ARTICLE>');
  END
  ELSE
  BEGIN
    Code := LeXml.ValueTag(fou, 'CODE');
    IF code <> '' THEN
    BEGIN
      // on regarde si on à pas déjà le fou qquepart dans le fichier
      IF lesfou.indexof(Code) <> -1 THEN
      BEGIN
        pass := TIcXMLElement(lesfou.objects[lesfou.indexof(Code)]);
        LeXml.AddNode('ID', LeXml.ValueTag(pass, 'ID'), fou);
        LeXml.AddNode('FOUID', LeXml.ValueTag(pass, 'ID'), art);
        LeXml.AddNode('CREAT', LeXml.ValueTag(pass, 'CREAT'), fou);
        result := true;
        EXIT;
      END
    END;
    // on cherche si un fourn de ce nom existe dans la base ;
    Nom := LeXml.ValueTag(fou, 'NOM');
    Qry.sql.clear;
    Qry.sql.Add('Select FOU_ID');
    Qry.sql.Add('From ArtFourn join k on (k_id=fou_id and k_enabled=1)');
    Qry.sql.Add('Where UPPER(FOU_NOM)=' + UPPERCASE(QuotedStr(Nom)));
    Qry.Open;
    IF NOT Qry.IsEmpty THEN
    BEGIN
      // on prend le fou
      LeXml.AddNode('ID', qry.fields[0].AsString, fou);
      LeXml.AddNode('CREAT', 'NON', fou);
      LeXml.AddNode('FOUID', qry.fields[0].AsString, art);
      IF code <> '' THEN
      BEGIN
        pass := TIcXMLElement.Create('FOURNISSEUR', LeXml.doc);
        LeXml.AddNode('ID', qry.fields[0].AsString, pass);
        LeXml.AddNode('CREAT', 'NON', pass);
        LeXml.AddNode('CODE', lexml.ValueTag(fou, 'CODE'), pass);
        LeXml.AddNode('NOM', lexml.ValueTag(fou, 'NOM'), pass);
        Lesfou.AddObject(Code, pass);
      END;
      result := true;
      Qry.Close;
      EXIT;
    END;
    Qry.Close;
    // Pas de fournisseur on le creer
    idA := ImportAdr(lexml.findtag(fou, 'ADRESSE'));
    Adr := lexml.findtag(fou, 'ADRESSE');
    qry.close;
    qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTFOURN'')';
    qry.Open;
    idf := qry.fields[0].asString;
    qry.close;
    sql.sql.text := 'Insert into ARTFOURN (' +
      'FOU_ID,FOU_IDREF,FOU_NOM,FOU_ADRID,FOU_TEL,FOU_FAX,' +
      'FOU_EMAIL,FOU_REMISE,FOU_GROS,FOU_CDTCDE,FOU_CODE,FOU_TEXTCDE' +
      ') Values (' +
      idf + ',0,' + quotedstr(Nom) + ',' + ida + ',' + quotedstr(lexml.ValueTag(Adr, 'TEL')) + ',' + quotedstr(lexml.ValueTag(Adr, 'FAX')) +
      ',' + quotedstr(lexml.ValueTag(Adr, 'EMAIL')) + ',0,0,'''',' + quotedstr(code) + ','''')';
    sql.ExecQuery;

    // memoriser FOU dans GenIMPORT
    qry.close;
    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''GENIMPORT'')';
    qry.open;
    impid := qry.fields[0].AsString;
    IBSql_Import.sql.text := 'insert into GENIMPORT(IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REF,IMP_NUM,IMP_REFSTR)' +
      'values (' + impid + ',-11111385,' + idf + ',-1,0,' + quotedstr(lexml.ValueTag(fou, 'CODE')) + ')';
    IBSql_Import.ExecQuery;

    // création du artfoudetail
    qry.close;
    qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTFOURNDETAIL'')';
    qry.Open;
    idfd := qry.fields[0].asString;
    qry.Close;
    S := lexml.ValueTag(fou, 'COND_PAIE');
    IF s = '' THEN
      CPAID := '0'
    ELSE
    BEGIN
      Qry.close;
      Qry.Sql.text := 'Select CPA_ID from gencdtpaiement where UPPER(CPA_NOM)=' + UPPERCASE(Quotedstr(s));
      Qry.Open;
      IF Qry.isempty THEN
        CPAID := '0'
      ELSE
        CPAID := qry.fields[0].AsString;
    END;
    sql.sql.text := 'Insert into ARTFOURNDETAIL (' +
      'FOD_ID, FOD_FOUID, FOD_MAGID, FOD_NUMCLIENT, FOD_COMENT, FOD_FTOID, FOD_MRGID, FOD_CPAID, FOD_ENCOURSA' +
      ') Values (' +
      idfd + ',' + idf + ',0,'''','''',0,0,' + CPAID + ',0)';
    sql.ExecQuery;

    // création du contact si Portable à mettre en place
    IF (lexml.ValueTag(Adr, 'PORTABLE') <> '') THEN
    BEGIN
      qry.close;
      qry.sql.text := 'SELECT ID FROM PR_NEWK (''ARTCONTACT'')';
      qry.Open;
      idcon := qry.fields[0].asString;
      qry.Close;
      sql.sql.text := 'INSERT INTO ARTCONTACT(CON_ID, CON_FOUID, CON_FTOID, CON_NOM, CON_PRENOM,' +
        'CON_FONCTION, CON_TEL,' +
        'CON_PORTABLE, CON_EMAIL, CON_COMENT) VALUES (' +
        idcon + ',' + idf + ', 0,''détail contact'','''','''',' + quotedstr(lexml.ValueTag(Adr, 'TEL')) + ',' +
        quotedstr(lexml.ValueTag(Adr, 'PORTABLE')) + ',' + quotedstr(lexml.ValueTag(Adr, 'EMAIL')) + ','''')';
      sql.ExecQuery;
    END;
    pass := TIcXMLElement.Create('FOURNISSEUR', LeXml.doc);
    LeXml.AddNode('FOUID', idf, art);

    LeXml.AddNode('ID', idf, pass);
    LeXml.AddNode('CREAT', 'OUI', pass);
    LeXml.AddNode('CODE', lexml.ValueTag(fou, 'CODE'), pass);
    LeXml.AddNode('NOM', lexml.ValueTag(fou, 'NOM'), pass);
    Lesfou.AddObject(Code, pass);
    result := true;
  END;
END;

FUNCTION TForm1.ImportMarque(Art, Marque: TIcXMLElement): boolean;
VAR
  idf: STRING;
  idm: STRING;
  idmrkf: STRING;
BEGIN
  IF marque = NIL THEN
  BEGIN
    result := false;
    //        LeXml.AddNode('ERREUR', 'Impossible de créer un article sans marque', art);
    writeln(Log, '<ARTICLE>');
    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
    AddValue(Log, 'ERREUR', 'Impossible de créer un article sans marque');
    writeln(Log, '</ARTICLE>');
  END
  ELSE IF NOT (ImportFou(Art, lexml.findtag(Marque, 'FOURNISSEUR'))) THEN
    result := false
  ELSE
  BEGIN
    IF UPPERCASE(QuotedStr(LeXml.ValueTag(Marque, 'NOM'))) = '' THEN
    BEGIN
      result := false;
      //            LeXml.AddNode('ERREUR', 'Impossible de créer un article sans marque', art);
      writeln(Log, '<ARTICLE>');
      AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
      AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
      AddValue(Log, 'ERREUR', 'Impossible de créer un article sans marque');
      writeln(Log, '</ARTICLE>');
    END
    ELSE
    BEGIN
      idf := LeXml.ValueTag(art, 'FOUID');
      // on cherche si la marque existe déjà dans le fichier
      // si la Marque et créée -> FMK_PRIN=1 autrement Fmk_prin=0
      qry.close;
      qry.Sql.text := 'Select MRK_ID from ARTMARQUE join K on (K_ID=MRK_ID and K_ENABLED=1) Where UPPER(MRK_NOM)=' + UPPERCASE(QuotedStr(LeXml.ValueTag(Marque, 'NOM')));
      qry.Open;
      IF qry.isEmpty THEN
      BEGIN
        qry.Close;
        qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTMARQUE'')';
        qry.Open;
        idm := qry.fields[0].AsString;
        qry.close;
        sql.sql.text := 'insert into ARTMARQUE (' +
          'MRK_ID,MRK_IDREF,MRK_NOM,MRK_CONDITION,MRK_CODE' +
          ') Values (' +
          idm + ',0,' + UPPERCASE(QuotedStr(LeXml.ValueTag(Marque, 'NOM'))) + ','''',' + QuotedStr(LeXml.ValueTag(Marque, 'CODE')) + ')';
        sql.ExecQuery;
        LeXml.AddNode('ID', idm, Marque);
        LeXml.AddNode('MRKID', idm, art);
        LeXml.AddNode('CREAT', 'OUI', Marque);
        qry.Close;
        qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTMRKFOURN'')';
        qry.Open;
        idmrkf := qry.fields[0].AsString;
        Sql.sql.text := 'Insert into ARTMRKFOURN (FMK_ID, FMK_FOUID, FMK_MRKID, FMK_PRIN) ' +
          ' Values (' + idmrkf + ',' + idf + ',' + idm + ',1)';
        Sql.ExecQuery;
        result := true;
      END
      ELSE
      BEGIN
        idm := qry.fields[0].AsString;
        LeXml.AddNode('ID', idm, Marque);
        LeXml.AddNode('MRKID', idm, art);
        LeXml.AddNode('CREAT', 'NON', Marque);

        qry.Close;
        qry.Sql.text := 'SELECT FMK_ID from ARTMRKFOURN join k on (k_id=fmk_id and k_enabled=1) ' +
          ' where FMK_FOUID=' + idf + ' and FMK_MRKID=' + idm;
        qry.open;
        IF qry.isempty THEN
        BEGIN
          qry.Close;
          qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTMRKFOURN'')';
          qry.Open;
          idmrkf := qry.fields[0].AsString;
          Sql.sql.text := 'Insert into ARTMRKFOURN (FMK_ID, FMK_FOUID, FMK_MRKID, FMK_PRIN) ' +
            ' Values (' + idmrkf + ',' + idf + ',' + idm + ',0)';
          Sql.ExecQuery;
        END;
        result := true;
      END;
    END;
  END;
END;

PROCEDURE TForm1.ImportStockXml(ADefaultMagId: integer);
VAR
  iNumFic: Integer;
  sNomFic: STRING;
  bStopProcess: Boolean;
BEGIN
  iNumFic := 0;
  bStopProcess := False;

  assignfile(Log, ed_rep.text + 'LogStock.xml');
  rewrite(Log);
  writeln(Log, '<STOCKS>');

  TRY
    // Connexion à la base
    Base.close;
    Base.DatabaseName := ed_base.text;
    Base.Open;

    tran_lect.active := true;
    tran_ecr.active := true;

    // On va proposer de choisir un magasin
    IF ADefaultMagId = 0 THEN
    BEGIN
      // choisir le magasin d'importation
      qry.close;
      qry.sql.text := 'select MAG_ID, MAG_NOM from genmagasin join k on (k_id=mag_id and k_enabled=1) where mag_id<>0';
      qry.Open;
      application.createform(Tfrm_ChxMag, frm_ChxMag);
      WHILE NOT qry.Eof DO
      BEGIN
        frm_ChxMag.Lb_Mag.items.AddObject(Qry.fields[1].AsString, pointer(Qry.fields[0].asInteger));
        qry.Next;
      END;
      qry.close;
      frm_ChxMag.Lb_Mag.ItemIndex := 0;
      IF NOT Chk_SelectMag.Checked THEN
        frm_ChxMag.ShowModal;

      ADefaultMagId := Integer(frm_ChxMag.Lb_Mag.items.Objects[frm_ChxMag.Lb_Mag.ItemIndex]);
      frm_ChxMag.release;
    END;

    REPEAT
      sNomFic := GetFilePath('stock', iNumFic);
      IF FileExists(sNomFic) THEN
      BEGIN
        TraiteFicStock(sNomFic, ADefaultMagId);
        Inc(iNumFic);
      END
      ELSE BEGIN
        bStopProcess := True;
      END;
    UNTIL bStopProcess;
    tran_ecr.Commit;
  FINALLY
    Base.close;
    writeln(Log, '</STOCKS>');
    closefile(Log);

    ShowMessage('Import du stock terminé.');
  END;
END;

FUNCTION TForm1.ImportGT(Art, GT: TIcXMLElement): Boolean;
VAR
  Nom: STRING;
  TGTID: STRING;
  TGFID: STRING;
  GTFID: STRING;
  Aff: STRING;
  Ta: TIcXMLElement;
  Taille: STRING;
  typeGrille: STRING;
BEGIN
  result := TRUE;
  IF GT = NIL THEN
  BEGIN
    result := false;
    //        LeXml.AddNode('ERREUR', 'Impossible de créer un article sans grille de tailles', art);
    writeln(Log, '<ARTICLE>');
    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
    AddValue(Log, 'ERREUR', 'Impossible de créer un article sans grille de tailles');
    writeln(Log, '</ARTICLE>');
  END
  ELSE
  BEGIN
    // rechercher la categorie importation
    qry.Close;
    typeGrille := LeXml.ValueTag(Gt, 'TYPE_GRILLE');
    IF typeGrille = '' THEN
      typeGrille := 'IMPORTATION';
    qry.Sql.text := 'Select TGT_ID from PLXTYPEGT ' +
      ' join k on (k_id=TGT_ID and k_enabled=1) ' +
      ' where UPPER(TGT_NOM)=' + UPPERCASE(quotedstr(TypeGrille));
    qry.Open;
    IF qry.isempty THEN
    BEGIN
      qry.Close;
      qry.Sql.text := 'Select Max(TGT_ORDREAFF)+10 from PLXTYPEGT join k on (k_id=TGT_ID and k_enabled=1) ';
      qry.Open;
      Aff := Qry.fields[0].AsString;
      qry.Close;
      IF aff = '' THEN aff := '1';
      qry.Sql.text := 'SELECT ID FROM PR_NEWK (''PLXTYPEGT'')';
      qry.Open;
      TGTID := Qry.fields[0].AsString;
      Sql.Sql.text := 'Insert into PLXTYPEGT (TGT_ID,TGT_NOM,TGT_ORDREAFF) values (' + TGTID + ',' + UPPERCASE(quotedstr(TypeGrille)) + ',' + Aff + ')';
      Sql.ExecQuery;
    END
    ELSE
      TGTID := Qry.fields[0].AsString;
    Nom := LeXml.ValueTag(Gt, 'NOM_GRILLE');
    IF Nom = '' THEN
    BEGIN
      result := false;
      //            LeXml.AddNode('ERREUR', 'Impossible de créer un article sans nom de grille de taille', art);
      writeln(Log, '<ARTICLE>');
      AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
      AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
      AddValue(Log, 'ERREUR', 'Impossible de créer un article sans nom de grille de taille');
      writeln(Log, '</ARTICLE>');

    END
    ELSE
    BEGIN
      // la grille existe t'elle (Code ou Nom)
      qry.Close;
      qry.Sql.text := 'Select GTF_ID from PLXGTF join k on (K_ID=GTF_ID And K_Enabled=1) where UPPER(GTF_NOM) = ' + UPPERCASE(quotedstr(nom)) + ' and GTF_TGTID=' + TGTID;
      qry.Open;
      IF qry.isempty THEN
      BEGIN
        IF (NOT Chk_ControleNK.Checked) THEN
        BEGIN
          qry.Close;
          qry.Sql.text := 'SELECT max(GTF_ORDREAFF)+10 from PLXGTF join k on (K_ID=GTF_ID And K_Enabled=1) where GTF_ID<>0 and GTF_TGTID=' + TGTID;
          qry.Open;
          Aff := Qry.fields[0].AsString;
          IF aff = '' THEN aff := '1';
          qry.Close;
          qry.Sql.text := 'SELECT ID FROM PR_NEWK (''PLXGTF'')';
          qry.Open;
          GTFID := Qry.fields[0].AsString;
          sql.sql.text := 'INSERT INTO PLXGTF (' +
            'GTF_ID, GTF_IDREF, GTF_NOM, GTF_TGTID, GTF_ORDREAFF, GTF_IMPORT' +
            ') values (' +
            GTFID + ',0,' + UPPERCASE(Quotedstr(nom)) + ',' + TGTID + ',' + Aff + ',0)';
          sql.ExecQuery;
          lexml.AddNode('GTFID', GTFID, art);
        END
        ELSE
        BEGIN
          result := false;
          //                    LeXml.AddNode('ERREUR', 'Impossible de créer un article, GRILLE de Taille inexistante', art);
          writeln(Log, '<ARTICLE>');
          AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
          AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
          AddValue(Log, 'ERREUR', 'Impossible de créer un article, GRILLE de Taille inexistante');
          writeln(Log, '</ARTICLE>');

        END;
      END
      ELSE
      BEGIN
        GTFID := Qry.fields[0].AsString;
        lexml.AddNode('GTFID', GTFID, art);
      END;
      // on vérifie que les tailles existe ou on les créer
      Ta := lexml.findtag(GT, 'TAILLES');
      IF ta <> NIL THEN
        ta := ta.GetFirstChild;
      IF ta = NIL THEN
      BEGIN
        result := false;
        //                LeXml.AddNode('ERREUR', 'Impossible de créer un article sans aucune taille', art);
        writeln(Log, '<ARTICLE>');
        AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
        AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
        AddValue(Log, 'ERREUR', 'Impossible de créer un article sans aucune taille');
        writeln(Log, '</ARTICLE>');

      END
      ELSE
      BEGIN
        WHILE ta <> NIL DO
        BEGIN
          Taille := leXml.ValueTag(ta, 'NOM');
          qry.Close;
          qry.Sql.text := 'SELECT TGF_ID from PLXTAILLESGF join k on (K_ID=TGF_ID and k_enabled=1) ' +
            'WHERE TGF_GTFID=' + GTFID + ' And UPPER(TGF_NOM) = ' + UPPERCASE(QuotedStr(Taille));
          qry.Open;
          IF qry.isempty THEN
          BEGIN
            IF (NOT Chk_ControleNK.Checked) THEN
            BEGIN
              qry.Close;
              qry.Sql.text := 'SELECT Max(TGF_ORDREAFF)+10 from PLXTAILLESGF join k on (K_ID=TGF_ID and k_enabled=1) ' +
                'WHERE TGF_GTFID=' + GTFID;
              qry.Open;
              Aff := qry.Fields[0].AsString;
              IF aff = '' THEN aff := '1';
              qry.Close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''PLXTAILLESGF'')';
              qry.Open;
              TGFID := qry.Fields[0].AsString;
              Sql.Sql.text := 'Insert into PLXTAILLESGF (TGF_ID,TGF_GTFID,TGF_IDREF,TGF_TGFID,' +
                'TGF_NOM,TGF_CORRES,TGF_ORDREAFF,TGF_STAT' +
                ') VALUES (' +
                TGFID + ',' + GTFID + ',0,' + TGFID + ',' + UPPERCASE(QuotedStr(Taille)) + ','''',' + aff + ',1)';
              Sql.ExecQuery;
              LeXml.AddNode('TGFID', TGFID, ta);
            END
            ELSE
            BEGIN
              result := false;
              //                            LeXml.AddNode('ERREUR', 'Impossible de créer un article, TAILLE inexistante', art);
              writeln(Log, '<ARTICLE>');
              AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
              AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
              AddValue(Log, 'ERREUR', 'Impossible de créer un article, TAILLE inexistante');
              writeln(Log, '</ARTICLE>');

            END;
          END
          ELSE
          BEGIN
            TGFID := qry.Fields[0].AsString;
            LeXml.AddNode('TGFID', TGFID, ta);
          END;
          ta := ta.NextSibling;
        END;
        result := (result AND true);
      END;
    END;
  END;
END;

FUNCTION TForm1.ImportFAM(Art: TIcXMLElement): Boolean;
VAR
  ray, fam, ssf, ssfID, FAMID, RAYID: STRING;
  uniid: STRING;
  aff: STRING;
  elem: TIcXMLElement;
BEGIN
  elem := lexml.findtag(art, 'SS_FAMILLE');
  IF elem = NIL THEN
  BEGIN
    result := false;
    //        LeXml.AddNode('ERREUR', 'Impossible de créer un article sans SOUS FAMILLE', art);
    writeln(Log, '<ARTICLE>');
    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
    AddValue(Log, 'ERREUR', 'Impossible de créer un article sans SOUS FAMILLE');
    writeln(Log, '</ARTICLE>');

    EXIT;
  END;
  ssf := lexml.ValueTag(elem, 'NOM');
  elem := lexml.findtag(elem, 'FAMILLE');
  IF elem = NIL THEN
  BEGIN
    result := false;
    //        LeXml.AddNode('ERREUR', 'Impossible de créer un article sans FAMILLE', art);
    writeln(Log, '<ARTICLE>');
    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
    AddValue(Log, 'ERREUR', 'Impossible de créer un article sans FAMILLE');
    writeln(Log, '</ARTICLE>');

    EXIT;
  END;
  Fam := lexml.ValueTag(elem, 'NOM');
  elem := lexml.findtag(elem, 'RAYON');
  IF elem = NIL THEN
  BEGIN
    result := false;
    //        LeXml.AddNode('ERREUR', 'Impossible de créer un article sans RAYON', art);
    writeln(Log, '<ARTICLE>');
    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
    AddValue(Log, 'ERREUR', 'Impossible de créer un article sans RAYON');
    writeln(Log, '</ARTICLE>');

    EXIT;
  END;
  ray := lexml.ValueTag(elem, 'NOM');
  IF ray = '' THEN
  BEGIN
    result := false;
    //        LeXml.AddNode('ERREUR', 'Impossible de créer un article sans RAYON', art);
    writeln(Log, '<ARTICLE>');
    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
    AddValue(Log, 'ERREUR', 'Impossible de créer un article sans RAYON');
    writeln(Log, '</ARTICLE>');

  END
  ELSE IF fam = '' THEN
  BEGIN
    result := false;
    //        LeXml.AddNode('ERREUR', 'Impossible de créer un article sans FAMILLE', art);
    writeln(Log, '<ARTICLE>');
    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
    AddValue(Log, 'ERREUR', 'Impossible de créer un article sans FAMILLE');
    writeln(Log, '</ARTICLE>');

  END
  ELSE IF ssf = '' THEN
  BEGIN
    result := false;
    //        LeXml.AddNode('ERREUR', 'Impossible de créer un article sans SOUS FAMILLE', art);
    writeln(Log, '<ARTICLE>');
    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
    AddValue(Log, 'ERREUR', 'Impossible de créer un article sans SOUS FAMILLE');
    writeln(Log, '</ARTICLE>');

  END
  ELSE
  BEGIN
    qry.close;
    qry.sql.text := ' select ssf_id from nklrayon join nklfamille join nklssfamille ' +
      ' join k on (k_id=ssf_id and k_enabled=1) on (ssf_famid=fam_id) on (fam_rayid=ray_id) ' +
      'where UPPER(SSF_NOM)=' + UPPERCASE(quotedstr(ssf)) +
      '  and UPPER(FAM_NOM)=' + UPPERCASE(quotedstr(fam)) +
      '  and UPPER(RAY_NOM)=' + UPPERCASE(quotedstr(ray));
    Qry.open;
    IF qry.isempty THEN
    BEGIN
      IF (NOT Chk_ControleNK.Checked) THEN
      BEGIN
        // Création de la Nomenclature correspondante
        qry.close;
        qry.sql.text := ' select fam_id from nklrayon join nklfamille  ' +
          ' join k on (k_id=fam_id and k_enabled=1) on (fam_rayid=ray_id) ' +
          'where UPPER(FAM_NOM)=' + UPPERCASE(quotedstr(fam)) +
          '  and UPPER(RAY_NOM)=' + UPPERCASE(quotedstr(ray));
        Qry.open;
        IF qry.isempty THEN
        BEGIN
          qry.close;
          qry.sql.text := ' select RAY_id from nklrayon ' +
            ' join k on (k_id=RAY_id and k_enabled=1) ' +
            'where UPPER(RAY_NOM)=' + UPPERCASE(quotedstr(ray));
          Qry.open;
          IF qry.isempty THEN
          BEGIN
            // création du rayon
            qry.close;
            qry.sql.text := 'Select Max(RAY_ORDREAFF)+10 from nklrayon ' +
              ' join k on (k_id=RAY_id and k_enabled=1) ';
            qry.open;
            aff := qry.fields[0].AsString;
            IF aff = '' THEN aff := '1';
            qry.Close;
            qry.Sql.text := 'SELECT ID FROM PR_NEWK (''NKLRAYON'')';
            qry.Open;
            RAYID := qry.fields[0].AsString;
            qry.Close;
            qry.Sql.text := 'Select uni_ID ' +
              ' from gendossier join k on (k_id=dos_id and k_enabled=1)' +
              '  Join nklunivers on (uni_nom=Dos_string)' +
              ' where dos_nom=''UNIVERS_REF''';
            qry.Open;
            uniid := qry.fields[0].AsString;

            Sql.Sql.text := 'Insert into NklRayon (RAY_ID,RAY_UNIID,RAY_IDREF,' +
              'RAY_NOM,RAY_ORDREAFF,RAY_VISIBLE,RAY_SECID)' +
              ' VALUES (' +
              RAYID + ',' + uniid + ',0,' + UPPERCASE(quotedstr(ray)) + ',' + aff + ',1,0)';
            Sql.ExecQuery;
          END
          ELSE
            RAYID := qry.fields[0].AsString;
          qry.close;
          qry.sql.text := 'Select Max(FAM_ORDREAFF)+10 from nklfamille ' +
            ' join k on (k_id=FAM_id and k_enabled=1) where FAM_RAYID =' + rayid;
          qry.open;
          aff := qry.fields[0].AsString;
          IF aff = '' THEN aff := '1';
          qry.close;
          qry.Sql.text := 'SELECT ID FROM PR_NEWK (''NKLFAMILLE'')';
          qry.open;
          FAMid := qry.fields[0].AsString;
          sql.sql.text := 'Insert into NKLFAMILLE ( ' +
            'FAM_ID,FAM_RAYID,FAM_IDREF,FAM_NOM,FAM_ORDREAFF,FAM_VISIBLE,FAM_CTFID' +
            ') Values (' +
            FAMID + ',' + rayid + ',0,' + UPPERCASE(quotedstr(fam)) + ',' + aff + ',1,0)';
          sql.ExecQuery;
        END
        ELSE
          famid := qry.fields[0].AsString;
        qry.close;
        qry.sql.text := 'Select Max(SSF_ORDREAFF)+10 from NKLSSFAMILLE ' +
          ' join k on (k_id=SSF_id and k_enabled=1) where SSF_FAMID =' + famid;
        qry.open;
        aff := qry.fields[0].AsString;
        IF aff = '' THEN aff := '1';
        qry.close;
        qry.Sql.text := 'SELECT ID FROM PR_NEWK (''NKLSSFAMILLE'')';
        qry.open;
        SSFID := qry.fields[0].AsString;
        sql.sql.text := 'Insert into NKLSSFAMILLE ( ' +
          'SSF_ID,SSF_FAMID,SSF_IDREF,SSF_NOM,SSF_ORDREAFF,SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID' +
          ') Values (' +
          SSFID + ',' + FAMID + ',0,' + UPPERCASE(quotedstr(ssf)) + ',' + aff + ',1,0,0,0)';
        sql.ExecQuery;
        result := true;
        LeXml.AddNode('SSFID', SSFID, art);
      END
      ELSE // Erreur car la Nomenclature correspondante n'existe pas
      BEGIN
        result := false;
        //                LeXml.AddNode('ERREUR', 'Impossible de créer un article, NOMENCLATURE inexacte', art);
        writeln(Log, '<ARTICLE>');
        AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
        AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
        AddValue(Log, 'ERREUR', 'Impossible de créer un article, NOMENCLATURE inexacte');
        writeln(Log, '</ARTICLE>');

      END;
    END
    ELSE
    BEGIN
      SSFID := Qry.fields[0].AsString;
      result := true;
      LeXml.AddNode('SSFID', SSFID, art);
    END;
  END;
END;

PROCEDURE TForm1.ImportXml(Xml: STRING; SelectMag: Boolean; Nbr: Integer = 0);
VAR
  Art: TIcXMLElement;
  artid, arfid: STRING;
  GREID: STRING;
  S1: STRING;
  s: STRING;
  TVAID, TCTID: STRING;
  ARFCHRONO: STRING;
  FOUID: STRING;
  magid: STRING;
  frm_ChxMag: Tfrm_ChxMag;
  Cous, cou: TIcXMLElement;
  couid: STRING;

  PxMinA: double;
  PxMinV: double;
  PxMinC: double;
  pxs, px: TIcXMLElement;
  CBs, Cb: TIcXMLElement;
  Tas, Ta: TIcXMLElement;

  i: integer;

  CLGID: STRING;
  PVTID: STRING;
  CBIID: STRING;
  TTVID: STRING;
  CDVID: STRING;

  Nbart, NbartT: integer;
  NbartExist: integer;

  tsl: tstringlist;
  prem: boolean;
  prem1: boolean;

  premChrono: STRING;
  DernChrono: STRING;
  CLAID, CITID,
    ICLI1, ICLI2, ICLI3, ICLI4, ICLI5, COL, CARID: STRING;
  mag_nom: STRING;
  lemagid: STRING;
  dateCree, dd, mm: STRING;

  lesTai1: TIcXMLElement;
  lesTai2: TIcXMLElement;
  lesTai3: TIcXMLElement;

  fou_code, impID: STRING;

  creart: boolean;
  cre2: boolean;

  iii, TTVmax: integer;
BEGIN

  lesfou := tstringlist.create;
  //
  IF trim(ed_Base.text) = '' THEN
    Application.messagebox('Pas de base, importation terminée', ' Fin ', mb_ok)
  ELSE IF NOT fileexists(ed_Base.text) THEN
    Application.messagebox('La base n''existe pas , importation terminée', ' Fin ', mb_ok)
  ELSE
  BEGIN
    Nbart := 0;
    NbartT := 0;
    NbartExist := 0;
    TRY
      PremChrono := '';
      DernChrono := '';
      Base.close;
      Base.DatabaseName := ed_base.text;
      Base.Open;
      tran_lect.active := true;
      // choisir le magasin d'importation
      qry.close;
      qry.sql.text := 'select MAG_ID, MAG_NOM from genmagasin join k on (k_id=mag_id and k_enabled=1) where mag_id<>0';
      qry.Open;
      application.createform(Tfrm_ChxMag, frm_ChxMag);
      WHILE NOT qry.Eof DO
      BEGIN
        frm_ChxMag.Lb_Mag.items.AddObject(Qry.fields[1].AsString, pointer(Qry.fields[0].asInteger));
        qry.Next;
      END;
      qry.close;
      frm_ChxMag.Lb_Mag.ItemIndex := 0;
      IF NOT SelectMag THEN
        frm_ChxMag.ShowModal;
      MagId := Inttostr(Integer(frm_ChxMag.Lb_Mag.items.Objects[frm_ChxMag.Lb_Mag.ItemIndex]));
      frm_ChxMag.release;
      Tran_ecr.active := true;
      leXml := TmonXML.create;
      assignfile(Log, ed_rep.text + 'LogArt.xml');
      rewrite(Log);
      writeln(Log, '<ARTICLES>');

      iii := 0;
      WHILE true DO
      BEGIN
        IF iii = 0 THEN
          leXml.LoadFromFile(XML)
        ELSE
        BEGIN
          IF fileexists(changefileext(XML, '') + inttostr(iii) + '.xml') THEN
            leXml.LoadFromFile(changefileext(XML, '') + inttostr(iii) + '.xml')
          ELSE
            BREAK;
        END;
        inc(iii);
        Art := LeXml.find('/ARTICLES/ARTICLE');
        pb.min := 0;
        pb.position := 0;
        pb.max := LeXml.find('/ARTICLES', false).GetNodeList.Length;

        WHILE (art <> NIL) AND (art.getname = 'ARTICLE') DO
        BEGIN
          pb.position := pb.position + 1;
          pb.Update;
          update;
          TRY
            IF NOT ImportMarque(Art, lexml.findtag(art, 'MARQUE')) THEN
              // traiter l'erreur
              //Exit;
            ELSE
            BEGIN
              // ici traiter les tailles de l'articles qui n'existe pas dans la grille de taille
              // à ajouter en fin de grille
              lesTai2 := lexml.findtag(art, 'CODE_BARRES');
              lesTai2 := lexml.findtag(lesTai2, 'CODE_BARRE');
              lesTai1 := lexml.findtag(art, 'GRILLE_TAILLES');
              lesTai1 := lexml.findtag(lesTai1, 'TAILLES');
              WHILE lesTai2 <> NIL DO
              BEGIN
                lesTai3 := lexml.findtag(lesTai1, 'TAILLE');
                WHILE (lesTai3 <> NIL) AND (LeXml.ValueTag(lesTai3, 'NOM') <> LeXml.ValueTag(lestai2, 'TAILLE')) DO
                  lesTai3 := lesTai3.NextSibling;
                IF lesTai3 = NIL THEN
                BEGIN
                  // ajout de la taille ;
                  lesTai3 := lexml.AddNode('TAILLE', '', lesTai1);
                  lexml.AddNode('NOM', LeXml.ValueTag(lestai2, 'TAILLE'), lesTai3);
                END;
                lestai2 := lestai2.NextSibling;
              END;
              IF NOT ImportGT(Art, lexml.findtag(art, 'GRILLE_TAILLES')) THEN
                // traiter l'erreur
              ELSE IF NOT ImportFAM(Art) THEN
                // traiter l'erreur
              ELSE
              BEGIN
                S := uppercase(lexml.ValueTag(art, 'GENRE'));
                IF s = '' THEN
                  GREID := '0'
                ELSE
                BEGIN
                  qry.close;
                  qry.sql.text := 'Select GRE_ID from ARTGENRE join k on (GRE_ID=K_ID and K_ENABLED=1) where GRE_NOM=' + quotedstr(s);
                  qry.Open;
                  IF qry.isempty THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTGENRE'')';
                    qry.open;
                    greid := qry.fields[0].AsString;
                    sql.sql.text := 'INSERT into ARTGENRE (' +
                      'GRE_ID, GRE_IDREF, GRE_NOM, GRE_SEXE) values (' +
                      greid + ',0,' + quotedstr(s) + ',0)';
                    sql.ExecQuery;
                  END
                  ELSE
                    GREID := qry.fields[0].AsString;
                END;

                S := lexml.ValueTag(art, 'CLASSEMENT1');
                IF S = '' THEN
                  ICLI1 := '0'
                ELSE
                BEGIN
                  qry.close;
                  qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''ART'' and cla_num=1';
                  qry.Open;
                  CLAID := qry.fields[0].AsString;
                  qry.close;
                  qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
                    ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
                    'WHERE CIT_CLAID=' + CLAID +
                    ' and ICL_NOM = ' + quotedstr(S);
                  qry.Open;
                  IF qry.isempty THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
                    qry.open;
                    ICLI1 := qry.fields[0].AsString;
                    sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                      ' Values (' + ICLI1 + ',' + QuotedStr(S) + ')';
                    sql.ExecQuery;
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
                    qry.open;
                    CITID := qry.fields[0].AsString;
                    qry.close;
                    sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                      ' values (' + CITID + ',' + CLAID + ',' + ICLI1 + ')';
                    sql.ExecQuery;
                  END
                  ELSE
                    ICLI1 := qry.fields[0].AsString;
                END;

                S := lexml.ValueTag(art, 'CLASSEMENT2');
                IF S = '' THEN
                  ICLI2 := '0'
                ELSE
                BEGIN
                  qry.close;
                  qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''ART'' and cla_num=2';
                  qry.Open;
                  CLAID := qry.fields[0].AsString;
                  qry.close;
                  qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
                    ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
                    'WHERE CIT_CLAID=' + CLAID +
                    ' and ICL_NOM = ' + quotedstr(S);
                  qry.Open;
                  IF qry.isempty THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
                    qry.open;
                    ICLI2 := qry.fields[0].AsString;
                    sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                      ' Values (' + ICLI2 + ',' + QuotedStr(S) + ')';
                    sql.ExecQuery;
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
                    qry.open;
                    CITID := qry.fields[0].AsString;
                    qry.close;
                    sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                      ' values (' + CITID + ',' + CLAID + ',' + ICLI2 + ')';
                    sql.ExecQuery;
                  END
                  ELSE
                    ICLI2 := qry.fields[0].AsString;
                END;

                S := lexml.ValueTag(art, 'CLASSEMENT3');
                IF S = '' THEN
                  ICLI3 := '0'
                ELSE
                BEGIN
                  qry.close;
                  qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''ART'' and cla_num=3';
                  qry.Open;
                  CLAID := qry.fields[0].AsString;
                  qry.close;
                  qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
                    ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
                    'WHERE CIT_CLAID=' + CLAID +
                    ' and ICL_NOM = ' + quotedstr(S);
                  qry.Open;
                  IF qry.isempty THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
                    qry.open;
                    ICLI3 := qry.fields[0].AsString;
                    sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                      ' Values (' + ICLI3 + ',' + QuotedStr(S) + ')';
                    sql.ExecQuery;
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
                    qry.open;
                    CITID := qry.fields[0].AsString;
                    qry.close;
                    sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                      ' values (' + CITID + ',' + CLAID + ',' + ICLI3 + ')';
                    sql.ExecQuery;
                  END
                  ELSE
                    ICLI3 := qry.fields[0].AsString;
                END;

                S := lexml.ValueTag(art, 'CLASSEMENT4');
                IF S = '' THEN
                  ICLI4 := '0'
                ELSE
                BEGIN
                  qry.close;
                  qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''ART'' and cla_num=4';
                  qry.Open;
                  CLAID := qry.fields[0].AsString;
                  qry.close;
                  qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
                    ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
                    'WHERE CIT_CLAID=' + CLAID +
                    ' and ICL_NOM = ' + quotedstr(S);
                  qry.Open;
                  IF qry.isempty THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
                    qry.open;
                    ICLI4 := qry.fields[0].AsString;
                    sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                      ' Values (' + ICLI4 + ',' + QuotedStr(S) + ')';
                    sql.ExecQuery;
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
                    qry.open;
                    CITID := qry.fields[0].AsString;
                    qry.close;
                    sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                      ' values (' + CITID + ',' + CLAID + ',' + ICLI4 + ')';
                    sql.ExecQuery;
                  END
                  ELSE
                    ICLI4 := qry.fields[0].AsString;
                END;

                S := lexml.ValueTag(art, 'CLASSEMENT5');
                IF S = '' THEN
                  ICLI5 := '0'
                ELSE
                BEGIN
                  qry.close;
                  qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''ART'' and cla_num=5';
                  qry.Open;
                  CLAID := qry.fields[0].AsString;
                  qry.close;
                  qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
                    ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
                    'WHERE CIT_CLAID=' + CLAID +
                    ' and ICL_NOM = ' + quotedstr(S);
                  qry.Open;
                  IF qry.isempty THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
                    qry.open;
                    ICLI5 := qry.fields[0].AsString;
                    sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                      ' Values (' + ICLI5 + ',' + QuotedStr(S) + ')';
                    sql.ExecQuery;
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
                    qry.open;
                    CITID := qry.fields[0].AsString;
                    qry.close;
                    sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                      ' values (' + CITID + ',' + CLAID + ',' + ICLI5 + ')';
                    sql.ExecQuery;
                  END
                  ELSE
                    ICLI5 := qry.fields[0].AsString;
                END;

                S := lexml.ValueTag(art, 'COLLECTION');
                IF S = '' THEN
                  COL := '0'
                ELSE
                BEGIN
                  qry.close;
                  qry.sql.text := 'select col_id from artcollection join k on (k_id=col_id and k_enabled=1) where col_nom=' + quotedstr(S);
                  qry.Open;
                  IF qry.isempty THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCOLLECTION'')';
                    qry.open;
                    COL := qry.fields[0].AsString;
                    sql.sql.text := 'Insert into ARTCOLLECTION (COL_ID,COL_NOM) ' +
                      ' values (' + COL + ',' + Quotedstr(S) + ')';
                    sql.ExecQuery;
                  END
                  ELSE
                    COL := qry.fields[0].AsString;
                END;

                TVAID := '0';
                IF (lexml.ValueTag(art, 'TVA') <> '') THEN
                BEGIN
                  TRY
                    qry.close;
                    qry.sql.text := 'Select TVA_ID from ARTTVA join k on (k_id=TVA_ID and k_ENABled=1) where TVA_TAUX=' + lexml.ValueTag(art, 'TVA');
                    qry.Open;
                    IF NOT qry.IsEmpty THEN
                      TVAID := qry.fields[0].AsString;
                  EXCEPT
                    TVAID := '0';
                  END;
                END;
                IF (TVAID = '0') THEN
                BEGIN
                  qry.close;
                  qry.sql.text := 'Select TVA_ID from ARTTVA join k on (k_id=TVA_ID and k_ENABled=1) where TVA_TAUX=19.6';
                  qry.Open;
                  TVAID := qry.fields[0].AsString;
                END;

                qry.close;
                qry.sql.text := 'Select TCT_ID from ARTTYPECOMPTABLE join k on (k_id=TCT_ID and k_ENABled=1) where TCT_CODE=1';
                qry.Open;
                TCTID := qry.fields[0].AsString;

                // teste si l'article existe déjà
                IF Chk_NoncreateArt.checked AND (lexml.ValueTag(art, 'CODE_FOU') <> '') THEN
                BEGIN
                  qry.close;
                  IF Chk_TestGT.checked THEN
                    qry.sql.text := 'Select ART_ID, arf_id, arf_chrono, ART_GTFID from ARTARTICLE join k on (k_id=ART_ID and k_ENABled=1) ' +
                      ' join artreference on (arf_artid = art_id) ' +
                      ' where ART_MRKID = ' + lexml.ValueTag(art, 'MRKID') +
                      ' and ART_REFMRK = ' + Quotedstr(lexml.ValueTag(art, 'CODE_FOU') +
                      ' and ART_GTFID = ' + lexml.ValueTag(art, 'GTFID'))

                  ELSE
                    qry.sql.text := 'Select ART_ID, arf_id, arf_chrono, ART_GTFID from ARTARTICLE join k on (k_id=ART_ID and k_ENABled=1) ' +
                      ' join artreference on (arf_artid = art_id) ' +
                      ' where ART_MRKID = ' + lexml.ValueTag(art, 'MRKID') +
                      ' and ART_REFMRK = ' + Quotedstr(lexml.ValueTag(art, 'CODE_FOU'));
                  qry.Open;
                  creart := qry.IsEmpty;
                  IF NOT creart THEN
                  BEGIN
                    qry.First;
                    WHILE NOT qry.eof DO
                    BEGIN
                      IF (qry.fields[3].AsString = lexml.ValueTag(art, 'GTFID')) THEN
                        BREAK
                      ELSE qry.next;
                    END;

                    IF (qry.fields[3].AsString <> lexml.ValueTag(art, 'GTFID')) THEN
                    BEGIN
                      RAISE Exception.Create('Existe déja sous le chrono ' + qry.fields[2].AsString + ' mais avec une grille de taille différente => ' + qry.fields[3].AsString);
                    END;

                    artid := qry.fields[0].AsString;
                    arfid := qry.fields[1].AsString;
                    inc(NbartExist);

                    writeln(Log, '<ARTICLE>');
                    AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
                    AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
                    AddValue(Log, 'EXISTE', 'sous le chrono ' + qry.fields[2].AsString);
                    writeln(Log, '</ARTICLE>');
                    //EXISTE
                  END;
                  qry.Close;
                END
                ELSE
                  creart := true;

                IF cb_chrono.checked THEN
                  ARFCHRONO := lexml.ValueTag(art, 'CODE')
                ELSE
                  ARFCHRONO := '';
                IF ARFCHRONO = '' THEN
                BEGIN
                  IF creart THEN
                  BEGIN
                    qry.close;
                    qry.sql.text := 'Select NEWNUM from ART_CHRONO';
                    qry.Open;
                    ARFCHRONO := qry.fields[0].AsString;
                  END;
                END;
                IF PremChrono = '' THEN
                  PremChrono := ARFCHRONO;
                DernChrono := ARFCHRONO;

                // importer l'article
                IF creart THEN
                BEGIN
                  qry.close;
                  qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTARTICLE'')';
                  qry.open;
                  artid := qry.fields[0].AsString;
                  qry.close;
                  qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTREFERENCE'')';
                  qry.open;
                  arfid := qry.fields[0].AsString;
                  sql.sql.text := 'insert into ARTARTICLE (' +
                    'ART_ID,ART_IDREF,ART_NOM,ART_ORIGINE,ART_DESCRIPTION,' +
                    'ART_MRKID,ART_REFMRK,ART_SSFID,ART_PUB,ART_GTFID,' +
                    'ART_SESSION,ART_GREID,ART_THEME,ART_GAMME,ART_CODECENTRALE,' +
                    'ART_TAILLES,ART_POS,ART_GAMPF,ART_POINT,ART_GAMPRODUIT,' +
                    'ART_SUPPRIME,ART_REFREMPLACE,ART_GARID,ART_CODEGS,ART_COMENT1,' +
                    'ART_COMENT2,ART_COMENT3,ART_COMENT4,ART_COMENT5' +
                    ') values (' +
                    artid + ',0,' + quotedstr(lexml.ValueTag(art, 'NOM')) + ',1,' + quotedstr(lexml.ValueTag(art, 'DESCRIPTION')) + ',' +
                    lexml.ValueTag(art, 'MRKID') + ',' + Quotedstr(lexml.ValueTag(art, 'CODE_FOU')) + ',' + lexml.ValueTag(art, 'SSFID') + ',0,' + lexml.ValueTag(art, 'GTFID') + ',' +
                    ''''',' + greid + ','''','''','''',' +
                    ''''','''','''','''','''',' +
                    '0,0,0,0,' + Quotedstr(lexml.ValueTag(art, 'COMENT1')) + ',' +
                    Quotedstr(lexml.ValueTag(art, 'COMENT2')) + ','''','''',' + Quotedstr(lexml.ValueTag(art, 'CODE')) +
                    ')';
                  sql.ExecQuery;

                  // memoriser ART dans GenIMPORT
                  qry.close;
                  qry.Sql.text := 'SELECT ID FROM PR_NEWK (''GENIMPORT'')';
                  qry.open;
                  impid := qry.fields[0].AsString;
                  IBSql_Import.sql.text := 'insert into GENIMPORT(IMP_ID,IMP_KTBID,IMP_GINKOIA,IMP_REF,IMP_NUM,IMP_REFSTR)' +
                    'values (' + impid + ',-11111375,' + artid + ',-1,0,' + quotedstr(lexml.ValueTag(art, 'CODE')) + ')';
                  IBSql_Import.ExecQuery;

                  DateCree := lexml.ValueTag(art, 'DATE');
                  IF (dateCree = '') THEN
                    dateCree := DateToStr(Date);
                  // convertir la date au bon format : mm/dd/yyyy
                  dd := Copy(dateCree, 0, Pos('/', dateCree) - 1);
                  Delete(dateCree, 1, Pos('/', dateCree));
                  mm := Copy(dateCree, 0, Pos('/', dateCree) - 1);
                  Delete(dateCree, 1, Pos('/', dateCree));
                  dateCree := mm + '/' + dd + '/' + dateCree;

                  sql.sql.text := 'Insert into Artreference (' +
                    'ARF_ID,ARF_ARTID,ARF_CATID,ARF_TVAID,ARF_TCTID,' +
                    'ARF_ICLID1,ARF_ICLID2,ARF_ICLID3,ARF_ICLID4,ARF_ICLID5,' +
                    'ARF_CREE,ARF_MODIF,ARF_CHRONO,ARF_DIMENSION,ARF_DEPRECIATION,' +
                    'ARF_VIRTUEL,ARF_SERVICE,ARF_COEFT,ARF_STOCKI,ARF_VTFRAC,' +
                    'ARF_CDNMT,ARF_CDNMTQTE,ARF_UNITE,ARF_CDNMTOBLI,ARF_GUELT,' +
                    'ARF_CPFA,ARF_FIDELITE,ARF_ARCHIVER,ARF_FIDPOINT,ARF_FIDDEBUT,' +
                    'ARF_FIDFIN,ARF_DEPTAUX,ARF_DEPDATE,ARF_DEPMOTIF,ARF_CGTID,' +
                    'ARF_GLTMONTANT,ARF_GLTPXV,ARF_GLTMARGE,ARF_GLTDEBUT,ARF_GLTFIN,' +
                    'ARF_MAGORG,ARF_CATALOG ) Values (' +
                    Arfid + ',' + artid + ',0,' + TVAID + ',' + TCTID + ',' +
                    ICLI1 + ',' + ICLI2 + ',' + ICLI3 + ',' + ICLI4 + ',' + ICLI5 + ',' +
                    quotedstr(dateCree) + ',current_date,' + Quotedstr(ARFCHRONO) + ',1,1,' +
                    '0,0,0,0,0,' +
                    '0,0,'''',0,0,' +
                    '0,' + quotedstr(lexml.ValueTag(art, 'FIDELITE')) + ',0,0,NULL,' +
                    'NULL,0,NULL,0,0,' +
                    '0,0,0,NULL,NULL,' +
                    MAGID + ',0' + ')';
                  sql.ExecQuery;
                  inc(nbart);
                END;

                // Collection
                IF (COL <> '0') THEN
                BEGIN
                  IF NOT creart THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT car_id from ARTCOLART join k on (k_id=car_id and k_enabled=1) ' +
                      ' where CAR_ARTID = ' + artid +
                      ' and  CAR_COLID = ' + COL;
                    qry.open;
                    IF qry.IsEmpty THEN
                    BEGIN
                      qry.close;
                      qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCOLART'')';
                      qry.open;
                      carid := qry.fields[0].asString;
                      sql.sql.text := 'INSERT Into ARTCOLART (CAR_ID,CAR_ARTID,CAR_COLID' +
                        ') Values (' +
                        carid + ',' + artid + ',' + COL + ')';
                      sql.ExecQuery;
                    END;
                  END
                  ELSE
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCOLART'')';
                    qry.open;
                    carid := qry.fields[0].asString;
                    sql.sql.text := 'INSERT Into ARTCOLART (' +
                      'CAR_ID,CAR_ARTID,CAR_COLID' +
                      ') Values (' +
                      carid + ',' + artid + ',' + COL + ')';
                    sql.ExecQuery;
                  END;
                END;

                Cous := lexml.findtag(art, 'COULEURS');
                IF cous = NIL THEN
                  cous := LeXml.AddNode('COULEURS', '', art);
                cou := lexml.findtag(cous, 'COULEUR');
                IF cou = NIL THEN
                BEGIN
                  cou := LeXml.AddNode('COULEUR', '', cous);
                  LeXml.AddNode('NOM', 'UNICOLOR', cou);
                END;

                WHILE cou <> NIL DO
                BEGIN
                  cre2 := creart;
                  IF NOT cre2 THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT cou_id from PLXCOULEUR join k on (k_id=cou_id and k_enabled=1) ' +
                      ' where COU_ARTID = ' + artid +
                      ' and  COU_NOM = ' + Quotedstr(LeXml.ValueTag(cou, 'NOM'));
                    qry.open;
                    cre2 := qry.IsEmpty;
                    IF NOT cre2 THEN
                    BEGIN
                      couid := qry.fields[0].asString;
                      LeXml.AddNode('COUID', couid, cou);
                    END;
                  END;
                  IF cre2 THEN
                  BEGIN
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''PLXCOULEUR'')';
                    qry.open;
                    couid := qry.fields[0].asString;
                    sql.sql.text := 'INSERT Into PLXCOULEUR (' +
                      'COU_ID,COU_ARTID,COU_IDREF,COU_GCSID,COU_CODE,COU_NOM' +
                      ') Values (' +
                      couid + ',' + artid + ',0,0,''.'',' + Quotedstr(LeXml.ValueTag(cou, 'NOM')) + ')';
                    sql.ExecQuery;
                    LeXml.AddNode('COUID', couid, cou);
                  END;
                  cou := cou.NextSibling;
                END;

                // recherche du plus petit prix
                PxMinA := 999999;
                PxMinV := 999999;
                PxMinC := 999999;
                pxs := lexml.findtag(art, 'LESPRIX');
                IF pxs <> NIL THEN
                BEGIN
                  px := lexml.findtag(pxs, 'LEPRIX');
                  WHILE px <> NIL DO
                  BEGIN
                    IF ((lexml.ValueTag(px, 'PXVTE') <> '') AND (StrToFloat(lexml.ValueTag(px, 'PXVTE')) <> 0)) THEN
                    TRY
                      IF StrToFloat(lexml.ValueTag(px, 'PXVTE')) < pxminV THEN
                        pxminV := StrToFloat(lexml.ValueTag(px, 'PXVTE'));
                    EXCEPT
                    END;
                    IF ((lexml.ValueTag(px, 'PXACH') <> '') AND (StrToFloat(lexml.ValueTag(px, 'PXACH')) <> 0)) THEN
                    TRY
                      IF StrToFloat(lexml.ValueTag(px, 'PXACH')) < pxminA THEN
                        pxminA := StrToFloat(lexml.ValueTag(px, 'PXACH'));
                    EXCEPT
                    END;
                    IF ((lexml.ValueTag(px, 'PXCATALOG') <> '') AND (StrToFloat(lexml.ValueTag(px, 'PXCATALOG')) <> 0)) THEN
                    TRY
                      IF StrToFloat(lexml.ValueTag(px, 'PXCATALOG')) < pxminC THEN
                        pxminC := StrToFloat(lexml.ValueTag(px, 'PXCATALOG'));
                    EXCEPT
                    END;
                    px := px.NextSibling;
                  END;
                END;
                IF PxMinA > 999998 THEN PxMinA := 0;
                IF PxMinV > 999998 THEN PxMinV := 0;
                IF PxMinC > 999998 THEN PxMinC := 0;

                fou_code := lexml.ValueTag(lexml.findtag(lexml.findtag(art, 'LESPRIX'), 'LEPRIX'), 'CODE_FOU');
                IF trim(fou_code) = '' THEN
                  fouID := lexml.ValueTag(art, 'FOUID')
                ELSE
                BEGIN
                  IF lesfou.indexof(fou_Code) <> -1 THEN
                  BEGIN
                    fouID := LeXml.ValueTag(TIcXMLElement(lesfou.objects[lesfou.indexof(fou_Code)]), 'ID');
                  END
                  ELSE
                  BEGIN
                    Qry.Close;
                    Qry.sql.clear;
                    Qry.sql.Add('Select FOU_ID');
                    Qry.sql.Add('From ArtFourn join k on (k_id=fou_id and k_enabled=1)');
                    Qry.sql.Add('Where UPPER(FOU_NOM)=' + UPPERCASE(QuotedStr(fou_Code)));
                    Qry.Open;
                    IF Qry.isempty THEN
                      fouID := lexml.ValueTag(art, 'FOUID')
                    ELSE
                      fouID := Qry.fields[0].AsString;
                  END;
                END;
                IF NOT creart THEN
                BEGIN
                  qry.close;
                  qry.Sql.text := 'Select CLG_ID from TARCLGFOURN join k on (k_id=clg_id and k_enabled=1) where CLG_ARTID=' + artid +
                    ' and CLG_TGFID=0 and CLG_FOUID = ' + FOUID;
                  qry.Open;
                  IF NOT qry.eof THEN
                  BEGIN // la ligne existe on update
                    CLGID := qry.fields[0].AsString;
                    UpdateK(qry.fields[0].AsString);
                    sql.sql.text := ' update TARCLGFOURN set CLG_PX = ' + floattostr(PxMinC) + ', ' +
                      ' CLG_PXNEGO = ' + floattostr(PxMinA) +
                      ' Where CLG_ID = ' + CLGID;
                    sql.ExecQuery;
                  END
                  ELSE
                  BEGIN
                    qry.Close;
                    qry.Sql.text := 'Select CLG_ID from TARCLGFOURN join k on (k_id=clg_id and k_enabled=1) where CLG_ARTID=' + artid +
                      ' and CLG_TGFID=0 and CLG_PRINCIPAL = 1';
                    qry.Open;
                    IF NOT qry.eof THEN
                    BEGIN // une ligne existe avec CLG_PRINCIPAL = 1
                      qry.close;
                      qry.Sql.text := 'SELECT ID FROM PR_NEWK (''TARCLGFOURN'')';
                      qry.open;
                      CLGID := qry.fields[0].AsString;
                      sql.sql.text := 'Insert into TARCLGFOURN (' +
                        'CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,' +
                        'CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,' +
                        'CLG_TAXE,CLG_PRINCIPAL' +
                        ') Values (' +
                        CLGID + ',' + ARTID + ',' + FOUID + ',0,' + floattostr(PxMinC) + ',' +
                        floattostr(PxMinA) + ',0,0,0,0,0,0)';
                      sql.ExecQuery;
                    END
                    ELSE
                    BEGIN // traitement standard
                      qry.close;
                      qry.Sql.text := 'SELECT ID FROM PR_NEWK (''TARCLGFOURN'')';
                      qry.open;
                      CLGID := qry.fields[0].AsString;
                      sql.sql.text := 'Insert into TARCLGFOURN (' +
                        'CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,' +
                        'CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,' +
                        'CLG_TAXE,CLG_PRINCIPAL' +
                        ') Values (' +
                        CLGID + ',' + ARTID + ',' + FOUID + ',0,' + floattostr(PxMinC) + ',' +
                        floattostr(PxMinA) + ',0,0,0,0,0,1)';
                      sql.ExecQuery;
                    END;
                  END;

                  // recherche du prix de vente
                  qry.close;
                  qry.sql.text := 'Select PVT_ID from TARPRIXVENTE join k on (k_id=PVT_ID and k_enabled=1) ' +
                    ' where PVT_ARTID=' + artid + ' and PVT_TGFID=0';
                  qry.open;
                  IF NOT qry.eof THEN
                  BEGIN // l'enr existe update
                    PVTID := qry.fields[0].AsString;
                    UpdateK(PVTID);
                    sql.sql.text := 'Update TARPRIXVENTE ' +
                      ' Set PVT_PX=' + floattostr(PxMinV) +
                      ' where PVT_ID=' + PVTID;
                    sql.ExecQuery;
                  END
                  ELSE
                  BEGIN // comportement standard
                    qry.close;
                    qry.Sql.text := 'SELECT ID FROM PR_NEWK (''TARPRIXVENTE'')';
                    qry.open;
                    PVTID := qry.fields[0].AsString;
                    sql.sql.text := 'Insert into TARPRIXVENTE (' +
                      'PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX' +
                      ') values (' +
                      PVTID + ',0,' + artid + ',0,' + floattostr(PxMinV) + ')';
                    sql.ExecQuery;
                  END;
                END
                ELSE
                BEGIN // on vient de créer l'article comportement standard
                  qry.close;
                  qry.Sql.text := 'SELECT ID FROM PR_NEWK (''TARCLGFOURN'')';
                  qry.open;
                  CLGID := qry.fields[0].AsString;
                  sql.sql.text := 'Insert into TARCLGFOURN (' +
                    'CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,' +
                    'CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,' +
                    'CLG_TAXE,CLG_PRINCIPAL' +
                    ') Values (' +
                    CLGID + ',' + ARTID + ',' + FOUID + ',0,' + floattostr(PxMinC) + ',' +
                    floattostr(PxMinA) + ',0,0,0,0,0,1)';
                  sql.ExecQuery;
                  qry.close;
                  qry.Sql.text := 'SELECT ID FROM PR_NEWK (''TARPRIXVENTE'')';
                  qry.open;
                  PVTID := qry.fields[0].AsString;
                  sql.sql.text := 'Insert into TARPRIXVENTE (' +
                    'PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX' +
                    ') values (' +
                    PVTID + ',0,' + artid + ',0,' + floattostr(PxMinV) + ')';
                  sql.ExecQuery;
                END;

                cbs := lexml.FindTag(art, 'CODE_BARRES');
                // gestion des prix/CB par taille
                tas := lexml.FindTag(art, 'GRILLE_TAILLES');
                ta := lexml.FindTag(tas, 'TAILLES');
                ta := lexml.FindTag(ta, 'TAILLE');
                TTVmax := 0;
                WHILE ta <> NIL DO
                BEGIN
                  // création des tailles travaillées pour TOUTE LA GRILLE de TAILLES
                  Inc(TTVmax);
                  IF (TTVmax < 29) THEN
                  BEGIN
                    IF NOT Chk_TaillesTrav.Checked THEN
                    BEGIN
                      IF NOT creart THEN
                      BEGIN
                        qry.close;
                        qry.Sql.text := 'Select TTV_ID from PLXTAILLESTRAV join k on (k_id=ttv_id and k_enabled=1) ' +
                          ' where TTV_ARTID = ' + ArtID +
                          ' And TTV_TGFID=' + leXml.ValueTag(ta, 'TGFID');
                        qry.open;
                        IF NOT qry.eof THEN
                        BEGIN // la ligne existe
                          TTVID := qry.Fields[0].AsString;
                        END
                        ELSE
                        BEGIN // la ligne n'existe pas création
                          qry.close;
                          qry.Sql.text := 'SELECT ID FROM PR_NEWK (''PLXTAILLESTRAV'')';
                          qry.open;
                          TTVID := qry.Fields[0].AsString;
                          Sql.sql.text := 'Insert into PLXTAILLESTRAV (TTV_ID,TTV_ARTID,TTV_TGFID) ' +
                            ' values (' + TTVID + ',' + ARTID + ',' + leXml.ValueTag(ta, 'TGFID') + ')';
                          Sql.ExecQuery;
                        END;
                      END
                      ELSE
                      BEGIN
                        qry.close;
                        qry.Sql.text := 'SELECT ID FROM PR_NEWK (''PLXTAILLESTRAV'')';
                        qry.open;
                        TTVID := qry.Fields[0].AsString;
                        Sql.sql.text := 'Insert into PLXTAILLESTRAV (TTV_ID,TTV_ARTID,TTV_TGFID) ' +
                          ' values (' + TTVID + ',' + ARTID + ',' + leXml.ValueTag(ta, 'TGFID') + ')';
                        Sql.ExecQuery;
                      END;
                    END;
                  END;

                  // pour chaque taille/couleur création du code barre prin
                  cou := lexml.findtag(cous, 'COULEUR');
                  WHILE cou <> NIL DO
                  BEGIN
                    IF NOT creArt THEN
                    BEGIN
                      // test pour ne créer que les CB nécessaires
                      qry.close;
                      qry.sql.text := 'Select CBI_ID from ARTCODEBARRE join k on (k_id=cbi_id and k_enabled=1) ' +
                        ' where CBI_ARFID = ' + arfid +
                        ' and CBI_TGFID = ' + LeXml.ValueTag(ta, 'TGFID') +
                        ' and CBI_COUID = ' + LeXml.ValueTag(cou, 'COUID') +
                        ' and CBI_TYPE =1';
                      qry.Open;
                      IF qry.eof THEN
                      BEGIN // création du code barre
                        IBST_CB.Prepare;
                        IBST_CB.ExecProc;
                        S := IBST_CB.Parambyname('NEWNUM').AsString;
                        IBST_CB.UnPrepare;
                        qry.close;
                        qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
                        qry.open;
                        cbiid := qry.fields[0].AsString;
                        sql.sql.text := 'INSERT INTO ARTCODEBARRE (' +
                          'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
                          'CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC' +
                          ') values (' +
                          CBIID + ',' + arfid + ',' + LeXml.ValueTag(ta, 'TGFID') + ',' + LeXml.ValueTag(cou, 'COUID') + ',' + QuotedStr(s) + ',' +
                          '1,0,0,0)';
                        sql.ExecQuery;
                      END
                      ELSE
                        cbiid := qry.fields[0].AsString;
                    END
                    ELSE
                    BEGIN
                      IBST_CB.Prepare;
                      IBST_CB.ExecProc;
                      S := IBST_CB.Parambyname('NEWNUM').AsString;
                      IBST_CB.UnPrepare;
                      qry.close;
                      qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
                      qry.open;
                      cbiid := qry.fields[0].AsString;
                      sql.sql.text := 'INSERT INTO ARTCODEBARRE (' +
                        'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
                        'CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC' +
                        ') values (' +
                        CBIID + ',' + arfid + ',' + LeXml.ValueTag(ta, 'TGFID') + ',' + LeXml.ValueTag(cou, 'COUID') + ',' + QuotedStr(s) + ',' +
                        '1,0,0,0)';
                      sql.ExecQuery;
                    END;

                    IF cbs <> NIL THEN
                    BEGIN
                      cb := lexml.findtag(cbs, 'CODE_BARRE');
                      WHILE cb <> NIL DO
                      BEGIN
                        IF (LeXml.ValueTag(cb, 'TAILLE') = LeXml.ValueTag(ta, 'NOM')) AND
                          (LeXml.ValueTag(cb, 'COULEUR') = LeXml.ValueTag(cou, 'NOM')) THEN
                        BEGIN
                          // création des tailles travaillées UNIQUEMENT pour les CB ou qté est renseigné
                          IF Chk_TaillesTrav.Checked THEN
                          BEGIN
                            // FC 13/10/2009 : Ajout d'une case à cocher pour forcer la création des tailles travaillées meme si stock à 0
                            IF ((LeXml.ValueTag(cb, 'QTTE') <> '') AND (LeXml.ValueTag(cb, 'QTTE') <> '0')) OR (Chk_TaillesTrav0.Checked) THEN
                            BEGIN
                              // Qtté <> 0 ou Coche 'activer meme si 0' cochée.
                              IF NOT creart THEN
                              BEGIN
                                qry.close;
                                qry.Sql.text := 'Select TTV_ID from PLXTAILLESTRAV join k on (k_id=ttv_id and k_enabled=1) ' +
                                  ' where TTV_ARTID = ' + ArtID +
                                  ' And TTV_TGFID=' + leXml.ValueTag(ta, 'TGFID');
                                qry.open;
                                IF NOT qry.eof THEN
                                BEGIN // la ligne existe
                                  TTVID := qry.Fields[0].AsString;
                                END
                                ELSE
                                BEGIN // la ligne n'existe pas création
                                  qry.close;
                                  qry.Sql.text := 'SELECT ID FROM PR_NEWK (''PLXTAILLESTRAV'')';
                                  qry.open;
                                  TTVID := qry.Fields[0].AsString;
                                  Sql.sql.text := 'Insert into PLXTAILLESTRAV (TTV_ID,TTV_ARTID,TTV_TGFID) ' +
                                    ' values (' + TTVID + ',' + ARTID + ',' + leXml.ValueTag(ta, 'TGFID') + ')';
                                  Sql.ExecQuery;
                                END;
                              END
                              ELSE
                              BEGIN
                                qry.close;
                                qry.Sql.text := 'SELECT ID FROM PR_NEWK (''PLXTAILLESTRAV'')';
                                qry.open;
                                TTVID := qry.Fields[0].AsString;
                                Sql.sql.text := 'Insert into PLXTAILLESTRAV (TTV_ID,TTV_ARTID,TTV_TGFID) ' +
                                  ' values (' + TTVID + ',' + ARTID + ',' + leXml.ValueTag(ta, 'TGFID') + ')';
                                Sql.ExecQuery;
                              END;
                            END;
                          END;

                          // code barre
                          S := LeXml.ValueTag(cb, 'EAN');
                          IF s <> '' THEN
                          BEGIN
                            // Si l'article est en création on ne teste pas l'existance du CB
                            IF NOT creart THEN
                            BEGIN
                              // test pour verif que le CB n'existe pas
                              qry.close;
                              qry.Sql.Text := 'Select CBI_ID from ARTCODEBARRE join k on (k_id=cbi_id and k_enabled=1) ' +
                                ' where CBI_ARFID=' + arfid +
                                ' and CBI_TGFID=' + LeXml.ValueTag(ta, 'TGFID') +
                                ' and CBI_COUID=' + LeXml.ValueTag(cou, 'COUID') +
                                ' and CBI_TYPE=3' +
                                ' and CBI_CB=' + QuotedStr(s);
                              qry.Open;
                              IF qry.isempty THEN
                              BEGIN
                                qry.close;
                                qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
                                qry.open;
                                cbiid := qry.fields[0].AsString;
                                sql.sql.text := 'INSERT INTO ARTCODEBARRE (' +
                                  'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
                                  'CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC' +
                                  ') values (' +
                                  CBIID + ',' + arfid + ',' + LeXml.ValueTag(ta, 'TGFID') + ',' + LeXml.ValueTag(cou, 'COUID') + ',' + QuotedStr(s) + ',' +
                                  '3,0,0,0)';
                                sql.ExecQuery;
                              END
                              ELSE
                                cbiid := qry.fields[0].AsString;
                            END
                            ELSE
                            BEGIN
                              qry.close;
                              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
                              qry.open;
                              cbiid := qry.fields[0].AsString;
                              sql.sql.text := 'INSERT INTO ARTCODEBARRE (' +
                                'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
                                'CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC' +
                                ') values (' +
                                CBIID + ',' + arfid + ',' + LeXml.ValueTag(ta, 'TGFID') + ',' + LeXml.ValueTag(cou, 'COUID') + ',' + QuotedStr(s) + ',' +
                                '3,0,0,0)';
                              sql.ExecQuery;

                            END;
                          END;
                          S := LeXml.ValueTag(cb, 'QTTE');
                          IF (s <> '') THEN
                          BEGIN
                            // création d'une conso div
                            MAG_NOM := LeXml.ValueTag(cb, 'MAG_NOM');
                            LeMagID := MAGID;
                            IF trim(MAG_NOM) <> '' THEN
                            BEGIN
                              qry.close;
                              qry.sql.text := 'Select MAG_ID from GenMagasin join k on (k_id=MAG_ID and k_enabled=1) ' +
                                ' where MAG_NOM = ' + quotedstr(MAG_NOM);
                              qry.Open;
                              IF NOT qry.isempty THEN
                                LeMagID := qry.fields[0].AsString;
                            END;
                            TRY
                              i := strtoint(s);
                              s := inttostr(-i);
                              IF (s <> '0') THEN
                              BEGIN
                                qry.close;
                                qry.Sql.text := 'SELECT ID FROM PR_NEWK (''CONSODIV'')';
                                qry.open;
                                cdvid := qry.fields[0].AsString;
                                sql.sql.text := 'Insert into CONSODIV (' +
                                  'CDV_ID,CDV_ARTID,CDV_TGFID,CDV_COUID,CDV_MAGID,' +
                                  'CDV_TYPID,CDV_DATE,CDV_COMENT,CDV_QTE' +
                                  ') Values (' +
                                  CDVID + ',' + ARTID + ',' + LeXml.ValueTag(ta, 'TGFID') + ',' + LeXml.ValueTag(cou, 'COUID') + ',' + LeMagID + ',' +
                                  '290,current_date,''Importation'',' + S + ')';
                                sql.ExecQuery;
                              END;
                            EXCEPT
                            END;
                            // 290
                          END;
                        END;
                        cb := cb.NextSibling;
                      END;
                    END;
                    cou := cou.NextSibling;
                  END;

                  IF pxs <> NIL THEN
                  BEGIN
                    px := lexml.findtag(pxs, 'LEPRIX');
                    WHILE px <> NIL DO
                    BEGIN
                      IF leXml.ValueTag(px, 'TAILLE') = leXml.ValueTag(ta, 'NOM') THEN
                      BEGIN
                        s := leXml.ValueTag(px, 'PXVTE');
                        IF s <> '' THEN
                        BEGIN
                          TRY
                            IF Abs(strtofloat(s) - PxMinV) > 0.009 THEN
                            BEGIN
                              // Si l'article est en création on ne teste pas l'existance du CB
                              IF NOT creart THEN
                              BEGIN

                                // tester si ce prix existe déja
                                qry.close;
                                qry.Sql.text := 'SELECT pvt_id, pvt_px from TARPRIXVENTE join k on (k_id=PVT_ID and k_enabled=1) ' +
                                  ' where PVT_TVTID=0 and PVT_ARTID = ' + Artid +
                                  ' and PVT_TGFID = ' + leXml.ValueTag(ta, 'TGFID');
                                qry.open;
                                IF qry.isempty THEN
                                BEGIN
                                  qry.close;
                                  qry.Sql.text := 'SELECT ID FROM PR_NEWK (''TARPRIXVENTE'')';
                                  qry.open;
                                  PVTID := qry.fields[0].AsString;
                                  sql.sql.text := 'Insert into TARPRIXVENTE (' +
                                    'PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX' +
                                    ') values (' +
                                    PVTID + ',0,' + artid + ',' + leXml.ValueTag(ta, 'TGFID') + ',' + s + ')';
                                  sql.ExecQuery;
                                END
                                ELSE
                                BEGIN
                                  // si le nouveau prix de vente est SUP alors MAJ
                                  IF (qry.fields[1].Asfloat < strtofloat(s)) THEN
                                  BEGIN
                                    PVTID := qry.fields[0].AsString;
                                    updatek(pvtid);
                                    sql.sql.text := 'Update TARPRIXVENTE ' +
                                      ' set PVT_PX=' + s +
                                      ' where pvt_id = ' + PVTID;
                                    sql.execquery;
                                  END;
                                END;
                              END
                              ELSE
                              BEGIN
                                qry.close;
                                qry.Sql.text := 'SELECT ID FROM PR_NEWK (''TARPRIXVENTE'')';
                                qry.open;
                                PVTID := qry.fields[0].AsString;
                                sql.sql.text := 'Insert into TARPRIXVENTE (' +
                                  'PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX' +
                                  ') values (' +
                                  PVTID + ',0,' + artid + ',' + leXml.ValueTag(ta, 'TGFID') + ',' + s + ')';
                                sql.ExecQuery;
                              END;
                            END;
                          EXCEPT
                          END;
                        END;

                        s := leXml.ValueTag(px, 'PXACH');
                        IF s <> '' THEN
                        BEGIN
                          TRY
                            IF Abs(strtofloat(s) - PxMinA) > 0.009 THEN
                            BEGIN
                              // Test si le tarif d'achat existe déja
                              qry.close;
                              qry.Sql.text := 'SELECT CLG_ID, CLG_PXNEGO from TARCLGFOURN join k on (k_id=CLG_ID and k_enabled=1) ' +
                                ' Where CLG_ARTID = ' + artid +
                                ' and CLG_FOUID = ' + FOUID +
                                ' and CLG_TGFID = ' + leXml.ValueTag(ta, 'TGFID');
                              qry.open;
                              IF qry.isempty THEN
                              BEGIN
                                qry.close;
                                qry.sql.text := 'SELECT CLG_ID  from TARCLGFOURN join k on (k_id=CLG_ID and k_enabled=1) ' +
                                  ' Where CLG_ARTID = ' + artid +
                                  ' and CLG_TGFID = ' + leXml.ValueTag(ta, 'TGFID');
                                qry.open;
                                IF qry.isempty THEN // si pas encore de tarif pour cette taille mettre le tarif principale ==> 1
                                BEGIN
                                  qry.close;
                                  qry.Sql.text := 'SELECT ID FROM PR_NEWK (''TARCLGFOURN'')';
                                  qry.open;
                                  CLGID := qry.fields[0].AsString;
                                  sql.sql.text := 'Insert into TARCLGFOURN (' +
                                    'CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,' +
                                    'CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,' +
                                    'CLG_TAXE,CLG_PRINCIPAL' +
                                    ') Values (' +
                                    CLGID + ',' + ARTID + ',' + FOUID + ',' + leXml.ValueTag(ta, 'TGFID') + ',' + leXml.ValueTag(px, 'PXCATALOG') + ',' +
                                    s + ',0,0,0,0,0,1)';
                                  sql.ExecQuery;
                                END
                                ELSE // si un tarif pour cette taille existe déja mettre ==> 0
                                BEGIN
                                  qry.close;
                                  qry.Sql.text := 'SELECT ID FROM PR_NEWK (''TARCLGFOURN'')';
                                  qry.open;
                                  CLGID := qry.fields[0].AsString;
                                  sql.sql.text := 'Insert into TARCLGFOURN (' +
                                    'CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,' +
                                    'CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,' +
                                    'CLG_TAXE,CLG_PRINCIPAL' +
                                    ') Values (' +
                                    CLGID + ',' + ARTID + ',' + FOUID + ',' + leXml.ValueTag(ta, 'TGFID') + ',' + leXml.ValueTag(px, 'PXCATALOG') + ',' +
                                    s + ',0,0,0,0,0,0)';
                                  sql.ExecQuery;
                                END;
                              END
                              ELSE
                              BEGIN // si le prix d'achat est inf. à celui dans la base, faire la maj
                                IF (qry.fields[1].asfloat > StrtoFloat(s)) THEN
                                BEGIN
                                  CLGID := qry.fields[0].AsString;
                                  updatek(clgid);
                                  sql.sql.text := 'Update TARCLGFOURN ' +
                                    ' set CLG_PX=' + leXml.ValueTag(px, 'PXCATALOG') +
                                    ', CLG_PXNEGO=' + s +
                                    ' where CLG_ID = ' + CLGID;
                                  sql.ExecQuery;
                                END;
                              END;
                            END;
                          EXCEPT
                          END;
                        END;
                      END;
                      px := px.NextSibling;
                    END;
                  END;
                  ta := ta.NextSibling;
                END;
              END;
            END;
          EXCEPT
            ON E: Exception DO
            BEGIN
              writeln(Log, '<ARTICLE>');
              AddValue(Log, 'NOM', lexml.ValueTag(art, 'NOM'));
              AddValue(Log, 'CODE', lexml.ValueTag(art, 'CODE'));
              AddValue(Log, 'ERREUR', E.message);
              writeln(Log, '</ARTICLE>');
            END;
          END;
          IF Tran_ecr.InTransaction THEN
            Tran_ecr.commit;
          IF Tran_lect.InTransaction THEN
            Tran_lect.commit;
          Tran_lect.active := true;
          Tran_ecr.active := true;
          sql.Transaction.active := true;
          Art := Art.NextSibling;
        END;
      END;
    FINALLY
      Base.Close;
      writeln(Log, '</ARTICLES>');
      closefile(Log);

      leXmlR := TmonXML.create;
      leXmlR.LoadFromFile(ed_rep.text + 'LogArt.xml');
      // Gestion des erreurs
      tsl := tstringlist.Create;
      tsl.add('<HTML>');
      tsl.Add('<head>');
      tsl.Add('<title>' + 'Importation ' + Datetostr(Date) + '</title>');
      tsl.Add('</head>');
      tsl.Add('<body>');
      tsl.Add('<FONT SIZE="-2">');
      tsl.Add('Ce document est sauvegardé dans le répertoire de votre importation, il peut être imprimé par le menu fichier imprimer ou par la combinaison de touches CTRL-P<BR>');
      tsl.Add('</FONT>');
      tsl.Add('Importation des articles du ' + Datetostr(Date) + ' sur la base ' + ed_Base.text + '<BR>');
      tsl.add('<P>');
      IF nbart = 0 THEN
        tsl.add('Aucun article intégré')
      ELSE IF Nbart = 1 THEN
      BEGIN
        tsl.add('1 article intégré sur le code chrono : ' + PremChrono + '<BR>')
      END
      ELSE
      BEGIN
        tsl.add(Inttostr(Nbart) + ' articles intégrés sur les codes chrono de ' + PremChrono + ' à ' + DernChrono + '<BR>');
      END;
      tsl.add('<P>');
      prem := true;
      Art := LeXmlR.find('/ARTICLES/ARTICLE');
      WHILE (art <> NIL) AND (art.getname = 'ARTICLE') DO
      BEGIN
        IF leXmlR.ValueTag(art, 'ERREUR') <> '' THEN
        BEGIN
          IF prem THEN
          BEGIN
            tsl.add('Liste des articles non intégré' + '<BR>' + '<BR>');
            prem := false;
          END;
          S := leXmlR.ValueTag(art, 'CODE');
          S1 := leXmlR.ValueTag(art, 'NOM');
          IF s <> '' THEN
            S := S + ' : ' + S1
          ELSE
            S := S1;
          Tsl.Add('l''article ' + S + ' N''est pas intégré car : ' + leXmlR.ValueTag(art, 'ERREUR') + '<BR>');
        END;
        art := art.NextSibling;
      END;

      tsl.add('<P>');
      prem1 := true;
      Art := LeXmlR.find('/ARTICLES/ARTICLE');
      WHILE (art <> NIL) AND (art.getname = 'ARTICLE') DO
      BEGIN
        IF leXmlR.ValueTag(art, 'EXISTE') <> '' THEN
        BEGIN
          IF prem1 THEN
          BEGIN
            tsl.add('Liste des articles déjà existant' + '<BR>' + '<BR>');
            prem1 := false;
          END;
          S := leXmlR.ValueTag(art, 'CODE');
          S1 := leXmlR.ValueTag(art, 'NOM');
          IF s <> '' THEN
            S := S + ' : ' + S1
          ELSE
            S := S1;
          Tsl.Add('l''article ' + S + ' déjà présent dans votre base ' + leXmlR.ValueTag(art, 'EXISTE') + '<BR>');
        END;
        art := art.NextSibling;
      END;

      tsl.add('<P>');
      IF prem THEN
      BEGIN
        tsl.add('Tous les articles ont été intégrés' + '<BR>' + '<BR>');
      END;
      tsl.Add('</body>');
      tsl.add('</HTML>');
      S := IncludeTrailingBackslash(extractfilepath(XML)) + 'ART_' + FormatDateTime('YYYY"-"MM"-"DD" "HH"H"NN', now) + '.HTML';
      tsl.savetofile(S);
      ShellExecute(Application.handle, 'open', Pchar(s), NIL, '', SW_SHOWDEFAULT);
      leXmlR.free;
      leXml.free;
      Application.messagebox('importation terminée, consultez le rapport.', ' Fin ', mb_ok);
      lesfou.free;
    END;
  END;
  //
  application.MessageBox('C''est fini', 'Fin', mb_ok);
END;

PROCEDURE TForm1.TraiteFicStock(AFile: STRING; ADefaultMagId: integer);
VAR
  XmlStock: TMonXML;

  Stk: TIcXMLElement;

  sCodeArt, sArtID, sChrono: STRING;
  sTgfID, sTaille: STRING;
  sCouID, sCouleur: STRING;

  MyArt: TArtTailCoul;
  //  iArtId, iTgfId, iCouId : Integer;
//  iGtfId: Integer;
//  sGtfNom: STRING;

  sId: STRING;

  sCodeBarre: STRING;
  iQtte: Integer;
  sQte: STRING;
  sMagId, sMagNom: STRING;
  iMagId: Integer;
BEGIN
  // On s'occupe de traiter le fichier XML
  XmlStock := TmonXML.Create;
  TRY
    // Ouverture
    XmlStock.LoadFromFile(AFile);

    // TODO : Progress BAR

    Stk := XmlStock.find('/STOCKS/STOCK');
    // Pour chaque STOCK du noeud STOCKS
    WHILE Stk <> NIL DO
    BEGIN
      // Lecture du noeud
      sCodeArt := Uppercase(XmlStock.ValueTag(Stk, 'CODE'));
      sArtID := Uppercase(XmlStock.ValueTag(Stk, 'ART_ID'));
      sChrono := Uppercase(XmlStock.ValueTag(Stk, 'CHRONO'));
      sTgfID := Uppercase(XmlStock.ValueTag(Stk, 'TGF_ID'));
      sTaille := Uppercase(XmlStock.ValueTag(Stk, 'TAILLE'));
      sCouID := Uppercase(XmlStock.ValueTag(Stk, 'COU_ID'));
      sCouleur := Uppercase(XmlStock.ValueTag(Stk, 'COULEUR'));
      sCodeBarre := Uppercase(XmlStock.ValueTag(Stk, 'EAN'));
      sMagId := Uppercase(XmlStock.ValueTag(Stk, 'MAG_ID'));
      sMagNom := Uppercase(XmlStock.ValueTag(Stk, 'MAG_NOM'));

      TRY
        iQtte := StrToInt(XmlStock.ValueTag(Stk, 'QTTE'));
      EXCEPT
        iQtte := 0;
      END;

      IF NOT (iQtte = 0) THEN
      BEGIN
        iMagId := Stock_GetMagId(sMagId, ADefaultMagId);

        IF iMagId = 0 THEN
        BEGIN
          // On a pas trouvé d'article du tout -> Log
          writeln(Log, '<STOCK>');
          AddValue(Log, 'CODE', sCodeArt);
          AddValue(Log, 'CHRONO', sChrono);
          AddValue(Log, 'MAG_ID', sMagId);
          AddValue(Log, 'MAGASIN', sMagNom);
          AddValue(Log, 'ERREUR', 'Impossible de trouver le magasin');
          writeln(Log, '</STOCK>');
        END
        ELSE BEGIN
          MyArt := Stock_GetArticle(sCodeBarre, sArtId, sChrono);

          // Si c'est une code barre, c'est bon, on a toutes les infos, on saute la recherche article/taille/coul
          IF NOT ((MyArt.iArtId <> 0) AND (MyArt.iTgfId <> 0) AND (MyArt.iCouId <> 0)) THEN
          BEGIN
            // On a pas trouvé de code barre
            IF MyArt.iArtId <= 0 THEN
            BEGIN
              // On a pas trouvé d'article du tout -> Log
              writeln(Log, '<STOCK>');
              AddValue(Log, 'CODE', sCodeArt);
              AddValue(Log, 'CHRONO', sChrono);
              AddValue(Log, 'EAN', sCodeBarre);
              AddValue(Log, 'ART_ID', sArtId);
              AddValue(Log, 'ERREUR', 'Impossible de trouver l''article');
              writeln(Log, '</STOCK>');
            END
            ELSE BEGIN
              MyArt.iTgfId := Stock_GetTgfId(sTgfId, sTaille, IntToStr(MyArt.iGtfId));

              IF MyArt.iTgfId = 0 THEN
              BEGIN
                // Taille non trouvée, on log
                writeln(Log, '<STOCK>');
                AddValue(Log, 'CODE', sCodeArt);
                AddValue(Log, 'CHRONO', sChrono);
                AddValue(Log, 'TAILLE', sTaille);
                AddValue(Log, 'TGF_ID', sTgfId);
                AddValue(Log, 'GRILLE_TAILLE', MyArT.sGtfNom);
                AddValue(Log, 'ERREUR', 'Impossible de trouver la taille dans la grille de tailles');
                writeln(Log, '</STOCK>');
              END
              ELSE BEGIN
                // Vérification de la taille travaillée
                Stock_VerifTtv(IntToStr(MyArt.iTgfId), IntToStr(MyArt.iArtId), sCodeArt, sChrono, sTaille, MyArt.sGtfNom);

                // Recherche de la couleur par id
                MyArt.iCouId := Stock_GetCouId(MyArt.iArtId, sCouId, sCouleur);
                IF MyArt.iCouId = 0 THEN
                BEGIN
                  // couleur non trouvée, on log
                  writeln(Log, '<STOCK>');
                  AddValue(Log, 'CODE', sCodeArt);
                  AddValue(Log, 'CHRONO', sChrono);
                  AddValue(Log, 'COULEUR', sCouleur);
                  AddValue(Log, 'COU_ID', sCouId);
                  AddValue(Log, 'ERREUR', 'Impossible de trouver la couleur');
                  writeln(Log, '</STOCK>');
                END;
              END;

            END;
          END;

          IF (MyArt.iArtId <> 0) AND (MyArt.iTgfId <> 0) AND (MyArt.iCouId <> 0) THEN
          BEGIN
            // Tout est ok, Création de la conso div
            qry.close;
            qry.Sql.text := 'SELECT ID FROM PR_NEWK (''CONSODIV'')';
            qry.open;

            sQte := IntToStr(-iQtte);
            sId := qry.fields[0].AsString;
            sql.sql.text := 'INSERT INTO CONSODIV' +
              '( CDV_ID, CDV_ARTID, CDV_TGFID' +
              ', CDV_COUID, CDV_MAGID' +
              ',  CDV_TYPID, CDV_DATE, CDV_COMENT' +
              ',  CDV_QTE)' +
              ' VALUES ' +
              '( ' + sId + ', ' + IntToStr(MyArt.iArtId) + ', ' + IntToStr(MyArt.iTgfId) +
              ', ' + IntToStr(MyArt.iCouId) + ', ' + IntToStr(iMagId) +
              ',  290, current_date, ''Importation''' +
              ',  ' + sQte + ')';

            sql.ExecQuery;
          END;

          IF Tran_ecr.InTransaction THEN
            Tran_ecr.commit;
          IF Tran_lect.InTransaction THEN
            Tran_lect.commit;
          Tran_lect.active := true;
          Tran_ecr.active := True;
        END;

      END;
      Stk := Stk.NextSibling;
    END;
  FINALLY
    XmlStock.free
  END;
END;

PROCEDURE TForm1.ArtXMLClick(Sender: TObject);
BEGIN
  OdXml.InitialDir := ed_Rep.text;
  IF OdXml.execute THEN
    ImportXml(OdXml.Filename, Chk_SelectMag.Checked);
END;

PROCEDURE TForm1.Btn_1Click(Sender: TObject);
VAR
  ficStock: TextFile;

  tslStock: TStringList;

  iNbFic, iNbStk: Integer;

  sMagId, sMagNom: STRING;

  i: Integer;
BEGIN
  // Chargement du CSV
  tslStock := TStringList.Create;
  TRY
    tslStock.LoadFromFile(ed_rep.text + 'stock.csv');

    // Connection à la base
    Base.close;
    Base.DatabaseName := ed_base.text;
    Base.Open;
    tran_lect.active := true;

    // choisir le magasin d'importation
    qry.close;
    qry.sql.text := 'select MAG_ID, MAG_NOM from genmagasin join k on (k_id=mag_id and k_enabled=1) where mag_id<>0';
    qry.Open;
    application.createform(Tfrm_ChxMag, frm_ChxMag);
    WHILE NOT qry.Eof DO
    BEGIN
      frm_ChxMag.Lb_Mag.items.AddObject(Qry.fields[1].AsString, pointer(Qry.fields[0].asInteger));
      qry.Next;
    END;
    qry.close;
    frm_ChxMag.Lb_Mag.ItemIndex := 0;
    IF NOT Chk_SelectMag.Checked THEN
      frm_ChxMag.ShowModal;
    sMagId := Inttostr(Integer(frm_ChxMag.Lb_Mag.items.Objects[frm_ChxMag.Lb_Mag.ItemIndex]));
    sMagNom := frm_ChxMag.Lb_Mag.Items[frm_ChxMag.Lb_Mag.ItemIndex];
    frm_ChxMag.release;

    // Création du fichier XML
    iNbFic := 0;
    assignfile(ficStock, GetFilePath('stock', iNbFic));
    rewrite(ficStock);

    // Entete du fichier XML
    writeln(ficStock, '<?xml version="1.0" encoding="ISO-8859-1"?>');
    writeln(ficStock, '<STOCKS>');

    iNbStk := 0;

    // Pour chaque ligne du CSV
    FOR i := 1 TO tslStock.Count - 1 DO
    BEGIN
      IF iNbStk > 1000 THEN
      BEGIN
        // Cloture du fichier
        WriteLn(ficStock, '</STOCKS>');
        CloseFile(ficStock);
        Inc(iNbFic);
        // Création du fichier XML
        AssignFile(ficStock, GetFilePath('stock', iNbFic));
        ReWrite(ficStock);

        // Entete du fichier XML
        writeln(ficStock, '<?xml version="1.0" encoding="ISO-8859-1"?>');
        writeln(ficStock, '<STOCKS>');
        iNbStk := 0;
      END;

      // Ecriture du noeud
      IF tslChamps(tslStock[i], 9) <> '0' THEN
      BEGIN
        writeln(ficStock, '<STOCK>');
        AddValue(ficStock, 'CODE', tslChamps(tslStock[i], 1));
        AddValue(ficStock, 'ART_ID', tslChamps(tslStock[i], 2));
        AddValue(ficStock, 'CHRONO', tslChamps(tslStock[i], 3));
        AddValue(ficStock, 'TGF_ID', tslChamps(tslStock[i], 4));
        AddValue(ficStock, 'TAILLE', tslChamps(tslStock[i], 5));
        AddValue(ficStock, 'COU_ID', tslChamps(tslStock[i], 6));
        AddValue(ficStock, 'COULEUR', tslChamps(tslStock[i], 7));
        AddValue(ficStock, 'EAN', tslChamps(tslStock[i], 8));
        AddValue(ficStock, 'QTTE', tslChamps(tslStock[i], 9));
        AddValue(ficStock, 'MAG_ID', sMagId);
        AddValue(ficStock, 'MAG_NOM', sMagNom);
        writeln(ficStock, '</STOCK>');

        // Pour le découpage par 1000
        Inc(iNbStk);
      END;

    END;

    // Cloture du fichier
    WriteLn(ficStock, '</STOCKS>');
    CloseFile(ficStock);

  FINALLY
    tslStock.Free;
  END;

  ImportStockXml(StrToInt(sMagId));
END;

PROCEDURE TForm1.Btn_2Click(Sender: TObject);
BEGIN
  ImportStockXml(0);
END;

PROCEDURE TForm1.Button4Click(Sender: TObject);
BEGIN
  close;
END;

PROCEDURE TForm1.FormCreate(Sender: TObject);
var
  s:string;
BEGIN
  DecimalSeparator := '.';
  s:=ExtractFilePath(paramstr(0));
  if s[Length(s)]<>'\' then
    s:=s+'\';
  ed_Rep.Text := s;

  // FC 13/10/2009 : Ajout d'une case à cocher pour forcer la création des tailles travaillées meme si stock à 0
  Chk_TaillesTrav0.Enabled := Chk_TaillesTrav.Checked;
END;

PROCEDURE TForm1.CltXlsClick(Sender: TObject);
VAR
  tslpro, tslpart: tstringlist;
  i: integer;
  tsl: tstringlist;
BEGIN
  IF fileexists(ed_rep.text + 'CliPart.csv') OR
    fileexists(ed_rep.text + 'CliPro.csv') THEN
  BEGIN
    tsl := tstringlist.create;
    tslpro := tstringlist.create;
    IF fileexists(ed_rep.text + 'CliPro.csv') THEN
      tslpro.Loadfromfile(ed_rep.text + 'CliPro.csv');
    tslpart := tstringlist.create;
    IF fileexists(ed_rep.text + 'CliPart.csv') THEN
      tslpart.Loadfromfile(ed_rep.text + 'CliPart.csv');
    tsl.add('<CLIENTS>');
    FOR i := 1 TO tslpart.count - 1 DO
    BEGIN
      tsl.add('<CLIENT>');
      AddValue(tsl, 'TYPE', 'PART');
      AddValue(tsl, 'NOM', tslChamps(tslpart[i], 2));
      AddValue(tsl, 'PRENOM', tslChamps(tslpart[i], 3));
      AddValue(tsl, 'CIV', tslChamps(tslpart[i], 4));
      AddValue(tsl, 'CODE_CPT', tslChamps(tslpart[i], 11));
      tsl.add('<ADRESSE>');
      AddValue(tsl, 'LIGNE1', tslChamps(tslpart[i], 5));
      AddValue(tsl, 'LIGNE2', tslChamps(tslpart[i], 6));
      AddValue(tsl, 'LIGNE3', tslChamps(tslpart[i], 7));
      AddValue(tsl, 'CP', tslChamps(tslpart[i], 8));
      AddValue(tsl, 'VILLE', tslChamps(tslpart[i], 9));
      AddValue(tsl, 'PAYS', tslChamps(tslpart[i], 10));
      AddValue(tsl, 'COMMENTAIRE', tslChamps(tslpart[i], 12));
      AddValue(tsl, 'TEL', tslChamps(tslpart[i], 13));
      AddValue(tsl, 'TEL_TRAV', tslChamps(tslpart[i], 14));
      AddValue(tsl, 'PORTABLE', tslChamps(tslpart[i], 15));
      AddValue(tsl, 'EMAIL', tslChamps(tslpart[i], 16));
      tsl.add('</ADRESSE>');
      tsl.add('</CLIENT>');
    END;
    FOR i := 1 TO tslpro.count - 1 DO
    BEGIN
      tsl.add('<CLIENT>');
      AddValue(tsl, 'TYPE', 'PRO');
      AddValue(tsl, 'RS1', tslChamps(tslpro[i], 2));
      AddValue(tsl, 'RS2', tslChamps(tslpro[i], 3));
      AddValue(tsl, 'CODE_CPT', tslChamps(tslpro[i], 10));
      tsl.add('<ADRESSE>');
      AddValue(tsl, 'LIGNE1', tslChamps(tslpro[i], 4));
      AddValue(tsl, 'LIGNE2', tslChamps(tslpro[i], 5));
      AddValue(tsl, 'LIGNE3', tslChamps(tslpro[i], 6));
      AddValue(tsl, 'CP', tslChamps(tslpro[i], 7));
      AddValue(tsl, 'VILLE', tslChamps(tslpro[i], 8));
      AddValue(tsl, 'PAYS', tslChamps(tslpro[i], 9));
      AddValue(tsl, 'COMMENTAIRE', tslChamps(tslpro[i], 11));
      AddValue(tsl, 'TEL', tslChamps(tslpro[i], 12));
      AddValue(tsl, 'FAX', tslChamps(tslpro[i], 13));
      AddValue(tsl, 'PORTABLE', tslChamps(tslpro[i], 14));
      AddValue(tsl, 'EMAIL', tslChamps(tslpro[i], 15));
      tsl.add('</ADRESSE>');
      tsl.add('</CLIENT>');
    END;
    tsl.add('</CLIENTS>');
    tsl.Savetofile(ed_rep.text + 'Clients.XML');
    tsl.free;
    tslpro.free;
    tslpart.free;
    ImportClientXml(ed_rep.text + 'Clients.XML');
  END
  ELSE
  BEGIN
    application.messagebox('Aucun fichier Client , vérifier votre chemin d''importation', 'ATTENTION', Mb_OK);
  END;
END;

PROCEDURE TForm1.Chk_TaillesTravClick(Sender: TObject);
BEGIN
  // FC 13/10/2009 : Ajout d'une case à cocher pour forcer la création des tailles travaillées meme si stock à 0
  Chk_TaillesTrav0.Enabled := Chk_TaillesTrav.Checked;

  IF NOT Chk_TaillesTrav.Checked THEN
    Chk_TaillesTrav0.Checked := False;

END;

PROCEDURE TForm1.CltCSVClick(Sender: TObject);
VAR
  tslClt: tstringlist;
  i: integer;
  tsl: tstringlist;
  tslCpt, tslFid: TStringList;
  bCpt, bFid, bHasCpt, bHasFid: Boolean;
  iPos: Integer;
  s: STRING;
  sCodeCli: STRING;
BEGIN
  IF fileexists(ed_rep.text + 'Clients.csv') THEN
  BEGIN
    tsl := tstringlist.create;
    tslClt := tstringlist.create;
    tslCpt := tstringlist.Create;
    tslFid := tstringlist.Create;
    TRY
      bFid := False;
      bCpt := False;
      IF FileExists(ed_rep.text + 'Comptes.csv') THEN
      BEGIN
        tslCpt.Loadfromfile(ed_rep.text + 'Comptes.csv');
        IF tslCpt.Count > 1 THEN
        BEGIN
//          tslCpt.Delete(0);    INUTILE CAR LA BOUCLE PAR à 1
          bCpt := True;
        END;
      END;

      IF FileExists(ed_rep.text + 'Fidelite.csv') THEN
      BEGIN
        tslFid.Loadfromfile(ed_rep.text + 'Fidelite.csv');
        IF tslFid.Count > 1 THEN
        BEGIN
//          tslFid.Delete(0);
          bFid := True;
        END;
      END;

      tslClt.Loadfromfile(ed_rep.text + 'Clients.csv');
      tsl.add('<?xml version="1.0" encoding="ISO-8859-1"?>');
      tsl.add('<CLIENTS>');
      FOR i := 1 TO tslClt.count - 1 DO
      BEGIN
        // entete
        tsl.add('<CLIENT>');

        sCodeCli := tslChamps(TslClt[i], 1);

        S := tslChamps(TslClt[i], 2);
        // Cas des clients pro/Particuliers
        TRY
          AddValue(tsl, 'CHRONO', tslChamps(TslClt[i], 24));
        EXCEPT
          AddValue(tsl, 'CHRONO', '');
        END;

        IF S <> 'PRO' THEN
        BEGIN
          AddValue(tsl, 'TYPE', 'PART');
          AddValue(tsl, 'NOM', tslChamps(TslClt[i], 3));
          AddValue(tsl, 'PRENOM', tslChamps(TslClt[i], 4));
          AddValue(tsl, 'CIV', tslChamps(TslClt[i], 5));
        END
        ELSE BEGIN
          AddValue(tsl, 'TYPE', 'PRO');
          AddValue(tsl, 'RS1', tslChamps(TslClt[i], 3));
          AddValue(tsl, 'RS2', tslChamps(TslClt[i], 4));
        END;

        AddValue(tsl, 'CODE_CPT', tslChamps(TslClt[i], 12));
        tsl.add('<ADRESSE>');
        AddValue(tsl, 'LIGNE1', tslChamps(TslClt[i], 6));
        AddValue(tsl, 'LIGNE2', tslChamps(TslClt[i], 7));
        AddValue(tsl, 'LIGNE3', tslChamps(TslClt[i], 8));
        AddValue(tsl, 'CP', tslChamps(TslClt[i], 9));
        AddValue(tsl, 'VILLE', tslChamps(TslClt[i], 10));
        AddValue(tsl, 'PAYS', tslChamps(TslClt[i], 11));
        AddValue(tsl, 'COMMENTAIRE', tslChamps(TslClt[i], 13));
        AddValue(tsl, 'TEL', tslChamps(TslClt[i], 14));

        // Cas d'un pro : FAX au lieu du téléphone pro
        IF S <> 'PRO' THEN
        BEGIN
          AddValue(tsl, 'TEL_TRAV', tslChamps(TslClt[i], 15))
        END
        ELSE BEGIN
          AddValue(tsl, 'FAX', tslChamps(TslClt[i], 15));
        END;

        AddValue(tsl, 'PORTABLE', tslChamps(TslClt[i], 16));
        AddValue(tsl, 'EMAIL', tslChamps(TslClt[i], 17));
        tsl.add('</ADRESSE>');
        TRY
          AddValue(tsl, 'CB_NATIONAL', tslChamps(TslClt[i], 18));
          AddValue(tsl, 'CLASS1', tslChamps(TslClt[i], 19));
          AddValue(tsl, 'CLASS2', tslChamps(TslClt[i], 20));
          AddValue(tsl, 'CLASS3', tslChamps(TslClt[i], 21));
          AddValue(tsl, 'CLASS4', tslChamps(TslClt[i], 22));
          AddValue(tsl, 'CLASS5', tslChamps(TslClt[i], 23));
        EXCEPT
          AddValue(tsl, 'CB_NATIONAL', '');
          AddValue(tsl, 'CLASS1', '');
          AddValue(tsl, 'CLASS2', '');
          AddValue(tsl, 'CLASS3', '');
          AddValue(tsl, 'CLASS4', '');
          AddValue(tsl, 'CLASS5', '');
        END;

        // FC Ajout comptes et Fid
        // Comptes clients
        iPos := -1;
        IF bCpt THEN
        BEGIN // Fichier Comptes présent et chargé
          bHasCpt := False;
          iPos := chercheVal(tslCpt, 1, sCodeCli); // Trouve le code client
          IF iPos <> -1 THEN
          BEGIN
            // Il y'en aura au moins 1, on crée le noeud <COMPTES>
            bHasCpt := True;
            tsl.add('<COMPTES>');
          END;

          WHILE (iPos <> -1) AND (tslCpt.Count <> 0) DO
          BEGIN
            // Ajoute le noeud <COMPTE>
            // CODE;LIBELLE;LADATE;CREDIT;DEBIT;LETTRAGE;LETNUM
            tsl.add('<COMPTE>');
            AddValue(tsl, 'LIBELLE', tslChamps(tslCpt[iPos], 2));
            AddValue(tsl, 'DATE', tslChamps(tslCpt[iPos], 3));
            AddValue(tsl, 'CREDIT', StringReplace(tslChamps(tslCpt[iPos], 4), ',', '.', [rfReplaceAll]));
            AddValue(tsl, 'DEBIT', StringReplace(tslChamps(tslCpt[iPos], 5), ',', '.', [rfReplaceAll]));
            AddValue(tsl, 'LETTRAGE', tslChamps(tslCpt[iPos], 6));
            AddValue(tsl, 'LETNUM', tslChamps(tslCpt[iPos], 7));
            tsl.add('</COMPTE>');

            // Supprime la ligne du tsl, pour accelerer les recherches
            tslCpt.Delete(iPos);

            // Suivant
            iPos := chercheVal(tslCpt, 1, sCodeCli); // Trouve le code client
          END;

          // Fin de noeud
          IF bHasCpt THEN
            tsl.add('</COMPTES>');
        END;

        iPos := -1;
        // Gestion de la fid
        IF bFid THEN
        BEGIN // Fichier fidelité présent et chargé
          bHasFid := False;

          iPos := chercheVal(tslFid, 1, sCodeCli); // Trouve le code client
          IF iPos <> -1 THEN
          BEGIN
            // Il y'en aura au moins 1, on crée le noeud <FIDELITES>
            bHasFid := True;
            tsl.add('<FIDELITES>');
          END;

          WHILE (iPos <> -1) AND (tslFid.Count <> 0) DO
          BEGIN
            // Ajoute le noeud <fidelite>
            tsl.add('<FIDELITE>');
            AddValue(tsl, 'POINTS', tslChamps(tslFid[iPos], 2)); // points
            AddValue(tsl, 'DATE', tslChamps(tslFid[iPos], 3)); // date
            AddValue(tsl, 'FID_MANUELLE', tslChamps(tslFid[iPos], 4)); // fid_manuelle
            tsl.add('</FIDELITE>');

            // Supprime la ligne du tsl, pour accelerer les recherches
            tslFid.Delete(iPos);

            // Suivant
            iPos := chercheVal(tslFid, 1, sCodeCli); // Trouve le code client
          END;

          // Fin de noeud
          IF bHasFid THEN
            tsl.add('</FIDELITES>');
        END;

        // Fin du client
        tsl.add('</CLIENT>');
        // Passage au suivant
      END;
      tsl.add('</CLIENTS>');
      tsl.Savetofile(ed_rep.text + 'Clients.XML');
    FINALLY
      tsl.free;
      tslClt.free;
      tslCpt.Free;
      tslFid.Free;
    END;
    ImportClientXml(ed_rep.text + 'Clients.XML');
  END
  ELSE
  BEGIN
    application.messagebox('Aucun fichier Client , vérifier votre chemin d''importation', 'ATTENTION', Mb_OK);
  END;
END;

PROCEDURE TForm1.CltXMLClick(Sender: TObject);
BEGIN
  OdXml.InitialDir := ed_Rep.text;
  IF OdXml.execute THEN
    ImportClientXml(OdXml.Filename);
END;

PROCEDURE TForm1.ImportClientXml(Xml: STRING);
VAR
  leXml: TmonXML;
  Clt: TIcXMLElement;
  fids: TIcXMLElement;
  fid: TIcXMLElement;
  Comptes: TIcXMLElement;
  S: STRING;
  cltid: STRING;
  civid: STRING;
  chrono: STRING;
  ADRID: STRING;

  // FC
  sDebit, sCredit: STRING;

  NbClient: Integer;
  ChrDeb, ChrFin: STRING;

  tsl: tstringlist;
  cbiid: STRING;

  MAGID: STRING;
  CTEID: STRING;

  LesPoints: STRING;
  Ladate: STRING;
  fidid: STRING;

  fidmanuelle: STRING;
  LeMagidRef: STRING;
  premd, dernd: STRING;

  clt_fid: STRING;
  SC, CLAID, CITID, ICLI1, ICLI2, ICLI3, ICLI4, ICLI5: STRING;
  NbC : Integer;
BEGIN
  IF trim(ed_Base.text) = '' THEN
    Application.messagebox('Pas de base, importation terminée', ' Fin ', mb_ok)
  ELSE IF NOT fileexists(ed_Base.text) THEN
    Application.messagebox('La base n''existe pas , importation terminée', ' Fin ', mb_ok)
  ELSE
  BEGIN
    nbclient := 0;
    TRY
      Base.close;
      Base.DatabaseName := ed_base.text;
      Base.Open;
      tran_lect.active := true;
      // choisir le magasin d'importation
      qry.close;
      qry.sql.text := 'select MAG_ID, MAG_NOM from genmagasin join k on (k_id=mag_id and k_enabled=1) where mag_id<>0';
      qry.Open;
      application.createform(Tfrm_ChxMag, frm_ChxMag);
      frm_ChxMag.Lb_Mag.items.AddObject(' Tous les mags', pointer(0));
      WHILE NOT qry.Eof DO
      BEGIN
        frm_ChxMag.Lb_Mag.items.AddObject(Qry.fields[1].AsString, pointer(Qry.fields[0].asInteger));
        qry.Next;
      END;
      qry.close;
      frm_ChxMag.caption := ' Choix du magasin d''affectation des clients, comptes et fidélité ';
      frm_ChxMag.Lb_Mag.ItemIndex := 0;
      frm_ChxMag.ShowModal;
      MagId := Inttostr(Integer(frm_ChxMag.Lb_Mag.items.Objects[frm_ChxMag.Lb_Mag.ItemIndex]));
      IF frm_ChxMag.Lb_Mag.ItemIndex = 0 THEN
        LeMagidRef := Inttostr(Integer(frm_ChxMag.Lb_Mag.items.Objects[1]))
      ELSE
        LeMagidRef := MagId;
      frm_ChxMag.release;
      Tran_ecr.active := true;
      leXml := TmonXML.create;
      leXml.LoadFromFile(XML);
      NbClient := 0;
      ChrDeb := '';
      ChrFin := '';

      pb.min := 0;
      pb.max := LeXml.find('/CLIENTS', false).GetNodeList.Length;
      Clt := LeXml.find('/CLIENTS/CLIENT');
      WHILE clt <> NIL DO
      BEGIN
        pb.position := pb.position + 1;
        update;
        S := LeXml.ValueTag(clt, 'TYPE');
        qry.close;
        qry.Sql.text := 'SELECT ID FROM PR_NEWK (''CLTCLIENT'')';
        qry.open;
        Cltid := qry.fields[0].AsString;
        qry.close;

        // Sandrine : 2009/10/18 Si le Chrono existe, voir pour le reprendre s'il est inexistant
        //                       dans la base de destination
        Chrono := trim(lexml.ValueTag(clt, 'CHRONO'));
        IF (Chrono <> '') THEN
        BEGIN
          qry.Sql.text := 'Select Count(*) From CltClient Where Clt_Numero = '+quotedstr(Chrono);
          qry.open;
          nbC :=qry.fields[0].AsInteger;
          if (nbC<>0) then // Chrono pas libre le re-initialiser
            Chrono:='';
        END;
        // S'il n'y a pas de chrono, il faut en générer un !
        if (Chrono='') then
        BEGIN
          qry.Sql.text := 'Select NEWNUM FROM CLIENT_CHRONO';
          qry.open;
          chrono := qry.fields[0].AsString;
        END;
        IF ChrDeb = '' THEN
            ChrDeb := chrono;
          ChrFin := chrono;

        ADRID := ImportAdr(lexml.findtag(clt, 'ADRESSE'));
        premd := trim(lexml.ValueTag(clt, 'PREM_PASS'));
        dernd := trim(lexml.ValueTag(clt, 'DERN_PASS'));
        clt_fid := lexml.ValueTag(clt, 'CLT_FIDELITE');
        IF trim(clt_fid) = '' THEN clt_fid := '0';
        IF premd = '' THEN
          premd := 'current_date'
        ELSE
          premd := quotedstr(datefr_enus(premd));
        IF dernd = '' THEN
          dernd := 'current_date'
        ELSE
          dernd := quotedstr(datefr_enus(dernd));
        IF S <> 'PRO' THEN
        BEGIN // Client PARTICULIER
          S := lexml.ValueTag(clt, 'CIV');
          IF s = '' THEN
            CIVID := '0'
          ELSE
          BEGIN
            qry.close;
            qry.Sql.text := 'Select CIV_ID FROM GENCIVILITE join k on (k_id=CIV_ID and k_enabled=1) where UPPER(CIV_NOM)= ' + QuotedStr(UPPERCASE(S));
            qry.open;
            IF qry.isEmpty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''GENCIVILITE'')';
              qry.open;
              CIVID := qry.Fields[0].AsString;
              Sql.Sql.text := 'INSERT INTO GENCIVILITE (CIV_ID,CIV_NOM,CIV_SEXE) VALUES (' +
                CIVID + ',' + Quotedstr(UPPERCASE(S)) + ',0)';
              Sql.ExecQuery;
            END
            ELSE
              CIVID := qry.Fields[0].AsString;
          END;

          // Gestion des Classements Client PARTICULIER
          SC := lexml.ValueTag(clt, 'CLASS1');
          IF SC = '' THEN
            ICLI1 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''CLT'' and cla_num=1';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI1 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI1 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI1 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI1 := qry.fields[0].AsString;
          END;

          SC := lexml.ValueTag(clt, 'CLASS2');
          IF SC = '' THEN
            ICLI2 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''CLT'' and cla_num=2';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI2 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI2 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI2 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI2 := qry.fields[0].AsString;
          END;

          SC := lexml.ValueTag(clt, 'CLASS3');
          IF SC = '' THEN
            ICLI3 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''CLT'' and cla_num=3';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI3 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI3 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI3 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI3 := qry.fields[0].AsString;
          END;

          SC := lexml.ValueTag(clt, 'CLASS4');
          IF SC = '' THEN
            ICLI4 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''CLT'' and cla_num=4';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI4 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI4 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI4 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI4 := qry.fields[0].AsString;
          END;

          SC := lexml.ValueTag(clt, 'CLASS5');
          IF SC = '' THEN
            ICLI5 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''CLT'' and cla_num=5';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI5 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI5 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI5 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI5 := qry.fields[0].AsString;
          END;

          Sql.Sql.text := 'INSERT INTO CLTCLIENT (' +
            'CLT_ID, CLT_GCLID, CLT_NUMERO, CLT_NOM, CLT_PRENOM,' +
            'CLT_CIVID, CLT_ADRID, CLT_NAISSANCE, CLT_TYPE, CLT_CLTID,' +
            'CLT_COMPTA, CLT_BL, CLT_FIDELITE, CLT_COMMENT, CLT_TELEPHONE,' +
            'CLT_TELTRAVAIL_FAX, CLT_TELPORTABLE, CLT_EMAIL, CLT_PREMIERPASS, CLT_DERNIERPASS,' +
            'CLT_ECAUTORISE, CLT_CPTBLOQUE, CLT_AFADRID, CLT_AFTELEPHONE, CLT_AFFAX,' +
            'CLT_AFEMAIL, CLT_AFAUTRE, CLT_RETRAIT, CLT_MRGID, CLT_CPAID,' +
            'CLT_RIBBANQUE, CLT_RIBGUICHET, CLT_RIBCOMPTE, CLT_RIBCLE, CLT_RIBDOMICILIATION,' +
            'CLT_CODETVA, CLT_ICLID1, CLT_ICLID2, CLT_ICLID3, CLT_ICLID4,' +
            'CLT_ICLID5, CLT_NUMFACTOR, CLT_DATECF, CLT_ADRLIV, CLT_MAGID,' +
            'CLT_ARCHIVE, CLT_RESID, CLT_STAADRID, CLT_ORGID, CLT_NUMCB,' +
            'CLT_NBJLOC, CLT_CLIPROLOCATION, CLT_TOFACTURATION,CLT_LOCREMISE,CLT_VTEREMISE,' +
            'CLT_TOCLTID, CLT_IDTHEO,CLT_TOSUPPLEMENT,CLT_NMODIF,CLT_DUREEVO,' +
            'CLT_DUREEVODATE, CLT_VTEREMISEPRO, CLT_MDP, CLT_DEBUTSEJOURVO, CLT_REFDYNA' +
            ') Values (' +
            cltid + ',0,' + quotedstr(chrono) + ',' + quotedstr(UPPERCASE(lexml.ValueTag(clt, 'NOM'))) + ',' + quotedstr(UPPERCASE(lexml.ValueTag(clt, 'PRENOM'))) + ',' +
            CIVID + ',' + adrid + ',NULL,0,0,' +
            QuotedStr(lexml.ValueTag(clt, 'CODE_CPT')) + ',0,' + clt_fid + ','''','''',' +
            ''''','''',' + quotedstr(lexml.ValueTag(clt, 'CODE')) + ',' + premd + ',' + dernd + ',' +
            '0,0,0,'''','''',' +
            ''''','''','''',0,0,' +
            '0,0,'''',0,'''',' +
            ''''',' + ICLI1 + ',' + ICLI2 + ',' + ICLI3 + ',' + ICLI4 + ',' +
            ICLI5 + ','''',NULL,0,' + magid + ',' +
            '0,0,0,0,'''',' +
            '0,0,0,0,0,' +
            '0,0,0,0,0,' +
            'NULL,0,'''',NULL,0)';
          Sql.ExecQuery;

          IBST_CB.Prepare;
          IBST_CB.ExecProc;
          S := IBST_CB.Parambyname('NEWNUM').AsString;
          IBST_CB.UnPrepare;
          qry.close;
          qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
          qry.open;
          cbiid := qry.fields[0].AsString;
          sql.sql.text := 'INSERT INTO ARTCODEBARRE (' +
            'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
            'CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC' +
            ') values (' +
            CBIID + ',0,0,0,' + QuotedStr(s) + ',' +
            '2,' + cltid + ',0,0)';
          sql.ExecQuery;

        END
        ELSE
        BEGIN
          // Gestion des Classements Client PRO
          SC := lexml.ValueTag(clt, 'CLASS1');
          IF SC = '' THEN
            ICLI1 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''PRO'' and cla_num=1';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI1 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI1 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI1 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI1 := qry.fields[0].AsString;
          END;

          SC := lexml.ValueTag(clt, 'CLASS2');
          IF SC = '' THEN
            ICLI2 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''PRO'' and cla_num=2';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI2 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI2 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI2 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI2 := qry.fields[0].AsString;
          END;

          SC := lexml.ValueTag(clt, 'CLASS3');
          IF SC = '' THEN
            ICLI3 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''PRO'' and cla_num=3';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI3 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI3 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI3 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI3 := qry.fields[0].AsString;
          END;

          SC := lexml.ValueTag(clt, 'CLASS4');
          IF SC = '' THEN
            ICLI4 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''PRO'' and cla_num=4';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI4 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI4 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI4 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI4 := qry.fields[0].AsString;
          END;

          SC := lexml.ValueTag(clt, 'CLASS5');
          IF SC = '' THEN
            ICLI5 := '0'
          ELSE
          BEGIN
            qry.close;
            qry.sql.text := 'select cla_id from artclassement join k on (k_id=cla_id and k_enabled=1) where cla_type=''PRO'' and cla_num=5';
            qry.Open;
            CLAID := qry.fields[0].AsString;
            qry.close;
            qry.sql.text := 'select ICL_id from ARTCLAITEM join k on (k_id=cit_id and k_enabled=1) ' +
              ' join ARTITEMC on (ICL_ID=CIT_ICLID)  join k on (k_id=ICL_id and k_enabled=1) ' +
              'WHERE CIT_CLAID=' + CLAID +
              ' and ICL_NOM = ' + quotedstr(SC);
            qry.Open;
            IF qry.isempty THEN
            BEGIN
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTITEMC'')';
              qry.open;
              ICLI5 := qry.fields[0].AsString;
              sql.sql.text := 'Insert into ARTITEMC (ICL_ID,ICL_NOM) ' +
                ' Values (' + ICLI5 + ',' + QuotedStr(SC) + ')';
              sql.ExecQuery;
              qry.close;
              qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCLAITEM'')';
              qry.open;
              CITID := qry.fields[0].AsString;
              qry.close;
              sql.sql.text := 'Insert into ARTCLAITEM (CIT_ID,CIT_CLAID,CIT_ICLID) ' +
                ' values (' + CITID + ',' + CLAID + ',' + ICLI5 + ')';
              sql.ExecQuery;
            END
            ELSE
              ICLI5 := qry.fields[0].AsString;
          END;
          Sql.Sql.text := 'INSERT INTO CLTCLIENT (' +
            'CLT_ID, CLT_GCLID, CLT_NUMERO, CLT_NOM, CLT_PRENOM,' +
            'CLT_CIVID, CLT_ADRID, CLT_NAISSANCE, CLT_TYPE, CLT_CLTID,' +
            'CLT_COMPTA, CLT_BL, CLT_FIDELITE, CLT_COMMENT, CLT_TELEPHONE,' +
            'CLT_TELTRAVAIL_FAX, CLT_TELPORTABLE, CLT_EMAIL, CLT_PREMIERPASS, CLT_DERNIERPASS,' +
            'CLT_ECAUTORISE, CLT_CPTBLOQUE, CLT_AFADRID, CLT_AFTELEPHONE, CLT_AFFAX,' +
            'CLT_AFEMAIL, CLT_AFAUTRE, CLT_RETRAIT, CLT_MRGID, CLT_CPAID,' +
            'CLT_RIBBANQUE, CLT_RIBGUICHET, CLT_RIBCOMPTE, CLT_RIBCLE, CLT_RIBDOMICILIATION,' +
            'CLT_CODETVA, CLT_ICLID1, CLT_ICLID2, CLT_ICLID3, CLT_ICLID4,' +
            'CLT_ICLID5, CLT_NUMFACTOR, CLT_DATECF, CLT_ADRLIV, CLT_MAGID,' +
            'CLT_ARCHIVE, CLT_RESID, CLT_STAADRID, CLT_ORGID, CLT_NUMCB,' +
            'CLT_NBJLOC, CLT_CLIPROLOCATION, CLT_TOFACTURATION,CLT_LOCREMISE,CLT_VTEREMISE,' +
            'CLT_TOCLTID, CLT_IDTHEO,CLT_TOSUPPLEMENT,CLT_NMODIF,CLT_DUREEVO,' +
            'CLT_DUREEVODATE, CLT_VTEREMISEPRO, CLT_MDP, CLT_DEBUTSEJOURVO, CLT_REFDYNA' +
            ') Values (' +
            cltid + ',0,' + quotedstr(chrono) + ',' + quotedstr(UPPERCASE(lexml.ValueTag(clt, 'RS1'))) + ',' + quotedstr(UPPERCASE(lexml.ValueTag(clt, 'RS2'))) + ',' +
            '0,' + adrid + ',NULL,1,0,' +
            QuotedStr(lexml.ValueTag(clt, 'CODE_CPT')) + ',0,' + clt_fid + ','''','''',' +
            ''''','''','''',' + premd + ',' + dernd + ',' +
            '0,0,0,'''','''',' +
            ''''','''','''',0,0,' +
            '0,0,'''',0,'''',' +
            ''''',' + ICLI1 + ',' + ICLI2 + ',' + ICLI3 + ',' + ICLI4 + ',' +
            ICLI5 + ','''',NULL,0,' + magid + ',' +
            '0,0,0,0,'''',' +
            '0,0,0,0,0,' +
            '0,0,0,0,0,' +
            'NULL,0,'''',NULL,0)';
          Sql.ExecQuery;
          IBST_CB.Prepare;
          IBST_CB.ExecProc;
          S := IBST_CB.Parambyname('NEWNUM').AsString;
          IBST_CB.UnPrepare;
          qry.close;
          qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
          qry.open;
          cbiid := qry.fields[0].AsString;
          sql.sql.text := 'INSERT INTO ARTCODEBARRE (' +
            'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
            'CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC' +
            ') values (' +
            CBIID + ',0,0,0,' + QuotedStr(s) + ',' +
            '2,' + cltid + ',0,0)';
          sql.ExecQuery;
        END;
        // Code Barre National
        IF (lexml.ValueTag(clt, 'CB_NATIONAL') <> '') THEN
        BEGIN
          qry.close;
          qry.Sql.text := 'SELECT ID FROM PR_NEWK (''ARTCODEBARRE'')';
          qry.open;
          cbiid := qry.fields[0].AsString;
          sql.sql.text := 'INSERT INTO ARTCODEBARRE (' +
            'CBI_ID,CBI_ARFID,CBI_TGFID,CBI_COUID,CBI_CB,' +
            'CBI_TYPE,CBI_CLTID,CBI_ARLID,CBI_LOC' +
            ') values (' +
            CBIID + ',0,0,0,' + QuotedStr(lexml.ValueTag(clt, 'CB_NATIONAL')) + ',' +
            '5,' + cltid + ',0,0)';
          sql.ExecQuery;
        END;

        Comptes := LeXml.FindTag(clt, 'COMPTES');
        IF Comptes <> NIL THEN
        BEGIN
          Comptes := LeXml.FindTag(Comptes, 'COMPTE');
          WHILE Comptes <> NIL DO
          BEGIN
            qry.close;
            qry.Sql.text := 'SELECT ID FROM PR_NEWK (''CLTCOMPTE'')';
            qry.open;
            CTEID := qry.fields[0].AsString;
            IF LeXml.ValueTag(comptes, 'DEBIT') <> '' THEN
              sDebit := QuotedStr(LeXml.ValueTag(comptes, 'DEBIT'))
            ELSE
              sDebit := '0';

            IF LeXml.ValueTag(comptes, 'CREDIT') <> '' THEN
              sCredit := QuotedStr(LeXml.ValueTag(comptes, 'CREDIT'))
            ELSE
              sCredit := '0';

            sql.sql.text := 'INSERT INTO CLTCOMPTE (' +
              'CTE_ID,CTE_CLTID,CTE_MAGID,CTE_LIBELLE,CTE_DATE,' +
              'CTE_DEBIT,CTE_CREDIT,CTE_REGLER,CTE_TKEID,CTE_TYP,' +
              'CTE_ORIGINE,CTE_FCEID,CTE_RVSID,CTE_LETTRAGE,' +
              'CTE_LETTRAGENUM,CTE_CTEID,CTE_DVEID)' +
              ' VALUES ' +
              '(' + cteid + ',' + cltid + ',' + MAGID + ',' + quotedstr(LeXml.ValueTag(comptes, 'LIBELLE')) + ',' + quotedstr(datefr_enus(LeXml.ValueTag(comptes, 'DATE'))) + ',' +
              sDebit + ',' + sCredit + ',''12/30/1899'',0,0,' +
              '0,0,0,' + LeXml.ValueTag(comptes, 'LETTRAGE') + ',' +
              quotedstr(LeXml.ValueTag(comptes, 'LETNUM')) + ',0,0)';
            sql.ExecQuery;
            Comptes := Comptes.NextSibling;
          END;
        END
        ELSE
        BEGIN
          S := trim(lexml.Valuetag(clt, 'COMPTE'));
          IF s <> '' THEN
          BEGIN
            qry.close;
            qry.Sql.text := 'SELECT ID FROM PR_NEWK (''CLTCOMPTE'')';
            qry.open;
            CTEID := qry.fields[0].AsString;
            IF strtofloat(s) > 0 THEN
              sql.sql.text := 'INSERT INTO CLTCOMPTE (' +
                'CTE_ID,CTE_CLTID,CTE_MAGID,CTE_LIBELLE,CTE_DATE,' +
                'CTE_DEBIT,CTE_CREDIT,CTE_REGLER,CTE_TKEID,CTE_TYP,' +
                'CTE_ORIGINE,CTE_FCEID,CTE_RVSID,CTE_LETTRAGE,' +
                'CTE_LETTRAGENUM,CTE_CTEID,CTE_DVEID)' +
                ' VALUES ' +
                '(' + cteid + ',' + cltid + ',' + MAGID + ',''Import'',current_date,' +
                '0,' + s + ',''12/30/1899'',0,0,' +
                '0,0,0,0,' +
                ''''',0,0)'
            ELSE
            BEGIN
              S := floattostr(-strtofloat(s));
              sql.sql.text := 'INSERT INTO CLTCOMPTE (' +
                'CTE_ID,CTE_CLTID,CTE_MAGID,CTE_LIBELLE,CTE_DATE,' +
                'CTE_DEBIT,CTE_CREDIT,CTE_REGLER,CTE_TKEID,CTE_TYP,' +
                'CTE_ORIGINE,CTE_FCEID,CTE_RVSID,CTE_LETTRAGE,' +
                'CTE_LETTRAGENUM,CTE_CTEID,CTE_DVEID)' +
                ' VALUES ' +
                '(' + cteid + ',' + cltid + ',' + MAGID + ',''Import'',current_date,' +
                s + ',0,''12/30/1899'',0,0,' +
                '0,0,0,0,' +
                ''''',0,0)';
            END;
            sql.ExecQuery;
          END;
        END;

        Fids := LeXml.FindTag(clt, 'FIDELITES');
        fid := LeXml.FindTag(Fids, 'FIDELITE');
        WHILE fid <> NIL DO
        BEGIN
          LesPoints := LeXml.ValueTag(fid, 'POINTS');
          Ladate := LeXml.ValueTag(fid, 'DATE');
          fidmanuelle := trim(LeXml.ValueTag(fid, 'FID_MANUELLE'));
          IF fidmanuelle = '' THEN
            fidmanuelle := '0';
          Ladate := copy(Ladate, 4, 2) + '/' + copy(Ladate, 1, 2) + '/' + copy(Ladate, 7, 4);
          qry.close;
          qry.Sql.text := 'SELECT ID FROM PR_NEWK (''CLTFIDELITE'')';
          qry.open;
          fidid := qry.fields[0].AsString;
          sql.sql.text := 'INSERT INTO CLTFIDELITE (' +
            'FID_ID,FID_TKEID,FID_POINT,FID_DATE,FID_MAGID,' +
            'FID_BACID,FID_CLTID,FID_MANUEL)' +
            ' VALUES (' +
            fidid + ',0,' + LesPoints + ',' + QuotedStr(LaDate) + ',' + LeMagidRef + ',' +
            '0,' + cltid + ',' + fidmanuelle + ')';
          sql.ExecQuery;
          fid := fid.NextSibling;
        END;
        inc(NbClient);
        IF sql.Transaction.InTransaction THEN
          sql.Transaction.commit;
        sql.Transaction.active := true;
        clt := clt.NextSibling;
      END;

      LeXML.Free;
    FINALLY
      tsl := tstringlist.Create;
      tsl.add('<HTML>');
      tsl.Add('<head>');
      tsl.Add('<title>' + 'Importation ' + Datetostr(Date) + '</title>');
      tsl.Add('</head>');
      tsl.Add('<body>');
      tsl.Add('<FONT SIZE="-2">');
      tsl.Add('Ce document est sauvegardé dans le répertoire de votre importation, il peut être imprimé par le menu fichier imprimer ou par la combinaison de touches CTRL-P<BR>');
      tsl.Add('</FONT>');
      tsl.Add('Importation des clients du ' + Datetostr(Date) + ' sur la base ' + ed_Base.text + '<BR>');
      tsl.add('<P>');
      IF NbClient = 0 THEN
        tsl.add('Aucun client intégré')
      ELSE IF NbClient = 1 THEN
      BEGIN
        tsl.add('1 client intégré sur le code chrono : ' + ChrDeb + '<BR>')
      END
      ELSE
      BEGIN
        tsl.add(Inttostr(NbClient) + ' clients intégrés sur les codes chrono de ' + ChrDeb + ' à ' + ChrFin + '<BR>');
      END;
      tsl.Add('</body>');
      tsl.add('</HTML>');
      S := IncludeTrailingBackslash(extractfilepath(XML)) + 'CLT_' + FormatDateTime('YYYY"-"MM"-"DD" "HH"H"NN', now) + '.HTML';
      tsl.savetofile(S);
      ShellExecute(Application.handle, 'open', Pchar(s), NIL, '', SW_SHOWDEFAULT);
      Application.messagebox('importation terminée, consultez le rapport.', ' Fin ', mb_ok);
    END;
  END;
  application.MessageBox('C''est fini', 'Fin', mb_ok);
END;

PROCEDURE TForm1.UpdateK(kid: STRING);
BEGIN
  sql.sql.text := 'Update K set k_version=gen_id(general_id,1), KRH_ID=gen_id(general_id,0),  ' +
    ' KSE_LOCK_ID=gen_id(general_id,0), KMA_LOCK_ID=gen_id(general_id,0)  ' +
    '  where k_id=' + kid;
  sql.ExecQuery;
END;

FUNCTION TForm1.datefr_enus(unedate: STRING): STRING;
BEGIN
  result := copy(unedate, 4, 2) + '/' + copy(unedate, 1, 2) + '/' + copy(unedate, 7, 4);
END;

PROCEDURE TForm1.Button8Click(Sender: TObject);

VAR
  iOCTID, iMagID: Integer;
  iOCLID, iOCDID: Integer;
  sNomOC, sPathFic: STRING;
  tsLog: TStrings;
  iARTId, iTGFID, iCOUID: Integer;
  fPxVte: double;
BEGIN
  MemD_TOC.DelimiterChar := ';';

  // Init du log
  initLogFileName(NIL, NIL);

  //
  sPathFic := IncludeTrailingBackslash(ed_Rep.Text) + 'PRIX_TOC.CSV';
  IF NOT (FileExists(sPathFic)) THEN
  BEGIN
    Showmessage('Fichier inexistant : ' + sPathFic + #13#10 + 'Impossible d''importer l''OC');
    EXIT;
  END;

  IF NOT (FileExists(ed_base.text)) THEN
  BEGIN
    Showmessage('Base inexistante : ' + ed_base.text + #13#10 + 'Impossible d''importer l''OC');
    EXIT;
  END;

  // Connection DB
  Base.close;
  tsLog := TStringList.Create;
  tsLog.Add('CBNonTrouvé;PV');
  TRY
    Base.DatabaseName := ed_base.text;
    Base.Open;
    IF NOT (Base.Connected) THEN
    BEGIN
      Showmessage('Connection base échouée : ' + ed_base.text + #13#10 + 'Impossible d''importer l''OC');
      EXIT;
    END;
    tran_lect.active := true;
    iMagID := GetMagasinID;
    tran_lect.active := true;
  EXCEPT
    // Erreur de connection à la base
    ON E: Exception DO
    BEGIN
      LogAction(E.Message);
      Showmessage('Connection base échouée : ' + ed_base.text + #13#10 + 'Impossible d''importer l''OC');
      EXIT;
    END;
  END;

  TRY
    // Création de l'OC
      // 1 -Récup de l'id
    Qry.SQL.Text := 'SELECT ID FROM PR_NEWK (''OCTETE'')';
    Qry.Open;
    Qry.First;
    iOCTID := Qry.FieldByName('ID').AsInteger;
    Qry.Close;
    IF iOCTID > 0 THEN
    BEGIN
      // ! si champ nom est vide
      IF ed_Toc.Text = '' THEN
        sNomOC := 'TOC'
      ELSE
        sNomOC := ed_Toc.Text;

      // 2 - Insert de l'OC (OCTETE)
      SQL.Close;
      SQL.SQL.Clear;
      SQL.SQL.Add('INSERT INTO OCTETE (OCT_ID, OCT_NOM, OCT_COMMENT, OCT_DEBUT, OCT_FIN, OCT_TYPID, OCT_WEB, OCT_CENTRALE) ');
      IF (Rgr_TypeOP.ItemIndex = 0) THEN // Permanent
        SQL.SQL.Add('VALUES (' + IntToStr(iOCTID) + ', ' + QuotedStr(sNomOc) + ', ''OC Importée le ''||current_date, ''01/01/1950'', ''01/01/2050'', 292, 0, 0)')
      ELSE SQL.SQL.Add('VALUES (' + IntToStr(iOCTID) + ', ' + QuotedStr(sNomOc) + ', ''OC Importée le ''||current_date, current_date, current_date, 296, 0, 0)');
      TRY
        SQL.ExecQuery();
        SQL.Close;
      EXCEPT
        ON E: Exception DO
        BEGIN
          // Erreur
          Showmessage('Insertion dans OCTETE impossible');
          LogAction('Insertion dans OCTETE impossible');
          LogAction(E.Message);
          EXIT;
        END;
      END;
      MemD_TOC.Close;
      MemD_TOC.LoadFromTextFile(sPathFic);
      MemD_Toc.First;
      // Parse du fichier
      WHILE NOT MemD_TOC.Eof DO
      BEGIN
        IF ((MemD_TOCCB.AsString <> '') AND (MemD_TOCCB.AsString <> 'Null') AND (MemD_TOCPV.AsString <> '0.00')) THEN
        BEGIN
          Qry.Close;
          Qry.SQL.Clear;
          Qry.SQL.Add('SELECT ARF_ARTID, CBI_TGFID, CBI_COUID,');
          Qry.SQL.Add('CAST(MAX ((SELECT R_PRIX FROM GETPRIXDEVENTE (' + IntToStr(iMagID) + ', ARTREFERENCE.ARF_ARTID, ARTCODEBARRE.CBI_TGFID))) AS NUMERIC(15,2)) AS PRIX');
          Qry.SQL.Add('FROM ARTCODEBARRE');
          Qry.SQL.Add('JOIN K ON (K_ID = CBI_ID AND K_ENABLED = 1)');
          Qry.SQL.Add('JOIN ARTREFERENCE ON (ARF_ID = CBI_ARFID)');
          IF (Rgr_TypeCB.ItemIndex = 1) THEN
            Qry.SQL.Add('WHERE CBI_CB = F_PADLEFT(' + QuotedStr(MemD_TOCCB.AsString) + ',''0'',6) AND CBI_TYPE = 3')
          ELSE
            Qry.SQL.Add('WHERE CBI_CB = ' + QuotedStr(MemD_TOCCB.AsString) + ' AND CBI_TYPE = 1');
          Qry.SQL.Add('GROUP BY ARF_ARTID, CBI_TGFID, CBI_COUID');

          Qry.Open;
          // -> récup du code et du tarif
          IF Qry.RecordCount = 0 THEN
          BEGIN
            // Code non trouvé, on log
            tsLog.Add(Format('%s ; %s', [MemD_TOCCB.AsString, MemD_TOCPV.AsString]));
            Qry.Close;
            Qry.SQL.Clear;
          END
          ELSE BEGIN
            // 1 - Création de la ligne si besoin
              // Stock les données
            Qry.First;
            iARTId := Qry.FieldByName('ARF_ARTID').AsInteger;
            iTGFId := Qry.FieldByName('CBI_TGFID').AsInteger;
            iCOUId := Qry.FieldByName('CBI_COUID').AsInteger;
            IF (Rgr_TypeOP.ItemIndex = 0) THEN // -> Récup du tarif max
              fPxVte := Qry.FieldByName('PRIX').AsFloat
            ELSE fPxVte := MemD_TOCPV.AsFloat;

            // -> détection si on a déjà l'article
            Qry.Close;
            Qry.SQL.Clear;
            Qry.SQL.Text := 'SELECT OCL_ID FROM OCLIGNES JOIN K ON (K_ID = OCL_ID AND K_ENABLED = 1) WHERE OCL_OCTID = :OCTID AND OCL_ARTID = :ARTID';
            Qry.ParamByName('OCTID').AsInteger := iOCTID;
            Qry.ParamByName('ARTID').AsInteger := iARTID;
            Qry.Open;
            IF Qry.RecordCount = 0 THEN
            BEGIN
              // -> Insertion dans OCLIGNES
              Qry.Close;
              Qry.SQL.Text := 'SELECT ID FROM PR_NEWK (''OCLIGNES'')';
              Qry.Open;
              Qry.First;
              iOCLID := Qry.FieldByName('ID').AsInteger;

              SQL.Close;
              SQL.SQL.Clear;
              SQL.SQL.Add('INSERT INTO OCLIGNES (OCL_ID, OCL_ARTID, OCL_PXVTE, OCL_OCTID) ');
              SQL.SQL.Add('VALUES (' + IntToStr(iOCLID) + ',' + IntToStr(iARTID) + ',' + FloatToStr(fPxVte) + ',' + IntToStr(iOCTID) + ')');
              SQL.ExecQuery;
              SQL.Close;
            END
            ELSE BEGIN
              // -> Recup du OCL_ID
              Qry.first;
              iOCLID := Qry.FieldByName('OCL_ID').AsInteger;
              Qry.Close;
              Qry.Close;
              Qry.SQL.Text := 'SELECT ID FROM PR_NEWK (''OCDETAIL'')';
              Qry.Open;
              Qry.First;
              iOCDID := Qry.FieldByName('ID').AsInteger;

              SQL.Close;

              // 2 - Création de la ligne de détail
                // -> Insertion dans OCDETAIL

              SQL.SQL.Clear;
              SQL.SQL.Add('INSERT INTO OCDETAIL (OCD_ID, OCD_OCLID, OCD_ARTID, OCD_TGFID, OCD_COUID, OCD_PRIX) ');
              SQL.SQL.Add(' VALUES (' + IntToStr(iOCDID) + ',' + IntToStr(iOCLID) + ',' + IntToStr(iARTID));
              SQL.SQL.Add(',' + IntToStr(iTGFID) + ',' + IntToStr(iCOUID) + ',' + FloatToStr(MemD_TOCPV.AsFloat) + ')');
              SQL.ExecQuery;
              SQL.Close
            END;
          END;
        END;
        MemD_Toc.Next;
      END;
    END;

  FINALLY
    // Déconnection
    Base.close;
    IF tsLog.Count > 1 THEN
      tsLog.SaveToFile(ed_Rep.Text + 'PRIX_TOC.Log');
    tsLog.Free;
    MessageDlg('Intégration de la TOC terminée', mtInformation, [mbOK], 0);
  END;

END;

FUNCTION TForm1.GetFilePath(AName: STRING; ANum: Integer): STRING;
BEGIN
  IF ANum = 0 THEN
    Result := ed_Rep.Text + AName + '.xml'
  ELSE
    Result := ed_Rep.Text + AName + IntToStr(ANum) + '.xml';
END;

FUNCTION TForm1.GetMagasinID: integer;
VAR
  MagId: integer;
BEGIN
  TRY
    qry.close;
    qry.SQL.Clear;
    qry.sql.text := 'select MAG_ID, MAG_NOM from genmagasin join k on (k_id=mag_id and k_enabled=1) where mag_id<>0';
    qry.Open;
    application.createform(Tfrm_ChxMag, frm_ChxMag);
    frm_ChxMag.Lb_Mag.items.AddObject(' Tous les mags', pointer(0));
    WHILE NOT qry.Eof DO
    BEGIN
      frm_ChxMag.Lb_Mag.items.AddObject(Qry.fields[1].AsString, pointer(Qry.fields[0].asInteger));
      qry.Next;
    END;
    qry.close;
    frm_ChxMag.caption := ' Choix du magasin d''affectation des clients, comptes et fidélité ';
    frm_ChxMag.Lb_Mag.ItemIndex := 0;
    frm_ChxMag.ShowModal;

    MagId := Integer(frm_ChxMag.Lb_Mag.items.Objects[frm_ChxMag.Lb_Mag.ItemIndex]);

    IF frm_ChxMag.Lb_Mag.ItemIndex = 0 THEN
      Result := Integer(frm_ChxMag.Lb_Mag.items.Objects[1])
    ELSE
      Result := MagId;

    frm_ChxMag.release;
    Tran_ecr.active := true;
  EXCEPT
    Result := 0
  END;

END;

END.


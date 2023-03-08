UNIT Unit1;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ExtCtrls, DBCtrls, Db, ADODB, Grids, DBGrids, LMDControl, LMDBaseControl,
    LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton, dxmdaset, stdutils, filectrl,
    BmDelay, LMDCustomComponent, LMDIniCtrl;

TYPE
    TForm1 = CLASS(TForm)
        ADOConnection1: TADOConnection;
        ADOQuery1: TADOQuery;
        FEDAS: TdxMemData;
        LMDSpeedButton4: TLMDSpeedButton;
        FEDASNumCategorie: TStringField;
        FEDASCategorie: TStringField;
        FEDASActivityCode: TStringField;
        FEDASNomActivite: TStringField;
        FEDASPMGCODE: TStringField;
        FEDASPMGNAME: TStringField;
        FEDASPSGCODE: TStringField;
        FEDASPSGNAME: TStringField;
        TfedasO: TADOTable;
        TfedasOFED_ID: TAutoIncField;
        TfedasOFED_NIV: TIntegerField;
        TfedasOFED_LIB: TStringField;
        TfedasOFED_NUM: TStringField;
        TfedasOFED_CATID: TIntegerField;
        TfedasOFED_IDPARENT: TIntegerField;
        TfedasOFED_IDACTIVITE: TIntegerField;
        Tfedas: TdxMemData;
        Tfedasfed_id: TIntegerField;
        Tfedasfed_niv: TIntegerField;
        Tfedasfed_lib: TStringField;
        Tfedasfed_num: TStringField;
        Tfedasfed_catid: TIntegerField;
        Tfedasfed_idparent: TIntegerField;
        Tfedasfed_idactivite: TIntegerField;
        LMDSpeedButton8: TLMDSpeedButton;
        Tcatal: TADOTable;
        MemD_GT: TdxMemData;
        MemD_GTITEMID: TStringField;
        MemD_GTGTFID: TIntegerField;
        MARQUE: TADOTable;
        MARQUEMRK_ID: TAutoIncField;
        MARQUEMRK_NOM: TStringField;
        que_fedas: TADOQuery;
        TcatalCAT_ID: TAutoIncField;
        TcatalCAT_NOM: TStringField;
        TcatalCAT_DATE: TDateTimeField;
        T: TADOStoredProc;
        ARTICLE: TADOStoredProc;
        COULEUR: TADOStoredProc;
        CL: TADOStoredProc;
        TL: TADOStoredProc;
        MemD_Tai: TdxMemData;
        MemD_Cou: TdxMemData;
        MemD_TaiLIBTAIL: TStringField;
        MemD_TaiTGF_ID: TIntegerField;
        MemD_CouCODE: TStringField;
        MemD_CouCOU_ID: TStringField;
        MemD_TaiLIBGT: TStringField;
        CB: TADOStoredProc;
        MemD_ART: TdxMemData;
        MemD_ARTITEMID: TStringField;
        MemD_ARTART_ID: TIntegerField;
        MemD_ARTGTITEMID: TStringField;
        MemD_CouITEMID: TStringField;
        MemD_Pbl: TdxMemData;
        MemD_PblITEMID: TStringField;
        MemD_PblIDRECHERCHE: TStringField;
        MemD_PblMOTIF: TStringField;
        INI: TLMDIniCtrl;
    LMDSpeedButton1: TLMDSpeedButton;
        PROCEDURE LMDSpeedButton4Click(Sender: TObject);
        PROCEDURE TfedasAfterInsert(DataSet: TDataSet);
        PROCEDURE LMDSpeedButton8Click(Sender: TObject);
        PROCEDURE FormActivate(Sender: TObject);
    procedure LMDSpeedButton1Click(Sender: TObject);
    PRIVATE
    { Déclarations privées }
        i: integer;
        repcat: STRING;
        PROCEDURE Integcatal;
        PROCEDURE Integration(catal: STRING);

    PUBLIC
    { Déclarations publiques }
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION
USES
    xml_unit, icxmlparser, Dlgstd_Frm, GaugeMess_Frm;

{$R *.DFM}

PROCEDURE TForm1.LMDSpeedButton4Click(Sender: TObject);
VAR num: STRING;
    n1, n2, n3, posi: integer;
    lg: STRING;
    tsl: tstringlist;
BEGIN
    tsl := tstringlist.create;
    i := 0;

    TRY
        //ADOConnection1.begintrans;
        screen.cursor := crsqlwait;
        fedas.DelimiterChar := ';';
        fedas.LoadFromTextFile(ExtractFilePath(application.ExeName) + 'RequeteGinkoia.csv');
        tfedas.open;
        fedas.first;
        WHILE NOT fedas.eof DO
        BEGIN
         //1er niveau
            IF NOT tfedas.locate('fed_niv;fed_num', vararrayOF([1, FEDASNumCategorie.asstring]), []) THEN
            BEGIN
                tfedas.insert;
                TfedasFED_NIV.asinteger := 1;
                TfedasFED_LIB.asstring := FEDASCategorie.asstring;
                TfedasFED_NUM.asstring := FEDASNumCategorie.asstring;
                TfedasFED_CATID.asinteger := 0;
                TfedasFED_IDPARENT.asinteger := 0;
                TfedasFED_IDACTIVITE.asinteger := 0;
                tfedas.post;
            END;
            n1 := TfedasFED_ID.asinteger;

        // 2ieme niveau
            num := conv(FEDASActivityCode.asstring, 2);
            IF NOT tfedas.locate('fed_niv;fed_num', vararrayOF([2, num]), []) THEN
            BEGIN
                tfedas.insert;
                TfedasFED_NIV.asinteger := 2;
                TfedasFED_LIB.asstring := FEDASNomActivite.asstring;
                TfedasFED_NUM.asstring := num;
                TfedasFED_CATID.asinteger := 0;
                TfedasFED_IDPARENT.asinteger := 0;
                TfedasFED_IDACTIVITE.asinteger := 0;
                tfedas.post;
            END;
            N2 := TfedasFED_ID.asinteger;

         //3ieme niveau
            num := conv(FEDASPMGCODE.asstring, 2);
            IF NOT tfedas.locate('fed_niv;fed_num;fed_idparent;fed_IDactivite', vararrayOF([3, num, n1, n2]), []) THEN
            BEGIN
                tfedas.insert;
                TfedasFED_NIV.asinteger := 3;
                TfedasFED_LIB.asstring := FEDASPMGNAME.asstring;
                TfedasFED_NUM.asstring := num;
                TfedasFED_CATID.asinteger := 0;
                TfedasFED_IDPARENT.asinteger := N1;
                TfedasFED_IDACTIVITE.asinteger := N2;
                tfedas.post;
            END;
            n3 := TfedasFED_ID.asinteger;

         //4ieme niveau
            num := FEDASPSGCODE.asstring;
            tfedas.insert;
            TfedasFED_NIV.asinteger := 4;
            TfedasFED_LIB.asstring := FEDASPSGNAME.asstring;
            TfedasFED_NUM.asstring := num;
            TfedasFED_CATID.asinteger := 0;
            TfedasFED_IDPARENT.asinteger := N3;
            TfedasFED_IDACTIVITE.asinteger := N2;
            tfedas.post;

            fedas.next;
        END;

    //Poubelle ou DIVERS CATMAN

        tfedas.insert;
        TfedasFED_NIV.asinteger := 1;
        TfedasFED_LIB.asstring := 'DIVERS CATMAN';
        TfedasFED_NUM.asstring := '9';
        TfedasFED_CATID.asinteger := 0;
        TfedasFED_IDPARENT.asinteger := 0;
        TfedasFED_IDACTIVITE.asinteger := 0;
        tfedas.post;
        n1 := TfedasFED_ID.asinteger;

        tfedas.insert;
        TfedasFED_NIV.asinteger := 2;
        TfedasFED_LIB.asstring := 'DIVERS CATMAN';
        TfedasFED_NUM.asstring := '99';
        TfedasFED_CATID.asinteger := 0;
        TfedasFED_IDPARENT.asinteger := 0;
        TfedasFED_IDACTIVITE.asinteger := 0;
        tfedas.post;
        n2 := TfedasFED_ID.asinteger;

        tfedas.insert;
        TfedasFED_NIV.asinteger := 3;
        TfedasFED_LIB.asstring := 'DIVERS CATMAN';
        TfedasFED_NUM.asstring := '99';
        TfedasFED_CATID.asinteger := 0;
        TfedasFED_IDPARENT.asinteger := n1;
        TfedasFED_IDACTIVITE.asinteger := n2;
        tfedas.post;
        n3 := TfedasFED_ID.asinteger;

        tfedas.insert;
        TfedasFED_NIV.asinteger := 4;
        TfedasFED_LIB.asstring := 'DIVERS CATMAN';
        TfedasFED_NUM.asstring := '9';
        TfedasFED_CATID.asinteger := 0;
        TfedasFED_IDPARENT.asinteger := n3;
        TfedasFED_IDACTIVITE.asinteger := n2;
        tfedas.post;

        tfedas.first;
        WHILE NOT tfedas.eof DO
        BEGIN
            lg := Tfedasfed_lib.asstring;
            posi := pos(#39, lg);
            IF posi <> 0 THEN
                delete(lg, posi, 1);

            tsl.add('insert into fedas values(' +
                Tfedasfed_id.asstring + ',' +
                Tfedasfed_niv.asstring + ',' +
                #39 + lg + #39 + ',' +
                #39 + Tfedasfed_num.asstring + #39 + ',' +
                '0,' +
                Tfedasfed_idparent.asstring + ',' +
                Tfedasfed_idactivite.asstring + ');');
            tfedas.next;
        END;
        DeleteFile(ExtractFilePath(application.ExeName) + 'ScriptFedas.txt');
        tsl.SaveToFile(ExtractFilePath(application.ExeName) + 'ScriptFedas.txt');
       // ADOConnection1.committrans;

        MessageDlg('Fedas terminé', mtWarning, [], 0);
        screen.cursor := crdefault;

    EXCEPT
        //ADOConnection1.rollbacktrans;
        MessageDlg('Erreur', mtWarning, [], 0);
        screen.cursor := crdefault;
    END;

END;

PROCEDURE TForm1.TfedasAfterInsert(DataSet: TDataSet);
BEGIN
    i := i + 1;
    Tfedasfed_id.asinteger := i;
END;

PROCEDURE Tform1.IntegCatal;
VAR Catal: STRING;
    fichier: TSearchRec;
BEGIN

    IF NOT DirectoryExists(repcat + 'INTEGRE') THEN
        CreateDir(repcat + 'INTEGRE');
    CreateDir(repcat + 'PROBLEME');

    IF FindFirst(repcat + 'ART_*.xml', faAnyFile, Fichier) = 0 THEN
    BEGIN
        Catal := fichier.name;
        delete(catal, 1, 4);

        //Test si catal déja intégré.
        Tcatal.open;
        IF Tcatal.locate('CAT_NOM', catal, []) THEN
        BEGIN //Attention déjà intégré Question préalable

            IF OuiNonHP('Le catalogue ' + fichier.name + ' a déjà été intégré.' + #10 + #13 +
                'Souhaitez vous l''intégrer à nouveaux?', false, false, 0, 0) THEN
            BEGIN
                Integration(catal);
            END
            ELSE
            BEGIN //Annulation de l'intégration
                deletefile(repcat + 'ART_' + catal);
                deletefile(repcat + 'BAR_' + catal);
                deletefile(repcat + 'TAI_' + catal);
                deletefile(repcat + 'FOU_' + catal);
            END;
        END
        ELSE
            Integration(catal);

        Tcatal.close;

        WHILE FindNext(fichier) = 0 DO
        BEGIN
            catal := fichier.name;
            delete(catal, 1, 4);
            Tcatal.open;
            IF Tcatal.locate('CAT_nom', catal, []) THEN
            BEGIN //Attention déjà intégré Question préalable

                IF OuiNonHP('Le catalogue ' + fichier.name + ' a déjà été intégré.' + #10 + #13 +
                    'Souhaitez vous l''intégrer à nouveaux?', false, false, 0, 0) THEN
                BEGIN
                    Integration(catal);
                END
                ELSE
                BEGIN //Annulation de l'intégration
                    deletefile(repcat + 'ART_' + catal);
                    deletefile(repcat + 'BAR_' + catal);
                    deletefile(repcat + 'TAI_' + catal);
                    deletefile(repcat + 'FOU_' + catal);
                END;
            END
            ELSE
                Integration(catal);
            tcatal.close;

        END;
    END;
    findclose(fichier);
END;

PROCEDURE Tform1.Integration(catal: STRING);
VAR
    Xml: TmonXML;
    passXML: TIcXMLElement;
    passXML2, passXML3, passXML4: TIcXMLElement;
    i: integer;
    tai, itemid: STRING;
    Nb: integer;
    libmarque, cdfedas, nom: STRING;
    flag: boolean;
    y, m, d, H, Mn, S, MS: word;

BEGIN
    screen.cursor := crsqlwait;
    ADOConnection1.begintrans;
    TRY

        tcatal.insert;
        tcatal.fieldbyname('CAT_NOM').asstring := catal;
        tcatal.fieldbyname('CAT_DATE').asdatetime := now;
        Tcatal.post;

        //----------------------
        //Les grilles de tailles
        //----------------------
        memd_gt.open;
        memd_tai.open;

        Xml := TmonXML.Create; // création de l'objet TMonXML
        xml.LoadFromFile(repcat + 'TAI_' + catal); // chargement du fichier

        passXML := Xml.find('TAILLE.XML'); // sélection du premier nœud
        passXML2 := xml.FindTag(passxml, 'ITEM');

        //1er passage combien?
        nb := 0;
        WHILE (passXML2 <> NIL) DO
        BEGIN
            nb := nb + 1;
            passXML2 := passXML2.NextSibling;
        END;
        InitGaugeMessHP('Traitement des grilles de taille (' + inttostr(nb) + ')', nb, false, 0, 0);

        //2ieme passage
        passXML2 := xml.FindTag(passxml, 'ITEM');
        WHILE (passXML2 <> NIL) DO
        BEGIN
            IncGaugeMessHP(0);
            //Entete de la Grille

            itemid := xml.valuetag(passxml2, 'ITEMID');

            T.parameters.parambyname('@gtf_nom').value := ItemID;
            T.parameters.parambyname('@gtf_fedid').value := 0;
            T.parameters.parambyname('@gtf_idref').value := 0;
            T.parameters.parambyname('@gtf_id').value := 0;
            T.Execproc;

            memd_gt.insert;
            MemD_GTITEMID.asstring := ItemID;
            MemD_GTGTFID.asinteger := T.parameters[3].value;
            memd_gt.post;

            //Ligne de GT
            FOR i := 1 TO 28 DO
            BEGIN
                tai := xml.valuetag(passxml2, 'T' + inttostr(i));
                IF tai <> '' THEN
                BEGIN

                    TL.parameters.parambyname('@TGF_GTFID').value := T.parameters[3].value;
                    TL.parameters.parambyname('@TGF_NOM').value := tai;
                    TL.parameters.parambyname('@TGF_ORDREAFF').value := i * 100;
                    TL.parameters.parambyname('@TGF_IDREF').value := 0;
                    TL.parameters.parambyname('@TGF_id').value := 0;
                    TL.Execproc;

                    memd_tai.insert;
                    MemD_TaiLIBGT.asstring := ItemID;
                    MemD_TaiLIBTAIL.asstring := tai;
                    MemD_TaiTGF_ID.asinteger := tl.parameters[4].value;
                    memd_tai.post;
                END;
            END;

            passXML2 := passXML2.NextSibling;
        END;
        CloseGaugeMessHP;
        xml.free;

        //----------------------
        //Les articles
        //----------------------
        Xml := TmonXML.Create; // création de l'objet TMonXML
        xml.LoadFromFile(repcat + 'ART_' + catal); // chargement du fichier

        marque.open;
        memd_art.open;
        memd_cou.open;
        memd_pbl.open;

        passXML := Xml.find('ARTICLE.XML'); // sélection du premier nœud

        //1er passage combien?
        passXML2 := xml.FindTag(passxml, 'ITEM');
        nb := 0;
        WHILE (passXML2 <> NIL) DO
        BEGIN
            nb := nb + 1;
            passXML2 := passXML2.NextSibling;
        END;
        InitGaugeMessHP('Traitement des articles (' + inttostr(nb) + ')', nb, false, 0, 0);

        passXML2 := xml.FindTag(passxml, 'ITEM');
        WHILE (passXML2 <> NIL) DO
        BEGIN
            IncGaugeMessHP(0);

            IF memd_gt.locate('itemid', xml.valuetag(passxml2, 'CTAI'), []) THEN
            BEGIN
                article.parameters.parambyname('@art_nom').value := xml.valuetag(passxml2, 'LIBELLE');
                article.parameters.parambyname('@art_description').value := '';

                article.parameters.parambyname('@art_GTFID').value := MemD_GTGTFID.asinteger;

                article.parameters.parambyname('@ART_REFMRK').value := xml.valuetag(passxml2, 'RFOU');

                libmarque := xml.valuetag(passxml2, 'MARQUE');
                libmarque := uppercase(libmarque);
                IF NOT marque.locate('mrk_nom', libmarque, []) THEN
                BEGIN
                    marque.insert;
                    MARQUEMRK_NOM.asstring := (libmarque);
                    marque.post;
                END;

                article.parameters.parambyname('@art_MRKID').value := MARQUEMRK_ID.asinteger;

            //Fedas
                cdfedas := xml.valuetag(passxml2, 'FEDAS');
                que_fedas.close;
                que_fedas.sql.clear;
                que_fedas.sql.text := 'exec idfedas @code=' + cdfedas;
                que_fedas.open;

                article.parameters.parambyname('@art_FEDID1').value := que_fedas.fields[0].asinteger;
                article.parameters.parambyname('@art_FEDID2').value := que_fedas.fields[2].asinteger;
                article.parameters.parambyname('@art_FEDID3').value := que_fedas.fields[4].asinteger;
                article.parameters.parambyname('@art_FEDID4').value := que_fedas.fields[6].asinteger;

                que_fedas.close;
            //Fin fedas

                article.parameters.parambyname('@ART_PA').value := strtofloat(xml.valuetag(passxml2, 'PA')) / 100;
                article.parameters.parambyname('@ART_PV').value := strtofloat(xml.valuetag(passxml2, 'PV')) / 100;
                article.parameters.parambyname('@ART_REASSORT').value := 0;
                article.parameters.parambyname('@ART_ARCHIVER').value := 0;
                article.parameters.parambyname('@ART_CATMAN').value := strtoint(xml.valuetag(passxml2, 'CATMAN'));
                article.parameters.parambyname('@art_id').value := 0;
                article.Execproc;

                memd_art.insert;
                MemD_ARTITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
                MemD_ARTART_ID.asinteger := article.parameters[14].value;
                MemD_ARTGTITEMID.asstring := xml.valuetag(passxml2, 'CTAI');
                memd_art.post;

            //Couleurs
                passXML3 := xml.FindTag(passxml2, 'COULEURS');
                IF passXML3 <> NIL THEN
                BEGIN
                    passXML4 := xml.FindTag(passxml3, 'COULEUR');
                    WHILE (passXML4 <> NIL) DO
                    BEGIN

                        COULEUR.parameters.parambyname('@COU_ARTID').value := article.parameters[14].value;
                        COULEUR.parameters.parambyname('@COU_CODE').value := xml.valueTag(passxml4, 'CODECOLORIS');
                        COULEUR.parameters.parambyname('@COU_NOM').value := xml.valueTag(passxml4, 'DESCRIPTIF');
                        COULEUR.parameters.parambyname('@COU_id').value := 0;
                        couleur.Execproc;

                        memd_cou.insert;
                        MemD_CouCODE.asstring := xml.valueTag(passxml4, 'CODECOLORIS');
                        MemD_CouCOU_ID.asinteger := couleur.parameters[3].value;
                        MemD_CouITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
                        memd_cou.post;
                        passXML4 := passXML4.NextSibling;
                    END;
                END;

                cl.parameters.parambyname('@CAL_CATID').value := TcatalCAT_ID.asinteger;
                cl.parameters.parambyname('@CAL_ARTID').value := article.parameters[14].value;
                cl.Execproc;
            END
            ELSE
            BEGIN //Article rejeté
                memd_pbl.insert;
                MemD_PblITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
                MemD_PblMOTIF.asstring := 'ARTICLE : GRILLE TAILLE NON TROUVEE';
                MemD_PblIDRECHERCHE.asstring := xml.valuetag(passxml2, 'CTAI');
                memd_pbl.post;

            END;
            passXML2 := passXML2.NextSibling;
        END;
        xml.free;
        CloseGaugeMessHP;

        //----------------------
        //Les Code barre
        //----------------------
        Xml := TmonXML.Create; // création de l'objet TMonXML
        xml.LoadFromFile(repcat + 'BAR_' + catal); // chargement du fichier
        passXML := Xml.find('BARFOU.XML'); // sélection du premier nœud

        //1er passage combien?
        passXML2 := xml.FindTag(passxml, 'ITEM');
        nb := 0;
        WHILE (passXML2 <> NIL) DO
        BEGIN
            nb := nb + 1;
            passXML2 := passXML2.NextSibling;
        END;
        InitGaugeMessHP('Traitement des codes barres (' + inttostr(nb) + ')', nb, false, 0, 0);

        passXML2 := xml.FindTag(passxml, 'ITEM');
        WHILE (passXML2 <> NIL) DO
        BEGIN
            IncGaugeMessHP(0);
            Flag := true;
            //Recherche article
            IF NOT memd_art.locate('ITEMID', xml.valuetag(passxml2, 'ARTICLEID'), []) THEN
            BEGIN
                memd_pbl.insert;
                MemD_PblITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
                MemD_PblMOTIF.asstring := 'CB : ARTICLE NON TROUVE';
                MemD_PblIDRECHERCHE.asstring := xml.valuetag(passxml2, 'CTAI');
                memd_pbl.post;
                flag := false;
            END;
            IF NOT memd_cou.locate('ITEMID;CODE', vararrayOF([MemD_ARTITEMID.asstring, xml.valuetag(passxml2, 'CODECOLORIS')]), []) THEN
            BEGIN
                memd_pbl.insert;
                MemD_PblITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
                MemD_PblMOTIF.asstring := 'CB : ARTICLE / COULEUR NON TROUVE';
                MemD_PblIDRECHERCHE.asstring := MemD_ARTITEMID.asstring + ' / ' + xml.valuetag(passxml2, 'CODECOLORIS');
                memd_pbl.post;
                flag := false;
            END;
            IF NOT memd_tai.locate('LIBGT;LIBTAIL', vararrayOF([MemD_ARTGTITEMID.asstring, xml.valuetag(passxml2, 'LTAI')]), []) THEN
            BEGIN
                memd_pbl.insert;
                MemD_PblITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
                MemD_PblMOTIF.asstring := 'CB : GRILLE TAILLE / TAILLE NON TROUVE';
                MemD_PblIDRECHERCHE.asstring := MemD_ARTGTITEMID.asstring + ' / ' + xml.valuetag(passxml2, 'LTAI');
                memd_pbl.post;
                flag := false;
            END;
            IF flag THEN
            BEGIN
                cb.parameters.parambyname('@CBI_ARTID').value := MemD_ARTART_ID.asinteger;
                cb.parameters.parambyname('@CBI_COUID').value := MemD_CouCOU_ID.asinteger;
                cb.parameters.parambyname('@CBI_TGFID').value := MemD_TaiTGF_ID.asinteger;
                cb.parameters.parambyname('@CBI_CB').value := xml.valuetag(passxml2, 'BARRE');
                cb.Execproc;
            END;
            passXML2 := passXML2.NextSibling;
        END;
        xml.free;
        CloseGaugeMessHP;

        IF memd_pbl.recordcount <> 0 THEN
        BEGIN //Intégration avec PBL

            DecodeDate(now, Y, M, D);
            DecodeTime(Time, H, Mn, S, MS);
            Nom := inttostr(y) + inttostr(m) + inttostr(d) + ' ' + inttostr(H) + inttostr(Mn) + inttostr(S) + '.txt';

            memd_pbl.SaveToTextFile(repcat + 'PROBLEME\' + catal + ' ' + nom);
            InfoMessHP('Intégration du catalogue impossible.' + #10 + #13 +
                'Consultez le rapport : ' + nom , false, 0, 0);


            ADOConnection1.rollbacktrans;

            movefileex(pchar(repcat + 'ART_' + catal), pchar(repcat + 'integre\ART_' + catal), MOVEFILE_REPLACE_EXISTING);
            movefileex(pchar(repcat + 'BAR_' + catal), pchar(repcat + 'integre\BAR_' + catal), MOVEFILE_REPLACE_EXISTING);
            movefileex(pchar(repcat + 'TAI_' + catal), pchar(repcat + 'integre\TAI_' + catal), MOVEFILE_REPLACE_EXISTING);
            movefileex(pchar(repcat + 'FOU_' + catal), pchar(repcat + 'integre\FOU_' + catal), MOVEFILE_REPLACE_EXISTING);
        END
        ELSE
        BEGIN

            movefileex(pchar(repcat + 'ART_' + catal), pchar(repcat + 'integre\ART_' + catal), MOVEFILE_REPLACE_EXISTING);
            movefileex(pchar(repcat + 'BAR_' + catal), pchar(repcat + 'integre\BAR_' + catal), MOVEFILE_REPLACE_EXISTING);
            movefileex(pchar(repcat + 'TAI_' + catal), pchar(repcat + 'integre\TAI_' + catal), MOVEFILE_REPLACE_EXISTING);
            movefileex(pchar(repcat + 'FOU_' + catal), pchar(repcat + 'integre\FOU_' + catal), MOVEFILE_REPLACE_EXISTING);
            ADOConnection1.committrans;

        END

    EXCEPT
        ADOConnection1.rollbacktrans;
        MessageDlg('Erreur', mtWarning, [], 0);
    END;
    memd_gt.close;
    memd_tai.close;
    memd_art.close;
    screen.cursor := crdefault;
    article.close;
    marque.close;
    couleur.close;
    t.close;
    tl.close;
    memd_cou.close;
    memd_art.close;
    memd_pbl.close;

END;

PROCEDURE TForm1.LMDSpeedButton8Click(Sender: TObject);
BEGIN
    IntegCatal;
END;

PROCEDURE TForm1.FormActivate(Sender: TObject);
BEGIN

    ADOConnection1.open;
    IF NOT ADOConnection1.connected THEN
    BEGIN
        InfoMessHP('Problème de connection avec le serveur CATMAN,' + #10 + #13 +
            'Réessayez ultérieurement...', false, 0, 0);
        application.terminate;
    END;
    Repcat := INI.readString('REP', 'CATA', '');
    IF repcat = '' THEN
    BEGIN
        InfoMessHP('Répertoire des catalogues non renseigné dans .INI...', false, 0, 0);
        application.terminate;
    END;

END;

procedure TForm1.LMDSpeedButton1Click(Sender: TObject);
//dvar Xml: TmonXML;
// passXML: TIcXMLElement;
//begin
//Xml := TmonXML.Create; // créa
//     xml.AddNode('toto','tata',passxml);
//     xml.savetofile('c:\titi.xml')
//     xml.ad
//
//en;
var doc : TIcXMLDocument;
    test,item : TIcXMLElement;
    parser : TIcXMLParser;
begin
  parser := TIcXLMParser.Create(nil);			// create XMLParser component if it wasn't created at design-time

  doc := TIcXMLDocument.Create;				// create XMLDocument
  doc.AssignParser(parser);                   		// associate XMLDocument with XMLParser component
  test := doc.CreateElement('test');			// create element 'test'
  doc.SetDocumentElement(test);				// set element 'test' as root element of XMLDocument
  item := doc.CreateElement('item');			// create element 'item'
  test.AppendChild(item);     				// set element 'item' as child of 'test'
  item.SetAttribute('attribute','value');		// set attribute for element 'item'
  item.SetCharData(doc.CreateTextNode('sample text'));  // create character data and appends it to 'item'

  doc.Write('c:\file.xml');				// write XMLDocument to file

  doc.Free;
  parser.Free;
end;



END.


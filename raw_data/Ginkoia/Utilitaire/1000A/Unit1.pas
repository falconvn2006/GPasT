UNIT Unit1;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    DB,
    Grids,
    DBGrids,
    dxmdaset,
    StdCtrls,
    variants;

TYPE
    TForm1 = CLASS(TForm)
        Button1: TButton;
        ODI: TOpenDialog;
        MOrigine: TdxMemData;
        MOrigineCODE: TIntegerField;
        MOrigineNOM: TStringField;
        MOrigineREF: TStringField;
        MOrigineCB1: TStringField;
        MOrigineCB2: TStringField;
        MOrigineCB3: TStringField;
        MOrigineNG1: TStringField;
        MOriginePXA: TStringField;
        MOrigineTVA1: TStringField;
        MOrigineTVA2: TStringField;
        MOriginePXV: TStringField;
        MOrigineFAMILLE: TStringField;
        MOrigineRAYON: TStringField;
        MOrigineMARQUE: TStringField;
        MOrigineUC: TStringField;
        DBGrid1: TDBGrid;
        DataSource1: TDataSource;
        MemD_CB: TdxMemData;
        MemD_CBCode_Art: TStringField;
        MemD_CBTaille: TStringField;
        MemD_CBCouleur: TStringField;
        MemD_CBEAN: TStringField;
        MemD_CBQtte: TStringField;
        MemD_Px: TdxMemData;
        MemD_PxCode_art: TStringField;
        MemD_PxTaille: TStringField;
        MemD_PxPxCatalogue: TStringField;
        MemD_PxPx_achat: TStringField;
        MemD_PxPx_Vente: TStringField;
        MemD_PxCODE_FOU: TStringField;
        MemD_Art: TdxMemData;
        MemD_ArtCode: TStringField;
        MemD_ArtCode_Mrq: TStringField;
        MemD_ArtCode_GT: TStringField;
        MemD_ArtCode_Fourn: TStringField;
        MemD_ArtNom: TStringField;
        MemD_ArtDescription: TStringField;
        MemD_ArtRayon: TStringField;
        MemD_ArtFamille: TStringField;
        MemD_ArtSS_Fam: TStringField;
        MemD_ArtGenre: TStringField;
        MemD_ArtCLASS1: TStringField;
        MemD_ArtCLASS2: TStringField;
        MemD_ArtCLASS3: TStringField;
        MemD_ArtCLASS4: TStringField;
        MemD_ArtCLASS5: TStringField;
        MemD_ArtIDREF_SSFAM: TStringField;
        MemD_ArtCOUL1: TStringField;
        MemD_ArtCOUL2: TStringField;
        MemD_ArtCOUL3: TStringField;
        MemD_ArtCOUL4: TStringField;
        MemD_ArtCOUL5: TStringField;
        MemD_ArtCOUL6: TStringField;
        MemD_ArtCOUL7: TStringField;
        MemD_ArtCOUL8: TStringField;
        MemD_ArtCOUL9: TStringField;
        MemD_ArtCOUL10: TStringField;
        MemD_ArtCOUL11: TStringField;
        MemD_ArtCOUL12: TStringField;
        MemD_ArtCOUL13: TStringField;
        MemD_ArtCOUL14: TStringField;
        MemD_ArtCOUL15: TStringField;
        MemD_ArtCOUL16: TStringField;
        MemD_ArtCOUL17: TStringField;
        MemD_ArtCOUL18: TStringField;
        MemD_ArtCOUL19: TStringField;
        MemD_ArtCOUL20: TStringField;

        MemD_ArtFidelite: TStringField;
        MemD_ArtDC: TStringField;
        MemD_ArtCollection: TStringField;
        MemD_ArtComent1: TStringField;
        MemD_ArtComent2: TStringField;
        MemD_ArtTVA: TStringField;
    Memd_Fourn: TdxMemData;
    Memd_FournCODE: TStringField;
    Memd_FournNOM: TStringField;
    Memd_FournADR1: TStringField;
    Memd_FournADR2: TStringField;
    Memd_FournADR3: TStringField;
    Memd_FournCP: TStringField;
    Memd_FournVILLE: TStringField;
    Memd_FournPAYS: TStringField;
    Memd_FournTEL: TStringField;
    Memd_FournFAX: TStringField;
    Memd_FournPORTABLE: TStringField;
    Memd_FournEMAIL: TStringField;
    Memd_FournCOMMENTAIRE: TStringField;
    Memd_FournNUM_CLT: TStringField;
    Memd_FournCOND_PAIE: TStringField;
    Memd_FournNUM_COMPTA: TStringField;
    memd_marque: TdxMemData;
    memd_marqueCODE: TStringField;
    memd_marqueCODE_FOU: TStringField;
    memd_marqueNOM: TStringField;
        PROCEDURE Button1Click(Sender: TObject);
    PRIVATE
        { Déclarations privées }
    PUBLIC
        { Déclarations publiques }
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

{$R *.dfm}

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    i: integer;
    chemDest: STRING;
BEGIN
    i := 0;
    memd_cb.open;
    memd_px.open;
    memd_art.open;
    
    IF ODI.Execute THEN
    BEGIN
        morigine.DelimiterChar := ';';
        morigine.LoadFromTextFile(ODI.files[0]);
        chemDest := ExtractFilePath(ODI.files[0]);

        memd_fourn.DelimiterChar := ';';
        memd_fourn.LoadFromTextFile(chemDest+'fourn.csv');

        memd_marque.DelimiterChar := ';';
        memd_marque.LoadFromTextFile(chemDest+'marque.csv');




        //attribution d'un code et verif cb
        morigine.first;
        WHILE NOT morigine.eof DO
        BEGIN
            inc(i);
            morigine.edit;
            MOrigineCODE.asstring := inttostr(i);
            IF MOrigineCB1.asstring = MOrigineCB2.asstring THEN MOrigineCB2.asstring := '';
            IF MOrigineCB1.asstring = MOrigineCB3.asstring THEN MOrigineCB3.asstring := '';
            IF MOrigineCB2.asstring = MOrigineCB3.asstring THEN MOrigineCB3.asstring := '';
            morigine.post;

            //Creation  cb1
            IF MOrigineCB1.asstring <> '' THEN
            BEGIN
                memd_cb.insert;
                MemD_CBCode_Art.asstring := MOrigineCODE.asstring;
                MemD_CBTaille.asstring := 'Unitaille';
                MemD_CBCouleur.asstring := 'Unicouleur';
                MemD_CBEAN.asstring := MOrigineCB1.asstring;
                MemD_CBQtte.asstring := '0';
                memd_cb.post;
            END;

            //Creation  cb2
            IF MOrigineCB1.asstring <> '' THEN
            BEGIN
                memd_cb.insert;
                MemD_CBCode_Art.asstring := MOrigineCODE.asstring;
                MemD_CBTaille.asstring := 'Unitaille';
                MemD_CBCouleur.asstring := 'Unicouleur';
                MemD_CBEAN.asstring := MOrigineCB2.asstring;
                MemD_CBQtte.asstring := '0';
                memd_cb.post;
            END;

            //Creation  cb3
            IF MOrigineCB1.asstring <> '' THEN
            BEGIN
                memd_cb.insert;
                MemD_CBCode_Art.asstring := MOrigineCODE.asstring;
                MemD_CBTaille.asstring := 'Unitaille';
                MemD_CBCouleur.asstring := 'Unicouleur';
                MemD_CBEAN.asstring := MOrigineCB3.asstring;
                MemD_CBQtte.asstring := '0';
                memd_cb.post;
            END;

            //Création de Prix
            memd_px.insert;
            MemD_PxCode_art.asstring := MOrigineCODE.asstring;
            MemD_PxTaille.asstring := 'Unitaille';
            MemD_PxPxCatalogue.asstring := MOriginePXA.asstring;
            MemD_PxPx_achat.asstring := MOriginePXA.asstring;
            MemD_PxPx_Vente.asstring := MOriginePXV.asstring;
            MemD_PxCODE_FOU.asstring := MOrigineMARQUE.asstring;
            memd_px.post;


            //verif marque et fourn
            if not (memd_fourn.locate('CODE',MOrigineMARQUE.asstring,[])) then
            begin
              memd_fourn.Insert;
              Memd_FournCODE.asstring:= MOrigineMARQUE.asstring;
              Memd_FournNOM.asstring:= MOrigineMARQUE.asstring;
              Memd_fourn.Post;
            end;

            if not (memd_marque.locate('CODE',MOrigineMARQUE.asstring,[])) then
            begin
              memd_marque.Insert;
              Memd_marqueCODE.asstring:= MOrigineMARQUE.asstring;
              Memd_marqueCODE_FOU.asstring:= MOrigineMARQUE.asstring;
              Memd_marqueNOM.asstring:= MOrigineMARQUE.asstring;
              Memd_marque.Post;
            end;




            //article.csv
            memd_art.insert;
            MemD_ArtCode.asstring := MOrigineCODE.asstring;
            MemD_ArtCode_Mrq.asstring := MOrigineMARQUE.asstring;
            MemD_ArtCode_GT.asstring := '1';
            MemD_ArtCode_Fourn.asstring := MOrigineREF.asstring;
            MemD_ArtNom.asstring := MOrigineNOM.asstring;
            MemD_ArtDescription.asstring :='UC:'+MOrigineUC.asstring;
            MemD_ArtRayon.asstring := MOrigineRAYON.asstring;
            MemD_ArtFamille.asstring := MOrigineFAMILLE.asstring;
            MemD_ArtSS_Fam.asstring := 'NON GERE';
            MemD_ArtGenre.asstring := '';
            MemD_ArtCLASS1.asstring := '';
            MemD_ArtCLASS2.asstring := '';
            MemD_ArtCLASS3.asstring := '';
            MemD_ArtCLASS4.asstring := '';
            MemD_ArtCLASS5.asstring := '';
            MemD_ArtIDREF_SSFAM.asstring := '';
            MemD_ArtCOUL1.asstring := 'Unicouleur';
            MemD_ArtCOUL2.asstring := '';
            MemD_ArtCOUL3.asstring := '';
            MemD_ArtCOUL4.asstring := '';
            MemD_ArtCOUL5.asstring := '';
            MemD_ArtCOUL6.asstring := '';
            MemD_ArtCOUL7.asstring := '';
            MemD_ArtCOUL8.asstring := '';
            MemD_ArtCOUL9.asstring := '';
            MemD_ArtCOUL10.asstring := '';
            MemD_ArtCOUL11.asstring := '';
            MemD_ArtCOUL12.asstring := '';
            MemD_ArtCOUL13.asstring := '';
            MemD_ArtCOUL14.asstring := '';
            MemD_ArtCOUL15.asstring := '';
            MemD_ArtCOUL16.asstring := '';
            MemD_ArtCOUL17.asstring := '';
            MemD_ArtCOUL18.asstring := '';
            MemD_ArtCOUL19.asstring := '';
            MemD_ArtCOUL20.asstring := '';
            MemD_ArtFidelite.asstring := 'OUI';
            MemD_ArtDC.asstring := '';
            MemD_ArtCollection.asstring := '';
            MemD_ArtComent1.asstring := '';
            MemD_ArtComent2.asstring := '';
            MemD_ArtTVA.asstring := MOrigineTVA1.asstring;
            memd_art.post;

            MOrigine.Next;
        END;

        MemD_Art.DelimiterChar := ';';
        memd_ART.SaveToTextFile(ChemDest + 'ARTICLES.CSV');

        memd_cb.DelimiterChar := ';';
        memd_cb.SaveToTextFile(ChemDest + 'CODE_BARRE.CSV');

        memd_px.DelimiterChar := ';';
        memd_px.SaveToTextFile(ChemDest + 'PRIX.CSV');

        memd_marque.SaveToTextFile(ChemDest + 'marque.csv');
        memd_fourn.SaveToTextFile(ChemDest + 'fourn.csv');


        MessageDlg('Traitement Terminé', mtInformation, [], 0);

    END;

END;

END.


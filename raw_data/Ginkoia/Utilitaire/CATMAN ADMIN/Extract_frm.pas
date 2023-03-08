unit Extract_frm;

interface

uses
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    Db,
    ADODB,
    ActionRv,
    IBDatabase,
    IBCustomDataSet,
    IBQuery,
    dxmdaset,
    StdCtrls,
    RzLabel,
    ExtCtrls,
    IBSQL,
    LMDCustomComponent,
    LMDIniCtrl,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    jpeg,
    wwDialog,
    wwidlg,
    wwLookupDialogRv,
    BmDelay,
    IdBaseComponent,
    IdComponent,
    IdTCPConnection,
    IdTCPClient,
    IdFTP, IdExplicitTLSClientServerBase;

type
    TFrm_Extract = class(TForm)
        ADO: TADOConnection;
        Qmag: TADOQuery;
        close: TGroupDataRv;
        Qmagmag_id: TAutoIncField;
        Qmagmag_cheminbase: TStringField;
        Tran: TIBTransaction;
        Ginkoia: TIBDatabase;
        Qmagmag_dateactivation: TDateTimeField;
        Qmagmag_code: TStringField;
        Qmagreplic: TDateTimeField;
        histo: TADOQuery;
        Qmagdos_id: TAutoIncField;
        RzLabel1: TRzLabel;
        tt: TTimer;
        QMvt: TIBQuery;
        QMvtRETOUR: TIntegerField;
        QMvtARTID: TIntegerField;
        QMvtCOUID: TIntegerField;
        QMvtTGFID: TIntegerField;
        QMvtMOV_QTE: TIntegerField;
        QMvtMOV_PXBRUT: TIBBCDField;
        QMvtMOV_PXNET: TIBBCDField;
        QMvtMOV_DATE: TDateTimeField;
        QMvtMOV_IDORIGINE: TIntegerField;
        QMvtART_NOM: TIBStringField;
        QMvtART_REFMRK: TIBStringField;
        QMvtART_MRKID: TIntegerField;
        QMvtMRK_NOM: TIBStringField;
        QMvtFEDAS: TIBStringField;
        QMvtART_GTFID: TIntegerField;
        QMvtGTF_NOM: TIBStringField;
        QMvtTGF_NOM: TIBStringField;
        QMvtCOU_NOM: TIBStringField;
        QMvtCOU_CODE: TIBStringField;
        QMvtPA: TIBBCDField;
        QMvtPV: TIBBCDField;
        QMvtCATMAN: TIntegerField;
        majPs: TIBSQL;
        INI: TLMDIniCtrl;
        Lab_mag: TRzLabel;
        Qmagmag_nom: TStringField;
        LMDSpeedButton1: TLMDSpeedButton;
        Lab_Info: TRzLabel;
        RzLabel2: TRzLabel;
        QMvtPUMP: TIBBCDField;
        QMvtMOV_TVA: TIntegerField;
        QMvtLASTVERSION: TIntegerField;
        QKmax: TADOQuery;
        SqlMaj: TIBSQL;
        Qmaj: TIBQuery;
        QKmaxkmax: TIntegerField;
        CurrentV: TIBQuery;
        CurrentVNEWKEY: TIntegerField;
        Image1: TImage;
        Image2: TImage;
        LMDSpeedButton2: TLMDSpeedButton;
        qlkmag: TADOQuery;
        lkmag: TwwLookupDialogRV;
        qlkmagdos_nom: TStringField;
        qlkmagmag_nom: TStringField;
        qlkmagmag_id: TAutoIncField;
        ADO_REEL: TADOConnection;
        ADO_TEST: TADOConnection;
        LMDIniCtrl1: TLMDIniCtrl;
        Alim_tb: TADOCommand;
        LMDSpeedButton3: TLMDSpeedButton;
        Unepause: TBmDelay;
        NewProc: TIBSQL;
        flagTag: TADOQuery;
        RegPxnetCDE: TIBQuery;
        RegK: TIBQuery;
        alim_tba: TADOCommand;
        ado_local: TADOConnection;
        RegPxnetREC: TIBQuery;
        QMvtCREE: TDateTimeField;
        QMvtCB: TIBStringField;
        PsMvt: TADOStoredProc;
        ComboBox: TComboBox;
        FTP: TIdFTP;
        memo: TMemo;
        MemD_Ftp: TdxMemData;
        MemD_FtpNumMagasin: TStringField;
        MemD_FtpNomMagasin: TStringField;
        MemD_Ftpdate: TDateField;
        MemD_FtpMouvement: TStringField;
        MemD_FtpLibelleMouvement: TStringField;
        MemD_FtpNomMarque: TStringField;
        MemD_FtpRefFournisseurTL: TStringField;
        MemD_FtpRefFournisseur: TStringField;
        MemD_FtpDesignation: TStringField;
        MemD_FtpUVC: TStringField;
        MemD_FtpCouleur: TStringField;
        MemD_FtpTaille: TStringField;
        MemD_FtpQuantite: TStringField;
        MemD_FtpCodeEAN: TStringField;
        MemD_FtpTva: TStringField;
        MemD_FtpMontantNet: TStringField;
        MemD_FtpPxVente: TStringField;
        MemD_FtpPxAchat: TStringField;
        MemD_FtpFedas: TStringField;
        Tmov: TADOTable;
        TmovCOL_MVT: TStringField;
        TmovCOL_SENS: TStringField;
        TmovCOL_TYP: TWordField;
    TmagI: TADOTable;
    TmagIMAG_ID: TAutoIncField;
    TmagIMAG_DOSID: TIntegerField;
    TmagIMAG_REGID: TIntegerField;
    TmagIMAG_TYMID: TIntegerField;
    TmagIMAG_CODE: TStringField;
    TmagIMAG_NOM: TStringField;
    TmagIMAG_DIRECTEUR: TStringField;
    TmagIMAG_VILLE: TStringField;
    TmagIMAG_LEARDERSHIP: TIntegerField;
    TmagIMAG_ENABLED: TIntegerField;
    TmagIMAG_CHEMINBASE: TStringField;
    TmagIMAG_DATEACTIVATION: TDateTimeField;
    TmagIMAG_ACTIF: TIntegerField;
    TmagIMAG_X: TSmallintField;
    TmagIMAG_Y: TSmallintField;
    TmagIMAG_INDICGENERAL: TWordField;
    TmagIMAG_SENDERID: TIntegerField;
    TFTP: TADOTable;
    TFTPint_id: TAutoIncField;
    TFTPint_nomfic: TStringField;
    TFTPint_daterec: TDateTimeField;
    TFTPint_datetraite: TDateTimeField;
    TFTPint_traite: TIntegerField;

        procedure FormCreate(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure ttTimer(Sender: TObject);
        procedure LMDSpeedButton1Click(Sender: TObject);
        procedure RzLabel1DblClick(Sender: TObject);
        procedure LMDSpeedButton2Click(Sender: TObject);
        procedure LMDSpeedButton3Click(Sender: TObject);
    private
        { Déclarations privées }
        rep: string;
        procedure traitement(idmag: integer);

        procedure InsertMvt;
        function InsertMvtIntegre(nomfic: string): boolean;
        FUNCTION virgule(champ:string):extended;

    public
        { Déclarations publiques }
    end;

var
    Frm_Extract: TFrm_Extract;

implementation
uses
    DlgStd_Frm,
    GaugeMess_Frm;

{$R *.DFM}

procedure TFrm_Extract.FormCreate(Sender: TObject);
begin
    //    IF INI.readString('BASE', 'TEST', '') = 'O' THEN
    //    BEGIN
    //        ado.ConnectionString := ado_test.ConnectionString;
    //        self.caption := '**** BASE TEST ****';
    //    END
    //    ELSE
    //        ado.ConnectionString := ado_reel.ConnectionString;

    if INI.readString('BASE', 'TEST', '') = 'O' then
    begin
        ado.ConnectionString := ado_test.ConnectionString;
        self.caption := '**** BASE TEST ****';
    end
    else
    begin
        if INI.readString('BASE', 'LOCAL', '') = 'O' then
        begin
            ado.ConnectionString := ado_Local.ConnectionString;
        end
        else
        begin
            ado.ConnectionString := ado_reel.ConnectionString;
        end
    end;

    ShowMessHPAvi('Connexion au serveur CATMAN en cours ...', false, 0, 0, 'Administration CATMAN');
    try
        ado.connected := true;
    except
        ShowCloseHP;
        InfoMessHP('Problème de connection avec le serveur CATMAN,' + #10 + #13 +
            'Réessayez ultérieurement...', true, 0, 0);

        application.terminate;
    end;
    ShowCloseHP;
    tt.enabled := true;
    Rep := INI.readString('REP', 'SCRIPT', '');
    combobox.itemindex := 0;
end;

procedure TFrm_Extract.FormCloseQuery(Sender: TObject;
    var CanClose: Boolean);
begin
    ado.close;
    close.close;

end;

procedure TFrm_Extract.Traitement(idmag: integer);
var
    debut, fin: tdatetime;
    lame: string;
    atraiter: boolean;
    tsl: tstringlist;
    i, boucle: integer;
    chemftp, ligne: string;
    sr: TSearchRec;
    dtmvt: string;
    ec: integer;

begin
    ec := 0;
    qmag.open;
    while (not qmag.eof) and (combobox.itemindex <> 5) do
    begin
        atraiter := true;

        if combobox.itemindex = 1 then
        begin
            if Pos('LAME1', Qmagmag_cheminbase.asstring) <> 0 then
                atraiter := true
            else
                atraiter := false;
        end;
        if combobox.itemindex = 3 then
        begin
            if Pos('LAME3', Qmagmag_cheminbase.asstring) <> 0 then
                atraiter := true
            else
                atraiter := false;
        end;
        if combobox.itemindex = 4 then
        begin
            if Pos('LAME4', Qmagmag_cheminbase.asstring) <> 0 then
                atraiter := true
            else
                atraiter := false;
        end;

        if ((idmag <> 0) and (Qmagmag_id.asinteger = idmag)) or ((idmag = 0) and (atraiter)) then
        begin
            ec := ec + 1;
            ginkoia.close;
            ginkoia.databasename := Qmagmag_cheminbase.asstring;

            debut := now;
            try
                ginkoia.open;

                //Mise à jour des scripts de procédure
                try
                    tran.starttransaction;
                    QMaj.sql.text := 'Drop procedure bn_cat_mvt';
                    QMaj.open;
                    tran.commit;
                except
                    tran.rollback;
                end;

                try
                    tran.starttransaction;
                    QMaj.sql.text := 'Drop procedure bn_cat_article';
                    QMaj.open;
                    tran.commit;
                except
                    tran.rollback;
                end;

                tran.active := true;
                NewProc.sql.LoadFromFile(ExtractFilePath(application.exename) + 'BN_CAT_ARTICLE.sql');
                NewProc.ExecQuery();
                tran.commit;

                tran.active := true;
                NewProc.sql.LoadFromFile(ExtractFilePath(application.exename) + 'BN_CAT_MVT.sql');
                NewProc.ExecQuery();
                tran.commit;

                tran.active := false;
                //Insertion des mouvements
                lab_mag.caption := inttostr(ec) + '/' + inttostr(qmag.recordcount) + ' Magasin en cours : ' + Qmagmag_nom.asstring;

                InsertMvt;

            except

                histo.close;
                histo.Parameters[0].value := Qmagmag_id.asinteger;
                histo.Parameters[1].value := 0;
                histo.Parameters[2].value := 0;
                histo.Parameters[3].value := debut;
                histo.Parameters[4].value := now;
                histo.parameters[5].value := 'Connexion impossible';
                histo.parameters[6].value := 0;
                histo.ExecSQL;
            end;
        end;

        qmag.next;
        if idmag = 0 then
        begin
            lab_mag.caption := 'Pause';
            lab_info.caption := 'Interruption possible';
            application.ProcessMessages;
            Unepause.Wait;
        end
    end;

    qmag.first;
    qmag.close;

    //Les Intégrés maintenant...
    if (combobox.itemindex = 0) or (combobox.itemindex = 5) then
    begin
        ShowMessHPAvi('Connexion au FTP Sp2000 ...', false, 0, 0, 'Administration CATMAN');

        //Connexion sur le FTP
        tsl := tstringlist.create;
        if FTP.Connected then FTP.Disconnect;

        FTP.Host := '194.250.124.9';
        FTP.Username := 'colombusginko';
        FTP.Password := 'sui67f5d';
        chemftp := INI.readString('FTP', 'CHEMIN', '');
        try
            FTP.Connect;
            if FTP.Connected then
            begin
                ftp.changedir('catman');
                ftp.list(tsl, '', false); //Chargement de la liste des fichiers dispo sur le FTP

                for i := 0 to tsl.count - 1 do
                begin
                    if not FileExists(chemftp + tsl[i]) then
                    begin //On récupère en local seulememnt les fichiers pas enre recu
                        ftp.get(tsl[i], chemftp + tsl[i], true, false);
                    end;
                end;
            end;
        except
        end;
        tsl.clear;
        ShowCloseHP;





        //Tous les fichiers sont récupérés
        //Chargement dans une TSL des fichiers présents dans le répertoire
        boucle := FindFirst(chemftp + 'MVCAT*.CSV', faAnyFile, sr);
        while boucle = 0 do
        begin
            tsl.add(sr.name);
            boucle := findnext(sr);
        end;
        findclose(sr);

        Tmov.open; //Table de description des mouvements
        Tmagi.open;
        Tftp.open;
        //On regarde si déjà traité en base
        for i := 0 to tsl.count - 1 do
        begin

            if not Tftp.locate('int_nomfic',tsl[i],[]) then
            begin // Le fichier doit être traité


                try
                    //Traitement
                    memd_ftp.close;
                    memd_ftp.DelimiterChar := ';';
                    memd_ftp.LoadFromTextFile(chemftp + tsl[i]);

                    //Memd Chargé
                    if InsertMvtIntegre(tsl[i]) then
                    begin
                        //Tag le fichier comme traité
                        tftp.insert;
                        tftpint_nomfic.asstring := tsl[i];
                        tftpint_datetraite.asdatetime := now;
                        tftpint_traite.asinteger := 1;
                        tftp.post;
                    end;
                except
                end
            end
        end;
        tmov.close;
        tmagi.close;
        tftp.close;
    end;
    lab_mag.caption := 'Pas de traitements en cours';
    lab_info.caption := '';
end;

procedure TFrm_Extract.ttTimer(Sender: TObject);
begin
    tt.enabled := false;
    traitement(0);
    // C'est fini...
    Application.terminate;
end;

procedure TFrm_Extract.InsertMvt;
var
    i, typ: integer;
    deb: tdatetime;
    lastk: integer;
    current_version: integer;
    kdeb: integer;
    gauge: integer;
    nbh: integer;

begin
    try
        currentV.open;
        current_version := CurrentVNEWKEY.asinteger;
        currentV.close;

        //Recherche des info dans la base
        for typ := 1 to 10 do
        begin

            //            IF (typ=1) or (typ=9) then
            //            begin

            lab_info.caption := 'Recherche des mouvements de type ' + inttostr(typ);
            application.ProcessMessages;
            deb := now;

            //Recherche du k_version de départ donc le + grans dans histo
            qkmax.close;
            qkmax.parameters[0].value := Qmagmag_id.asinteger;
            qkmax.parameters[1].value := typ;
            qkmax.open;
            if (qkmax.eof) or (qkmax.fieldbyname('kmax').asinteger = 0) then
            begin
                histo.close;
                histo.Parameters[0].value := Qmagmag_id.asinteger;
                histo.Parameters[1].value := 0; //kdeb;
                histo.Parameters[2].value := lastk; //kfin;
                histo.Parameters[3].value := now;
                histo.Parameters[4].value := deb;
                histo.parameters[5].value := 'T' + inttostr(typ) + ' K_version max nul';
                histo.parameters[6].value := 0;
                histo.parameters[7].value := typ;
                histo.parameters[8].value := 0;
                histo.ExecSQL;
                BREAK;
            end;
            kdeb := QKmaxkmax.asinteger;

            qmvt.close;
            qmvt.parambyname('codeadh').asstring := Qmagmag_code.asstring;
            qmvt.parambyname('kversion').asinteger := QKmaxkmax.asinteger;
            qmvt.parambyname('typ').asinteger := typ;
            qmvt.parambyname('current_version').asinteger := current_version;
            qmvt.parambyname('dtmax').asdatetime := Qmagmag_dateactivation.asdatetime;
            qmvt.parambyname('INITIALISATION').asinteger := 0;
            qmvt.open;
            //qmvt.FetchAll;

            i := qmvt.recordcount;

            if (QMvtRETOUR.asinteger = 0) and (i = 1) then
            begin //Pbl de code adhérent   1 seule ligne retournée avec retour=0
                histo.close;
                histo.Parameters[0].value := Qmagmag_id.asinteger;
                histo.Parameters[1].value := QKmaxkmax.asinteger; //kdeb;
                histo.Parameters[2].value := 0; //kfin;
                histo.Parameters[3].value := now;
                histo.Parameters[4].value := deb;
                histo.parameters[5].value := 'Erreur Traitement:CODE ADHERENT';
                histo.parameters[6].value := 0;
                histo.parameters[7].value := typ;
                histo.parameters[8].value := 0;
                histo.ExecSQL;
                EXIT
            end;

            if i = 0 then
            begin
                histo.close;
                histo.Parameters[0].value := Qmagmag_id.asinteger;
                histo.Parameters[1].value := QKmaxkmax.asinteger; //kdeb;
                histo.Parameters[2].value := QKmaxkmax.asinteger; //current_version; //lastk; //kfin;
                histo.Parameters[3].value := now;
                histo.Parameters[4].value := deb;
                histo.parameters[5].value := 'T' + inttostr(typ);
                histo.parameters[6].value := 1;
                histo.parameters[7].value := typ;
                histo.parameters[8].value := 0;
                histo.ExecSQL;
            end;

            while i <> 0 do //Paquet de 10000 Maxi
            begin
                lab_info.caption := 'Traitement en cours (T' + inttostr(typ) + ')';
                application.ProcessMessages;

                qmvt.first;
                //InitGaugeMessHP('Insertion des mouvements de Type ' + inttostr(typ) + '(' + inttostr(i) + ')', i, false, 0, 0);
                InitGaugeMessHP('Insertion des mouvements de Type ' + inttostr(typ), 100, false, 0, 0);
                nbh := 0;
                gauge := 0;
                qmvt.first;
                while not qmvt.eof do
                begin
                    gauge := gauge + 1;
                    nbh := nbh + 1;
                    if gauge = 100 then
                    begin
                        IncGaugeMessHP(0);
                        gauge := 0;
                    end;

                    psmvt.Parameters[1].value := Qmagdos_id.asinteger;
                    psmvt.Parameters[2].value := Qmagmag_id.asinteger;
                    psmvt.Parameters[3].value := typ;
                    psmvt.Parameters[4].value := QMvtMOV_DATE.asdatetime;
                    psmvt.Parameters[5].value := QMvtMOV_IDORIGINE.asinteger;
                    psmvt.Parameters[6].value := QMvtMOV_QTE.asinteger;
                    psmvt.Parameters[7].value := QMvtMOV_PXBRUT.asfloat;
                    psmvt.Parameters[8].value := QMvtMOV_PXNET.asfloat;
                    psmvt.Parameters[9].value := QMvtPUMP.asfloat;
                    psmvt.Parameters[10].value := QMvtARTID.asinteger;
                    psmvt.Parameters[11].value := QMvtART_NOM.asstring;
                    psmvt.Parameters[12].value := QMvtART_REFMRK.asstring;
                    psmvt.Parameters[13].value := QMvtMRK_NOM.asstring;
                    psmvt.Parameters[14].value := QMvtFEDAS.asstring;
                    psmvt.Parameters[15].value := QMvtART_GTFID.asinteger;
                    psmvt.Parameters[16].value := QMvtGTF_NOM.asstring;
                    psmvt.Parameters[17].value := QMvtTGF_NOM.asstring;
                    psmvt.Parameters[18].value := QMvtCOU_NOM.asstring;
                    psmvt.Parameters[19].value := QMvtCOU_CODE.asstring;
                    psmvt.Parameters[20].value := QMvtPA.asfloat;
                    psmvt.Parameters[21].value := QMvtPV.asfloat;
                    psmvt.Parameters[22].value := QMvtCATMAN.asinteger;
                    psmvt.Parameters[23].value := QMvtMOV_TVA.asinteger;
                    psmvt.Parameters[24].value := QMvtCREE.asdatetime;
                    if length(QMvtCB.asstring) > 31 then
                        psmvt.Parameters[25].value := copy(QMvtCB.asstring, 1, 31)
                    else
                        psmvt.Parameters[25].value := QMvtCB.asstring;
                    psmvt.ExecProc;
                    lastk := QMvtLASTVERSION.asinteger;

                    qmvt.next;
                end;
                CloseGaugeMessHP;

                histo.close;
                histo.Parameters[0].value := Qmagmag_id.asinteger;
                histo.Parameters[1].value := kdeb; //QKmaxkmax.asinteger; //kdeb;
                histo.Parameters[2].value := lastk; //current_version; //lastk; //kfin;
                histo.Parameters[3].value := now;
                histo.Parameters[4].value := deb;
                histo.parameters[5].value := 'T' + inttostr(typ);
                histo.parameters[6].value := 1;
                histo.parameters[7].value := typ;
                histo.parameters[8].value := nbh;
                histo.ExecSQL;

                kdeb := lastk;

                qmvt.close;
                qmvt.parambyname('codeadh').asstring := Qmagmag_code.asstring;
                qmvt.parambyname('kversion').asinteger := lastk;
                qmvt.parambyname('typ').asinteger := typ;
                qmvt.parambyname('current_version').asinteger := current_version;
                qmvt.parambyname('dtmax').asdatetime := Qmagmag_dateactivation.asdatetime;
                qmvt.parambyname('INITIALISATION').asinteger := 0;
                qmvt.open;

                //qmvt.FetchAll;
                i := qmvt.recordcount;

            end;

            //            IF typ = 1 THEN
            //            BEGIN //Traitement spécifique pour valoriser les commandes dans Ginkoia
            //              //aux prix px fixé par CATMAN
            //              //Il faut traité tous les enreg Tagué mov_tagGinkoia=1
            //
            //                lab_info.caption := 'Traitement en cours : Regul PX net Commandes';
            //                application.ProcessMessages;
            //
            //
            //                flagtag.Parameters[0].value := Qmagmag_id.asinteger;
            //                flagtag.open;
            //                tran.active:=false;
            //                WHILE NOT flagtag.eof DO
            //                BEGIN
            //                    tran.starttransaction;
            //                    regpxnetCDE.parambyname('cdlid').asinteger := flagtag.fieldbyname('mov_idorigine').asinteger;
            //                    regpxnetCDE.parambyname('pxnet').asfloat := flagtag.fieldbyname('mov_pxnet').asfloat;
            //                    regpxnetCDE.parambyname('pxbrut').asfloat := flagtag.fieldbyname('mov_pxnet').asfloat;
            //                    regpxnetCDE.ExecSQL;
            //
            //                    regK.parambyname('cdlid').asinteger := flagtag.fieldbyname('mov_idorigine').asinteger;
            //                    tran.commit;
            //
            //                    flagtag.next;
            //                END
            //            END
            //
            //            IF typ = 9 THEN
            //            BEGIN //Traitement spécifique pour valoriser les commandes dans Ginkoia
            //              //aux prix px fixé par CATMAN
            //              //Il faut traité tous les enreg Tagué mov_tagGinkoia=1
            //
            //                lab_info.caption := 'Traitement en cours : Regul PX net Receptions';
            //                application.ProcessMessages;
            //
            //
            //                flagtag.Parameters[0].value := Qmagmag_id.asinteger;
            //                flagtag.open;
            //                tran.active:=false;
            //                WHILE NOT flagtag.eof DO
            //                BEGIN
            //                    tran.starttransaction;
            //                    regpxnetREC.parambyname('cdlid').asinteger := flagtag.fieldbyname('mov_idorigine').asinteger;
            //                    regpxnetREC.parambyname('pxnet').asfloat := flagtag.fieldbyname('mov_pxnet').asfloat;
            //                    regpxnetREC.ExecSQL;
            //
            //                    regK.parambyname('cdlid').asinteger := flagtag.fieldbyname('mov_idorigine').asinteger;
            //                    tran.commit;
            //
            //                    flagtag.next;
            //                END
            //            END

             //       END;
        end;

    except
        CloseGaugeMessHP;
        //MessageDlg(inttostr(QMvtMOV_IDORIGINE.asinteger), mtWarning, [], 0);
        histo.close;
        histo.Parameters[0].value := Qmagmag_id.asinteger;
        histo.Parameters[1].value := QKmaxkmax.asinteger; //kdeb;
        histo.Parameters[2].value := 0; //kfin;
        histo.Parameters[3].value := now;
        histo.Parameters[4].value := deb;
        histo.parameters[5].value := 'Erreur Traitement T' + inttostr(typ) + 'ID:' + inttostr(QMvtMOV_IDORIGINE.asinteger);
        histo.parameters[6].value := 0;
        histo.parameters[7].value := typ;
        histo.parameters[8].value := 0;
        histo.ExecSQL;
    end;
end;

function TFrm_Extract.InsertMvtIntegre(nomfic: string): boolean;
var
    i, typ: integer;
    mv: integer;
    sens: integer;

begin
    result := true;
    ADO.begintrans;
    try

        InitGaugeMessHP('Insertion des Mag INTEGRES : ' + nomfic, memd_ftp.recordcount, false, 0, 0);
        memd_ftp.first;
        while not memd_ftp.eof do
        begin
            application.ProcessMessages;
            IncGaugeMessHP(0);

            //Recherche mag et code id
            IF Tmagi.locate('mag_code',MemD_FtpNumMagasin.asstring,[])then
            begin

                psmvt.Parameters[1].value := TmagIMAG_DOSID.asinteger;
                psmvt.Parameters[2].value := TmagIMAG_ID.asinteger;

                //identification du typ par rapport au code mouvement
                if tmov.locate('COL_MVT', MemD_FtpMouvement.asstring, []) then
                begin
                    typ := TmovCOL_TYP.asinteger;

                    //Les mouvement avec typ=0 et les qte=0 ne sont pas traités
                    if (typ <> 0) and (MemD_FtpQuantite.asfloat <> 0) then
                    begin

                        //attention au sens pour certain typ(Entree ou Sortie)
                        sens := 1;

                        case typ of
                            1: begin //Commande
                                    if TmovCOL_SENS.asstring = 'AS' then sens := -1;
                                end;
                            2, 5: begin //Vente, Conso
                                    if TmovCOL_SENS.asstring = 'E' then sens := -1;
                                end;
                        end;




                        psmvt.Parameters[3].value := typ;
                        psmvt.Parameters[4].value := MemD_Ftpdate.asdatetime;
                        psmvt.Parameters[5].value := 0;
                        psmvt.Parameters[6].value := MemD_FtpQuantite.asinteger * sens;

                        //Px brut Px net résultat en fonction dy typ
                        case typ of
                            1,9: begin //Commande & Réception
                                    psmvt.Parameters[7].value := virgule(MemD_FtpPxAchat.asstring); //brut
                                    psmvt.Parameters[8].value := virgule(MemD_FtpMontantNet.asstring) / MemD_FtpQuantite.asfloat; //Net
                                end;
                            2: begin //Vente
                                    psmvt.Parameters[7].value := virgule(MemD_FtpPxVente.asstring); //brut
                                    psmvt.Parameters[8].value := (virgule(MemD_FtpMontantNet.asstring) * (1 + (virgule(MemD_FtpTva.asstring) / 100))) / MemD_FtpQuantite.asfloat; //Net
                                end;
                        else
                            begin
                                psmvt.Parameters[7].value := 0; //brut
                                psmvt.Parameters[8].value := 0;
                            end
                        end;

                        psmvt.Parameters[9].value := virgule(MemD_FtpPxAchat.asstring);
                        psmvt.Parameters[10].value := 0; //Id article origine
                        psmvt.Parameters[11].value := MemD_FtpDesignation.asstring;
                        psmvt.Parameters[12].value := MemD_FtpRefFournisseur.asstring;
                        psmvt.Parameters[13].value := MemD_FtpNomMarque.asstring;
                        psmvt.Parameters[14].value := MemD_FtpFedas.asstring;
                        psmvt.Parameters[15].value := 0;
                        psmvt.Parameters[16].value := 'INTEGRES';
                        psmvt.Parameters[17].value := MemD_FtpTaille.asstring;
                        psmvt.Parameters[18].value := MemD_FtpCouleur.asstring;
                        psmvt.Parameters[19].value := MemD_FtpCouleur.asstring;
                        psmvt.Parameters[20].value := virgule(MemD_FtpPxAchat.asstring);
                        psmvt.Parameters[21].value := virgule(MemD_FtpPxVente.asstring);
                        psmvt.Parameters[22].value := 1;
                        psmvt.Parameters[23].value := virgule(MemD_FtpTva.asstring);
                        psmvt.Parameters[24].value := '01/01/2008';
                        psmvt.Parameters[25].value := MemD_FtpCodeEAN.asstring;
                        psmvt.ExecProc;

                    end; //Typ=0
                end
                else
                begin; //Mvt non trouvé on arrete tout....
                    ADO.rollbacktrans;
                    CloseGaugeMessHP;
                    histo.close;
                    histo.Parameters[0].value := 165;
                    histo.Parameters[1].value := 0; //kdeb;
                    histo.Parameters[2].value := 0; //kfin;
                    histo.Parameters[3].value := now;
                    histo.Parameters[4].value := now;
                    histo.parameters[5].value := MemD_FtpMouvement.asstring + ' ' + nomfic;
                    histo.parameters[6].value := 0;
                    histo.parameters[7].value := typ;
                    histo.parameters[8].value := 0;
                    histo.ExecSQL;
                    result := false;
                    EXIT;
                end
            end
            else
            begin //Magasin non trouvé
                //Déclenche une alerte, mais ne bloque pas le système
                histo.close;
                histo.Parameters[0].value := 165;
                histo.Parameters[1].value := 0;
                histo.Parameters[2].value := 0;
                histo.Parameters[3].value := now;
                histo.Parameters[4].value := now;
                histo.parameters[5].value := 'Non référencé ' + MemD_FtpNumMagasin.asstring + ' ' + nomfic;
                histo.parameters[6].value := 1;
                histo.parameters[7].value := 0;
                histo.parameters[8].value := 0;
                histo.ExecSQL;
               
            end;
            memd_ftp.next;
        end;
        ADO.committrans;
        CloseGaugeMessHP;

        histo.close;
        histo.Parameters[0].value := 165;
        histo.Parameters[1].value := 0;
        histo.Parameters[2].value := 0;
        histo.Parameters[3].value := now;
        histo.Parameters[4].value := now;
        histo.parameters[5].value := nomfic;
        histo.parameters[6].value := 1;
        histo.parameters[7].value := 0;
        histo.parameters[8].value := 0;
        histo.ExecSQL;





    except
        ADO.rollbacktrans;
        CloseGaugeMessHP;
        histo.close;
        histo.Parameters[0].value := 165;
        histo.Parameters[1].value := 0; //kdeb;
        histo.Parameters[2].value := 0; //kfin;
        histo.Parameters[3].value := now;
        histo.Parameters[4].value := now;
        histo.parameters[5].value := 'Erreur Traitement';
        histo.parameters[6].value := 0;
        histo.parameters[7].value := typ;
        histo.parameters[8].value := 0;
        histo.ExecSQL;
        result := false;
    end;




end;

procedure TFrm_Extract.LMDSpeedButton1Click(Sender: TObject);
begin
    application.terminate;
end;

procedure TFrm_Extract.RzLabel1DblClick(Sender: TObject);
begin
    traitement(0);
end;

procedure TFrm_Extract.LMDSpeedButton2Click(Sender: TObject);
begin
    tt.enabled := false;
    if lkmag.execute then
    begin
        qmag.open;
        traitement(qlkmagmag_id.asinteger);
    end;
end;

procedure TFrm_Extract.LMDSpeedButton3Click(Sender: TObject);
begin
    InfoMessHP('Traitement interrompu...', true, 0, 0);
    qmag.last;
end;

FUNCTION TFrm_Extract.virgule(champ:string):extended;
var i:integer;
begin
     i:=pos('.',champ);
     IF i<>0 then
     begin
        delete(champ,i,1);
        insert(',',champ,i);
    END;
    result:=strtofloat(champ);

END;


end.


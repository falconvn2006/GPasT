unit TLS_frm;

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
    Psock,
    NMFtp;

type
    TFrm_TLS = class(TForm)
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
        majPs: TIBSQL;
        INI: TLMDIniCtrl;
        Lab_mag: TRzLabel;
        Qmagmag_nom: TStringField;
        LMDSpeedButton1: TLMDSpeedButton;
        Lab_Info: TRzLabel;
        RzLabel2: TRzLabel;
        SqlMaj: TIBSQL;
        Qmaj: TIBQuery;
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
        LMDSpeedButton3: TLMDSpeedButton;
        Unepause: TBmDelay;
        NewProc: TIBSQL;
        QDJ: TIBQuery;
        Qart: TADOQuery;
        QVte: TIBQuery;
        MemD_R: TdxMemData;
        MemD_RIDENTIFIANTMAGASIN: TStringField;
        MemD_RDATEEXTRACTION: TStringField;
        MemD_RDATEDEBUTPERIODE: TStringField;
        MemD_RDATEFINPERIODE: TStringField;
        MemD_RDATEDEVENTE: TStringField;
        MemD_RCODEARTICLEADIDAS: TStringField;
        MemD_RDESIGNATIONPRODUIT: TStringField;
        MemD_RTAILLE: TStringField;
        MemD_REAN: TStringField;
        MemD_RQUANTITEVENTE: TStringField;
        MemD_RMONTANTVENTE: TStringField;
        MemD_RQUANTITESTOCK: TStringField;
        ADO_TLS: TADOConnection;
        QDTmax: TADOQuery;
        ibc_trigger: TIBQuery;
        nbTrig: TIBQuery;
        FTP: TNMFTP;
        LMDSpeedButton4: TLMDSpeedButton;
        Qartrsm_code: TStringField;
        Qartrsm_taille: TStringField;
        Qartrsm_ean: TStringField;
        monitor: TIBDatabase;
        Qmon: TIBQuery;
        Tmon: TIBTransaction;
        Qmagmag_senderid: TIntegerField;
        QmonHDB_CYCLE: TDateTimeField;
    Qmagdos_nom: TStringField;
        procedure FormCreate(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure ttTimer(Sender: TObject);
        procedure LMDSpeedButton1Click(Sender: TObject);
        procedure RzLabel1DblClick(Sender: TObject);
        procedure LMDSpeedButton2Click(Sender: TObject);
        procedure LMDSpeedButton3Click(Sender: TObject);
        procedure FTPAuthenticationFailed(var Handled: Boolean);
        procedure FTPAuthenticationNeeded(var Handled: Boolean);
        procedure FTPConnectionFailed(Sender: TObject);
        procedure FTPFailure(var Handled: Boolean; Trans_Type: TCmdType);
        procedure LMDSpeedButton4Click(Sender: TObject);
    private
        { Déclarations privées }
        rep: string;

        procedure traitement(idmag: integer);

        procedure ExtractMvt;

    public
        { Déclarations publiques }
    end;

var
    Frm_TLS: TFrm_TLS;

implementation
uses
    DlgStd_Frm,
    GaugeMess_Frm,
    dateutil,
    upost;

{$R *.DFM}

procedure TFrm_TLS.FormCreate(Sender: TObject);
begin
    if INI.readString('BASE', 'TSL', '') = 'O' then
    begin
        ado.ConnectionString := ado_tls.ConnectionString;
        self.caption := 'ADIDAS TSL';
    end
    else
    begin
        if INI.readString('BASE', 'TEST', '') = 'O' then
        begin
            ado.ConnectionString := ado_test.ConnectionString;
            self.caption := '**** BASE TEST ****';
        end
        else
            ado.ConnectionString := ado_reel.ConnectionString;
    end;
    ShowMessHPAvi('Connexion au serveur Sport 2000 en cours ...', false, 0, 0, 'Administration CATMAN');
    try
        ado.connected := true;
    except
        ShowCloseHP;
        InfoMessHP('Problème de connection avec le serveur Sport 2000,' + #10 + #13 +
            'Réessayez ultérieurement...', true, 0, 0);

        application.terminate;
    end;
    ShowCloseHP;
    tt.enabled := true;
    Rep := INI.readString('REP', 'SCRIPT', '');
    monitor.databasename := INI.readString('BASE', 'MONITOR', '');
    monitor.open;
end;

procedure TFrm_TLS.FormCloseQuery(Sender: TObject;
    var CanClose: Boolean);
begin
    ado.close;
    close.close;

end;

procedure TFrm_TLS.Traitement(idmag: integer);
var
    debut, fin: tdatetime;

begin

    qmag.open;
    while not qmag.eof do
    begin

        if ((idmag <> 0) and (Qmagmag_id.asinteger = idmag)) or (idmag = 0) then
        begin
            ginkoia.close;
            ginkoia.databasename := Qmagmag_cheminbase.asstring;

            debut := now;
            try

                ginkoia.open;
                //Mise à jour des scripts de procédure
                try
                    tran.starttransaction;
                    QMaj.sql.text := 'Drop procedure bn_TLS';
                    QMaj.open;
                    tran.commit;
                except
                    tran.rollback;
                end;

                try
                    tran.starttransaction;
                    QMaj.sql.text := 'Drop procedure BN_TRIGGERDIFFERE_ARTICLE';
                    QMaj.open;
                    tran.commit;
                except
                    tran.rollback;
                end;



                tran.active := true;
                NewProc.sql.LoadFromFile(ExtractFilePath(application.exename) + 'BN_TRIGGERDIFFERE_ARTICLE.sql');
                NewProc.ExecQuery();
                tran.commit;

                 tran.active := true;
                NewProc.sql.LoadFromFile(ExtractFilePath(application.exename) + 'BN_TLS.sql');
                NewProc.ExecQuery();
                tran.commit;


                tran.active := false;

                //Extraction des ventes du jour...
                lab_mag.caption := 'Magasin en cours : ' +Qmagdos_nom.asstring+' '+Qmagmag_nom.asstring;

                application.ProcessMessages;

                ExtractMvt;

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
    lab_mag.caption := 'Pas de traitements en cours';
    lab_info.caption := '';

end;

procedure TFrm_TLS.ttTimer(Sender: TObject);
begin
    tt.enabled := false;
    traitement(0);
    // C'est fini...
    Application.terminate;
end;

procedure TFrm_TLS.ExtractMvt;
var
    i: integer;
    deb: tdatetime;
    lastk: integer;
    jour, jourmax: tdatetime;
    nom: string;
    encore: integer;
    nbt: integer;
    nbp: extended;
    taille: string;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;


begin
    try

        //Recherche de la date maxi dejà traité
        qdtmax.close;
        qdtmax.parameters[0].value := Qmagmag_id.asinteger;
        qdtmax.open;

        if (qdtmax.eof) then
        begin
            histo.close;
            histo.Parameters[0].value := Qmagmag_id.asinteger;
            histo.Parameters[1].value := 0; //kdeb;
            histo.Parameters[2].value := 0; //kfin;
            histo.Parameters[3].value := now;
            histo.Parameters[4].value := now;
            histo.parameters[5].value := 'Date max nul';
            histo.parameters[6].value := 0;
            histo.parameters[7].value := 0;
            histo.ExecSQL;
            EXIT;
        end;

        //Recherche des jour à traiter
        jour := IncDay(qdtmax.fieldbyname('dtmax').asdatetime, 1);

        //      ANCIENNE METHODE
        //        QDJ.close;
        //        QDJ.parambyname('CODEADH').asstring := Qmagmag_code.asstring;
        //        QDJ.open;
        //        jourmax := int(qdj.fieldbyname('DerVte').asdatetime);
        //        jourmax := incday(jourmax, -1);

                  //NOUVELLE METHODE
        Qmon.close;
        qmon.parambyname('ID').asinteger := Qmagmag_senderid.asinteger;
        Qmon.open;
        if not qmon.eof then
        begin
            //Il faut interpréter la date de dern réplic
            DecodeTime(QmonHDB_CYCLE.asdatetime, Hour, Min, Sec, MSec);
            DecodeDate(QmonHDB_CYCLE.asdatetime, Year, Month, Day);

            //Si replic >= à 19H jour ok
            if hour >= 19 then
                jourmax := EncodeDate(Year, Month, Day)
            else
                //Replic avant 19h jour=jour-1
                jourmax := EncodeDate(Year, Month, Day - 1);
        end
        else
            jour:=jourmax+1; //Pas de traitement



        IF jour > jourmax then EXIT;

        //        //Régul des trigger différé
        //        lab_info.caption := 'Calcul des triggers';
        //        nbtrig.open;
        //        nbt := nbtrig.fieldbyname('nbr').asinteger;
        //        nbtrig.close;
        //
        //        nbp := int(nbt / 500) + 1;
        //
        //        encore := 1;
        //        tran.active := true;
        //        WHILE encore = 1 DO
        //        BEGIN
        //            lab_info.caption := 'Calcul des triggers en cours : ' + floattostr(nbp) + ' paquet(s)';
        //            application.ProcessMessages;
        //            ibc_trigger.close;
        //            ibc_trigger.open;
        //            encore := ibc_trigger.fieldbyname('Retour').asinteger;
        //            tran.commit;
        //            nbp := nbp - 1;
        //        END;
        //        tran.active := false;

        lab_info.caption := 'Extraction des ventes';
        application.ProcessMessages;
        Qart.open;
        //Boucle de Jour à Jourmax
        while jour <= jourmax do
        begin
            //Traitement du JOUR
            InitGaugeMessHP('Ventes du ' + datetostr(jour), qart.recordcount, false, 0, 0);
            memd_r.close;
            memd_r.open;

            qart.first;
            while not qart.eof do
            begin
                IncGaugeMessHP(0);

                qvte.close;
                qvte.parambyname('jour').asdatetime := jour;
                qvte.parambyname('codeadh').asstring := Qmagmag_code.asstring;
                qvte.parambyname('art_refmrk').asstring := Qartrsm_code.asstring; //Qartart_refmrk.asstring;
                qvte.parambyname('tgf_nom').asstring := Qartrsm_taille.asstring; //Qarttgf_nom.asstring;
                qvte.parambyname('ean').asstring := Qartrsm_ean.asstring;
                qvte.open;
                taille := Qartrsm_taille.asstring; //Qarttgf_nom.asstring;

                if not qvte.eof then
                begin
                    qvte.first;
                    while not qvte.eof do
                    begin
                        memd_r.append;
                        MemD_RIDENTIFIANTMAGASIN.asstring := Qmagmag_code.asstring;
                        MemD_RDATEEXTRACTION.asstring := datetostr(date);
                        MemD_RDATEDEBUTPERIODE.asstring := datetostr(jour);
                        MemD_RDATEFINPERIODE.asstring := datetostr(jour);
                        MemD_RDATEDEVENTE.asstring := datetostr(jour);
                        MemD_RCODEARTICLEADIDAS.asstring := Qartrsm_code.asstring; //Qartart_refmrk.asstring;
                        MemD_RDESIGNATIONPRODUIT.asstring := qvte.fieldbyname('art_nom').asstring;
                        MemD_RTAILLE.asstring := Taille;
                        MemD_REAN.asstring := '';
                        MemD_RQUANTITEVENTE.asstring := qvte.fieldbyname('qtvte').asstring;
                        MemD_RMONTANTVENTE.asstring := qvte.fieldbyname('cavte').asstring;
                        MemD_RQUANTITESTOCK.asstring := qvte.fieldbyname('qtstk').asstring;
                        memd_r.post;
                        qvte.next;
                    end
                end;

                //Si rien trouvé alors...
                if qvte.recordcount = 0 then
                begin
                    //cas particulier
                    if (taille = '2XL') or (taille = '3XL') or (taille = '180') then
                    begin
                        if (taille = '2XL') then taille := 'XXL';
                        if (taille = '3XL') then taille := 'XXXL';
                        if (taille = '180') then taille := '180.';
                        qvte.close;
                        qvte.parambyname('jour').asdatetime := jour;
                        qvte.parambyname('codeadh').asstring := Qmagmag_code.asstring;
                        qvte.parambyname('art_refmrk').asstring := Qartrsm_code.asstring; //Qartart_refmrk.asstring;
                        qvte.parambyname('tgf_nom').asstring := taille;
                        qvte.parambyname('ean').asstring := Qartrsm_ean.asstring;
                        qvte.open;

                        if not qvte.eof then
                        begin
                            qvte.first;
                            while not qvte.eof do
                            begin
                                memd_r.append;
                                MemD_RIDENTIFIANTMAGASIN.asstring := Qmagmag_code.asstring;
                                MemD_RDATEEXTRACTION.asstring := datetostr(date);
                                MemD_RDATEDEBUTPERIODE.asstring := datetostr(jour);
                                MemD_RDATEFINPERIODE.asstring := datetostr(jour);
                                MemD_RDATEDEVENTE.asstring := datetostr(jour);
                                MemD_RCODEARTICLEADIDAS.asstring := Qartrsm_code.asstring; //Qartart_refmrk.asstring;
                                MemD_RDESIGNATIONPRODUIT.asstring := qvte.fieldbyname('art_nom').asstring;
                                if (taille = 'XXL') then taille := '2XL';
                                if (taille = 'XXXL') then taille := '3XL';
                                if (taille = '180.') then taille := '180';
                                MemD_RTAILLE.asstring := Taille;
                                MemD_REAN.asstring := '';
                                MemD_RQUANTITEVENTE.asstring := qvte.fieldbyname('qtvte').asstring;
                                MemD_RMONTANTVENTE.asstring := qvte.fieldbyname('cavte').asstring;
                                MemD_RQUANTITESTOCK.asstring := qvte.fieldbyname('qtstk').asstring;
                                memd_r.post;
                                qvte.next;
                            end;
                        end;
                    end;
                end;

                qart.next;
            end;

            if memd_r.recordcount <> 0 then
            begin
                //Sauvegarde du fichier au format rsm_sp2000_DDMMYYYY.csv
                nom := 'rsm_sp2000_' + Qmagmag_code.asstring + '_' +
                    copy(datetostr(jour), 1, 2) +
                    copy(datetostr(jour), 4, 2) +
                    copy(datetostr(jour), 7, 4) + '.csv';
                memd_r.DelimiterChar := ';';
                memd_r.SaveToTextFile(ExtractFilePath(application.exename) + 'Extract\' + nom);

                ftp.Connect;
                ftp.ChangeDir('ADIDAS_S2000');
                ftp.upload(ExtractFilePath(application.exename) + 'Extract\' + nom, nom);

                ftp.disconnect;
            end;

            histo.close;
            histo.Parameters[0].value := Qmagmag_id.asinteger;
            histo.Parameters[1].value := 0;
            histo.Parameters[2].value := 0;
            histo.Parameters[3].value := now;
            histo.Parameters[4].value := jour;
            if memd_r.recordcount <> 0 then
                histo.parameters[5].value := 'OK'
            else
                histo.parameters[5].value := 'OK (Vide)';
            histo.parameters[6].value := 1;
            histo.parameters[7].value := 0;
            histo.ExecSQL;
            memd_r.close;
            CloseGaugeMessHP;

            jour := incday(jour, 1);
        end;

    except
        CloseGaugeMessHP;
        //MessageDlg(inttostr(QMvtMOV_IDORIGINE.asinteger), mtWarning, [], 0);
        histo.close;
        histo.Parameters[0].value := Qmagmag_id.asinteger;
        histo.Parameters[1].value := 0; //kdeb;
        histo.Parameters[2].value := 0; //kfin;
        histo.Parameters[3].value := now;
        histo.Parameters[4].value := now;
        histo.parameters[5].value := 'Erreur Traitement ';
        histo.parameters[6].value := 0;
        histo.parameters[7].value := 0;
        histo.ExecSQL;
    end;
end;

procedure TFrm_TLS.LMDSpeedButton1Click(Sender: TObject);
begin
    application.terminate;
end;

procedure TFrm_TLS.RzLabel1DblClick(Sender: TObject);
begin
    traitement(0);
end;

procedure TFrm_TLS.LMDSpeedButton2Click(Sender: TObject);
begin
    tt.enabled := false;
    if lkmag.execute then
    begin
        qmag.open;
        traitement(qlkmagmag_id.asinteger);
    end;
end;

procedure TFrm_TLS.LMDSpeedButton3Click(Sender: TObject);
begin
    InfoMessHP('Traitement interrompu...', true, 0, 0);
    qmag.last;
end;

procedure TFrm_TLS.FTPAuthenticationFailed(var Handled: Boolean);
begin
    MessageDlg('Mauvaise indentification', mtWarning, [], 0);
end;

procedure TFrm_TLS.FTPAuthenticationNeeded(var Handled: Boolean);
begin
    MessageDlg('Besoin Identification ', mtWarning, [], 0);
end;

procedure TFrm_TLS.FTPConnectionFailed(Sender: TObject);
begin
    MessageDlg('Connexion failed', mtWarning, [], 0);
end;

procedure TFrm_TLS.FTPFailure(var Handled: Boolean; Trans_Type: TCmdType);
begin
    MessageDlg('Failure', mtWarning, [], 0);
end;

procedure TFrm_TLS.LMDSpeedButton4Click(Sender: TObject);
begin
    //           ftp.Connect;
    //            ftp.ChangeDir('ADIDAS_S2000');
    //            //ftp.upload(ExtractFilePath(application.exename) + 'Extract\' + nom,nom);
    //            ftp.upload('test.csv','test.csv');
    //
    //            ftp.disconnect;
    //

end;

end.


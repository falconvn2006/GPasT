UNIT Divers_frm;

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
    BmDelay;

TYPE
    TFrm_Divers = CLASS(TForm)
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
        PsMvt: TADOStoredProc;
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
        LMDSpeedButton3: TLMDSpeedButton;
        Unepause: TBmDelay;
        NewProc: TIBSQL;
        flagTag: TADOQuery;
        RegPxnetCDE: TIBQuery;
        RegK: TIBQuery;
        ado_local: TADOConnection;
        RegPxnetREC: TIBQuery;
    umvt: TADOStoredProc;
    qdt: TIBQuery;
    Qmov: TADOQuery;
    IBQuery1: TIBQuery;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    QP: TIBQuery;

        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
        PROCEDURE ttTimer(Sender: TObject);
        PROCEDURE LMDSpeedButton1Click(Sender: TObject);
        PROCEDURE RzLabel1DblClick(Sender: TObject);
        PROCEDURE LMDSpeedButton2Click(Sender: TObject);
        PROCEDURE LMDSpeedButton3Click(Sender: TObject);
    PRIVATE
    { Déclarations privées }
        rep: STRING;
          tsl: tstringList;
        PROCEDURE traitement(idmag: integer);

        PROCEDURE InsertMvt;
        PROCEDURE Datecreation;
        PROCEDURE InitGenparam;

    PUBLIC
    { Déclarations publiques }
    END;

VAR
    Frm_Divers: TFrm_Divers;

IMPLEMENTATION
USES
    DlgStd_Frm,
    GaugeMess_Frm;

{$R *.DFM}

PROCEDURE TFrm_Divers.FormCreate(Sender: TObject);
BEGIN
//    IF INI.readString('BASE', 'TEST', '') = 'O' THEN
//    BEGIN
//        ado.ConnectionString := ado_test.ConnectionString;
//        self.caption := '**** BASE TEST ****';
//    END
//    ELSE
//        ado.ConnectionString := ado_reel.ConnectionString;

    IF INI.readString('BASE', 'TEST', '') = 'O' THEN
    BEGIN
        ado.ConnectionString := ado_test.ConnectionString;
        self.caption := '**** BASE TEST ****';
    END
    ELSE
    BEGIN
        IF INI.readString('BASE', 'LOCAL', '') = 'O' THEN
        BEGIN
            ado.ConnectionString := ado_Local.ConnectionString;
        END
        ELSE
        BEGIN
            ado.ConnectionString := ado_reel.ConnectionString;
        END
    END;

    ShowMessHPAvi('Connexion au serveur CATMAN en cours ...', false, 0, 0, 'Administration CATMAN');
    TRY
        ado.connected := true;
    EXCEPT
        ShowCloseHP;
        InfoMessHP('Problème de connection avec le serveur CATMAN,' + #10 + #13 +
            'Réessayez ultérieurement...', true, 0, 0);

        application.terminate;
    END;
    ShowCloseHP;
    tt.enabled := true;
    Rep := INI.readString('REP', 'SCRIPT', '');

END;

PROCEDURE TFrm_Divers.FormCloseQuery(Sender: TObject;
    VAR CanClose: Boolean);
BEGIN
    ado.close;
    close.close;

END;

PROCEDURE TFrm_Divers.Traitement(idmag: integer);
VAR
    debut, fin: tdatetime;
    lame: STRING;
    atraiter: boolean;

BEGIN
    tsl := tstringList.Create;
    qmag.open;
    WHILE NOT qmag.eof DO
    BEGIN
        atraiter := true;
        lame := INI.readString('LAME', 'LAME', '');
        IF lame = '1' THEN
        BEGIN
            IF Pos('LAME1', Qmagmag_cheminbase.asstring) <> 0 THEN
                atraiter := true
            ELSE
                atraiter := false;
        END;
        IF lame = '3' THEN
        BEGIN
            IF Pos('LAME3', Qmagmag_cheminbase.asstring) <> 0 THEN
                atraiter := true
            ELSE
                atraiter := false;
        END;
        IF lame = '4' THEN
        BEGIN
            IF Pos('LAME4', Qmagmag_cheminbase.asstring) <> 0 THEN
                atraiter := true
            ELSE
                atraiter := false;
        END;

        IF ((idmag <> 0) AND (Qmagmag_id.asinteger = idmag)) OR ((idmag = 0) AND (atraiter)) THEN
        BEGIN
            ginkoia.close;
            ginkoia.databasename := Qmagmag_cheminbase.asstring;

            debut := now;
            TRY
                ginkoia.open;

            //Mise à jour des scripts de procédure
 //               TRY
//                    tran.starttransaction;
//                    QMaj.sql.text := 'Drop procedure bn_cat_mvt';
//                    QMaj.open;
//                    tran.commit;
//                EXCEPT
//                    tran.rollback;
//                END;
//
//                TRY
//                    tran.starttransaction;
//                    QMaj.sql.text := 'Drop procedure bn_cat_article';
//                    QMaj.open;
//                    tran.commit;
//                EXCEPT
//                    tran.rollback;
//                END;
//
//                TRY
//                    tran.starttransaction;
//                    QMaj.sql.text := 'Drop procedure bn_cat_DTCREATION';
//                    QMaj.open;
//                    tran.commit;
//                EXCEPT
//                    tran.rollback;
//                END;


                 TRY
                    tran.starttransaction;
                    QMaj.sql.text := 'Drop procedure BN_INIT_GENPARAM_CATMAN';
                    QMaj.open;
                    tran.commit;
                 EXCEPT
                    tran.rollback;
                END;


                //tran.active := true;
//                NewProc.sql.LoadFromFile(ExtractFilePath(application.exename) + 'BN_CAT_ARTICLE.sql');
//                NewProc.ExecQuery();
//                tran.commit;
//
//                tran.active := true;
//                NewProc.sql.LoadFromFile(ExtractFilePath(application.exename) + 'BN_CAT_MVT.sql');
//                NewProc.ExecQuery();
//                tran.commit;
//
//                tran.active := true;
//                NewProc.sql.LoadFromFile(ExtractFilePath(application.exename) + 'BN_CAT_DTCREATION.sql');
//                NewProc.ExecQuery();
//                tran.commit;

                tran.active := true;
                NewProc.sql.LoadFromFile(ExtractFilePath(application.exename) + 'BN_INIT_GENPARAM_CATMAN.sql');
                NewProc.ExecQuery();
                tran.commit;



                tran.active := false;
                lab_mag.caption := 'Magasin en cours : ' + Qmagmag_nom.asstring;


                //DateCreation;
                InitGenparam;

            EXCEPT

                histo.close;
                histo.Parameters[0].value := Qmagmag_id.asinteger;
                histo.Parameters[1].value := 0;
                histo.Parameters[2].value := 0;
                histo.Parameters[3].value := debut;
                histo.Parameters[4].value := now;
                histo.parameters[5].value := 'Connexion impossible';
                histo.parameters[6].value := 0;
                histo.ExecSQL;
            END;
        END;

        qmag.next;
        IF idmag = 0 THEN
        BEGIN
            lab_mag.caption := 'Pause';
            lab_info.caption := 'Interruption possible';
            application.ProcessMessages;
            //Unepause.Wait;
        END
    END;
    lab_mag.caption := 'Pas de traitements en cours';
    lab_info.caption := '';

     tsl.SaveToFile('C:\UpdateMvt.txt');
    tsl.free;

//    ShowMessHPAvi('Traitement des tables statistiques (TB) ...', false, 0, 0, 'Administration CATMAN');
//    alim_tb.execute;
//    ShowCloseHP;
//
//    ShowMessHPAvi('Traitement des tables statistiques (TBA) ...', false, 0, 0, 'Administration CATMAN');
//    alim_tba.execute;
//    ShowCloseHP;

END;

PROCEDURE TFrm_Divers.ttTimer(Sender: TObject);
BEGIN
    tt.enabled := false;
    traitement(0);
    // C'est fini...
    Application.terminate;
END;

PROCEDURE TFrm_Divers.InsertMvt;
VAR
    i, typ: integer;
    deb: tdatetime;
    lastk: integer;
    current_version: integer;
    kdeb: integer;
    gauge: integer;


BEGIN

    TRY
        currentV.open;
        current_version := CurrentVNEWKEY.asinteger;
        currentV.close;

     //Recherche des info dans la base
        FOR typ := 1 TO 10 DO
        BEGIN

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
            IF (qkmax.eof) OR (qkmax.fieldbyname('kmax').asinteger = 0) THEN
            BEGIN
                histo.close;
                histo.Parameters[0].value := Qmagmag_id.asinteger;
                histo.Parameters[1].value := 0; //kdeb;
                histo.Parameters[2].value := lastk; //kfin;
                histo.Parameters[3].value := now;
                histo.Parameters[4].value := deb;
                histo.parameters[5].value := 'T' + inttostr(typ) + ' K_version max nul';
                histo.parameters[6].value := 0;
                histo.parameters[7].value := typ;
                histo.ExecSQL;
                BREAK;
            END;
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

            IF (QMvtRETOUR.asinteger = 0) AND (i = 1) THEN
            BEGIN //Pbl de code adhérent   1 seule ligne retournée avec retour=0
                histo.close;
                histo.Parameters[0].value := Qmagmag_id.asinteger;
                histo.Parameters[1].value := QKmaxkmax.asinteger; //kdeb;
                histo.Parameters[2].value := 0; //kfin;
                histo.Parameters[3].value := now;
                histo.Parameters[4].value := deb;
                histo.parameters[5].value := 'Erreur Traitement:CODE ADHERENT';
                histo.parameters[6].value := 0;
                histo.parameters[7].value := typ;
                histo.ExecSQL;
                EXIT
            END;

            IF i = 0 THEN
            BEGIN
                histo.close;
                histo.Parameters[0].value := Qmagmag_id.asinteger;
                histo.Parameters[1].value := QKmaxkmax.asinteger; //kdeb;
                histo.Parameters[2].value := QKmaxkmax.asinteger; //current_version; //lastk; //kfin;
                histo.Parameters[3].value := now;
                histo.Parameters[4].value := deb;
                histo.parameters[5].value := 'T' + inttostr(typ);
                histo.parameters[6].value := 1;
                histo.parameters[7].value := typ;
                histo.ExecSQL;
            END;

            WHILE i <> 0 DO //Paquet de 10000 Maxi
            BEGIN
                lab_info.caption := 'Traitement en cours (T' + inttostr(typ) + ')';
                application.ProcessMessages;

                qmvt.first;
                //InitGaugeMessHP('Insertion des mouvements de Type ' + inttostr(typ) + '(' + inttostr(i) + ')', i, false, 0, 0);
                InitGaugeMessHP('Insertion des mouvements de Type ' + inttostr(typ), 100, false, 0, 0);

                gauge := 0;
                qmvt.first;
                WHILE NOT qmvt.eof DO
                BEGIN
                    gauge := gauge + 1;
                    IF gauge = 100 THEN
                    BEGIN
                        IncGaugeMessHP(0);
                        gauge := 0;
                    END;

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
                    psmvt.ExecProc;
                    lastk := QMvtLASTVERSION.asinteger;
                    qmvt.next;
                END;
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

            END;

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
        END;

    EXCEPT
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
        histo.ExecSQL;
    END;

END;

PROCEDURE TFrm_Divers.LMDSpeedButton1Click(Sender: TObject);
BEGIN
    application.terminate;
END;

PROCEDURE TFrm_Divers.RzLabel1DblClick(Sender: TObject);
BEGIN
    traitement(0);
END;

PROCEDURE TFrm_Divers.LMDSpeedButton2Click(Sender: TObject);
BEGIN
    tt.enabled := false;
    IF lkmag.execute THEN
    BEGIN
        qmag.open;
        traitement(qlkmagmag_id.asinteger);
    END;
END;

PROCEDURE TFrm_Divers.LMDSpeedButton3Click(Sender: TObject);
BEGIN
    InfoMessHP('Traitement interrompu...', true, 0, 0);
    qmag.last;
END;

PROCEDURE TFrm_Divers.InitGenparam;
begin
    qp.parambyname('code').asstring:=Qmagmag_code.asstring; 
    qp.ExecSQL;
    
END;


PROCEDURE TFrm_Divers.Datecreation;
var chaine:string;

begin



     qmov.active:=false;

     qmov.parameters[0].value:=Qmagmag_id.asinteger;
     qmov.active:=true;



     InitGaugeMessHP('Traitement cours ' , qmov.recordcount, false, 0, 0);


     WHILE not qmov.eof do
     begin
          IncGaugeMessHP(0);

          qdt.close;
          qdt.parambyname('typ').asinteger:=qmov.fieldbyname('mov_type').asinteger;
          qdt.parambyname('id').asinteger:=qmov.fieldbyname('mov_idorigine').asinteger;
          qdt.open;

          IF qdt.fieldbyname('dt_creation').asdatetime=0 then
          begin
              tsl.add(inttostr(qmov.fieldbyname('mov_idorigine').asinteger));
          END;


//          try
//          umvt.Parameters[1].value := Qmagmag_id.asinteger;
//          umvt.Parameters[2].value := qmov.fieldbyname('mov_idorigine').asinteger;
//          umvt.Parameters[3].value := qdt.fieldbyname('dt_creation').asdatetime;
//          umvt.ExecProc;
//          except
//          MessageDlg(floattostr(qdt.fieldbyname('dt_creation').asdatetime)+' '+datetostr(qdt.fieldbyname('dt_creation').asdatetime)+' '+inttostr(qmov.fieldbyname('mov_idorigine').asinteger)+' '+inttostr(qmov.fieldbyname('mov_type').asinteger)  , mtWarning, [], 0);
//          END;
//          // chaine:='update mouvements set mov_artcreation='+#39+datetostr(qdt.fieldbyname('dt_creation').asdatetime)+#39+' where mov_magid='+Qmagmag_id.asstring+' and mov_idorigine='+qmov.fieldbyname('mov_idorigine').asstring;
//
//          // tsl.add(chaine);
            qmov.next;

     END;
     qmov.first;
     qmov.close;

     CloseGaugeMessHP;

END;


END.


//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Trigger_frm;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls,
    
    Forms, Dialogs, AlgolStdFrm, LMDCustomComponent, LMDIniCtrl,
    IB_Components, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
    LMDCustomSpeedButton, LMDSpeedButton, StdCtrls, RzLabel, LMDFileGrep,
    UserDlg, Psock, NMsmtp;

TYPE
    TFrm_Trigger = CLASS(TAlgolStdFrm)
        Database: TIB_Connection;
        IniCtrl_Trig: TLMDIniCtrl;
        IbC_Trigger: TIB_Cursor;
        IbT_Trig: TIB_Transaction;
        LMDSpeedButton1: TLMDSpeedButton;
        LMDSpeedButton2: TLMDSpeedButton;
        RzLabel1: TRzLabel;
        Lab_Base: TRzLabel;
        RzLabel2: TRzLabel;
        IbC_Paquet: TIB_Cursor;
        RzLabel3: TRzLabel;
        Lab_Paquet: TRzLabel;
        Lab_Pec: TRzLabel;
        IbC_Exe: TIB_Cursor;
        LMDSpeedButton3: TLMDSpeedButton;
        FileGrep: TLMDFileGrep;
        IbC_Proc: TIB_Cursor;
        Mess: TUserDlg;
        IbC_Etatgen: TIB_Cursor;
        IbC_CreatePrc: TIB_Cursor;
        IbC_GENTRIG: TIB_Cursor;
        NMSMTP1: TNMSMTP;
    IbC_DesActiveTrigger: TIB_Cursor;
        PROCEDURE LMDSpeedButton1Click(Sender: TObject);
        PROCEDURE LMDSpeedButton2Click(Sender: TObject);
        PROCEDURE LMDSpeedButton3Click(Sender: TObject);
    procedure AlgolStdFrmActivate(Sender: TObject);
    PRIVATE
    { Private declarations }
        PROCEDURE traitement;
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED
    { Published declarations }
    END;

VAR
    Frm_Trigger: TFrm_Trigger;

IMPLEMENTATION
{$R *.DFM}

PROCEDURE Tfrm_Trigger.traitement;
VAR i, encore, pec: integer;
    ident, chemin: STRING;
    paquet: extended;
    eror: boolean;

    num, id: STRING;
    resultat: tstrings;

    mail: Tstrings;
    debut:string;


BEGIN

    mail:=TStringList.Create;
    mail.add('SERVEUR : '+IniCtrl_Trig.readString('SERVEUR', 'NOM', ''));
    mail.add('Debut du traitement : '+DateTimeToStr(Now));
    mail.add(' ');

    lab_base.caption := 'Recherche en cours...';
    Application.ProcessMessages;

    FileGrep.grep;
    resultat := FileGrep.Files;
    //MessageDlg(resultat.text, mtWarning, [], 0);

    lab_base.caption := 'Recherche terminée...';
    Application.ProcessMessages;

    database.connected := false; //On sait jamais...

    FOR i := 0 TO resultat.count - 1 DO
    BEGIN
        chemin := copy(resultat[i], 1, length(resultat[i]) - 1) + 'ginkoia.gdb';
        IF chemin <> '' THEN
        BEGIN
            eror := false;

            database.databasename := chemin;
            lab_base.caption := chemin;

            TRY
                database.connected := true;

                ibc_proc.close;
                ibc_proc.open;
                IF ibc_proc.fieldbyname('flag').asinteger = 1 THEN
                BEGIN
                    ibc_etatgen.close;
                    ibc_etatgen.open;
                    IF ibc_etatgen.fieldbyname('flag').asinteger = 0 THEN
                    BEGIN //La proc permettant de connaitre l'etat de gentrigger n'existe pas
                            //Il faut la créer
                        ibc_createprc.close;
                        ibt_trig.starttransaction;
                        ibc_createprc.open;
                        ibt_trig.commit;
                        ibc_createprc.close;

                    END;

                    ibc_GENTRIG.close;
                    ibc_GENTRIG.open;
                    IF ibc_GENTRIG.fieldbyname('EtaT').asinteger = 1 THEN
                    BEGIN

                        ibc_paquet.open;
                        paquet := int(ibc_paquet.fieldbyname('paquet').asinteger / 500) + 1;
                        lab_paquet.caption := floattostr(paquet);
                        ibc_paquet.close;

                        pec := 0;
                        TRY
                            debut:=DateTimeToStr(Now);
                            encore := 1;
                            WHILE encore = 1 DO
                            BEGIN

                                inc(pec);
                                lab_pec.caption := inttostr(pec);
                                Application.ProcessMessages;

                                ibc_trigger.close;
                                ibt_trig.starttransaction;
                                ibc_trigger.open;
                                encore := ibc_trigger.fieldbyname('Retour').asinteger;
                                ibt_trig.commit;
                            END;

                            //Memo rapport pour Mail
                            mail.add(lab_base.caption+' - '+lab_paquet.caption+' Paquet(s)  -   '+debut+' - '+DateTimeToStr(Now));


                        EXCEPT
                            eror := true;
                            ibt_trig.rollback;

                    //Il faut noter l'exeception dans la base
                            IbC_Exe.close;

                            IbC_Exe.Sql.Clear;
                            IbC_Exe.Sql.Add('select Cast(PAR_STRING as Integer) Numero');
                            IbC_Exe.Sql.Add('from genparambase');
                            IbC_Exe.Sql.Add('Where PAR_NOM=''IDGENERATEUR''');
                            IbC_Exe.open;
                            num := IbC_Exe.Fields[0].AsString;
                            IbC_Exe.Close;

                            IbC_Exe.Sql.Clear;
                            IbC_Exe.Sql.Add('select Bas_ID');
                            IbC_Exe.Sql.Add('from GenBases');
                            IbC_Exe.Sql.Add('where BAS_ID<>0');
                            IbC_Exe.Sql.Add('AND BAS_IDENT=' + #39 + Num + #39);
                            IbC_Exe.open;
                            num := IbC_Exe.Fields[0].AsString;

                            IbC_Exe.Close;
                            IbC_Exe.Sql.Clear;
                            IbC_Exe.Sql.Add('Select NewKey ');
                            IbC_Exe.Sql.Add('From PROC_NEWKEY');
                            IbC_Exe.open;
                            Id := IbC_Exe.Fields[0].AsString;
                            IbC_Exe.Close;

                            IbC_Exe.Sql.Clear;
                            IbC_Exe.Sql.Add('Insert Into GenDossier');
                            IbC_Exe.Sql.Add('(DOS_ID, DOS_NOM, DOS_STRING)');
                            IbC_Exe.Sql.Add('VALUES (');
                            IbC_Exe.Sql.Add(Id + ',' + Num + ', ' + '''Recalc Trigger''');
                            IbC_Exe.Sql.Add(')');
                            IbC_Exe.open;
                            IbC_Exe.close;

                            IbC_Exe.Sql.Clear;
                            IbC_Exe.Sql.Add('Insert Into K');
                            IbC_Exe.Sql.Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
                            IbC_Exe.Sql.Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED,KSE_LOCK_ID, KMA_LOCK_ID )');
                            IbC_Exe.Sql.Add('VALUES (');
                            IbC_Exe.Sql.Add(ID + ',-101,-11111338,' + Id + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
                            IbC_Exe.open;

                            IbC_Exe.close;


                            //---------------------------------------

                            //Memo rapport pour Mail
                            mail.add('*** ERREUR *** '+lab_base.caption+' / '+lab_paquet.caption+' / '+debut+' / '+DateTimeToStr(Now));


                        END;
                        ibc_trigger.close;

    //                    IF eror THEN
    //                    BEGIN
    //                        MessageDlg('Erreur : ' + chemin, mtInformation, [], 0);
    //                    END;
                    END;
                END;
                IbC_DesActiveTrigger.ExecSQL;
                database.connected := false;
            EXCEPT
                  mail.add('*** ERREUR BASE SHUTDOWN *** '+lab_base.caption+' / '+lab_paquet.caption+' / '+debut+' / '+DateTimeToStr(Now));
            END;
        END;
    END;

//    MessageDlg('Traitement terminé...', mtInformation, [], 0);

     //Memo rapport pour Mail
     mail.add('');
     mail.add('Fin du traitement : '+DateTimeToStr(Now));


     //Envoi du mail
//     NMSMTP1.Host := 'smtp.fr.oleane.com';
     NMSMTP1.Host := 'mail.netsecurity.fr';
     NMSMTP1.UserID := 'mp1304-10';
     NMSMTP1.PostMessage.Subject := 'Calcul differe des triggers';
     NMSMTP1.PostMessage.FromAddress := 'bruno.nicolafrancesco@algol.fr';
     NMSMTP1.PostMessage.FromName := IniCtrl_Trig.readString('SERVEUR', 'NOM', '');
     NMSMTP1.PostMessage.ToAddress.Add('bruno.nicolafrancesco@algol.fr');
     NMSMTP1.PostMessage.ToAddress.Add('Sandrine.Medeiros@algol.fr');

     NMSMTP1.PostMessage.Body.text:=mail.text;
     NMSMTP1.Connect;
     NMSMTP1.SendMail;
     NMSMTP1.Disconnect;



    mail.free;


    Application.terminate;

END;

PROCEDURE TFrm_Trigger.LMDSpeedButton1Click(Sender: TObject);
BEGIN
    traitement;
END;

PROCEDURE TFrm_Trigger.LMDSpeedButton2Click(Sender: TObject);
BEGIN
    application.terminate;
END;

PROCEDURE TFrm_Trigger.LMDSpeedButton3Click(Sender: TObject);
VAR resultat: tstrings;
    i: integer;
    chemin: STRING;
BEGIN
    FileGrep.grep;
    resultat := FileGrep.Files;
    //MessageDlg(resultat.text, mtWarning, [], 0);

    database.connected := false; //On sait jamais...

    FOR i := 0 TO resultat.count - 1 DO
    BEGIN

//        Ident := inttostr(i);
//
//        // Lecture dans le fichier INI de la base à traiter
//
//        //Chemin de la base
//        chemin := IniCtrl_Trig.readString('BASES', ident, '');

        chemin := copy(resultat[i], 1, length(resultat[i]) - 1) + 'ginkoia.gdb';
        IF chemin <> '' THEN
        BEGIN
            database.databasename := chemin;
            lab_base.caption := chemin;
            database.connected := true;
            ibc_proc.close;
            ibc_proc.open;
            IF ibc_proc.fieldbyname('flag').asinteger = 1 THEN
            BEGIN
                MessageDlg(chemin, mtWarning, [], 0);
            END;
            database.connected := false;
        END;

    END;
END;

procedure TFrm_Trigger.AlgolStdFrmActivate(Sender: TObject);
begin
     Traitement;
end;

END.


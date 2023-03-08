//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Base_frm;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls,
    Forms, Dialogs, AlgolStdFrm, LMDFileCtrl, LMDIniCtrl,
    LMDCustomComponent, LMDFileGrep, splashms, BmDelay ;

TYPE
    TFrmBase = CLASS(TAlgolStdFrm)
        FileGrep_IP: TLMDFileGrep;
        IniCtrl_IP: TLMDIniCtrl;
        LMDFileCtrl1: TLMDFileCtrl;
        Delay: TBmDelay;
    Splash_Mess: TSplashMessage;
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    PRIVATE
    { Private declarations }
        PROCEDURE CHANGE(doc: STRING; ancien: STRING; nouveau: STRING);
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED
    { Published declarations }
    END;

VAR
    FrmBase: TFrmBase;

IMPLEMENTATION
{$R *.DFM}

PROCEDURE TFrmBase.AlgolStdFrmCreate(Sender: TObject);
VAR ident, chemin: STRING;
    ancien, nouveau: STRING;
    i: integer;

BEGIN

    //Analyse du fichier ini
    FOR i := 1 TO 99 DO
    BEGIN

        Ident := inttostr(i);
        Ancien := IniCtrl_IP.readString('ANCIEN', ident, '');
        Nouveau := IniCtrl_IP.readString('NOUVEAU', ident, '');

        IF ancien <> '' THEN
        BEGIN

            //Traitement du fichier ginkoia.ini
            change('Ginkoia.ini', ancien, nouveau);

            //Traitement du fichier -	DelosQPMAgent.Providers.xml
            change('DelosQPMAgent.Providers.xml', ancien, nouveau);

             //Traitement du fichier -	DelosQPMAgent.Subscriptions.xml
            change('DelosQPMAgent.Subscriptions.xml', ancien, nouveau);

        END;
    END;

    Splash_Mess.splash;
    delay.Wait;
    Splash_Mess.stop;
    application.terminate;

END;

PROCEDURE TFrmBase.CHANGE(Doc: STRING; ancien: STRING; nouveau: STRING);
VAR i, j, posi: integer;
    fichier: TStrings;
    resultat: tstrings;
    ligne, chemin: STRING;

BEGIN

    //Recherche de tous les fichiers
    FileGrep_ip.Filemasks := Doc;
    FileGrep_ip.grep;
    resultat := FileGrep_ip.Files;
    FOR i := 0 TO resultat.count - 1 DO
    BEGIN
        chemin := copy(resultat[i], 1, length(resultat[i]) - 1);
        chemin := chemin + doc;

        //Traitement du fichier ginkoia.ini
        fichier := TStringList.Create;
        fichier.loadfromfile(chemin);

        TRY
            FOR j := 0 TO fichier.count - 1 DO
            BEGIN
                ligne := fichier[j];
                posi := Pos(ancien, ligne);
                IF posi <> 0 THEN
                BEGIN
                    Delete(ligne, posi, length(ancien));
                    Insert(nouveau, ligne, posi);
                    fichier[j] := ligne;
                END;
            END;
        EXCEPT
        END;

        fichier.savetofile(chemin);
        fichier.free;
    END;
END;

END.


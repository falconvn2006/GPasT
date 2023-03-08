UNIT UGUID;

INTERFACE

USES
    Xml_Unit,
    IcXMLParser,
    //Debut Uses Perso
    Upost,
    GestionJetonLaunch,
    //Fin Uses Perso
    comobj,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, Db, IBCustomDataSet, IBQuery, IBDatabase, IpUtils, IpSock,
    IpHttp, IpHttpClientGinkoia, IBSQL, ComCtrls, CheckLst, wwriched,
    wwDBRichEditRv, ExtCtrls, RzPanel, Inifiles, StrUtils;

TYPE
    TForm1 = CLASS(TForm)
        Label1: TLabel;
        data: TIBDatabase;
        tran: TIBTransaction;
        Que_Exists: TIBQuery;
        Que_ExistsNB: TIntegerField;
        Que_GUID: TIBQuery;
        Que_GUIDBAS_ID: TIntegerField;
        Que_GUIDBAS_NOM: TIBStringField;
        Que_GUIDBAS_IDENT: TIBStringField;
        Que_GUIDBAS_JETON: TIntegerField;
        Que_GUIDBAS_PLAGE: TIBStringField;
        Que_GUIDBAS_SENDER: TIBStringField;
        Que_GUIDBAS_GUID: TIBStringField;
        Que_ModifK: TIBQuery;
        Que_ModifGUID: TIBQuery;
        IBQue_Base: TIBQuery;
        IBQue_BaseBAS_NOM: TIBStringField;
        IBQue_BaseBAS_IDENT: TIBStringField;
        IBQue_Soc: TIBQuery;
        IBQue_SocSOC_NOM: TIBStringField;
        Que_Version: TIBQuery;
        Que_VersionVER_VERSION: TIBStringField;
        SQL: TIBSQL;
        Label2: TLabel;
        IBQue_LaBaseNew: TIBQuery;
        IBQue_LaBaseNewBAS_ID: TIntegerField;
        IBQue_LaBaseNewBAS_NOM: TIBStringField;
        IBQue_LaBaseNewBAS_IDENT: TIBStringField;
        IBQue_LaBaseNewBAS_GUID: TIBStringField;
        Que_BaseNew: TIBQuery;
        Que_BaseNewBAS_NOM: TIBStringField;
        Que_BaseNewBAS_IDENT: TIBStringField;
        Que_BaseNewBAS_GUID: TIBStringField;
        Label3: TLabel;
        Memo1: TMemo;
        IBQue_Param: TIBQuery;
        IBQue_ParamPRM_STRING: TIBStringField;
        IBQue_BaseBAS_ID: TIntegerField;
        Que_newid1: TIBQuery;
        Que_newid1KTB_ID: TIntegerField;
        Que_newid2: TIBQuery;
        Que_newid3: TIBQuery;
        Que_newid2ID: TLargeintField;
        Que_GUIDBASE: TIBQuery;
        Que_GUIDBASEBAS_GUID: TIBStringField;
        tran2: TIBTransaction;
        Que_existsNom: TIBQuery;
        Que_KTBID: TIBQuery;
        Que_KTBIDKTB_ID: TIntegerField;
        Cb_serveur: TCheckListBox;
        Od: TOpenDialog;
        OdDatabases: TOpenDialog;
        IBQue_Suite: TIBQuery;
        Que_logMag: TIBQuery;
        Que_logMagMAG_ID: TIntegerField;
        Que_logMagMAG_IDENT: TIBStringField;
        Que_logMagMAG_NOM: TIBStringField;
        Que_LogPoste: TIBQuery;
        Que_LogPostePOS_NOM: TIBStringField;
        Chp_Rtf: TwwDBRichEditRv;
        IBQue_Adresse: TIBQuery;
        ds_adresse: TDataSource;
        IBQue_AdresseADR_ID: TIntegerField;
        IBQue_AdresseADR_LIGNE: TIBStringField;
    Pan_Top: TRzPanel;
    PB: TProgressBar;
    Go: TButton;
    Button2: TButton;
    Button1: TButton;
    Http1: TIpHttpClientGinkoia;
        PROCEDURE GoClick(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormPaint(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
    PRIVATE
        PROCEDURE parcour(machine: STRING);
        FUNCTION Patch(i: integer; S: STRING): boolean;
        PROCEDURE CreationGUID(NomClient, LaCentrale: STRING);
        PROCEDURE AffecteYellis(Tc: Tconnexion; NomPourNous: STRING; Lamachine, LaCentrale: STRING);
        PROCEDURE execute(Machine, databases: STRING);
        PROCEDURE TraiteXML(_Nom, _tipe, _data: STRING);
        PROCEDURE CreationLog(NomClient, LaMachine, LaCentrale: STRING);
        PROCEDURE traitement_rtf;
        //Fonction de lecture d'une valeur dans le fichier Ini
        FUNCTION LecteurValeurIni(AFileIni,ASection,AIdent,ADefault:String):String;
        //Procedure de création de log
        Procedure LogDebug(FileLogName,Texte:String);

        function traitechaine(S: string): string;
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        first: boolean;
        Version6plus: boolean;
        faitlelog: boolean;
        log: tstringlist;
        LecteurLame: String;
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

uses UVersion;

{$R *.DFM}

FUNCTION TForm1.Patch(i: integer; S: STRING): boolean;
VAR
    s1, erreur: STRING;
BEGIN
    result := false;
    WHILE s <> '' DO
    BEGIN
        IF pos('<---->', S) > 0 THEN
        BEGIN
            S1 := trim(Copy(S, 1, pos('<---->', S) - 1));
            Delete(S, 1, pos('<---->', S) + 5);
        END
        ELSE
        BEGIN
            S1 := trim(S);
            S := '';
        END;
        IF s1 <> '' THEN
        BEGIN
            TRY
                Sql.Transaction.Active := true;
                Sql.SQL.Text := S1;
                Sql.ExecQuery;
                IF Sql.Transaction.InTransaction THEN
                    Sql.Transaction.Commit;
                Sql.Transaction.Active := true;
            EXCEPT
                ON E: Exception DO
                BEGIN
                    erreur := E.Message;
                    S1 := Uppercase(trim(S1));
               // gestion des GENERATOR déja existants
                    IF copy(S1, 1, length('CREATE GENERATOR')) = 'CREATE GENERATOR' THEN
                    BEGIN
                    END
               // gestion des INDEX déja existants
                    ELSE IF Copy(S1, 1, length('CREATE INDEX')) = 'CREATE INDEX' THEN
                    BEGIN
                    END
           // gestion des TRIGGER déja existants
                    ELSE IF Copy(S1, 1, length('CREATE TRIGGER')) = 'CREATE TRIGGER' THEN
                    BEGIN
                    END
                    ELSE IF copy(S1, 1, length('CREATE PROCEDURE')) = 'CREATE PROCEDURE' THEN
                    BEGIN
                        delete(S1, 1, 6);
                        S1 := 'ALTER' + S1;
                        TRY
                            Sql.Transaction.Active := true;
                            Sql.SQL.Text := S1;
                            Sql.ExecQuery;
                            IF Sql.Transaction.InTransaction THEN
                                Sql.Transaction.Commit;
                            Sql.Transaction.Active := true;
                        EXCEPT
                            ON E: Exception DO
                            BEGIN
                                Application.messagebox(Pchar('Erreur sur le script' + Inttostr(i) + #10#13 + Erreur + Copy(S1, 1, 50)), ' impossible de continuer', mb_ok);
                                result := true;
                                BREAK;
                            END;
                        END;
                    END
                    ELSE
                    BEGIN
                        Application.messagebox(Pchar('Erreur sur le script' + Inttostr(i) + #10#13 + Erreur + Copy(S1, 1, 50)), ' impossible de continuer', mb_ok);
                        result := true;
                        BREAK;
                    END;
                END;
            END
        END;
    END;
END;

PROCEDURE TForm1.CreationGUID(NomClient, LaCentrale: STRING);
VAR
    ktbid, Id: Integer;
BEGIN
   // teste de l'existance du GUID dans la table GenBase
    LogDebug('Trace.log','Création des GUID (NomClient: '+NomClient+' ; LaCentrale: '+LaCentrale);
    tran2.active := true;
    Que_Exists.Open;
    Label2.caption := 'Création des GUID';
    Label2.Update;
    IF Que_ExistsNB.AsInteger > 0 THEN
    BEGIN
        caption := ' Que_GUID 1';
        Que_GUID.open;
        Que_GUID.first;
        WHILE NOT Que_GUID.eof DO
        BEGIN
            IF trim(Que_GUIDBAS_GUID.AsString) = '' THEN
            BEGIN
                caption := ' Que_GUID 1-1';
            // recherche si le guid n'est pas dans les parametres
                Que_ModifK.paramByName('ID').AsInteger := Que_GUIDBAS_ID.AsInteger;
                Que_ModifK.ExecSQL;
                caption := ' Que_GUID 1-2';
                Que_ModifGUID.paramByName('ID').AsInteger := Que_GUIDBAS_ID.AsInteger;
                IBQue_Param.parambyname('magid').AsInteger := Que_GUIDBAS_ID.AsInteger;
                IBQue_Param.Open;
                caption := ' Que_GUID 1-3';
                IF IBQue_Param.isempty THEN
                    Que_ModifGUID.paramByName('GUID').AsSTRING := CreateClassID
                ELSE
                    Que_ModifGUID.paramByName('GUID').AsSTRING := IBQue_ParamPRM_STRING.asstring;
                IBQue_Param.close;
                Que_ModifGUID.ExecSQL;
                caption := ' Que_GUID 1-4';
            END;
            Que_GUID.next;
            caption := ' Que_GUID 2';
        END;
        Que_GUID.close;
        IF tran2.InTransaction THEN
            tran2.commit;
        tran2.active := true;
    END
    ELSE
    BEGIN
        caption := ' IBQue_Base 1';
        IBQue_Base.open;
        IBQue_Base.first;
        caption := ' IBQue_Base 2';
        WHILE NOT IBQue_Base.eof DO
        BEGIN
            caption := ' IBQue_Base 4 - 1';
            IBQue_Param.parambyname('magid').AsInteger := IBQue_BaseBAS_ID.AsInteger;
            caption := ' IBQue_Base 4 - 2';
            IBQue_Param.Open;
            caption := ' IBQue_Base 4 - 3';
            IF IBQue_Param.isempty THEN
            BEGIN
                caption := ' IBQue_Base 4 - 4';
                Que_newid1.open;
                caption := ' IBQue_Base 4 - 5';
                ktbid := Que_newid1KTB_ID.AsInteger;
                Que_newid1.close;
                caption := ' IBQue_Base 4 - 6';
                Que_newid2.Open;
                caption := ' IBQue_Base 4 - 7';
                id := Que_newid2ID.AsInteger;
                Que_newid2.close;
                caption := ' IBQue_Base 4 - 8';
                Que_newid3.paramByName('ID').AsInteger := id;
                Que_newid3.paramByName('KTBID').AsInteger := ktbid;
                Que_newid3.ExecSQL;
                caption := ' IBQue_Base 4 - 9';
                SQL.SQL.Text := 'INSERT INTO GENPARAM ' +
                    ' (PRM_ID,PRM_CODE,PRM_INTEGER,PRM_FLOAT,PRM_STRING,' +
                    'PRM_TYPE,PRM_MAGID,PRM_INFO,PRM_POS) ' +
                    ' VALUES ' +
                    ' (' + Inttostr(id) + ', 9999, 0, 0,''' + CreateClassID + ''', 9999, ' +
                    IBQue_BaseBAS_ID.AsString + ',''GUID en attente version 5.2'',0)';
                caption := ' IBQue_Base 4 - 10';
                Sql.ExecQuery;
                caption := ' IBQue_Base 4 - 11';
            END;
            IBQue_Param.close;
            caption := ' IBQue_Base 3';
            IBQue_Base.next;
            caption := ' IBQue_Base 4';
        END;
        caption := ' IBQue_Base 5';
        IBQue_Base.close;
        caption := ' IBQue_Base 6';
    END;
    Que_existsNom.close;
    Que_existsNom.sql.text := 'select count(*) NB from kfld where kfld_name=''BAS_CENTRALE''';

    Que_existsNom.Open;
    caption := ' IBQue_Base 7';
    IF Que_existsNom.fields[0].AsInteger > 0 THEN
    BEGIN
        caption := ' IBQue_Base 8-' + Que_existsNom.fields[0].AsString;
        Version6plus := true;
     // remplir les champs
        Que_existsNom.Close;
        Que_existsNom.sql.clear;
        Que_existsNom.sql.Add('Select BAS_ID from GENBASES join k on (k_id=bas_id and k_enabled=1) where BAS_ID<>0');
        Que_existsNom.Open;

        Que_existsNom.First;
        WHILE NOT Que_existsNom.eof DO
        BEGIN
            SQL.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK (' + Que_existsNom.fields[0].AsString + ',0)';
            SQL.ExecQuery;
            SQL.SQL.Text := 'UPDATE GENBASES SET BAS_CENTRALE=' + QuotedStr(LaCentrale) +
                ' , BAS_NOMPOURNOUS=' + QuotedStr(NomClient) +
                ' where BAS_ID=' + Que_existsNom.fields[0].AsString;
            SQL.ExecQuery;
            Que_existsNom.next;
        END;
        Que_existsNom.Close;
    END;
   // enlever le loop que sur les versions qui n'ont pas le champs GET_CODE
    Que_existsNom.close;
    Que_existsNom.sql.text := 'select count(*) NB from kfld where kfld_name=''GET_CODE''';
    Que_existsNom.Open;
    IF Que_existsNom.fields[0].AsInteger = 0 THEN
    BEGIN
        Que_existsNom.Close;
        Que_existsNom.Sql.clear;
        Que_existsNom.Sql.Add('select sub_id');
        Que_existsNom.Sql.Add('from gensubscribers join k on (k_id=SUB_ID and k_enabled=1)');
        Que_existsNom.Sql.Add('where sub_loop=1');
        Que_existsNom.Sql.Add('and sub_id<>0');
        Que_existsNom.Open;
        WHILE NOT Que_existsNom.eof DO
        BEGIN
            SQL.SQL.Text := 'UPDATE K SET K_VERSION=GEN_ID(GENERAL_ID,1) WHERE K_ID=' + Que_existsNom.fields[0].AsString;
            SQL.ExecQuery;
            SQL.SQL.Text := 'Update gensubscribers set sub_loop=0 where sub_id=' + Que_existsNom.fields[0].AsString;
            SQL.ExecQuery;
            Que_existsNom.next;

        END;
        Que_existsNom.close;
    END;
    Que_existsNom.Close;

    Que_existsNom.Sql.clear;
    Que_existsNom.Sql.add('select BAS_ID');
    Que_existsNom.Sql.add('from genbases join k on (k_id=bas_id and k_enabled=1)');
    Que_existsNom.Sql.add('where bas_id<>0');
    Que_existsNom.Sql.add('and bas_nom like ''NB%''');
    Que_existsNom.Open;
    WHILE NOT Que_existsNom.eof DO
    BEGIN
        IBQue_Suite.Sql.Clear;
        IBQue_Suite.Sql.add('select PRM_ID, PRM_POS');
        IBQue_Suite.Sql.add('   From genparam');
        IBQue_Suite.Sql.add('        join k on (k_id=prm_id and k_enabled=1)');
        IBQue_Suite.Sql.add('Where PRM_INTEGER = ' + Que_existsNom.fieldByName('BAS_ID').AsString);
        IBQue_Suite.Sql.add('  And PRM_CODE=666 and PRM_TYPE =1999 ');
        IBQue_Suite.Open;
        IF IBQue_Suite.IsEmpty THEN
        BEGIN
            Que_KTBID.Close;
            Que_KTBID.params[0].AsString := 'GENPARAM';
            Que_KTBID.Open;
            Que_newid2.close;
            Que_newid2.Open;
            Que_newid3.paramByName('ID').AsInteger := Que_newid2ID.AsInteger;
            Que_newid3.paramByName('KTBID').AsInteger := Que_KTBIDKTB_ID.AsInteger; ;
            Que_newid3.ExecSQL;
            sql.sql.text := 'INSERT INTO GENPARAM ' +
                ' (PRM_ID,PRM_CODE,PRM_INTEGER,PRM_FLOAT,PRM_STRING,PRM_TYPE,PRM_MAGID,PRM_INFO,PRM_POS) ' +
                '  VALUES ' +
                '(' + Que_newid2ID.AsString + ',666,' + Que_existsNom.fields[0].AsString +
                ',0,'''',1999,0,''Forcer la MAJ'',1)';
            sql.ExecQuery;
            Que_newid2.close;
            Que_KTBID.Close;
        END
        ELSE
        BEGIN
            IF IBQue_Suite.FieldByName('PRM_POS').AsInteger <> 1 THEN
            BEGIN
                Que_ModifK.paramByName('ID').AsInteger := Que_existsNom.fields[0].AsInteger;
                Que_ModifK.ExecSQL;
                Sql.sql.text := 'Update genparam set PRM_POS=1 where prm_id=' + Que_existsNom.fields[0].AsString;
                Sql.execquery;
            END;
        END;
        IBQue_Suite.close;
        Que_existsNom.next;
    END;
    Que_existsNom.close;

    IF tran.InTransaction THEN
        tran.commit;
    IF tran2.InTransaction THEN
        tran2.commit;
    tran.active := true;
    tran2.active := true;
    Que_Exists.close;
END;

function TForm1.traitechaine(S: string): string;
var
   kk: Integer;
begin
   while pos(' ', S) > 0 do
   begin
      kk := pos(' ', S);
      delete(S, kk, 1);
      Insert('%20', S, kk);
   end;
   result := S;
end;

PROCEDURE TForm1.AffecteYellis(Tc: Tconnexion; NomPourNous: STRING; Lamachine, LaCentrale: STRING);
VAR
    GUID: STRING;
    tsl_C: tstringlist;
    tsl_V: TstringList;
    Site: STRING;
    S: STRING;
    VersionEnCours: STRING;
    idclient: STRING;
    PatchClt, PatchVers: Integer;
    Nomdelaversion: STRING;
    i: Integer;
    Tsl: TstringList;
    Nok: Boolean;
    LeJour: STRING;
    spe_patch, spe_fait: integer;
    Nomrecup:String;
BEGIN
   // teste de l'existance du GUID dans la table GenBase
    LogDebug('Trace.log','Affecte Yellis (NomPourNous: '+NomPourNous+' ; Lamachine: '+Lamachine+' ; LaCentrale: '+LaCentrale);
    Que_Exists.Open;
    caption := ' IBQue_Base 7';
    IBQue_Base.open;
    IBQue_Base.first;
    caption := ' IBQue_Base 8';
    Que_Version.Open;
    VersionEnCours := Que_VersionVER_VERSION.AsString;
    Que_Version.Close;
    tsl_V := tc.Select('Select * from version where version="' + VersionEnCours + '"');
    IF tsl_V.count = 0 THEN
    BEGIN
        Application.messagebox(pchar('la version ' + VersionEnCours + ' n''existe pas'), 'Problème', mb_ok);
        EXIT;
    END;
    caption := ' IBQue_Base 9';
    WHILE NOT IBQue_Base.eof DO
    BEGIN
        IF Que_ExistsNB.AsInteger > 0 THEN
        BEGIN
        // recupération du GUID dans GENBASE
            Que_GUIDBASE.ParamByName('BASID').AsInteger := IBQue_BaseBAS_ID.AsInteger;
            Que_GUIDBASE.Open;
            GUID := Que_GUIDBASEBAS_GUID.AsString;
            Que_GUIDBASE.Close;
        END
        ELSE
        BEGIN
        // recupération du GUID dans GENPARAM
            IBQue_Param.parambyname('magid').AsInteger := IBQue_BaseBAS_ID.AsInteger;
            IBQue_Param.Open;
            GUID := IBQue_ParamPRM_STRING.AsString;
            IBQue_Param.Close;
        END;
      // Recherche si le GUID est affecté à une base de Yellis
        tsl_C := tc.Select('Select * from clients where clt_GUID = "' + GUID + '"');
        IBQue_Soc.open;
        Site := IBQue_SocSOC_NOM.AsString;
        IBQue_Soc.Close;
        IF tsl_c.count = 0 THEN
        BEGIN
        // La base n'est pas affectée, recherche de la base
            tc.FreeResult(tsl_C);
         // on recherche au plus précis
            tsl_C := tc.Select('Select * from clients where site = "' + Site + '" And ' +
                ' nom="' + IBQue_BaseBAS_NOM.AsString + '" and nompournous="' + NomPourNous + '" and ' +
                ' clt_GUID is null');
            IF tsl_c.count = 0 THEN
            BEGIN
                tc.FreeResult(tsl_C);
                tsl_C := tc.Select('Select * from clients where site = "' + Site + '" And ' +
                    ' nom="' + IBQue_BaseBAS_NOM.AsString + '" and ' +
                    ' clt_GUID is null');
            END;
            IF tsl_c.count = 0 THEN
            BEGIN
           // le client n'existe pas encore le créer
                S := 'Insert into clients (site, nom, version, patch, nompournous, basepantin, clt_GUID) ' +
                    'values ("' + Site + '", "' + IBQue_BaseBAS_NOM.AsString + '", ' +
                    tc.UneValeur(tsl_V, 'id') + ', 0, "' + NomPourNous + '", ';
                IF IBQue_BaseBAS_IDENT.AsString = '0' THEN
                    s := s + ' 1, "' + GUID + '")'
                ELSE
                    s := s + ' 0, "' + GUID + '")';
                idclient := Inttostr(tc.insert(s, memo1));
            END
            ELSE
            BEGIN
                idclient := tc.UneValeur(tsl_C, 'id');
                tc.ordre('update clients set clt_GUID = "' + GUID + '" where id=' + idclient, memo1);
            END;
        END
        ELSE
            idclient := tc.UneValeur(tsl_C, 'id');
        tc.FreeResult(tsl_C);
        tsl_C := tc.Select('Select * from clients where id = ' + idclient);
      // vérification des données
        IF tc.UneValeur(tsl_C, 'clt_machine') <> LaMachine THEN
        BEGIN
            tc.ordre('update clients set clt_machine = "' + LaMachine + '" where id=' + idclient, memo1);
        END;
        IF tc.UneValeur(tsl_C, 'clt_centrale') <> LaCentrale THEN
        BEGIN
            tc.ordre('update clients set clt_centrale = "' + LaCentrale + '" where id=' + idclient, memo1);
        END;
        IF tc.UneValeur(tsl_C, 'nompournous') <> NomPourNous THEN
        BEGIN
            tc.ordre('update clients set nompournous = "' + NomPourNous + '" where id=' + idclient, memo1);
        END;
        IF tc.UneValeur(tsl_C, 'site') <> site THEN
        BEGIN
            tc.ordre('update clients set site = "' + site + '" where id=' + idclient, memo1);
        END;
        IF tc.UneValeur(tsl_C, 'nom') <> IBQue_BaseBAS_NOM.AsString THEN
        BEGIN
            tc.ordre('update clients set nom = "' + IBQue_BaseBAS_NOM.AsString + '" where id=' + idclient, memo1);
        END;
      // Vérification de la version actuellement dans yellis
        IF IBQue_BaseBAS_IDENT.AsString = '0' THEN
        BEGIN
            IF tc.UneValeur(tsl_V, 'id') <> tc.UneValeur(tsl_C, 'version') THEN
            BEGIN
            // MAJ de la version
                tc.ordre('update clients set version = ' + tc.UneValeur(tsl_V, 'id') + ', patch=0 where id=' + idclient, memo1);
                tc.FreeResult(tsl_C);
                tsl_C := tc.Select('Select * from clients where id=' + idclient, memo1);
            END;

         // doit ont passer des patch ?
            PatchClt := Strtoint(tc.UneValeur(tsl_C, 'patch'));
            PatchVers := Strtoint(tc.UneValeur(tsl_V, 'Patch'));
            Nomdelaversion := tc.UneValeur(tsl_V, 'nomversion');
            IF PatchClt > PatchVers THEN
            BEGIN
            // Ya eu un gros problème
                PatchClt := 0;
                S := 'Update clients set patch = 0 where id=' + idclient;
                tc.ordre(S, memo1);
            END;

            FOR i := PatchClt + 1 TO PatchVers DO
            BEGIN
                label2.caption := 'Patching script ' + inttostr(i); label2.Update;
            // des patchs sont à passer
                //S := LecteurLame+':\EAI\MAJ\Patch\' + Nomdelaversion + '\script' + inttostr(i) + '.SQL';
                Nomrecup := 'http://lame2.no-ip.com/MAJ/Patch/' + Nomdelaversion + '/script' + inttostr(i) + '.SQL';

                if Http1.GetWaitTimeOut(Nomrecup, 30000) then
                begin
                  Http1.SaveToFile(Nomrecup, LecteurLame+':\EAI\MAJ\Patch\' + Nomdelaversion + '\script' + Inttostr(i) + '.SQL');
                  S := LecteurLame+':\EAI\MAJ\Patch\' + Nomdelaversion + '\script' + inttostr(i) + '.SQL';
                  tsl := TstringList.Create;
                  tsl.loadfromfile(S);
                  S := trim(tsl.Text);
                  tsl.free;


                  Nok := Patch(i, S);
                  IF NOK THEN
                  BEGIN
                 // erreur
                      LeJour := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
                      S := 'Insert into histo (id_cli, ladate, action, actionstr, str1) ' +
                          'value (' + idclient + ', "' + LeJour + '",5 ,"script' + Inttostr(i) + '.SQL", "A pantin")';
                      tc.ordre(S, memo1);
                      BREAK;
                  END
                  ELSE
                  BEGIN
                      S := 'Update clients set patch = ' + Inttostr(i) + ' where id=' + idclient;
                      tc.ordre(S, memo1);
                      LeJour := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
                      S := 'Insert into histo (id_cli, ladate, action, actionstr, str1) ' +
                          'value (' + idclient + ', "' + LeJour + '",4 ,"script' + Inttostr(i) + '.SQL", "A pantin")';
                      tc.ordre(S, memo1);
                  END;
                end;
            END;

         // Patch Spécifique au client ?
            spe_patch := Strtoint(tc.UneValeur(tsl_C, 'spe_patch'));
            spe_fait := Strtoint(tc.UneValeur(tsl_C, 'spe_fait'));
            IF spe_fait > spe_patch THEN
            BEGIN
            // Ya eu un gros problème
                spe_fait := 0;
                S := 'Update clients set spe_fait = 0 where id=' + idclient;
                tc.ordre(S, memo1);
            END;
            FOR i := spe_fait + 1 TO spe_patch DO
            BEGIN
            // script specifique
                label2.caption := 'Patching Spe script ' + inttostr(i); label2.Update;
                //S := LecteurLame+':\EAI\MAJ\Patch\' + GUID + '\script' + inttostr(i) + '.SQL';
                Nomrecup := 'http://lame2.no-ip.com/MAJ/Patch/' + GUID + '/script' + inttostr(i) + '.SQL';

                if Http1.GetWaitTimeOut(Nomrecup, 30000) then
                begin
                  Http1.SaveToFile(Nomrecup, LecteurLame+':\EAI\MAJ\Patch\' + GUID + '\script' + Inttostr(i) + '.SQL');
                  S := LecteurLame+':\EAI\MAJ\Patch\' + GUID + '\script' + inttostr(i) + '.SQL';
                  IF fileexists(S) THEN
                  BEGIN
                      tsl := TstringList.Create;
                      tsl.loadfromfile(S);
                      S := trim(tsl.Text);
                      tsl.free;
                      Nok := Patch(i, S);
                      IF NOK THEN
                      BEGIN
                    // erreur
                          LeJour := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
                          S := 'Insert into histo (id_cli, ladate, action, actionstr, str1) ' +
                              'value (' + idclient + ', "' + LeJour + '",7 ,"script' + Inttostr(i) + '.SQL", "A pantin")';
                          tc.ordre(S, memo1);
                          BREAK;
                      END
                      ELSE
                      BEGIN
                          S := 'Update clients set spe_fait = ' + Inttostr(i) + ' where id=' + idclient;
                          tc.ordre(S, memo1);
                          LeJour := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
                          S := 'Insert into histo (id_cli, ladate, action, actionstr, str1) ' +
                              'value (' + idclient + ', "' + LeJour + '",8 ,"script' + Inttostr(i) + '.SQL", "A pantin")';
                          tc.ordre(S, memo1);
                      END;
                  END;
                end;
              END;
        END;
        tc.FreeResult(tsl_C);
        caption := ' IBQue_Base 10';
        IBQue_Base.Next;
        caption := ' IBQue_Base 11';
    END;
    Que_Exists.Close;
    tc.FreeResult(tsl_V);
END;

PROCEDURE TForm1.CreationLog(NomClient, LaMachine, LaCentrale: STRING);
VAR
    S: STRING;
BEGIN
  //
    Que_logMag.Open;
    WHILE NOT Que_logMag.eof DO
    BEGIN
        S := NomClient + ';' + LaMachine + ';' + LaCentrale + ';' + Que_logMagMAG_IDENT.AsString + ';' + Que_logMagMAG_NOM.AsString;
        Que_LogPoste.ParamByName('ID').AsInteger := Que_logMagMAG_ID.AsInteger;
        Que_LogPoste.Open;
        WHILE NOT Que_LogPoste.Eof DO
        BEGIN
            S := S + ';' + Que_LogPostePOS_NOM.AsString;
            Que_LogPoste.next;
        END;
        Log.add(s);
        Que_LogPoste.Close;
        Que_logMag.next;
    END;
    Que_logMag.Close;
  //
END;

PROCEDURE TForm1.traitement_rtf;
VAR
    S: STRING;
BEGIN
    Caption := 'traitement rtf';
    SQL.Transaction.active := true;
    IBQue_Adresse.Open;
    WHILE NOT IBQue_Adresse.eof DO
    BEGIN
        S := LowerCase(IBQue_AdresseADR_LIGNE.AsString);
        WHILE pos(#10, s) > 0 DO
            delete(s, pos(#10, s), 1);
        WHILE pos(#13, s) > 0 DO
            delete(s, pos(#13, s), 1);
        Chp_Rtf.Lines.text := s;
        SQL.SQL.text := 'Update Genadresse set ADR_LIGNE = ' + quotedstr(Chp_Rtf.Text) + ' where ADR_ID = ' + IBQue_AdresseADR_ID.AsString;
        SQL.ExecQuery;
        IBQue_Adresse.next;
    END;
    IBQue_Adresse.close;
    IF SQL.Transaction.InTransaction THEN
    BEGIN
        SQL.Transaction.commit;
        SQL.Transaction.active := true;
    END;
END;

PROCEDURE TForm1.execute(Machine, databases: STRING);
VAR
    Xml: TmonXML;
    passXML: TIcXMLElement;
    passXML2: TIcXMLElement;
    LaBase: STRING;
    Tc: Tconnexion;
    NomClient: STRING;
    LaMachine: STRING;
    LaCentrale: STRING;

    XMLExecute: TmonXML;
    s: STRING;
    tsl: tstringList;
    XMLA: TIcXMLElement;
    _nom, _tipe, _data: STRING;
    tpJeton : TTokenParams;
    bJeton  : Boolean;        //Vrai si on a le jeton sinon faux
    i       : Integer;        //Compteur pour les jetons
BEGIN
    LogDebug('Trace.log','Execute traitement (Machine: '+Machine+' ; DataBases: '+ Databases);
    s := databases;
    WHILE pos('\', S) > 0 DO
        s[pos('\', S)] := '/';
    WHILE s[1] <> 'V' DO
        delete(S, 1, pos('/', s));
    s := Copy(S, 1, pos('/', s) - 1);
    caption := S;
    XMLExecute := TmonXML.Create;
    IF NOT FileExists(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + S + '.xml') THEN
    BEGIN
        tsl := tstringList.Create;
        tsl.add('<doc>');
        tsl.add('   <ORDRES>');
        tsl.add('   </ORDRES>');
        tsl.add('</doc>');
        tsl.savetofile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + S + '.xml');
        tsl.free;
    END;
    XMLExecute.LoadFromFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + S + '.xml');

    Xml := TmonXML.Create;
    Tc := Tconnexion.create;

    Label3.caption := databases;
    Label3.Update;
    xml.LoadFromFile(databases);
    passXML := Xml.find('/DataSources');
    pb.position := 0;
    pb.max := PassXML.GetNodeList.Length;
    passXML := Xml.find('/DataSources/DataSource');
    WHILE (PassXML <> NIL) DO
    BEGIN
        pb.position := pb.position + 1;

        NomClient := Xml.ValueTag(passXml, 'Name');
        passXML2 := xml.FindTag(passxml, 'Params');
        passXML2 := xml.FindTag(passxml2, 'Param');

        WHILE (passXML2 <> NIL) AND (Xml.ValueTag(passXML2, 'Name') <> 'SERVER NAME') DO
            passXML2 := passXML2.NextSibling;                       

        IF Xml.ValueTag(passXML2, 'Name') = 'SERVER NAME' THEN
        BEGIN
            LaBase := Xml.ValueTag(passXML2, 'Value');
            IF (labase <> '') THEN
            BEGIN
                IF pos(':', labase) < 3 THEN
                BEGIN
                    labase := machine + ':' + labase;
                END;
                LaMachine := copy(labase, 1, pos(':', labase) - 1);
                LaCentrale := labase;
                Delete(LaCentrale, 1, pos('\', LaCentrale));
                Delete(LaCentrale, 1, pos('\', LaCentrale));
                LaCentrale := Copy(LaCentrale, 1, pos('\', LaCentrale) - 1);

                Label2.caption := '';
                Label2.Update;
                Label1.caption := ('Traitement : ' + labase);
                memo1.lines.add(labase);
                Label1.Update;
                data.DatabaseName := labase;
                LogDebug('Trace.log','Traitement (LaMachine: '+LaMachine+' ; LaCentrale: '+LaCentrale+' ; labase: '+labase+' ; NomClient: '+NomClient);

                TRY
                  LogDebug('Trace.log','Récupération des paramétres des jetons');
                  tpJeton := GetParamsToken(labase,'ginkoia','ginkoia');    //Prise en compte des Jetons
                  bJeton  := False;

                  if tpJeton.bLectureOK then
                  begin
                    LogDebug('Trace.log','Prise de jeton');
                    i := 1;

                    while (not bJeton) and (i < 5) do
                    begin
                      bJeton  := StartTokenEnBoucle(tpJeton,30000);             //On rafraichi toute les 30s

                      if not bJeton then    //Si pas de jeton
                      begin
                        LogDebug('Trace.log','Impossible de prendre un Jeton');
                        memo1.lines.add('Impossible de prendre un Jeton. Tentative : '+ IntToStr(i) +' sur 3.');
                        sleep(30000);       //Pause de 30s
                        Inc(i);             //On incrémente le nombre d'essai
                      end;
                    end;
                  end;

                  LogDebug('Trace.log','Contrôle jeton bJeton = '+BoolToStr(bJeton)+' ; tpJeton.bLectureOK: ' + BoolToStr(tpJeton.bLectureOK));
                  if (bJeton and tpJeton.bLectureOK) or (not bJeton and not tpJeton.bLectureOK) then
                  begin
                    try
                      LogDebug('Trace.log','Ouverture de data');
                      data.open;
                      // On vérifie que les GUID existe
                      CreationGUID(NomClient, LaCentrale);
                      // recherche sur yellis du GUID de chaque base
                      AffecteYellis(TC, NomClient, LaMachine, LaCentrale);
                      // création du log
                      IF faitlelog THEN
                          CreationLog(NomClient, LaMachine, LaCentrale);
                      // traitement spécifique version
                      LogDebug('Trace.log','traitement spécifique version');
                      XMLA := XMLExecute.find('/doc/ORDRES/ORDRE');
                      WHILE XMLA <> NIL DO
                      BEGIN
                          _nom := XMLExecute.ValueTag(XMLA, 'NOM');
                          IF _nom <> '' THEN
                          BEGIN
                              _tipe := XMLExecute.ValueTag(XMLA, 'TYPE');
                              _data := XMLExecute.ValueTag(XMLA, 'DATA');
                              IF Xml.ValueTag(passXML2, _nom) <> 'NON' THEN
                                  TraiteXML(_nom, _tipe, _data);
                          END;
                          XMLA := XMLA.NextSibling;
                      END;
                      XMLA := XMLExecute.find('/doc/' + Uppercase(LaCentrale) + '/ORDRES/ORDRE');
                      WHILE XMLA <> NIL DO
                      BEGIN
                          _nom := XMLExecute.ValueTag(XMLA, 'NOM');
                          IF _nom <> '' THEN
                          BEGIN
                              _tipe := XMLExecute.ValueTag(XMLA, 'TYPE');
                              _data := XMLExecute.ValueTag(XMLA, 'DATA');
                              IF Xml.ValueTag(passXML2, _nom) <> 'NON' THEN
                                  TraiteXML(_nom, _tipe, _data);
                          END;
                          XMLA := XMLA.NextSibling;
                      END;
                      traitement_rtf;
                    finally                                                 
                      data.Close;
                      if bJeton then
                        StopTokenEnBoucle;      //Relache le jeton
                    end;
                  end
                  else
                  begin
                    LogDebug('Trace.log','Impossible de prendre un Jeton.');
                    memo1.lines.add('Impossible de prendre un Jeton.');
                  end;
                EXCEPT
                    LogDebug('Trace.log','prob sur la base');
                    memo1.lines.add('prob sur labase');
                END;

            END;
        END;
        PassXML := PassXML.NextSibling;
    END;
    xml.free;

END;

PROCEDURE TForm1.parcour(machine: STRING);
VAR
    f: tsearchrec;
    f2: tsearchrec;
    rep: STRING;
    sousrep:string;
    chemin:string;
BEGIN
    memo1.lines.add(machine + ' en cours');
    rep := '\\' + machine + '\'+LecteurLame+'$\EAI\';
    LogDebug('Trace.log','Parcour ' + rep);
    IF findfirst(rep + '*.*', faanyfile, f) = 0 THEN
    BEGIN
        REPEAT
            IF (Copy(f.name, 1, 1) = 'V') AND ((f.attr AND faDirectory) = faDirectory) AND (f.name<>'.') and (f.Name<>'..') THEN
            BEGIN
                sousrep := f.name;
                LogDebug('Trace.log','Parcour ' + rep + sousrep + '\*.*');
                IF findfirst(rep + sousrep + '\*.*', faanyfile, f2) = 0 THEN
                begin
                  repeat
                    IF ((f2.attr AND faDirectory) = faDirectory) AND (f2.name<>'.') and (f2.Name<>'..') THEN
                    BEGIN
                      chemin  := rep + sousrep + '\' + f2.name;
                      IF FileExists(rep + sousrep + '\' + f2.name + '\DelosQPMAgent.Databases.xml') THEN
                      BEGIN
                          execute(machine, rep + sousrep + '\' + f2.name + '\DelosQPMAgent.Databases.xml');
                      END;
                    END;
                  UNTIL findnext(f2) <> 0;
                end;
            END;
        UNTIL findnext(f) <> 0;
    END;
    findclose(f);
END;

PROCEDURE TForm1.GoClick(Sender: TObject);
VAR
    i: integer;
BEGIN
    LogDebug('Trace.log','Début traitement');
    faitlelog := true;
    log := Tstringlist.create;
    FOR i := 0 TO Cb_serveur.items.count - 1 DO
        IF Cb_serveur.Checked[i] THEN
            parcour(Cb_serveur.items[i]);
//   parcour('PASCAL_FIX');
    IF sender <> NIL THEN
        application.MessageBox('c''est fini', 'fini', mb_ok);
    log.savetofile(IncludeTrailingBackslash(ExtractFilePath(application.exename)) + 'Postes.txt');
    log.free;
    faitlelog := false;
    LogDebug('Trace.log','Fin traitement');
END;

function TForm1.LecteurValeurIni(AFileIni, ASection, AIdent,
  ADefault: String): String;
//Fonction de lecture d'une valeur dans le fichier Ini
Var
  FichierIni  : TIniFile;
begin
  Try
    //Ouverture ou création du fichier ini
    FichierIni  := TIniFile.Create(AFileIni);

    //Lecteur de la valeur
    Result := FichierIni.ReadString(ASection, AIdent, ADefault);
  Finally
    FichierIni.Free;
    FichierIni  := nil;
  End;
end;

procedure TForm1.LogDebug(FileLogName, Texte: String);
Var
  LogFile       : TextFile;   //Variable d'accès au fichier
  Chemin        : String;     //Chemin du fichier de log
Begin
  {$IFDEF DEBUG}
  ForceDirectories(IncludeTrailingPathDelimiter(ExtractFilePath(Chemin)));
  AssignFile(LogFile,Chemin+FileLogName);
  if Not FileExists(Chemin+FileLogName) then
    ReWrite(LogFile)
  else
    Append(LogFile);
  try
    Writeln(LogFile,DatetimeToStr(now)+#9#9+ '=> ' + Texte);
  finally
    CloseFile(LogFile);
  end;
  {$ENDIF}
end;

PROCEDURE TForm1.FormCreate(Sender: TObject);
VAR
    i: integer;
    sListFilePath : String;
BEGIN
    Form1.caption := Form1.caption + '   -   V'+GetNumVersionSoft;
    sListFilePath := ExtractFilePath(Application.ExeName) + 'GUID.lst';
    if FileExists(ExtractFilePath(Application.ExeName) + 'GUID.lst') then
      Cb_serveur.Items.LoadFromFile(sListFilePath);

    LecteurLame := LecteurValeurIni(IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'GUID.ini','GENERAL','LecteurLame','D');

    faitlelog := false;
    label1.caption := ''; label2.caption := '';
    Label3.caption := '';
    first := true;
    Version6plus := false;
    FOR i := 0 TO Cb_serveur.items.count - 1 DO
        Cb_serveur.Checked[i] := true;
END;

PROCEDURE TForm1.FormPaint(Sender: TObject);
BEGIN
    IF first THEN
    BEGIN
        first := false;
        IF paramcount > 0 THEN
        BEGIN
            GoClick(NIL);
            close;
        END;
    END;
END;

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    s: STRING;
    LaCentrale: STRING;
    LaMachine: STRING;
    NomClient: STRING;
    Tc: Tconnexion;
    tpJeton : TTokenParams;
    bJeton  : Boolean;        //Vrai si on a le jeton sinon faux
    i       : Integer;        //Compteur pour les jetons
BEGIN
    IF od.execute THEN
    BEGIN
        s := uppercase(od.filename);
        caption := s;
        if (LeftStr(s,1) = LecteurLame) then
        begin
          s := '\\SYMREPLIC1\' + rightStr(s,length(s)-3);
        end;
        
        IF copy(s, 1, 2) = '\\' THEN
        BEGIN

            Tc := Tconnexion.create;
            delete(s, 1, 2);
            i := pos('\', s);
            insert(':'+LecteurLame+':', s, i);
            data.DatabaseName := s;

            s := uppercase(od.filename);
            delete(s, 1, 2);
            LaMachine := Copy(s, 1, pos('\', s) - 1);
            delete(s, 1, pos('\', s));
            IF s[1] = '\' THEN delete(s, 1, 1);

            delete(s, 1, pos('\', s));
            IF s[1] = '\' THEN delete(s, 1, 1);

            LaCentrale := Copy(s, 1, pos('\', s) - 1);
            delete(s, 1, pos('\', s));
            IF s[1] = '\' THEN delete(s, 1, 1);

            NomClient := Copy(s, 1, pos('\', s) - 1);
            TRY
              tpJeton := GetParamsToken(data.DatabaseName,'ginkoia','ginkoia');    //Prise en compte des Jetons
              bJeton  := False;

              if tpJeton.bLectureOK then
              begin
                i := 1;

                while (not bJeton) and (i < 5) do
                begin
                  bJeton  := StartTokenEnBoucle(tpJeton,30000);             //On rafraichi toute les 30s

                  if not bJeton then    //Si pas de jeton
                  begin
                    memo1.lines.add('Impossible de prendre un Jeton. Tentative : '+ IntToStr(i) +' sur 3.');
                    sleep(30000);       //Pause de 30s
                    Inc(i);             //On incrémente le nombre d'essai
                  end;
                end;
              end;

              if (bJeton and tpJeton.bLectureOK) or (not bJeton and not tpJeton.bLectureOK) then
              begin
                try
                  data.open;
                  // On vérifie que les GUID existe
                  CreationGUID(NomClient, LaCentrale);
                  // recherche sur yellis du GUID de chaque base
                  AffecteYellis(TC, NomClient, LaMachine, LaCentrale);

                  traitement_rtf;

                finally
                  data.Close;
                  if bJeton then
                    StopTokenEnBoucle;      //Relache le jeton
                end;
              end
              else
              begin
                memo1.lines.add('Impossible de prendre un Jeton.');
              end;
            EXCEPT
                memo1.lines.add('prob sur labase');
            END;

            tc.free;
        END;
    END;
END;

PROCEDURE TForm1.Button2Click(Sender: TObject);
VAR
    s: STRING;
    Machine: STRING;
BEGIN
    IF OdDatabases.execute THEN
    BEGIN
        S := OdDatabases.FileName;
        IF pos('//', s) = 1 THEN
        BEGIN
            delete(S, 1, 2);
            Machine := Copy(S, 1, pos('/', s) - 1);
            execute(Machine, OdDatabases.FileName);
        END
        ELSE
            execute(Machine, OdDatabases.FileName);
    END;
END;

PROCEDURE TForm1.TraiteXML(_Nom, _tipe, _data: STRING);
VAR
    S: STRING;
BEGIN
    IF _tipe = 'CREATE_AND_DROP_PROCEDURE' THEN
    BEGIN
        tran2.active := true;
        TRY
            sql.sql.text := _data;
            sql.ExecQuery;
            IF tran2.InTransaction THEN
                tran2.commit;
            tran2.active := true;
            sql.sql.text := 'EXECUTE PROCEDURE ' + _Nom;
            sql.ExecQuery;
            IF tran2.InTransaction THEN
                tran2.commit;
            tran2.active := true;
            sql.sql.text := 'DROP PROCEDURE ' + _Nom;
            sql.ExecQuery;
            IF tran2.InTransaction THEN
                tran2.commit;
            tran2.active := true;
        EXCEPT
            on E: Exception do
            memo1.lines.add('prob sur CREATE_AND_DROP_PROCEDURE ' + _Nom+ ' ' + E.Message);
        END;
    END
    ELSE IF _tipe = 'PROCEDURE' THEN
    BEGIN
        tran2.active := true;
        TRY
            sql.sql.text := _data;
            sql.ExecQuery;
            IF tran2.InTransaction THEN
                tran2.commit;
            tran2.active := true;
        EXCEPT
            //on E: Exception do MsgDialog(E.Message, E.HelpContext);
            on E: Exception do
            memo1.lines.add('Prob sur PROCEDURE ' + _data + ' ' + E.Message);
        END;
    END;
    IF _tipe = 'QUERY' THEN
    BEGIN
        WHILE _data <> '' DO
        BEGIN
            IF pos(';', _data) > 0 THEN
            BEGIN
                s := copy(_data, 1, pos(';', _data) - 1);
                delete(_data, 1, pos(';', _data));
            END
            ELSE
            BEGIN
                s := _data;
                _data := '';
            END;
            IF trim(s) <> '' THEN
            BEGIN
                tran2.active := true;
                TRY
                    sql.sql.text := s;
                    sql.ExecQuery;
                    IF tran2.InTransaction THEN
                        tran2.commit;
                    tran2.active := true;
                EXCEPT
                    on E: Exception do
                    begin
                    memo1.lines.add('prob sur la QUERY ' + _data+ ' ' + E.Message);
                    BREAK;
                    end;
                END;
            END;
        END;
    END;
END;

END.


//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Export_frm;

INTERFACE

USES
//    Fileutil,
    FtpThread,
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    AlgolStdFrm,
    dxTL,
    dxDBCtrl,
    dxDBGrid,
    dxCntner,
    dxDBGridRv,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    dxmdaset,
    Db,
//    IBDataset,
    IB_Components,
    LMDCustomComponent,
    LMDIniCtrl,
    StdCtrls,
    RzLabel,
//    PSCMonthsBox,
    ExtCtrls,
    RzPanel,
    RzPanelRv,
    wwdbdatetimepicker,
    wwDBDateTimePickerRv,
    Mask,
    DBCtrls,
    RzDBEdit,
    RzDBBnEd,
    RzDBButtonEditRv,
//    Psock,
//    NMFtp,
    IB_Process, IB_Script, wwDialog, wwidlg, wwLookupDialogRv,
//    NMsmtp,
    UserDlg, IBODataset, LMDBaseGraphicControl,
    ParamLogiciel_frm, UVersion, ComCtrls,DateUtils;

TYPE
    TFrmBase = CLASS(TAlgolStdFrm)
        Que_Exp: TIBOQuery;
        Que_ExpL_STKFIN: TIBOFloatField;
        Que_ExpL_VTECANET: TIBOFloatField;
        Que_ExpL_VTENBR: TIBOFloatField;
        Que_ExpARTID: TIntegerField;
        Que_ExpARFCHRONO: TStringField;
        Que_ExpARTNOM: TStringField;
        Que_ExpMRKNOM: TStringField;
        Que_ExpARTREFMRK: TStringField;
        MemD_Export: TdxMemData;
        MemD_ExportExport: TStringField;
        Database: TIB_Connection;
        IniCtrl_npd: TLMDIniCtrl;
        RzPanelRv1: TRzPanelRv;
        SBtn_Cancel: TLMDSpeedButton;
        SBtn_Ok: TLMDSpeedButton;
        Timer1: TTimer;
        Que_ExpRAYON: TStringField;
        Que_ExpFAMILLE: TStringField;
        Que_ExpSOUSFAM: TStringField;
        IbC_Mag: TIB_Cursor;
        Que_Drop: TIBOQuery;
        IB_Script1: TIB_Script;
        MemD_Sem: TdxMemData;
        MemD_Semnum: TStringField;
        MemD_Semdebut: TStringField;
        MemD_Semfin: TStringField;
        MemD_Semdimanche: TStringField;
        LK_Sem: TwwLookupDialogRV;
//        NMSMTP1: TNMSMTP;
        LMDSpeedButton2: TLMDSpeedButton;
        MemD_Mag: TdxMemData;
        MemD_MagNUMERO: TStringField;
        MemD_MagCLIENT: TStringField;
        MemD_MagNOMFICHIER: TStringField;
        MemD_MagCHEMIN: TStringField;
        MemD_MagMAGASIN: TStringField;
        MemD_MagCENTRALE: TStringField;
        Dlg_NPD: TUserDlg;
    Nbt_ParamLogiciel: TLMDSpeedButton;
    Lab_client: TRzLabel;
    PanelInfo: TPanel;
    Nbt_TraitementAll: TLMDSpeedButton;
    ProgressBar1: TProgressBar;
    Lab_plage: TLabel;
    Lab_etape: TLabel;

        PROCEDURE AlgolStdFrmActivate(Sender: TObject);
        PROCEDURE SBtn_OkClick(Sender: TObject);
        PROCEDURE SBtn_CancelClick(Sender: TObject);
//        PROCEDURE NMFTP1Success(Trans_Type: TCmdType);
//        PROCEDURE NMFTP1Error(Sender: TComponent; Errno: Word; Errmsg: STRING);
//        PROCEDURE NMFTP1Failure(VAR Handled: Boolean; Trans_Type: TCmdType);
        PROCEDURE LMDSpeedButton2Click(Sender: TObject);
    procedure Nbt_ParamLogicielClick(Sender: TObject);
    procedure AlgolStdFrmCreate(Sender: TObject);
    procedure Nbt_TraitementAllClick(Sender: TObject);
    PRIVATE
    { Private declarations }
        mois, annee: word;
        Ville, centrale, Pantin, Magasin: STRING;
        MagId: integer;
       
        DtDebut, Dtfin: tdatetime;
        dsk: STRING;
        semaine: STRING;

        PROCEDURE Creation(ident: STRING);
        PROCEDURE traitement;
    PROTECTED
    { Protected declarations }
        ftp: TFtpThread;
    PUBLIC
    { Public declarations }
    PUBLISHED
    { Published declarations }
    END;

VAR
    FrmBase: TFrmBase;

IMPLEMENTATION
{$R *.DFM}

USES
    stdutils,
//    ChxMois_Frm,
    StdDateUtils, p_Frm, SelMag_frm,upost;

PROCEDURE TFrmBase.AlgolStdFrmActivate(Sender: TObject);
VAR
    sPathApp : String;

    Ye, Mo, Da: Word;

BEGIN

    sPathApp := ExtractFilePath(Application.ExeName);

    //Chargement des magasins à traiter
    memd_mag.DelimiterChar := ';';
    memd_mag.loadfromtextfile(IniCtrl_npd.ReadString('DIR','LSTMAG',sPathapp + 'magasin.csv'));
//    ExtractFilePath(application.exename) + 'magasin.csv');

    //On determine le mois à traiter (Mois précédent)

    DecodeDate(Now, Ye, Mo, Da);
    annee := ye;

    dsk := ExtractFilePath(application.exename);
    memd_sem.close;
    MemD_sem.DelimiterChar := ';';
    MemD_sem.LoadFromTextFile(IniCtrl_npd.ReadString('DIR','LSTSEMAINE',sPathApp + 'semaine.csv'));

    IF DayOfWeek(date) = 1 THEN
    BEGIN // c'est dimache on va trouver la date
        IF memd_sem.locate('dimanche', datetostr(date), []) THEN
        BEGIN // C'est ok tout en automatique...
            Traitement;
            application.terminate;
            EXIT;
        END;
    END;
END;

PROCEDURE TfrmBase.Traitement;
VAR
    i, nbre, port: integer;
    ident, chemin, client: STRING;
    mm, aa, aaaa: STRING;
    user,mp,host,dest:string;
    mess,desti: tstringlist;
    txt:string;
    passive : Boolean;
BEGIN
    mess:=tstringlist.create;
    desti:=tstringlist.create;

    nbre := 0;
    DtDebut := strtodate(MemD_Semdebut.asstring);
    Dtfin := strtodate(MemD_SemFin.asstring);
    semaine := MemD_Semnum.asstring;

    //Création et init FTP
    ftp := TFtpThread.create(self);

    user := IniCtrl_NPD.readString('FTP', 'user', '');
    mp := IniCtrl_NPD.readString('FTP', 'mp', '');
    host := IniCtrl_NPD.readString('FTP', 'host', '');
    dest := IniCtrl_NPD.readString('FTP', 'dest', '');
    port := IniCtrl_npd.ReadInteger('FTP','PORT',21);
    passive := IniCtrl_npd.ReadBool('FTP','PASSIVE',True);
    ftp.init(user,mp,host,dest,port,passive);

    aaaa := inttostr(YearOf(DtDebut));

    //Création des répertoires
    createdir(dsk +  aaaa);
    createdir(dsk + aaaa + '\' + 'S' + semaine);

    //mail
//    NMSMTP1.PostMessage.Body.clear;
//    NMSMTP1.PostMessage.Body.add('Semaine ' + semaine);
    mess.clear;
    mess.add('Semaine ' + semaine);

    lab_client.visible := True;

    database.connected := false; //On sait jamais...
    memd_mag.first;
    WHILE NOT memd_mag.eof DO
    BEGIN
        Ident := MemD_MagNUMERO.asstring;

        //Chemin de la base
        chemin := MemD_MagCHEMIN.asstring;

        //Nom du client
        client := MemD_MagCLIENT.asstring;
        lab_client.caption := 'Client en cours : ' + client;

        //Ville du mag qui sera une partie du nom du fichier TXT
        Ville := MemD_MagNOMFICHIER.asstring;

        //Centrale TW ou SP encore ppour le nom du fichier TXT
        Centrale := MemD_MagCENTRALE.asstring;

        //Connection à la base
        database.databasename := chemin;
        TRY
            database.connected := true;

        //Nom du magasin pour les multi-magasins
            Magasin := MemD_MagMAGASIN.asstring;
            IF magasin = '' THEN
                magid := -1
            ELSE
            BEGIN
                ibc_mag.close;
                ibc_mag.parambyname('mag_nom').asstring := magasin;
                ibc_mag.open;
                IF ibc_mag.eof THEN
                BEGIN
                    MessageDlg('Connection à la base impossible ' + magasin, mtError, [], 0);
                    application.terminate;
                END
                ELSE
                    magid := ibc_mag.fieldbyname('mag_id').asinteger;
            END;

//          TRY Que_Drop.ExecSQL; EXCEPT END;
//          IB_Script1.Execute;
            inc(nbre);

        //Appel de la procedure stockée
            PanelInfo.Caption := 'Recherche données magasin '+magasin+' en cours ....';

            que_exp.parambyname('magid').asinteger := MagId;
            que_exp.parambyname('ddeb').asdate := dtdebut;
            que_exp.parambyname('dfin').asdate := dtfin;
            que_exp.open;
            PanelInfo.Caption := 'Traitement données magasin '+magasin+' en cours ....';

        //Création du fichier Texte résultat
            Creation(ident);
            PanelInfo.Caption := 'Traitement données magasin '+magasin+' terminé';

        //Déconnection de la base
            database.connected := false;

        //Mail
            // NMSMTP1.PostMessage.Body.add(Client + ' / ' + magasin);
            mess.add(Client + ' / ' + magasin);
        EXCEPT
        //Mail
            //NMSMTP1.PostMessage.Body.add(Client + ' / ' + magasin + '/ *** NON TRAITE ***');
            mess.add(Client + ' / ' + magasin + '/ *** NON TRAITE ***');
        END;

        memd_mag.next;
    END;

    WHILE NOT ftp.vide DO
    BEGIN
        Sleep(250);
        Application.processmessages;
    END;
    ftp.Terminate;

       //Envoi du mail...
//    NMSMTP1.Host := IniCtrl_NPD.readString('MAIL', 'host', '');  //mail.netsecurity.fr
//    NMSMTP1.UserID := 'mp1304-10';
//    NMSMTP1.PostMessage.Subject := 'Export NPD';
//    NMSMTP1.PostMessage.FromAddress := 'bruno.nicolafrancesco@ginkoia.fr';
//    NMSMTP1.PostMessage.FromName := 'Export NPD';
//
//    NMSMTP1.PostMessage.ToAddress.Add(IniCtrl_NPD.readString('MAIL', '1', ''));
//    NMSMTP1.PostMessage.ToAddress.Add(IniCtrl_NPD.readString('MAIL', '2', ''));
//    NMSMTP1.PostMessage.ToAddress.Add(IniCtrl_NPD.readString('MAIL', '3', ''));
//    NMSMTP1.PostMessage.ToAddress.Add(IniCtrl_NPD.readString('MAIL', '4', ''));
//    NMSMTP1.PostMessage.ToAddress.Add(IniCtrl_NPD.readString('MAIL', '5', ''));

      desti.clear;
      for i:=1 to 5 do
      begin
          txt:=IniCtrl_NPD.readString('MAIL', inttostr(i), '');
          IF txt<>'' THEN desti.add(txt);
      END;

      mess.add(inttostr(nbre) + ' Magasins traites');


//    NMSMTP1.PostMessage.Body.add(inttostr(nbre) + ' Magasins traites');
//    NMSMTP1.Connect;
//    NMSMTP1.SendMail;
//    NMSMTP1.Disconnect;

    sendmail('bruno.nicolafrancesco@ginkoia.fr', desti.text, 'Export NPD',mess.text);

    lab_client.visible := False;
    EXIT;

END;

procedure TFrmBase.AlgolStdFrmCreate(Sender: TObject);
begin
  Caption := 'Export NPD Sports Tracking Europe v' + GetNumVersionSoft;
end;

PROCEDURE TfrmBase.Creation(ident: STRING);
VAR
    zone: STRING; //[430];
    tmp, mm, aa, aaaa: STRING;
    posi: integer;
//    Tsl: TstringList;
    Cpt : Integer;
BEGIN

    aaaa := inttostr(annee);

    memd_export.close;
    memd_export.open;
    que_exp.first;
    Cpt := 0;
    Update;
    WHILE NOT que_exp.eof DO
    BEGIN
      Cpt := Cpt + 1;
      PanelInfo.Caption := 'Traitement ligne ' + IntToStr(Cpt);
      Application.ProcessMessages;

        // Application.ProcessMessages;
        IF NOT ftp.vide THEN
            Application.ProcessMessages;
        zone := spacesstr(366);

        Insert(ident, zone, 1);

        tmp := que_expARFCHRONO.asstring;
        IF length(tmp) > 14 THEN tmp := copy(tmp, 1, 14);
        Insert(tmp, zone, 11);

        tmp := que_expARTNOM.asstring;
        IF length(tmp) > 36 THEN tmp := copy(tmp, 1, 36);
        Insert(tmp, zone, 25);

        tmp := que_expMRKNOM.asstring;
        IF length(tmp) > 30 THEN tmp := copy(tmp, 1, 30);
        Insert(tmp, zone, 61);

        tmp := que_expARTREFMRK.asstring;
        IF length(tmp) > 15 THEN tmp := copy(tmp, 1, 15);
        Insert(tmp, zone, 97);

        tmp := floattostrf(que_expL_VTENBR.asfloat, ffFixed, 7, 0);
        tmp := AlignLeft(tmp, #32, 7);
        Insert(tmp, zone, 128);

        IF que_expL_VTENBR.asfloat <> 0 THEN
        BEGIN
            tmp := floattostrf(que_expL_VTECANET.asfloat / que_expL_VTENBR.asfloat, ffFixed, 7, 2);
            tmp := AlignLeft(tmp, #32, 7);
            Insert(tmp, zone, 135);
        END;

        tmp := floattostrf(que_expL_VTECANET.asfloat, ffFixed, 7, 2);
        tmp := AlignLeft(tmp, #32, 10);
        Insert(tmp, zone, 142);

        tmp := floattostrf(que_expL_STKFIN.asfloat, ffFixed, 7, 0);
        tmp := AlignLeft(tmp, #32, 7);
        Insert(tmp, zone, 152);

        //Insert(mm, zone, 167);
        Insert(semaine, zone, 167);
        Insert(aaaa, zone, 169);

        Insert(que_expRayon.asstring, zone, 175);
        Insert(que_expFamille.asstring, zone, 239);
        Insert(que_expSousFam.asstring, zone, 303);

        //Insert du code fedas
        posi:=pos('[',que_expsousfam.asstring);
        IF posi<>0 then
             Insert(substr(que_expsousfam.asstring,posi+1,6), zone, 350)
        else
             Insert('      ', zone, 350);

        memd_export.insert;
        memd_export.fieldbyname('export').asstring := zone;
        memd_export.post;

        que_exp.next;
    END;

    ForceDirectories(dsk +  aaaa + '\' + 'S' + semaine + '\');
    memd_export.SaveToTextFile(dsk  + aaaa + '\' + 'S' + semaine + '\' + centrale + Ville + semaine + '.txt');

    // copie par le thread
    ftp.ajoute(dsk + aaaa + '\' + 'S' + semaine + '\' + centrale + Ville + semaine + '.txt', centrale + Ville + semaine + '.txt');

END;

PROCEDURE TFrmBase.SBtn_OkClick(Sender: TObject);
VAR
    Debut, Fin: TDateTime;
BEGIN
    CASE dlg_npd.show OF
        2: EXIT;
        1: IF NOT executeselmag THEN EXIT;
    END;

    IF lk_sem.execute THEN
    BEGIN
        Traitement;
        application.terminate;
    END;

END;

PROCEDURE TFrmBase.SBtn_CancelClick(Sender: TObject);
BEGIN
    application.terminate;
END;

//PROCEDURE TFrmBase.NMFTP1Success(Trans_Type: TCmdType);
//BEGIN
////MessageDlg('OK', mtWarning, [mbYes], 0);
//END;
//
//PROCEDURE TFrmBase.NMFTP1Error(Sender: TComponent; Errno: Word;
//    Errmsg: STRING);
//BEGIN
////MessageDlg('Error', mtWarning, [mbYes], 0);
//END;
//
//PROCEDURE TFrmBase.NMFTP1Failure(VAR Handled: Boolean;
//    Trans_Type: TCmdType);
//BEGIN
////MessageDlg('failure', mtWarning, [mbYes], 0);
//END;

PROCEDURE TFrmBase.LMDSpeedButton2Click(Sender: TObject);
BEGIN
    param;
    memd_mag.DelimiterChar := ';';
    memd_mag.loadfromtextfile(ExtractFilePath(application.exename) + 'magasin.csv');

END;

procedure TFrmBase.Nbt_ParamLogicielClick(Sender: TObject);
begin
  ExecuteParamLogiciel(IniCtrl_npd);
end;

procedure TFrmBase.Nbt_TraitementAllClick(Sender: TObject);
var
  deb, fin : string;
  i : integer;
begin
  MemD_Sem.Last;
  fin := MemD_SemFin.asstring;
  MemD_Sem.First;
  deb := MemD_Semdebut.asstring;
  Lab_plage.Caption := 'Plage du traitement : ' + deb + ' à ' + fin;
  ProgressBar1.Max := MemD_Sem.RecordCount;
  ProgressBar1.Min := 0;
  ProgressBar1.Step := 1;
  i := MessageDlg('Traitement du ' + deb + ' au ' + fin + #13#10 + 'Continuer ?', mtCustom, [mbYes, mbNo], 0);
  if i = 6 then
  begin
    while not MemD_Sem.eof do
    begin
      Lab_etape.Caption := 'Etape du traitement : ' + MemD_Semdebut.asstring + ' à ' + MemD_SemFin.asstring;
      ProgressBar1.StepIt;
      Application.ProcessMessages;
      Traitement;
      MemD_Sem.Next;
    end;
    ProgressBar1.StepIt;
    showmessage('Terminé');
  end;
end;

END.


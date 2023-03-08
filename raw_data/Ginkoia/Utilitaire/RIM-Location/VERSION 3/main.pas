unit main ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ReservationResStr, dmReservation, ReservationType_Defs,
  strUtils, ReservationSport2k_Defs, uLOgfile, ReservationSkimium_Defs, ReservationTwinner_Defs,
  ReservationGenerique_Defs, ReservationInterSport_Defs, Main_dm,
  IdMessage, IdAttachment, stdutils, R2D2, StdCtrls, RzLabel, Progbr3d,
  LMDControl, LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, ExtCtrls, RzPanel, messagebox_frm, IdBaseComponent, IdCoder,
  IdCoder3to4, IdCoderMIME, Shellapi, IdAntiFreezeBase, IdAntiFreeze, ImgList, uImap4, DB,
  Ulog,Inifiles,DateUtils, dbugintf, Diagnostic_frm;

type
  TFmain = class(TForm)
    Pan_Fond: TRzPanel;
    Pan_Btn: TRzPanel;
    Gge_A: ProgressBar3D;
    Pan_Text: TRzPanel;
    Memo_Mess: TRzLabel;
    IdAntiFreeze: TIdAntiFreeze;
    Lim_lstimage: TImageList;
    TrayIcon1: TTrayIcon;
    procedure ExecuteTraitementReservation ;
    Procedure ArchivMail(MaCentrale : TGENTYPEMAIL;MaCFG : TCFGMail; reprejet : string = '');
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    { Déclarations privées }
    procedure FindeSessionWindows(var aMsg : Tmessage); message WM_ENDSESSION ;
  public
    { Déclarations publiques }
  oLogfile : Tlogfile ;
  Fdatabase : string ;
  FAuto : boolean  ; // mode auto = true mode ginkoia = false
  FPostid, Fmagid : integer ;
  FAlgol : boolean ;
  Ferrorconnect : boolean ; // pour distinguer l'erreur de connexion de l'erreur de traitement

  procedure SetDatabase(sDatabase : string) ;
  procedure InitGauge(sMessage : string ;MaxValue : integer) ;
  procedure UpdateGauge ;
  procedure ResetGauge ;

  procedure ShowmessageRS(sMessage, sTitle : string) ; overload;
  procedure ShowmessageRS(sMessage, sTitle : string; bDetail : boolean) ; overload;

  procedure trclog(smsg:string);
  procedure p_maj_etat(setat : string);

  end;

const

  //SK7
  CSKI7    = 'RESERVATION SKISET';

var
  Fmain: TFmain;
  itrc:integer; //PDB - niveau de tracing 1,2,3
  cpt_x : integer = 0; //comptage des exceptions
  cpt_e : integer = 0; //comptage des erreurs/problèmes
  cpt_a : integer = 0; //comptage des abandons
  cpt_r : integer = 0; //comptage des réussis

  //TWGS
  cpt_centrale : integer;
  iId_centrale : integer;

  sNom_centrale : string;

  //SK7
  RimIni : TIniFile;
  sdate_begin,sdate_end : string;
  ddate_begin,ddate_end : tdatetime;
  bok_date_begin,bok_date_end : boolean;
  idecal:integer;
  bok_sk7 : boolean;
  FSetting : TFormatSettings;

  bISF : boolean;

  // CVI - Variables pour récupération info client non ISF
  sClient_Id : string;
  sClient_Nom : string;
  sClient_Prenom : string;
  sClient_Email : string;

  //Variable de travail
  bnotallow : boolean;          //Remonte l'absence d'autorisation d'exécuter l'intégration
  scodeadh : string;            //Remonte le code adhérent en cour de traitement
  bcreation_init_oc : boolean;  //Remonte le fait qu'on est en création d'OC initial
  bcreation_oc : boolean;       //Remonte le fait qu'on est en création d'OC
  bparcours_oc : boolean;       //Indivateur de parcours des OC
  irecno_memd : integer;        //Conserve le dernier n° re record traité dans memd_mail
  berreur_codeadh : boolean;    //Remonte une erreur sur le code adhérent
  sbadxml : string;             //Conserve le n° de résa pour une erruer d'XML
  icptnoresa : integer;         //Compteur de centrales sans réservations


  vdebut_exec : tdatetime;
  vfin_exec : tdatetime;


implementation

{$R *.dfm}

USes udevexpresstranslate;

//PDB - Procedure de tracing et d'alimentation de la fenêtre de Diagnostic suivant la nature des cas
procedure TFmain.trclog(smsg:string); //PDB
var
  i:integer;
  sprem,si:string;
  scritcentrale,scritnumresa : string;
  bmulti : boolean;
  sraison : string;
begin
  if itrc>0 then begin
    if length(smsg)>1 then
    begin
      si:=smsg; //passage du message en variable locale
      sprem:=si[1]; //1er caractère

      //senddebug('bISF = ' + BoolToStr(bISF));
      senddebug(smsg);

      //Pour éviter l'événement onAfterPost sur le MemD_Reservations
      FDiagnostic.bLoad := true;

      // Si c'est un M : message dans le bas de la fenêtre uniquement
      if sprem = 'M' then
      begin
        // On écrit dans le Memo_Global
        FDiagnostic.label_global.Caption := copy(si,2);
        Ulog.Log.Log('RIM','Status',copy(si,2),logInfo,false,-1,ltLocal);
        FDiagnostic.bLoad := false;
        exit;
      end;


      // Indicateur Q pour indiquer de ne pas afficher la fenêtre de diagnostic.
      // Dans le cas où une erreur en amont contredirait le fait de devoir l'afficher (pas de centrale, pas de config mail, erreur d'acces au mail,...)
      if sprem = 'Q' then
      begin
        FDiagnostic.bdonotshow := true;
      end
      else
      begin

        if sprem<>'T' then
        begin

          try

            FDiagnostic.MemD_Reservations.Open;
            bmulti := false;

            if Assigned(dm_Reservation) then
            begin
              if Assigned(dm_reservation.MemD_Mail) AND Assigned(dm_reservation.MemD_Rap) then
              begin

                scritcentrale:=sNom_centrale;

                //G=F mais avec l'ajout d'une nouvelle ligne forcée pour le cas de la non correspondance du code adhérent
                if sprem='G' then
                begin
                  FDiagnostic.MemD_Reservations.Append;
                  FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := sNom_centrale+ ' ('+ scodeadh +')';
                  //if scodeadh<>''
                  //    then FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString+ ' ('+scodeadh+')';
                end

                else begin

                  (*
                  if bISF
                    then scritnumresa := trim(dm_reservation.MemD_Rap.FieldByName('Web').AsString)
                    else scritnumresa := trim(dm_reservation.MemD_Mail.FieldByName('MailIdResa').AsString);
                  *)

                  if scritnumresa<> '' then begin

                    //On vérifie si ce n'est pas une erreur de corruption XML.
                    //Pour éviter de sortir plusieurs fois a même erreur à différents endroits
                    (*
                    if pos('Erreur XML',copy(si,2))>0 then
                    begin
                      if pos(scritnumresa+';',sbadxml)=0 then
                      begin
                        //On laisse aller et on concatène pour le prochain passage
                        senddebug('Erreur XML sur résa nouveau : '+scritnumresa);
                        sbadxml := sbadxml + scritnumresa+';';
                      end
                      else begin
                        //Déjà traité, on sort
                        senddebug('Erreur XML sur résa déjà traitée : '+scritnumresa);
                        FDiagnostic.bLoad := false;
                        exit;
                      end;
                    end;
                    *)

                    //On vérifie si il n'ya pas déjà une ligne pour ce couple central+resa
                    if FDiagnostic.MemD_Reservations.Locate('Centrale;NumResa',VarArrayOf([scritcentrale,scritnumresa]),[loCaseInsensitive])
                      then begin
                        //Oui on edit
                        FDiagnostic.MemD_Reservations.Edit;
                        bmulti := true;
                        senddebug('---Message multiple pour couple centrale+résa');
                      end
                      //Non on append
                      else FDiagnostic.MemD_Reservations.Append;
                  end
                  else begin
                    FDiagnostic.MemD_Reservations.Append;
                  end;
                end;

                FDiagnostic.MemD_Reservations.FieldByName('Quand').AsDateTime := Now;

                if sprem<>'G' then
                begin

                  if bISF then
                  begin

                    //FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := sNom_centrale;
                    //if scodeadh<>''
                    //  then FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString+ ' ('+scodeadh+')';
                    if sprem='A'
                      then FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := sNom_centrale
                      else FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := sNom_centrale + ' ('+ dm_reservation.MemD_Mail.FieldByName('scodeadh').AsString +')';

                    //FDiagnostic.MemD_Reservations.FieldByName('Date').AsDateTime := dm_reservation.MemD_Rap.FieldByName('Deb').AsDateTime;
                    //PDB - Prendre la date du mail et pas celui de ma résa
                    FDiagnostic.MemD_Reservations.FieldByName('Date').AsDateTime := dm_reservation.MemD_Mail.FieldByName('MailDate').AsDateTime;

                    if trim(dm_reservation.MemD_Mail.FieldByName('MailIdResa').AsString)<>''
                      then FDiagnostic.MemD_Reservations.FieldByName('NumResa').AsString := dm_reservation.MemD_Mail.FieldByName('MailIdResa').AsString
                    else if trim(dm_reservation.MemD_Rap.FieldByName('Web').AsString)<>''
                      then FDiagnostic.MemD_Reservations.FieldByName('NumResa').AsString := dm_reservation.MemD_Rap.FieldByName('Web').AsString
                      else FDiagnostic.MemD_Reservations.FieldByName('NumResa').AsString := '<Non disponible>';

                    if trim(dm_reservation.MemD_Rap.FieldByName('client').AsString)<>''
                      then FDiagnostic.MemD_Reservations.FieldByName('Client').AsString := dm_reservation.MemD_Rap.FieldByName('client').AsString
                      else FDiagnostic.MemD_Reservations.FieldByName('Client').AsString := '<Non disponible>';

                  end else
                  begin

                    //FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := sNom_centrale;
                    //if scodeadh<>''
                    //  then FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString+ ' ('+scodeadh+')';
                    if sprem='A'
                      then FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := sNom_centrale
                      else FDiagnostic.MemD_Reservations.FieldByName('Centrale').AsString := sNom_centrale + ' ('+ dm_reservation.MemD_Mail.FieldByName('scodeadh').AsString +')';

                    FDiagnostic.MemD_Reservations.FieldByName('Date').AsDateTime := dm_reservation.MemD_Mail.FieldByName('MailDate').AsDateTime;
                    if trim(dm_reservation.MemD_Mail.FieldByName('MailIdResa').AsString)<>''
                      then FDiagnostic.MemD_Reservations.FieldByName('NumResa').AsString := dm_reservation.MemD_Mail.FieldByName('MailIdResa').AsString
                      else FDiagnostic.MemD_Reservations.FieldByName('NumResa').AsString := '<Non disponible>';
                    if sClient_Nom<>'' then
                    begin
                      if sClient_Nom<>'<Non disponible>'
                        then FDiagnostic.MemD_Reservations.FieldByName('Client').AsString := sClient_Prenom + ' ' + sClient_Nom
                        else FDiagnostic.MemD_Reservations.FieldByName('Client').AsString := sClient_Nom;
                    end
                      else FDiagnostic.MemD_Reservations.FieldByName('Client').AsString := '<Non disponible>';

                  end;

                  //Stocker le sujet+date du mail pour demande d'archivage manuelle potentielle ultérieure
                  FDiagnostic.MemD_Reservations.FieldByName('MailSubject').AsString := dm_reservation.MemD_Mail.FieldByName('MailSubject').AsString;
                  FDiagnostic.MemD_Reservations.FieldByName('MailDate').AsDateTime := dm_reservation.MemD_Mail.FieldByName('MailDate').AsDateTime;

                end;


                //Ne rien afficher si date nil/0
                if FDiagnostic.MemD_Reservations.FieldByName('Date').AsDateTime = 0
                  then FDiagnostic.MemD_Reservations.FieldByName('Date').Asstring := '';

              end;
            end;
            FDiagnostic.MemD_Reservations.FieldByName('Rejet').AsInteger := 0;

            //On concatène les raisons...
            if bmulti then begin
              senddebug('---Message multiple on concatène la raison : '+copy(si,2));
              FDiagnostic.MemD_Reservations.FieldByName('Raison').AsString := FDiagnostic.MemD_Reservations.FieldByName('Raison').AsString  + #13+#10+ copy(si,2);
            end
            else FDiagnostic.MemD_Reservations.FieldByName('Raison').AsString := copy(si,2);

            // Si c'est un A : Abandon
            if sprem = 'A' then
            begin
              FDiagnostic.MemD_Reservations.FieldByName('Nature').AsString := 'Abandon';
              FDiagnostic.MemD_Reservations.FieldByName('Enabled').AsInteger := 0;
              inc(cpt_a); //on comptabilise les abandons pour quand même afficher le log en fin de traitement
            end;

            // Si c'est un X : Exception
            if sprem = 'X' then
            begin
              FDiagnostic.MemD_Reservations.FieldByName('Nature').AsString := 'Erreur';
              FDiagnostic.MemD_Reservations.FieldByName('Enabled').AsInteger := 1;
              inc(cpt_x); //on comptabilise les exceptions pour savoir si on affichera le log en fin de traitement
            end;
            // Si c'est un E : Erreur de faible gravité
            if sprem = 'E' then
            begin
              FDiagnostic.MemD_Reservations.FieldByName('Nature').AsString := 'Problème';
              FDiagnostic.MemD_Reservations.FieldByName('Enabled').AsInteger := 1;
              (*
              if dm_reservation.MemD_Mail.FieldByName('bArchive').AsBoolean
                then FDiagnostic.MemD_Reservations.FieldByName('Rejet').AsInteger := 1;
              *)
              inc(cpt_e);
            end;
            // Si c'est un F : Erreur fonctionnelle
            if sprem = 'F' then
            begin
              FDiagnostic.MemD_Reservations.FieldByName('Nature').AsString := 'Echec';
              FDiagnostic.MemD_Reservations.FieldByName('Enabled').AsInteger := 1;
              inc(cpt_e);
            end;
            // Si c'est un G : Erreur fonctionnelle mais non archivable
            if sprem = 'G' then
            begin
              FDiagnostic.MemD_Reservations.FieldByName('Nature').AsString := 'Echec';
              FDiagnostic.MemD_Reservations.FieldByName('Enabled').AsInteger := 0;
              inc(cpt_e);
            end;
            // Si c'est un R : Intégration de résa réussie
            if sprem = 'R' then
            begin
              FDiagnostic.MemD_Reservations.FieldByName('Nature').AsString := 'Réussi';
              FDiagnostic.MemD_Reservations.FieldByName('Enabled').AsInteger := 0;
              FDiagnostic.MemD_Reservations.FieldByName('Rejet').AsInteger := 1;
            end;

            // Tous les autres cas (I) : Message d'info utile de remonter
            if pos(sprem,'MAXEFGRT')=0 then
            begin
              FDiagnostic.MemD_Reservations.FieldByName('Nature').AsString := 'Information';
              FDiagnostic.MemD_Reservations.FieldByName('Enabled').AsInteger := 0;
            end;

            //Précocher l'archivage dans tous les cas où le flag interne est positionné
            //par le traitement de base (ex: résa déjà existante)
            //if (sprem = 'E') or (sprem = 'F') or (sprem = 'G') then begin
            if (sprem <> 'R')  then begin
            if dm_reservation.MemD_Mail.FieldByName('bArchive').AsBoolean then
            begin
              dm_reservation.MemD_Mail.Edit;
              dm_reservation.MemD_Mail.FieldByName('bArchive').AsBoolean := false;
              dm_reservation.MemD_Mail.Post;
              FDiagnostic.MemD_Reservations.FieldByName('Enabled').AsInteger := 1;
              FDiagnostic.MemD_Reservations.FieldByName('Rejet').AsInteger := 0;
            end;
            end;

          finally
            FDiagnostic.MemD_Reservations.Post;

            //Si en cours de parcours des OC ne rien mettre dans...
            if (bparcours_oc) or
            //Si pas de déplacement de record dans MemD_Mail ne rien mettre dans...
            (irecno_memd = dm_reservation.MemD_Mail.RecNo) then
            begin
              senddebug('Reset client <non dispo> :');
              senddebug('- irecno_memd='+inttostr(irecno_memd));
              senddebug('- dm_reservation.MemD_Mail.RecNo='+inttostr(dm_reservation.MemD_Mail.RecNo));
              FDiagnostic.MemD_Reservations.Edit;
              FDiagnostic.MemD_Reservations.FieldByName('Client').AsString := '<Non disponible>';
              //FDiagnostic.MemD_Reservations.FieldByName('Date').Asstring := '';
              FDiagnostic.MemD_Reservations.Post;
            end;

            //On conserve le dernier recno utilisé dans MemD_Mail pour le passage suivant.
            senddebug('Conservation des variables :');
            senddebug('- irecno_memd='+inttostr(irecno_memd));
            senddebug('- dm_reservation.MemD_Mail.RecNo='+inttostr(dm_reservation.MemD_Mail.RecNo));
            irecno_memd := dm_reservation.MemD_Mail.RecNo;
            senddebug('Ajout diagnostic');
          end;

        end;

        // Si c'est un T : Envoie au log de tracing uniquement- idem avant.
        // Aussi y envoyer les cas X, E et F,G et R.
        if pos(sprem,'TXEFGR')>0 then
        begin
          si[1]:='-'; //remplacer le T avec un -
          Ulog.Log.Log('RIM','Status',si,logInfo,false,-1,ltLocal);
          //senddebug(si);
        end;

      end;

      FDiagnostic.bLoad := false;

      {
      //Si c'est X le message est issu d'une exception
      if sprem='X' then begin
        si:=copy(si,2);
        //Logger normal
        if pos(sNom_centrale,si)>0 //on n'affiche pas le nom de la centrale si déjà présent dans le message
          then fmain.ologfile.Addtext('> '+si)
          else fmain.ologfile.Addtext('> '+sNom_centrale+' : '+si);

        //Envoyer au monitoring
        //Ulog.Log.Log('RIM','Status','Exception : '+si,loginfo,true,-1,ltLocal);
        Ulog.Log.Log('RIM','Status',si,logError,false,-1,ltLocal);

        senddebug('XXX '+si);

        inc(cpt_x); //on comptabilise les exceptions pour savoir si on affichera le log en fin de traitement
      end

      else begin
        //Message normal, on envoie au log uniquement
        i:=strtointdef(si[1],0);
        if i<=itrc then begin //gestion du niveau de message
          si[1]:='-'; //remplacer le n° de niveau de message avec un -
          //fmain.ologfile.Addtext(si);
          Ulog.Log.Log('RIM','Status',si,logInfo,false,-1,ltLocal);

          senddebug(si);
        end;
      end;
      }
      
    end;
  end;
end;


//Met à jour l'état pour visualisation dans Ginkoia
procedure TFmain.p_maj_etat(setat : string);
begin
  Dm_Main.IbC_updgenparam.Close;
  Dm_Main.IbC_updgenparam.sql.clear;
  Dm_Main.IbC_updgenparam.sql.Add('Update GENPARAM');
  Dm_Main.IbC_updgenparam.sql.Add('SET PRM_STRING = '+quotedstr(setat));
  Dm_Main.IbC_updgenparam.sql.Add(' Where PRM_MAGID = ' + Inttostr(FMagid));
  Dm_Main.IbC_updgenparam.sql.Add('  And PRM_TYPE = 3');
  Dm_Main.IbC_updgenparam.sql.Add('  And PRM_CODE = 145');
  //trclog('T'+Dm_Main.IbC_updgenparam.sql.text);
  Dm_Main.IbC_updgenparam.Execute;
  Dm_Main.IbC_updgenparam.IB_Transaction.commit;
end;


procedure TFmain.FindeSessionWindows(var aMsg: TMessage);
var oMsg : Tform ;
begin
  Try
   oMsg := CreateMessageDialog('Le module d''intégration des réservations est en cours d''exécution',mtWarning,[mbOk]) ;
   oMsg.ShowModal ;
  Finally
    oMsg.Release ;
    oMsg := nil ;
  End;
end;


Procedure TFmain.SetDatabase(sDatabase : string);
var sflog : string ; // nom du fichier log
    bLaunch : boolean ;

    i : integer;

    iRecResa : integer;
    iCptResa : integer;
    sNomCentrale, sNrResa : string;
    sResa : string;

    sFicIni : TFileName;
    FicIni  : TIniFile;
    setat : string;

(*
    //Met à jour l'état pour visualisation dans Ginkoia
    procedure p_maj_etat(setat : string);
    begin
      Dm_Main.IbC_updgenparam.Close;
      Dm_Main.IbC_updgenparam.sql.clear;
      Dm_Main.IbC_updgenparam.sql.Add('Update GENPARAM');
      Dm_Main.IbC_updgenparam.sql.Add('SET PRM_STRING = '+quotedstr(setat));
      Dm_Main.IbC_updgenparam.sql.Add(' Where PRM_MAGID = ' + Inttostr(FMagid));
      Dm_Main.IbC_updgenparam.sql.Add('  And PRM_TYPE = 3');
      Dm_Main.IbC_updgenparam.sql.Add('  And PRM_CODE = 145');
      //trclog('T'+Dm_Main.IbC_updgenparam.sql.text);
      Dm_Main.IbC_updgenparam.Execute;
      Dm_Main.IbC_updgenparam.IB_Transaction.commit;
    end;
*)

begin
  if paramstr(1) = '/M' then begin
    ologfile.Addtext(RS_RESERVATION_START+' Ginkoia');
    trclog('T'+RS_RESERVATION_START+' Ginkoia');
    FAuto := False ;
  end
  else begin
    ologfile.Addtext(RS_RESERVATION_START+' Automatique');
    trclog('T'+RS_RESERVATION_START+' Automatique');
    FAuto := True ;
  end;

   if paramstr(5) = '1' then
      FAlgol := True else FAlgol := False ;

  Fdatabase :=  sDatabase ;
  if dm_main.InitDatabase(Fdatabase, 'ginkoia', 'ginkoia') then
   begin
    Try
      //if paramstr(1) = '/M' then visible := True ;
      Visible := True ; // visible dans tous les cas
      application.ProcessMessages ;

      Try

       //ULOG - initialisation
       dm_main.IbQ_Ulog.SQL.Clear;
       dm_main.IbQ_Ulog.SQL.Add('SELECT BAS_MAGID, BAS_GUID, BAS_SENDER FROM GENBASES');
       dm_main.IbQ_Ulog.SQL.Add(' WHERE BAS_IDENT = (SELECT PAR_STRING FROM GENPARAMBASE WHERE PAR_NOM=''IDGENERATEUR'')');
       trclog('TPréparation ULOG');
       dm_main.IbQ_Ulog.Open;
       uLog.Log.readIni;
       uLog.Log.App:='RIM';
       uLog.Log.Mag:=dm_main.IbQ_Ulog.fieldbyname('BAS_MAGID').asstring;
       uLog.Log.Ref:=dm_main.IbQ_Ulog.fieldbyname('BAS_GUID').asstring;
       dm_main.ibc_majcu.Close;
       uLog.Log.Open;
       //uLog.Log.SaveIni('C:\Developpement\Ginkoia\Ulog.ini');

       //Liste des paramètres
       trclog('TParamètres d''exécution');
       for i:= 0 to paramcount do trclog('TParamètre '+inttostr(i)+' : '+paramstr(i));

       trclog('TBase de données initialisée');

       vdebut_exec := now;

       trclog('TAppel du traitement des réservations');
       ExecuteTraitementReservation ;
       trclog('TRetour du traitement des réservations');
       trclog('TClôture des transactions');
       dm_main.Database.CloseTransactions ;
       trclog('TClôture de la base de données');
       dm_main.Database.close ;

       vfin_exec := now;

      Except
        //PDB
        on e:exception do begin
          trclog('XErreur de traitement : '+e.Message);
        end;
        //
      End;
      trclog('TFin d''exécution');

      //PDB - Ne plus fermer ici
      //Sendmessage(handle, WM_CLose, 0, 0) ;

    Finally
       oLogfile.Addtext( RS_RESERVATION_END );

       // CVI - Appel de la fenêtre de diagnostic
       //FDiagnostic.ShowModal;

       if FDiagnostic.bdonotshow
         then trclog('TDoNotShow=true')
         else trclog('TDoNotShow=false');

       if (not FDiagnostic.bdonotshow) and (FDiagnostic.MemD_Reservations.RecordCount>0) then begin

         oLOgfile.Free ;
         oLOgfile := nil ;

         FMain.Hide;

         //Ecriture de la dernière exécution + etat dans GENPARAM
         trclog('TEcriture des infos sur l''exécution dans GENPARAM 3/145');
         trclog('TExecution - Début : '+datetimetostr(vdebut_exec));
         trclog('TExecution - Fin : '+datetimetostr(vfin_exec));

         setat := '';
         //Gestion de l'état de sortie affiché dans Ginkoia :
         if (cpt_x>0) or (cpt_e>0) then
         begin
           setat := 'Intégration: ';
           setat := setat+inttostr(cpt_x+cpt_e)+' erreurs / ';
           setat := setat+inttostr(cpt_r)+' réussies';
         end
         else if cpt_r>0 then
         begin
           setat := 'Intégration: ';
           setat := setat+inttostr(0)+' erreurs / ';
           setat := setat+inttostr(cpt_r)+' réussies';
         end
         //- Si création OC (initial ou complémentaire)
         else if (bcreation_init_oc) or (bcreation_oc) then
         begin
           setat := 'Création OC'
         end
         //- Si le nombre de centrale = au nombre de fois qu'on a constaté qu'il n'y avait pas de résa à traiter
         else if cpt_centrale=icptnoresa then
         begin
             setat := 'Pas de réservation'
         end
         else setat := 'Intégration: Aucune info';

         trclog('TEtat final='+setat);
         setat := setat+ ' ('+formatdatetime('dd/mm hh:nn',vdebut_exec)+')';

         //Toujours afficher la fenêtre en mode manuel
         if (not FAuto) then
         begin
           p_maj_etat(setat);
           trclog('TAffichage de la fenêtre de diagnostic - mode manuel');
           FDiagnostic.ShowModal;
         end

         //Mode auto, à voir...
         else begin

           //Vérifier si l'état actuel est setat := 'Pas de réservation'
           //et que l'état enregistré précédement est aussi setat := 'Pas de réservation'.
           //Dans ce cas, ne pas afficher la fenêtre.
           Dm_Main.IbC_updgenparam.Close;
           Dm_Main.IbC_updgenparam.sql.clear;
           Dm_Main.IbC_updgenparam.sql.Add('SELECT PRM_STRING FROM GENPARAM');
           Dm_Main.IbC_updgenparam.sql.Add(' Where PRM_MAGID = ' + Inttostr(FMagid));
           Dm_Main.IbC_updgenparam.sql.Add('  And PRM_TYPE = 3');
           Dm_Main.IbC_updgenparam.sql.Add('  And PRM_CODE = 145');
           Dm_Main.IbC_updgenparam.Open;
           sResa := Dm_Main.IbC_updgenparam.fieldbyname('PRM_STRING').asstring;
           if (pos('Pas de réservation',sresa)>0) and (pos('Pas de réservation',setat)>0) then
           begin
             trclog('TPas affichage de diagnostic : ancien état et état actuel = Pas de réservation');
             p_maj_etat(setat);
             application.terminate ;
           end
           else begin

             //Afficher la fenêtre mais d'abord mettre en place l'auto-destruction
             trclog('TParamètres d''auto-destruction');
             //PDB - Traiter l'auto-destruction
             if paramcount>5 then
             begin
               //Initialiser le timer de destruction au paramètre de cycle de RIM-Auto - la durée d'exécution du traitement courant - 5 minutes de sécurité.
               trclog('TCalcul auto-destruction');
               trclog('TParam6='+paramstr(6));
               trclog('TDiffExec='+inttostr(millisecondsbetween(vdebut_exec, vfin_exec)));
               trclog('T2min='+inttostr(2*60*1000));

               i:=strtoint(paramstr(6));
               trclog('Ti1='+inttostr(i));
               i:=i-millisecondsbetween(vdebut_exec, vfin_exec);
               trclog('Ti2='+inttostr(i));
               i:=i-( 2*60*1000 );
               trclog('Ti3='+inttostr(i));
               FDiagnostic.tim_wait.interval := i;
               trclog('TAuto-destruction dans '+inttostr(FDiagnostic.tim_wait.interval)+' millisec.');
               FDiagnostic.tim_wait.Enabled := true;
             end;

             p_maj_etat(setat);
             if (cpt_x>0) or (cpt_e>0) then
             begin
               trclog('TAffichage de la fenêtre de diagnostic - mode auto');
               FDiagnostic.ShowModal;
             end
             else trclog('TPas d''affichage de la fenêtre de diagnostic car Intégration réussie et mode Auto.');
           end;

         end;

         trclog('TArrêt du tracing');

       end

       else begin

         Fmain.p_maj_etat('Intégration: Erreur ('+formatdatetime('dd/mm hh:nn',vdebut_exec)+')' );

         //bLaunch := oLogfile.Count > 2 ;
         if cpt_x>0 then bLaunch:=true;

         Sendmessage(handle, WM_CLose, 0, 0) ;

         sFlog := IncludeTrailingPathDelimiter(Extractfilepath(paramstr(0)))+'LOG_RIM\' ;
         ologfile.SaveToFile(sflog);  // passe le chemin d'enregistrement
         if blaunch then
          begin
           sFlog := oLogfile.fichierlog ;
           Shellexecute(handle, 'open', 'Notepad.exe', pchar(sFlog), nil, SW_NORMAL) ;
          end;
         oLOgfile.Free ;
         oLOgfile := nil ;
         application.terminate ;
       end;

    End;

   end else
   begin

     Fmain.p_maj_etat('Intégration: Erreur ('+formatdatetime('dd/mm hh:nn',vdebut_exec)+')' );

     ologfile.Addtext(RS_ERR_RESMAN_DATABASE);
     oLOgfile.Free ;
     oLOgfile := nil ;
     application.terminate ;
   end;

   (* PDB - pas de terminate si diagnostic ouvert
   oLOgfile.Free ;
   oLOgfile := nil ;
   application.terminate ;
   *)

end;


Procedure TFmain.ExecuteTraitementReservation;
var FListCentrale  : TListGENTYPEMAIL;
    i : integer ;
    MaCFG          : TCFGMAIL;
    bAutorisation, bDoreservation, bDotraitement, bResaok : boolean ;
    bAnnulok : boolean ;
    lSearchRecord  : TSearchRec;
    s : string ;

begin
  // fonction récupérée de Ginkoia
  trclog('TEntrée dans la procédure de traitement');

  //PDB
  try
  try
  //

  With Dm_Reservation do
  Begin
    MemD_Rap.Close;
    MemD_Rap.Open;

  // répertoire temporaire pour récupérer les fichiers
   GPATHMAILTMP := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'MailImportTmp\';
   trclog('TCréation du répertoire temporaire pour récupérer les fichiers');
   ForceDirectories(GPATHMAILTMP);

   trclog('TRécupération de la liste des centrales');
   FListCentrale := dm_reservation.GetListCentrale ;

   cpt_centrale:=FListCentrale.count; //TWGS
   trclog('TBoucle sur les centrales (Nbre.='+inttostr(FListCentrale.count)+')');

   if cpt_centrale=0 then begin
     ShowmessageRS('Aucune centrale n''est définie. Traitement abandonné.', 'Erreur');
     trclog('TAucune centrale n''est définie. Traitement abandonné.');
     trclog('T-');

     Fmain.p_maj_etat('Intégration: Erreur ('+formatdatetime('dd/mm hh:nn',vdebut_exec)+')' );

     exit;
   end;


      for I := 0 to FlistCentrale.Count-1  do
       begin
          iId_centrale:=FListCentrale.Items[i].MTY_ID; //TWGS
          sNom_centrale:=FListCentrale.Items[i].MTY_NOM;

          //Au changement de centrale, Reset des variables de travail
          scodeadh := '';
          berreur_codeadh := false;
          irecno_memd := -1;

          // On récupère l'information si on est une centrale ISF ou pas
          case AnsiIndexStr(sNom_centrale,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3,CGOSPORT]) of
            0,2,3,4,5,6,7: bISF := False;
            1: bISF := True;
          end;
          if bISF
            then trclog('TMode ISF')
            else trclog('TMode générique');


          trclog('TCentrale "'+FListCentrale.Items[i].MTY_NOM+'" (ID='+inttostr(FListCentrale.Items[i].MTY_ID)+')');
          trclog('T------------------------------------------');
          //Fmain.oLogfile.Addtext('Centrale "'+FListCentrale.Items[i].MTY_NOM+'"');
          dm_reservation.PosID := FPostid;
          case FListCentrale.Items[i].MTY_MULTI of
            // poste référant uniquement
            0: bAutorisation := (FPostID = GetPostReferantId);
            // magasin uniquement
            1: bAutorisation := IsMagAutorisation(FListCentrale.Items[i].MTY_ID,FMagID, FPostID);
          end;

          //bAutorisation:=true; //SK7 forcé

         if bAutorisation then
          begin
           trclog('TAutorisation OK');

           //SKISET
           if FListCentrale.Items[i].MTY_CODE='RS7' then begin
             trclog('TTraitement SKISET WebService');
             bok_sk7:=true;

             trclog('TLecture du fichier '+extractFilePath(application.exename)+'RIM.INI');
             //Normallement le fichier INI existe touours car si inexistant il est créé au démarrage de GINKOIA
             s:=extractFilePath(application.exename)+'RIM.INI';
             if fileexists(s) then begin

               RimIni:=TIniFile.Create(s);

               if RimIni.SectionExists('SKISET') then begin

                 sdate_begin:=trim(lowercase(RimIni.ReadString('SKISET','date_begin','')));
                 sdate_end:=trim(lowercase(RimIni.ReadString('SKISET','date_end','')));
                 RimIni.Free;
                 if (sdate_begin<>'') and (sdate_end<>'') then begin

                   GetLocaleFormatSettings(SysLocale.DefaultLCID,FSetting);
                   FSetting.ShortDateFormat := 'YYYY-MM-DD';
                   FSetting.ShortTimeFormat:='HH:NN:SS';
                   FSetting.DateSeparator := '-';
                   FSetting.TimeSeparator:=':';

                   bok_date_begin:=true;
                   bok_date_end:=true;

                   //date_begin
                   if pos('today',sdate_begin)>0 then begin
                     ddate_begin:=now;
                     if pos('today+',sdate_begin)>0 then begin
                       s:=copy(sdate_begin,7);
                       try
                         idecal:=strtoint(s);
                         ddate_begin:=incday(now,idecal);
                       except
                         bok_date_begin:=false;
                       end;
                     end;
                     if pos('today-',sdate_begin)>0 then begin
                       s:=copy(sdate_begin,7);
                       try
                         idecal:=strtoint(s);
                         ddate_begin:=incday(now,-idecal);
                       except
                         bok_date_begin:=false;
                       end;
                     end;
                   end
                   else begin
                     try
                       ddate_begin:=strtodate(sdate_begin,fsetting);
                     except
                       bok_date_begin:=false;
                     end;
                   end;

                   if not bok_date_begin then begin
                     trclog('TLa date de début de période est incorrecte ('+sdate_begin+'). Traitement abandonné.');
                     bok_sk7:=false;
                   end;

                   if bok_sk7 then begin

                     //date_end
                     if pos('today',sdate_end)>0 then begin
                       ddate_end:=now;
                       if pos('today+',sdate_end)>0 then begin
                         s:=copy(sdate_end,7);
                         try
                           idecal:=strtoint(s);
                           ddate_end:=incday(now,idecal);
                         except
                           bok_date_end:=false;
                         end;
                       end;
                       if pos('today-',sdate_end)>0 then begin
                         s:=copy(sdate_end,7);
                         try
                           idecal:=strtoint(s);
                           ddate_end:=incday(now,-idecal);
                         except
                           bok_date_end:=false;
                         end;
                       end;
                     end
                     else begin
                       try
                         ddate_end:=strtodate(sdate_end,fsetting);
                       except
                         bok_date_end:=false;
                       end;
                     end;

                     if not bok_date_end then begin
                       trclog('TLa date de fin de période est incorrecte ('+sdate_end+'). Traitement abandonné.');
                       bok_sk7:=false;
                     end;

                     if bok_sk7 then begin
                       if ddate_end<ddate_begin then begin
                         trclog('TLa date de fin de période est inférieure à la date de début. Traitement abandonné.');
                         bok_sk7:=false;
                       end;
                     end;

                   end;
                 end
                 else begin
                   trclog('TLes dates de début et/ou de fin ne sont pas spécifiées. Traitement abandonné.');
                   bok_sk7:=false;
                 end;

               end
               else begin
                 trclog('TLa section SKISET n''existe pas dans le fichier INI. Traitement abandonné.');
                 bok_sk7:=false;
               end;

             end
             else begin
               trclog('TFichier RIM.INI absent. Traitement abandonné.');
               bok_sk7:=false;
             end;

             //Si période valide
             if bok_sk7 then begin
               trclog('TPériode valide du '+sdate_begin+' au '+sdate_end);
               CreateResaSki7(FListCentrale.Items[i], ddate_begin, ddate_end)
             end;

           end

           //PAS SK7
           else begin
             trclog('TTraitement classique Email');

             MaCFG := dm_reservation.GetMailCFG(FListCentrale.Items[i]);

             trclog('TVérification des mails de la centrale en cours (n°='+inttostr(AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3,CGOSPORT]))+')');
             // 2- Vérification des mails de la centrale en cours
             // Cxxxxx correspondent à des constantes qui sont l'identique du nom dans la base de données
             // De la table GENTYPEMAIL
             case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3,CGOSPORT]) of
               0,7: begin
                    trclog('TTwinner,GoSport');
                    bDoReservation := GenerateTwinnerMailList(FListCentrale.Items[i],MaCFG); // Twinner et GoSport
                  end ;
               1: begin
                    trclog('TInterSport');
                    bDoReservation := GenerateISMailList(FListCentrale.Items[i],MaCFG); // Intersport
                  end ;
               2: begin
                   trclog('TSkimium');
                   bDoReservation := GenerateSkmMailList(FListCentrale.Items[i],MaCFG); // Skimium
                  end ;
               3: begin
                    trclog('TSport2000');
                    bDoReservation := GenerateSport2kMailList(FListCentrale.Items[i],MaCFG); // Sport2000
                  end ;
               4,5,6 : begin
                 trclog('TGénérique');
                 bDoReservation := GenerateGENMailList(FListCentrale.Items[i],MaCFG); // Gen1, Gen2,Gen3
               end;
               else
                 trclog('FAucune centrale ne correspond à "'+sNom_centrale+'" -> Abandon de la centrale');
                 // 'Aucune centrale trouvée', 'Erreur'
                 ologfile.Addtext(RS_ERR_RESMAN_NOCENTRALE);
                 trclog('Q-'); //pour forcer à ne pas afficher la fenêtre de diagnostic
                     // affichage message
                 ShowmessageRS('Aucune centrale ne correspond à "'+sNom_centrale+'" -> Abandon', 'Erreur');

                 Fmain.p_maj_etat('Intégration: Erreur ('+formatdatetime('dd/mm hh:nn',vdebut_exec)+')' );

                 Exit;
             end;   // encase

             // Si il n'y a pas eu de soucis avec la validation des mails de la centrale on passe à la suite
             if bDoReservation then
             begin
               trclog('TValidation des mails ok -> traitement des réservations de la centrale');
               // 3- Traitement des réservations de la centrale en cours
               case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3,CGOSPORT]) of
                 0,7: bDoTraitement := ExecuteTwinnerDoTraitement(FListCentrale.Items[i]); // Twinner-GoSport
                 1: bDoTraitement := True; // Intersport - Sera vérifié et traité en même temps que l'intégration
                 2: bDoTraitement := ExecuteSkmDoTraitement(FListCentrale.Items[i],MaCFG); // Skimium
                 3: bDoTraitement := ExecuteSport2KDoTraitement(FListCentrale.Items[i],MaCFG); // Sport2000
                 4,5,6: bDoTraitement := ExecuteGENDoTraitement(FListCentrale.Items[i],MaCFG); // Gen1, Gen2,Gen3
               end;

               // Si le traitement des réservations c'est bien passé alors on va les intégrer
               if bDoTraitement then
               begin
                 trclog('TTraitement des réservations -> intégration des réservations');
                 // 4- Intégration des Réservations dans la base de données
                 case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3,CGOSPORT]) of
                   0,2,3,4,5,6,7: bResaOk := CreateResa(FListCentrale.Items[i]); //Twinner, Skimium, Sport2k, Gen1,Gen2, Gen3
                   1: bResaOk := DoCreateReservationIS(FListCentrale.Items[i],MaCFG); // Intersport
                 end;

                //Reset des infos client pour fenêtre de Diagnostic
                sClient_Id := '';
                sClient_Nom := '<Non disponible>';
                sClient_Prenom := '';
                sClient_Email := '';

                 // 5- Traitement des annulations
                 trclog('TTraitement des annulations');
                 case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3,CGOSPORT]) of
                   //PDB - A noter : PAS D'ANNULATION pour Twinner/GoSport et InterSport
                   2,3,4,5,6: bAnnulOk := AnnulResa; // Sport2000, Skimium, Gen1, Gen2, Gen3,...
                   else
                     bAnnulOk := True;
                 end; // case annulation


                 // 6- Archivage des mails
                 // Archivage si l'intégration et/ou l'annulation des réservations c'est bien faite et si on a une adresse d'archivage
                 trclog('TProcéder à l''archivage ?');
                 if bResaOk and bAnnulOk
                 //PDB - ne plus tester la valorisation de ce paramètre : and (MaCFG.PBT_ADRARCH <> '')
                 then
                 begin
                    trclog('TArchivage des mails');
                   // traitement des mails à archiver
                    case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3,CGOSPORT]) of
                      1: ArchiveMailIS(FListCentrale.Items[i],MaCFG); // intersport
                      else begin
                        ArchivMail(FListCentrale.Items[i],MaCFG);
                      end;
                     end ;
                  end // bresaok...
                  else begin
                    trclog('TPas d''achivage :');
                    if bResaOk then trclog('T bResa Ok') else trclog('T bResa pas Ok');
                    if bAnnulOk then trclog('T bAnnul Ok') else trclog('T bAnnul pas Ok');
                    //trclog('T MaCFG.PBT_ADRARCH (adresse archivage)='+MaCFG.PBT_ADRARCH);
                  end;

               end// bDotraitement
               else begin
                 if (main.bcreation_oc) and (not bcreation_init_oc)
                   then trclog('ACréation d''OC complémentaires')
                   else trclog('TLe traitement des réservations s''est mal déroulé, pas d''intégration possible');
               end;

             end  // bDoreservation

             else begin
               trclog('TLa validation des mails a échoué -> aucun traitement');
                // ' : De nouvelles offres commerciales ont été créées, veuillez les mettre à jour', 'Informations'
               //  InfoMessHP(ParamsStr(RS_TXT_RESMAN_NEWOFFRE, FListCentrale.Items[i].MTY_NOM),True,0,0,RS_TXT_RESMAN_INFO);
               if fmain.Ferrorconnect = False then
               begin
                 trclog('Q-'); //pour forcer à ne pas afficher la fenêtre de diagnostic
                 // ce n'est pas une erreur de connexition
                 s := ParamsStr(RS_TXT_RESMAN_NEWOFFRE, FListCentrale.Items[i].MTY_NOM) ;
                 fmain.ologfile.Addtext(s) ;
                    // affichage message
                 ShowmessageRS(ParamsStr(RS_TXT_RESMAN_NEWOFFRE, FListCentrale.Items[i].MTY_NOM),RS_TXT_RESMAN_INFO );
               end;
               Exit;
             end // else

           end; // SK7
          end  // if bAutorisation
          else begin

            Fmain.p_maj_etat('Intégration: Erreur ('+formatdatetime('dd/mm hh:nn',vdebut_exec)+')' );

            ShowmessageRS('Pas d''autorisation. Traitement abandonné.', 'Erreur');
            trclog('TPas d''autorisation. Traitement abandonné.');
            trclog('Q-');
          end;

       end; // for


       // 7- Suppression des fichiers du répertoire temporaire
       trclog('TSuppression des fichiers du répertoire temporaire');
       i := FindFirst(GPATHMAILTMP + '*.*',faAnyFile,lSearchRecord);
       try
         while i = 0  do
         begin
           trclog('TFichier "'+GPATHMAILTMP + ExtractFileName(lSearchRecord.Name)+'"');
           DeleteFile(GPATHMAILTMP + ExtractFileName(lSearchRecord.Name));
           i := FindNext(lSearchRecord);
         end;
       finally
         FindClose(lSearchRecord);
       end;

       // Affichage du rapport

      //   if Dm_Reservation.MemD_Rap.RecordCount > 0 then
        //          Dm_Reservation.LK_Rap.Execute

       //else
      // begin
         // 'Pas de nouvelle réservation' , 'Informations'
        // InfoMessHP(RS_TXT_RESMAN_NONEWRESA,True,0,0,RS_TXT_RESMAN_INFO);
        // ologfile.Addtext(RS_TXT_RESMAN_NONEWRESA );
       //  ShowmessageRS(RS_TXT_RESMAN_NONEWRESA ,RS_TXT_RESMAN_INFO);
      // end ;

  end; // fin de with..do

  //pdb
  except
    on e:exception do trclog('XErreur de traitement : '+e.message);
  end;
  finally
    trclog('TSortie de la procédure de traitement');
  end;
  //
end;


procedure TFmain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose := false ;
  uLog.Log.Close;  //ULOG
  windowstate := wsMinimized ;
  application.processmessages ;
end;

procedure TFmain.FormCreate(Sender: TObject);
var sId : string ;
begin
    Chargement_Langue();
    Decimalseparator := '.' ;
    Ferrorconnect := false ;
    Memo_Mess.Caption := RS_VERIF_MAIL ;
    FAuto := false ;
    if oLogfile = nil then
      oLogfile := Tlogfile.Create(False);

    // transforme params en integer
    sId := Paramstr(3) ;
    Try
     FPostid := StrToInt(sid) ;
    Except
     Fpostid := 0 ;
    End;

    sId := Paramstr(4) ;
    Try
     FMagid := StrToInt(sid) ;
    Except
     FMagid := 0 ;
    End;

    if Paramstr(1) = '/A' then
     begin
       WindowState := wsMinimized ;
     end;

    // Init de bISF
    bISF := False;

    //PDB
    itrc:=0;
    if paramstr(paramcount)='debug1' then itrc:=1
    else if paramstr(paramcount)='debug2' then itrc:=2
    else if paramstr(paramcount)='debug3' then itrc:=3;
    itrc:=3; //pour le moment on force à 3

    trclog('TNiveau de tracing = '+inttostr(itrc));
    (*
    trclog('TTest');
    trclog('AAbandon');
    trclog('XException');
    trclog('EErreur');
    trclog('RBonne résa');
    *)

    //Init des variables de contrôle de traitement
    bnotallow := false;
    scodeadh := '';
    bcreation_init_oc := false;
    bcreation_oc := false;
    bparcours_oc := false;
    irecno_memd := -1;
    berreur_codeadh := false;
    sbadxml := '';
    icptnoresa := 0;

end;

Procedure  TFmain.ArchivMail(MaCentrale : TGENTYPEMAIL;MaCFG : TCFGMail; reprejet : string = '');
const
  Retry = 3;
var
  Count : integer ; // pour tester les essais
  iNbMess, i, j : Integer;
  IdSMTP : TSmtpClient ;
  lstRep, lstMailBox : TStringList;
  s : string ;
  IMAP4 : IMAP4Class;
begin
 Fmain.trclog('TProcédure d''archivage');
  // On sort quand on est en algol
  if FAlgol then begin
   Fmain.trclog('TMode Algol -> pas d''archivage');
    Exit;
  end;

  if reprejet<>''
    then reprejet := '/'+reprejet;
  trclog('TDossier de Rejet='+reprejet);

  try //PDB

    IMAP4 := IMAP4Class.Create(MaCfg.PBT_SERVEUR,MaCfg.PBT_ADRPRINC,MaCfg.PBT_PASSW,MaCfg.PBT_PORT,True);
    IMAP4.PGStatus3D := Fmain.Gge_A;
    lstRep := TStringList.Create;
    lstMailBox := TStringList.Create;
    With Dm_Reservation do
    Try
      //raise Exception.Create('Erreur volontaire dans archivage');
      {$REGION 'Tentative de connexion'}
      Count := 0;
      Repeat
        try
          Inc(Count) ;
          IMAP4.Connect;
          //Plus utile car email identique  Fmain.oLogfile.Addtext(Format(RS_CONNEXION_OK_LOG, [MaCentrale.MTY_NOM]));
          break ;
        Except on E:Exception do
          begin
            if Count = Retry then
            begin
              Fmain.Ferrorconnect := True ;
              Fmain.oLogfile.Addtext(Format(RS_ERREUR_CONNEXION_LOG, [MaCentrale.MTY_NOM, Count, Retry, E.ClassName, E.Message]));
              Fmain.ShowmessageRS(Format(RS_ERREUR_CONNEXION_DLG, [MaCentrale.MTY_NOM, E.ClassName, E.Message]), 'Erreur');
              trclog('T'+RS_ERREUR_CONNEXION_DLG_TRC+': '+E.Message);
              trclog('Q-'); //pour forcer à ne pas afficher la fenêtre de diagnostic

              Fmain.p_maj_etat('Intégration: Erreur ('+formatdatetime('dd/mm hh:nn',vdebut_exec)+')' );

              Exit;
            end
            else begin
              Sleep(Dm_Reservation.DelaisEssais);
            end;
          end;
        end;
      Until Retry=Count;
      {$ENDREGION}

     lstMailBox := IMAP4.MailboxList;
     With Que_IdentMagExist do
     begin
       Close;
       ParamCheck := True;
       ParamByName('PMtyId').AsInteger := MaCfg.PBT_MTYID;
       Open;

       if (Recordcount > 0) then
       begin
         trclog('TRecordcount='+inttostr(Recordcount));
         while not EOF do
         begin
            if ((MaCentrale.MTY_MULTI <> 0) and (dm_reservation.POSID = FieldByName('IDM_POSID').AsInteger)) Or
               (MaCentrale.MTY_MULTI = 0) then
            begin
              lstRep.Text := StringReplace(Trim(FieldByName('IDM_PRESTA').AsString),';',#13#10,[rfReplaceAll]);
              for i := 0 to lstRep.Count - 1 do
              begin
                Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Analyse des mails pour archivage',[MaCentrale.MTY_NOM,RecNo,Recordcount,i + 1, lstRep.Count]),100);
                trclog('T'+Format('%s %d sur %d : Code %d/%d'#13#10'Analyse des mails pour archivage',[MaCentrale.MTY_NOM,RecNo,Recordcount,i + 1, lstRep.Count]));
                // Positionnement dans le répertoire (On passe à la suite s'il n'existe pas
                trclog('TPositionnement dans le répertoire des mails : '+'Reservation/' + Trim(lstRep[i]));
                if not IMAP4.SelectMailBox('Reservation/' + Trim(lstRep[i])) then
                begin
                  trclog('TN''existe pas, on passe à la suite');
                  Continue;
                end;

                // Récupération des mails du répertoire
                IMAP4.LoadAllMailBoxMsg;

                Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Archivage des mails en cours',[MaCentrale.MTY_NOM,RecNo,Recordcount, i+1, lstRep.Count]),100);
                trclog('T'+Format('%s %d sur %d : Code %d/%d'#13#10'Archivage des mails en cours',[MaCentrale.MTY_NOM,RecNo,Recordcount, i+1, lstRep.Count]));
                trclog('TMsgList.Count='+inttostr(IMAP4.MsgList.Count));
                for j := 0 to IMAP4.MsgList.Count - 1 do
                begin
                  // recherche si le mail est à traiter
                  trclog('TRecheche si le mail est à traiter');
                  if MemD_Mail.Locate('MailSubject;MailDate',VarArrayOf([IMAP4.MsgList[j].Subject,IMAP4.MsgList[j].Date]),[loCaseInsensitive]) then
                  begin
                    // Doit on archiver le mail ?
                    trclog('TDoit on archiver le mail ?');
                    if MemD_Mail.FieldByName('bArchive').AsBoolean then
                    begin
                      trclog('TOui. Vérification si le dossier existe : '+'Archive/' + Trim(lstRep[i]) + reprejet);
                      if lstMailBox.IndexOf('Archive/' + Trim(lstRep[i]) + reprejet) = -1 then
                      begin
                        trclog('TNon, on le créé');
                        IMAP4.CreateMailBox('Archive/' + Trim(lstRep[i]) + reprejet);
                        lstMailBox.Add('Archive/' + Trim(lstRep[i]) + reprejet);
                      end
                      else trclog('TOui, on poursuit');

                      trclog('TDéplacement du mail dans le dossier d''archive');
                      IMAP4.MoveMsg(j + 1,'Archive/' + Trim(lstRep[i]) + reprejet);

                    end
                    else trclog('TNon');
                  end;

                  Fmain.Gge_A.Progress := (j + 1) * 100 DIV (IMAP4.MsgList.Count);
                  FMain.Refresh;
                end; // for j
                trclog('TValidation des mouvements de mail');
                IMAP4.ValidMoveMsg;
              end; // for i
            end; // if
           Next;
         end; // while
       end // if
       else Fmain.trclog('TPas d''itentificatin du magasin');
     end; // With

  //PDB
  except
    on e:exception do begin
     Fmain.trclog('XErreur dans ArchivMail : '+e.message);
    end;
  end;
  Finally
    lstMailBox.Free;
    lstRep.Free;
    IMAP4.Free;
  End;


//  Account := TAccount.Create(MaCfg.PBT_ADRPRINC,MaCfg.PBT_PASSW,'');
//  With Account do
//   begin
//     Port := MaCfg.PBT_PORT ;
//     Host := MaCfg.PBT_SERVEUR
//   end;
//
//  IdPop := Tpop3Client.Create(Account, True); // connection True = avec SSL
//
//  SMTPAccount := TAccount.Create(MaCfg.PBT_ADRPRINC,MaCfg.PBT_PASSW,'');
//  With SMTPAccount do
//   begin
//     Port := MaCfg.PBT_PORTSMTP ;
//     Host := MaCFG.PBT_SMTP ;
//   end;
//
//  IdSMTP := TSmtpClient.Create(SMTPAccount);
//  Count := 0 ;
//  Repeat
//    Try
//     inc(Count) ;
//     IdSMTP.Connect ;
//     Break ;
//    Except on E:Exception do
//     begin
//     if Count=Retry then
//        begin
//        // ' : Erreur lors de la connexion avec le serveur de mail', 'Erreur POP3'
//       // InfoMessHP(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,True,0,0,RS_ERR_RESMAN_ERRORPOP3);
//        ologfile.Addtext(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM)+' '+E.Message);
//        Fmain.ShowmessageRS(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,RS_ERR_RESMAN_ERRORPOP3 );
//        Exit;
//        end;
//     end;
//    End;
//  Until Retry=Count ;
//
//  
//  IdMess := TIdMessage.Create(Dm_Reservation);
//  lst := TStringList.Create;
//
//
//
//
//  With Dm_Reservation do
//  try
//    With IdPop do
//    begin
//      PrepareUserPass ;// connection SSL en mode user pass
//      Count := 0 ;
//      Repeat
//      try
//        Inc(Count) ;
//        if Connected = False then
//           Connect;
//        break ;
//      Except on E:Exception do
//        begin
//         if Count=Retry then
//          begin
//          // ' : Erreur lors de la connexion avec le serveur de mail', 'Erreur POP3'
//         // InfoMessHP(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,True,0,0,RS_ERR_RESMAN_ERRORPOP3);
//          ologfile.Addtext(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM)+' '+E.Message);
//          ShowmessageRS(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,RS_ERR_RESMAN_ERRORPOP3 );
//          Exit;
//          end;
//        end;
//      end; // with idpop
//      Until  Retry=Count  ;
//    end;  // with
//
//    iNbMess := Idpop.CheckMessages;
//    // ' : Vérification des mails pour Archivage'
//    //InitGaugeMessHP (ParamsStr(RS_TXT_RESMAN_VERIFMAILARCHIV,MaCentrale.MTY_NOM), iNbMess + 1, true, 0, 0, '', false) ;
//
//    InitGauge(ParamsStr(RS_TXT_RESMAN_VERIFMAILARCHIV,MaCentrale.MTY_NOM),  iNbMess+1);
//    for i := iNbMess downto 1  do
//    begin
//       UpdateGauge ;
//      // récupération du header du mail (plus rapide pour un traitement en surface)
//      IdPop.Pop3.RetrieveHeader(i,IdMess);
//      // Est ce que le mail se trouve dans la liste des mails à traiter
//      if MemD_Mail.Locate('MailSubject',IdMess.Subject,[])  then
//      begin
//        // doit on archiver le mail ?
//        if MemD_Mail.FieldByName('bArchive').AsBoolean then
//        begin
//          With IdSMTP do
//          begin
//            Count := 0 ;
//            Repeat
//              Try
//                 Inc(Count) ;
//                 if Connected = false then
//                   Connect;
//                 break ;
//              Except on E:Exception do
//                begin
//                 if Retry=Count then
//                  begin
//                   // ' : Erreur lors de la connexion avec le serveur de mail', 'Erreur SMTP'
//                   // InfoMessHP(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,True,0,0,RS_TXT_RESMAN_ERRORSMTP);
//                   ologfile.Addtext(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM)+' '+E.message);
//                      ShowmessageRS(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message, RS_TXT_RESMAN_ERRORSMTP);
//
//                   Exit;
//                  end;
//                end;
//              end;
//            Until Retry=Count ;
//           end;
//
//           // Récupération du mail en entier
//           // Gestion de Twinner spécifique
//           if MaCentrale.MTY_CODE = 'RTW' then
//           begin
//            {$REGION '<---- cliquez sur le + et lire avant de modifier le code ci dessous'}
//            // La sauvegarde du fichier sur le disc dur + le traitement ne doivent pas être modifiés
//            // car les mails transmis par twinner ont des soucis de format qui sont corrigés
//            // Par l'utilisation de la sauvegarde tempporaire + nettoyage du mail.
//            {$ENDREGION}
//            IdMess.NoEncode := True;
//            IdMess.NoDecode := True;
//            IdPop.Pop3.Retrieve(i,IdMess);
//
//            IdMess.SaveToFile(GPATHMAILTMP + 'ArchTmp.txt');
//
//            lst.LoadFromFile(GPATHMAILTMP + 'ArchTmp.txt');
//            lst.Text := StringReplace(lst.Text,#13#13#10,#13#10,[rfReplaceAll]);
//            lst.SaveToFile(GPATHMAILTMP + 'ArchTmpb.txt');
//
//            IdMess.NoEncode := False;
//            IdMess.NoDecode := False;
//            IdMess.LoadFromFile(GPATHMAILTMP + 'ArchTmpb.txt');
//           end else
//            IdPop.Pop3.Retrieve(i,IdMess);
//            Count := 0 ;
//            Repeat
//            try
//              // changement de l'adresse de l'envoyeyr et du destinataire
//              Inc(Count) ;
//              idMess.Sender.Address := idSmtp.Smtp.Username ;
//              IdMess.Recipients.EMailAddresses := MaCFG.PBT_ADRARCH;
//              IdMess.From.Address :=   idSmtp.Smtp.Username ;
//              // transfert du mail- en mode algol non
//              if FAlgol = false then
//                IdSMTP.Send(IdMess);
//              Break ;
//            Except on E:Exception do
//              begin
//                if Retry = Count then
//                begin
//                // ' : Erreur lors du transfert d''un mail', 'Erreur SMTP'
//                //InfoMessHP(ParamsStr(RS_ERR_RESMAN_MAILTRANSERROR,MaCentrale.MTY_NOM) + #13#10 + E.Message,True,0,0,RS_TXT_RESMAN_ERRORSMTP);
//                ologfile.Addtext(ParamsStr(RS_ERR_RESMAN_MAILTRANSERROR,MaCentrale.MTY_NOM)+' '+E.Message) ;
//                ShowmessageRS(ParamsStr(RS_ERR_RESMAN_MAILTRANSERROR,MaCentrale.MTY_NOM)+#13#10 + E.Message,RS_TXT_RESMAN_ERRORSMTP );
//                 Exit;
//                end;
//              end;
//            end;
//            Until Retry = Count;
//             // Si l'envoi se passe bien alors on va supprimer le mail dans la boite reservation.xxx@ginkoia.fr
//             // en mode algol on ne supprime pas le message
//             if FAlgol = False then
//              begin
//                if not IdPop.Pop3.Delete(i) then
//                begin
//                  // 'Impossible de supprimer un mail', 'Erreur Pop3'
//                  //InfoMessHP(RS_ERR_RESMAN_DELERROR,True,0,0,RS_ERR_RESMAN_ERRORPOP3);
//                  ologfile.Addtext(RS_ERR_RESMAN_DELERROR+' '+idMess.Subject);
//                  ShowmessageRS(RS_ERR_RESMAN_DELERROR,RS_ERR_RESMAN_ERRORPOP3);
//                   Exit;
//                end;
//              end;
//          end; // with
//        end;
//      end;
//      // resert de la gauge
//      ResetGauge ;
//  finally
//    IdPop.Free;
//    IdMess.Free;
//    IdSMTP.Free;
//    lst.free;
//    IdPop := nil ;
//    IdMess := nil ;
//    IdSmtp := nil ;
//    lst := nil ;
//  end;
end;


// kes fonction de gestion de la barre de progression et des messages ne sont
// exécutées qu'en mode manuel

procedure TFmain.UpdateGauge;
begin
//  if Fauto = True then exit ;
  Gge_A.Progress := Gge_A.Progress+1 ;
  application.processmessages ;
end;

Procedure TFmain.InitGauge(sMessage : string ;MaxValue: Integer);
begin
//    if Fauto = True then exit ;
    Memo_Mess.caption := sMessage ;
    Memo_Mess.Update ;
    Gge_A.MaxValue := MaxValue;
    Gge_A.Progress := 0 ;
    Gge_A.Update ;
    Application.ProcessMessages;
end;

procedure TFmain.ResetGauge;
begin
  //  if Fauto = True then exit ;
    Gge_A.Progress := 0 ;
    Gge_A.MaxValue := 0 ;
    Gge_A.Update ;
end;


procedure TFmain.ShowmessageRS(sMessage, sTitle: string);
var bNeedToDisplay : boolean;
begin
 //if Fauto = True then exit ;

 Try
   bNeedtoDisplay := visible ;
   if visible then Hide ;
   Application.CreateForm(TFmessagebox, Fmessagebox);
   Fmessagebox.Caption := sTitle ;
   Fmessagebox.Memo_Mess.Caption := sMessage ;
   Fmessagebox.ShowModal ;
 Finally
   if bNeedToDisplay then Show;
   Fmessagebox.Release ;
   Fmessagebox := nil ;
 End;
   
end;

procedure TFmain.ShowmessageRS(sMessage, sTitle: string; bDetail: boolean);
var bNeedToDisplay : boolean;
begin
 //if Fauto = True then exit ;

 Try
   bNeedtoDisplay := visible ;
   if visible then Hide ;
   Application.CreateForm(TFmessagebox, Fmessagebox);
   Fmessagebox.Caption := sTitle ;
   Fmessagebox.Memo_Mess.Caption := sMessage ;

   // On affiche le bouton "Voir détail" en fonction du boolean bDetail
   Fmessagebox.Nbt_VoirDetail.Visible := bDetail;

   Fmessagebox.ShowModal ;
 Finally
   if bNeedToDisplay then Show;
   Fmessagebox.Release ;
   Fmessagebox := nil ;
 End;

end;

end.

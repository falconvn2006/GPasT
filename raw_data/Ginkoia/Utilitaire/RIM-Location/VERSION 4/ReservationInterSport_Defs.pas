unit ReservationInterSport_Defs;

interface

  uses Classes, SysUtils, StrUtils, IdMessage, IdAttachment,  IdText,
       DateUtils, xml_unit, IcXmlParser, Main_DM,IdSMTP,
       dmReservation, ReservationType_Defs, ReservationResStr,
       StdUtils, R2D2, uImap4, Variants, DB, dbugintf;


type TFichierIS = Record
  Client : Record
    Nom        : String;
    Prenom     : String;
    Adresse    : String;
    CodePostal : String;
    Ville      : String;
    Pays       : String;
    Telephone  : String;
    Fax        : String;
    Email      : String;
    Fidelite   : String;
  end;

  Reservation : record
    LangueResa   : String;
    IdPointVente : String;
    DebutResa    : TDateTime;
    FinResa      : TDateTime;
    TypeResa     : String;
    NomTO        : String;
    Acompte      : single;
    RemiseMag    : single;
    RemisePart   : single;
    TotalCmd     : single;
    NumCmd       : String;
  end;

  Participant :  array of record
    Prenom     : String;
    Poids      : String;
    Taille     : String;
    Age        : String;
    Pointure   : String;
    Sexe       : String;
    IdProduit  : String;
    NomProduit : String;
    Chaussures : String;
    Prix       : Single;
    Casque     : String;
    Duree      : String;
//    //Valeur Réglage Afnor
//    Mesures    : String;
  end;
  bTraiter     : Boolean;
//  nNewFlux     : Boolean;
  FluxFidelite : Boolean;
End;

const
  CINTERSPORT = 'RESERVATION INTERSPORT';
  CISWORDDETECTMAX  = 5;

var
  TBISWORDDETECT : Array [1..CISWORDDETECTMAX] of String =
                  (
                   'Mail CILEA de confirmation de réservation Magasin',
                   '?iso-8859-15?Q?Mail_CILEA_de_confirmation_de_r=E9servation_Magasin',
                   'Mail CILEA de confirmation de réservation Magasin SysTo',
                   '?iso-8859-15?Q?Mail_de_confirmation_de_r=E9servation_Magasin_SysTO',{,
                   'Mail de confirmation de réservation Magasin SysTO'} // Les mails avec ce format n'ont pas toutes les informations
                   'Mail SKILOU de confirmation de réservation Magasin'
                  );
  // Récupère les mails pour savoir s'il vont être traité ou non.
  function GenerateISMailList(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
  // Intégration des réservations intersport
  function DoCreateReservationIS(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
  // Permet d'extraire les données du fichier et de les mettre dans la structure TFichierIS
  // bArchiv permet d'eviter d'avoir un message d'erreur sur le traitement des fichiers en cas d'erreur sur ceux ci
  function ExtractDataFromFile(MaCentrale : TGENTYPEMAIL;sFileName :String;bArchiv : Boolean = False) : TFichierIS;
  // fonction de traitement de l'archivage des mails d'intersport
  function ArchiveMailIS(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL; reprejet : string = '') : Boolean;
implementation

uses main ;

function GenerateISMailList(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
const
  Retry = 3;
var
//  Account : Taccount ;
//  IdPop  : Tpop3Client ;
  Count : integer ; // pour tester les essais
//  IdMess : TIdMessage;
  i, iNbMess, j : integer;
  sIdMag,sIdResa : String;
  sFileName : String;
  bTraiter : Boolean;
  IMAP4 : IMAP4Class;
  lstRep : TStringList;
begin
  try
  try
    Result := False;

    Dm_Reservation.MemD_Mail.Close;
    Dm_Reservation.MemD_Mail.Open;

    if MaCfg.PBT_ADRPRINC = '' then
    begin
      //InfoMessHP('Veuillez configurer la partie @mail d''intersport',True,0,0,'Erreur');
      fmain.oLogfile.Addtext( RS_CONFIG_ISF );
      Fmain.ShowmessageRS(RS_CONFIG_ISF,'Erreur');
      Fmain.trclog('T'+RS_ERR_RESCMN_CFGMAILISF_TRC);
//      Fmain.trclog('Q-');

      Fmain.p_maj_etat('Erreur d''intégration'+ ' : '+formatdatetime('dd/mm/yyyy hh:nn',vdebut_exec) );

      Exit;
    end;

    IMAP4 := IMAP4Class.Create(Macfg.PBT_SERVEUR,Macfg.PBT_ADRPRINC,Macfg.PBT_PASSW,Macfg.PBT_PORT,True);
    IMAP4.PGStatus3D := Fmain.Gge_A;
    lstRep := TStringList.Create;
    //Try //PDB

      {$REGION 'Tentative de connexion}
      Count := 0;
      Repeat
        try
          Inc(Count) ;
          IMAP4.Connect;
          //Fmain.oLogfile.Addtext(Format(RS_CONNEXION_OK_LOG, [MaCentrale.MTY_NOM]));
          break ;
        Except on E:Exception do
          begin
            if Count = Retry then
            begin
              Fmain.Ferrorconnect := True ;
              Fmain.oLogfile.Addtext(Format(RS_ERREUR_CONNEXION_LOG, [MaCentrale.MTY_NOM, Count, Retry, E.ClassName, E.Message]));
              Fmain.ShowmessageRS(Format(RS_ERREUR_CONNEXION_DLG, [MaCentrale.MTY_NOM, E.ClassName, E.Message]), 'Erreur');
              Fmain.trclog('T'+RS_ERREUR_CONNEXION_DLG_TRC+': '+E.Message);

              FMain.p_maj_etat('Erreur d''intégration'+ ' : '+formatdatetime('dd/mm/yyyy hh:nn',vdebut_exec) );

              Exit;
            end
            else begin
              Sleep(Dm_Reservation.DelaisEssais);
            end;
          end;
        end;
      Until Retry=Count;
      {$ENDREGION}

      // Récupération de la liste des magasins à traiter
      Fmain.trclog('T**Récupération de la liste des magasins à traiter');
      With dm_reservation.Que_IdentMagExist do
      begin
        Close;
        ParamCheck := True;
        ParamByName('PMtyId').AsInteger := MaCfg.PBT_MTYID;
        Open;

        if (Recordcount > 0) then
        begin
          while not EOF do
          begin
            if ((MaCentrale.MTY_MULTI <> 0) and (dm_reservation.POSID = FieldByName('IDM_POSID').AsInteger)) Or
               (MaCentrale.MTY_MULTI = 0) then
            begin

              dm_reservation.Que_TmpLoc.Close;
              dm_reservation.Que_TmpLoc.SQL.Clear;
              dm_reservation.Que_TmpLoc.SQL.Add('Select MAG_NOM');
              dm_reservation.Que_TmpLoc.SQL.Add(' FROM GENMAGASIN');
              dm_reservation.Que_TmpLoc.SQL.Add(' WHERE MAG_ID='+inttostr(FieldByName('IDM_MAGID').asinteger));
              dm_reservation.Que_TmpLoc.ExecSQL;
              Fmain.trclog('T*Magasin : '+dm_reservation.Que_TmpLoc.FieldByName('MAG_NOM').asstring);

              lstRep.Text := StringReplace(Trim(FieldByName('IDM_PRESTA').AsString),';',#13#10,[rfReplaceAll]);

            if lstRep.Count=0 then begin

              //Uniquement mentionner ce cas dans le tracing, et pas dans le diagnostic
              Fmain.trclog('TAucun identifiant/code adhérent n''est défini pour le magasin '+dm_reservation.Que_TmpLoc.FieldByName('MAG_NOM').asstring);
            end;

              for i := 0 to lstRep.Count - 1 do
              begin
                Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Récupération des mails',[MaCentrale.MTY_NOM,RecNo, Recordcount, i + 1, lstRep.Count]),100);
                Fmain.trclog('T'+Format('%s %d sur %d : Code %d/%d'#13#10'Récupération des mails',[MaCentrale.MTY_NOM,RecNo, Recordcount, i + 1, lstRep.Count]));
                main.scodeadh:= Trim(lstRep[i]);

                Fmain.trclog('TCode adhérent='+main.scodeadh);

                // Positionnement dans le répertoire (On passe à la suite s'il n'existe pas
                if not IMAP4.SelectMailBox('Reservation/' + Trim(lstRep[i])) then
                begin
                  scodeadh := Trim(lstRep[i]);
//                  Fmain.trclog('GPas de correspondance du code adhérent '+Trim(lstRep[i])+' - Pas de boîte mail "Reservation/' + Trim(lstRep[i])+'"');
                  Fmain.trclog('GPas de réservation pour le magasin '+dm_reservation.Que_TmpLoc.FieldByName('MAG_NOM').asstring+ '(Code adhérent '+Trim(lstRep[i])+')');
                  main.berreur_codeadh := true;
                  Continue;
                end;

                // Récupération des mails du répertoire
                IMAP4.LoadAllMailBoxMsg;

                Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Sauvegarde des mails en cours',[MaCentrale.MTY_NOM,RecNo,RecordCount, i+1, lstRep.Count]),100);
                Fmain.trclog('T'+Format('%s %d sur %d : Code %d/%d'#13#10'Sauvegarde des mails en cours',[MaCentrale.MTY_NOM,RecNo,RecordCount, i+1, lstRep.Count]));
                for j := 0 to IMAP4.MsgList.Count - 1 do
                begin

                  // Génération du nom du fichier
                  repeat
                    sFileName := 'IS-' + FormatDateTime('YYYYMMDDhhmmsszzz_',Now) + IntToStr(i);
                  until (not FileExists(GPATHMAILTMP + sFileName));

                  With Dm_Reservation.MemD_Mail do
                  begin
                    Append;
                    FieldByName('MailId').AsInteger        := j + 1;
                    FieldByName('MailSubject').AsString    := IMAP4.MsgList[j].Subject;
                    FieldByName('MailAttachName').AsString := sFileName;
                    FieldByName('MailIdMag').AsString      := '';
                    FieldByName('MailIdResa').AsString     := '';
                    FieldByName('MailDate').AsDateTime     := IMAP4.MsgList[j].Date;
                    FieldByName('bTraiter').AsBoolean      := False;
                    FieldByName('bArchive').AsBoolean      := False;
                    FieldByName('bAnnulation').AsBoolean   := False;
                    FieldByName('bVoucher').AsBoolean      := False;

                    FieldByName('scodeadh').AsString := main.scodeadh;

                    Try
                      Post;
                      // Sauvegarde de la pièce jointe;
                      IMAP4.MsgList[j].Body.SaveToFile(GPATHMAILTMP + sFileName);
                    Except on E:Exception do
                      begin
                        fmain.oLogfile.Addtext('ISF -> ' + E.Message );
                        // A voir selon
                        //PDB
                        Fmain.trclog('X'+ParamsStr(RS_ERR_RESCMN_SAVEMAIL_TRC,MaCentrale.MTY_NOM)+e.message);
                      end;
                    End; // try
                  end;

                  Fmain.Gge_A.Progress := (j + 1) * 100 DIV (IMAP4.MsgList.Count);
                  FMain.Refresh;
                end; // for j
              end; // for i

            end;
            Next;
          end;
        end
        else begin
          Fmain.trclog('TPas de répertoire à traiter');
          exit; // pas de répertoire à traiter
        end;
      end;
      Result := True;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GenerateISMailList : '+e.message);
  end;
  Finally
    Fmain.ResetGauge ;
    IMAP4.Free;
    LstRep.Free;
  End;
end;

function ExtractDataFromFile(MaCentrale : TGENTYPEMAIL;sFileName :String;bArchiv : Boolean) : TFichierIS;
var
  lst        : TStringList;
  i          : integer;
  nbField    : Integer;
  nFieldFlux : Single;
  nTempRes   : string;
  nbGrpField : Integer;
  bError     : Boolean;
begin
  lst := TStringList.Create;
  try
  try
    // Init
    nbGrpField := 12;
    bError     := False;

    // Récupération du fichier
    lst.LoadFromFile(GPATHMAILTMP + sFileName);
    // suppression des caractères spéciaux et blanc devant et derriere le texte
    lst.Text := Trim(lst.Text);
    //Nettoyage de la chaîne
    lst.Text := StringReplace(lst.Text, #13#10, ' ',[rfReplaceAll]);
    // Découpage des données
    lst.Text := StringReplace(lst.Text, ';', #13#10,[rfReplaceAll]);
    //Récupération du nombre de champ de la liste
    nbField := lst.Count - 1;

    senddebug('IS> Nb. de champs='+inttostr(nbField));
    senddebug('IS>  Email='+inttostr(i)+'='+lst[8]);

////    Vérification sur quel type de flux ont est nouveau (AFNOR) ou l'ancien
//    nFieldFlux := (nbField - 20)/12;
//    nTempRes   := FloatToStr(nFieldFlux);
//
//    if ContainsStr(nTempRes, '.') then
//    begin
//      senddebug('IS> Nouveau flux 13');
//      //On est surement en présence du nouveau flux
//      nFieldFlux := (nbField - 20)/13;
//      nTempRes   := FloatToStr(nFieldFlux);
//
//      if ContainsStr(nTempRes, '.') then
//      begin
//        //Présence d'une erreur dans le fichier
//        bError := True;
//      end else
//      begin
//        Result.nNewFlux := True;
//      end;
//    end else
//    begin
//      senddebug('IS> Ancien flux 12');
//      //On est en présence de l'ancien flux
//      Result.nNewFlux := False;
//    end;
//
//    if Result.nNewFlux then
//      nbGrpField := 13
//    else
//      nbGrpField := 12;


//  Contrôle du bon nombre de champs
    nFieldFlux := (nbField - 20)/12;
    nTempRes   := FloatToStr(nFieldFlux);

    if ContainsStr(nTempRes, '.') then
    begin
      senddebug('IS> Nouveau flux Fidélité');
      //On est surement en présence du nouveau flux
      nFieldFlux := (nbField - 21)/12;
      nTempRes   := FloatToStr(nFieldFlux);

      if ContainsStr(nTempRes, '.') then
      begin
        //Présence d'une erreur dans le fichier
        bError := True;
      end
      else
      begin
        Result.FluxFidelite := True;
      end;
    end
    else
    begin
      senddebug('IS> Ancien flux sans Fidélité');
      //On est en présence de l'ancien flux
      Result.FluxFidelite := False;
    end;

    try
      With Result.Client do
      begin
        Nom        := lst[0];
        Prenom     := lst[1];
        Adresse    := lst[2];
        CodePostal := lst[3];
        Ville      := lst[4];
        Pays       := lst[5];
        Telephone  := lst[6];
        Fax        := lst[7];
        Email      := lst[8];
        Fidelite   := '';     // Renseigné après
      end;

      With Result.Reservation do
      begin
        NumCmd       := lst[19]; // mis en premier au cas ou les convertions se passe mal pour avoir le numéro de la réservation

        //PDB - Stocker au passage l'ID de Resa si le traitement ne va pas au bout, en vue d'une sortie en erreur dans le diagnostic
        senddebug('>>>ISF n° de résa='+NumCmd);
        dm_reservation.MemD_Mail.Edit;
        dm_reservation.MemD_Mail.FieldByName('MailIdResa').AsString := NumCmd;
        dm_reservation.MemD_Mail.Post;
        senddebug('>>>ISF n° de résa (après pos)='+dm_reservation.MemD_Mail.FieldByName('MailIdResa').AsString);

        LangueResa   := lst[9];
        IdPointVente := lst[10];
        DebutResa    := StrToDate(lst[11]);
        FinResa      := StrToDate(lst[12]);
        TypeResa     := lst[13];
        NomTO        := lst[14];

        // Initialisation
        Acompte := 0;
        RemiseMag := 0;
        RemisePart := 0;
        TotalCmd := 0;

        if lst[15] <> '' then
          Acompte      := StrToFloatDef(lst[15],StrToFloat(StringReplace(lst[15],',','.',[rfReplaceAll])));
        if lst[16] <> '' then
          RemiseMag    := StrToFloatDef(lst[16],StrToFloat(StringReplace(lst[16],',','.',[rfReplaceAll])));
        if lst[17] <> '' then
          RemisePart   := StrToFloatDef(lst[17],StrToFloat(StringReplace(lst[17],',','.',[rfReplaceAll])));
        if lst[18] <> '' then
          TotalCmd     := StrToFloatDef(lst[18],StrToFloat(StringReplace(lst[18],',','.',[rfReplaceAll])));
      end;

      if bError then
      begin
        Fmain.ologfile.Addtext('Erreur lors du traitement de la reservation n° '+ Result.Reservation.NumCmd + #13#10 + 'nombre de champs incorrecte');
        //PDB - Fmain.showmessagers('Erreur lors du traitement de la reservation n° '+ Result.Reservation.NumCmd + #13#10 + 'nombre de champs incorrecte', 'Erreur');
        dm_reservation.MemD_Rap.Append;
        dm_reservation.MemD_Rap.FieldByName('client').AsString := Result.Client.Nom + ' ' + Result.Client.Prenom;
        Fmain.trclog('ENombre de champs incorrect dans le mail');
        Result.bTraiter := False;
        Exit;
      end;

      i := 20;
      // remise à 0 de la taille du tableau.
      SetLength(Result.Participant,0);
      while (i + nbGrpField) < lst.Count do
      begin
        if StrToIntDef(lst[i+6],10000) < 10000 then
        begin
          // Augmentation de la taille du tableau
          SetLength(Result.Participant,Length(Result.Participant) + 1);
          With Result.Participant[Length(Result.Participant) -1] do
          begin
            Prenom     := lst[i];
            Poids      := lst[i+1];
            Taille     := lst[i+2];
            Age        := lst[i+3];
            Pointure   := lst[i+4];
            Sexe       := lst[i+5];
            IdProduit  := lst[i+6];
            NomProduit := lst[i+7];
            Chaussures := lst[i+8];

            Prix := 0;
            if lst[i+9] <> '' then
              Prix       := StrToFloatDef(lst[i+9],StrToFloat(StringReplace(lst[i+9],',','.',[rfReplaceAll])));;
            Casque     := lst[i+10];
            Duree      := lst[i+11];
//            //Valeur Réglage Afnor
//            if Result.nNewFlux then
//              Mesures    := lst[i+12];
          end; // with
        end;// if
        i := i + nbGrpField;
      end; // while

      // Champ N° carte fidélité
      if Result.FluxFidelite then
      begin
        Result.Client.Fidelite := lst[i];
      end;

      Result.bTraiter := True;

    Except on E:Exception do
      begin
        if (not bArchiv) then
          if Dm_Reservation.IsIdentMagExist(MaCentrale.MTY_MULTI, MaCentrale.MTY_ID,Result.Reservation.IdPointVente) then
            Fmain.ologfile.Addtext('La réservation : ' + Result.Reservation.NumCmd + ' du ' +
                        FormatDateTime('DD/MM/YYYY',Result.Reservation.DebutResa) + #13#10 + ' au ' + FormatDateTime('DD/MM/YYYY',Result.Reservation.FinResa) +
                        ' contient des données non traitables' + #13#10 + 'Erreur : ' + E.Message);
            //InfoMessHP('La réservation : ' + Result.Reservation.NumCmd + ' du ' +
            //            FormatDateTime('DD/MM/YYYY',Result.Reservation.DebutResa) + #13#10 + ' au ' + FormatDateTime('DD/MM/YYYY',Result.Reservation.FinResa) +
            //            ' contient des données non traitables' + #13#10 + 'Erreur : ' + E.Message,True,0,0,'');

              (*PDB - Fmain.showmessagers('La réservation : ' + Result.Reservation.NumCmd + ' du ' +
                        FormatDateTime('DD/MM/YYYY',Result.Reservation.DebutResa) + #13#10 + ' au ' + FormatDateTime('DD/MM/YYYY',Result.Reservation.FinResa) +
                        ' contient des données non traitables' + #13#10 + 'Erreur : ' + E.Message, 'Erreur') ;
                        *)

          Fmain.trclog('ELa réservation contient des données non traitables : '+ E.Message);

        Result.bTraiter := False;
      end;
    end;

    if not Result.bTraiter then begin
      Dm_Reservation.MemD_Mail.edit;
      dm_reservation.MemD_Mail.FieldByName('bArchive').AsBoolean := false;
      Dm_Reservation.MemD_Mail.post;
    end;


  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans ExtractDataFromFile : '+e.message);
  end;
  finally
    lst.Free;
    lst := nil ;
  end;
end;

function DoCreateReservationIS(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
var
  i : integer;
  FFileIS : TFichierIS;

  iIdPays         : Integer;
  iIdVille        : Integer;
  iIdClient       : Integer;
  iMagID          : Integer;
  iEtat           : Integer;
  iPaiment        : Integer;

  sNumChrono      : String;
  iIdResa         : Integer;
  iIdResaligne    : Integer;

  sIsComment      : String;
  iRLOOption      : Integer;
  iLceId          : Integer;
  iTaille,iPoids,iPointure : Integer;

  bOcError        : Boolean;

  cpt_resa:integer; //compteur drsa
  cpt_trc:integer; //PDB compteur de tracing

  bxmlresa_ok : boolean;

  //CVI - pour contrôle de validité de nomenclature (Type, Catégorie, CA)
  sCheckNomenclature : String;

  label gtResa_Next;

begin
  Fmain.trclog('TDébut de la procedure DoCreateReservationIS');
  Result := True;
  With Dm_Reservation do
  try
  try

    if MemD_Mail.RecordCount=0 then begin
      Fmain.trclog('AAucune réservation n''est disponible');
      inc(icptnoresa);
      exit;
    end;


    iEtat := GetEtat(1,0);
    iPaiment := GetEtat(1,1);

    iTaille   := GetLocParam('Taille');
    iPoids    := GetLocParam('Poids');
    iPointure := GetLocParam('Pointure');
    Memd_rap.Open ;
    With MemD_Mail do
    begin
      //InitGaugeMessHP(MaCentrale.MTY_NOM + ' : Traitement des réservations en cours ...',RecordCount + 1,True,0,0,'',False);
      Fmain.InitGauge(MaCentrale.MTY_NOM + ' : Traitement des réservations en cours ...',RecordCount + 1);
      First;
      Fmain.trclog('TBoucle de parcours des réservations');
      cpt_resa:=0;
      while not EOF do
      begin
        inc(cpt_resa);
        Fmain.trclog('TRéservation n° '+inttostr(cpt_resa));
        cpt_trc:=0;
        FFileIS := ExtractDataFromFile(MaCentrale,FieldByName('MailAttachName').AsString);

        (* fait dans ExtractDataFromFile directement
        //Stocker au passage l'ID de Resa si le traitement ne va pas au bout en vue d'une sortie en erreur dans le diagnostic)
        MemD_Mail.Edit;
        MemD_Mail.FieldByName('MailIdResa').AsString := FFileIS.Reservation.NumCmd;
        MemD_Mail.Post;
        *)

        // vérification que le mail correspond au magasin à traiter
        // et que l'on a pas eu d'erreur lors de la récupération des données
        if IsIdentMagExist(MaCentrale.MTY_MULTI, MaCentrale.MTY_ID,FFileIS.Reservation.IdPointVente) then
        begin
          cpt_trc:=10;
          MemD_Rap.append;
          MemD_Rap.FieldByName('client').AsString := FFileIS.Client.Nom + ' ' + FFileIS.Client.Prenom;
          // est ce que la réservation a déja été traité ?
          //if (not IsReservationExist(FFileIS.Reservation.NumCmd)) and FFileIS.bTraiter then
          //PDB...en tenant compte de la Centrale
          if (not IsReservationExistMulti(FFileIS.Reservation.NumCmd, -1, MaCentrale.MTY_ID)) and FFileIS.bTraiter then
          begin
            fmain.trclog('TLa résa n''existe pas');
            cpt_trc:=20;
            MemD_Rap.FieldByName('Centrale').AsString := MaCentrale.MTY_NOM;

            // récupération de l'Id Magasin
            iMagId := GetMagId(MaCentrale.MTY_ID,FFileIS.Reservation.IdPointVente);

            // Récupération de l'Id Pays
            iIdPays := GetPaysId(FFileIS.Client.Pays, iMagId);

            cpt_trc:=30;
            // récupération de l'IDVille
            iIdVille := GetVilleId(FFileIS.Client.Ville,FFileIS.Client.CodePostal,iIdPays);

            cpt_trc:=50;
            //PDB
            Fmain.trclog('TContrôle de la présence du Nom + email du client');
            bxmlresa_ok := true;
            if trim(Uppercase(FFileIS.Client.Nom))='' then begin
              Fmain.trclog('EPas de nom de client renseigné -> abandon de l''intégration de la résa');
              bxmlresa_ok :=false;
            end;

            if trim(FFileIS.Client.Email)='' then begin
              Fmain.trclog('EPas d''email client renseigné -> abandon de l''intégration de la résa');
              bxmlresa_ok :=false;
            end
            else begin
              // Recherche si le client n'existe pas déjà
              iIdClient := GetClientByMail(FFileIS.Client.Email);
              senddebug('IS> iIdClient='+inttostr(iIdClient));
              cpt_trc:=60;
              // si trouvé ouverture de la table client
              if iIdClient<>-1 then
              begin
                senddebug('IS> Client trouvé, ouverture de la table Client');
                GetClientID(iIdClient);
              end;
            end;

            if not bxmlresa_ok then goto gtResa_Next;

             cpt_trc:=70;
            // Création ou modification de l'adresse du client
            With Que_GenAdresse do
            begin
              Close;
              if (iIdClient=-1) or not(Que_Client.Active) then // creation
              begin
                senddebug('IS> Création');
                ParamByName('adrid').AsInteger := -1
              end else
              begin
                senddebug('IS> Modification');
                ParamByName('adrid').AsInteger := Que_Client.FieldByName('CLT_ADRID').AsInteger; // modification
              end;
              Open;
              cpt_trc:=80;

              if (iIdClient=-1) or not(Que_Client.Active) then
                Append   // creation
              else
                Edit;    // modification
              cpt_trc:=90;
              FieldByName('ADR_LIGNE').AsString  := FFileIS.Client.Adresse;
              FieldByName('ADR_VILID').AsInteger := iIdVille;
              FieldByName('ADR_TEL').AsString    := FFileIS.Client.Telephone;
              FieldByName('ADR_FAX').AsString    := FFileIS.Client.Fax;
              FieldByName('ADR_EMAIL').AsString  := FFileIS.Client.Email;
              cpt_trc:=100;
              Post;
              cpt_trc:=110;
            end;

            cpt_trc:=120;
            // création ou modification du client
            With Que_Client do
            begin
              if (iIdClient=-1) or not(Que_Client.Active) then // creation
              begin
                cpt_trc:=130;
                Close;
                ParamByName('cltid').AsInteger := -1;
                Open;
                cpt_trc:=140;
                Append;
              end  // sinon ouvert par GetClientID
              else
                cpt_trc:=150;
                Edit;  // modification

              FieldByName('CLT_NOM').AsString    := Uppercase(FFileIS.Client.Nom);
              FieldByName('CLT_PRENOM').AsString := Uppercase(FFileIS.Client.Prenom);
              FieldByName('CLT_ADRID').AsInteger := Que_GenAdresse.FieldByName('ADR_ID').asinteger;
              FieldByName('CLT_MAGID').AsInteger := iMagID;
              cpt_trc:=160;
              Post;
              cpt_trc:=170;
              iIdClient := FieldByName('CLT_ID').AsInteger;
            end;
            cpt_trc:=180;
            MemD_Rap.FieldByName('client').AsString := FFileIS.Client.Nom + ' ' + FFileIS.Client.Prenom;

            cpt_trc:=190;
             //Codebarre client
            InsertCodeBarre(iIdClient);

            // CodeBarre Fidélité
            InsertCodeBarreFidelite(iIdClient, FFileIS.Client.Fidelite);

            cpt_trc:=200;
            // Création de l'entete de réservation
            sNumChrono := GetProcChrono;

            cpt_trc:=210;
            iIdResa := InsertReservation(
                            iIdClient,
                            MaCentrale.MTY_CLTIDPRO,
                            iEtat,
                            iPaiment,
                            iMagId,
                            FloatToStr(FFileIS.Reservation.Acompte),
                            FFileIS.Reservation.NumCmd,
                            sNumChrono,
                            FFileIS.Reservation.NumCmd,
                            '0',
                            FloatToStr(FFileIS.Reservation.TotalCmd),
                            FFileIS.Reservation.DebutResa,
                            FFileIS.Reservation.FinResa,
                            MaCentrale.MTY_ID,
                            '0', '0', ''
                            );

            cpt_trc:=220;
            MemD_Rap.FieldByName('Num').AsString := sNumChrono;
            MemD_Rap.FieldByName('Web').AsString := FFileIS.Reservation.NumCmd;

            cpt_trc:=230;
            //Lien avec genimport
            InsertGENIMPORT(iIdResa,-11111512,5,FFileIS.Reservation.NumCmd,0);

            // s'il y a un organisme
            if MaCentrale.MTY_CLTIDPRO > 0 then
            begin
              InsertCLTMEMBREPRO_ENMIEUX(MaCentrale.MTY_CLTIDPRO, iIdClient);
            end;

            cpt_trc:=240;
            // traitement des lignes de la réservation en parcourant le tableau de participant
            for i := low(FFileIS.Participant) to high(FFileIS.Participant) do
            begin
              cpt_trc:=250;
              if FFileIS.Participant[i].Chaussures = '0' then
              begin
                if FFileIS.Participant[i].Casque = '0' then
                  iRLOOption := 1  // Offre seule
                else
                  iRLOOption := 3; // Offre seule + Casque
              end
              else begin
                if FFileIS.Participant[i].Casque = '0' then
                  iRLOOption := 2  // Offre avec chaussures
                else
                 iRLOOption := 4;  // Offre avec chaussures + Casque
              end;

              cpt_trc:=260;
              bOcError := False;
              IF not IsOCParamExist(MaCentrale.MTY_ID,StrToIntDef(FFileIS.Participant[i].IdProduit,-1),iRLOOption) THEN
              BEGIN // La relation est manquante
                cpt_trc:=270;
                {
                Fmain.ologfile.Addtext(MaCentrale.MTY_NOM +  ' : Des offres commerciales n''ont pas été trouvées pour la réservation ' + FFileIS.Reservation.NumCmd + #13#10 +
                           'du ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.DebutResa) + ' au ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.FinResa) + #13#10 +
                           'Produit : ' +  #13#10 + FFileIS.Participant[i].IdProduit + ' - ' + FFileIS.Participant[i].NomProduit);

                cpt_trc:=280;
                //InfoMessHP (MaCentrale.MTY_NOM +  ' : Des offres commerciales n''ont pas été trouvées pour la réservation ' + FFileIS.Reservation.NumCmd + #13#10 +
                //            'du ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.DebutResa) + ' au ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.FinResa) + #13#10 +
                //            'Produit : ' +  #13#10 + FFileIS.Participant[i].IdProduit + ' - ' + FFileIS.Participant[i].NomProduit,True,0,0,'Erreur');

                  (*PDB - Fmain.showmessagers(MaCentrale.MTY_NOM +  ' : Des offres commerciales n''ont pas été trouvées pour la réservation ' + FFileIS.Reservation.NumCmd + #13#10 +
                            'du ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.DebutResa) + ' au ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.FinResa) + #13#10 +
                            'Produit : ' +  #13#10 + FFileIS.Participant[i].IdProduit + ' - ' + FFileIS.Participant[i].NomProduit, 'Erreur') ;
                            *)

                Fmain.trclog('FDes offres commerciales n''ont pas été trouvées pour la réservation');

                cpt_trc:=290;
                bOcError := True;
                MemD_Rap.cancel;
                cpt_trc:=300;
                Result := False;
                Break; // on sort de la boucle for
                }

                Fmain.trclog('FLa relation avec l''OC est manquante :'+FFileIS.Participant[i].NomProduit);
                goto gtResa_Next;

              END;

              //CVI - pour contrôle de validité de nomenclature (Type, Catégorie, CA)
              Fmain.trclog('TCVI : contrôle nomenclature avec PrdId='+inttostr(iPrdId));
              sCheckNomenclature := CheckNomenclature(iPrdId);
              if sCheckNomenclature <> '' then
              begin
                Fmain.trclog('F'+sCheckNomenclature);
                goto gtResa_Next;
              end;

              cpt_trc:=310;
              sIsComment := '';
              if FFileIS.Participant[i].Casque = '1' then
                sIsComment := 'Casque / ';

              cpt_trc:=320;
//              if FFileIS.nNewFlux then
//              begin
//                cpt_trc:=330;
//                sIsComment := sIsComment +
//                            'Reg Fix : ' + FFileIS.Participant[i].Mesures  + ' / ' +
//                            'Pointure : ' + FFileIS.Participant[i].Pointure + ' / ' +
//                            'Taille : ' +  FFileIS.Participant[i].Taille + #10 +
//                            'Poids : ' +  FFileIS.Participant[i].Poids + ' / ' +
//                            'Age : ' +  FFileIS.Participant[i].Age + ' / ' +
//                            'Sexe : ' +  FFileIS.Participant[i].Sexe;
//                cpt_trc:=340;
//              end else
//              begin
                cpt_trc:=350;
                sIsComment := sIsComment +
                            'Pointure : ' + FFileIS.Participant[i].Pointure + ' / ' +
                            'Taille : ' +  FFileIS.Participant[i].Taille + #10 +
                            'Poids : ' +  FFileIS.Participant[i].Poids + ' / ' +
                            'Age : ' +  FFileIS.Participant[i].Age + ' / ' +
                            'Sexe : ' +  FFileIS.Participant[i].Sexe;
                cpt_trc:=360;
//              end;

              cpt_trc:=370;
              iIdResaligne := InsertResaLigne(MaCentrale,
                            iIdResa,
                            0,
                            StrToIntDef(FFileIS.Participant[i].Casque,0),
                            0,
                            0,
                            Que_LOCOCRELATION.fieldbyname ('RLO_PRDID').asinteger, // Ouvert lors de l'exécution de IsOCParamExist
                            FFileIS.Participant[i].Prenom,
                            '0',
                            FloatToStr(FFileIS.Participant[i].prix),
                            '',
                            FFileIS.Reservation.debutResa,
                            FFileIS.Reservation.FinResa,
                            True,
                            sIsComment
                            );

              cpt_trc:=380;
              Que_LOCOCRELATION.First;

              WHILE NOT Que_LOCOCRELATION.eof DO
              BEGIN
                With Que_LOCTYPERELATION do
                begin
                  Close;
                  ParamCheck := True;
                  ParamByName('PPrdID').AsInteger :=  Que_LOCOCRELATION.fieldbyname ('RLO_PRDID').asinteger;
                  ParamByName('PMtyId').AsInteger := MaCentrale.MTY_ID;
                  cpt_trc:=390;
                  Open;
                  cpt_trc:=400;

                  while not Que_LOCTYPERELATION.Eof do
                  begin
                    cpt_trc:=410;
                    iLceId := 0;

                    if FieldByName('LTR_PTR').AsInteger = 1 then
                    begin
                      iLceId := GetLocParamElt(iPointure,FFileIS.Participant[i].Pointure);
                      InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                    end;

                    cpt_trc:=420;
                    if FieldByName('LTR_TAILLE').AsInteger = 1 then
                    begin
                      iLceId := GetLocParamElt(iTaille,FFileIS.Participant[i].Taille);
                      InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                    end;

                    cpt_trc:=430;
                    if FieldByName('LTR_POIDS').asInteger = 1 then
                    begin
                      ilceId := GetLocParamElt(iPoids,FFileIS.Participant[i].Poids);
                      InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                    end;

                    cpt_trc:=440;
                    // On insère une ligne sans valeur
                    if iLceId = 0 then
                      InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,0);
                    Que_LOCTYPERELATION.Next;
                  end;
                  cpt_trc:=450;
                  Que_LOCOCRELATION.Next;
                end; //with
              end; // while
              cpt_trc:=460;
            end; // for i

            cpt_trc:=470;
            if not bOcError then
            begin
              cpt_trc:=480;
              // si on a bien trouver toutes les Offres commerciales on continue et on valide la réservation
              MemD_Rapdeb.asdatetime := FFileIS.Reservation.DebutResa;
              //PDB - erreur sur date -> stocker fin pas début
              //MemD_Rapfin.asdatetime := FFileIS.Reservation.DebutResa;
              MemD_Rapfin.asdatetime := FFileIS.Reservation.FinResa;

              cpt_trc:=490;
              Memd_Rap.post;

              cpt_trc:=500;
              // sauvegarde des données
              Dm_Main.StartTransaction;
              TRY
                Dm_Main.IBOUpDateCache (Que_pays) ;
                Dm_Main.IBOUpDateCache (Que_Villes) ;
                Dm_Main.IBOUpDateCache (Que_client) ;
                Dm_Main.IBOUpDateCache (Que_GenAdresse) ;
                Dm_Main.IBOUpDateCache (Que_CodeBarre) ;
                Dm_Main.IBOUpDateCache (Que_CodeBarreFidelite) ;
                Dm_Main.IBOUpDateCache (Que_resa) ;
                Dm_Main.IBOUpDateCache (Que_resal) ;
                Dm_Main.IBOUpDateCache (Que_resasl) ;
                Dm_Main.IBOUpDateCache (Que_LOCPARAMELT) ;
                Dm_Main.IBOUpDateCache (Que_GENIMPORT) ;
                Dm_Main.IBOUpDateCache (Que_CltTo) ;
                cpt_trc:=510;
                Dm_Main.Commit;
                Fmain.trclog('RIntégration réussie');
                inc(cpt_r);

                //Marquer pour archivage
                MemD_Mail.Edit;
                MemD_Mail.FieldByName('bArchive').AsBoolean := true;
                MemD_Mail.Post;
                Fmain.trclog('TRésa marquée pour archive immédiat');


              EXCEPT
                cpt_trc:=520;
                Dm_Main.Rollback;
                Dm_Main.IBOCancelCache (Que_pays) ;
                Dm_Main.IBOCancelCache (Que_Villes) ;
                Dm_Main.IBOCancelCache (Que_client) ;
                Dm_Main.IBOCancelCache (Que_GenAdresse) ;
                Dm_Main.IBOCancelCache (Que_CodeBarre) ;
                Dm_Main.IBOCancelCache (Que_CodeBarreFidelite) ;
                Dm_Main.IBOCancelCache (Que_resa) ;
                Dm_Main.IBOCancelCache (Que_resal) ;
                Dm_Main.IBOCancelCache (Que_resasl) ;
                Dm_Main.IBOCancelCache (Que_LOCPARAMELT) ;
                Dm_Main.IBOCancelCache (Que_GENIMPORT) ;
                Dm_Main.IBOCancelCache (Que_CltTo) ;
                RAISE;
              END;
              cpt_trc:=530;
            end else
            begin
              cpt_trc:=540;
              // si on a eu une erreur lors de la récupération des OC on annule la réservation
              Dm_Main.IBOCancelCache (Que_pays) ;
              Dm_Main.IBOCancelCache (Que_Villes) ;
              Dm_Main.IBOCancelCache (Que_client) ;
              Dm_Main.IBOCancelCache (Que_GenAdresse) ;
              Dm_Main.IBOCancelCache (Que_CodeBarre) ;
              Dm_Main.IBOCancelCache (Que_CodeBarreFidelite) ;
              Dm_Main.IBOCancelCache (Que_resa) ;
              Dm_Main.IBOCancelCache (Que_resal) ;
              Dm_Main.IBOCancelCache (Que_resasl) ;
              Dm_Main.IBOCancelCache (Que_LOCPARAMELT) ;
              Dm_Main.IBOCancelCache (Que_GENIMPORT) ;
              Dm_Main.IBOCancelCache (Que_CltTo) ;
              cpt_trc:=550;
            end;
            cpt_trc:=560;
            // On valide le cache
            Dm_Main.IBOCommitCache (Que_pays) ;
            Dm_Main.IBOCommitCache (Que_Villes) ;
            Dm_Main.IBOCommitCache (Que_client) ;
            Dm_Main.IBOCommitCache (Que_GenAdresse) ;
            Dm_Main.IBOCommitCache (Que_CodeBarre) ;
            Dm_Main.IBOCommitCache (Que_CodeBarreFidelite) ;
            Dm_Main.IBOCommitCache (Que_resa) ;
            Dm_Main.IBOCommitCache (Que_resal) ;
            Dm_Main.IBOCommitCache (Que_resasl) ;
            Dm_Main.IBOCommitCache (Que_LOCPARAMELT) ;
            Dm_Main.IBOCommitCache (Que_GENIMPORT) ;
            Dm_Main.IBOCommitCache (Que_CltTo) ;
            cpt_trc:=570;
          end
          else begin
            cpt_trc:=580;

            //Résa existe déjà, seulement si bTraiter, sinon on a eu une erreur de données auparavant au retour de ExtractDataFromFile
            if FFileIS.bTraiter
              then fmain.trclog('FLa réservation existe déjà');

            //PDB - En cas d'erreur, en aucun cas on archive
            Edit;
            FieldByName('bArchive').AsBoolean := false;
            (*
            // si oui doit on l'archiver ?
            if Fmain.FAlgol
              then FieldByName('bArchive').AsBoolean := false
            else FieldByName('bArchive').AsBoolean := true;  //(Abs(DaysBetween(Now,GetDateFromK(FFileIS.Reservation.NumCmd))) >= MaCfg.PBT_ARCHIVAGE);
            *)

            cpt_trc:=590;
            Post;
            cpt_trc:=600;
          end;
          cpt_trc:=610;

        end;

        cpt_trc:=620;

gtResa_Next:

        //Si sortie en erreur, on annule tout pour la résa courante
        if cpt_trc < 620 then begin
          Fmain.trclog('TSortie en erreur Resa_Next -> rollback');
          Dm_Main.IBOCancelCache (Que_pays) ;
          Dm_Main.IBOCancelCache (Que_Villes) ;
          Dm_Main.IBOCancelCache (Que_client) ;
          Dm_Main.IBOCancelCache (Que_GenAdresse) ;
          Dm_Main.IBOCancelCache (Que_CodeBarre) ;
          Dm_Main.IBOCancelCache (Que_CodeBarreFidelite) ;
          Dm_Main.IBOCancelCache (Que_resa) ;
          Dm_Main.IBOCancelCache (Que_resal) ;
          Dm_Main.IBOCancelCache (Que_resasl) ;
          Dm_Main.IBOCancelCache (Que_LOCPARAMELT) ;
          Dm_Main.IBOCancelCache (Que_GENIMPORT) ;
        end;

        cpt_trc:=630;
        Next;
         Fmain.UpdateGauge ;
        //IncGaugeMessHP(1);
      end; // while
      cpt_trc:=640;
    end; // With

  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans DoCreateReservationIS (id_trace='+inttostr(cpt_trc)+') : '+e.message);
  end;
  finally
    Fmain.ResetGauge ;
   // CloseGaugeMessHP;
  end; // With / try
  Fmain.trclog('TFin de la procedure DoCreateReservationIS');
end;

function ArchiveMailIS(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL; reprejet : string = '') : Boolean;
const
  Retry = 3;
var
  i, j : Integer;
  IdSMTP : TSmtpClient ;
  Count : integer ; // pour tester les essais

  IMAP4 : IMAP4Class;
  lstRep : TStringList;
  lstMailBox : TStringList;
begin

  Fmain.trclog('TProcédure d''archivage');
  // On sort quand on est en algol
  if Fmain.FAlgol then begin
    Fmain.trclog('TMode Algol -> pas d''archivage');
    Exit;
  end;

  if reprejet<>''
    then reprejet := '/'+reprejet;
  Fmain.trclog('TDossier de Rejet='+reprejet);

  Try //PDB
  try

    With Dm_Reservation do
    begin

    IMAP4 := IMAP4Class.Create(MaCfg.PBT_SERVEUR,MaCfg.PBT_ADRPRINC,MaCfg.PBT_PASSW,MaCfg.PBT_PORT,True);
    IMAP4.PGStatus3D := Fmain.Gge_A;
    lstRep := TStringList.Create;
    lstMailBox := TStringList.Create;

    //PDB
    //With Dm_Reservation do
    //Try

      {$REGION 'Tentative de connexion'}
      Count := 0;
      Repeat
        try
          Inc(Count) ;
          IMAP4.Connect;
          //Fmain.oLogfile.Addtext(Format(RS_CONNEXION_OK_LOG, [MaCentrale.MTY_NOM]));
          break ;
        Except on E:Exception do
          begin
            if Count = Retry then
            begin
              Fmain.Ferrorconnect := True ;
              Fmain.oLogfile.Addtext(Format(RS_ERREUR_CONNEXION_LOG, [MaCentrale.MTY_NOM, Count, Retry, E.ClassName, E.Message]));
              //PDB - Fmain.ShowmessageRS(Format(RS_ERREUR_CONNEXION_DLG, [MaCentrale.MTY_NOM, E.ClassName, E.Message]), 'Erreur');
              Fmain.trclog('T'+RS_ERREUR_CONNEXION_DLG_TRC+': '+E.Message);

              Fmain.p_maj_etat('Erreur d''intégration'+ ' : '+formatdatetime('dd/mm/yyyy hh:nn',vdebut_exec) );

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
         while not EOF do
         begin
            if ((MaCentrale.MTY_MULTI <> 0) and (dm_reservation.POSID = FieldByName('IDM_POSID').AsInteger)) Or
               (MaCentrale.MTY_MULTI = 0) then
            begin
              lstRep.Text := StringReplace(Trim(FieldByName('IDM_PRESTA').AsString),';',#13#10,[rfReplaceAll]);
              for i := 0 to lstRep.Count - 1 do
              begin
                Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Analyse des mails pour archivage',[MaCentrale.MTY_NOM,RecNo,Recordcount,i + 1, lstRep.Count]),100);
                Fmain.trclog('T'+Format('%s %d sur %d : Code %d/%d'#13#10'Analyse des mails pour archivage',[MaCentrale.MTY_NOM,RecNo,Recordcount,i + 1, lstRep.Count]));
                // Positionnement dans le répertoire (On passe à la suite s'il n'existe pas
                if not IMAP4.SelectMailBox('Reservation/' + Trim(lstRep[i])) then
                begin
                  Fmain.trclog('TN''existe pas, on passe à la suite');
                  Continue;
                end;

                // Récupération des mails du répertoire
                IMAP4.LoadAllMailBoxMsg;

                Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Archivage des mails en cours',[MaCentrale.MTY_NOM,RecNo,Recordcount, i+1, lstRep.Count]),100);
                Fmain.trclog('T'+Format('%s %d sur %d : Code %d/%d'#13#10'Archivage des mails en cours',[MaCentrale.MTY_NOM,RecNo,Recordcount, i+1, lstRep.Count]));
                Fmain.trclog('TMsgList.Count='+inttostr(IMAP4.MsgList.Count));
                for j := 0 to IMAP4.MsgList.Count - 1 do
                begin

                  Fmain.trclog('TRecheche si le mail est à traiter');
                  if MemD_Mail.Locate('MailSubject;MailDate',VarArrayOf([IMAP4.MsgList[j].Subject,IMAP4.MsgList[j].Date]),[loCaseInsensitive]) then
                  begin
                    Fmain.trclog('TDoit on archiver le mail ?');
                    if MemD_Mail.FieldByName('bArchive').AsBoolean then
                    begin
                      Fmain.trclog('TOui. Vérification si le dossier existe : '+'Archive/' + Trim(lstRep[i]) + reprejet);
                      if lstMailBox.IndexOf('Archive/' + Trim(lstRep[i]) + reprejet) = -1 then
                      begin
                        Fmain.trclog('TNon, on le créé');
                        IMAP4.CreateMailBox('Archive/' + Trim(lstRep[i]) + reprejet);
                        lstMailBox.Add('Archive/' + Trim(lstRep[i]) + reprejet);
                      end
                      else Fmain.trclog('TOui, on poursuit');

                      Fmain.trclog('TDéplacement du mail dans le dossier d''archive');
                      IMAP4.MoveMsg(j + 1,'Archive/' + Trim(lstRep[i]) + reprejet);

                    end
                    else Fmain.trclog('TNon');

                  end;

                  Fmain.Gge_A.Progress := (j + 1) * 100 DIV (IMAP4.MsgList.Count);
                  FMain.Refresh;
                end; // for j
                Fmain.trclog('TValidation des mouvements de mail');
                IMAP4.ValidMoveMsg;
              end; // for i
            end; // if

           Next;
         end; // while
       end // if
       else Fmain.trclog('TPas d''itentificatin du magasin');
     end; // With
    end; //with

  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans ArchiveMailIS : '+e.message);
  end;
  Finally
    lstMailBox.Free;
    lstRep.Free;
    IMAP4.Free;
  End;

end;



end.

unit ReservationInterSport_Defs;

interface

  uses Classes, SysUtils, StrUtils, IdMessage, IdAttachment,  IdText,
       DateUtils, xml_unit, IcXmlParser, Main_DM,IdSMTP,
       dmReservation, ReservationType_Defs, ReservationResStr,
       StdUtils, R2D2, uImap4, Variants, DB;


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
    //Valeur Réglage Afnor
    Mesures    : String;
  end;
  bTraiter     : Boolean;
  nNewFlux     : Boolean;
End;

const
  CINTERSPORT = 'RESERVATION INTERSPORT';
  CISWORDDETECTMAX  = 4;

var
  TBISWORDDETECT : Array [1..CISWORDDETECTMAX] of String =
                  (
                   'Mail CILEA de confirmation de réservation Magasin',
                   '?iso-8859-15?Q?Mail_CILEA_de_confirmation_de_r=E9servation_Magasin',
                   'Mail CILEA de confirmation de réservation Magasin SysTo',
                   '?iso-8859-15?Q?Mail_de_confirmation_de_r=E9servation_Magasin_SysTO'{,
                   'Mail de confirmation de réservation Magasin SysTO'} // Les mails avec ce format n'ont pas toutes les informations
                  );
  // Récupère les mails pour savoir s'il vont être traité ou non.
  function GenerateISMailList(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
  // Intégration des réservations intersport
  function DoCreateReservationIS(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
  // Permet d'extraire les données du fichier et de les mettre dans la structure TFichierIS
  // bArchiv permet d'eviter d'avoir un message d'erreur sur le traitement des fichiers en cas d'erreur sur ceux ci
  function ExtractDataFromFile(MaCentrale : TGENTYPEMAIL;sFileName :String;bArchiv : Boolean = False) : TFichierIS;
  // fonction de traitement de l'archivage des mails d'intersport
  function ArchiveMailIS(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
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
  Result := False;

  Dm_Reservation.MemD_Mail.Close;
  Dm_Reservation.MemD_Mail.Open;

  if MaCfg.PBT_ADRPRINC = '' then
  begin
    //InfoMessHP('Veuillez configurer la partie @mail d''intersport',True,0,0,'Erreur');
    fmain.oLogfile.Addtext( RS_CONFIG_ISF );
    Fmain.ShowmessageRS(RS_CONFIG_ISF,'Erreur');

    Exit;
  end;

  IMAP4 := IMAP4Class.Create(Macfg.PBT_SERVEUR,Macfg.PBT_ADRPRINC,Macfg.PBT_PASSW,Macfg.PBT_PORT,True);
  IMAP4.PGStatus3D := Fmain.Gge_A;
  lstRep := TStringList.Create;
  Try

    {$REGION 'Tentative de connexion}
    Count := 0;
    Repeat
      try
        Inc(Count) ;
        IMAP4.Connect;
        Fmain.oLogfile.Addtext(Format(RS_CONNEXION_OK_LOG, [MaCentrale.MTY_NOM]));
        break ;
      Except on E:Exception do
        begin
          if Count = Retry then
          begin
            Fmain.Ferrorconnect := True ;
            Fmain.oLogfile.Addtext(Format(RS_ERREUR_CONNEXION_LOG, [MaCentrale.MTY_NOM, Count, Retry, E.ClassName, E.Message]));
            Fmain.ShowmessageRS(Format(RS_ERREUR_CONNEXION_DLG, [MaCentrale.MTY_NOM, E.ClassName, E.Message]), 'Erreur');
            Exit;
          end
          else begin
            Sleep(Dm_Reservation.DelaisEssais);
          end;
        end;
      end;
    Until Retry=Count;
    {$ENDREGION}

    // Récupéraiotn de la liste des magasins à traiter
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
            lstRep.Text := StringReplace(Trim(FieldByName('IDM_PRESTA').AsString),';',#13#10,[rfReplaceAll]);
            for i := 0 to lstRep.Count - 1 do
            begin
              Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Récupération des mails',[MaCentrale.MTY_NOM,RecNo, Recordcount, i + 1, lstRep.Count]),100);
              // Positionnement dans le répertoire (On passe à la suite s'il n'existe pas
              if not IMAP4.SelectMailBox('Reservation/' + Trim(lstRep[i])) then
                Continue;

              // Récupération des mails du répertoire
              IMAP4.LoadAllMailBoxMsg;

              Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Sauvegarde des mails en cours',[MaCentrale.MTY_NOM,RecNo,RecordCount, i+1, lstRep.Count]),100);
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

                  Try
                    Post;
                    // Sauvegarde de la pièce jointe;
                    IMAP4.MsgList[j].Body.SaveToFile(GPATHMAILTMP + sFileName);
                  Except on E:Exception do
                    begin
                      fmain.oLogfile.Addtext('ISF -> ' + E.Message );
                      // A voir selon
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
      else
        exit; // pas de répertoire à traiter
    end;
    Result := True;
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

    //Vérification sur quel type de flux ont est nouveau (AFNOR) ou l'ancien
    nFieldFlux := (nbField - 20)/12;
    nTempRes   := FloatToStr(nFieldFlux);

    if ContainsStr(nTempRes, '.') then
    begin
      //On est surement en présence du nouveau flux
      nFieldFlux := (nbField - 20)/13;
      nTempRes   := FloatToStr(nFieldFlux);

      if ContainsStr(nTempRes, '.') then
      begin
        //Présence d'une erreur dans le fichier
        bError := True;
      end else
      begin
        Result.nNewFlux := True;
      end;
    end else
    begin
      //On est en présence de l'ancien flux
      Result.nNewFlux := False;
    end;

    if Result.nNewFlux then
      nbGrpField := 13
    else
      nbGrpField := 12;

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
      end;

      With Result.Reservation do
      begin
        NumCmd       := lst[19]; // mis en premier au cas ou les convertions se passe mal pour avoir le numéro de la réservation
        LangueResa   := lst[9];
        IdPointVente := lst[10];
        DebutResa    := StrToDate(lst[11]);
        FinResa      := StrToDate(lst[12]);
        TypeResa     := lst[13];
        NomTO        := lst[14];
        Acompte      := StrToFloatDef(lst[15],StrToFloat(StringReplace(lst[15],',','.',[rfReplaceAll])));
        RemiseMag    := StrToFloatDef(lst[16],StrToFloat(StringReplace(lst[16],',','.',[rfReplaceAll])));
        RemisePart   := StrToFloatDef(lst[17],StrToFloat(StringReplace(lst[17],',','.',[rfReplaceAll])));
        TotalCmd     := StrToFloatDef(lst[18],StrToFloat(StringReplace(lst[18],',','.',[rfReplaceAll])));
      end;

      if bError then
      begin
        Fmain.ologfile.Addtext('Erreur lors du traitement de la reservation n° '+ Result.Reservation.NumCmd + #13#10 + 'nombre de champs incorrecte');
        Fmain.showmessagers('Erreur lors du traitement de la reservation n° '+ Result.Reservation.NumCmd + #13#10 + 'nombre de champs incorrecte', 'Erreur');
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
            Prix       := StrToFloatDef(lst[i+9],StrToFloat(StringReplace(lst[i+9],',','.',[rfReplaceAll])));;
            Casque     := lst[i+10];
            Duree      := lst[i+11];
            //Valeur Réglage Afnor
            if Result.nNewFlux then
              Mesures    := lst[i+12];
          end; // with
        end;// if
        i := i + nbGrpField;
      end; // while
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
              Fmain.showmessagers('La réservation : ' + Result.Reservation.NumCmd + ' du ' +
                        FormatDateTime('DD/MM/YYYY',Result.Reservation.DebutResa) + #13#10 + ' au ' + FormatDateTime('DD/MM/YYYY',Result.Reservation.FinResa) +
                        ' contient des données non traitables' + #13#10 + 'Erreur : ' + E.Message, 'Erreur') ;


            
        Result.bTraiter := False;
      end;
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

begin
  Result := True;
  With Dm_Reservation do
  try
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
      while not EOF do
      begin
        FFileIS := ExtractDataFromFile(MaCentrale,FieldByName('MailAttachName').AsString);

        // vérification que le mail correspond au magasin à traiter
        // et que l'on a pas eu d'erreur lors de la récupération des données
        if IsIdentMagExist(MaCentrale.MTY_MULTI, MaCentrale.MTY_ID,FFileIS.Reservation.IdPointVente) then
        begin
          // est ce que la réservation a déja été traité ?
          if (not IsReservationExist(FFileIS.Reservation.NumCmd)) and FFileIS.bTraiter then
          begin
            memd_rap.append;
            MemD_Rap.FieldByName('Centrale').AsString := MaCentrale.MTY_NOM;
            // Récupération de l'Id Pays
            iIdPays := GetPaysId(FFileIS.Client.Pays);

            // récupération de l'IDVille
            iIdVille := GetVilleId(FFileIS.Client.Ville,FFileIS.Client.CodePostal,iIdPays);

            // récupération de l'Id Magasin
            iMagId := GetMagId(MaCentrale.MTY_ID,FFileIS.Reservation.IdPointVente);

            // Recherche si le client n'existe pas déjà
            iIdClient := GetClientByMail(FFileIS.Client.Email);
            // si trouvé ouverture de la table client
            if iIdClient<>-1 then
              GetClientID(iIdClient);

            // Création ou modification de l'adresse du client
            With Que_GenAdresse do
            begin
              Close;
              if (iIdClient=-1) or not(Que_Client.Active) then // creation
                ParamByName('adrid').AsInteger := -1
              else
                ParamByName('adrid').AsInteger := Que_Client.FieldByName('CLT_ADRID').AsInteger; // modification
              Open;

              if (iIdClient=-1) or not(Que_Client.Active) then
                Append   // creation
              else
                Edit;    // modification
              FieldByName('ADR_LIGNE').AsString  := FFileIS.Client.Adresse;
              FieldByName('ADR_VILID').AsInteger := iIdVille;
              FieldByName('ADR_TEL').AsString    := FFileIS.Client.Telephone;
              FieldByName('ADR_FAX').AsString    := FFileIS.Client.Fax;
              FieldByName('ADR_EMAIL').AsString  := FFileIS.Client.Email;
              Post;
            end;

            // création ou modification du client
            With Que_Client do
            begin  
              if (iIdClient=-1) or not(Que_Client.Active) then // creation
              begin
                Close;
                ParamByName('cltid').AsInteger := -1;
                Open;   
                Append;
              end  // sinon ouvert par GetClientID
              else
                Edit;  // modification

              FieldByName('CLT_NOM').AsString    := Uppercase(FFileIS.Client.Nom);
              FieldByName('CLT_PRENOM').AsString := Uppercase(FFileIS.Client.Prenom);
              FieldByName('CLT_ADRID').AsInteger := Que_GenAdresse.FieldByName('ADR_ID').asinteger;
              FieldByName('CLT_MAGID').AsInteger := iMagID;
              Post;
              iIdClient := FieldByName('CLT_ID').AsInteger;
            end;
            MemD_Rapclient.asstring := FFileIS.Client.Nom + ' ' + FFileIS.Client.Prenom;

             //Codebarre client
            InsertCodeBarre(iIdClient);

            // Création de l'entete de réservation
            sNumChrono := GetProcChrono;

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
                            '0', '0'
                            );

            MemD_Rap.FieldByName('Num').AsString := sNumChrono;
            MemD_Rap.FieldByName('Web').AsString := FFileIS.Reservation.NumCmd;

            //Lien avec genimport
            InsertGENIMPORT(iIdResa,-11111512,5,FFileIS.Reservation.NumCmd,0);

            // traitement des lignes de la réservation en parcourant le tableau de participant
            for i := low(FFileIS.Participant) to high(FFileIS.Participant) do
            begin
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

              bOcError := False;
              IF not IsOCParamExist(MaCentrale.MTY_ID,StrToIntDef(FFileIS.Participant[i].IdProduit,-1),iRLOOption) THEN
              BEGIN // La relation est manquante
                Fmain.ologfile.Addtext(MaCentrale.MTY_NOM +  ' : Des offres commerciales n''ont pas été trouvées pour la réservation ' + FFileIS.Reservation.NumCmd + #13#10 +
                           'du ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.DebutResa) + ' au ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.FinResa) + #13#10 +
                           'Produit : ' +  #13#10 + FFileIS.Participant[i].IdProduit + ' - ' + FFileIS.Participant[i].NomProduit);

              
                //InfoMessHP (MaCentrale.MTY_NOM +  ' : Des offres commerciales n''ont pas été trouvées pour la réservation ' + FFileIS.Reservation.NumCmd + #13#10 +
                //            'du ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.DebutResa) + ' au ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.FinResa) + #13#10 +
                //            'Produit : ' +  #13#10 + FFileIS.Participant[i].IdProduit + ' - ' + FFileIS.Participant[i].NomProduit,True,0,0,'Erreur');

                  Fmain.showmessagers(MaCentrale.MTY_NOM +  ' : Des offres commerciales n''ont pas été trouvées pour la réservation ' + FFileIS.Reservation.NumCmd + #13#10 +
                            'du ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.DebutResa) + ' au ' + FormatDateTime('DD/MM/YYYY',FFileIS.Reservation.FinResa) + #13#10 +
                            'Produit : ' +  #13#10 + FFileIS.Participant[i].IdProduit + ' - ' + FFileIS.Participant[i].NomProduit, 'Erreur') ;
                bOcError := True;
                MemD_Rap.cancel;
                Result := False;
                Break; // on sort de la boucle for
              END;

              sIsComment := '';
              if FFileIS.Participant[i].Casque = '1' then
                sIsComment := 'Casque / ';

              if FFileIS.nNewFlux then
              begin
                sIsComment := sIsComment +
                            'Reg Fix : ' + FFileIS.Participant[i].Mesures  + ' / ' +
                            'Pointure : ' + FFileIS.Participant[i].Pointure + ' / ' +
                            'Taille : ' +  FFileIS.Participant[i].Taille + #10 +
                            'Poids : ' +  FFileIS.Participant[i].Poids + ' / ' +
                            'Age : ' +  FFileIS.Participant[i].Age + ' / ' +
                            'Sexe : ' +  FFileIS.Participant[i].Sexe;
              end else
              begin
                sIsComment := sIsComment +
                            'Pointure : ' + FFileIS.Participant[i].Pointure + ' / ' +
                            'Taille : ' +  FFileIS.Participant[i].Taille + #10 +
                            'Poids : ' +  FFileIS.Participant[i].Poids + ' / ' +
                            'Age : ' +  FFileIS.Participant[i].Age + ' / ' +
                            'Sexe : ' +  FFileIS.Participant[i].Sexe;
              end;


              iIdResaligne := InsertResaLigne(MaCentrale,
                            iIdResa,
                            StrToIntDef(FFileIS.Participant[i].Casque,0),
                            0,
                            0,
                            Que_LOCOCRELATION.fieldbyname ('RLO_PRDID').asinteger, // Ouvert lors de l'exécution de IsOCParamExist
                            FFileIS.Participant[i].Prenom,
                            '0',
                            FloatToStr(FFileIS.Participant[i].prix),
                            FFileIS.Reservation.debutResa,
                            FFileIS.Reservation.FinResa,
                            True,
                            sIsComment
                            );

              Que_LOCOCRELATION.First;

              WHILE NOT Que_LOCOCRELATION.eof DO
              BEGIN
                With Que_LOCTYPERELATION do
                begin
                  Close;
                  ParamCheck := True;
                  ParamByName('PPrdID').AsInteger :=  Que_LOCOCRELATION.fieldbyname ('RLO_PRDID').asinteger;
                  ParamByName('PMtyId').AsInteger := MaCentrale.MTY_ID;
                  Open;

                  while not Que_LOCTYPERELATION.Eof do
                  begin
                    iLceId := 0;

                    if FieldByName('LTR_PTR').AsInteger = 1 then
                    begin
                      iLceId := GetLocParamElt(iPointure,FFileIS.Participant[i].Pointure);
                      InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                    end;

                    if FieldByName('LTR_TAILLE').AsInteger = 1 then
                    begin
                      iLceId := GetLocParamElt(iTaille,FFileIS.Participant[i].Taille);
                      InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                    end;

                    if FieldByName('LTR_POIDS').asInteger = 1 then
                    begin
                      ilceId := GetLocParamElt(iPoids,FFileIS.Participant[i].Poids);
                      InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,iLceId);
                    end;

                    // On insère une ligne sans valeur
                    if iLceId = 0 then
                      InsertResaSousLigne(iIdResaligne,Que_LOCTYPERELATION.fieldbyname ('LTR_TCAID') .asinteger,0);
                    Que_LOCTYPERELATION.Next;
                  end;
                  Que_LOCOCRELATION.Next;
                end; //with
              end; // while
            end; // for i

            if not bOcError then
            begin
              // si on a bien trouver toutes les Offres commerciales on continue et on valide la réservation
              MemD_Rapdeb.asdatetime := FFileIS.Reservation.DebutResa;
              MemD_Rapfin.asdatetime := FFileIS.Reservation.DebutResa;

              Memd_Rap.post;

              // sauvegarde des données
              Dm_Main.StartTransaction;
              TRY
                Dm_Main.IBOUpDateCache (Que_pays) ;
                Dm_Main.IBOUpDateCache (Que_Villes) ;
                Dm_Main.IBOUpDateCache (Que_client) ;
                Dm_Main.IBOUpDateCache (Que_GenAdresse) ;
                Dm_Main.IBOUpDateCache (Que_CodeBarre) ;
                Dm_Main.IBOUpDateCache (Que_resa) ;
                Dm_Main.IBOUpDateCache (Que_resal) ;
                Dm_Main.IBOUpDateCache (Que_resasl) ;
                Dm_Main.IBOUpDateCache (Que_LOCPARAMELT) ;
                Dm_Main.IBOUpDateCache (Que_GENIMPORT) ;
                Dm_Main.Commit;
              EXCEPT
                Dm_Main.Rollback;
                Dm_Main.IBOCancelCache (Que_pays) ;
                Dm_Main.IBOCancelCache (Que_Villes) ;
                Dm_Main.IBOCancelCache (Que_client) ;
                Dm_Main.IBOCancelCache (Que_GenAdresse) ;
                Dm_Main.IBOCancelCache (Que_CodeBarre) ;
                Dm_Main.IBOCancelCache (Que_resa) ;
                Dm_Main.IBOCancelCache (Que_resal) ;
                Dm_Main.IBOCancelCache (Que_resasl) ;
                Dm_Main.IBOCancelCache (Que_LOCPARAMELT) ;
                Dm_Main.IBOCancelCache (Que_GENIMPORT) ;
                RAISE;
              END;
            end else
            begin
              // si on a eu une erreur lors de la récupération des OC on annule la réservation
              Dm_Main.IBOCancelCache (Que_pays) ;
              Dm_Main.IBOCancelCache (Que_Villes) ;
              Dm_Main.IBOCancelCache (Que_client) ;
              Dm_Main.IBOCancelCache (Que_GenAdresse) ;
              Dm_Main.IBOCancelCache (Que_CodeBarre) ;
              Dm_Main.IBOCancelCache (Que_resa) ;
              Dm_Main.IBOCancelCache (Que_resal) ;
              Dm_Main.IBOCancelCache (Que_resasl) ;
              Dm_Main.IBOCancelCache (Que_LOCPARAMELT) ;
              Dm_Main.IBOCancelCache (Que_GENIMPORT) ;
            end;
            // On valide le cache
            Dm_Main.IBOCommitCache (Que_pays) ;
            Dm_Main.IBOCommitCache (Que_Villes) ;
            Dm_Main.IBOCommitCache (Que_client) ;
            Dm_Main.IBOCommitCache (Que_GenAdresse) ;
            Dm_Main.IBOCommitCache (Que_CodeBarre) ;
            Dm_Main.IBOCommitCache (Que_resa) ;
            Dm_Main.IBOCommitCache (Que_resal) ;
            Dm_Main.IBOCommitCache (Que_resasl) ;
            Dm_Main.IBOCommitCache (Que_LOCPARAMELT) ;
            Dm_Main.IBOCommitCache (Que_GENIMPORT) ;

          end
          else begin
            // si oui doit on l'archiver ?
            Edit;
            if Fmain.FAlgol = False then
              FieldByName('bArchive').AsBoolean := True else  //(Abs(DaysBetween(Now,GetDateFromK(FFileIS.Reservation.NumCmd))) >= MaCfg.PBT_ARCHIVAGE);
                FieldByName('bArchive').AsBoolean := False;
            Post;
          end;
        end;
        Next;
         Fmain.UpdateGauge ;
        //IncGaugeMessHP(1);
      end; // while
    end; // With
  finally
    Fmain.ResetGauge ;
   // CloseGaugeMessHP;
  end; // With / try

end;

function ArchiveMailIS(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;  
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
  // On sort quand on est en algol
  if Fmain.FAlgol then
    Exit;

  IMAP4 := IMAP4Class.Create(MaCfg.PBT_SERVEUR,MaCfg.PBT_ADRPRINC,MaCfg.PBT_PASSW,MaCfg.PBT_PORT,True);
  IMAP4.PGStatus3D := Fmain.Gge_A;
  lstRep := TStringList.Create;
  lstMailBox := TStringList.Create;
  With Dm_Reservation do
  Try

    {$REGION 'Tentative de connexion'}
    Count := 0;
    Repeat
      try
        Inc(Count) ;
        IMAP4.Connect;      
        Fmain.oLogfile.Addtext(Format(RS_CONNEXION_OK_LOG, [MaCentrale.MTY_NOM]));
        break ;
      Except on E:Exception do
        begin
          if Count = Retry then
          begin
            Fmain.Ferrorconnect := True ;
            Fmain.oLogfile.Addtext(Format(RS_ERREUR_CONNEXION_LOG, [MaCentrale.MTY_NOM, Count, Retry, E.ClassName, E.Message]));
            Fmain.ShowmessageRS(Format(RS_ERREUR_CONNEXION_DLG, [MaCentrale.MTY_NOM, E.ClassName, E.Message]), 'Erreur');
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
              // Positionnement dans le répertoire (On passe à la suite s'il n'existe pas
              if not IMAP4.SelectMailBox('Reservation/' + Trim(lstRep[i])) then
                Continue;

              // Récupération des mails du répertoire
              IMAP4.LoadAllMailBoxMsg;

              Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Archivage des mails en cours',[MaCentrale.MTY_NOM,RecNo,Recordcount, i+1, lstRep.Count]),100);
              for j := 0 to IMAP4.MsgList.Count - 1 do
              begin

                if MemD_Mail.Locate('MailSubject;MailDate',VarArrayOf([IMAP4.MsgList[j].Subject,IMAP4.MsgList[j].Date]),[loCaseInsensitive]) then
                begin
                  if MemD_Mail.FieldByName('bArchive').AsBoolean then
                  begin
                    if lstMailBox.IndexOf('Archive/' + Trim(lstRep[i])) = -1 then
                    begin
                      IMAP4.CreateMailBox('Archive/' + Trim(lstRep[i]));
                      lstMailBox.Add('Archive/' + Trim(lstRep[i]));
                    end;

                    IMAP4.MoveMsg(j + 1,'Archive/' + Trim(lstRep[i]));
                  end;

                end;

                Fmain.Gge_A.Progress := (j + 1) * 100 DIV (IMAP4.MsgList.Count);
                FMain.Refresh;
              end; // for j
              IMAP4.ValidMoveMsg;
            end; // for i
          end; // if

         Next;
       end; // while
     end; // if
   end; // With
  Finally
    lstMailBox.Free;
    lstRep.Free;
    IMAP4.Free;
  End;
end;



end.

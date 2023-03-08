unit VoirTicket_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IB_Components, DB, dxmdaset, IBODataset, ConvertorRv;

type
  TFrm_VoirTicket = class(TForm)
    Lbx_Liste: TListBox;
    Panel1: TPanel;
    Nbt_Ok: TBitBtn;
    Que_EntTicket: TIBOQuery;
    Que_EntTicketTKE_ID: TIntegerField;
    Que_EntTicketTKE_SESID: TIntegerField;
    Que_EntTicketTKE_CLTID: TIntegerField;
    Que_EntTicketTKE_DATE: TDateTimeField;
    Que_EntTicketTKE_DETAXE: TIntegerField;
    Que_EntTicketTKE_NUMERO: TIntegerField;
    Que_EntTicketTKE_TOTBRUTA1: TIBOFloatField;
    Que_EntTicketTKE_REMA1: TIBOFloatField;
    Que_EntTicketTKE_USRID: TIntegerField;
    Que_EntTicketTKE_TOTNETA1: TIBOFloatField;
    Que_EntTicketTKE_QTEA1: TIBOFloatField;
    Que_EntTicketTOTEURO: TIBOFloatField;
    Que_EntTicketTOTENC: TIBOFloatField;
    Que_EntTicketARENDRE: TIBOFloatField;
    Que_EntTicketRESTE: TIBOFloatField;
    Que_EntTicketCLIENT: TStringField;
    Que_EntTicketCLT_COMMENT: TMemoField;
    Que_EntTicketCPTCLI: TIBOFloatField;
    Que_EntTicketSOLDECPT: TIBOFloatField;
    Que_EntTicketENCOURSBL: TIBOFloatField;
    Que_EntTicketUSR_USERNAME: TStringField;
    Que_EntTicketTKE_DIVINT: TIntegerField;
    Que_EntTicketTKE_DIVFLOAT: TIBOFloatField;
    Que_EntTicketSES_NUMERO: TStringField;
    Que_EntTicketTKE_CTEID: TIntegerField;
    Que_EntTicketTKE_CHEFCLTID: TIntegerField;
    Que_EntTicketCLT_NUMERO: TStringField;
    Que_EntTicketTOTGEN: TIBOFloatField;
    Que_EntTicketTKE_TOTNETA2: TIBOFloatField;
    Que_EntTicketPOS_ID: TIntegerField;
    Que_Ticket: TIBOQuery;
    Que_TicketTKL_ID: TIntegerField;
    Que_TicketUSR_USERNAME: TStringField;
    Que_TicketARF_CHRONO: TStringField;
    Que_TicketTKL_TYPEVTE: TIntegerField;
    Que_TicketART_NOM: TStringField;
    Que_TicketTGF_NOM: TStringField;
    Que_TicketTKL_REMISE: TIBOFloatField;
    Que_TicketTKL_QTE: TIBOFloatField;
    Que_TicketTKL_PXNET: TIBOFloatField;
    Que_TicketTKL_USRID: TIntegerField;
    Que_TicketTKL_TKEID: TIntegerField;
    Que_TicketTKL_ARTID: TIntegerField;
    Que_TicketTKL_TGFID: TIntegerField;
    Que_TicketTKL_COUID: TIntegerField;
    Que_TicketTKL_NOM: TStringField;
    Que_TicketTKL_PXBRUT: TIBOFloatField;
    Que_TicketTKL_SSTOTAL: TIntegerField;
    Que_TicketTKL_SSMONTANT: TIBOFloatField;
    Que_TicketTKL_COMENT: TStringField;
    Que_TicketCOU_NOM: TStringField;
    Que_TicketSTOCK: TIBOFloatField;
    Que_TicketTKL_GPSSTOTAL: TIntegerField;
    Que_TicketTKL_INSSTOTAL: TIntegerField;
    Que_TicketTKL_TYPID: TIntegerField;
    Que_TicketTYP_COD: TIntegerField;
    Que_TicketTKL_TVA: TIBOFloatField;
    Que_TicketTKL_PXNN: TIBOFloatField;
    Que_TicketPRIXZERO: TIBOFloatField;
    Que_TicketPXUNITNET: TIBOFloatField;
    Que_TicketREMISE: TIBOFloatField;
    Que_TicketART_REFMRK: TStringField;
    Que_TicketARF_FIDELITE: TIntegerField;
    Que_TicketARF_VIRTUEL: TIntegerField;
    Que_TicketVALREMGLO: TIBOFloatField;
    Que_TicketDESI: TStringField;
    Que_TicketTYPGEN: TStringField;
    Que_Enc: TIBOQuery;
    Que_EncMEN_NOM: TStringField;
    Que_EncENC_MONTANT: TIBOFloatField;
    Que_EncENC_ECHEANCE: TDateTimeField;
    Que_EncENC_ID: TIntegerField;
    Que_EncENC_TKEID: TIntegerField;
    Que_EncENC_MENID: TIntegerField;
    Que_EncENC_DEPENSE: TIntegerField;
    Que_EncENC_MOTIF: TStringField;
    Que_EncTYP: TLargeintField;
    Que_EncCHEQUE: TLargeintField;
    Que_EncTIROIR: TLargeintField;
    Que_EncMEN_TYPEMOD: TIntegerField;
    Que_EncMEN_RACCOURCI: TStringField;
    Que_EncMEN_ISODEF: TStringField;
    Que_EncMEN_DATEECH: TIntegerField;
    Que_EncENC_BA: TIBOFloatField;
    Que_CptCli: TIBOQuery;
    Que_CptCliCTE_LIBELLE: TStringField;
    Que_CptCliCTE_DEBIT: TIBOFloatField;
    Que_CptCliCTE_CREDIT: TIBOFloatField;
    Que_CptCliCTE_CLTID: TIntegerField;
    Que_CptCliCTE_MAGID: TIntegerField;
    Que_CptCliCTE_DATE: TDateTimeField;
    Que_CptCliCTE_REGLER: TDateTimeField;
    Que_CptCliCTE_ID: TIntegerField;
    Que_CptCliTYP: TIBOFloatField;
    Que_CptCliCTE_TKEID: TIntegerField;
    Que_CptCliCTE_TYP: TIntegerField;
    MemD_LT: TdxMemData;
    MemD_LTLigne: TStringField;
    Ds_Lt: TDataSource;
    IbC_NumTck: TIB_Cursor;
    IbC_Reajust: TIB_Cursor;
    IbC_Typ: TIB_Cursor;
    Convertor: TConvertorRv;
    procedure FormCreate(Sender: TObject);
    procedure Que_TicketCalcFields(DataSet: TDataSet);
  private
    { Déclarations privées } 
    tkeid: integer;
    LeCaption: STRING;
    Location: Boolean;  
    FUNCTION Convert(Value: Extended): STRING;
    PROCEDURE NewLigne(groupe, zone: STRING; recu: boolean; journal: boolean);
    procedure CMDialogKey(var M: TCMDialogKey); message CM_DIALOGKEY;
  public
    { Déclarations publiques }
    procedure InitEcr(TKEID: integer);
  end;

resourcestring
  LabTKl = 'Ticket'; 
  VenteDetaxee = 'VENTE DETAXEE'; 
  LbCorrectionMP = 'CORRECTION ENCAISSEMENT';     
  AnnuationTck = 'ANNULATION DU TICKET NUMERO '; 
  MoinsRemise = '  DONT REMISE : ';
  TotalVente = 'TOTAL DES VENTES';     
  RecapLoc = 'Location';     
  TotalAPayer = 'TOTAL A PAYER';       
  type59 = 'Remboursement de la TVA';
  ARendre = 'A RENDRE';
  ReajustCompteLib = 'REAJUSTEMENT DU COMPTE CLIENT';   
  Promo = 'Promo';
  Solde = 'Solde';
  Normale = 'Normale';

implementation 

uses
  Main_Dm, stdutils;

{$R *.dfm}

FUNCTION TFrm_VoirTicket.Convert(Value: Extended): STRING;
BEGIN
  Result := Convertor.Convert(Value);
END;

procedure TFrm_VoirTicket.CMDialogKey(var M: TCMDialogKey);
begin
  if m.CharCode=VK_ESCAPE then
  begin
    m.Result:=1;
    Close;
    exit;
  end;
  inherited;
end; 

PROCEDURE TFrm_VoirTicket.NewLigne(groupe, zone: STRING; recu: boolean; journal: boolean);
BEGIN
  zone := zone + strs(' ', 40);

  Memd_Lt.append;
  MemD_LTLigne.asstring := '     ' + copy(zone, 1, 40);
  memd_lt.post;
END;

procedure TFrm_VoirTicket.Que_TicketCalcFields(DataSet: TDataSet);
begin 
  //Px unitaire Net
  IF que_ticket.fieldbyname('tkl_qte').asfloat <> 0 THEN
    que_ticket.fieldbyname('PxUnitNet').asfloat := que_ticket.fieldbyname('tkl_pxnet').asfloat /
      que_ticket.fieldbyname('tkl_qte').asfloat
  ELSE
    que_ticket.fieldbyname('PxUnitNet').asfloat := 0;

  //Remise Ligne
  IF que_ticket.fieldbyname('tkl_sstotal').asinteger <> 1 THEN
    que_ticket.fieldbyname('Remise').asfloat := (que_ticket.fieldbyname('tkl_pxbrut').asfloat *
      que_ticket.fieldbyname('tkl_qte').asfloat) - que_ticket.fieldbyname('tkl_pxnet').asfloat
  ELSE //Calcul pour un sous Total
    que_ticket.fieldbyname('Remise').asfloat := que_ticket.fieldbyname('tkl_pxbrut').asfloat -
      que_ticket.fieldbyname('tkl_pxnet').asfloat;

  //Lib du typGEN
  text := '';
  CASE que_ticket.fieldbyname('typ_cod').asinteger OF
    1: que_ticketTYPGEN.asstring := '';
    3: que_ticketTYPGEN.asstring := uppercase(promo);
    2: que_ticketTYPGEN.asstring := uppercase(solde);
  END;

  //DESI ARTICLE
  IF que_ticket.fieldbyname('tkl_nom').asstring <> '' THEN
    que_ticketDESI.asstring := que_ticket.fieldbyname('tkl_nom').asstring
  ELSE
    que_ticketDESI.asstring := que_ticket.fieldbyname('art_nom').asstring;
end;

procedure TFrm_VoirTicket.FormCreate(Sender: TObject);
begin 
  Convertor.DefaultMnyRef := Convertor.GetTMYTYP('EUR');
  Convertor.DefaultMnyTgt := Convertor.GetTMYTYP('FRF');
  Convertor.ReInit;
end;

procedure TFrm_VoirTicket.InitEcr(TKEID: integer);
VAR
  text, zone, numeroticket: STRING;
  montant, montantright: STRING;
  i, j: integer;
  remisef, solde, Arr: double;

  receipt: STRING[40];
  tailcoul: STRING[15];
  tail, coul: STRING;
  lib: STRING[22];

  ref_mrk: STRING;

  qte, prix, prixright, prixuright, typ: ansiSTRING;
  pad: char;
BEGIN

  //Mode normal ou mode training
  ibc_typ.close;
  ibc_typ.parambyname('tkeid').asinteger := tkeid;
  ibc_typ.open;
  IF NOT ibc_typ.eof THEN
  BEGIN
    // Mode trainning
    i := Que_entticket.Sql.indexof('FROM CSHTICKET');
    Que_entticket.Sql[i] := 'FROM CSHTICKETTRG';
    Que_entticket.Sql.delete(i + 1);

    i := Que_ticket.Sql.indexof('FROM CSHTICKETL');
    Que_ticket.Sql[i] := 'FROM CSHTICKETLTRG';
    Que_ticket.Sql.delete(i + 1);

    i := Que_enc.Sql.indexof('FROM CSHENCAISSEMENT');
    Que_enc.Sql[i] := 'FROM CSHENCAISSEMENTTRG';
    Que_enc.Sql.delete(i + 1);

    i := Que_cptcli.Sql.indexof('FROM CLTCOMPTE');
    Que_cptcli.Sql[i] := 'FROM CLTCOMPTETRG';
    Que_cptcli.Sql.delete(i + 1);

  END;

  memd_lt.close;
  memd_lt.open;

  //lab 1175 inversion d'ordre  pour récupèrer le bon posidavant 1 ibc_numtck 2 Que_entticket
  que_entticket.close;
  que_entticket.parambyname('tkeid').asinteger := tkeid;
  que_entticket.open;
  LeCaption := LeCaption + ' ' + LabTkl + ' N° ' + que_entticketTKE_NUMERO.asstring;

  ibc_numtck.close;
  ibc_numtck.parambyname('posid').asinteger := que_entticket.fieldbyname('pos_id').asInteger;
  ibc_numtck.open;
  NumeroTicket := ibc_numtck.fieldbyname('ident').asstring;
  LeCaption := '  ' + NUmeroTicket;
  //        ibc_numtck.close;
  //        ibc_numtck.parambyname('posid').asinteger := stdginkoia.posteId;
  //        ibc_numtck.open;
  //        NumeroTicket := ibc_numtck.fieldbyname('ident').asstring;
  //        LeCaption := '  ' + NUmeroTicket;
  //
  //        que_entticket.close;
  //        que_entticket.parambyname('tkeid').asinteger := tkeid;
  //        que_entticket.open;
  //        LeCaption := LeCaption + ' ' + LabTkl + ' N° ' + que_entticketTKE_NUMERO.asstring;
  //fin lab 1175

  IF Que_EntTicketTKE_TOTNETA2.asfloat <> 0 THEN
    location := true
  ELSE
    location := false;

  //Ouverture query lignes
  que_ticket.close;
  que_ticket.parambyname('tkeid').asinteger := tkeid;
  que_ticket.open;

  //    newligne(text, '', true, false);

          //Identification du ticket
  zone := NumeroTicket + '-' + que_entticket.fieldbyname('ses_numero').asstring + '-' +
    que_entticket.fieldbyname('tke_numero').asstring;

  newligne(text, zone, true, true);

  zone := DateTimeToStr(que_entticket.fieldbyname('tke_date').AsDateTime);
  IF que_entticket.fieldbyname('tke_cltid').asinteger <> 0 THEN //Numéro du client
    zone := zone + ' ' + que_entticket.fieldbyname('clt_numero').asstring;

  newligne(text, zone, true, true);

  //Ident du caissier
  zone := Strs(' ', 40);
  IF que_entticketTke_Usrid.asinteger <> 0 THEN
  BEGIN
    zone := que_entticket.fieldbyname('usr_username').asstring;
    Newligne(text, zone, true, true);
  END;

  //Ident du vendeur 1ère ligne
  zone := Strs(' ', 40);
  que_ticket.first;
  IF (NOT que_ticket.eof) AND (que_ticketTKL_usrid.asinteger <> 0) THEN
  BEGIN
    zone := que_ticket.fieldbyname('usr_username').asstring;
    Newligne(text, zone, true, true);
  END;

  //TEXTE VENTE DETAXEE
  IF Que_EntTicketTKE_DETAXE.asinteger = 1 THEN
  BEGIN
    zone := Ventedetaxee;
    Newligne(text, zone, true, true);
  END;

  //Correction de mode de paiement globale
  IF que_entticket.fieldbyname('tke_divfloat').asinteger = 1 THEN
  BEGIN
    newligne(text, '', true, false);
    newligne(text, LbCorrectionMP, true, true);
  END;

  //Si annulation ticket pas d'impression de lignes
  //ni de la remise siur le total
  IF (que_entticket.fieldbyname('tke_divint').asinteger <> 0) AND
    (que_entticket.fieldbyname('tke_divint').asstring <> '') THEN
  BEGIN
    //Impression du numero du ticket annulé
    newligne(text, AnnuationTck + inttostr(que_entticket.fieldbyname('tke_divint').asinteger), true, true);
    newligne(text, '', true, false);
  END
  ELSE
  BEGIN

    //Ticket Classique
    //Impression des lignes

    newligne(text, '', true, false);

    que_ticket.first;
    WHILE NOT que_ticket.eof DO
    BEGIN
      IF NOT ((que_ticket.recordcount = 1) AND (que_ticket.fieldbyname('tkl_artid').asinteger = 0)) THEN
      BEGIN

        pad := #32;

        typ := que_ticketTypGen.asstring;
        Lib := que_ticketDESI.asstring;

        qte := que_tickettkl_qte.asstring;
        tail := que_tickettgf_nom.asstring;
        coul := que_ticketcou_nom.asstring;

        ref_mrk := que_ticketArf_Chrono.asstring;
        lib := ref_mrk + ' / ' + lib;

        IF trim(tail) <> '' THEN
        BEGIN
          IF trim(coul) <> '' THEN
            tailcoul := '[' + tail + '/' + coul + ']'
          ELSE
            tailcoul := '[' + tail + ']';
        END
        ELSE
        BEGIN
          IF trim(coul) <> '' THEN
            tailcoul := '[' + coul + ']'
          ELSE
            tailcoul := '';
        END;

        IF length(tailcoul) = 15 THEN tailcoul[15] := ']';

        prix := floattostrf(que_ticketTkl_Pxnet.asfloat, fffixed, 15, 2);
        prixright := AlignLeft(prix, pad, 9);

        //Px Unitaire net
        prix := floattostrf(que_ticket.fieldbyname('PxUnitNet').asfloat, fffixed, 15, 2);
        prixuright := AlignLeft(prix, pad, 9);

        //Insertion du prix  total
        receipt := Strs(' ', 40);
        j := 1;
        FOR i := 32 TO 40 DO
        BEGIN
          receipt[i] := prixright[j];
          inc(j);
        END;

        IF que_ticketTkl_sstotal.asstring <> '1' THEN
        BEGIN //Ce n'est pas un sous total
          //Insertion du prix unitaire
          j := 1;
          FOR i := 18 TO 26 DO
          BEGIN
            receipt[i] := prixuright[j];
            inc(j);
          END;
        END;

        //Insertion Taille  (sauf si ligne sous total)
        IF que_ticketTkl_sstotal.asstring <> '1' THEN
        BEGIN
          j := 1;
          FOR i := 1 TO length(Tailcoul) DO
          BEGIN
            receipt[i + 2] := tailcoul[j];
            inc(j);
          END;
        END;

        //Insertion Qte
        qte := 'x' + qte;
        j := 1;
        FOR i := 28 TO 27 + length(qte) DO
        BEGIN
          receipt[i] := qte[j];
          inc(j);
        END;

        //Ligne avec désignation article
        IF trim(typ) = '' THEN // Vente normale
          Newligne(text, lib, true, true)
        ELSE //Vente solde ou promo
          Newligne(text, typ + '/' + lib, true, true);

        //Ligne avec Taille,Qté,Prix
        Newligne(text, receipt, true, true);

        //Ligne si remise
        IF roundrv(que_ticketTkl_REMISE.asfloat, 2) <> 0 THEN
        BEGIN
          prix := que_ticketREMISE.asstring;

          receipt := Strs(' ', 40);
          receipt := MoinsRemise + prix + ' ' + 'EUR' + receipt;
          NewLigne(text, receipt, true, true);
        END;

        //Ligne Vide si SousTotal
        IF que_ticketTkl_sstotal.asstring = '1' THEN
          newligne(text, '', true, true);

      END;
      que_ticket.next;
    END;
    //Ligne Vide finale
    Newligne(text, '', true, false);
  END;

  //Remise sur l'onglet vente
  IF que_entticket.fieldbyname('tke_rema1').asfloat <> 0 THEN
  BEGIN
    zone := Strs(' ', 40);
    zone := TOTALVENTE + zone;

    montant := Convert(que_entticket.fieldbyname('tke_TOTNETA1').asfloat);
    montantright := AlignLeft(montant, #32, 9);

    j := 1;
    FOR i := 32 TO 40 DO
    BEGIN
      zone[i] := montantright[j];
      inc(j);
    END;
    newligne(text, zone, true, true);

    remiseF := que_entticket.fieldbyname('tke_TOTBRUTA1').asfloat -
      que_entticket.fieldbyname('tke_TOTNETA1').asfloat;
    montant := Convert(remiseF);

    zone := Strs(' ', 40);
    zone := MoinsRemise + montant + ' ' + 'EUR' + zone;
    newligne(text, zone, true, true);
    newligne(text, '', true, false);
  END;

  IF location THEN
  BEGIN
    zone := Strs(' ', 40);
    zone := uppercase(RecapLoc) + zone;

    montant := floattostrf(Que_EntTicketTKE_TOTNETA2.asfloat, fffixed, 15, 2);
    montantright := AlignLeft(montant, #32, 9);

    j := 1;
    FOR i := 32 TO 40 DO
    BEGIN
      zone[i] := montantright[j];
      inc(j);
    END;
    newligne(text, zone, true, true);
    newligne(text, '', true, false);
  END;

  //impression des Avances,règlement,rembourssement
  que_cptcli.close;
  que_cptcli.parambyname('tkeid').asinteger := tkeid;
  que_cptcli.open;

  ARR := 0;
  que_cptcli.first;
  WHILE NOT que_cptcli.eof DO
  BEGIN
    IF (que_cptcli.fieldbyname('cte_typ').asinteger <> 4) AND
      (que_cptcli.fieldbyname('cte_typ').asinteger <> 5) THEN
    BEGIN //On n'imprime pas ICI les ligne Reste du et compte client...
      solde := que_cptcli.fieldbyname('cte_credit').asfloat - que_cptcli.fieldbyname('cte_debit').asfloat;
      Arr := Arr + solde;
      montant := Convert(solde);
      montantright := AlignLeft(montant, #32, 9);

      zone := Strs(' ', 40);
      zone := uppercase(que_cptcli.fieldbyname('cte_libelle').asstring) + zone;
      j := 1;
      FOR i := 32 TO 40 DO
      BEGIN
        zone[i] := montantright[j];
        inc(j);
      END;
      newligne(text, zone, true, true);
    END;
    que_cptcli.next;
  END;

  IF que_cptcli.recordcount <> 0 THEN
    newligne(text, '', true, false);

  //Impression du total à payer
  montant := Convert(que_entticket.fieldbyname('totgen').asfloat + Arr);
  montantright := AlignLeft(montant, #32, 9);
  zone := Strs(' ', 40);
  zone := TotalAPayer + ' (' + 'EUR' + ')' + zone;
  j := 1;
  FOR i := 32 TO 40 DO
  BEGIN
    zone[i] := montantright[j];
    inc(j);
  END;
  Newligne(text, zone, true, true);

  //    //Total en Euros  ou plutot dans la monnaie cible
  //    //montant := floattostr ( roundrv ( que_entticket.fieldbyname ( 'totgen' ) .asfloat, 2 ) ) ;
  //    montant := frm_CommonCaisse.convertorTAPconvert(que_entticket.fieldbyname('totgen').asfloat);
  //
  //    zone := Strs(' ', 40);
  //    zone := TotalEuros + montant + ' ' + stdginkoia.GetIso(StdGinkoia.Convertor.DefaultMnyTgt) + ')' + zone;
  //    Newligne(text, zone, true, true);
  Newligne(text, '', true, false);

  //Impression des encaissements

  que_enc.close;
  que_enc.parambyname('tkeid').asinteger := tkeid;
  que_enc.open;

  que_enc.first;
  WHILE NOT que_enc.eof DO
  BEGIN
    //Edition des MP

    //Si c'est une dépense on l'indique ICI
    IF que_enc.fieldbyname('enc_depense').asinteger = 1 THEN
    BEGIN
      zone := que_enc.fieldbyname('enc_motif').asstring;
      newligne(text, zone, true, true);
    END;

    //Si c'est un Rembourssement TVA on l'indique ICI
    IF que_enc.fieldbyname('enc_depense').asinteger = 2 THEN
    BEGIN
      zone := type59;
      newligne(text, zone, true, true);

      zone := que_enc.fieldbyname('enc_motif').asstring;
      IF zone <> '' THEN newligne(text, zone, true, true);
    END;

    zone := Strs(' ', 40);
    IF que_enc.FieldByName('enc_motif').Asstring <> '%%%A rendre%%%' THEN
    BEGIN // Ce sont les ligne sd'encaissement normale
      zone := Uppercase(que_enc.fieldbyname('men_nom').asstring) + zone;
      IF que_encMen_IsoDef.asstring <> 'EUR' THEN
      BEGIN
        IF Que_EncENC_BA.asfloat = 0 THEN
          montant := Convert(que_enc.fieldbyname('enc_montant').asfloat)
        ELSE
          montant := Convert(que_enc.fieldbyname('enc_ba').asfloat);
      END;
    END
    ELSE
    BEGIN //C'est le rendu de monnaie
      IF que_encMen_IsoDef.asstring <> 'EUR' THEN
      BEGIN
        montant := Convert((-1) * que_enc.fieldbyname('enc_montant').asfloat);
        zone := ARendre + zone;
      END;
      //            ELSE
      //            BEGIN
      //                montant := frm_CommonCaisse.convertorTAPconvert((-1) * que_enc.fieldbyname('enc_montant').asfloat);
      //                zone := ARendre + ' (' + stdginkoia.GetIso(StdGinkoia.Convertor.DefaultMnytgt) + ')' + zone;
      //            END;
    END;

    montantright := AlignLeft(montant, #32, 9);

    j := 1;
    FOR i := 32 TO 40 DO
    BEGIN
      zone[i] := montantright[j];
      inc(j);
    END;
    newligne(text, zone, true, true);
    que_enc.next;
  END;

  IF que_enc.recordcount <> 0 THEN
    newligne(text, '', true, false); //Ligne vide

  //Est ce un ticket de réajustement de compte?

  IF que_entticketTKE_Cteid.asinteger <> 0 THEN
  BEGIN
    ibc_reajust.close;
    ibc_reajust.parambyname('cte_id').asinteger := que_entticketTKE_Cteid.asinteger;
    ibc_reajust.open;
    IF NOT ibc_reajust.eof THEN
    BEGIN
      zone := ibc_reajust.fieldbyname('cte_libelle').asstring;
      IF length(zone) > 30 THEN zone := copy(zone, 1, 30);
      zone := zone + Strs(' ', 40);

      IF ibc_reajust.fieldbyname('cte_credit').asfloat <> 0 THEN
        montant := floattostrf(ibc_reajust.fieldbyname('cte_credit').asfloat, fffixed, 15, 2)
      ELSE
        montant := floattostrf(ibc_reajust.fieldbyname('cte_debit').asfloat * (-1), fffixed, 15, 2);

      montantright := AlignLeft(montant, #32, 9);
      j := 1;
      FOR i := 32 TO 40 DO
      BEGIN
        zone[i] := montantright[j];
        inc(j);
      END;
      Newligne(text, ReajustCompteLib, true, true);
      Newligne(text, zone, true, true);
      Newligne(text, '', true, false);

    END;
    ibc_reajust.close;
  END;

  Lbx_Liste.Clear;
  memd_lt.first;
  while not(memd_lt.Eof) do
  begin
    Lbx_Liste.Items.Add(memd_lt.fieldbyname('Ligne').AsString);
    memd_lt.Next;
  end;
  SendMessage(Lbx_Liste.Handle,LB_SETCURSEL,0,0);
end;

end.

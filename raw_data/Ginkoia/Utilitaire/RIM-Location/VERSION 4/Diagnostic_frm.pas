unit Diagnostic_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, ExtCtrls, RzPanel, dxDBGrid, dxDBTLCl,
  dxGrClms, dxTL, dxDBCtrl, dxCntner, dxDBGridHP, DB, dxmdaset, dbugintf,
  dxExEdtr, dxEdLib, dxDBELib, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkSide, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinPumpkin, dxSkinSilver, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, cxDBData, cxCheckBox, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView,
  cxGrid,
  ReservationType_Defs, dmReservation;

type                                                                                  
  TFDiagnostic = class(TForm)
    Pan_Fond: TRzPanel;
    Pan_Btn: TRzPanel;
    Nbt_Ok: TLMDSpeedButton;
    Pan_Text: TRzPanel;
    MemD_Reservations: TdxMemData;
    Ds_Reservations: TDataSource;
    MemD_ReservationsClient: TStringField;
    MemD_ReservationsNumResa: TStringField;
    MemD_ReservationsDate: TDateField;
    MemD_ReservationsNature: TStringField;
    MemD_ReservationsCentrale: TStringField;
    MemD_ReservationsRejet: TIntegerField;
    MemD_ReservationsRaison: TMemoField;
    Nbt_TraiteRejet: TLMDSpeedButton;
    MemD_ReservationsEnabled: TIntegerField;
    label_global: TLabel;
    Pan_MessGlobal: TPanel;
    cxg_DiagReservation: TcxGrid;
    cxg_DiagReservationDBTableView1: TcxGridDBTableView;
    cxg_DiagReservationDBTableView1RecId: TcxGridDBColumn;
    cxg_DiagReservationDBTableView1Nature: TcxGridDBColumn;
    cxg_DiagReservationDBTableView1Centrale: TcxGridDBColumn;
    cxg_DiagReservationDBTableView1Date: TcxGridDBColumn;
    cxg_DiagReservationDBTableView1NumResa: TcxGridDBColumn;
    cxg_DiagReservationDBTableView1Client: TcxGridDBColumn;
    cxg_DiagReservationDBTableView1Raison: TcxGridDBColumn;
    cxg_DiagReservationDBTableView1Rejet: TcxGridDBColumn;
    cxg_DiagReservationDBTableView1Enabled: TcxGridDBColumn;
    cxg_DiagReservationLevel1: TcxGridLevel;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle_Content: TcxStyle;
    cxStyle_Selection: TcxStyle;
    MemD_ReservationsMailSubject: TStringField;
    MemD_ReservationsMailDate: TDateField;
    Chk_all: TCheckBox;
    MemD_Reservationsquand: TDateTimeField;
    cxg_DiagReservationDBTableView1Quand: TcxGridDBColumn;
    Tim_wait: TTimer;
    procedure Nbt_OkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxg_DiagReservationDBTableView1NatureCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure cxg_DiagReservationDBTableView1RejetCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure cxg_DiagReservationDBTableView1Editing(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      var AAllow: Boolean);
    procedure cxg_DiagReservationDBTableView1DataControllerSummaryAfterSummary(
      ASender: TcxDataSummary);
    procedure cxg_DiagReservationDBTableView1RaisonGetCellHint(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      ACellViewInfo: TcxGridTableDataCellViewInfo; const AMousePos: TPoint;
      var AHintText: TCaption; var AIsHintMultiLine: Boolean;
      var AHintTextRect: TRect);
    procedure Nbt_TraiteRejetClick(Sender: TObject);
    procedure MemD_ReservationsAfterPost(DataSet: TDataSet);
    procedure Chk_allClick(Sender: TObject);
    procedure cxg_DiagReservationDBTableView1DblClick(Sender: TObject);
    procedure Tim_waitTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    bLoad : boolean;
    bdonotshow : boolean;
  end;

var
  FDiagnostic: TFDiagnostic;

implementation

Uses Main, ReservationInterSport_Defs;

{$R *.dfm}

//------------------------------------------------------------------------------
procedure TFDiagnostic.Chk_allClick(Sender: TObject);
var
  cpt : integer;
  i: Integer;
  iIndexData: Integer;
begin
  bload:=true;
  try
    cxg_DiagReservation.BeginUpdate;
    MemD_Reservations.DisableControls;

    cpt:=0;
    // On boucle sur les éléments présents visuellement dans la grille
    for i := 0 to cxg_DiagReservationDBTableView1.ViewData.RecordCount - 1 do
    begin
      // On récupère l'index côté data
      iIndexData := cxg_DiagReservationDBTableView1.DataController.FilteredRecordIndex[i];


      if MemD_Reservations.Locate('Centrale;NumResa',
        VarArrayOf([cxg_DiagReservationDBTableView1.DataController.Values[iIndexData, cxg_DiagReservationDBTableView1Centrale.Index],
        cxg_DiagReservationDBTableView1.DataController.Values[iIndexData, cxg_DiagReservationDBTableView1NumResa.Index]]),
        [loCaseInsensitive]) then
      begin
        // Normalement, on doit toujours le trouver
        if (MemD_Reservations.FieldByName('Enabled').AsInteger=1) then
        begin
          MemD_Reservations.edit;
          if Chk_all.checked then
          begin
             MemD_Reservations.FieldByName('Rejet').AsInteger:=1;
             inc(cpt);
          end
          else MemD_Reservations.FieldByName('Rejet').AsInteger:=0;
          MemD_Reservations.post;
        end;
      end;
    end;
  finally
    cxg_DiagReservation.EndUpdate();
  end;

  MemD_Reservations.EnableControls;
  bload:=false;

  if cpt>0
    then Nbt_TraiteRejet.enabled := true
    else Nbt_TraiteRejet.enabled := false;

end;

procedure TFDiagnostic.cxg_DiagReservationDBTableView1DataControllerSummaryAfterSummary(
  ASender: TcxDataSummary);
var
  Index : integer;
begin
(* Désactiver car plus de summary, le total n'exprimant pas vraiment le nbre. d'archivage à réaliser
  // On récupère l'index correspondant au footer summary
  Index := ASender.FooterSummaryItems.IndexOfItemLink(cxg_DiagReservationDBTableView1Rejet);

  // On active ou désactive le bouton "Traiter les rejets" en fonction de la valeur du summary
  if ASender.FooterSummaryValues[Index] > 0 then
    Nbt_TraiteRejet.Enabled := True
  else
    Nbt_TraiteRejet.Enabled := False;
*)
end;

procedure TFDiagnostic.cxg_DiagReservationDBTableView1DblClick(Sender: TObject);
begin
  messagedlg('Raison : '+memd_reservations.fieldbyname('raison').asstring ,mtInformation, [mbOk], 0);
end;

//------------------------------------------------------------------------------
procedure TFDiagnostic.cxg_DiagReservationDBTableView1Editing(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var AAllow: Boolean);
begin
  // Si champ 'Enabled' = 0, on ne peut pas éditer la ligne
  if Sender.DataController.Values[Sender.DataController.FocusedRecordIndex, cxg_DiagReservationDBTableView1Enabled.Index] = 0 then
    AAllow := False
  else begin
    AAllow := True;
  end;
end;

//------------------------------------------------------------------------------
procedure TFDiagnostic.cxg_DiagReservationDBTableView1NatureCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if AViewInfo.Text = 'Réussi' then
  begin
    ACanvas.Brush.Color := RGB(176, 242, 182);   // Vert
  end
  else if AViewInfo.Text = 'Echec' then
  begin
    ACanvas.Brush.Color := RGB(176, 216, 255);    // Bleu
  end
  else if AViewInfo.Text = 'Problème' then
  begin
    ACanvas.Brush.Color := RGB(255, 197, 138);    // Orange
  end
  else if AViewInfo.Text = 'Erreur' then
  begin
    ACanvas.Brush.Color := RGB(255, 149, 149);  // Rouge
  end
  else if AViewInfo.Text = 'Abandon' then
  begin
    ACanvas.Brush.Color := RGB(255, 255, 193);    // Jaune
  end
  else
  begin
    if not AViewInfo.Selected or not AViewInfo.Focused then
    begin
      ACanvas.Brush.Color := clWhite;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TFDiagnostic.cxg_DiagReservationDBTableView1RaisonGetCellHint(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  ACellViewInfo: TcxGridTableDataCellViewInfo; const AMousePos: TPoint;
  var AHintText: TCaption; var AIsHintMultiLine: Boolean;
  var AHintTextRect: TRect);
begin
//   AHintText := MemD_Reservations.fieldbyname('Raison').asstring;
//   AIsHintMultiLine := true;
end;

procedure TFDiagnostic.cxg_DiagReservationDBTableView1RejetCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
 if AViewInfo.RecordViewInfo.GridRecord.Values[cxg_DiagReservationDBTableView1Enabled.Index] = 0 then
 begin
   ACanvas.Brush.Color := RGB(247, 247, 247);
 end
 else
 begin
  ACanvas.Brush.Color := clWhite;
 end;
end;


//------------------------------------------------------------------------------
procedure TFDiagnostic.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TFDiagnostic.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Nbt_TraiteRejet.Enabled then begin
    if messagedlg('Des éléments ont été marqués pour archivage et ne seront pas traîtés.'+#13+#10+
      'Souhaitez-vous quand même quitter l''aplication?' ,mtConfirmation, [mbYes,mbNo], 0) = mrYes
    then CanClose := true
    else CanClose := false;

  end
  else CanClose := true;

end;

//------------------------------------------------------------------------------
procedure TFDiagnostic.FormCreate(Sender: TObject);
begin
  FDiagnostic.Width := 1024;
  FDiagnostic.Height := 405;
  bdonotshow:=false;
  {
  DBG_DiagReservation.BeginUpdate;
  MemD_Reservations.Close;
  MemD_Reservations.Open;
  MemD_Reservations.DelimiterChar := ';';
  MemD_Reservations.LoadFromTextFile('C:\Developpement\Ginkoia\UTILITAIRE\Rim-Location\SKISET\Resa_RIM.txt');
  DBG_DiagReservation.EndUpdate;
  }
end;

//------------------------------------------------------------------------------
procedure TFDiagnostic.FormShow(Sender: TObject);
begin
  {
  MemD_Reservations.edit;
  MemD_Reservations.FieldByName('Raison').AsString := 'Test';
  MemD_Reservations.Post;
  }
  //DBG_DiagReservationId.Visible := False;
  //Ds_Reservations.DataSet.Refresh;
  //DBG_DiagReservation.Refresh;
end;

procedure TFDiagnostic.MemD_ReservationsAfterPost(DataSet: TDataSet);
var
  cpt,irec : integer;
  srec : string;
  iv : integer;
begin
  if not bLoad then begin

    bload:=true;

    MemD_Reservations.DisableControls;

    iv:= MemD_Reservations.FieldByName('Rejet').AsInteger;

    if not not MemD_Reservations.eof
      then irec := MemD_Reservations.RecNo
      else irec := -1;

    srec := '';
    cpt:=0;
    MemD_Reservations.First;
    while not MemD_Reservations.eof do
    begin

      //Ne prendre que ceux actif et marqués pour archivage
      if (MemD_Reservations.FieldByName('Enabled').AsInteger=1) and
         (MemD_Reservations.FieldByName('Rejet').AsInteger=1) then
      begin
        inc(cpt);
        //Garder le n° de résa pour faire une seconde passe et cocher en auto toutes celles qui seraint à double
        if pos(';'+MemD_Reservations.FieldByName('NumResa').AsString+';' , srec) = 0 then
          srec := srec +';'+MemD_Reservations.FieldByName('NumResa').AsString+';';
      end;

      MemD_Reservations.next;
    end;

    if cpt>0 then
      Nbt_TraiteRejet.Enabled := True
    else
      Nbt_TraiteRejet.Enabled := False;


    (* Plus nécessaire : les raisons de résa multi sont concaténées ensemble
    //Seconde passe pour auto coche sur les doublons
    MemD_Reservations.First;
    while not MemD_Reservations.eof do
    begin
      if pos(';'+MemD_Reservations.FieldByName('NumResa').AsString+';' , srec)>0 then
      begin
         MemD_Reservations.edit;
         MemD_Reservations.FieldByName('Rejet').AsInteger:=iv;
         MemD_Reservations.post;
      end;
      MemD_Reservations.next;
    end;
    *)
    
    if irec>-1 then MemD_Reservations.RecNo := irec;

    MemD_Reservations.EnableControls;

    bload:=false;

  end;
end;

//------------------------------------------------------------------------------
procedure TFDiagnostic.Nbt_OkClick(Sender: TObject);
begin
  Close;
end;

procedure TFDiagnostic.Nbt_TraiteRejetClick(Sender: TObject);
var
  FListCentrale  : TListGENTYPEMAIL;
  MaCFG          : TCFGMAIL;
  i,irec,ir,ioldr : integer;
  ok : boolean;
  sc : string;
  snumresa : string;
  trecno : array of integer;
begin
  try

  if messagedlg('Souhaitez-vous archiver les éléments marqués ?',mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin

    screen.Cursor := crHourglass;

    Fmain.trclog('TDemande de traitement d''archivage manuel');

    Fmain.trclog('TRécupération de la liste des centrales');
    FListCentrale := dm_reservation.GetListCentrale ;

    bload:=true; //pour intercepter l'event on afterpost

    //D'abord conserver le rec courant
    if not MemD_Reservations.eof
      then irec:=MemD_Reservations.recno
      else irec:=-1;

     MemD_Reservations.DisableControls;

    //  Trier le memd sur la centrale de manière à imbriquer 2 niveaux de while et traiter une centrale à la fois
    // (et récupérer sa cfg email une seule fois)
    MemD_Reservations.SortedField:='Centrale';

    MemD_Reservations.first;
    sc:='';
    ioldr:=0; // pour forcer le passage initial dans la boucle
    while (not MemD_Reservations.eof) and (ioldr>-1) do
    begin

      sc := MemD_Reservations.FieldByName('Centrale').asstring;
      Fmain.trclog('T>Traitement de la centrale "'+sc+'"');

      i:=0;
      ok:=false;
      //Rechercher la centrale
      while (not ok) and (i<FListCentrale.Count) do begin
        //trclog('T'+uppercase(FListCentrale.Items[i].MTY_NOM)+'='+uppercase(sc));
        if pos(uppercase(FListCentrale.Items[i].MTY_NOM), uppercase(sc))>0
          then ok:=true
          else inc(i);
      end;

      //Récupérer sa configuration email
      if ok then
      begin

        Fmain.trclog('TRécupération de sa config mail');
        MaCFG := dm_reservation.GetMailCFG(FListCentrale.Items[i]);

        //Vider Memd_Mail
        while not dm_reservation.MemD_Mail.eof
          do dm_reservation.MemD_Mail.Delete;
        dm_reservation.MemD_Mail.Close;
        dm_reservation.MemD_Mail.Open;

        Fmain.trclog('TPréparation des enregistrements marqués à traiter pour la centrale');
        snumresa := '';

        while (not MemD_Reservations.eof) and (sc=MemD_Reservations.FieldByName('Centrale').asstring) do
        begin

          Fmain.trclog('T   Passage rec n° '+inttostr(MemD_Reservations.RecNo)+' - '+MemD_Reservations.fieldbyname('NumResa').asstring);

          //Ne prendre que ceux actif et marqués pour archivage
          if (MemD_Reservations.FieldByName('Enabled').AsInteger=1) and
             (MemD_Reservations.FieldByName('Rejet').AsInteger=1) and
             (MemD_Reservations.FieldByName('NumResa').AsString<>'<Non disponible>') and
             (MemD_Reservations.FieldByName('NumResa').AsString<>'') then
          begin

            //S'assurer que un n° de résa identique n'a pas déjà étét pris en compte
            // (possible si plusieurs erreurs pour une même résa)
            if pos(';'+MemD_Reservations.fieldbyname('NumResa').asstring+';',snumresa)=0 then begin

              //Cumul de la résa pour vérification
              snumresa := snumresa+';'+MemD_Reservations.fieldbyname('NumResa').asstring+';';

              Fmain.trclog('TPrise en compte de la résa n° '+MemD_Reservations.fieldbyname('NumResa').asstring);
              //Les ajouter au MemD_Mail de travail utilisé par l'archivage
              dm_reservation.MemD_Mail.append;
              dm_reservation.MemD_Mail.fieldbyname('MailSubject').asstring := MemD_Reservations.fieldbyname('MailSubject').asstring;
              dm_reservation.MemD_Mail.fieldbyname('MailDate').AsDateTime := MemD_Reservations.fieldbyname('MailDate').AsDateTime;
              dm_reservation.MemD_Mail.FieldByName('bArchive').AsBoolean := true;
              dm_reservation.MemD_Mail.FieldByName('MailID').AsInteger := MemD_Reservations.RecNo;  //Garder le recno pour remettre à jour chaque record traité
              dm_reservation.MemD_Mail.post;
            end
            else Fmain.trclog('TRésa n° '+MemD_Reservations.fieldbyname('NumResa').asstring+' déjà prise en compte');
          end;

          MemD_Reservations.next;

        end;

        //Archivage des enregistrements sélectionnés
        if dm_reservation.MemD_Mail.RecordCount>0 then
        begin

          Fmain.trclog('T'+inttostr(dm_reservation.MemD_Mail.RecordCount)+' enregistrement(s) à traiter');

          Fmain.trclog('TAppel au module d''archivage');
          //Appel du module d'archivage : ISF ou autres
          if Main.bISF then ArchiveMailIS(FListCentrale.Items[i],MaCFG, 'Rejet')
          else FMain.ArchivMail(FListCentrale.Items[i],MaCFG, 'Rejet');

          Fmain.trclog('TArchivage réalisé');

          //Conserver la position...
          if not MemD_Reservations.eof
            then ioldr := MemD_Reservations.RecNo
            else ioldr := -1;

          //Indication visuelle dans le diagnostic de ce qui a été traité
          setlength(trecno,0);
          dm_reservation.MemD_Mail.first;
          bLoad := true; //Pour bloquer le afterpost
          while not dm_reservation.MemD_Mail.eof do
          begin

            MemD_Reservations.RecNo := dm_reservation.MemD_Mail.FieldByName('MailID').AsInteger;  //utiliser pour stocker le recno initial de MemD_Reservations et se repositionner
            ir:=length(trecno);
            setlength(trecno,ir+1);
            trecno[ir]:=dm_reservation.MemD_Mail.FieldByName('MailID').AsInteger;
            (* Pas ici sinon soucis pour traiter plusieurs modules/centrales
            MemD_Reservations.edit;
            MemD_Reservations.FieldByName('Enabled').AsInteger:=0;
            MemD_Reservations.FieldByName('Rejet').AsInteger:=1;
            MemD_Reservations.post;
             *)
            dm_reservation.MemD_Mail.next;
          end;

          //Se repositionner...
          if ioldr>-1 then MemD_Reservations.RecNo := ioldr;

        end
        else  Fmain.trclog('TAucun enregistrement à traiter -> passage à la centrale suivante');

      end
      else begin
        Fmain.trclog('TImpossible de retrouver la centrale et sa configuration mail ');
        MemD_Reservations.next;
      end;

    end;

    Fmain.trclog('TFIN de la demande de traitement d''archivage manuel');

    Fmain.trclog('TMise à jour de la fenêtre de diagnostic');
    ir:=0;
    while ir<length(trecno) do begin
      MemD_Reservations.RecNo := trecno[ir];
      MemD_Reservations.edit;
      MemD_Reservations.FieldByName('Enabled').AsInteger:=0;
      MemD_Reservations.FieldByName('Rejet').AsInteger:=1;
      MemD_Reservations.post;
      inc(ir);
    end;

    Fmain.trclog('MArchivage terminé');

    //Désactiver tout autre possibilité d'agir.
    Nbt_TraiteRejet.Enabled := False;
    chk_all.Enabled := false;
    MemD_ReservationsRejet.ReadOnly:=true;

    MemD_Reservations.SortedField:='';

    //Se repositionner avant de poursuivre
    if irec>-1
      then MemD_Reservations.RecNo := irec;
    bLoad := false;

    MemD_Reservations.EnableControls;

    screen.Cursor := crDefault;

  end;

  except
    on e:exception do begin
      Fmain.ShowmessageRS(E.Message, 'Erreur à l''archivage');
    end;
  end;

end;

procedure TFDiagnostic.Tim_waitTimer(Sender: TObject);
begin
  Fmain.trclog('TAuto-destruction!');
  Fmain.trclog('T=================');
  Close;
end;

end.

unit twinner_frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  //uses perso
  ProgressForm_Frm, AfficheErreurSelAuto_Frm, Patienter_Frm, Twinner_Dm,
  GinkoiaStyle_Dm, uVersion, UxTheme, dxExEdtr, Date_Frm, FidNATTwin_Frm,
  //fin
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdBaseComponent,
  IdComponent, AdvOfficePagerStylers, IdFTP, AdvOfficePager, dxmdaset, dxGrClEx,
  GinPanel, AdvGlowButton, GraphUtil, IBCustomDataSet, IBQuery, IBDatabase,
  dxDBGridHP, ExtCtrls, RzPanel, StdCtrls, DB, dxDBGrid, dxDBTLCl, dxGrClms,
  dxTL, dxDBCtrl, dxCntner, Buttons, DBSBtn, IniCfg_Frm;

const
  WM_DEMARRE = WM_USER + 50;

type
  TFrm_Twinner = class(TForm)
    Ds_Mag: TDataSource;
    Ds_Dos: TDataSource;
    mdc: TdxMemData;
    OD_Bases: TOpenDialog;
    mdListeAdherent: TdxMemData;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    AdvGlowButton1: TAdvGlowButton;
    Img_1: TImage;
    AOO_Principale: TAdvOfficePagerOfficeStyler;
    Page_Accueil: TAdvOfficePager;
    AOPageMyTwinner: TAdvOfficePage;
    AOPageExtraction: TAdvOfficePage;
    GinPanel1: TGinPanel;
    Pan_Dos: TRzPanel;
    Nbt_Actd: TAdvGlowButton;
    Pan_Navig: TRzPanel;
    Nbt_Insert: TDBSpeedButton;
    Nbt_Delete: TDBSpeedButton;
    Nbt_Edit: TDBSpeedButton;
    Nbt_Post: TDBSpeedButton;
    Nbt_Cancel: TDBSpeedButton;
    GinPanel2: TGinPanel;
    pan_mag: TRzPanel;
    RzPanel1: TRzPanel;
    dbSBtnAppend: TDBSpeedButton;
    dbSBtnEdit: TDBSpeedButton;
    dbSBtnSave: TDBSpeedButton;
    dbSBtnCancel: TDBSpeedButton;
    dbSBtnDelete: TDBSpeedButton;
    Nbt_ActM: TAdvGlowButton;
    Nbt_DesactM: TAdvGlowButton;
    Nbt_RefreshMags: TAdvGlowButton;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    DBG_Dos: TdxDBGridHP;
    DBG_DosDOS_ID: TdxDBGridMaskColumn;
    DBG_DosDOS_NOM: TdxDBGridMaskColumn;
    DBG_DosDOS_GUID: TdxDBGridMaskColumn;
    DBG_DosDOS_CHEMIN: TdxDBGridExtLookupColumn;
    DBG_DosDOS_ACTIF: TdxDBGridCheckColumn;
    DBG_DosDOS_DATEACTIV: TdxDBGridDateColumn;
    DBG_DosDOS_lastversion: TdxDBGridMaskColumn;
    DBG_Mag: TdxDBGridHP;
    DBG_MagMAG_ID: TdxDBGridMaskColumn;
    DBG_MagMAG_DOSID: TdxDBGridMaskColumn;
    DBG_MagMAG_NOM: TdxDBGridMaskColumn;
    DBG_MagMAG_ENSEIGNE: TdxDBGridMaskColumn;
    DBG_MagMAG_CODEADH: TdxDBGridMaskColumn;
    DBG_MagMAG_VILLE: TdxDBGridMaskColumn;
    DBG_MagMAG_IDFID: TdxDBGridMaskColumn;
    DBG_MagColumn7: TdxDBGridCheckColumn;
    DBG_MagColumn8: TdxDBGridColumn;
    DBG_MagMAG_MAGID: TdxDBGridMaskColumn;
    GinPanel3: TGinPanel;
    RzPanel4: TRzPanel;
    Nbt_SelAuto: TAdvGlowButton;
    RzPanel6: TRzPanel;
    DBG_DosMag: TdxDBGridHP;
    Nbt_TraiteExtract: TAdvGlowButton;
    Nbt_ActuExtract: TAdvGlowButton;
    Ds_DosMag: TDataSource;
    DBG_DosMagmag_id: TdxDBGridMaskColumn;
    DBG_DosMagdos_nom: TdxDBGridMaskColumn;
    DBG_DosMagmag_codeadh: TdxDBGridMaskColumn;
    DBG_DosMagmag_nom: TdxDBGridMaskColumn;
    DBG_DosMagmag_ville: TdxDBGridMaskColumn;
    DBG_DosMagCanSelect: TdxDBGridColumn;
    DBG_DosMagOkSelect: TdxDBGridCheckColumn;
    OD_SelAuto: TOpenDialog;
    IdFTP1: TIdFTP;
    DBG_DosMagsCodeSur6: TdxDBGridMaskColumn;
    Nbt_Envoi: TAdvGlowButton;
    Nbt_Parametrage: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Ds_DosStateChange(Sender: TObject);
    procedure Nbt_ActdClick(Sender: TObject);
    procedure DBG_DosDOS_CHEMINEditButtonClick(Sender: TObject);
    procedure Nbt_ActMClick(Sender: TObject);
    procedure Ds_MagDataChange(Sender: TObject; Field: TField);
    procedure FormShow(Sender: TObject);
    procedure Nbt_RefreshMagsClick(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure Nbt_DesactMClick(Sender: TObject);
    procedure DBG_MagCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: string;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
    procedure DBG_DosMagCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: string;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
    procedure Nbt_ActuExtractClick(Sender: TObject);
    procedure DBG_DosMagDblClick(Sender: TObject);
    procedure Nbt_SelAutoClick(Sender: TObject);
    procedure Nbt_TraiteExtractClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure Nbt_InsertAfterAction(Sender: TObject; var Error: Boolean);
    procedure Page_AccueilChanging(Sender: TObject; FromPage, ToPage: Integer;
      var AllowChange: Boolean);
    procedure Nbt_EnvoiClick(Sender: TObject);
    procedure Nbt_ParametrageClick(Sender: TObject);
  private
        { Déclarations privées }
    // taille du fichier à transférer par FTP
    iTailleFicATransferer: Int64;
    bActivate: boolean;
    procedure ChargeDatabase;
    procedure WmDemarre(var m: TMessage); message WM_DEMARRE;
    procedure RechFicAEnvoyer(AListeFic: TStrings);
    function EnvoieParFTP(AListeFic: TStrings): integer;
    function DoEnvoiFTP: integer;
    procedure DrawCellCheckBox(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: string;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
    procedure Active_DesactiveMagasin(bActive: boolean);
  public
        { Déclarations publiques }
    procedure refreshMag;
  end;

var
  Frm_Twinner: TFrm_Twinner;

implementation

{$R *.DFM}

function TFrm_Twinner.EnvoieParFTP(AListeFic: TStrings): integer;
var
  i: integer;
  sFic: string;
begin
  Result := 0;
  SetProgressFormProgress1('0/'+inttostr(AListeFic.Count), 0);
  SetProgressFormTitreProg2('Connexion FTP');
  IdFTP1.Disconnect;
  IdFTP1.Host     := Dm_twinner.FtpExtraction.Host;
  IdFTP1.Username := Dm_twinner.FtpExtraction.User;
  IdFTP1.Password := Dm_twinner.FtpExtraction.Pass;
  IdFTP1.Port     := Dm_twinner.FtpExtraction.Port;
  IdFTP1.Passive  := true;  // sinon, ça ne marche pas sur les lames
  try
    try
      // connexion
      IdFTP1.Connect;

      // changeDir
      if Dm_twinner.FtpExtraction.RepFtp<>'' then
      begin
        SetProgressFormTitreProg2('Changement répertoire');
        IdFTP1.ChangeDir(Dm_twinner.FtpExtraction.RepFtp);
      end;

      // transfert FTP
      SetProgressFormTitreProg2('Progression');
      for i := 1 to AListeFic.Count do
      begin
        iTailleFicATransferer := 0;
        SetProgressFormProgress1(inttostr(i)+'/'+inttostr(AListeFic.Count), Round((i/AListeFic.Count)*100));
        SetProgressFormProgress2('0%', 0);
        sFic := AListeFic[i-1];
        IdFTP1.Put(sFic, ExtractFileName(sFic));
        DeleteFile(sFic);
        inc(Result);
      end;
    except
      on E: Exception do
      begin
        CloseProgressForm;
        MessageDlg('Impossible de transferer le fichier: "'+ExtractFileName(sFic)+'": '+E.Message,
                            mterror, [mbok],0);
      end;
    end;
  finally
    IdFTP1.Disconnect;
  end;
end;

function TFrm_Twinner.DoEnvoiFTP: integer;
var
  Lst_Fichier: TStringList;
begin
  Result := 0;
  Lst_Fichier := TStringList.Create;
  InitProgressForm('Traitement en cours',
                   'Transfert FTP',
                   'Fichier', '0/0',
                   'Recherche des fichiers à envoyer par FTP', '0%');
  try
    RechFicAEnvoyer(Lst_Fichier);

    if Lst_Fichier.Count>0 then
      Result := EnvoieParFTP(Lst_Fichier);
  finally
    FreeAndNil(Lst_Fichier);
    CloseProgressForm;
  end;
end;

procedure TFrm_Twinner.WmDemarre(var m: TMessage);
var
  bOkQuestion: boolean;
  SearchRec: TSearchRec;
  iFicEnvoye: integer;
begin
  // test s'il y a des fichiers à envoyer par ftp
  bOkQuestion := (FindFirst(ReperExtract+'*.csv', faAnyFile, SearchRec)=0);
  FindClose(SearchRec);
  if not(bOkQuestion) then
    exit;

  if MessageDlg('Des fichiers sont prêt à être envoyer par ftp, voulez-vous le faire maintenant ?',
            mtConfirmation, [mbyes, mbno], 0)<>mryes then
    exit;

  iFicEnvoye := DoEnvoiFTP;
  MessageDlg(inttostr(iFicEnvoye)+' fichier(s) ont été envoyé.', mtInformation, [mbok], 0);

end;

procedure TFrm_Twinner.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Caption := Caption + ' - Version : ' + GetNumVersionSoft;

  Left := Screen.WorkAreaLeft+Round((Screen.WorkAreaWidth-Width)/2);
  Top := Screen.WorkAreaTop+Round((Screen.WorkAreaHeight-Height)/2);

  bActivate := false;

  Dm_GinkoiaStyle := TDm_GinkoiaStyle.Create(Self);
  Dm_Twinner := TDm_Twinner.Create(Self);

  Page_Accueil.ActivePage := AOPageMyTwinner;

  for i := 1 to ComponentCount do
  begin
    if Components[i-1] is TAdvGlowButton then
      Dm_GinkoiaStyle.AppliqueStyleAdvGlowButton(TAdvGlowButton(Components[i-1]));
  end;

end;

procedure TFrm_Twinner.FormActivate(Sender: TObject);
begin
  if bActivate then
    exit;

  bActivate := true;
  Application.ProcessMessages;
  PostMessage(Handle, WM_DEMARRE, 0, 0);
end;

procedure TFrm_Twinner.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  FreeAndNil(Dm_Twinner);
end;

procedure TFrm_Twinner.Ds_DosStateChange(Sender: TObject);
begin
  if ds_dos.state in [dsedit, dsinsert] then
  begin
    dbg_dos.setfocus;
    dbg_mag.enabled := false;
    pan_mag.enabled := false;
    nbt_actd.enabled := false;
    nbt_actM.enabled := false;
    Nbt_DesactM.enabled := false;
  end
  else
  begin
    dbg_mag.enabled := true;
    pan_mag.enabled := true;
    nbt_actd.enabled := true;
    nbt_actM.enabled := true;
    Nbt_DesactM.enabled := true;
  end;
end;

procedure TFrm_Twinner.Nbt_ActdClick(Sender: TObject);
var
  i: integer;
begin
  with Dm_Twinner do
  begin
    //flag sur le bouton pour ne pas mettre a jour la liste des magasin dans refreshMag()
    Nbt_Actd.Tag := 1;
    try

      //Verif si au moins un magasin est actif
      que_mag.first;
      while not que_mag.eof do
      begin
        if que_magmag_actif.asinteger = 1 then break;
        que_mag.next;
      end;

      if que_mag.eof then
      begin
        MessageDlg('Impossible, aucun magasin est actif pour ce dossier.', mterror, [mbok], 0);
        exit;
      end;

      if que_dosDOS_lastversion.asinteger = 0 then
      begin
        if MessageDlg('Confirmez vous l''export du fichier client pour le dossier '+trim(que_dosDOS_NOM.asstring)+' ?',
                      mtConfirmation ,[mbyes, mbno], 0)<>mryes then
          exit;
      end
      else
      begin
        if MessageDlg('Attention l''export a déjà été réalisé.'+#10#13+
                      'Souhaitez vous le regénérer ?', mtWarning, [mbyes, mbno], 0)<>mryes then
          exit;
      end;

      VeuillezPatienter('Génération de l''export ...');
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        if trim(que_dosDos_chemin.asString) <> '' then
        begin

          //OK on peut initialiser
          ginkoia.close;
          ginkoia.databasename := que_dosDOS_CHEMIN.asstring;
          try
            ginkoia.open;
            //export du fichier client
              //insèrer le nom du dossier dans chaque linge exportée
            i := Que_cli.sql.indexof('/*BALISE1*/');
            if i <> 0 then
            begin
              QUE_Cli.sql[i + 1] := '''' + trim(Que_dosDos_nom.asString) + ''' DOSSIER,';
            end;
            i := Que_cli.sql.indexof('/*BALISE2*/');
            if i <> 0 then
            begin
              QUE_Cli.sql[i + 1] := '''' + trim(Que_dosDos_nom.asString) + ''' DOSSIER,';
            end;
            que_cli.open;
            que_cli.FetchAll;
            mdc.LoadFromDataSet(que_cli);
            mdc.DelimiterChar := ';';
            mdc.SaveToTextFile(ReperMyTwinner + trim(que_dosDOS_NOM.asstring) + '.csv');
            mdc.close;
            que_cli.close;

            que_dos.edit;
              //Recherche du général_id
            que_lv.open;
            que_dosDOS_lastversion.asinteger := que_lv.fieldbyname('newkey').asinteger;
            que_dosDOS_DATEACTIV.asdatetime := date;
            que_dosDOS_actif.asinteger := 1;
            que_dos.post;

            que_lv.close;

            //export de la liste des adhérents
            adoRefresh.Connected := false;
            try
              adoRefresh.ConnectionString := Dm_Twinner.ado.ConnectionString;
              adoRefresh.connected :=true;
              Que_ListeAdherents.open;
              mdListeAdherent.LoadFromDataSet(Que_ListeAdherents);
              mdListeAdherent.DelimiterChar := ';';
              mdListeAdherent.SaveToTextFile(ReperMyTwinner + 'ListeAdherents_' + FormatDateTime('YYYYMMDD_HHNN', now) + '.csv');
              mdListeAdherent.close;
            finally
              adoRefresh.connected :=false;
            end;


            FermerPatienter;
            MessageDlg('Le fichier est généré sous ...\EXTRACT\' + trim(que_dosDOS_NOM.asstring) + '.csv',
                       mtInformation, [mbok], 0);

          except on stan: exception do
            begin
              FermerPatienter;
              MessageDlg(Stan.Message, mterror, [mbok], 0);
              ginkoia.close;
            end;
          end;
        end;
      finally
        FermerPatienter;
      end;
    finally
      //réinitialiser le flag du bouton d'export
      Nbt_Actd.Tag := 0;
    end;
  end;  // with
end;

procedure TFrm_Twinner.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Twinner.ChargeDatabase;
var
  s: string;
  i: integer;
begin
  with Dm_Twinner do
  begin
    if ds_dos.dataset.state in [dsedit, dsinsert] then
    begin
      if OD_Bases.execute then
      begin
        S := Uppercase(OD_Bases.FileName);
        if s[1] = '\' then
        begin
                  // Distant
          delete(s, 1, 2);
          if pos('$', s) > 0 then
          begin
            s[pos('$', s)] := ':';
            s[pos('\', s)] := ':';
          end
          else
          begin
            i := pos('\', s);
            insert(':D:', s, i);
          end;
          que_dos.fieldbyname('dos_chemin').asstring := S;
        end
        else
        begin
                  // local
          que_dos.fieldbyname('dos_chemin').asstring := S;
        end;
        //ginkoia.databasename := s;
        try
          ginkoia.close; //lab
          ginkoia.databasename := s;
          ginkoia.open;
        except
          MessageDlg('Chemin de base incorrect !', mterror, [mbok], 0);
        end;
        ginkoia.close;
      end;
    end;
  end;
end;

procedure TFrm_Twinner.DBG_DosDOS_CHEMINEditButtonClick(
  Sender: TObject);
begin
  ChargeDatabase;
  Abort;
end;

procedure TFrm_Twinner.DrawCellCheckBox(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: string;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
var
  DrawRect: TRect;
  wCheck: integer;
  hCheck: integer;
  HandleTheme: HTHEME;
  Taille: TSize;
  StateFrameCtrl: uint;
  StateThemeCtrl: integer;

    procedure DoGradient(bStandardColor: boolean; BRect: TRect);
    var
      ColorHaut: TColor;
      ColorBas : TColor;
    begin
      if bStandardColor then
      begin
        ColorHaut := TdxDBGridHP(Sender).HPAddOn.Advanced.SelectedGradientColor;
        ColorBas  := TdxDBGridHP(Sender).HPAddOn.Advanced.SelectedColor;
      end
      else
      begin
        ColorHaut := Luminosite(AColor, 45);
        ColorBas := AColor;
      end;
      GradientFillCanvas(ACanvas,
                         ColorHaut,
                         ColorBas,
                         BRect,
                         gdVertical);
    end;
begin
  if AColumn is TdxDBGridCheckColumn then
  begin
    if ASelected then
    begin
      if TdxDBGridHP(Sender).HPAddOn.Advanced.SelectedGradientUse then
        GradientFillCanvas(ACanvas,
                         TdxDBGridHP(Sender).HPAddOn.Advanced.SelectedGradientColor,
                         TdxDBGridHP(Sender).HPAddOn.Advanced.SelectedColor,
                         ARect,
                         gdVertical)
      else
      begin
        ACanvas.Brush.Color := TdxDBGridHP(Sender).HPAddOn.Advanced.SelectedColor;
        ACanvas.FillRect(ARect);
      end;
    end
    else
    begin
      ACanvas.Brush.Color := AColor;
      ACanvas.FillRect(ARect);
    end;
    if UseThemes then
    begin
      if (AText=TdxDBGridCheckColumn(AColumn).ValueChecked) then
        StateThemeCtrl := CBS_CHECKEDNORMAL
      else if (AText=TdxDBGridCheckColumn(AColumn).ValueUnchecked) then
        StateThemeCtrl := CBS_UNCHECKEDNORMAL
      else if (AText=TdxDBGridCheckColumn(AColumn).ValueGrayed) and (TdxDBGridCheckColumn(AColumn).AllowGrayed) then
        StateThemeCtrl := CBS_CHECKEDDISABLED
      else // valeur null
      begin
        if TdxDBGridCheckColumn(AColumn).ShowNullFieldStyle=nsUnchecked then
          StateThemeCtrl := CBS_UNCHECKEDNORMAL
        else
          StateThemeCtrl := CBS_CHECKEDDISABLED
      end;
      HandleTheme := OpenThemeData(TdxDBGridHP(Sender).Handle, 'BUTTON');
      if HandleTheme <> 0 then
      begin
        try
          GetThemePartSize(HandleTheme, ACanvas.Handle, BP_CHECKBOX, CBS_CHECKEDNORMAL, nil, TS_DRAW, Taille);
          DrawRect.Top    := ARect.Top+(ARect.Bottom-ARect.Top-Taille.cy) div 2;
          DrawRect.Bottom := DrawRect.Top+Taille.cy;
          DrawRect.Left   := ARect.Left+(ARect.Right-ARect.Left-Taille.cx) Div 2;     //CBS_CHECKEDNORMAL, CBS_UNCHECKEDNORMAL
          DrawRect.Right  := DrawRect.Left+Taille.cx;
          DrawThemeBackground(HandleTheme, ACanvas.Handle, BP_CHECKBOX, StateThemeCtrl, DrawRect, nil);
        finally
          CloseThemeData(HandleTheme);
        end;
      end;
    end
    else
    begin
      if (AText=TdxDBGridCheckColumn(AColumn).ValueChecked) then
        StateFrameCtrl := DFCS_CHECKED
      else if (AText=TdxDBGridCheckColumn(AColumn).ValueUnchecked) then
        StateFrameCtrl := DFCS_BUTTONCHECK
      else if (AText=TdxDBGridCheckColumn(AColumn).ValueGrayed) and (TdxDBGridCheckColumn(AColumn).AllowGrayed) then
        StateFrameCtrl := DFCS_CHECKED or DFCS_INACTIVE
      else // valeur null
      begin
        if TdxDBGridCheckColumn(AColumn).ShowNullFieldStyle=nsUnchecked then
          StateFrameCtrl := DFCS_BUTTONCHECK
        else
          StateFrameCtrl := DFCS_CHECKED or DFCS_INACTIVE;
      end;
      wCheck := GetSystemMetrics(SM_CXMENUCHECK);
      hCheck := GetSystemMetrics(SM_CYMENUCHECK);
      DrawRect.Top    := ARect.Top+(ARect.Bottom-ARect.Top-hCheck) div 2;
      DrawRect.Bottom := DrawRect.Top+hCheck;
      DrawRect.Left   := ARect.Left+(ARect.Right-ARect.Left-wCheck) Div 2;
      DrawRect.Right  := DrawRect.Left+wCheck;
      InflateRect(DrawRect, -1, -1);
      ACanvas.Pen.color := clred;
      DrawFrameControl(ACanvas.Handle, DrawRect, DFC_BUTTON, StateFrameCtrl);
    end;
    ADone := true;
  end;
end;

procedure TFrm_Twinner.DBG_MagCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn; ASelected,
  AFocused, ANewItemRow: Boolean; var AText: string; var AColor: TColor;
  AFont: TFont; var AAlignment: TAlignment; var ADone: Boolean);
begin
  DrawCellCheckBox(Sender, ACanvas, ARect, ANode, AColumn,
        ASelected, AFocused, ANewItemRow, AText, AColor, AFont, AAlignment, ADone);
end;

procedure TFrm_Twinner.Active_DesactiveMagasin(bActive: boolean);
var
  prm_id: integer;
  iActive: integer;
begin
  with Dm_Twinner do
  begin
    if not ginkoia.connected then
    begin
      ginkoia.close;
      ginkoia.databasename := que_dosDOS_CHEMIN.asstring;
      ginkoia.open;
    end;

    if bActive then
      iActive := 1
    else
      iActive := 0;

    if que_mag.eof then
    begin
      MessageDlg('Pas de magasin défini pour ce dossier !', mterror, [mbok], 0);
      exit;
    end;

    if que_mag.state in [dsedit, dsinsert] then
    begin
      que_mag.post;
    end;


      //Activation du magasin en cours

    if (que_magmag_actif.asinteger = 1) and (bActive) then
    begin
      MessageDlg('Ce magasin est déjà activé !', mterror, [mbok], 0);
      exit;
    end;

    if (que_magmag_actif.asinteger = 0) and not(bActive) then
    begin
      MessageDlg('Ce magasin n''est pas activé !', mterror, [mbok], 0);
      exit;
    end;

    que_im.close;
    que_im.parambyname('codeadh').asstring := que_magmag_codeadh.asstring;
    que_im.open;
    if que_im.eof then
    begin
      MessageDlg('Impossible, ce code adhérent n''est plus présent dans la base ginkoia !', mterror, [mbok], 0);
      exit;
    end;

    que_p1.close;
    que_p1.parambyname('magid').asinteger := que_im.fieldbyname('mag_id').asinteger;
    que_p1.open;
    if que_p1.eof then
    begin
      MessageDlg('Anomalie, Enregistrement manquant dans Genparam Mag : ' + que_im.fieldbyname('mag_id').asstring+' !',
                  mterror, [mbok], 0);
      exit;
    end;
    prm_id := que_p1.fieldbyname('prm_id').asinteger;

    tb.active := false;
    tb.StartTransaction;
    que_p2.close;
    que_p2.ParamByName('prm_id').asinteger := prm_id;
    que_p2.ParamByName('prm_integer').asinteger := iActive;
    que_p2.ExecSQL;

    que_p3.close;
    que_p3.ParamByName('prm_id').asinteger := prm_id;
    que_p3.ExecSQL;
    tb.commit;

    que_p2.close;
    que_p3.close;

    que_mag.edit;
    que_magmag_actif.asinteger := iActive;
    que_magmag_dateactiv.asdatetime := now;
    que_mag.post;
  end;
end;

procedure TFrm_Twinner.Nbt_ActMClick(Sender: TObject);
begin
  Active_DesactiveMagasin(True);
end;

procedure TFrm_Twinner.Nbt_ActuExtractClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    Dm_Twinner.Que_DosMag.Close;
    Dm_Twinner.Que_DosMag.Open;
  finally
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Twinner.Nbt_DesactMClick(Sender: TObject);
begin
  Active_DesactiveMagasin(False);
end;

procedure TFrm_Twinner.Nbt_EnvoiClick(Sender: TObject);
begin
  Frm_Date.ShowModal;
  if Frm_Date.bTraitement then
  begin
    try
      if not Dm_Twinner.GINKOIA.Connected then
      begin
        Dm_Twinner.GINKOIA.Close;
        Dm_Twinner.GINKOIA.DatabaseName := Dm_Twinner.que_dosDOS_CHEMIN.asstring;
        Dm_Twinner.GINKOIA.Open;
      end;
      Dm_Twinner.Que_Client.Close;
      Dm_Twinner.Que_Client.ParamByName('DateDebut').AsDate := Frm_Date.dDateDebut;
      Dm_Twinner.Que_Client.Open;
      Dm_Twinner.Que_Client.First;
      while not Dm_Twinner.Que_Client.Eof do
      begin
        ExecuteFidNatTwinAjoutModifClient(Dm_Twinner.Que_Client.FieldByName('Client_Id').AsInteger,'',false);
        Dm_Twinner.Que_Client.Next;
      end;
    finally
      Dm_Twinner.Que_Client.Close;
      MessageDlg('Traitement terminé.',mtInformation,[mbok],0);
    end;
  end
  else
  begin
    MessageDlg('Traitement annulé.',mtInformation,[mbok],0);
  end;
end;

procedure TFrm_Twinner.Nbt_InsertAfterAction(Sender: TObject;
  var Error: Boolean);
begin
  ChargeDatabase;
end;

procedure TFrm_Twinner.Nbt_ParametrageClick(Sender: TObject);
begin
  if IniCfg.ShowCfgInterface = mrOk then
  begin
    Dm_Twinner.Init;
  end;
end;

procedure TFrm_Twinner.Ds_MagDataChange(Sender: TObject; Field: TField);
begin
  if ds_mag.state in [dsedit, dsinsert] then
  begin
    DBG_Mag.SetFocus;
    dbg_dos.enabled := false;
    pan_dos.enabled := false;
    nbt_actd.visible := false;
    nbt_actM.visible := false;
    Nbt_DesactM.visible := false;
    DBG_MagMAG_IDFID.readonly := true;
  end
  else
  begin
    dbg_dos.enabled := true;
    pan_dos.enabled := true;
    nbt_actd.visible := true;
    nbt_actM.visible := true;
    Nbt_DesactM.visible := true;
  end;
end;

procedure TFrm_Twinner.DBG_DosMagCustomDrawCell(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
  var AText: string; var AColor: TColor; AFont: TFont;
  var AAlignment: TAlignment; var ADone: Boolean);
var
  sCodeAd: string;
begin
  if (DBG_DosMag.GetValueByFieldName(Anode, 'CanSelect') =0) then
    AFont.Color := clGray;

  if AColumn=DBG_DosMagOkSelect then
  begin
    sCodeAd := DBG_DosMag.GetValueByFieldName(Anode, 'sCodeSur6');
    if (sCodeAd<>'') and (Dm_Twinner.ListeSelExtract.IndexOf(sCodeAd)>=0) then
      AText := '1'
    else
      AText := '0';
  end;
  DrawCellCheckBox(Sender, ACanvas, ARect, ANode, AColumn,
        ASelected, AFocused, ANewItemRow, AText, AColor, AFont, AAlignment, ADone);
end;

procedure TFrm_Twinner.DBG_DosMagDblClick(Sender: TObject);
var
  sCodeAd: string;
  LRet: integer;
begin
  with Dm_Twinner do
  begin
    if not(Que_DosMag.Active) or (Que_DosMag.RecordCount=0) then
      exit;

    if Que_DosMag.fieldbyname('CanSelect').AsInteger<>1 then
    begin
      MessageDlg('Impossible de sélectionner un magasin sans code adhérent !',mterror,[mbok],0);
      exit;
    end;

    sCodeAd := Trim(Que_DosMag.FieldByName('sCodeSur6').AsString);
    Lret := ListeSelExtract.IndexOf(sCodeAd);
    if lret<0 then
      ListeSelExtract.Add(sCodeAd)  // sélectionne
    else
      ListeSelExtract.Delete(lret);  // déselectionne

    Dbg_DosMag.Refresh;
  end;
end;

procedure TFrm_Twinner.FormShow(Sender: TObject);
begin
  //réactiver le after scroll du tableau des dossiers
  Dm_Twinner.flagScroll := true;
  //Se placer sur le prochain élément
  dbg_dos.GotoNext(true);
  //Se placer sur le premier élément du tableau
  dbg_dos.GotoFirst;
end;

procedure TFrm_Twinner.IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  iPourcen: integer;
begin
  if iTailleFicATransferer>0 then
  begin
    iPourcen := Round((AWorkCount/iTailleFicATransferer)*100);
    SetProgressFormProgress2(inttostr(iPourcen)+'%', iPourcen);
  end;
end;

procedure TFrm_Twinner.IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  iTailleFicATransferer := AWorkCountMax;
  SetProgressFormProgress2('0%', 0);
end;

procedure TFrm_Twinner.IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  SetProgressFormProgress2('100%', 100);
end;

procedure TFrm_Twinner.Nbt_RefreshMagsClick(Sender: TObject);
begin
  VeuillezPatienter('Actualisation des magasins ...');
  try
    refreshMag;
  finally
    FermerPatienter;
  end;
end;

procedure TFrm_Twinner.Nbt_SelAutoClick(Sender: TObject);
var
  bmBook        : TBookMark;
  sFicImportSel : string;
  LstTmp        : TStringList;
  sCode         : string;
  i             : integer;
  NoErr         : integer;
  sErr          : string;
  bOk           : boolean;
begin
  if Dm_Twinner.ListeSelExtract.Count>0 then
  begin
    if MessageDlg('Toute votre sélection va être annulée.'+#13#10#13#10+
                  'Continuez ?', mtConfirmation, [mbyes, mbno], 0, mbno)<>mryes then
      exit;
  end;

  // coix du fichier csv
  sFicImportSel := '';
  if OD_SelAuto.Execute then
    sFicImportSel := OD_SelAuto.FileName;
  if sFicImportSel='' then
    exit;

  with Dm_Twinner do
  begin
    VeuillezPatienter('Sélection automatique...');
    MemD_ErrSelAuto.Close;
    MemD_ErrSelAuto.Open;
    bmBook := Que_DosMag.GetBookmark;
    Que_DosMag.DisableControls;
    LstTmp := TStringList.Create;
    try
      // chargement du fichier csv
      LstTmp.LoadFromFile(sFicImportSel);

      // test des codes adhérent
      NoErr := 0;
      for i := 1 to LstTmp.Count do
      begin
        sErr := '';
        sCode := LstTmp[i-1];
        if (Length(sCode)>16) or (Pos(';', sCode)>0) or (Pos('"', sCode)>0) then
          sErr := 'Code invalide';
        if (sErr='') then
        begin
          while Length(sCode)<6 do
            sCode := '0'+sCode;

          // recherche sur sCodeSur6 car locate ne marche pas sur un champ calculé
          bOk := false;
          Que_DosMag.First;
          while not(bOk) and not(Que_DosMag.Eof) do
          begin
            if Que_DosMag.FieldByName('sCodeSur6').AsString=sCode then
              bOk := true;
            Que_DosMag.Next;
          end;
          if not(bOk) then
            sErr := 'Magasin non trouvé pour ce code';
        end;
        if sErr<>'' then  // erreur
        begin
          Inc(NoErr);
          MemD_ErrSelAuto.Append;
          MemD_ErrSelAuto.FieldByName('No').AsInteger := NoErr;
          MemD_ErrSelAuto.FieldByName('CodeAd').AsString := sCode;
          MemD_ErrSelAuto.FieldByName('InfoErr').AsString := sErr;
          MemD_ErrSelAuto.Post;
        end;
      end;

      // tout est ok, on sélectionne
      if MemD_ErrSelAuto.RecordCount=0 then
      begin
        ListeSelExtract.Clear;
        for i := 1 to LstTmp.Count do
        begin
          sCode := Trim(LstTmp[i-1]);
          while Length(sCode)<6 do
            sCode := '0'+sCode;
          if ListeSelExtract.IndexOf(Trim(sCode))<0 then
            ListeSelExtract.Add(Trim(sCode));
        end;
        DBG_DosMag.Refresh;
      end;

    finally
      Que_DosMag.GotoBookmark(bmBook);
      Que_DosMag.FreeBookmark(bmBook);
      Que_DosMag.EnableControls;
      FreeAndNil(LstTmp);
      FermerPatienter;
    end;

    // affichage des erreurs
    if MemD_ErrSelAuto.RecordCount>0 then
    begin
      MemD_ErrSelAuto.First;
      Frm_AfficheErreurSelAuto := TFrm_AfficheErreurSelAuto.Create(Self);
      try
        Frm_AfficheErreurSelAuto.ShowModal;
        Application.ProcessMessages;
      finally
        FreeAndNil(Frm_AfficheErreurSelAuto);
        MemD_ErrSelAuto.Close;
      end;
    end;

  end;
end;

procedure TFrm_Twinner.Nbt_TraiteExtractClick(Sender: TObject);
var
  bOkEnvoieFTP: boolean;
  SearchRec: TSearchRec;
  bmBook: TBookMark;
  i, j: integer;
  iPosiRecord: integer;
  iPourcen: integer;
  sDossier: string;
  sCode: string;
  sDataBase: string;
  sLigne: string;
  sTmp: string;
  Lst_Extract: TStringList;
  Lst_ProcExtract: TStringList;
  Que_Tmp: TIBQuery;
  iCnt: integer;
  iFicGenere: integer;
  iFicEnvoyé: integer;
  bOkFind: boolean;
begin
  if not(FileExists(ReperBase+ProcExtractFileName)) then
  begin
    MessageDlg('Fichier contenant la procedure d''extraction ("'+ProcExtractFileName+
               '") non trouvé !', mterror,[mbok],0);
    exit;
  end;
  if Dm_Twinner.NomProcStockExtract='' then
  begin
    MessageDlg('Nom de la procédure stockée non renseignée dans l''ini: [Extraction]...ProcStockee=...',
                mterror,[mbok],0);
    exit;
  end;

  iFicGenere := 0;
  iFicEnvoyé := 0;

  Lst_ProcExtract := TStringList.Create;
  try
    // load de la procedure stockée
    Lst_ProcExtract.LoadFromFile(ReperBase+ProcExtractFileName);

    // extraction des données
    with Dm_Twinner do
    begin
      if (ListeSelExtract.Count>0) and (Que_DosMag.RecordCount>0) then
      begin
        try
          Lst_Extract := TStringList.Create;
          Que_Tmp := TIBQuery.Create(Self);
          bmBook := Que_DosMag.GetBookmark;
          Que_DosMag.DisableControls;
          InitProgressForm('Traitement en cours',
                           'Contrôle des données',
                           'Sélection', '0/'+inttostr(ListeSelExtract.Count),
                           'Progression', '0%');
          try
            // contrôle si des dossiers différents ont le même code adhérent
            for i := 1 to ListeSelExtract.Count do
            begin
              SetProgressFormProgress1(inttostr(i)+'/'+inttostr(ListeSelExtract.Count),
                                       Round((i/ListeSelExtract.Count)*100));
              iPosiRecord := 0;
              iPourcen := Round((iPosiRecord/Que_DosMag.RecordCount)*100);
              SetProgressFormProgress2(inttostr(iPourcen)+'%', iPourcen);
              sCode := ListeSelExtract[i-1];
              while Length(sCode)<6 do
                sCode := '0'+sCode;
              sdossier := '';
              Que_DosMag.First;
              while not(Que_DosMag.Eof) do
              begin
                inc(iPosiRecord);
                iPourcen := Round((iPosiRecord/Que_DosMag.RecordCount)*100);
                SetProgressFormProgress2(inttostr(iPourcen)+'%', iPourcen);
                if sCode = Trim(Que_DosMag.FieldByName('sCodeSur6').AsString) then
                begin
                  if sDossier='' then
                    sDossier := Trim(Que_DosMag.FieldByName('dos_nom').AsString)
                  else
                  begin
                    if sDossier<>Trim(Que_DosMag.FieldByName('dos_nom').AsString) then
                      Raise Exception.Create('Le code '+sCode+' est présent dans plusieurs dossiers différents !');
                  end;
                end;
                Que_DosMag.Next;
              end;
            end;

            //extraction
            SetProgressFormInfo2('Extraction des données');
            SetProgressFormTitreProg1('Sélection');
            SetProgressFormTitreProg2('Extraction');
            SetProgressFormProgress1('0/'+inttostr(ListeSelExtract.Count), 0);
            SetProgressFormProgress2('0%', 0);

            for i := 1 to ListeSelExtract.Count do
            begin
              // effacement du fichier de sortie
              Lst_Extract.Clear;
              sCode := ListeSelExtract[i-1];
              while Length(sCode)<6 do
                sCode := '0'+sCode;

              // recherche en parcourant car le locate ne marche pas sur les champs calculés
              bOkFind := false;
              Que_DosMag.First;
              while not(bOkFind) and not(Que_DosMag.Eof) do
              begin
                if Que_DosMag.FieldByName('sCodeSur6').AsString=sCode then
                  bOkfind := true;
                if not(bOkFind) then
                  Que_DosMag.Next;
              end;

              //
              if bOkFind then
              begin
                sDossier := Trim(Que_DosMag.FieldByName('dos_nom').AsString);
                sDataBase := Trim(Que_DosMag.FieldByName('dos_chemin').AsString);
                SetProgressFormTitreProg1('Dossier: '+sDossier);
                SetProgressFormProgress1(inttostr(i)+'/'+inttostr(ListeSelExtract.Count),
                                         Round((i/ListeSelExtract.Count)*100));
                SetProgressFormProgress2('0%', 0);

                SetProgressFormTitreProg2('Ouverture de la base de données');
                Que_Tmp.Close;
                // connexion à la base de donnée
                Ginkoia.Close;
                Ginkoia.DatabaseName := sDataBase;
                Ginkoia.Open;

                Que_Tmp.Database := Ginkoia;

                // drop de la procedure stockée
                SetProgressFormTitreProg2('Suppression procédure d''extraction');
                with Que_Tmp do
                begin
                  SQL.Clear;
                  SQL.Add('drop procedure '+NomProcStockExtract);
                  try
                    ExecSQL;
                  except  // pas d'arrêt pour le drop
                  end;
                end;

                SetProgressFormTitreProg2('Création procédure d''extraction');
                // création de la proc stockée;
                with Que_Tmp do
                begin
                  ParamCheck := false;
                  SQL.Clear;
                  SQL.AddStrings(Lst_ProcExtract);
                  ExecSQL;
                  ParamCheck := true;
                end;

                SetProgressFormTitreProg2('Autorisation procédure d''extraction');
                // droit de la proc stockée;
                with Que_Tmp do
                begin
                  SQL.Clear;
                  SQL.Add('GRANT EXECUTE ON PROCEDURE '+NomProcStockExtract+' TO GINKOIA');
                  ExecSQL;
                end;

                // compte le nbre d'enregistrement à peu près
                SetProgressFormTitreProg2('Initialisation extraction');
                with Que_Tmp do
                begin
                  SQL.Clear;
                  SQL.Add('select count(*) as Nbre from CLTCLIENT'+
                          ' join k on (k_id=clt_id and k_enabled=1)'+
                          ' where clt_archive=0');
                //  SQL.Add('select count(*) as Nbre from '+NomProcStockExtract+' (:CODEADHE)');
                  Open;
                  iCnt := fieldbyname('Nbre').AsInteger;
                  Close;
                end;

                // extraction
                SetProgressFormTitreProg2('Extraction');
                with Que_Tmp do
                begin
                  iPosiRecord := 0;
                  SQL.Clear;
                  SQL.Add('select * from '+NomProcStockExtract+' (:CODEADHE)');
                  ParamByName('CODEADHE').AsString := Que_DosMag.FieldByName('mag_codeadh').AsString;
                  Open;
                  // liste des champs
                  sLigne := '';
                  for j := 1 to FieldCount do
                  begin
                    sTmp := Fields[j-1].FieldName;
                    if sLigne<>'' then
                      sLigne := sLigne+';';
                    sLigne := sLigne+sTmp;
                  end;
                  Lst_Extract.Add(sLigne);
                  // chaque ligne
                  First;
                  while not(Eof) do
                  begin
                    inc(iPosiRecord);
                    iPourcen := Round((iPosiRecord/iCnt)*100);
                    SetProgressFormProgress2(inttostr(iPourcen)+'%', iPourcen);
                    sLigne := '';
                    for j := 1 to FieldCount do
                    begin
                      case Fields[j-1].DataType of
                        ftFloat:
                        begin
                          sTmp := FormatFloat('0.00', Fields[j-1].AsFloat);
                          if Pos(',', sTmp)>0 then
                            sTmp[Pos(',', sTmp)] := '.';
                        end;
                        ftDate, ftDateTime:
                        begin
                          if Fields[j-1].IsNull then
                            sTmp := ''
                          else
                            sTmp := FormatDateTime('dd/mm/yyyy', Fields[j-1].AsDateTime);
                        end;
                      else      // ftstring, ftinteger
                        sTmp := Fields[j-1].AsString;
                      end;
                      sTmp := StringReplace(sTmp, ';', ' ', [rfReplaceAll]);
                      if sLigne<>'' then
                        sLigne := sLigne+';';
                      sLigne := sLigne+sTmp;
                    end;
                    Lst_Extract.Add(sLigne);
                    Next;
                  end;
                  Close;
                end;
                // sauvegarde du fichier généré
                Lst_Extract.SaveToFile(ReperExtract+sCode+'_'+FormatDateTime('yyyymmdd', Date)+'.csv');
                inc(iFicGenere);

                // drop de la procedure stockée
                SetProgressFormTitreProg2('Suppression procédure d''extraction');
                with Que_Tmp do
                begin
                  SQL.Clear;
                  SQL.Add('drop procedure '+NomProcStockExtract);
                  try
                    ExecSQL;
                  except  // pas d'arrêt pour le drop
                  end;
                end;

              end;
            end;



          finally
            Que_Tmp.Close;
            FreeAndNil(Que_Tmp);
            Ginkoia.Close;
            FreeAndNil(Lst_Extract);
            Que_DosMag.GotoBookmark(bmBook);
            Que_DosMag.FreeBookmark(bmBook);
            Que_DosMag.EnableControls;
            CloseProgressForm;
          end;
        except
          on E: Exception do
          begin
            MessageDlg(E.Message, mterror, [mbok], 0);
            exit;
          end;
        end;
      end;
    end;
  finally
    freeAndNil(Lst_ProcExtract);
  end;

  // envoie Ftp
  bOkEnvoieFTP := (FindFirst(ReperExtract+'*.csv', faAnyFile, SearchRec)=0);
  FindClose(SearchRec);
  if (bOkEnvoieFTP) then
    iFicEnvoyé := DoEnvoiFTP;

  MessageDlg(' - '+inttostr(iFicGenere)+' fichier(s) ont été généré.'+#13#10+
             ' - '+inttostr(iFicEnvoyé)+' fichier(s) ont été envoyé.'
             , mtInformation, [mbok], 0);

end;

procedure TFrm_Twinner.Page_AccueilChanging(Sender: TObject; FromPage,
  ToPage: Integer; var AllowChange: Boolean);
begin
  AllowChange := not(ds_dos.state in [dsedit, dsinsert]) and not(ds_mag.state in [dsedit, dsinsert])
end;

procedure TFrm_Twinner.RechFicAEnvoyer(AListeFic: TStrings);
var
  i: integer;
  iResu: integer;   // variable de retour de FindFirst ou FindNext
  SearchRec: TSearchRec;
  sFichier: string;
begin
  AListeFic.Clear;
  if not(DirectoryExists(ReperExtract)) then
    exit;

  iResu := FindFirst(ReperExtract+'*.csv', faAnyFile, SearchRec);
  while (iresu=0) do
  begin
    sFichier := ExtractFileName(SearchRec.Name);
    if (sFichier<>'.') and (sFichier<>'..') and ((SearchRec.Attr and faDirectory)<>faDirectory) then
      AListeFic.Add(ReperExtract+sFichier);
    iresu := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

procedure TFrm_Twinner.refreshMag;
begin
  with Dm_Twinner do
  begin
   //raffraichir la liste des magasins
   // si on n'est pas en export csv des clients
    if (Nbt_Actd.Tag = 0) then
    begin
   //si un dossier est sélectionné et que le requete dossier n'est pas en cours de modification
      if (Que_DosDos_ID.asInteger <> 0) and (Que_Dos.state in [dsBrowse]) then
      begin
      //si on a un chemin vers une base renseigné
        if (trim(que_dosDos_chemin.asString) <> '') then
        begin
          try
          //récupèrer et recopier les infos des magasins
            ginkoia.close;
            ginkoia.databasename := que_dosDOS_CHEMIN.asstring;
            ginkoia.open;
            Que_InitMags.close;
            Que_InitMags.open;
            Que_InitMags.FetchAll;
            Que_InitMags.first;
            que_mag.DisableControls;
            que_mag.close;
            que_mag.sql[que_mag.tag] := '';
            que_mag.parameters[0].value := que_dosDOS_ID.asinteger;
            que_mag.open;
            que_mag.enableControls;
            if Que_InitMags.recordCount <> 0 then
            begin
              while not Que_InitMags.EOF do
              begin
              //Si la liste des magsins ne contient pas ce magasin -> création
              //(le mag_nom a été renseigné au début avec le mag_enseigne)
                if (que_mag.recordcount = 0) or not (Que_mag.Locate('MAG_NOM', Que_InitMagsMag_ENSEIGNE.asstring, []) or Que_mag.Locate('MAG_NOM', Que_InitMagsMag_NOM.asstring, [])) then
                begin
                  que_mag.insert;
                end
                else //Sinon mise à jour
                begin
                  que_mag.edit;
                end;
                que_magmag_dosid.asinteger := que_dosDOS_ID.asinteger;
                que_magmag_nom.asstring := Que_InitMagsMag_Nom.asString;
                que_magmag_enseigne.asstring := Que_InitMagsMag_enseigne.asstring;
                que_magmag_ville.asstring := Que_InitMagsVIL_Nom.asString;
              //que_magmag_idfid.asinteger := 0;
                que_magmag_codeadh.asstring := Que_InitMagsMag_CodeAdh.asstring;
                que_magmag_magid.asinteger := Que_InitMagsMag_id.asinteger;
                que_mag.post;
                Que_InitMags.next;
              end;
            end;
          except on stan: Exception do
            begin
              MessageDlg(Stan.Message, mterror, [mbok], 0);
            end
          end;
        end;
  //    else //si pas de chemin vers une base renseigné
  //    begin
  //      MessageDlg('Veuillez indiquer le chemin  vers la base, mterror, [mbok], 0);
  //    end
      end
      else
      begin
        MessageDlg('Veuillez sélectionner un dossier', mterror, [mbok], 0);
      end;
    end;
  end;
end;

end.


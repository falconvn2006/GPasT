unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, ExtCtrls, RzPanel, dxGrClEx, dxDBTLCl, dxGrClms,
  dxTL, dxDBCtrl, dxDBGrid, dxCntner, dxDBGridHP, LMDBaseControl,
  LMDBaseGraphicControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, Boxes, PanBtnDbgHP, RzPanelRv, AdvGlowButton, GinkoiaStyle_dm, Main_dm,
  ComCtrls, vgPageControlRv, db, ADODB, uHeaderCsv, StdCtrls, IniCfg_frm,
  DBClient, OC_Frm, OCMag_Frm, OCMAGUpdate_frm, OCExport_Frm, OCImport_Frm,MidasLib;

type
  TFrm_Main = class(TAlgolDialogForm)
    Pan_Bottom: TRzPanel;
    Pan_Mag: TPanelDbg;
    AdvGlowButton8: TAdvGlowButton;
    Nbt_ins: TAdvGlowButton;
    Nbt_modif: TAdvGlowButton;
    Pan_Sep: TRzPanel;
    Pan_Edition: TRzPanel;
    Nbt_Histo: TAdvGlowButton;
    Pgc_Fond: TvgPageControlRv;
    Tab_Magasin: TTabSheet;
    Tab_Rapport: TTabSheet;
    DBG_Magasin_sp2000: TdxDBGridHP;
    DBG_Magasin_sp2000mag_id: TdxDBGridMaskColumn;
    DBG_Magasin_sp2000mag_code: TdxDBGridMaskColumn;
    DBG_Magasin_sp2000mag_nom: TdxDBGridMaskColumn;
    DBG_Magasin_sp2000mag_ville: TdxDBGridMaskColumn;
    DBG_Magasin_sp2000mag_dateactivation: TdxDBGridButtonColumn;
    DBG_Magasin_sp2000mag_cheminbase: TdxDBGridExtLookupColumn;
    DBG_Magasin_sp2000dos_nom: TdxDBGridMaskColumn;
    DBG_Magasin_sp2000mag_database: TdxDBGridCheckColumn;
    DBG_Magasin_sp2000mag_dtbdateactivation: TdxDBGridDateColumn;
    DBG_Rapport_sp2000: TdxDBGridHP;
    Nbt_Export: TAdvGlowButton;
    Lab_url: TLabel;
    DBG_Rapport_sp2000mag_id: TdxDBGridMaskColumn;
    DBG_Rapport_sp2000dos_nom: TdxDBGridMaskColumn;
    DBG_Rapport_sp2000mag_nom: TdxDBGridMaskColumn;
    DBG_Rapport_sp2000mag_code: TdxDBGridMaskColumn;
    DBG_Rapport_sp2000mag_ville: TdxDBGridMaskColumn;
    DBG_Rapport_sp2000mag_database: TdxDBGridCheckColumn;
    DBG_Rapport_sp2000DernierTicket: TdxDBGridDateColumn;
    DBG_Rapport_sp2000DernierResultatStr: TdxDBGridColumn;
    DBG_Rapport_sp2000DernierResultat: TdxDBGridMaskColumn;
    DBG_Rapport_sp2000DerniereSynchroOk: TdxDBGridDateColumn;
    DBG_Rapport_sp2000mag_dtbdateactivation: TdxDBGridDateColumn;
    DBG_Rapport_sp2000DateInit: TdxDBGridDateColumn;
    nbt_parametre: TAdvGlowButton;
    Tab_OCCentrale: TTabSheet;
    DBG_LstOC: TdxDBGridHP;
    DBG_ListOCMag: TdxDBGridHP;
    Pan_ListOCMAG: TRzPanel;
    pdbg_OcMag: TPanelDbg;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    nbt_OCMACAdd: TAdvGlowButton;
    nbt_OCMAGUpdate: TAdvGlowButton;
    Pan_LstOC: TRzPanel;
    RzPanel4: TRzPanel;
    RzPanel5: TRzPanel;
    nbt_OCDelete: TAdvGlowButton;
    nbt_OCUpdate: TAdvGlowButton;
    nbt_OCInsert: TAdvGlowButton;
    nbt_OCMAGDelete: TAdvGlowButton;
    Nbt_Import: TAdvGlowButton;
    DBG_LstOCOSO_NOM: TdxDBGridMaskColumn;
    Tab_RapportOC: TTabSheet;
    Ds_rapportOC: TDataSource;
    DBG_RapportOCOSH_ACTIF: TdxDBGridCheckColumn;
    DBG_RapportOCOSH_DEBUT: TdxDBGridDateColumn;
    DBG_RapportOCOSH_FIN: TdxDBGridDateColumn;
    DBG_RapportOCOSH_DATE: TdxDBGridDateColumn;
    DBG_RapportOCMAG_CODE: TdxDBGridMaskColumn;
    DBG_RapportOCMAG_NOM: TdxDBGridMaskColumn;
    DBG_RapportOCMAG_VILLE: TdxDBGridMaskColumn;
    DBG_RapportOCOSO_NOM: TdxDBGridMaskColumn;
    DBG_RapportOCOSO_SUPP: TdxDBGridCheckColumn;
    DBG_ListOCMagOSM_MAGCODE: TdxDBGridMaskColumn;
    DBG_ListOCMagOSM_DEBUT: TdxDBGridDateColumn;
    DBG_ListOCMagOSM_FIN: TdxDBGridDateColumn;
    DBG_ListOCMagMAG_NOM: TdxDBGridMaskColumn;
    DBG_ListOCMagMAG_VILLE: TdxDBGridMaskColumn;
    DBG_ListOCMagDOS_NOM: TdxDBGridMaskColumn;
    DBG_ListOCMagOSM_ID: TdxDBGridMaskColumn;
    DBG_Rapport_sp2000mag_cheminbase: TdxDBGridMaskColumn;
    DBG_RapportOC: TdxDBGridHP;
    procedure Nbt_modifClick(Sender: TObject);
    procedure Nbt_insClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure AdvGlowButton8Click(Sender: TObject);
    procedure DBG_Magasin_sp2000DblClick(Sender: TObject);
    procedure Nbt_HistoClick(Sender: TObject);
    procedure Tab_MagasinShow(Sender: TObject);
    procedure Tab_RapportShow(Sender: TObject);
    procedure Pgc_FondChange(Sender: TObject);
    procedure Nbt_ExportClick(Sender: TObject);
    procedure AlgolDialogFormShow(Sender: TObject);
    procedure nbt_parametreClick(Sender: TObject);
    //procedure Tab_OCCentraleShow(Sender: TObject);
    procedure nbt_OCInsertClick(Sender: TObject);
    procedure nbt_OCUpdateClick(Sender: TObject);
    procedure nbt_OCDeleteClick(Sender: TObject);
    procedure nbt_OCMACAddClick(Sender: TObject);
    procedure nbt_OCMAGUpdateClick(Sender: TObject);
    procedure nbt_OCMAGDeleteClick(Sender: TObject);
    //procedure Tab_RapportOCShow(Sender: TObject);
    procedure Nbt_ImportClick(Sender: TObject);
  private
    procedure UpdateQuery(Query : TADOQuery);
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

uses InsMag_Frm, Histo_Frm, Start_Frm;

procedure TFrm_Main.nbt_parametreClick(Sender: TObject);
begin
  IniCfg.AdoConnection := Dm_Main.ado;
  if IniCfg.ShowCfgInterface = mrOk then
  begin
    // connexion à la base de données
    Dm_Main.DatabaseConnection;
  end;
end;


procedure TFrm_Main.nbt_OCMACAddClick(Sender: TObject);
begin
  With Tfrm_OCMag.Create(Self) do
  Try
    IdOffre := Dm_Main.QListOC.FieldByName('OSO_ID').AsInteger;
    if ShowModal = mrOk then
    begin
      DM_main.QListOcMag.Close;
      DM_main.QListOcMag.Open;
    end;
  finally
    Release;
  end;
end;

procedure TFrm_Main.nbt_OCMAGDeleteClick(Sender: TObject);
var
  iCount, i, OSM_ID : Integer;
begin
  iCount := DBG_ListOCMag.SelectedCount;

  if MessageDlg(Format('Etes vous sûr de vouloir supprimer le(s) %d magasin(s) ?',[iCount]),mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
    Dm_Main.ado.BeginTrans;
    for i := iCount -1 downto 0 do
    begin
      OSM_ID := DBG_ListOCMag.GetValueByFieldName(DBG_ListOCMag.SelectedNodes[i],'OSM_ID');
      With Dm_Main.QTemp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM [DATABASE].DBO.OCSP2KMAG Where OSM_ID = :POSMID');
        ParamCheck := True;
        Parameters.ParamByName('POSMID').Value := OSM_ID;
        ExecSQL;
      end;
    end;

    Dm_Main.ado.CommitTrans;
    DM_main.QListOcMag.Close;
    DM_main.QListOcMag.Open;
  end;
end;

procedure TFrm_Main.nbt_OCMAGUpdateClick(Sender: TObject);
var
  i : integer;
  OSM_ID : integer;
begin
  With Tfrm_OCMAGUpdate.Create(self) do
  try
    if ShowModal = mrOk then
    begin
      for i := 0 to  DBG_ListOCMag.SelectedCount -1 do
      begin
        OSM_ID := DBG_ListOCMag.GetValueByFieldName(DBG_ListOCMag.SelectedNodes[i],'OSM_ID');

        Dm_Main.ado.BeginTrans;
        With Dm_Main.QTemp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE [DATABASE].DBO.OCSP2KMAG SET');
          SQL.Add('  OSM_DEBUT = :PDEBUT,');
          SQL.Add('  OSM_FIN = :PFIN,');
          SQL.Add('  OSM_CREER = :PCREER');
          SQL.Add('WHERE OSM_ID = :POSMID');
          ParamCheck := True;
          Parameters.ParamByName('PDEBUT').Value := DateDebut;
          Parameters.ParamByName('PFIN').Value := DateFin;
          Parameters.ParamByName('PCREER').Value := Now;
          Parameters.ParamByName('POSMID').Value := OSM_ID;
          ExecSQL;
        end;
        Dm_Main.ado.CommitTrans;
        DM_main.QListOcMag.Close;
        DM_main.QListOcMag.Open;

      end;
    end;
  finally
    Release;
  end;
end;

procedure TFrm_Main.AdvGlowButton8Click(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Main.AlgolDialogFormCreate(Sender: TObject);
begin
  Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);

  Tab_Magasin.TabVisible := True;
  Tab_Rapport.TabVisible := True;
  Tab_OCCentrale.TabVisible := False;
  Tab_RapportOC.TabVisible := False;
  Pgc_Fond.ActivePage := Tab_Magasin;
  nbt_parametre.Visible := True;
end;

procedure TFrm_Main.AlgolDialogFormShow(Sender: TObject);
begin
  Frm_Start.Close;
  Lab_url.Caption := 'Connecté à la base : ' + Dm_Main.sSource;
end;

procedure TFrm_Main.DBG_Magasin_sp2000DblClick(Sender: TObject);
Var
  iMagId : Integer;
begin
  iMagId := Dm_Main.Ds_mag.DataSet.FieldByName('mag_id').asInteger;
  ExecuteInsMag(iMagId);
  // Refresh des données
  UpdateQuery(Dm_Main.Qmag);
end;

procedure TFrm_Main.Nbt_ExportClick(Sender: TObject);
var
  Header : TExportHeaderOL;
  sFileName : string;
  i : integer;
  bm : TBookmark;
begin

//JB if Pgc_Fond.ActivePage = Tab_Magasin then
  if (Pgc_Fond.ActivePage = Tab_Magasin) or (Pgc_Fond.ActivePage = Tab_Rapport)then
//
  begin

    sFileName := ExtractFilePath(Application.ExeName);

    Header := TExportHeaderOL.Create;
    try
      try
        Header.bWriteHeader := True;
        Header.Separator := ';';
        Header.bAlign := False;

        if Pgc_Fond.ActivePage = Tab_Magasin then
        begin
          sFileName := sFileName + 'Export_Magasin_' + FormatDateTime('YYYYMMDD_hhmmss',Now) + '.csv';
          for i := 0 to (DBG_Magasin_sp2000.ColumnCount - 1) do
          begin
            if DBG_Magasin_sp2000.HPAddOn.Columns.CmzHidden.IndexOf(DBG_Magasin_sp2000.Columns[i].FieldName) = -1 then
              if DBG_Magasin_sp2000.Columns[i].Visible then
                case DBG_Magasin_sp2000.Columns[i].Field.DataType of
                  ftDate, ftDateTime :
                  begin
                    Header.Add(DBG_Magasin_sp2000.Columns[i].FieldName,0,alLeft,fmDate,'DD/MM/YYYY','.',DBG_Magasin_sp2000.Columns[i].Caption);
                  end;
                  ftInteger :
                  begin
                    Header.Add(DBG_Magasin_sp2000.Columns[i].FieldName,6,alLeft,fmInteger,'','.',DBG_Magasin_sp2000.Columns[i].Caption);
                  end;
                  else
                    Header.Add(DBG_Magasin_sp2000.Columns[i].FieldName,DBG_Magasin_sp2000.Columns[i].Field.Size,alLeft,fmNone,'','.',DBG_Magasin_sp2000.Columns[i].Caption);
                end;  //case
          end;  //for
          try
            screen.cursor := CrHourGlass;
            Dm_Main.Ds_mag.DataSet.DisableControls;
            try
              bm := Dm_Main.Ds_mag.DataSet.GetBookMark;

              if Header.ConvertToCsv(DBG_Magasin_sp2000,sFileName)=1 then
                ShowMessage('Création du fichier réussit : ' + sFileName)
              else if Header.ConvertToCsv(DBG_Magasin_sp2000,sFileName)=0 then
                ShowMessage('Aucune données à exporter dans le fichier : ' + sFileName)
              else
                ShowMessage('Echec de création du fichier : ' + sFileName);

              Dm_Main.Ds_mag.DataSet.GotoBookmark(bm);
              Dm_Main.Ds_mag.DataSet.FreeBookmark(bm);
              bm := nil;
            except
              Dm_Main.Ds_mag.DataSet.EnableControls;
              bm:= nil;
              exit;
            end;  //try ... except
          finally
            Dm_Main.Ds_mag.DataSet.EnableControls;
            screen.cursor := CrDefault;
          end;  //try ... finally
        end
        else if Pgc_Fond.ActivePage = Tab_Rapport then
        begin
          sFileName := sFileName + 'Export_Rapport_' + FormatDateTime('YYYYMMDD_hhmmss',Now) + '.csv';
          for i := 0 to (DBG_Rapport_sp2000.ColumnCount - 1) do
          begin
            if DBG_Rapport_sp2000.HPAddOn.Columns.CmzHidden.IndexOf(DBG_Rapport_sp2000.Columns[i].FieldName) = -1 then
              if DBG_Rapport_sp2000.Columns[i].Visible then
                case DBG_Rapport_sp2000.Columns[i].Field.DataType of
                  ftDate, ftDateTime :
                  begin
                    Header.Add(DBG_Rapport_sp2000.Columns[i].FieldName,0,alLeft,fmDate,'DD/MM/YYYY','.',DBG_Rapport_sp2000.Columns[i].Caption);
                  end;
                  ftInteger :
                  begin
                    Header.Add(DBG_Rapport_sp2000.Columns[i].FieldName,6,alLeft,fmInteger,'','.',DBG_Rapport_sp2000.Columns[i].Caption);
                  end;
                  else
                    Header.Add(DBG_Rapport_sp2000.Columns[i].FieldName,DBG_Rapport_sp2000.Columns[i].Field.Size,alLeft,fmNone,'','.',DBG_Rapport_sp2000.Columns[i].Caption);
                end;  //case
          end;  //for
          try
            screen.cursor := CrHourGlass;
            Dm_Main.Ds_Rapport.DataSet.DisableControls;
            try
              bm := Dm_Main.Ds_Rapport.DataSet.GetBookMark;
              if Header.ConvertToCsv(DBG_Rapport_sp2000,sFileName)=1 then
                ShowMessage('Création du fichier réussit : ' + sFileName)
              else if Header.ConvertToCsv(DBG_Rapport_sp2000,sFileName)=0 then
                ShowMessage('Aucune données à exporter dans le fichier : ' + sFileName)
              else
                ShowMessage('Echec de création du fichier : ' + sFileName);
              Dm_Main.Ds_Rapport.DataSet.GotoBookmark(bm);
              Dm_Main.Ds_Rapport.DataSet.FreeBookmark(bm);
              bm := nil;
            except
              Dm_Main.Ds_Rapport.DataSet.EnableControls;
              bm:= nil;
              exit;
            end;  //try ... except
          finally
            Dm_Main.Ds_Rapport.DataSet.EnableControls;
            screen.cursor := CrDefault;
          end;  //try ... finally
        end;
      Except on E:Exception do
        raise Exception.Create('DoMemStockToCsv -> ' + E.Message);
      end;  //try ... except
    finally
      Header.Free;
    end;  //try ... finally
  end;

  {if Pgc_Fond.ActivePage = Tab_OCCentrale then
  begin
    With Tfrm_OCExport.Create(Self) do
    try
      ShowModal;
    finally
      Release;
    end;
  end; }
end;

procedure TFrm_Main.Nbt_HistoClick(Sender: TObject);
var
  iMagId: Integer;
begin
  if Pgc_Fond.ActivePage = Tab_Magasin then
  begin
    iMagId := Dm_Main.Ds_mag.DataSet.FieldByName('mag_id').asInteger;
  end
  else if Pgc_Fond.ActivePage = Tab_Rapport then
  begin
    iMagId := Dm_Main.Ds_Rapport.DataSet.FieldByName('mag_id').asInteger;
  end;

  if iMagId <> 0 then
  begin
    Dm_Main.QHisto.Parameters[0].Value := iMagId;
    Dm_Main.QHisto.open;

    IF NOT Dm_Main.QHisto.eof THEN
      ExecuteHisto()
    else
      ShowMessage('Aucun historique n''est disponible pour ce magasin.');

    Dm_Main.QHisto.Close;
  end;
end;

procedure TFrm_Main.Nbt_ImportClick(Sender: TObject);
begin
  With Tfrm_OCImport.Create(Self) do
  try
    if ShowModal = mrOk then
    begin
      Dm_Main.QListOC.Close;
      Dm_Main.QListOC.Open;
    end;
  finally
    Release;
  end;
end;


procedure TFrm_Main.Nbt_insClick(Sender: TObject);
var
  iMagId: Integer;
begin
  iMagId := ExecuteInsMag(0);
  // Refresh des données
  UpdateQuery(Dm_Main.Qmag);
  Dm_Main.Ds_mag.DataSet.Locate('mag_id', iMagId, []);
  DBG_Magasin_sp2000.LocateDbg('MAG_ID', iMagId);
end;

procedure TFrm_Main.Nbt_modifClick(Sender: TObject);
var
  iMagId: Integer;
begin
  iMagId := Dm_Main.Ds_mag.DataSet.FieldByName('mag_id').asInteger;
  if iMagId <> 0 then
  begin
    ExecuteInsMag(iMagId);
    // Refresh des données
    UpdateQuery(Dm_Main.Qmag);
  end;
end;

procedure TFrm_Main.nbt_OCInsertClick(Sender: TObject);
begin
  With Tfrm_OC.Create(Self) do
  try
    Mode := mlInsert;
    Nom := '';

    if ShowModal = mrOk then
    begin
      Dm_Main.ado.BeginTrans;
      Dm_Main.QTemp.Close;
      Dm_Main.QTemp.SQL.Clear;
      Dm_Main.QTemp.SQL.Add('INSERT INTO [Database].Dbo.OCSP2K(OSO_NOM, OSO_SUPP)');
      Dm_Main.QTemp.SQL.Add('VALUES(' + QuotedStr(Nom) + ',0)');
//      Dm_Main.QTemp.ParamCheck := True;
//      Dm_Main.QTemp.Parameters.ParamByName('POSONOM').Value := Nom;
      Dm_Main.QTemp.ExecSQL;
      Dm_Main.ado.CommitTrans;
      Dm_Main.QListOC.Requery;
    end;
  finally
    Release;
  end;

end;

procedure TFrm_Main.nbt_OCUpdateClick(Sender: TObject);
var
  Id : Integer;
begin
  if Dm_Main.QListOC.RecordCount <= 0 then
    Exit;

  With Tfrm_OC.Create(Self) do
  try
    Mode := mlUpdate;
    Nom := Dm_Main.QListOC.FieldByName('OSO_NOM').AsString;
    Id := Dm_Main.QListOC.FieldByName('OSO_ID').AsInteger;

    if ShowModal = mrOk then
    begin
      Dm_Main.ado.BeginTrans;
      Dm_Main.QTemp.Close;
      Dm_Main.QTemp.SQL.Clear;
      Dm_Main.QTemp.SQL.Add('UPDATE [Database].Dbo.OCSP2K SET');
      Dm_Main.QTemp.SQL.Add('OSO_NOM = :POSONOM');
      Dm_Main.QTemp.SQL.Add('Where OSO_ID = :POSOID');
      Dm_Main.QTemp.ParamCheck := True;
      Dm_Main.QTemp.Parameters.ParamByName('POSONOM').Value := Nom;
      Dm_Main.QTemp.Parameters.ParamByName('POSOID').Value := Id;
      Dm_Main.QTemp.ExecSQL;
      Dm_Main.ado.CommitTrans;

      Dm_Main.QListOC.Close;
      Dm_Main.QListOC.Open;
      Dm_Main.QListOC.Locate('OSO_ID',id,[]);

    end;
  finally
    Release;
  end;
end;

procedure TFrm_Main.nbt_OCDeleteClick(Sender: TObject);
var
  id : integer;
begin
  if MessageDlg(Format('Etes vous sûr de vouloir supprimer l''Offre : %s ?',[Dm_Main.QListOC.FieldByName('OSO_NOM').AsString]),mtConfirmation,[mbYes,MbNo],0) = mrYes then
  begin
      id := Dm_Main.QListOC.FieldByName('OSO_ID').AsInteger;
      Dm_Main.ado.BeginTrans;
      Dm_Main.QTemp.Close;
      Dm_Main.QTemp.SQL.Clear;
      Dm_Main.QTemp.SQL.Add('UPDATE [Database].Dbo.OCSP2K SET');
      Dm_Main.QTemp.SQL.Add('  OSO_SUPP = 1');
      Dm_Main.QTemp.SQL.Add('Where OSO_ID = :POSOID');
      Dm_Main.QTemp.Parameters.ParamByName('POSOID').Value := id;
      Dm_Main.QTemp.ExecSQL;
      Dm_Main.ado.CommitTrans;

      Dm_Main.QListOC.Close;
      Dm_Main.QListOC.Open;
      Dm_Main.QListOC.Locate('OSO_ID',id,[]);
  end;
end;


procedure TFrm_Main.Pgc_FondChange(Sender: TObject);
begin
  if Pgc_Fond.ActivePage = Tab_Magasin then
  begin
    Nbt_Export.Hint := 'Exporter la grille';
  end;

  if Pgc_Fond.ActivePage = Tab_Rapport then
  begin
    Dm_Main.RefreshRapport;
  end;

  {if Pgc_Fond.ActivePage = Tab_OCCentrale then
  begin
    Dm_Main.QListOC.Close;
    Dm_Main.QListOC.Open;

    Nbt_Export.Hint := 'Exporter les OC';
  end;

  if Pgc_Fond.ActivePage = Tab_RapportOC then
  begin
    Dm_Main.QRapportOC.Close;
    Dm_Main.QRapportOC.Open;
  end;}

  {Pan_Mag.Visible := not (Pgc_Fond.ActivePage = Tab_OCCentrale);
  Lab_url.Visible := not (Pgc_Fond.ActivePage = Tab_OCCentrale);
  Nbt_Import.Visible := (Pgc_Fond.ActivePage = Tab_OCCentrale);}
//JB Nbt_Export.Visible := (Pgc_Fond.ActivePage = Tab_OCCentrale) or (Pgc_Fond.ActivePage = Tab_Magasin);
  Nbt_Export.Visible := (Pgc_Fond.ActivePage = Tab_Rapport) or
                        (Pgc_Fond.ActivePage = Tab_Magasin);
//
end;

procedure TFrm_Main.Tab_MagasinShow(Sender: TObject);
begin
  DBG_Magasin_sp2000.HPAddOn.Advanced.ButtonsPanel := Pan_Mag;

  Nbt_ins.Visible := True;
  Nbt_modif.Visible := True;
  Nbt_Histo.Visible := True;

  Nbt_Import.Visible := False;
  Application.ProcessMessages;
end;

{procedure TFrm_Main.Tab_OCCentraleShow(Sender: TObject);
begin
  Nbt_ins.Visible := False;
  Nbt_modif.Visible := False;
  Nbt_Histo.Visible := False;

end; }

{procedure TFrm_Main.Tab_RapportOCShow(Sender: TObject);
begin
  DBG_RapportOC.HPAddOn.Advanced.ButtonsPanel := Pan_Mag;
end; }

procedure TFrm_Main.Tab_RapportShow(Sender: TObject);
begin
  DBG_Rapport_sp2000.HPAddOn.Advanced.ButtonsPanel := Pan_Mag;

  DBG_Rapport_sp2000.Filter.Add(DBG_Rapport_sp2000mag_database,1,'1');

  Nbt_ins.Visible := False;
  Nbt_modif.Visible := False;
  Nbt_Histo.Visible := False;

  Application.ProcessMessages;
end;

procedure TFrm_Main.UpdateQuery(Query: TADOQuery);
var
  bm : TBookmark;
begin
  try
    screen.cursor := CrHourGlass;
    Query.DisableControls;
    try
      bm := Query.GetBookMark;

      Query.Active := False;
      Query.Active := True;

      Query.GotoBookmark(bm);
      Query.FreeBookmark(bm);
      bm := nil;
    except
      Query.EnableControls;
      bm:= nil;
      exit;
    end;
  finally
    Query.EnableControls;
    screen.cursor := CrDefault;
  end;
end;

end.

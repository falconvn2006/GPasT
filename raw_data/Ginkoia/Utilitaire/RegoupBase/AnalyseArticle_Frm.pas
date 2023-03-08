unit AnalyseArticle_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Boxes, PanBtnDbgHP, StdCtrls, LMDCustomButton, LMDButton, ExtCtrls, dxCntner, dxTL, dxDBCtrl,
  dxDBGrid, dxDBGridHP, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider,
  dxPSFillPatterns, dxPSEdgePatterns, dxPSCore, dxPSdxTLLnk, dxPSdxDBCtrlLnk, dxPSdxDBGrLnk, dxComponentPrinterHP, DB,
  Buttons, DBCtrls, dxDBTLCl, dxGrClms;

const
  WM_EXCELREPORT = WM_USER + 1001;

type
  TFrm_AnalyseArticle = class(TForm)
    Pgc_Analyse: TPageControl;
    Tab_ManquantDetail: TTabSheet;
    Tab_ArtACompleter: TTabSheet;
    DBG_ArtManqDet: TdxDBGridHP;
    dxPtr_ManqDet: TdxComponentPrinterHP;
    dxPtr_ManqDetLink1: TdxDBGridReportLink;
    Ds_ArtNewDet: TDataSource;
    Ds_ArtAModif: TDataSource;
    DBG_AModif: TdxDBGridHP;
    Pan_bas: TPanel;
    Nbt_Close1: TLMDButton;
    dxPtr_ArtAModif: TdxComponentPrinterHP;
    dxPtr_ArtAModifLink1: TdxDBGridReportLink;
    Spe_Etend: TSpeedButton;
    Spe_Replie: TSpeedButton;
    Spe_Exc: TSpeedButton;
    Spe_Imprim: TSpeedButton;
    DBNavig: TDBNavigator;
    DBG_AModifRecId: TdxDBGridColumn;
    DBG_AModifOrdreListe: TdxDBGridMaskColumn;
    DBG_AModifMarque: TdxDBGridMaskColumn;
    DBG_AModifRef: TdxDBGridMaskColumn;
    DBG_AModifTypeInfo: TdxDBGridMaskColumn;
    DBG_AModifLibelle: TdxDBGridMaskColumn;
    DBG_AModifInfo: TdxDBGridMaskColumn;
    Tab_MarqDiff: TTabSheet;
    DBG_MarqDiff: TdxDBGridHP;
    Ds_MarqDiff: TDataSource;
    dxPtr_MarqDiff: TdxComponentPrinterHP;
    DBG_MarqDiffRecId: TdxDBGridColumn;
    DBG_MarqDiffOrdreListe: TdxDBGridMaskColumn;
    DBG_MarqDiffMarque: TdxDBGridMaskColumn;
    DBG_MarqDiffRef: TdxDBGridMaskColumn;
    DBG_MarqDiffTypeInfo: TdxDBGridMaskColumn;
    DBG_MarqDiffLibelle: TdxDBGridMaskColumn;
    DBG_MarqDiffInfo: TdxDBGridMaskColumn;
    dxPtr_MarqDiffLink1: TdxDBGridReportLink;
    Tab_Manquant: TTabSheet;
    DBG_ArtNouv: TdxDBGridHP;
    DBG_ArtManqDetRecId: TdxDBGridColumn;
    DBG_ArtManqDetOrdreListe: TdxDBGridMaskColumn;
    DBG_ArtManqDetMarque: TdxDBGridMaskColumn;
    DBG_ArtManqDetRef: TdxDBGridMaskColumn;
    DBG_ArtManqDetTypeInfo: TdxDBGridMaskColumn;
    DBG_ArtManqDetLibelle: TdxDBGridMaskColumn;
    DBG_ArtManqDetInfo: TdxDBGridMaskColumn;
    DBG_ArtManqDetPxAch: TdxDBGridMaskColumn;
    DBG_ArtManqDetPxVen: TdxDBGridMaskColumn;
    DBG_ArtManqDetTailleTrav: TdxDBGridMaskColumn;
    DBG_ArtManqDetCouleur: TdxDBGridMaskColumn;
    DBG_ArtManqDetRayon: TdxDBGridMaskColumn;
    DBG_ArtManqDetFamille: TdxDBGridMaskColumn;
    DBG_ArtManqDetSFamille: TdxDBGridMaskColumn;
    DBG_ArtManqDetSecteur: TdxDBGridMaskColumn;
    DBG_ArtManqDetCateg: TdxDBGridMaskColumn;
    DBG_ArtManqDetSCateg: TdxDBGridMaskColumn;
    DBG_ArtManqDetGenre: TdxDBGridMaskColumn;
    Ds_ArtNouv: TDataSource;
    dxPtr_ArtNouv: TdxComponentPrinterHP;
    dxPtr_ArtNouvLink1: TdxDBGridReportLink;
    DBG_ArtNouvRecId: TdxDBGridColumn;
    DBG_ArtNouvOrdreListe: TdxDBGridMaskColumn;
    DBG_ArtNouvMarque: TdxDBGridMaskColumn;
    DBG_ArtNouvRef: TdxDBGridMaskColumn;
    DBG_ArtNouvTypeInfo: TdxDBGridMaskColumn;
    DBG_ArtNouvLibelle: TdxDBGridMaskColumn;
    DBG_ArtNouvInfo: TdxDBGridMaskColumn;
    DBG_ArtNouvPxAch: TdxDBGridMaskColumn;
    DBG_ArtNouvPxVen: TdxDBGridMaskColumn;
    DBG_ArtNouvRayon: TdxDBGridMaskColumn;
    DBG_ArtNouvFamille: TdxDBGridMaskColumn;
    DBG_ArtNouvSFamille: TdxDBGridMaskColumn;
    DBG_ArtNouvSecteur: TdxDBGridMaskColumn;
    DBG_ArtNouvCateg: TdxDBGridMaskColumn;
    DBG_ArtNouvSCateg: TdxDBGridMaskColumn;
    DBG_ArtNouvGenre: TdxDBGridMaskColumn;
    DBG_ArtNouvStock: TdxDBGridMaskColumn;
    DBG_ArtManqDetStock: TdxDBGridMaskColumn;
    DBG_ArtManqDetDatCre: TdxDBGridDateColumn;
    DBG_ArtNouvDatCre: TdxDBGridDateColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Spe_ImprimClick(Sender: TObject);
    procedure Spe_EtendClick(Sender: TObject);
    procedure Spe_ReplieClick(Sender: TObject);
    procedure Spe_ExcClick(Sender: TObject);
    procedure Pgc_AnalyseChange(Sender: TObject);
  private
    { Déclarations privées }
    Etatfiche: boolean;
    FicExcelManquant: string;  // fichier excel pour les articles manquants
    FicExcelManquantDet: string;  // fichier excel pour les articles manquants détaillés
    FicExcelMarqDiff: string;    // fichier excel pour les articles ref identique marque différente
    FicExcelAModif: string;    // fichier excel pour les articles à modifier
    procedure DoExcel(ACas: integer);
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    procedure SetInit(ABase1, ABase2: string);
  end;

var
  Frm_AnalyseArticle: TFrm_AnalyseArticle;

implementation  

uses
  Main_Dm, ShellApi, ExportExcelConfirm_Frm;

{$R *.dfm}  

procedure TFrm_AnalyseArticle.SetInit(ABase1, ABase2: string);
var
  d: TDateTime;
begin
  d := Now;

  FicExcelManquant := 'Articles manquant dans la base '+ABase2+' '+
              FormatDateTime('dd-mm-yyyy', d)+' '+
              FormatDateTime('hh.nn.ss', d)+'.xls';

  dxPtr_ArtNouvLink1.PrinterPage.PageHeader.CenterTitle.Text := 'Articles manquant dans la base '+ABase2+' '+
                                                                FormatDateTime('dd-mm-yyyy', d)+' '+
                                                                FormatDateTime('hh.nn.ss', d)+'.xls';

  FicExcelManquantDet := 'Articles manquant détaillés dans la base '+ABase2+
              FormatDateTime('dd-mm-yyyy', d)+' '+
              FormatDateTime('hh.nn.ss', d)+'.xls';

  dxPtr_ManqDetLink1.PrinterPage.PageHeader.CenterTitle.Text := 'Articles manquant détaillés dans la base '+ABase2+' '+
                                                                FormatDateTime('dd-mm-yyyy', d)+' '+
                                                                FormatDateTime('hh.nn.ss', d)+'.xls';


  FicExcelMarqDiff := 'Articles Réf. identique marque différente dans la base '+ABase2+' '+
              FormatDateTime('dd-mm-yyyy', d)+' '+
              FormatDateTime('hh.nn.ss', d)+'.xls';

  dxPtr_MarqDiffLink1.PrinterPage.PageHeader.CenterTitle.Text := 'Articles Réf. identique marque différente dans la base '+ABase2+' '+
                                                                FormatDateTime('dd-mm-yyyy', d)+' '+
                                                                FormatDateTime('hh.nn.ss', d)+'.xls';
                                                                
  FicExcelAModif := 'Articles à compléter dans la base '+ABase2+' '+
              FormatDateTime('dd-mm-yyyy', d)+' '+
              FormatDateTime('hh.nn.ss', d)+'.xls';

  dxPtr_ArtAModifLink1.PrinterPage.PageHeader.CenterTitle.Text := 'Articles à compléter dans la base '+ABase2+' '+
                                                                FormatDateTime('dd-mm-yyyy', d)+' '+
                                                                FormatDateTime('hh.nn.ss', d)+'.xls';

  if Dm_Main.MemD_ArtNewDet.Active then
    Dm_Main.MemD_ArtNewDet.First;
  if Dm_Main.MemD_ArtAModif.Active then
    Dm_Main.MemD_ArtAModif.First;

  DBG_ArtManqDet.FullExpand;
  DBG_AModif.FullExpand;

  DBG_ArtNouv.DoAutoWidth;
  DBG_ArtManqDet.DoAutoWidth;
  DBG_MarqDiff.DoAutoWidth;
  DBG_AModif.DoAutoWidth;
end;

procedure TFrm_AnalyseArticle.DoExcel(ACas: integer);
var
  sFileName: string;
  Flag: boolean;
  bOk: boolean;
  bOuvreExcel: boolean;
begin  
  case ACas of
    1:
    begin
      if FicExcelManquant='' then
        exit;
      sFileName := ReperBase+'Exports\';
      if not(DirectoryExists(sFileName)) then
        ForceDirectories(sFileName);
      sFileName := sFileName+FicExcelManquant;

      bOuvreExcel := false;
      bOk := false;
      Frm_ExportExcelConfirm := TFrm_ExportExcelConfirm.Create(Self);
      try
        Frm_ExportExcelConfirm.SetInit(sFilename);
        bOk := (Frm_ExportExcelConfirm.ShowModal = mrok);
        bOuvreExcel := Frm_ExportExcelConfirm.Chk_OuvrirExcel.Checked;
      finally
        Frm_ExportExcelConfirm.Free;
        Frm_ExportExcelConfirm:=nil;
      end;
      if not(bOk) then
        exit;

      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      Flag := False;
      if (DBG_ArtNouv.HPAddOn.Groupes.SummaryGroupOnTop and DBG_ArtNouv.ShowRowFooter) then
      begin
        Flag := True;
        DBG_ArtNouv.HpAddon.Groupes.SummaryGroupOnTop := false;
      end;
      DBG_ArtNouv.BeginUpdate;
      try
        DBG_ArtNouv.SaveToXLS(sFileName, true);
      finally
        if Flag then
          DBG_ArtNouv.HpAddon.Groupes.SummaryGroupOnTop := true;

        DBG_ArtNouv.EndUpdate;
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;

      if bOuvreExcel then
        ShellExecute(0, 'open', PChar(sFileName), nil, nil, SW_SHOW);
    end;    // 1

    2:
    begin
      if FicExcelManquantDet='' then
        exit;
      sFileName := ReperBase+'Exports\';
      if not(DirectoryExists(sFileName)) then
        ForceDirectories(sFileName);
      sFileName := sFileName+FicExcelManquantDet;

      bOuvreExcel := false;
      bOk := false;
      Frm_ExportExcelConfirm := TFrm_ExportExcelConfirm.Create(Self);
      try
        Frm_ExportExcelConfirm.SetInit(sFilename);
        bOk := (Frm_ExportExcelConfirm.ShowModal = mrok);
        bOuvreExcel := Frm_ExportExcelConfirm.Chk_OuvrirExcel.Checked;
      finally
        Frm_ExportExcelConfirm.Free;
        Frm_ExportExcelConfirm:=nil;
      end;
      if not(bOk) then
        exit;

      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      Flag := False;
      if (DBG_ArtManqDet.HPAddOn.Groupes.SummaryGroupOnTop and DBG_ArtManqDet.ShowRowFooter) then
      begin
        Flag := True;
        DBG_ArtManqDet.HpAddon.Groupes.SummaryGroupOnTop := false;
      end;
      DBG_ArtManqDet.BeginUpdate;
      try
        DBG_ArtManqDet.SaveToXLS(sFileName, true);
      finally
        if Flag then
          DBG_ArtManqDet.HpAddon.Groupes.SummaryGroupOnTop := true;

        DBG_ArtManqDet.EndUpdate;
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;

      if bOuvreExcel then
        ShellExecute(0, 'open', PChar(sFileName), nil, nil, SW_SHOW);
    end;    // 2

    3:
    begin
      if FicExcelMarqDiff='' then
        exit;
      sFileName := ReperBase+'Exports\';
      if not(DirectoryExists(sFileName)) then
        ForceDirectories(sFileName);
      sFileName := sFileName+FicExcelMarqDiff;

      bOuvreExcel := false;
      bOk := false;
      Frm_ExportExcelConfirm := TFrm_ExportExcelConfirm.Create(Self);
      try
        Frm_ExportExcelConfirm.SetInit(sFilename);
        bOk := (Frm_ExportExcelConfirm.ShowModal = mrok);
        bOuvreExcel := Frm_ExportExcelConfirm.Chk_OuvrirExcel.Checked;
      finally
        Frm_ExportExcelConfirm.Free;
        Frm_ExportExcelConfirm:=nil;
      end;
      if not(bOk) then
        exit;

      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      Flag := False;
      if (DBG_MarqDiff.HPAddOn.Groupes.SummaryGroupOnTop and DBG_MarqDiff.ShowRowFooter) then
      begin
        Flag := True;
        DBG_MarqDiff.HpAddon.Groupes.SummaryGroupOnTop := false;
      end;
      DBG_MarqDiff.BeginUpdate;
      try
        DBG_MarqDiff.SaveToXLS(sFileName, true);
      finally
        if Flag then
          DBG_MarqDiff.HpAddon.Groupes.SummaryGroupOnTop := true;

        DBG_MarqDiff.EndUpdate;
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;

      if bOuvreExcel then
        ShellExecute(0, 'open', PChar(sFileName), nil, nil, SW_SHOW);
    end;    // 3
    
    4:
    begin
      if FicExcelAModif='' then
        exit;
      sFileName := ReperBase+'Exports\';
      if not(DirectoryExists(sFileName)) then
        ForceDirectories(sFileName);
      sFileName := sFileName+FicExcelAModif;

      bOuvreExcel := false;
      bOk := false;
      Frm_ExportExcelConfirm := TFrm_ExportExcelConfirm.Create(Self);
      try
        Frm_ExportExcelConfirm.SetInit(sFilename);
        bOk := (Frm_ExportExcelConfirm.ShowModal = mrok);
        bOuvreExcel := Frm_ExportExcelConfirm.Chk_OuvrirExcel.Checked;
      finally
        Frm_ExportExcelConfirm.Free;
        Frm_ExportExcelConfirm:=nil;
      end;
      if not(bOk) then
        exit;

      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      Flag := False;
      if (DBG_AModif.HPAddOn.Groupes.SummaryGroupOnTop and DBG_AModif.ShowRowFooter) then
      begin
        Flag := True;
        DBG_AModif.HpAddon.Groupes.SummaryGroupOnTop := false;
      end;
      DBG_ArtManqDet.BeginUpdate;
      try
        DBG_AModif.SaveToXLS(sFileName, true);
      finally
        if Flag then
          DBG_AModif.HpAddon.Groupes.SummaryGroupOnTop := true;

        DBG_AModif.EndUpdate;
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;

      if bOuvreExcel then
        ShellExecute(0, 'open', PChar(sFileName), nil, nil, SW_SHOW);
    end;    // 4
  end;
end;

procedure TFrm_AnalyseArticle.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

procedure TFrm_AnalyseArticle.FormActivate(Sender: TObject);
begin    
  if EtatFiche then
    exit;

  EtatFiche := true;
  Application.ProcessMessages;
  Align := AlNone;
  Application.ProcessMessages;
  ReAlign;    
  Application.ProcessMessages;
end;

procedure TFrm_AnalyseArticle.FormCreate(Sender: TObject);
begin
  Etatfiche := false;
  Pgc_Analyse.ActivePage := Tab_Manquant;
  DBNavig.DataSource := Ds_ArtNouv;
end;

procedure TFrm_AnalyseArticle.Pgc_AnalyseChange(Sender: TObject);
begin

  if Pgc_Analyse.ActivePage = Tab_Manquant then
  begin
    DBNavig.DataSource := Ds_ArtNouv;
  end
  else if Pgc_Analyse.ActivePage = Tab_ManquantDetail then
  begin
    DBNavig.DataSource := Ds_ArtNewDet;
  end     
  else if Pgc_Analyse.ActivePage = Tab_MarqDiff then
  begin
    DBNavig.DataSource := Ds_MarqDiff;
  end
  else if Pgc_Analyse.ActivePage = Tab_ArtACompleter then
  begin
    DBNavig.DataSource := Ds_ArtAModif;
  end

end;

procedure TFrm_AnalyseArticle.Spe_ReplieClick(Sender: TObject);
begin
  if Pgc_Analyse.ActivePage=Tab_Manquant then
  begin
    DBG_ArtNouv.FullCollapse;
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_ManquantDetail then
  begin
    DBG_ArtManqDet.FullCollapse;
    exit;
  end; 

  if Pgc_Analyse.ActivePage=Tab_MarqDiff then
  begin
    DBG_MarqDiff.FullCollapse;
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_ArtACompleter then
  begin
    DBG_AModif.FullCollapse;
    exit;
  end;
end;

procedure TFrm_AnalyseArticle.Spe_ExcClick(Sender: TObject);
begin
  if Pgc_Analyse.ActivePage=Tab_Manquant then
  begin
    DoExcel(1);
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_ManquantDetail then
  begin
    DoExcel(2);
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_MarqDiff then
  begin
    DoExcel(3);
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_ArtACompleter then
  begin
    DoExcel(4);
    exit;
  end;
end;

procedure TFrm_AnalyseArticle.Spe_EtendClick(Sender: TObject);
begin            
  if Pgc_Analyse.ActivePage=Tab_Manquant then
  begin
    DBG_ArtNouv.FullExpand;
    exit;
  end; 

  if Pgc_Analyse.ActivePage=Tab_ManquantDetail then
  begin
    DBG_ArtManqDet.FullExpand;
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_MarqDiff then
  begin
    DBG_MarqDiff.FullExpand;
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_ArtACompleter then
  begin
    DBG_AModif.FullExpand;
    exit;
  end;
end;

procedure TFrm_AnalyseArticle.Spe_ImprimClick(Sender: TObject);
var
  ReportTitle: TStrings;
  i: Integer;
  head: STRING;
  nb, dif, w, ww, l, r : Integer;
begin 
  if Pgc_Analyse.ActivePage=Tab_Manquant then
  begin
    ReportTitle := TStringList.Create;
    try
      DBG_ArtNouv.CtrlDimLeftBand;
      nb := 0;
      if DBG_ArtNouv.Bands.Count > 1 then
      begin
        ww := 0;
        DBG_ArtNouv.GetBandeInfo(0, L, R, W);
        if W > 0 then
        begin
          for i := 0  to DBG_ArtNouv.VisibleColumnCount -1 DO
          begin
            if ( DBG_ArtNouv.VisibleColumns[i].BandIndex = 0 ) AND
                   ( DBG_ArtNouv.VisibleColumns[i].Visible ) then
            begin
              ww := ww + DBG_ArtNouv.VisibleColumns[i].width;
              Inc(Nb);
            end;
          end;
        end;
        dif := ( DBG_ArtNouv.Bands[0].width - ( 23 * DBG_ArtNouv.groupColumnCount)) - ww;
        if dif > 0 then
        begin
          for i := DBG_ArtNouv.VisibleColumnCount -1 downto 0 do
          begin
            if ( DBG_ArtNouv.VisibleColumns[i].BandIndex = 0 ) and
                      ( DBG_ArtNouv.VisibleColumns[i].Visible ) then
              DBG_ArtNouv.VisibleColumns[i].Width := DBG_ArtNouv.VisibleColumns[i].Width + Trunc( dif / nb );

          end;
        end;
      end;
      DBG_ArtNouv.Repaint;

      dxPtr_ArtNouv.PrintDBGHP(DBG_ArtNouv, Head, ReportTitle);
    finally
      FreeAndNil(ReportTitle);
    end;
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_ManquantDetail then
  begin
    ReportTitle := TStringList.Create;
    try
      DBG_ArtManqDet.CtrlDimLeftBand;
      nb := 0;
      if DBG_ArtManqDet.Bands.Count > 1 then
      begin
        ww := 0;
        DBG_ArtManqDet.GetBandeInfo(0, L, R, W);
        if W > 0 then
        begin
          for i := 0  to DBG_ArtManqDet.VisibleColumnCount -1 DO
          begin
            if ( DBG_ArtManqDet.VisibleColumns[i].BandIndex = 0 ) AND
                   ( DBG_ArtManqDet.VisibleColumns[i].Visible ) then
            begin
              ww := ww + DBG_ArtManqDet.VisibleColumns[i].width;
              Inc(Nb);
            end;
          end;
        end;
        dif := ( DBG_ArtManqDet.Bands[0].width - ( 23 * DBG_ArtManqDet.groupColumnCount)) - ww;
        if dif > 0 then
        begin
          for i := DBG_ArtManqDet.VisibleColumnCount -1 downto 0 do
          begin
            if ( DBG_ArtManqDet.VisibleColumns[i].BandIndex = 0 ) and
                      ( DBG_ArtManqDet.VisibleColumns[i].Visible ) then
              DBG_ArtManqDet.VisibleColumns[i].Width := DBG_ArtManqDet.VisibleColumns[i].Width + Trunc( dif / nb );

          end;
        end;
      end;
      DBG_ArtManqDet.Repaint;

      dxPtr_ManqDet.PrintDBGHP(DBG_ArtManqDet, Head, ReportTitle);
    finally
      FreeAndNil(ReportTitle);
    end;
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_MarqDiff then
  begin
    ReportTitle := TStringList.Create;
    try
      DBG_MarqDiff.CtrlDimLeftBand;
      nb := 0;
      if DBG_MarqDiff.Bands.Count > 1 then
      begin
        ww := 0;
        DBG_MarqDiff.GetBandeInfo(0, L, R, W);
        if W > 0 then
        begin
          for i := 0  to DBG_MarqDiff.VisibleColumnCount -1 DO
          begin
            if ( DBG_MarqDiff.VisibleColumns[i].BandIndex = 0 ) AND
                   ( DBG_MarqDiff.VisibleColumns[i].Visible ) then
            begin
              ww := ww + DBG_MarqDiff.VisibleColumns[i].width;
              Inc(Nb);
            end;
          end;
        end;
        dif := ( DBG_MarqDiff.Bands[0].width - ( 23 * DBG_AModif.groupColumnCount)) - ww;
        if dif > 0 then
        begin
          for i := DBG_MarqDiff.VisibleColumnCount -1 downto 0 do
          begin
            if ( DBG_MarqDiff.VisibleColumns[i].BandIndex = 0 ) and
                      ( DBG_MarqDiff.VisibleColumns[i].Visible ) then
              DBG_MarqDiff.VisibleColumns[i].Width := DBG_MarqDiff.VisibleColumns[i].Width + Trunc( dif / nb );

          end;
        end;
      end;
      DBG_MarqDiff.Repaint;

      dxPtr_MarqDiff.PrintDBGHP(DBG_MarqDiff, Head, ReportTitle);
    finally
      FreeAndNil(ReportTitle);
    end;  
    exit;
  end;

  if Pgc_Analyse.ActivePage=Tab_ArtACompleter then
  begin
    ReportTitle := TStringList.Create;
    try
      DBG_AModif.CtrlDimLeftBand;
      nb := 0;
      if DBG_AModif.Bands.Count > 1 then
      begin
        ww := 0;
        DBG_AModif.GetBandeInfo(0, L, R, W);
        if W > 0 then
        begin
          for i := 0  to DBG_AModif.VisibleColumnCount -1 DO
          begin
            if ( DBG_AModif.VisibleColumns[i].BandIndex = 0 ) AND
                   ( DBG_AModif.VisibleColumns[i].Visible ) then
            begin
              ww := ww + DBG_AModif.VisibleColumns[i].width;
              Inc(Nb);
            end;
          end;
        end;
        dif := ( DBG_AModif.Bands[0].width - ( 23 * DBG_AModif.groupColumnCount)) - ww;
        if dif > 0 then
        begin
          for i := DBG_AModif.VisibleColumnCount -1 downto 0 do
          begin
            if ( DBG_AModif.VisibleColumns[i].BandIndex = 0 ) and
                      ( DBG_AModif.VisibleColumns[i].Visible ) then
              DBG_AModif.VisibleColumns[i].Width := DBG_AModif.VisibleColumns[i].Width + Trunc( dif / nb );

          end;
        end;
      end;
      DBG_AModif.Repaint;

      dxPtr_ArtAModif.PrintDBGHP(DBG_AModif, Head, ReportTitle);
    finally
      FreeAndNil(ReportTitle);
    end;  
    exit;
  end;
end;

end.

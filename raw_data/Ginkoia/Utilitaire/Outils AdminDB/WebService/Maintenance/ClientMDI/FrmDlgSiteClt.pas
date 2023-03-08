unit FrmDlgSiteClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Buttons, ExtCtrls, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, Grids, DBGrids, DBCtrls, ComCtrls, Mask, cxPC, DB,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, dmdClient, FrameHeureMinute,
  FrameToolBar, Spin, FramUpDown, DBClient;


type
  TDlgSiteCltFrm = class(TCustomGinkoiaDlgFrm)
    PgCtrlSite: TcxPageControl;
    TbShtInfoGen: TcxTabSheet;
    TbShtReplicLames: TcxTabSheet;
    TbShtConnexion: TcxTabSheet;
    Label12: TLabel;
    DBEDT_CEGID: TDBEdit;
    Label30: TLabel;
    Label9: TLabel;
    DBEDT_IDENT: TDBEdit;
    Label10: TLabel;
    DBEDT_JETONS: TDBEdit;
    DBCHK_NONREPLICATION: TDBCheckBox;
    Lab_2: TLabel;
    DBC_TYPEREPLICATION: TDBComboBox;
    Lab_3: TLabel;
    DBLK_SERVEURSECOURS: TDBLookupComboBox;
    Lab_4: TLabel;
    CB_MAGPRINCIPAL: TComboBox;
    DsEmetteur: TDataSource;
    DBEDT_SENDER: TDBEdit;
    DsSrvSecours: TDataSource;
    GrpBxH1: TGroupBox;
    GrpBxOptions: TGroupBox;
    CHK_AUTO: TCheckBox;
    CHK_FORCEMAJ: TCheckBox;
    GrpBxNONREPLICATION: TGroupBox;
    DTP_DEBUTNONREPLICATION: TDateTimePicker;
    DTP_FINNONREPLICATION: TDateTimePicker;
    Lab_11: TLabel;
    Lab_1: TLabel;
    cxGridConnexion: TcxGrid;
    cxGridTWConnexion: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    DsConnexion: TDataSource;
    cxGridTWConnexionCON_ID: TcxGridDBColumn;
    cxGridTWConnexionCON_LAUID: TcxGridDBColumn;
    cxGridTWConnexionCON_NOM: TcxGridDBColumn;
    cxGridTWConnexionCON_TEL: TcxGridDBColumn;
    cxGridTWConnexionCON_TYPE: TcxGridDBColumn;
    cxGridTWConnexionCON_ORDRE: TcxGridDBColumn;
    FrameHeureReplic1: THeureMinuteFrame;
    GrpBxPlage: TGroupBox;
    DBEDT_PLAGE: TDBEdit;
    EdtPlageDeb: TEdit;
    EdtPlageFin: TEdit;
    Lab_7: TLabel;
    Lab_12: TLabel;
    Lab_13: TLabel;
    pnlTop: TPanel;
    Lab_14: TLabel;
    DBEDT_NOM: TDBEdit;
    TlBrFrameConnexion: TToolBarFrame;
    GrpBxReplicTempsReel: TGroupBox;
    pnlListRC: TPanel;
    ToolBarFrameListRC: TToolBarFrame;
    cxGridListRC: TcxGrid;
    cxGridDBTWListRC: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    DsListRC: TDataSource;
    Lab_5: TLabel;
    Lab_6: TLabel;
    Lab_8: TLabel;
    Lab_9: TLabel;
    GrpBxWebServiceJeton: TGroupBox;
    Lab_10: TLabel;
    Lab_15: TLabel;
    Lab_16: TLabel;
    HeureMinuteFrameRTRHeureDeb: THeureMinuteFrame;
    HeureMinuteFrameRTRHeureFin: THeureMinuteFrame;
    DBEdtURL: TDBEdit;
    DBEdtSender: TDBEdit;
    DBEdtDatabase: TDBEdit;
    TbShtReplicWeb: TcxTabSheet;
    pnlListRW: TPanel;
    ToolBarFrameListRW: TToolBarFrame;
    cxGridListRW: TcxGrid;
    cxGridDBTableViewListRW: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    Lab_17: TLabel;
    Lab_18: TLabel;
    Lab_19: TLabel;
    HeureMinuteFrameRWHeureDeb: THeureMinuteFrame;
    HeureMinuteFrameRWHeureFin: THeureMinuteFrame;
    DBRdGrpRWOrdre: TDBRadioGroup;
    FrameHeureBackup: THeureMinuteFrame;
    CHK_FORCERBACKUP: TCheckBox;
    DBCK_H1: TDBCheckBox;
    DBCK_H2: TDBCheckBox;
    FrameHeureReplic2: THeureMinuteFrame;
    DBEdtNBESSAI: TDBEdit;
    DBEdtDELAI: TDBEdit;
    DBEdtRWINTERVAL: TDBEdit;
    cxGridDBTWListRCREP_URLDISTANT: TcxGridDBColumn;
    cxGridDBTWListRCREP_PLACEEAI: TcxGridDBColumn;
    cxGridDBTWListRCREP_PLACEBASE: TcxGridDBColumn;
    cxGridDBTWListRCREP_JOUR: TcxGridDBColumn;
    cxGridDBTableViewListRWREP_URLDISTANT: TcxGridDBColumn;
    cxGridDBTableViewListRWREP_PLACEEAI: TcxGridDBColumn;
    cxGridDBTableViewListRWREP_PLACEBASE: TcxGridDBColumn;
    DsListRW: TDataSource;
    cxStyleRepository: TcxStyleRepository;
    cxStyleRO: TcxStyle;
    UpDownFramReplicLames: TUpDownFram;
    UpDownFramReplicWeb: TUpDownFram;
    ChkBxActiveWeb: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure DsEmetteurDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure CHK_FORCERBACKUPClick(Sender: TObject);
    procedure DBCHK_NONREPLICATIONClick(Sender: TObject);
    procedure EdtPlageDebChange(Sender: TObject);
    procedure EdtPlageDebKeyPress(Sender: TObject; var Key: Char);
    procedure DBEDT_NOMExit(Sender: TObject);
    procedure DBC_TYPEREPLICATIONChange(Sender: TObject);
    procedure TlBrFrameConnexionActInsertExecute(Sender: TObject);
    procedure TlBrFrameConnexionActUpdateExecute(Sender: TObject);
    procedure TlBrFrameConnexionActDeleteExecute(Sender: TObject);
    procedure TbShtConnexionShow(Sender: TObject);
    procedure cxGridTWConnexionDblClick(Sender: TObject);
    procedure CB_MAGPRINCIPALKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBEdtNBESSAIKeyPress(Sender: TObject; var Key: Char);
    procedure ToolBarFrameListRCActRefreshExecute(Sender: TObject);
    procedure ToolBarFrameListRWActRefreshExecute(Sender: TObject);
    procedure ToolBarFrameListRCActInsertExecute(Sender: TObject);
    procedure ToolBarFrameListRCActUpdateExecute(Sender: TObject);
    procedure ToolBarFrameListRCActDeleteExecute(Sender: TObject);
    procedure UpDownFramReplicLamesSpdBtnUpClick(Sender: TObject);
    procedure UpDownFramReplicLamesSpdBtnDownClick(Sender: TObject);
    procedure ChkBxActiveWebClick(Sender: TObject);
    procedure DBEDT_NOMKeyPress(Sender: TObject; var Key: Char);
    procedure DBEDT_SENDERKeyPress(Sender: TObject; var Key: Char);
    procedure DBEDT_CEGIDKeyPress(Sender: TObject; var Key: Char);
    procedure DBEDT_SENDERClick(Sender: TObject);
  private
    FdmClient: TdmClient;
    FVER_MAJEURE: integer;
    procedure ExtractPlage;

    procedure LoadConnexion;
    procedure ShowDetailConnexion(const AAction: TUpdateKind);
    procedure ShowDetailReplication(const AAction: TUpdateKind);

    procedure GestionAccessComponentVersion(Const AVER_MAJEURE: integer);
  protected
    function PostValues: Boolean; override;
  public
    procedure CheckBaseZero;
    property AdmClient: TdmClient read FdmClient write FdmClient;
  end;

var
  DlgSiteCltFrm: TDlgSiteCltFrm;

implementation

uses dmdClients, uTool, uConst, FrmDlgConnexionClt, FrmDlgParamReplic;

{$R *.dfm}

procedure TDlgSiteCltFrm.CB_MAGPRINCIPALKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_DELETE then
    CB_MAGPRINCIPAL.ItemIndex:= -1;
end;

procedure TDlgSiteCltFrm.CheckBaseZero;
var
  vBM: TBookmark;
begin
  if AAction <> ukInsert then
    Exit;
  vBM:= DsEmetteur.DataSet.GetBookmark;
  DsEmetteur.DataSet.DisableControls;
  try
    if DsEmetteur.DataSet.Locate('EMET_IDENT', 0, []) then
      DBC_TYPEREPLICATION.Items.Delete(0);
  finally
    DsEmetteur.DataSet.GotoBookmark(vBM);
    DsEmetteur.DataSet.FreeBookmark(vBM);
    DsEmetteur.DataSet.EnableControls;
  end;
end;

procedure TDlgSiteCltFrm.ChkBxActiveWebClick(Sender: TObject);
begin
  inherited;
  if ChkBxActiveWeb.Checked then
    begin
      HeureMinuteFrameRWHeureDeb.AEnabled:= True;
      HeureMinuteFrameRWHeureFin.AEnabled:= True;
      DBEdtRWINTERVAL.Enabled:= True;
      DBRdGrpRWOrdre.Enabled:= True;
    end
  else
    begin
      HeureMinuteFrameRWHeureDeb.AEnabled:= False;
      HeureMinuteFrameRWHeureFin.AEnabled:= False;
      DBEdtRWINTERVAL.Enabled:= False;
      DBRdGrpRWOrdre.Enabled:= False;

      HeureMinuteFrameRWHeureDeb.Reset:= True;
      HeureMinuteFrameRWHeureFin.Reset:= True;
      DBEdtRWINTERVAL.Field.AsInteger:= 0;
      DBRdGrpRWOrdre.ItemIndex:= -1;
    end;
end;

procedure TDlgSiteCltFrm.CHK_FORCERBACKUPClick(Sender: TObject);
begin
  inherited;
  FrameHeureBackup.Reset:= not CHK_FORCERBACKUP.Checked;
  DsEmetteurDataChange(nil, nil);
end;

procedure TDlgSiteCltFrm.ExtractPlage;
var
  i: integer;
  vSL: TStringList;
  vEventDeb, vEventFin: TNotifyEvent;
begin
  vEventDeb:= EdtPlageDeb.OnChange;
  vEventFin:= EdtPlageFin.OnChange;
  EdtPlageDeb.OnChange:= nil;
  EdtPlageFin.OnChange:= nil;
  vSL:= TStringList.Create;
  try
   vSL.Text:= StringReplace(DsEmetteur.DataSet.FieldByName('EMET_PLAGE').AsString, '_', #13#10, []);
   if vSL.Count = 0 then
     Exit;
   for i:= 0 to vSL.Count - 1 do
     begin
       vSL.Strings[i]:= StringReplace(vSL.Strings[i], '[', '', [rfReplaceAll]);
       vSL.Strings[i]:= StringReplace(vSL.Strings[i], ']', '', [rfReplaceAll]);
       vSL.Strings[i]:= StringReplace(vSL.Strings[i], 'M', '', [rfReplaceAll]);
     end;
    EdtPlageDeb.Text:= vSL.Strings[0];
    EdtPlageFin.Text:= vSL.Strings[1];
  finally
    EdtPlageDeb.OnChange:= vEventDeb;
    EdtPlageFin.OnChange:= vEventFin;
    FreeAndNil(vSL);
  end;
end;

procedure TDlgSiteCltFrm.cxGridTWConnexionDblClick(Sender: TObject);
begin
  inherited;
  TlBrFrameConnexion.ActUpdate.Execute;
end;

procedure TDlgSiteCltFrm.DBCHK_NONREPLICATIONClick(Sender: TObject);
begin
  inherited;
  DsEmetteurDataChange(nil, nil);
end;

procedure TDlgSiteCltFrm.DBC_TYPEREPLICATIONChange(Sender: TObject);
begin
  inherited;
  if DBC_TYPEREPLICATION.ItemIndex in [1..3] then
    begin
      CHK_AUTO.Checked:= True;
      CHK_FORCEMAJ.Checked:= DBC_TYPEREPLICATION.ItemIndex = 3;
    end
  else
    begin
      CHK_AUTO.Checked:= False;
      CHK_FORCEMAJ.Checked:= False;
    end;
end;

procedure TDlgSiteCltFrm.DBEdtNBESSAIKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  NumberEditKeyPress(Key, False);
end;

procedure TDlgSiteCltFrm.DBEDT_CEGIDKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key=' ' then
    Key:=#0;
end;

procedure TDlgSiteCltFrm.DBEDT_NOMExit(Sender: TObject);
begin
  inherited;
  if (DsEmetteur.DataSet.State <> dsBrowse) and (DBC_TYPEREPLICATION.ItemIndex <> 0) and
     (DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString = '') then
    DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString:= DsEmetteur.DataSet.FieldByName('EMET_NOM').AsString;

end;

procedure TDlgSiteCltFrm.DBEDT_NOMKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key=' ' then
    Key:=#0;
end;

procedure TDlgSiteCltFrm.DBEDT_SENDERClick(Sender: TObject);
begin
  inherited;
  if (DsEmetteur.DataSet.State <> dsBrowse) and (DBC_TYPEREPLICATION.ItemIndex <> 0) and
     (DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString = '') then
    DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString:= DsEmetteur.DataSet.FieldByName('EMET_NOM').AsString;
end;

procedure TDlgSiteCltFrm.DBEDT_SENDERKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key=' ' then
    Key:=#0;
end;

procedure TDlgSiteCltFrm.DsEmetteurDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  FrameHeureReplic1.AEnabled:= DBCK_H1.Checked;
  FrameHeureReplic2.AEnabled:= DBCK_H2.Checked;
  GrpBxNONREPLICATION.Enabled:= DBCHK_NONREPLICATION.Checked;
  FrameHeureBackup.AEnabled:= CHK_FORCERBACKUP.Checked;
end;

procedure TDlgSiteCltFrm.EdtPlageDebChange(Sender: TObject);
begin
  inherited;
  if DsEmetteur.DataSet.State = dsBrowse then
    DsEmetteur.DataSet.Edit;
  DsEmetteur.DataSet.FieldByName('EMET_PLAGE').AsString:= Format(cPlage, [EdtPlageDeb.Text, EdtPlageFin.Text]);
end;

procedure TDlgSiteCltFrm.EdtPlageDebKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  NumberEditKeyPress(Key, False);
end;

procedure TDlgSiteCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
  TlBrFrameConnexion.ConfirmDelete:= True;

  DBEDT_IDENT.Color:= cxStyleRO.Color;
  DBEDT_PLAGE.Color:= cxStyleRO.Color;

  FrameHeureReplic1.Initialize;
  FrameHeureReplic2.Initialize;
  FrameHeureBackup.Initialize;
  HeureMinuteFrameRTRHeureDeb.Initialize;
  HeureMinuteFrameRTRHeureFin.Initialize;
  HeureMinuteFrameRWHeureDeb.Initialize;
  HeureMinuteFrameRWHeureFin.Initialize;
end;

procedure TDlgSiteCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsEmetteur.DataSet:= FdmClient.CDS_EMETTEUR;
  DsSrvSecours.DataSet:= FdmClient.CDS_SRVSECOURS;
  DsConnexion.DataSet:= FdmClient.CDS_GENCONNEXION;
  DsListRC.DataSet:= FdmClient.CDS_GENREPLICATION;
  DsListRW.DataSet:= FdmClient.CDS_GENREPLICATIONWEB;
  FdmClient.CDS_GENCONNEXION.EmptyDataSet;
  PgCtrlSite.ActivePageIndex:= 0;

  { Preparation de la liste des serveurs de secours }
  if AAction <> ukInsert then
    begin
      FdmClient.CDS_SRVSECOURS.Filtered:= False;
      FdmClient.CDS_SRVSECOURS.Filter:= '(EMET_ID <> ' + QuotedStr(FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsString) +
                                        ') and (EMET_NOM LIKE ''%' + cSuffSrvSec + ''')';
      FdmClient.CDS_SRVSECOURS.Filtered:= True;
    end;


  { Chargement de la liste des magasins du dossier }
  dmClients.XmlToList('Magasin?DOSS_ID=' + IntToStr(FdmClient.DOSS_ID), 'MAGA_NOM', 'MAGA_ID', CB_MAGPRINCIPAL.Items, Self);

  FVER_MAJEURE:= FdmClient.GetVersionMajeure(DsEmetteur.DataSet.FieldByName('VERS_VERSION').AsString);

  { Gestion de l'affichage des composants en fonction de la version majeure  }
  GestionAccessComponentVersion(FVER_MAJEURE);

  if AAction = ukModify then
    begin
      DsEmetteur.DataSet.Edit;
      CB_MAGPRINCIPAL.ItemIndex:= dmClients.IndexOfByID(DsEmetteur.DataSet.FieldByName('EMET_MAGID').AsInteger, CB_MAGPRINCIPAL.Items);

      if not DsEmetteur.DataSet.FieldByName('EMET_TYPEREPLICATION').IsNull then
        DBC_TYPEREPLICATION.ItemIndex:= DBC_TYPEREPLICATION.Items.IndexOf(DsEmetteur.DataSet.FieldByName('EMET_TYPEREPLICATION').AsString)
      else
        if (DsEmetteur.DataSet.FieldByName('EMET_IDENT').IsNull) or
           (DsEmetteur.DataSet.FieldByName('EMET_IDENT').AsInteger = 0) then
          begin
            DBC_TYPEREPLICATION.ItemIndex:= 0;
            DBC_TYPEREPLICATION.Enabled:= False;
          end;

      { Réplication Classique }
      DTP_DEBUTNONREPLICATION.Date:= DsEmetteur.DataSet.FieldByName('EMET_DEBUTNONREPLICATION').AsDateTime;
      DTP_FINNONREPLICATION.Date:= DsEmetteur.DataSet.FieldByName('EMET_FINNONREPLICATION').AsDateTime;

      if not DsEmetteur.DataSet.FieldByName('EMET_HEURE1').IsNull then
        begin
          FrameHeureReplic1.ATime:= DsEmetteur.DataSet.FieldByName('EMET_HEURE1').AsDateTime;
          if FrameHeureReplic1.ATime = 0 then
            FrameHeureReplic1.Reset:= True;
        end;

      if not DsEmetteur.DataSet.FieldByName('EMET_HEURE2').IsNull then
        begin
          FrameHeureReplic2.ATime:= DsEmetteur.DataSet.FieldByName('EMET_HEURE2').AsDateTime;
          if FrameHeureReplic2.ATime = 0 then
            FrameHeureReplic2.Reset:= True;
        end;

      { Options }
      CHK_FORCERBACKUP.Checked:= DsEmetteur.DataSet.FieldByName('LAU_BACK').AsInteger = 1;
      if CHK_FORCERBACKUP.Checked then
      begin
        FrameHeureBackup.ATime:= DsEmetteur.DataSet.FieldByName('LAU_BACKTIME').AsDateTime;
        if FrameHeureBackup.ATime = 0 then
          FrameHeureBackup.Reset:= True;
      end;
      CHK_AUTO.Checked:= DsEmetteur.DataSet.FieldByName('LAU_AUTORUN').AsInteger = 1;
      CHK_FORCEMAJ.Checked:= DsEmetteur.DataSet.FieldByName('PRM_POS').AsInteger = 1;

      { Réplic temps réel }
      if GrpBxReplicTempsReel.Enabled then
        begin
          if not DsEmetteur.DataSet.FieldByName('RTR_HEUREDEB').IsNull then
            begin
              HeureMinuteFrameRTRHeureDeb.ATime:= DsEmetteur.DataSet.FieldByName('RTR_HEUREDEB').AsDateTime;
              if HeureMinuteFrameRTRHeureDeb.ATime = 0 then
                HeureMinuteFrameRTRHeureDeb.Reset;
            end;

          if not DsEmetteur.DataSet.FieldByName('RTR_HEUREFIN').IsNull then
            begin
              HeureMinuteFrameRTRHeureFin.ATime:= DsEmetteur.DataSet.FieldByName('RTR_HEUREFIN').AsDateTime;
              if HeureMinuteFrameRTRHeureFin.ATime = 0 then
                HeureMinuteFrameRTRHeureFin.Reset;
            end;
        end;

       { Replic Web }
       if TbShtReplicWeb.Enabled then
         begin
           if not DsEmetteur.DataSet.FieldByName('RW_HEUREDEB').IsNull then
             begin
               HeureMinuteFrameRWHeureDeb.ATime:= DsEmetteur.DataSet.FieldByName('RW_HEUREDEB').AsDateTime;
               if HeureMinuteFrameRWHeureDeb.ATime = 0 then
                 HeureMinuteFrameRWHeureDeb.Reset;
             end;

           if not DsEmetteur.DataSet.FieldByName('RW_HEUREFIN').IsNull then
             begin
               HeureMinuteFrameRWHeureFin.ATime:= DsEmetteur.DataSet.FieldByName('RW_HEUREFIN').AsDateTime;
               if HeureMinuteFrameRWHeureFin.ATime = 0 then
                 HeureMinuteFrameRWHeureFin.Reset;
             end;

           ChkBxActiveWeb.Checked:= (HeureMinuteFrameRWHeureDeb.ATime <> 0) and
                                    (HeureMinuteFrameRWHeureFin.ATime <> 0) and
                                    (DBEdtRWINTERVAL.Field.AsInteger <> 0);
           ChkBxActiveWebClick(nil);
         end;

      { Chargement des replications Classique }
      ToolBarFrameListRC.ActRefresh.Execute;

      { Chargement des replications Web }
      if TbShtReplicWeb.Enabled then
        ToolBarFrameListRW.ActRefresh.Execute;
    end
  else
    if AAction = ukInsert then
      begin
        DsEmetteur.DataSet.Append;
        DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsInteger:= FdmClient.DOSS_ID;
        dmClients.XmlToDataSet('NewPlage?DOSS_ID=' + IntToStr(FdmClient.DOSS_ID), FdmClient.CDS_EMETTEUR, False, False, False);
        dmClients.XmlToDataSet('NewIdent?DOSS_ID=' + IntToStr(FdmClient.DOSS_ID), FdmClient.CDS_EMETTEUR, False, False, False);
        PgCtrlSite.Pages[PgCtrlSite.PageCount -1].TabVisible:= False;

        pnlListRC.Enabled:= False;
        TbShtReplicWeb.Enabled:= False;
        TbShtReplicLames.Enabled:= False;
      end;

  ExtractPlage;
end;

{===============================================================================
 Procedure     : GestionAccessComponentVersion
 Description   : Permet de gerer l'afficher des composants en fonction du
                 numéro de version majeure.
===============================================================================}
procedure TDlgSiteCltFrm.GestionAccessComponentVersion(Const AVER_MAJEURE: integer);
begin
  GrpBxReplicTempsReel.Enabled:= AVER_MAJEURE >= 12;
  if not GrpBxReplicTempsReel.Enabled then
    begin
      DBEdtNBESSAI.Color:= cxStyleRO.Color;
      DBEdtDELAI.Color:= cxStyleRO.Color;
      DBEdtURL.Color:= cxStyleRO.Color;
      DBEdtSender.Color:= cxStyleRO.Color;
      DBEdtDatabase.Color:= cxStyleRO.Color;
      HeureMinuteFrameRTRHeureDeb.AEnabled:= False;
      HeureMinuteFrameRTRHeureFin.AEnabled:= False;
    end;

  TbShtReplicWeb.Enabled:= AVER_MAJEURE >= 9;
end;

procedure TDlgSiteCltFrm.LoadConnexion;
begin
  if (FdmClient.CDS_EMETTEUR.FieldByName('EMET_DOSSID').AsInteger > 0) and
     (FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsInteger > 0) then
    dmClients.XmlToDataSet('Connexion?DOSS_ID=' + FdmClient.CDS_EMETTEUR.FieldByName('EMET_DOSSID').AsString +
                           '&EMET_ID=' + FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsString, FdmClient.CDS_GENCONNEXION);
end;

function TDlgSiteCltFrm.PostValues: Boolean;

  function GetSuffixeSrvSec(Const S: String): String;
  begin
    Result:= S;
    if Length(Result) > 3 then
      begin
        if Copy(Result, Length(Result)-3, 4) <> cSuffSrvSec then
          Result:= Result + cSuffSrvSec;
      end
    else
      Result:= Result + cSuffSrvSec;
  end;

begin
  Result:= inherited PostValues;
  try
    if (EdtPlageDeb.Text = '') or (EdtPlageFin.Text = '') then
      Raise Exception.Create('Les plages début et fin sont obligatoires.');

    if StrToInt(EdtPlageFin.Text) <= StrToInt(EdtPlageDeb.Text) then
      Raise Exception.Create('La plage de fin est inférieure ou égale à la plage de début.');

    if (DsEmetteur.DataSet.FieldByName('EMET_NOM').AsString = '') or
       (DsEmetteur.DataSet.FieldByName('EMET_JETON').AsString = '') or
       (EdtPlageDeb.Text = '') or (EdtPlageFin.Text = '') or
       (DsEmetteur.DataSet.FieldByName('EMET_TIERSCEGID').AsString = '') then
      begin
        MessageDlg('Les zones (Nom du site, Plage, Nb de jetons et code tiers) sont obligatoires.', mtInformation, [mbOk], 0);
        Exit;
      end;

    if (DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString = '') and
       (DBC_TYPEREPLICATION.ItemIndex <> 0) then
      begin
        MessageDlg('Les zones (Sender) est obligatoire.', mtInformation, [mbOk], 0);
        Exit;
      end;

    if DBC_TYPEREPLICATION.ItemIndex = 2 then
    begin
      DsEmetteur.DataSet.FieldByName('EMET_NOM').AsString:= GetSuffixeSrvSec(DsEmetteur.DataSet.FieldByName('EMET_NOM').AsString);
      DsEmetteur.DataSet.FieldByName('BAS_NOM').AsString:= GetSuffixeSrvSec(DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString);       //SR - 18/02/2014 : Ajout pour prise en compte modification
      DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString:= GetSuffixeSrvSec(DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString);
    end
    else
      DsEmetteur.DataSet.FieldByName('BAS_NOM').AsString:= DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString;       //SR - 10/03/2014 : Ajout pour prise en compte modification

    if CB_MAGPRINCIPAL.ItemIndex <> -1 then
      DsEmetteur.DataSet.FieldByName('EMET_MAGID').AsInteger:= TGenerique(CB_MAGPRINCIPAL.Items.Objects[CB_MAGPRINCIPAL.ItemIndex]).ID
    else
      DsEmetteur.DataSet.FieldByName('EMET_MAGID').Value:= null;

    DsEmetteur.DataSet.FieldByName('EMET_DEBUTNONREPLICATION').AsDateTime:= DTP_DEBUTNONREPLICATION.Date;
    DsEmetteur.DataSet.FieldByName('EMET_FINNONREPLICATION').AsDateTime:= DTP_FINNONREPLICATION.Date;

    DsEmetteur.DataSet.FieldByName('EMET_HEURE1').AsDateTime:= FrameHeureReplic1.ATime;
    DsEmetteur.DataSet.FieldByName('EMET_HEURE2').AsDateTime:= FrameHeureReplic2.ATime;

    DsEmetteur.DataSet.FieldByName('LAU_BACK').AsInteger:= Integer(CHK_FORCERBACKUP.Checked);
    if CHK_FORCERBACKUP.Checked then
      DsEmetteur.DataSet.FieldByName('LAU_BACKTIME').AsDateTime:= FrameHeureBackup.ATime;
    DsEmetteur.DataSet.FieldByName('LAU_AUTORUN').AsInteger:= Integer(CHK_AUTO.Checked);
    DsEmetteur.DataSet.FieldByName('PRM_POS').AsInteger:= Integer(CHK_FORCEMAJ.Checked);

    if GrpBxReplicTempsReel.Enabled then
      begin
        DsEmetteur.DataSet.FieldByName('RTR_HEUREDEB').AsDateTime:= HeureMinuteFrameRTRHeureDeb.ATime;
        DsEmetteur.DataSet.FieldByName('RTR_HEUREFIN').AsDateTime:= HeureMinuteFrameRTRHeureFin.ATime;
      end;

    if TbShtReplicWeb.Enabled then
      begin
        DsEmetteur.DataSet.FieldByName('RW_HEUREDEB').AsDateTime:= HeureMinuteFrameRWHeureDeb.ATime;
        DsEmetteur.DataSet.FieldByName('RW_HEUREFIN').AsDateTime:= HeureMinuteFrameRWHeureDeb.ATime;
      end;

    dmClients.PostRecordToXml('Emetteur', 'TEmetteur', FdmClient.CDS_EMETTEUR);
    DsEmetteur.DataSet.Post;
    Result:= True;
  except
    Raise;
  end;
end;

procedure TDlgSiteCltFrm.ShowDetailConnexion(const AAction: TUpdateKind);
var
  vDlgConCltFrm: TDlgConnexionCltFrm;
begin
  if AAction = ukDelete then
    begin
      dmClients.DeleteRecordByRessource('Connexion?EMET_ID=' + FdmClient.CDS_GENCONNEXION.FieldByName('EMET_ID').AsString +
                                        '&CON_ID=' + FdmClient.CDS_GENCONNEXION.FieldByName('CON_ID').AsString);
      FdmClient.CDS_GENCONNEXION.Delete;
      Exit;
    end;

  vDlgConCltFrm:= TDlgConnexionCltFrm.Create(nil);
  try
    vDlgConCltFrm.Caption:= 'Connexion (' + FdmClient.CDS_EMETTEUR.FieldByName('EMET_NOM').AsString + ')';
    vDlgConCltFrm.AAction:= AAction;
    vDlgConCltFrm.AdmClient:= FdmClient;

    if AAction = ukInsert then
      begin
        FdmClient.CDS_GENCONNEXION.Append;
        FdmClient.CDS_GENCONNEXION.FieldByName('DOSS_ID').AsInteger:= FdmClient.CDS_EMETTEUR.FieldByName('EMET_DOSSID').AsInteger;
        FdmClient.CDS_GENCONNEXION.FieldByName('EMET_ID').AsInteger:= FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsInteger;
      end;

    if vDlgConCltFrm.ShowModal = mrOk then
      begin
        //-->
      end
    else
      if vDlgConCltFrm.DsConnexion.DataSet.State <> dsBrowse then
        vDlgConCltFrm.DsConnexion.DataSet.Cancel;
  finally
    FreeAndNil(vDlgConCltFrm);
    GIsBrowse:= False;
  end;
end;

procedure TDlgSiteCltFrm.ShowDetailReplication(const AAction: TUpdateKind);
var
  vDlgParamReplicFrm: TDlgParamReplicFrm;
begin
  if AAction in[ukModify, ukDelete] then
    begin
      if PgCtrlSite.ActivePage.Name = 'TbShtReplicLames' then
        begin
          if FdmClient.CDS_GENREPLICATION.RecordCount = 0 then
            Exit;
        end
      else
        if PgCtrlSite.ActivePage.Name = 'TbShtReplicWeb' then
          begin
            if FdmClient.CDS_GENREPLICATIONWEB.RecordCount = 0 then
              Exit;
          end;
    end;

  vDlgParamReplicFrm:= TDlgParamReplicFrm.Create(nil);
  try
    vDlgParamReplicFrm.AAction:= AAction;
    vDlgParamReplicFrm.AdmClient:= AdmClient;

    if PgCtrlSite.ActivePage.Name = 'TbShtReplicLames' then
      vDlgParamReplicFrm.DsGenReplication.DataSet:= FdmClient.CDS_GENREPLICATION
    else
      if PgCtrlSite.ActivePage.Name = 'TbShtReplicWeb' then
        vDlgParamReplicFrm.DsGenReplication.DataSet:= FdmClient.CDS_GENREPLICATIONWEB;

    if AAction = ukDelete then
      begin
        dmClients.DeleteRecordByRessource('GenSubscribersGenReplication?DOSS_ID=' +  vDlgParamReplicFrm.DsGenReplication.DataSet.FieldByName('DOSS_ID').AsString +
                                          '&LAUID=' +  vDlgParamReplicFrm.DsGenReplication.DataSet.FieldByName('LAU_ID').AsString);
        FdmClient.CDS_GENREPLICATION.Delete;
        Exit;
      end
    else
      if AAction = ukInsert then
        vDlgParamReplicFrm.DsGenReplication.DataSet.Insert;

    vDlgParamReplicFrm.Gbx_ReplicJour.Visible:= FVER_MAJEURE >= 12;
    vDlgParamReplicFrm.Gbx_EXEFinReplic.Visible:= FVER_MAJEURE >= 12;

    if vDlgParamReplicFrm.ShowModal = mrOk then
      begin
        if PgCtrlSite.ActivePage.Name = 'TbShtReplicLames' then
          ToolBarFrameListRC.ActRefresh.Execute
        else
          if PgCtrlSite.ActivePage.Name = 'TbShtReplicWeb' then
            ToolBarFrameListRW.ActRefresh.Execute;
      end
    else
      vDlgParamReplicFrm.DsGenReplication.DataSet.Cancel;
  finally
    FreeAndNil(vDlgParamReplicFrm);
    GIsBrowse:= False;
  end;
end;

procedure TDlgSiteCltFrm.TbShtConnexionShow(Sender: TObject);
begin
  inherited;
  if (FdmClient.CDS_GENCONNEXION.RecordCount = 0) and (AAction <> ukInsert) and
     (FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsInteger > 0) then
    LoadConnexion;
end;

procedure TDlgSiteCltFrm.TlBrFrameConnexionActDeleteExecute(Sender: TObject);
begin
  inherited;
  TlBrFrameConnexion.ActDeleteExecute(Sender);
  ShowDetailConnexion(ukDelete);
end;

procedure TDlgSiteCltFrm.TlBrFrameConnexionActInsertExecute(Sender: TObject);
begin
  inherited;
  ShowDetailConnexion(ukInsert);
end;

procedure TDlgSiteCltFrm.TlBrFrameConnexionActUpdateExecute(Sender: TObject);
begin
  inherited;
  ShowDetailConnexion(ukModify);
end;

procedure TDlgSiteCltFrm.ToolBarFrameListRCActDeleteExecute(Sender: TObject);
begin
  inherited;
  ToolBarFrameListRC.ActDeleteExecute(Sender);
  ShowDetailReplication(ukDelete);
end;

procedure TDlgSiteCltFrm.ToolBarFrameListRCActInsertExecute(Sender: TObject);
begin
  inherited;
  ShowDetailReplication(ukInsert);
end;

procedure TDlgSiteCltFrm.ToolBarFrameListRCActRefreshExecute(Sender: TObject);
begin
  inherited;
  if (DsEmetteur.DataSet.RecordCount <> 0) and (DsEmetteur.DataSet.FieldByName('LAU_ID').AsInteger > 0) then
    dmClients.XmlToDataSet('GenReplication?DOSS_ID=' + DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                           '&LAUID=' + DsEmetteur.DataSet.FieldByName('LAU_ID').AsString +
                           '&REPLICWEB=0', FdmClient.CDS_GENREPLICATION);
end;

procedure TDlgSiteCltFrm.ToolBarFrameListRCActUpdateExecute(Sender: TObject);
begin
  inherited;
  ShowDetailReplication(ukModify);
end;

procedure TDlgSiteCltFrm.ToolBarFrameListRWActRefreshExecute(Sender: TObject);
begin
  inherited;
  if (DsEmetteur.DataSet.RecordCount <> 0) and (DsEmetteur.DataSet.FieldByName('LAU_ID').AsInteger > 0) then
    dmClients.XmlToDataSet('GenReplication?DOSS_ID=' + DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                           '&LAUID=' + DsEmetteur.DataSet.FieldByName('LAU_ID').AsString +
                           '&REPLICWEB=1', FdmClient.CDS_GENREPLICATIONWEB);
end;

procedure TDlgSiteCltFrm.UpDownFramReplicLamesSpdBtnDownClick(Sender: TObject);
begin
  inherited;
  if PgCtrlSite.ActivePage.Name = 'TbShtReplicLames' then
    begin
      dmClients.MoveOrdre(False, FdmClient.CDS_GENREPLICATION, 'REP_ORDRE', 'GenReplication', 'TGnkGenReplication');
      ToolBarFrameListRC.ActRefresh.Execute;
    end
  else
    if PgCtrlSite.ActivePage.Name = 'TbShtReplicWeb' then
      begin
        dmClients.MoveOrdre(False, FdmClient.CDS_GENREPLICATIONWEB, 'REP_ORDRE', 'GenReplication', 'TGnkGenReplication');
        ToolBarFrameListRW.ActRefresh.Execute;
      end;
end;

procedure TDlgSiteCltFrm.UpDownFramReplicLamesSpdBtnUpClick(Sender: TObject);
begin
  inherited;
  if PgCtrlSite.ActivePage.Name = 'TbShtReplicLames' then
    begin
      dmClients.MoveOrdre(True, FdmClient.CDS_GENREPLICATION, 'REP_ORDRE', 'GenReplication', 'TGnkGenReplication');
      ToolBarFrameListRC.ActRefresh.Execute;
    end
  else
    if PgCtrlSite.ActivePage.Name = 'TbShtReplicWeb' then
      begin
        dmClients.MoveOrdre(True, FdmClient.CDS_GENREPLICATIONWEB, 'REP_ORDRE', 'GenReplication', 'TGnkGenReplication');
        ToolBarFrameListRW.ActRefresh.Execute;
      end;
end;

end.



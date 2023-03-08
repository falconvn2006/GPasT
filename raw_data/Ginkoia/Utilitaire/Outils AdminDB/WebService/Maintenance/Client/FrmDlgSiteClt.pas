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
  FrameToolBar;


type
  TDlgSiteCltFrm = class(TCustomGinkoiaDlgFrm)
    PgCtrlSite: TcxPageControl;
    TbShtInfoGen: TcxTabSheet;
    TbShtHoraireRep: TcxTabSheet;
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
    DBCK_H1: TDBCheckBox;
    DBCK_H2: TDBCheckBox;
    CHK_FORCERBACKUP: TCheckBox;
    DsEmetteur: TDataSource;
    DBEDT_SENDER: TDBEdit;
    DsSrvSecours: TDataSource;
    GrpBxH1: TGroupBox;
    Lab_5: TLabel;
    GrpBxH2: TGroupBox;
    Lab_6: TLabel;
    GrpBxForceBackup: TGroupBox;
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
    FrameHeureReplic2: THeureMinuteFrame;
    FrameHeureBackup: THeureMinuteFrame;
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
  private
    FdmClient: TdmClient;
    procedure ExtractPlage;

    procedure LoadConnexion;
    procedure ShowDetailConnexion(const AAction: TUpdateKind);
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
  end;

var
  DlgSiteCltFrm: TDlgSiteCltFrm;

implementation

uses dmdClients, uTool, uConst, FrmDlgConnexionClt;

{$R *.dfm}

procedure TDlgSiteCltFrm.CB_MAGPRINCIPALKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_DELETE then
    CB_MAGPRINCIPAL.ItemIndex:= -1;
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

procedure TDlgSiteCltFrm.DBEDT_NOMExit(Sender: TObject);
begin
  inherited;
  if (DsEmetteur.DataSet.State <> dsBrowse) and (DBC_TYPEREPLICATION.ItemIndex <> 0) and
     (DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString = '') then
    DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString:= DsEmetteur.DataSet.FieldByName('EMET_NOM').AsString;
end;

procedure TDlgSiteCltFrm.DsEmetteurDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  GrpBxH1.Enabled:= DBCK_H1.Checked;
  GrpBxH2.Enabled:= DBCK_H2.Checked;
  GrpBxNONREPLICATION.Enabled:= DBCHK_NONREPLICATION.Checked;
  GrpBxForceBackup.Enabled:= CHK_FORCERBACKUP.Checked;
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
  FrameHeureReplic1.Initialize;
  FrameHeureReplic2.Initialize;
  FrameHeureBackup.Initialize;
end;

procedure TDlgSiteCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsEmetteur.DataSet:= FdmClient.CDS_EMETTEUR;
  DsSrvSecours.DataSet:= FdmClient.CDS_SRVSECOURS;
  DsConnexion.DataSet:= FdmClient.CDS_GENCONNEXION;
  FdmClient.CDS_GENCONNEXION.EmptyDataSet;
  PgCtrlSite.ActivePageIndex:= 0;

  { Preparation de la liste des serveurs de secours }
  FdmClient.CDS_SRVSECOURS.Filtered:= False;
  FdmClient.CDS_SRVSECOURS.Filter:= '(EMET_ID <> ' + FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsString +
                                    ') and (EMET_NOM LIKE ''%' + cSuffSrvSec + ''')';
  FdmClient.CDS_SRVSECOURS.Filtered:= True;

  { Chargement de la liste des magasins du dossier }
  dmClients.XmlToList('Magasin?DOS_ID=' + IntToStr(FdmClient.DOS_ID), 'MAG_NOM', 'MAG_ID', CB_MAGPRINCIPAL.Items, Self);

  if AAction = ukModify then
    begin
      DsEmetteur.DataSet.Edit;
      CB_MAGPRINCIPAL.ItemIndex:= dmClients.IndexOfByID(DsEmetteur.DataSet.FieldByName('EMET_MAGID').AsInteger, CB_MAGPRINCIPAL.Items);

      if not DsEmetteur.DataSet.FieldByName('EMET_TYPEREPLICATION').IsNull then
        DBC_TYPEREPLICATION.ItemIndex:= DBC_TYPEREPLICATION.Items.IndexOf(DsEmetteur.DataSet.FieldByName('EMET_TYPEREPLICATION').AsString)
      else
        if DsEmetteur.DataSet.FieldByName('EMET_IDENT').AsInteger = 0 then
          begin
            DBC_TYPEREPLICATION.ItemIndex:= 0;
            DBC_TYPEREPLICATION.Enabled:= False;
          end;

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

      CHK_FORCERBACKUP.Checked:= DsEmetteur.DataSet.FieldByName('LAU_BACK').AsInteger = 1;
      if CHK_FORCERBACKUP.Checked then
        FrameHeureBackup.ATime:= DsEmetteur.DataSet.FieldByName('LAU_BACKTIME').AsDateTime;
      CHK_AUTO.Checked:= DsEmetteur.DataSet.FieldByName('LAU_AUTORUN').AsInteger = 1;
      CHK_FORCEMAJ.Checked:= DsEmetteur.DataSet.FieldByName('PRM_POS').AsInteger = 1;
    end
  else
    if AAction = ukInsert then
      begin
        DsEmetteur.DataSet.Append;
        DsEmetteur.DataSet.FieldByName('DOS_ID').AsInteger:= FdmClient.DOS_ID;
        dmClients.XmlToDataSet('NewPlage?DOS_ID=' + IntToStr(FdmClient.DOS_ID), FdmClient.CDS_EMETTEUR, False, False, False);
        dmClients.XmlToDataSet('NewIdent?DOS_ID=' + IntToStr(FdmClient.DOS_ID), FdmClient.CDS_EMETTEUR, False, False, False);
        PgCtrlSite.Pages[PgCtrlSite.PageCount -1].TabVisible:= False;
      end;
  ExtractPlage;
end;

procedure TDlgSiteCltFrm.LoadConnexion;
begin
  if (FdmClient.CDS_EMETTEUR.FieldByName('DOS_ID').AsInteger > 0) and
     (FdmClient.CDS_EMETTEUR.FieldByName('EMET_ID').AsInteger > 0) then
    dmClients.XmlToDataSet('Connexion?DOS_ID=' + FdmClient.CDS_EMETTEUR.FieldByName('DOS_ID').AsString +
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
       (EdtPlageDeb.Text = '') or (EdtPlageFin.Text = '') then
      begin
        MessageDlg('Les zones (Nom du site, Plage et Nb de jetons) sont obligatoires.', mtInformation, [mbOk], 0);
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
        DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString:= GetSuffixeSrvSec(DsEmetteur.DataSet.FieldByName('BAS_SENDER').AsString);
      end;

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
        FdmClient.CDS_GENCONNEXION.FieldByName('DOS_ID').AsInteger:= FdmClient.CDS_EMETTEUR.FieldByName('DOS_ID').AsInteger;
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

end.

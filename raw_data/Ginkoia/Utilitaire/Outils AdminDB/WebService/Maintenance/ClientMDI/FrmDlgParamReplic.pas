unit FrmDlgParamReplic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPC, StdCtrls, Mask,
  DBCtrls, Buttons, ExtCtrls, AdvOfficeButtons, DBAdvOfficeButtons,
  AdvDirectoryEdit, AdvEdBtn, AdvFileNameEdit, AdvEdit, DBAdvEd, FrameToolBar,
  FramParamReplic, DB, dmdClient, DBClient, cxClasses, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxStyles;



type
  TStatutPkg = (spDispo, spTraite);
  TStatutsPkg = Set of TStatutPkg;

  TDlgParamReplicFrm = class(TCustomGinkoiaDlgFrm)
    pnlTop: TPanel;
    Lab_14: TLabel;
    DBEDT_NOM: TDBEdit;
    cxPgCtrlParamReplic: TcxPageControl;
    TbShtParametre: TcxTabSheet;
    TbShtProviders: TcxTabSheet;
    TbShtSubscription: TcxTabSheet;
    Gbx_URL: TGroupBox;
    Lab_URLLocale: TLabel;
    Lab_URLDistante: TLabel;
    Lab_User: TLabel;
    Lab_Password: TLabel;
    BtnTestUrlL: TButton;
    BtnTestUrlD: TButton;
    Gbx_Ordres: TGroupBox;
    Lab_Ping: TLabel;
    Lab_Push: TLabel;
    Lab_Pull: TLabel;
    Gbx_Chemins: TGroupBox;
    Lab_Eai: TLabel;
    Lab_Base: TLabel;
    Gbx_ReplicJour: TGroupBox;
    Gbx_EXEFinReplic: TGroupBox;
    Lab_ExecFinReplic: TLabel;
    DBEdtUrlLocale: TDBEdit;
    DBEdtUrlDistante: TDBEdit;
    DBEdtUser: TDBEdit;
    DBEdtPassword: TDBEdit;
    DBEdtPing: TDBEdit;
    DBEdtPush: TDBEdit;
    DBEdtPull: TDBEdit;
    DBEdtPlaceEAI: TDBEdit;
    DBEdtPlaceBase: TDBEdit;
    OpenDlg: TOpenDialog;
    DBChkBxReplicJourneeActive: TDBCheckBox;
    DBEdtExecFinReplic: TDBEdit;
    ParamReplicFramProviders: TParamReplicFram;
    ParamReplicFramSubscribers: TParamReplicFram;
    SpdBtnPlaceEAI: TSpeedButton;
    SpdBtnPlaceBase: TSpeedButton;
    SpdBtnExecFinReplic: TSpeedButton;
    DsGenReplication: TDataSource;
    DsEmetteur: TDataSource;
    cxStyleRepository: TcxStyleRepository;
    cxStyleRO: TcxStyle;
    cxStyleDefault: TcxStyle;
    procedure FormShow(Sender: TObject);
    procedure ToolBarFrameDispoActRefreshExecute(Sender: TObject);
    procedure UpDownFramDispoSpdBtnUpClick(Sender: TObject);
    procedure UpDownFramDispoSpdBtnDownClick(Sender: TObject);
    procedure ToolBarFrameDispoActInsertExecute(Sender: TObject);
    procedure SpdBtnPlaceEAIClick(Sender: TObject);
    procedure SpdBtnPlaceBaseClick(Sender: TObject);
    procedure SpdBtnExecFinReplicClick(Sender: TObject);
    procedure ToolBarFrameDispoActUpdateExecute(Sender: TObject);
    procedure ToolBarFrameDispoActDeleteExecute(Sender: TObject);
    procedure ParamReplicFramProviderscxGridDBTableViewListDispoStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure ParamReplicFramSubscriberscxGridDBTableViewListDispoStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure ParamReplicFramProvidersSpdBtnAllDisableClick(Sender: TObject);
    procedure ParamReplicFramProvidersSpdBtnAllEnableClick(Sender: TObject);
    procedure ParamReplicFramProvidersSpdBtnDisableClick(Sender: TObject);
    procedure ParamReplicFramProvidersSpdBtnEnableClick(Sender: TObject);
    procedure ParamReplicFramProvidersSpdBtnTraiteLoopEnabledClick(
      Sender: TObject);
    procedure ParamReplicFramProvidersSpdBtnTraiteLoopDisabledClick(
      Sender: TObject);
    procedure BtnTestUrlLClick(Sender: TObject);
    procedure BtnTestUrlDClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FdmClient: TdmClient;

    procedure RefreshProviders(Const AStatutsPkg: TStatutsPkg);
    procedure RefreshSubscribers(Const AStatutsPkg: TStatutsPkg);

    procedure PackageProSub(Const AStatutPkg: TStatutPkg; Const AIsAll: Boolean = False);
    procedure StepLoop(Const AActive: Boolean);

    function CheckUrl(Const AUrl: String): Boolean;
    procedure TestUrlLocale;
    procedure TestUrlDistante;

    procedure ShowDetailProSub(const AAction: TUpdateKind);
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
  end;

var
  DlgParamReplicFrm: TDlgParamReplicFrm;

implementation

uses dmdClients, FrmDlgProvidersSubscribers, uTool, uConst, IdHTTP;

{$R *.dfm}

{ TDlgParamReplicFrm }

procedure TDlgParamReplicFrm.BtnTestUrlDClick(Sender: TObject);
begin
  inherited;
  TestUrlDistante;
end;

procedure TDlgParamReplicFrm.BtnTestUrlLClick(Sender: TObject);
begin
  inherited;
  TestUrlLocale;
end;

function TDlgParamReplicFrm.CheckUrl(const AUrl: String): Boolean;
var
 vIdHTTP: TIdHTTP;
 vSL: TStrings;
 Buffer: String;
begin
  Result:= False;
  vIdHTTP:= dmClients.GetNewIdHTTP(nil);
  vSL:= TStringList.Create;
  try
    vSL.Add('Caller=TOTO');
    vSL.Add('Provider=TATA');

    Buffer:= vIdHTTP.Post(AUrl, vSL);

    Result:= Copy(Buffer,1,4) = 'PONG';
  finally
    FreeAndNil(vIdHTTP);
    FreeAndNil(vSL);
  end;
end;

procedure TDlgParamReplicFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
end;

procedure TDlgParamReplicFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsEmetteur.DataSet:= FdmClient.CDS_EMETTEUR;
  ParamReplicFramProviders.DsListDispo.DataSet:= FdmClient.CDS_GENPROVIDERS_D;
  ParamReplicFramProviders.DsListTraite.DataSet:= FdmClient.CDS_GENPROVIDERS_T;
  ParamReplicFramSubscribers.DsListDispo.DataSet:= FdmClient.CDS_GENSUBSCRIBERS_D;
  ParamReplicFramSubscribers.DsListTraite.DataSet:= FdmClient.CDS_GENSUBSCRIBERS_T;

  ParamReplicFramProviders.cxGridDBTableViewListDispo.DataController.CreateAllItems;
  ParamReplicFramProviders.cxGridDBTableViewListTraite.DataController.CreateAllItems;
  ParamReplicFramSubscribers.cxGridDBTableViewListDispo.DataController.CreateAllItems;
  ParamReplicFramSubscribers.cxGridDBTableViewListTraite.DataController.CreateAllItems;

  TbShtProviders.TabVisible:= AAction <> ukInsert;
  TbShtSubscription.TabVisible:= AAction <> ukInsert;

  if AAction = ukModify then
    begin
      RefreshProviders([spDispo, spTraite]);
      RefreshSubscribers([spDispo, spTraite]);
    end;

end;

procedure TDlgParamReplicFrm.ShowDetailProSub(const AAction: TUpdateKind);
var
  vDlgProvidersSubscribersFrm: TDlgProvidersSubscribersFrm;
begin
  vDlgProvidersSubscribersFrm:= TDlgProvidersSubscribersFrm.Create(nil);
  try
    vDlgProvidersSubscribersFrm.AAction:= AAction;
    vDlgProvidersSubscribersFrm.AdmClient:= FdmClient;

    if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtProviders' then
      vDlgProvidersSubscribersFrm.ATypeProSub:= tpsPRO
    else
      if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtSubscription' then
        vDlgProvidersSubscribersFrm.ATypeProSub:= tpsSUB;

    if AAction = ukDelete then
      begin
        if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtProviders' then
          dmClients.DeleteRecordByRessource('GenProviders?DOSS_ID=' +  DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                                            '&PRO_ID=' +  vDlgProvidersSubscribersFrm.DsPROSUB.DataSet.FieldByName('PRO_ID').AsString)
        else
          if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtSubscription' then
            dmClients.DeleteRecordByRessource('GenSubscribers?DOSS_ID=' +  DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                                            '&SUB_ID=' +  vDlgProvidersSubscribersFrm.DsPROSUB.DataSet.FieldByName('SUB_ID').AsString);

        vDlgProvidersSubscribersFrm.DsPROSUB.DataSet.Delete;
        Exit;
      end
    else
      if AAction = ukInsert then
        vDlgProvidersSubscribersFrm.DsPROSUB.DataSet.Insert;

    if vDlgProvidersSubscribersFrm.ShowModal = mrOk then
      begin
        if AAction = ukInsert then
          begin
            if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtProviders' then
              RefreshProviders([spDispo])
            else
              if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtSubscription' then
                RefreshSubscribers([spDispo]);
          end;
      end
    else
      vDlgProvidersSubscribersFrm.DsPROSUB.DataSet.Cancel;
  finally
    FreeAndNil(vDlgProvidersSubscribersFrm);
    GIsBrowse:= False;
  end;
end;

procedure TDlgParamReplicFrm.TestUrlDistante;
begin
  if CheckUrl(DBEdtUrlDistante.Field.AsString + DBEdtPing.Field.AsString) then
    MessageDlg('Ping distant réussi', mtInformation, [mbOK], 0)
  else
    MessageDlg('Ping distant échoué', mtInformation, [mbOK], 0);
end;

procedure TDlgParamReplicFrm.TestUrlLocale;
var
  vResulCode: integer;
  vResultMsg: String;
begin
  try
    vResulCode:= WinExec(PAnsiChar(DBEdtPlaceEAI.Field.AsString + 'Delos_QpmAgent.exe'), 0);
    if vResulCode > 31 then
      begin
        try
          Sleep(1000);

          if CheckUrl(DBEdtUrlLocale.Field.AsString + DBEdtPing.Field.AsString) then
            MessageDlg('Ping local réussi', mtInformation, [mbOK], 0)
          else
            MessageDlg('Ping local échoué', mtInformation, [mbOK], 0);
        finally
          IsApplicationRUN('Delos_QpmAgent.exe', True);
        end;
      end
    else
      begin
        case vResulCode of
          ERROR_BAD_FORMAT: MessageDlg('Fichier DelosQPMAgent.exe endommagé', mtInformation, [mbOK], 0);
          ERROR_FILE_NOT_FOUND: MessageDlg('Fichier DelosQPMAgent.exe introuvable', mtInformation, [mbOK], 0);
          ERROR_PATH_NOT_FOUND: MessageDlg('Chemin DelosQPMAgent.exe inconnu', mtInformation, [mbOK], 0);
        else
          MessageDlg('Erreur DelosQPMAgent', mtError, [mbOK], 0);
        end;
      end;
  except
    on E: Exception do
      Raise Exception.Create('Echec de lancement de QPMAgent' + cRC + E.Message);
  end;
end;

procedure TDlgParamReplicFrm.ToolBarFrameDispoActDeleteExecute(Sender: TObject);
begin
  inherited;
  ShowDetailProSub(ukDelete);
end;

procedure TDlgParamReplicFrm.ToolBarFrameDispoActInsertExecute(Sender: TObject);
begin
  inherited;
  ShowDetailProSub(ukInsert);
end;

procedure TDlgParamReplicFrm.ToolBarFrameDispoActRefreshExecute(
  Sender: TObject);
begin
  inherited;
  if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtProviders' then
    RefreshProviders([spDispo, spTraite])
  else
    if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtSubscription' then
      RefreshSubscribers([spDispo, spTraite]);
end;

procedure TDlgParamReplicFrm.ToolBarFrameDispoActUpdateExecute(Sender: TObject);
begin
  inherited;
  ShowDetailProSub(ukModify);
end;

procedure TDlgParamReplicFrm.UpDownFramDispoSpdBtnDownClick(Sender: TObject);
begin
  inherited;
  if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtProviders' then
    dmClients.MoveOrdre(False, FdmClient.CDS_GENPROVIDERS_D, 'PRO_ORDRE', 'GenProviders', 'TGnkGenProviders')
  else
    if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtSubscription' then
      dmClients.MoveOrdre(False, FdmClient.CDS_GENSUBSCRIBERS_D, 'SUB_ORDRE', 'GenSubscribers', 'TGnkGenSubscribers');
end;

procedure TDlgParamReplicFrm.UpDownFramDispoSpdBtnUpClick(Sender: TObject);
begin
  inherited;
  if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtProviders' then
    dmClients.MoveOrdre(True, FdmClient.CDS_GENPROVIDERS_D, 'PRO_ORDRE', 'GenProviders', 'TGnkGenProviders')
  else
    if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtSubscription' then
      dmClients.MoveOrdre(True, FdmClient.CDS_GENSUBSCRIBERS_D, 'SUB_ORDRE', 'GenSubscribers', 'TGnkGenSubscribers');
end;

procedure TDlgParamReplicFrm.SpdBtnExecFinReplicClick(Sender: TObject);
begin
  inherited;
  OpenDlg.DefaultExt:= '*.exe';
  OpenDlg.Filter:= 'Executable (*.exe)|*.exe';
  OpenDlg.InitialDir:= ExtractFilePath(DBEdtExecFinReplic.Field.AsString);
  OpenDlg.FileName:= ExtractFileName(DBEdtExecFinReplic.Field.AsString);
  if OpenDlg.Execute(Handle) then
    DBEdtExecFinReplic.Field.AsString:= OpenDlg.FileName;
end;

procedure TDlgParamReplicFrm.SpdBtnPlaceBaseClick(Sender: TObject);
begin
  inherited;
  OpenDlg.DefaultExt:= '';
  OpenDlg.Filter:= '';
  OpenDlg.InitialDir:= ExtractFilePath(DBEdtPlaceBase.Field.AsString);
  OpenDlg.FileName:= ExtractFileName(DBEdtPlaceBase.Field.AsString);
  if OpenDlg.Execute(Handle) then
    DBEdtPlaceBase.Field.AsString:= OpenDlg.FileName;
end;

procedure TDlgParamReplicFrm.SpdBtnPlaceEAIClick(Sender: TObject);
var
  Buffer: String;
begin
  inherited;
  Buffer:= DBEdtPlaceEAI.Field.AsString;
  if GetBoxFolder(Handle, Buffer, Lab_Eai.Caption, True) then
    DBEdtPlaceEAI.Field.AsString:= Buffer;
end;

procedure TDlgParamReplicFrm.StepLoop(const AActive: Boolean);
var
  vStepLoop: integer;
begin
  try
    if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtProviders' then
      begin
        if ParamReplicFramProviders.DsListTraite.DataSet.RecordCount = 0 then
          Exit;

        vStepLoop:= 0;
        if AActive then
          vStepLoop:= StrToInt(ParamReplicFramProviders.EdtStepLoop.Text);

        ParamReplicFramProviders.DsListTraite.DataSet.Edit;
        ParamReplicFramProviders.DsListTraite.DataSet.FieldByName('PRO_LOOP').AsInteger:= vStepLoop;
        ParamReplicFramProviders.DsListTraite.DataSet.FieldByName('DOSS_ID').AsInteger:= DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsInteger;

        dmClients.PostRecordToXml('GenProviders', 'TGnkGenProviders', TClientDataSet(ParamReplicFramProviders.DsListTraite.DataSet));
        ParamReplicFramProviders.DsListTraite.DataSet.Post;
      end
    else
      if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtSubscription' then
        begin
          if ParamReplicFramSubscribers.DsListTraite.DataSet.RecordCount = 0 then
            Exit;

          vStepLoop:= 0;
          if AActive then
            vStepLoop:= StrToInt(ParamReplicFramSubscribers.EdtStepLoop.Text);

          ParamReplicFramSubscribers.DsListTraite.DataSet.Edit;
          ParamReplicFramSubscribers.DsListTraite.DataSet.FieldByName('SUB_LOOP').AsInteger:= vStepLoop;
          ParamReplicFramSubscribers.DsListTraite.DataSet.FieldByName('DOSS_ID').AsInteger:= DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsInteger;

          dmClients.PostRecordToXml('GenSubscribers', 'TGnkGenSubscribers', TClientDataSet(ParamReplicFramSubscribers.DsListTraite.DataSet));
          ParamReplicFramSubscribers.DsListTraite.DataSet.Post;
        end;
  except
    if ParamReplicFramProviders.DsListTraite.DataSet.State = dsEdit then
      ParamReplicFramProviders.DsListTraite.DataSet.Cancel;

    if ParamReplicFramSubscribers.DsListTraite.DataSet.State = dsEdit then
      ParamReplicFramSubscribers.DsListTraite.DataSet.Cancel;

    Raise;
  end;
end;

{===============================================================================
 Procedure     : PackageProSub
 Description   : Permet d'activer ou de desactiver des packages PRO ou SUB en
                 fonction de l'onglet actif.
 Parametres
   - AStatutPkg : Permet de definir l'activation ([spTraite])
                  ou la desactivation ([spDispo]).
   - AIsAll     : Permet de prendre en compte tous les élements de la liste à
                  traiter. La valeur par defaut "False";

 INFO           : La gestion de la selection multiple est supportée si le
                  parametre AIsAll est "False".
===============================================================================}
procedure TDlgParamReplicFrm.PackageProSub(const AStatutPkg: TStatutPkg;
  const AIsAll: Boolean);

  procedure SetDispoByCxGridMultiSelected(Const ACxGridDBTableView: TcxGridDBTableView);
  var
    i, vIdx, vGLR_ID: integer;
  begin
    for i:= 0 to ACxGridDBTableView.ViewData.RowCount -1 do
      begin
        if (ACxGridDBTableView.ViewData.Rows[i].ViewInfo <> nil) and
           (ACxGridDBTableView.ViewData.Rows[i].ViewInfo.Selected) then
          begin
            vIdx:= ACxGridDBTableView.GetColumnByFieldName('GLR_ID').Index;
            if not VarIsNull(ACxGridDBTableView.ViewData.Rows[i].Values[vIdx]) then
              begin
                vGLR_ID:= ACxGridDBTableView.ViewData.Rows[i].Values[vIdx];
                dmClients.DeleteRecordByRessource('GenGenLiaiRepli?DOSS_ID=' +  DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                                                  '&GLR_ID=' + IntToStr(vGLR_ID));
              end;
          end;
      end;
  end;

  procedure SetDispoByDataSet(Const ADataSet: TDataSet);
  begin
    ADataSet.DisableControls;
    try
      ADataSet.First;
      while not ADataSet.Eof do
        begin
          dmClients.DeleteRecordByRessource('GenGenLiaiRepli?DOSS_ID=' +  DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                                            '&GLR_ID=' + ADataSet.FieldByName('GLR_ID').AsString);
          ADataSet.Next;
        end;
    finally
      ADataSet.EnableControls;
    end;
  end;

  procedure SetTraiteByCxGridMultiSelected(Const AFieldNamePROSUBID: String;
    Const ACxGridDBTableView: TcxGridDBTableView; Const ADataSetTraite: TDataSet);
  var
    i, vIdx, vSUBPROID: integer;
  begin
    ADataSetTraite.DisableControls;
    try
      for i:= 0 to ACxGridDBTableView.ViewData.RowCount -1 do
        begin
          if (ACxGridDBTableView.ViewData.Rows[i].ViewInfo <> nil) and
             (ACxGridDBTableView.ViewData.Rows[i].ViewInfo.Selected) then
            begin
              vIdx:= ACxGridDBTableView.GetColumnByFieldName(AFieldNamePROSUBID).Index;
              if not VarIsNull(ACxGridDBTableView.ViewData.Rows[i].Values[vIdx]) then
                begin
                  vSUBPROID:= ACxGridDBTableView.ViewData.Rows[i].Values[vIdx];

                  if not ADataSetTraite.Locate(AFieldNamePROSUBID, vSUBPROID, []) then
                    begin
                      FdmClient.CDS_GENLIAIREPLI.Append;
                      FdmClient.CDS_GENLIAIREPLI.FieldByName('DOSS_ID').AsInteger:= DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsInteger;
                      FdmClient.CDS_GENLIAIREPLI.FieldByName('GLR_REPID').AsInteger:= DsGenReplication.DataSet.FieldByName('REP_ID').AsInteger;
                      FdmClient.CDS_GENLIAIREPLI.FieldByName('GLR_PROSUBID').AsInteger:= vSUBPROID;

                      dmClients.PostRecordToXml('GenGenLiaiRepli', 'TGnkGenLiaiRepli', FdmClient.CDS_GENLIAIREPLI);
                      FdmClient.CDS_GENLIAIREPLI.Post;
                    end;
                end;
            end;
        end;
    finally
      ADataSetTraite.EnableControls;
    end;
  end;

  procedure SetTraiteByDataSet(Const AFieldNamePROSUBID: String; Const ADataSetDispo, ADataSetTraite: TDataSet);
  begin
    ADataSetDispo.DisableControls;
    ADataSetTraite.DisableControls;
    try
      ADataSetDispo.First;
      while not ADataSetDispo.Eof do
        begin
          if not ADataSetTraite.Locate(AFieldNamePROSUBID, ADataSetDispo.FieldByName(AFieldNamePROSUBID).AsInteger, []) then
            begin
              FdmClient.CDS_GENLIAIREPLI.Append;
              FdmClient.CDS_GENLIAIREPLI.FieldByName('DOSS_ID').AsInteger:= DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsInteger;
              FdmClient.CDS_GENLIAIREPLI.FieldByName('GLR_REPID').AsInteger:= DsGenReplication.DataSet.FieldByName('REP_ID').AsInteger;
              FdmClient.CDS_GENLIAIREPLI.FieldByName('GLR_PROSUBID').AsInteger:= ADataSetDispo.FieldByName(AFieldNamePROSUBID).AsInteger;

              dmClients.PostRecordToXml('GenGenLiaiRepli', 'TGnkGenLiaiRepli', FdmClient.CDS_GENLIAIREPLI);
              FdmClient.CDS_GENLIAIREPLI.Post;
            end;

          ADataSetDispo.Next;
        end;
    finally
      ADataSetDispo.EnableControls;
      ADataSetTraite.EnableControls;
    end;
  end;

begin
  try
    try
      if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtProviders' then
        begin
          case AStatutPkg of
            spDispo:
              begin
                if not AIsAll then
                  SetDispoByCxGridMultiSelected(ParamReplicFramProviders.cxGridDBTableViewListTraite)
                else
                  SetDispoByDataSet(ParamReplicFramProviders.DsListTraite.DataSet);
              end;
            spTraite:
              begin
                if not AIsAll then
                  SetTraiteByCxGridMultiSelected('PRO_ID', ParamReplicFramProviders.cxGridDBTableViewListDispo,
                                                 ParamReplicFramProviders.DsListTraite.DataSet)
                else
                  SetTraiteByDataSet('PRO_ID', ParamReplicFramProviders.DsListDispo.DataSet,
                                     ParamReplicFramProviders.DsListTraite.DataSet);
              end;
          end;
        end
      else
        if cxPgCtrlParamReplic.ActivePage.Name = 'TbShtSubscription' then
          begin
            case AStatutPkg of
              spDispo:
                begin
                  if not AIsAll then
                    SetDispoByCxGridMultiSelected(ParamReplicFramSubscribers.cxGridDBTableViewListTraite)
                  else
                    SetDispoByDataSet(ParamReplicFramSubscribers.DsListTraite.DataSet);
                end;
              spTraite:
                begin
                  if not AIsAll then
                    SetTraiteByCxGridMultiSelected('SUB_ID', ParamReplicFramSubscribers.cxGridDBTableViewListDispo,
                                                   ParamReplicFramSubscribers.DsListTraite.DataSet)
                  else
                    SetTraiteByDataSet('SUB_ID', ParamReplicFramSubscribers.DsListDispo.DataSet,
                                       ParamReplicFramSubscribers.DsListTraite.DataSet);
                end;
              end;
          end;

      ParamReplicFramProviders.ToolBarFrameDispo.ActRefresh.Execute;
    except
      Raise;
    end;
  finally
    if FdmClient.CDS_GENLIAIREPLI.State <> dsBrowse then
      FdmClient.CDS_GENLIAIREPLI.Cancel;
    FdmClient.CDS_GENLIAIREPLI.EmptyDataSet;
  end;
end;

procedure TDlgParamReplicFrm.ParamReplicFramProviderscxGridDBTableViewListDispoStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
var
  vIdx: integer;
  vBM: TBookmark;
begin
  inherited;
  if (ParamReplicFramProviders.DsListTraite.DataSet = nil) or
     (ParamReplicFramProviders.DsListTraite.DataSet.RecordCount = 0) then
    Exit;

  vIdx:= ParamReplicFramProviders.cxGridDBTableViewListDispo.GetColumnByFieldName('PRO_ID').Index;
  if (not VarIsNull(ARecord.Values[vIdx])) and (ARecord.Values[vIdx] > 0) then
    begin
      vBM:= ParamReplicFramProviders.DsListTraite.DataSet.GetBookmark;
      ParamReplicFramProviders.DsListTraite.DataSet.DisableControls;
      try
        if ParamReplicFramProviders.DsListTraite.DataSet.Locate('PRO_ID', ARecord.Values[vIdx], []) then
          AStyle:= cxStyleRO;
      finally
        ParamReplicFramProviders.DsListTraite.DataSet.GotoBookmark(vBM);
        ParamReplicFramProviders.DsListTraite.DataSet.FreeBookmark(vBM);
        ParamReplicFramProviders.DsListTraite.DataSet.EnableControls;
      end;
    end;
end;

procedure TDlgParamReplicFrm.ParamReplicFramProvidersSpdBtnAllDisableClick(
  Sender: TObject);
begin
  inherited;
  PackageProSub(spDispo, True);
end;

procedure TDlgParamReplicFrm.ParamReplicFramProvidersSpdBtnAllEnableClick(
  Sender: TObject);
begin
  inherited;
  PackageProSub(spTraite, True);
end;

procedure TDlgParamReplicFrm.ParamReplicFramProvidersSpdBtnDisableClick(
  Sender: TObject);
begin
  inherited;
  PackageProSub(spDispo);
end;

procedure TDlgParamReplicFrm.ParamReplicFramProvidersSpdBtnEnableClick(
  Sender: TObject);
begin
  inherited;
  PackageProSub(spTraite);
end;

procedure TDlgParamReplicFrm.ParamReplicFramProvidersSpdBtnTraiteLoopDisabledClick(
  Sender: TObject);
begin
  inherited;
  StepLoop(False);
end;

procedure TDlgParamReplicFrm.ParamReplicFramProvidersSpdBtnTraiteLoopEnabledClick(
  Sender: TObject);
begin
  inherited;
  StepLoop(True);
end;

procedure TDlgParamReplicFrm.ParamReplicFramSubscriberscxGridDBTableViewListDispoStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
var
  vIdx: integer;
  vBM: TBookmark;
begin
  inherited;
  if (ParamReplicFramSubscribers.DsListTraite.DataSet = nil) or
     (ParamReplicFramSubscribers.DsListTraite.DataSet.RecordCount = 0) then
    Exit;

  vIdx:= ParamReplicFramSubscribers.cxGridDBTableViewListDispo.GetColumnByFieldName('SUB_ID').Index;
  if (not VarIsNull(ARecord.Values[vIdx])) and (ARecord.Values[vIdx] > 0) then
    begin
      vBM:= ParamReplicFramSubscribers.DsListTraite.DataSet.GetBookmark;
      ParamReplicFramSubscribers.DsListTraite.DataSet.DisableControls;
      try
        if ParamReplicFramSubscribers.DsListTraite.DataSet.Locate('SUB_ID', ARecord.Values[vIdx], []) then
          AStyle:= cxStyleRO;
      finally
        ParamReplicFramSubscribers.DsListTraite.DataSet.GotoBookmark(vBM);
        ParamReplicFramSubscribers.DsListTraite.DataSet.FreeBookmark(vBM);
        ParamReplicFramSubscribers.DsListTraite.DataSet.EnableControls;
      end;
    end;
end;

function TDlgParamReplicFrm.PostValues: Boolean;
begin
  Result:= inherited PostValues;

  try
    //-->

    if AAction = ukInsert then
    begin
      DsGenReplication.DataSet.FieldByName('REP_ID').AsInteger:= 0;
      DsGenReplication.DataSet.FieldByName('REP_LAUID').AsInteger:= DsEmetteur.DataSet.FieldByName('LAU_ID').AsInteger;
    end;

    //DsGenReplication.DataSet.FieldByName('DOSS_ID').AsInteger:= DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsInteger;
    dmClients.PostRecordToXml('GenReplication', 'TGnkGenReplication', TClientDataSet(DsGenReplication.DataSet));
    //DsGenReplication.DataSet.Post;

    Result:= True;
  except
    Raise;
  end;
end;

procedure TDlgParamReplicFrm.RefreshProviders(Const AStatutsPkg: TStatutsPkg);
begin
  if (DsEmetteur.DataSet.RecordCount <> 0) and (DsEmetteur.DataSet.FieldByName('LAU_ID').AsInteger > 0) then
    begin
      { Disponibles }
      if spDispo in AStatutsPkg then
        dmClients.XmlToDataSet('GenProviders?DOSS_ID=' + DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                               '&REP_ID=' + DsGenReplication.DataSet.FieldByName('REP_ID').AsString +
                               '&STATUTPKG=0', FdmClient.CDS_GENPROVIDERS_D);

      { Traités }
      if spTraite in AStatutsPkg then
        dmClients.XmlToDataSet('GenProviders?DOSS_ID=' + DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                               '&REP_ID=' + DsGenReplication.DataSet.FieldByName('REP_ID').AsString +
                               '&STATUTPKG=1', FdmClient.CDS_GENPROVIDERS_T);

      FdmClient.CDS_GENPROVIDERS_D.First;
    end;
end;

procedure TDlgParamReplicFrm.RefreshSubscribers(Const AStatutsPkg: TStatutsPkg);
begin
  if (DsEmetteur.DataSet.RecordCount <> 0) and (DsEmetteur.DataSet.FieldByName('LAU_ID').AsInteger > 0) then
    begin
      { Disponibles }
      if spDispo in AStatutsPkg then
        dmClients.XmlToDataSet('GenSubscribers?DOSS_ID=' + DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                               '&REP_ID=' + DsGenReplication.DataSet.FieldByName('REP_ID').AsString +
                               '&STATUTPKG=0', FdmClient.CDS_GENSUBSCRIBERS_D);

      { Traités }
      if spTraite in AStatutsPkg then
        dmClients.XmlToDataSet('GenSubscribers?DOSS_ID=' + DsEmetteur.DataSet.FieldByName('EMET_DOSSID').AsString +
                               '&REP_ID=' + DsGenReplication.DataSet.FieldByName('REP_ID').AsString +
                               '&STATUTPKG=1', FdmClient.CDS_GENSUBSCRIBERS_T);

      FdmClient.CDS_GENSUBSCRIBERS_D.First;
    end;
end;

end.

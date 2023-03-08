unit Main_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.IB, FireDAC.Phys.IBDef, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Vcl.ComCtrls, Vcl.OleCtrls, SHDocVw, Vcl.ExtCtrls,
  Vcl.Imaging.GIFImg, WaitScreen_Frm, System.Win.TaskbarCore, Vcl.Taskbar;

const
  WM_AFTER_SHOW = WM_USER + 1;

type

  TEventThreadProgress = procedure(iPercent: Integer) of object;
  TEvenThreadException = procedure(E: Exception) of object;

  EExceptionCancel = class(Exception)

  end;

  TThreadFidboxProcess = class(TThread)
  private
    FB_Test: Integer;
    FB_Num: Integer;
    FNivFidBox: Integer;
    FSaveDirectory: String;
    FOwner: TObject;
    function CalcPercent(iCurrent, iCount: Integer): Integer;
  protected
    procedure Execute; override;
    function GetSQLSession: String;
    function GetSQLDate: String;
  public
    onProgress: TEventThreadProgress;
    onException: TEvenThreadException;
    constructor Create(Test, Num, NivFidBox: Integer; SaveDirectory: String;
      Owner: TObject);
    procedure Cancel;
  end;

  TDBGrid = class(Vcl.DBGrids.TDBGrid)
  private
    procedure WMNCCalcSize(var msg: TMessage); message WM_NCCALCSIZE;
  end;

  TFrm_Main = class(TForm)
    Chp_Database: TEdit;
    Btn_Browse: TSpeedButton;
    OD_Database: TOpenDialog;
    GrpB_Magasin: TGroupBox;
    FDC_Database: TFDConnection;
    Grd_Magasin: TDBGrid;
    FDQ_Magasin: TFDQuery;
    DS_Magasin: TDataSource;
    GrpB_Poste: TGroupBox;
    Grd_Poste: TDBGrid;
    FDQ_Poste: TFDQuery;
    DS_Poste: TDataSource;
    FDQ_PostePOS_ID: TIntegerField;
    FDQ_PostePOS_NOM: TStringField;
    FDQ_MagasinMAG_ID: TIntegerField;
    FDQ_MagasinMAG_NOM: TStringField;
    FDQ_MagasinMAG_SOCID: TIntegerField;
    Btn_Close: TSpeedButton;
    GrpB_Filtre: TGroupBox;
    FDQ_Session: TFDQuery;
    DS_Session: TDataSource;
    Btn_Valider: TSpeedButton;
    FDQ_SessionSES_ID: TIntegerField;
    FDQ_SessionSES_ETAT: TIntegerField;
    FDQ_SessionSES_NUMERO: TStringField;
    FDQ_SessionSES_TRFCOMPTA: TIntegerField;
    FDQ_SessionSES_DEBUT: TSQLTimeStampField;
    FDQ_SessionSES_FIN: TSQLTimeStampField;
    PB_Total: TProgressBar;
    FDQ_ListeTickets: TFDQuery;
    FDQ_Client: TFDQuery;
    FDQ_Enc: TFDQuery;
    FDQ_Fid: TFDQuery;
    FDQ_FidIMP_REF: TIntegerField;
    FDQ_Reference: TFDQuery;
    FDQ_ReferenceCBI_CB: TStringField;
    FDQ_TicketLigne: TFDQuery;
    FDQ_Univers: TFDQuery;
    FDQ_Permission: TFDQuery;
    FDQ_PermissionUGG_ID: TIntegerField;
    FDQ_GetParam: TFDQuery;
    FDQ_GetParamPRM_ID: TIntegerField;
    FDQ_GetParamPRM_CODE: TIntegerField;
    FDQ_GetParamPRM_INTEGER: TIntegerField;
    FDQ_GetParamPRM_FLOAT: TFloatField;
    FDQ_GetParamPRM_STRING: TStringField;
    FDQ_GetParamPRM_TYPE: TIntegerField;
    FDQ_GetParamPRM_MAGID: TIntegerField;
    FDQ_GetParamPRM_INFO: TStringField;
    FDQ_GetParamPRM_POS: TIntegerField;
    FDQ_Fidbox: TFDQuery;
    FDQ_EncENC_MENID: TIntegerField;
    FDQ_EncENC_MOTIF: TStringField;
    FDQ_EncENC_MONTANT: TFloatField;
    FDQ_TicketLigneTKL_ARTID: TIntegerField;
    FDQ_TicketLigneTKL_TGFID: TIntegerField;
    FDQ_TicketLigneTKL_COUID: TIntegerField;
    FDQ_TicketLigneARF_VIRTUEL: TIntegerField;
    FDQ_TicketLigneTKL_PXBRUT: TFloatField;
    FDQ_TicketLigneART_REFMRK: TStringField;
    FDQ_TicketLigneTKL_QTE: TFloatField;
    FDQ_TicketLigneTKL_PXNN: TFloatField;
    TB_Progress: TTaskbar;
    Lbl_Percent: TLabel;
    PC_Filtre: TPageControl;
    TS_Date: TTabSheet;
    Chp_DateDeb: TDateTimePicker;
    Chp_DateFin: TDateTimePicker;
    Lbl_DateDeb: TLabel;
    Lbl_DateFin: TLabel;
    TS_Session: TTabSheet;
    Grd_Session: TDBGrid;
    FDQ_ClientCBI_CB: TStringField;
    FDQ_FidboxPRM_INTEGER: TIntegerField;
    FDQ_FidboxPRM_STRING: TStringField;
    FDQ_ListeTicketsTKE_CLTID: TIntegerField;
    FDQ_ListeTicketsTKE_ID: TIntegerField;
    FDQ_ListeTicketsTKE_NUMERO: TIntegerField;
    FDQ_ListeTicketsTOTGEN: TFloatField;
    FDQ_ListeTicketsTKE_DATE: TSQLTimeStampField;
    FDQ_TicketLigneTKL_GPSSTOTAL: TIntegerField;
    FDQ_TicketLigneTKL_SSTOTAL: TIntegerField;
    FDQ_TicketLigneTKL_ID: TIntegerField;
    procedure Btn_BrowseClick(Sender: TObject);
    procedure FDQ_MagasinAfterOpen(DataSet: TDataSet);
    procedure FDQ_PosteAfterOpen(DataSet: TDataSet);
    procedure FDQ_MagasinAfterScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_CloseClick(Sender: TObject);
    procedure FDQ_PosteAfterScroll(DataSet: TDataSet);
    procedure FDQ_SessionAfterOpen(DataSet: TDataSet);
    procedure Btn_ValiderClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormConstrainedResize(Sender: TObject;
      var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure OD_DatabaseShow(Sender: TObject);
    procedure Chp_DateChange(Sender: TObject);
    procedure FDQ_SessionAfterScroll(DataSet: TDataSet);
    procedure PC_FiltreChange(Sender: TObject);
  private
    { Déclarations privées }
    FMinWidth: Integer;
    FMinHeight: Integer;
    FB_Test: Integer;
    FB_Num: Integer;
    FNivFidBox: Integer;
    FSaveDirectory: String;
    FThreadFidBox: TThreadFidboxProcess;
    FResultThread: Integer;
    FWaitForm: TFrm_WaitScreen;
    function MessageDlg(const AOwner: TForm; const msg: string;
      DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
      HelpCtx: Integer = 0): Integer;
    procedure FixDBGridColumnsWidth(const DBGrid: TDBGrid);
    procedure FormWmAfterShow(var msg: TMessage); message WM_AFTER_SHOW;
    function LancerTraitement(aDateDebut, aDateFin: TDate): Boolean;
    function RoundRv(Value: Double; Precision: Integer): Double;
    function Conv(Value: Variant; Lg: Integer): STRING;
    function AlignLeft(Chaine: STRING; Pad: char; Lg: Integer): STRING;
    function Strs(c: char; Lg: Integer): STRING;
    function HasPermissionModuleIntersport: Boolean;
    function GetParamInteger(ACode: Integer; AType: Integer;
      AMagID: Integer = 0; APosID: Integer = 0): Integer;
    function GetParam(ACode, AType, AMagID, APosID: Integer;
      VAR PrmInteger: Integer; VAR PrmFloat: Double; VAR PrmString: STRING;
      VAR PrmInfo: STRING): Boolean;
    function InitFidBox: Boolean;
    procedure ThreadFidBoxOnTerminate(Sender: TObject);
    procedure ThreadFidBoxOnProgress(iPercent: Integer);
    procedure ThreadFidBoxOnException(E: Exception);
    procedure DisplayError(E: Exception); overload;
    procedure DisplayError(sMsg: String); overload;
    procedure ChangeControlsState(bActive: Boolean);
    procedure OnMove(var msg: TWMMove); message WM_MOVE;
    procedure OnCancelClick(Sender : TObject);
  public
    { Déclarations publiques }
  end;

var
  Main: TFrm_Main;

implementation

{$R *.dfm}

uses
  DateUtils, UITypes, ShlObj, FileCtrl;

function TFrm_Main.AlignLeft(Chaine: STRING; Pad: char; Lg: Integer): STRING;
begin
  IF Pad = '' THEN
    Pad := #32;
  IF length(Chaine) > Lg THEN
    result := copy(Chaine, 1, Lg)
  ELSE
    result := Strs(Pad, Lg - length(Chaine)) + Chaine;
end;

procedure TFrm_Main.Btn_BrowseClick(Sender: TObject);
begin
  try
    if OD_Database.Execute then
    begin
      if FileExists(OD_Database.Files[0]) then
      begin
        if FDC_Database.Connected then
          FDC_Database.Close;

        Chp_Database.Text := OD_Database.Files[0];
        FDC_Database.Params.Database := OD_Database.Files[0];
        FDC_Database.Open();
        FDQ_Magasin.Active := True;
      end
      else
      begin
        ShowMessage('Impossible d''ouvrir la base de données. ');
      end;
    end;
  except
    ShowMessage('Impossible d''ouvrir la base de données. ');
  end;
end;

procedure TFrm_Main.FDQ_PosteAfterOpen(DataSet: TDataSet);
begin
  FixDBGridColumnsWidth(Self.Grd_Poste);
end;

procedure TFrm_Main.FDQ_PosteAfterScroll(DataSet: TDataSet);
begin
  if FDQ_Session.Active then
    FDQ_Session.Close;

  FDQ_Session.Params.ParamByName('POSID').AsInteger :=
    FDQ_PostePOS_ID.AsInteger;

  FDQ_Session.Open();

end;

procedure TFrm_Main.FDQ_SessionAfterOpen(DataSet: TDataSet);
begin
  FixDBGridColumnsWidth(Self.Grd_Session);
  Chp_DateDeb.Enabled := FDQ_Session.RecordCount <> 0;
  Chp_DateFin.Enabled := Chp_DateDeb.Enabled;
  Chp_DateChange(Nil);

end;

procedure TFrm_Main.FDQ_SessionAfterScroll(DataSet: TDataSet);
begin
  if PC_Filtre.ActivePage = TS_Session then
  begin
    Btn_Valider.Enabled := FDQ_SessionSES_ID.AsInteger > 0;
  end;
end;

procedure TFrm_Main.Btn_CloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrm_Main.FDQ_MagasinAfterOpen(DataSet: TDataSet);
begin
  FixDBGridColumnsWidth(Self.Grd_Magasin);
end;

procedure TFrm_Main.FDQ_MagasinAfterScroll(DataSet: TDataSet);
begin
  if FDQ_Poste.Active then
    FDQ_Poste.Close;

  FDQ_Poste.Params.ParamByName('MAGID').AsInteger :=
    FDQ_MagasinMAG_ID.AsInteger;

  FDQ_Poste.Open();
end;

procedure TFrm_Main.FixDBGridColumnsWidth(const DBGrid: TDBGrid);
var
  i: Integer;
  TotWidth: Integer;
  VarWidth: Integer;
  ResizableColumnCount: Integer;
  AColumn: TColumn;
begin
  TotWidth := 0;
  ResizableColumnCount := 0;

  for i := 0 to -1 + DBGrid.Columns.Count do
  begin
    TotWidth := TotWidth + DBGrid.Columns[i].Width;
    if (DBGrid.Columns[i].Field.Tag = 0) and (DBGrid.Columns[i].Visible) then
      Inc(ResizableColumnCount);
  end;

  if dgColLines in DBGrid.Options then
    TotWidth := TotWidth + DBGrid.Columns.Count;

  if dgIndicator in DBGrid.Options then
    TotWidth := TotWidth + IndicatorWidth;

  VarWidth := DBGrid.ClientWidth - TotWidth;

  if ResizableColumnCount > 0 then
    VarWidth := VarWidth div ResizableColumnCount;

  for i := 0 to -1 + DBGrid.Columns.Count do
  begin
    AColumn := DBGrid.Columns[i];
    if (AColumn.Field.Tag = 0) and (DBGrid.Columns[i].Visible) then
    begin
      AColumn.Width := AColumn.Width + VarWidth;
      if (AColumn.Width = 0) then
        AColumn.Width := AColumn.Field.Tag;
    end;
  end;
end;

procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;

  if FDQ_Magasin.Active then
    FDQ_Magasin.Close;

  if FDQ_Poste.Active then
    FDQ_Poste.Close;

  if FDQ_Poste.Active then
    FDQ_Poste.Close;

end;

procedure TFrm_Main.FormConstrainedResize(Sender: TObject;
  var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
begin
  MinWidth := FMinWidth;
  MinHeight := FMinHeight;
  FixDBGridColumnsWidth(Grd_Magasin);
  FixDBGridColumnsWidth(Grd_Poste);
  FixDBGridColumnsWidth(Grd_Session);
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TWinControl then
    begin
      (Components[i] as TWinControl).ControlStyle :=
        (Components[i] as TWinControl).ControlStyle - [csParentBackground];
      (Components[i] as TWinControl).DoubleBuffered := True;
    end;
  end;
  Chp_DateDeb.DateTime := IncMonth(Date, -1);
  Chp_DateFin.DateTime := Date;

  FMinWidth := 690;
  FMinHeight := 600;
  FResultThread := -1;

  if FileExists('C:\Ginkoia\Data\Ginkoia.ib') then
  begin
    Chp_Database.Text := 'C:\Ginkoia\Data\Ginkoia.ib';
    FDC_Database.Params.Database := 'C:\Ginkoia\Data\Ginkoia.ib';
  end
  else if FileExists('D:\Ginkoia\Data\Ginkoia.ib') then
  begin
    Chp_Database.Text := 'D:\Ginkoia\Data\Ginkoia.ib';
    FDC_Database.Params.Database := 'D:\Ginkoia\Data\Ginkoia.ib';
  end;

  if Trim(FDC_Database.Params.Database) <> '' then
  begin
    if not FDC_Database.Connected then
      FDC_Database.Open();
    FDQ_Magasin.Open();
  end;


end;

procedure TFrm_Main.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      Btn_Valider.Click;
  end;

end;

procedure TFrm_Main.FormResize(Sender: TObject);
begin
  FixDBGridColumnsWidth(Grd_Magasin);
  FixDBGridColumnsWidth(Grd_Poste);
  FixDBGridColumnsWidth(Grd_Session);
end;

procedure TFrm_Main.FormShow(Sender: TObject);
begin
  PostMessage(Self.Handle, WM_AFTER_SHOW, 0, 0);
end;

function TFrm_Main.GetParam(ACode, AType, AMagID, APosID: Integer;
  var PrmInteger: Integer; var PrmFloat: Double;
  var PrmString, PrmInfo: STRING): Boolean;
begin
  result := True;
  if FDQ_GetParam.Active then
  begin
    FDQ_GetParam.Close;
  end;

  try
    FDQ_GetParam.Params.ParamByName('PRMCODE').AsInteger := ACode;
    FDQ_GetParam.Params.ParamByName('PRMTYPE').AsInteger := AType;
    FDQ_GetParam.Params.ParamByName('MAGID').AsInteger := AMagID;
    FDQ_GetParam.Params.ParamByName('POSID').AsInteger := APosID;
    FDQ_GetParam.Open;
    PrmInteger := FDQ_GetParamPRM_INTEGER.AsInteger;
    PrmFloat := FDQ_GetParamPRM_FLOAT.AsFloat;
    PrmString := FDQ_GetParamPRM_STRING.AsString;
    PrmInfo := FDQ_GetParamPRM_INFO.AsString;
    FDQ_GetParam.Close;
  except
    on E: Exception do
      result := False;
  end;

end;

function TFrm_Main.GetParamInteger(ACode, AType, AMagID,
  APosID: Integer): Integer;
VAR
  iInt: Integer;
  fFlt: Double;
  sStr: STRING;
  sInfo: STRING;
begin
  result := 0;
  TRY
    IF GetParam(ACode, AType, AMagID, APosID, iInt, fFlt, sStr, sInfo) THEN
      result := iInt;
  EXCEPT
  END;
end;

procedure TFrm_Main.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      PostMessage(Self.Handle, WM_KEYDOWN, VK_RETURN, 0);
    VK_ESCAPE:
      PostMessage(Self.Handle, WM_KEYDOWN, VK_ESCAPE, 0);
  end;
end;

function TFrm_Main.HasPermissionModuleIntersport: Boolean;
begin
  try
    if FDQ_Permission.Active then
    begin
      FDQ_Permission.Close;
    end;

    FDQ_Permission.Params.ParamByName('MAGID').AsInteger := FDQ_MagasinMAG_ID.AsInteger;
    FDQ_Permission.Params.ParamByName('NOM').AsString := 'CENTRALE INTERSPORT';
    FDQ_Permission.Open();
    result := FDQ_Permission.RecordCount <> 0;
  finally
    FDQ_Permission.Close;
  end;

end;

function TFrm_Main.InitFidBox: Boolean;
var
  i: Integer;
begin
  if FDQ_Fidbox.Active then
  begin
    FDQ_Fidbox.Close;
  end;

  for i := 11001 to 11002 do
  begin
    FDQ_Fidbox.Close;
    FDQ_Fidbox.Params.ParamByName('posid').AsInteger :=
      FDQ_PostePOS_ID.AsInteger;
    FDQ_Fidbox.Params.ParamByName('code').AsInteger := i;
    FDQ_Fidbox.Open;

    if not FDQ_Fidbox.Eof then
    begin
      case i of
        11001:
          begin
            if FDQ_FidboxPRM_STRING.AsString = 'TEST' then
            begin
              FB_Test := 1;
            end
            else
            begin
              FB_Test := 0;
            end;
          end;
        11002:
          FB_Num := FDQ_FidboxPRM_INTEGER.AsInteger;
      end;
    end;
  end;

  FNivFidBox := GetParamInteger(117, 3, FDQ_MagasinMAG_ID.AsInteger,
    FDQ_PostePOS_ID.AsInteger);
  result := True;
end;

function TFrm_Main.LancerTraitement(aDateDebut, aDateFin: TDate): Boolean;
begin
  result := False;
  try
    if CompareDate(aDateDebut, aDateFin) = 1 then
    begin
      Exit;
    end;

    if not InitFidBox then
    begin
      Exit;
    end;

    if not SelectDirectory('Sélectionnez un répertoire de destination', '', FSaveDirectory,
      [sdShowEdit, sdNewUI, sdValidateDir], Self) then
    begin
      raise EExceptionCancel.Create('');
    end;

    FResultThread := -1;
    FThreadFidBox := TThreadFidboxProcess.Create(FB_Test, FB_Num, FNivFidBox,
      FSaveDirectory, Self);
    FThreadFidBox.OnTerminate := ThreadFidBoxOnTerminate;
    FThreadFidBox.onProgress := ThreadFidBoxOnProgress;
    FThreadFidBox.onException := ThreadFidBoxOnException;
    FThreadFidBox.Start;

    try
      FWaitForm := TFrm_WaitScreen.ShowWaitScreen(Self);
      FWaitForm.Lbl_Annuler.OnClick := OnCancelClick;
      while FResultThread = -1 do
      begin
        Application.ProcessMessages;
      end;
    finally
      FWaitForm.AllowClose;
      FWaitForm.Free;
    end;

    result := FResultThread = 1;
  except
    on E: Exception do
      if (E is EExceptionCancel) then
        Raise
      else
        DisplayError(E);
  end;
end;

function TFrm_Main.MessageDlg(const AOwner: TForm; const msg: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Integer): Integer;
begin
  with CreateMessageDialog(msg, DlgType, Buttons) do
    try
      Position := poOwnerFormCenter;
      result := ShowModal;
    finally
      Free;
    end
end;

procedure TFrm_Main.OD_DatabaseShow(Sender: TObject);
var
  r: TRect;
begin
  with Sender as TOpenDialog do
  begin
    GetWIndowRect(GetParent(Handle), r);
    MoveWindow(GetParent(Handle), Application.MainForm.Left +
      (Application.MainForm.Width - (r.Right - r.Left)) div 2,
      Application.MainForm.Top + (Application.MainForm.Height -
      (r.Bottom - r.Top)) div 2, r.Right - r.Left, r.Bottom - r.Top, True);

    Abort;
  end;
end;

procedure TFrm_Main.OnCancelClick(Sender: TObject);
begin
  if Assigned(Self.FThreadFidBox) and (not Self.FThreadFidBox.Terminated) then
    Self.FThreadFidBox.Terminate;

end;

procedure TFrm_Main.OnMove(var msg: TWMMove);
begin
  if Assigned(FWaitForm) then
    FWaitForm.BringToFront;
end;

procedure TFrm_Main.PC_FiltreChange(Sender: TObject);
begin
  if PC_Filtre.ActivePage = TS_Date then
    Chp_DateChange(Nil)
  else if PC_Filtre.ActivePage = TS_Session then
  begin
    FDQ_PosteAfterScroll(Nil);
    if not FDQ_Session.Active then
      FDQ_Session.Open;
    Btn_Valider.Enabled := (FDQ_Session.RecordCount > 0) and
      (FDQ_SessionSES_ID.AsInteger > 0);
  end;
end;

procedure TFrm_Main.FormWmAfterShow(var msg: TMessage);
begin
  FixDBGridColumnsWidth(Grd_Magasin);
  FixDBGridColumnsWidth(Grd_Poste);
  FixDBGridColumnsWidth(Grd_Session);
end;

procedure TFrm_Main.Btn_ValiderClick(Sender: TObject);
var
  sMsg: String;
  bResult: Boolean;
begin
  try
    if not Btn_Valider.Enabled then
    begin
      Exit;
    end;
    ChangeControlsState(False);
    try
      if PC_Filtre.ActivePage = TS_Date then
      begin
        if CompareDate(Chp_DateDeb.Date, Chp_DateFin.Date) = 0 then
        begin
          sMsg := 'Souhaitez-vous générer tous les fichiers FIDBOX pour la journée du '
            + FormatDateTime('dd/MM/YYYY', Chp_DateDeb.Date) + ' ? ';
        end
        else if CompareDate(Chp_DateDeb.Date, Chp_DateFin.Date) < 0 then
        begin
          sMsg := 'Souhaitez-vous générer tous les fichiers FIDBOX pour toutes les journées entre le '
            + FormatDateTime('dd/MM/YYYY', Chp_DateDeb.Date) + ' et le ' +
            FormatDateTime('dd/MM/YYYY', Chp_DateFin.Date) + ' ? ';
        end
        else
        begin
          Self.DisplayError
            ('La date de fin ne peut pas être antérieure à la date de début. ');
          Exit;
        end;
      end
      else if PC_Filtre.ActivePage = TS_Session then
      begin
        sMsg := 'Souhaitez-vous générer l''ensemble des fichiers FidBox pour la session de caisse numéro '
          + FDQ_SessionSES_NUMERO.AsString;
      end;

      if Self.MessageDlg(Self, sMsg, mtConfirmation, mbYesNo, 0) = mrYes then
      begin
        bResult := LancerTraitement(Chp_DateDeb.Date, Chp_DateFin.Date);
      end
      else
      begin
        Exit;
      end;

      if bResult then
      begin
        Self.MessageDlg(Self, 'Traitement terminé', mtInformation, [mbOK], 0);
        ThreadFidBoxOnProgress(0);
      end
      else
      begin
        Self.MessageDlg(Self, 'Une erreur est survenu pendant le traitement',
          mtError, [mbOK], 0);
      end;
    finally
      ChangeControlsState(True);
      ThreadFidBoxOnProgress(0);
      Lbl_Percent.Visible := False;
    end;
  except
    on E: Exception do
      if not(E is EExceptionCancel) then
        DisplayError(E);
  end;

end;

procedure TFrm_Main.DisplayError(E: Exception);
begin
  if Assigned(E) then
  begin
    DisplayError(E.Message);
  end;
end;

procedure TFrm_Main.DisplayError(sMsg: String);
begin
  Self.MessageDlg(Self, 'Erreur : ' + sMsg, mtError, [mbOK], 0);
end;

function TFrm_Main.RoundRv(Value: Double; Precision: Integer): Double;
VAR
  i: Integer;
  r: Int64;
BEGIN
  r := 1;
  IF Precision > 0 THEN
    FOR i := 1 TO Precision DO
      r := r * 10;

  IF Value > 0 THEN
  BEGIN
    TRY
      result := Trunc((Value * r) + 0.5) / r;
    EXCEPT
      result := Value;
    END;
  END
  ELSE
  BEGIN
    IF Value = 0 THEN
      result := 0
    ELSE
      result := -Trunc((Abs(Value) * r) + 0.5) / r;
  END;
  // Result := ( Round ( Value * R ) ) / R;
END;

function TFrm_Main.Strs(c: char; Lg: Integer): STRING;
var
  i: Integer;
begin
  result := '';
  IF Lg = 0 THEN
    Exit;
  FOR i := 1 TO Lg DO
    result := result + c;
end;

procedure TFrm_Main.ThreadFidBoxOnException(E: Exception);
begin
  if not FThreadFidBox.Terminated then
    FThreadFidBox.Terminate;
  DisplayError(E);
end;

procedure TFrm_Main.ThreadFidBoxOnProgress(iPercent: Integer);
begin
  if iPercent >= 0 then
  begin
    Lbl_Percent.Visible := True;
    Lbl_Percent.Caption := IntToStr(iPercent) + '%';
    PB_Total.Position := iPercent;
    TB_Progress.ProgressValue := iPercent;
  end;
end;

procedure TFrm_Main.ThreadFidBoxOnTerminate(Sender: TObject);
begin
  FResultThread := FThreadFidBox.ReturnValue;
end;

procedure TFrm_Main.ChangeControlsState(bActive: Boolean);
begin
  Grd_Magasin.Enabled := bActive;
  Grd_Poste.Enabled := bActive;
  Grd_Session.Enabled := bActive;
  Btn_Browse.Enabled := bActive;
  Btn_Close.Enabled := bActive;
  Btn_Valider.Enabled := bActive;
  Chp_DateDeb.Enabled := bActive;
  Chp_DateFin.Enabled := bActive;
end;

procedure TFrm_Main.Chp_DateChange(Sender: TObject);
var
  bMustEnable: Boolean;
begin
  bMustEnable := False;

  if PC_Filtre.ActivePage = TS_Date then
  begin
    bMustEnable := (CompareDate(Chp_DateDeb.DateTime, Chp_DateFin.DateTime) <=
      0) and (Chp_DateDeb.Enabled) and (Chp_DateFin.Enabled);
  end;

  Btn_Valider.Enabled := bMustEnable;
end;

function TFrm_Main.Conv(Value: Variant; Lg: Integer): STRING;
BEGIN
  result := AlignLeft(Value, '0', Lg);
END;

{ TThreadFidboxProcess }

function TThreadFidboxProcess.CalcPercent(iCurrent, iCount: Integer): Integer;
begin
  if iCurrent < iCount then
    result := (iCurrent * 100) div iCount
  else
    result := 100;

end;

procedure TThreadFidboxProcess.Cancel;
begin
  if not Self.Terminated then
    Self.Terminate;
end;

constructor TThreadFidboxProcess.Create(Test, Num, NivFidBox: Integer;
  SaveDirectory: String; Owner: TObject);
begin
  inherited Create(True);

  FreeOnTerminate := True;
  FB_Test := Test;
  FB_Num := Num;
  FNivFidBox := NivFidBox;
  FSaveDirectory := SaveDirectory;
  Self.FreeOnTerminate := True;

  if Owner is TFrm_Main then
    Self.FOwner := Owner;
end;

procedure TThreadFidboxProcess.Execute;
var
  tsl: TStringList;
  sNumBA, scbf, sCodeUnivers: String;
  iPosi, iNba: Integer;
  aa, mm, jj, hr, mn, sec, ms: Word;
  sFileName, sLib: String;
  aDateTime : TDateTime;
  
begin
  try
    if Not Assigned(FOwner) then
      Exit;
    Self.ReturnValue := 0;

    if FB_Test = 0 then
    begin
      sLib := 'Caisse';
    end
    else
    begin
      sLib := 'Recette';
    end;

    with FOwner as TFrm_Main do
    begin

      if FDQ_ListeTickets.Active then
        FDQ_ListeTickets.Close;

      if PC_Filtre.ActivePage = TS_Date then
      begin
        FDQ_ListeTickets.SQL.Text := GetSQLDate;
        FDQ_ListeTickets.Params.ParamByName('DATE_DEB').AsDateTime :=
          StrToDateTime(DateToStr(Chp_DateDeb.Date) + ' 00:00:00:00');
        FDQ_ListeTickets.Params.ParamByName('DATE_FIN').AsDateTime :=
          StrToDateTime(DateToStr(Chp_DateFin.Date) + ' 23:59:59:999');
        FDQ_ListeTickets.Params.ParamByName('POSID').AsInteger :=
          FDQ_PostePOS_ID.AsInteger;
      end
      else if PC_Filtre.ActivePage = TS_Session then
      begin
        FDQ_ListeTickets.SQL.Text := GetSQLSession;
        FDQ_ListeTickets.Params.ParamByName('SES_ID').AsInteger :=
          FDQ_SessionSES_ID.AsInteger;
      end;
      FDQ_ListeTickets.Open();
      FDQ_ListeTickets.FetchAll;

      FDQ_ListeTickets.First;
      tsl := TStringList.Create;
      try
        while not FDQ_ListeTickets.Eof and not Self.Terminated do
        begin
          iPosi := 0;
          iNba := 0;
          aDateTime := FDQ_ListeTicketsTKE_DATE.AsDateTime;
          if Assigned(onProgress) then
          begin
            onProgress(CalcPercent(FDQ_ListeTickets.RecNo,
              FDQ_ListeTickets.RecordCount));
          end;

          if FDQ_Client.Active then
          begin
            FDQ_Client.Close;
          end;
          FDQ_Client.Params.ParamByName('CLTID').AsInteger :=
            FDQ_ListeTicketsTKE_CLTID.AsInteger;
          FDQ_Client.Open();

          if FDQ_Enc.Active then
          begin
            FDQ_Enc.Close;
          end;
          FDQ_Enc.Params.ParamByName('TKEID').AsInteger :=
            FDQ_ListeTicketsTKE_ID.AsInteger;
          FDQ_Enc.Open();

          tsl.add('DEB:2');
          tsl.add('TYP:G');
          tsl.add('IDE:' + FDQ_ClientCBI_CB.AsString);
          tsl.add('LAR:40');
          tsl.add('MN:' + floattostr(RoundRv(FDQ_ListeTicketsTOTGEN.AsFloat,
            2) * 100) + #59 + '978');
          tsl.add('NFA:' + Conv(FDQ_ListeTicketsTKE_NUMERO.AsString, 4));
          tsl.add('NTP:' + IntToStr(FDQ_Enc.RecordCount));

          FDQ_Enc.First;
          while not FDQ_Enc.Eof do
          begin
            try
              if FDQ_Fid.Active then
              begin
                FDQ_Fid.Close;
              end;
              FDQ_Fid.Params.ParamByName('menid').AsInteger :=
                FDQ_EncENC_MENID.AsInteger;
              FDQ_Fid.Open();

              if FDQ_FidIMP_REF.AsString = '5' then
                sNumBA := ';' + copy(FDQ_EncENC_MOTIF.AsString, 9, 13)
              else
                sNumBA := '';

              tsl.add('TPA:' + Conv(FDQ_FidIMP_REF.AsString, 2) + ';' +
                floattostr(RoundRv(FDQ_EncENC_MONTANT.AsFloat, 2) * 100) +
                ';978' + sNumBA);
            finally
              FDQ_Enc.Next;
            end;
          end;

          if FDQ_TicketLigne.Active then
          begin
            FDQ_TicketLigne.Close;
          end;
          FDQ_TicketLigne.Params.ParamByName('TKEID').AsInteger :=
            FDQ_ListeTicketsTKE_ID.AsInteger;
          FDQ_TicketLigne.Open();
          FDQ_TicketLigne.First;
          while not FDQ_TicketLigne.Eof do
          begin
            try
              if FDQ_TicketLigneTKL_ARTID.AsInteger <> 0 then
              begin
                if FDQ_Reference.Active then
                begin
                  FDQ_Reference.Close;
                end;
                FDQ_Reference.Params.ParamByName('artid').AsInteger :=
                  FDQ_TicketLigneTKL_ARTID.AsInteger;
                FDQ_Reference.Params.ParamByName('tgfid').AsInteger :=
                  FDQ_TicketLigneTKL_TGFID.AsInteger;
                FDQ_Reference.Params.ParamByName('couid').AsInteger :=
                  FDQ_TicketLigneTKL_COUID.AsInteger;
                FDQ_Reference.Open();
                if not FDQ_Reference.Eof then
                  scbf := FDQ_ReferenceCBI_CB.AsString
                else
                  scbf := '';

                if FDQ_Univers.Active then
                begin
                  FDQ_Univers.Close;
                end;

                if HasPermissionModuleIntersport then
                begin
                  FDQ_Univers.SQL.Text :=
                    'SELECT F_LEFT(CAST(MAX(SSF_CODEFINAL) AS VARCHAR(32)), 8) AS CodeUnivers '
                    + 'FROM ARTRELATIONAXE JOIN K ON (K_ID = ARX_ID AND K_ENABLED = 1) '
                    + '  JOIN NKLSSFAMILLE JOIN K ON (K_ID = SSF_ID AND K_ENABLED = 1) ON (ARX_SSFID = SSF_ID) '
                    + '  JOIN NKLFAMILLE JOIN K ON (K_ID = FAM_ID AND K_ENABLED = 1)  ON (FAM_ID = SSF_FAMID) '
                    + '  JOIN NKLRAYON JOIN K ON (K_ID = RAY_ID AND K_ENABLED = 1)  ON (RAY_ID = FAM_RAYID) '
                    + '  JOIN NKLSECTEUR JOIN K ON (K_ID = SEC_ID AND K_ENABLED = 1) ON (SEC_ID = RAY_SECID) '
                    + 'WHERE SEC_UNIID = ' + IntToStr(GetParamInteger(16, 12)) +
                    ' ' + '  AND ARX_ARTID = :ARTID';
                end
                else
                begin
                  FDQ_Univers.SQL.Text := 'select ssf_idref as CodeUnivers ' +
                    'from artarticle join nklssfamille on ssf_id=art_ssfid ' +
                    'where art_id=:artid';
                end;

                FDQ_Univers.Params.ParamByName('artid').AsInteger :=
                  FDQ_TicketLigneTKL_ARTID.AsInteger;
                FDQ_Univers.Open();
                if FDQ_Univers.Eof then
                  sCodeUnivers := '0'
                else
                  sCodeUnivers := FDQ_Univers.FieldByName('CodeUnivers').AsString;
                FDQ_Univers.Close;

                if iPosi = 0 then
                begin
                  tsl.add('NBA:1');
                  iPosi := tsl.Count;
                end;

                Inc(iNba);

                if (FDQ_TicketLigneARF_VIRTUEL.AsInteger = 1) and
                  (FDQ_TicketLigneTKL_PXBRUT.AsFloat = 0) and (scbf <> '') and
                  (copy(scbf, 1, 10) = '9999999999') then
                begin
                  tsl.add('ART:' + copy(FDQ_ReferenceCBI_CB.AsString, 1, 13) +
                    ';COUP;1;0;' + sCodeUnivers);
                end
                else
                begin
                  tsl.add('ART:' + scbf + ';' + FDQ_TicketLigneART_REFMRK.AsString
                    + ';' + FDQ_TicketLigneTKL_QTE.AsString + ';' +
                    floattostr(RoundRv((FDQ_TicketLigneTKL_PXNN.AsFloat *
                    FDQ_TicketLigneTKL_QTE.AsFloat) * 100, 0)) + ';' +
                    sCodeUnivers)
                end;
              end;
            finally
              FDQ_TicketLigne.Next;
            end;
          end;

          if iNba <> 0 then
          begin
            tsl[iPosi - 1] := 'NBA:' + IntToStr(iNba);
          end;
          DecodeDate(aDateTime, aa, mm, jj);
          DecodeTime(aDateTime, hr, mn, sec, ms);
          sFileName := sLib + Conv(IntToStr(FB_Num), 2) +
            Conv(FDQ_ListeTicketsTKE_NUMERO.AsInteger, 4) + '_' + IntToStr(aa) +
            Conv(IntToStr(mm), 2) + Conv(IntToStr(jj), 2) +
            Conv(IntToStr(hr), 2) + Conv(IntToStr(mn), 2) +
            Conv(IntToStr(sec), 2) + '.txt';

          if not System.SysUtils.DirectoryExists(FSaveDirectory) then
          begin
            if not CreateDir(FSaveDirectory) then
            begin
              raise Exception.Create
                ('Impossible d''écrire dans le répertoire de sortie');
            end;
          end;

          if FNivFidBox = 1 then
            raise Exception.Create('Fidbox désactivé (Niveau 1)');

          if Trim(FDQ_ClientCBI_CB.AsString) <> '' then          
          begin
            tsl.SaveToFile(IncludeTrailingPathDelimiter(FSaveDirectory) +
            sFileName);
          end;

          tsl.Clear;

          FDQ_ListeTickets.Next;
        end;
        Self.ReturnValue := 1;
      finally
        if Assigned(tsl) then
        begin
          FreeAndNil(tsl);
        end;
      end;
    end;
  except
    on E : Exception do
    begin
      if Assigned(Self.onException) then
      begin
        Self.onException(E);
      end;
    end;
  end;
end;

function TThreadFidboxProcess.GetSQLDate: String;
begin
  result := 'select T.*, SES.*, (T.TKE_TOTNETA1 + T.TKE_TOTBRUTA2 + + T.TKE_TOTBRUTA3 + + T.TKE_TOTBRUTA4) TOTGEN, T.TKE_DATE  ' +
    ' from CSHTICKET T ' + ' join CSHSESSION SES on SES.SES_ID = T.TKE_SESID ' +
    ' join K K1 on (K1.K_ID = T.TKE_ID and K1.K_ENABLED = 1) ' +
    ' join K K2 on (K2.K_ID = SES.SES_ID and K2.K_ENABLED = 1) ' +
    ' where SES.SES_DEBUT >= :DATE_DEB and ' + ' SES.SES_FIN <= :DATE_FIN and SES.SES_POSID = :POSID'
end;

function TThreadFidboxProcess.GetSQLSession: String;
begin
  result := 'select T.*, SES.*, (T.TKE_TOTNETA1 + T.TKE_TOTBRUTA2 + + T.TKE_TOTBRUTA3 + + T.TKE_TOTBRUTA4) TOTGEN , T.TKE_DATE ' +
    ' from CSHTICKET T ' + ' join CSHSESSION SES on SES.SES_ID = T.TKE_SESID ' +
    ' join K K1 on (K1.K_ID = T.TKE_ID and K1.K_ENABLED = 1) ' +
    ' join K K2 on (K2.K_ID = SES.SES_ID and K2.K_ENABLED = 1) ' +
    ' where SES.SES_ID = :SES_ID';

end;

{ TDBGrid }

procedure TDBGrid.WMNCCalcSize(var msg: TMessage);
var
  style: Integer;
begin
  style := getWindowLong(Handle, GWL_STYLE);
  if (style and WS_HSCROLL) <> 0 then
    SetWindowLong(Handle, GWL_STYLE, style and not WS_HSCROLL);
  inherited;
end;

end.

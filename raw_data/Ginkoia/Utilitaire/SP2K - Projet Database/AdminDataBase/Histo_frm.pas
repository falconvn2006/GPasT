// ------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
// ------------------------------------------------------------------------------

UNIT Histo_frm;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Main_Dm, Controls, Forms,
  Dialogs, AlgolDialogForms, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, ExtCtrls, RzPanel, fcStatusBar,
  RzBorder, LMDCustomComponent, LMDWndProcComponent, LMDFormShadow, Db, ADODB,
  dxCntner, dxTL, dxDBCtrl, dxDBGrid, dxDBGridHP, dxDBTLCl, dxGrClms,
  LMDBaseGraphicControl, AdvGlowButton, StdCtrls, RzLabel, uHeaderCsv;

TYPE
  TFrm_Histo = CLASS(TAlgolDialogForm)
    DBG_Histo: TdxDBGridHP;
    DBG_Histomhi_datedeb: TdxDBGridDateColumn;
    DBG_Histomhi_datefin: TdxDBGridDateColumn;
    DBG_HistoCOLUMN1: TdxDBGridDateColumn;
    DBG_Histomhi_kdeb: TdxDBGridMaskColumn;
    DBG_Histomhi_kfin: TdxDBGridMaskColumn;
    DBG_Histomhi_ok: TdxDBGridCheckColumn;
    DBG_Histomhi_info: TdxDBGridMaskColumn;
    Pan_Fond: TRzPanel;
    Pan_Btn: TRzPanel;
    Nbt_Post: TAdvGlowButton;
    Nbt_Export: TAdvGlowButton;
    Ds_Histo: TDataSource;
    PROCEDURE Nbt_PostClick(Sender: TObject);
    PROCEDURE Nbt_CancelClick(Sender: TObject);
    PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word; Shift: TShiftState);
    PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    procedure Pan_BtnEnter(Sender: TObject);
    procedure Pan_BtnExit(Sender: TObject);
    procedure Nbt_ExportClick(Sender: TObject);
  PRIVATE
    UserCanModify, UserVisuMags: Boolean;
    { Private declarations }
  PROTECTED
    { Protected declarations }
  PUBLIC
    { Public declarations }
  PUBLISHED

  END;

FUNCTION ExecuteHisto(): Boolean;

IMPLEMENTATION

{$R *.DFM}

USES
  StdUtils, GinkoiaStyle_Dm;

FUNCTION ExecuteHisto(): Boolean;

VAR
  Frm_histo: TFrm_Histo;
BEGIN
  Result := False;
  Application.createform(TFrm_Histo, Frm_histo);
  WITH Frm_histo DO
  BEGIN
    TRY
//      Ds_Histo.DATASET := query;
      IF Showmodal = mrOk THEN
      BEGIN
        Result := True;
      END;
    FINALLY
      release;
    END;
  END;
END;

PROCEDURE TFrm_Histo.AlgolStdFrmCreate(Sender: TObject);
BEGIN
  TRY
    screen.Cursor := crSQLWait;
    Hint          := Caption;
    Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);
  FINALLY
    screen.Cursor := crDefault;
  END;
END;

PROCEDURE TFrm_Histo.AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word; Shift: TShiftState);
BEGIN
  CASE Key OF
    VK_ESCAPE:
      Nbt_CancelClick(Sender);
    VK_F12:
      Nbt_PostClick(Sender);
    VK_RETURN:
      IF Pan_Btn.Focused THEN
        Nbt_PostClick(Sender);
  END;
END;

PROCEDURE TFrm_Histo.Nbt_PostClick(Sender: TObject);
BEGIN
  ModalResult := mrOk;
END;

PROCEDURE TFrm_Histo.Nbt_CancelClick(Sender: TObject);
BEGIN
  ModalResult := mrCancel;
END;

procedure TFrm_Histo.Nbt_ExportClick(Sender: TObject);
var
  Header : TExportHeaderOL;
  sFileName : string;
  i : integer;
  bm : TBookmark;
begin
  sFileName := ExtractFilePath(Application.ExeName);
  Header := TExportHeaderOL.Create;
  try
    try
      Header.bWriteHeader := True;
      Header.Separator := ';';
      Header.bAlign := False;

      sFileName := sFileName + 'Export_Historique_' + FormatDateTime('YYYYMMDD_hhmmss',Now) + '.csv';
      for i := 0 to (DBG_Histo.ColumnCount - 1) do
      begin
        if DBG_Histo.HPAddOn.Columns.CmzHidden.IndexOf(DBG_Histo.Columns[i].FieldName) = -1 then
          if DBG_Histo.Columns[i].Visible then
            case DBG_Histo.Columns[i].Field.DataType of
              ftDate, ftDateTime :
              begin
                Header.Add(DBG_Histo.Columns[i].FieldName,0,alLeft,fmDate,'DD/MM/YYYY','.',DBG_Histo.Columns[i].Caption);
              end;
              ftInteger :
              begin
                Header.Add(DBG_Histo.Columns[i].FieldName,6,alLeft,fmInteger,'','.',DBG_Histo.Columns[i].Caption);
              end;
              else
                Header.Add(DBG_Histo.Columns[i].FieldName,DBG_Histo.Columns[i].Field.Size,alLeft,fmNone,'','.',DBG_Histo.Columns[i].Caption);
            end;  //case
      end;  //for
      try
        screen.cursor := CrHourGlass;
        Ds_Histo.DataSet.DisableControls;
        try
          bm := Ds_Histo.DataSet.GetBookMark;

          if Header.ConvertToCsv(DBG_Histo,sFileName)=1 then
            ShowMessage('Création du fichier réussit : ' + sFileName)
          else if Header.ConvertToCsv(DBG_Histo,sFileName)=0 then
            ShowMessage('Aucune données à exporter dans le fichier : ' + sFileName)
          else
            ShowMessage('Echec de création du fichier : ' + sFileName);

          Ds_Histo.DataSet.GotoBookmark(bm);
          Ds_Histo.DataSet.FreeBookmark(bm);
          bm := nil;
        except
          Ds_Histo.DataSet.EnableControls;
          bm:= nil;
          exit;
        end;  //try ... except
      finally
        Ds_Histo.DataSet.EnableControls;
        screen.cursor := CrDefault;
      end;  //try ... finally
    Except on E:Exception do
      raise Exception.Create('DoMemStockToCsv -> ' + E.Message);
    end;  //try ... except
  finally
    Header.Free;
  end;  //try ... finally
end;

procedure TFrm_Histo.Pan_BtnEnter(Sender: TObject);
begin
  Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_Histo.Pan_BtnExit(Sender: TObject);
begin
  Nbt_Post.Font.style := [];
end;

END.

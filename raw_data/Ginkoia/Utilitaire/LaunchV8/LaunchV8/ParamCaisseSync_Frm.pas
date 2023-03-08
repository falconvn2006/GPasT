unit ParamCaisseSync_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, dxDBGrid, dxCntner, DB,
  IBCustomDataSet, IBQuery, StdCtrls, ExtCtrls, Buttons, Mask, IBDatabase, uLog;

type
  TFrm_ParamCaisseSync = class(TForm)
    panButtons: TPanel;
    btnFermer: TButton;
    Panel1: TPanel;
    Ds_Caisses: TDataSource;
    queCaisses: TIBQuery;
    dxDBGrid1: TdxDBGrid;
    dxDBGrid1Column1: TdxDBGridColumn;
    dxDBGrid1Column2: TdxDBGridCheckColumn;
    dxDBGrid1Column3: TdxDBGridTimeColumn;
    lbBase: TLabel;
    ckCaisse: TCheckBox;
    lbSyncTime: TLabel;
    edSyncTime: TMaskEdit;
    lbServerUNC: TLabel;
    edServerUNC: TEdit;
    btServerUNC: TSpeedButton;
    odServerUNC: TOpenDialog;
    btEnregistrer: TButton;
    btCancel: TButton;
    lbCaisse: TLabel;
    queTmp: TIBQuery;
    traTmp: TIBTransaction;
    queCaissesPRM_TIME: TStringField;
    queCaissesPRM_ID: TIntegerField;
    queCaissesPRM_INTEGER: TIntegerField;
    queCaissesPRM_FLOAT: TFloatField;
    queCaissesPRM_STRING: TIBStringField;
    queCaissesBAS_SENDER: TIBStringField;
    procedure FormShow(Sender: TObject);
    procedure btnFermerClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btServerUNCClick(Sender: TObject);
    procedure queCaissesAfterScroll(DataSet: TDataSet);
    procedure ckCaisseClick(Sender: TObject);
    procedure edSyncTimeChange(Sender: TObject);
    procedure edServerUNCChange(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btEnregistrerClick(Sender: TObject);
    procedure queCaissesCalcFields(DataSet: TDataSet);
  private
    FPrmId    : Int64 ;
    FModified : boolean  ;

    procedure setModified(aValue: boolean);
    procedure editLine;
    procedure storeLine;
    procedure refreshCaisses;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ParamCaisseSync: TFrm_ParamCaisseSync;

procedure ExecuteParamCaisseSync() ;

implementation
{$R *.dfm}

uses Launchv7_Dm ;

procedure ExecuteParamCaisseSync() ;
begin
  Frm_ParamCaisseSync.ShowModal ;
end;

procedure TFrm_ParamCaisseSync.btCancelClick(Sender: TObject);
begin
  editLine ;
end;

procedure TFrm_ParamCaisseSync.btEnregistrerClick(Sender: TObject);
begin
  storeLine ;
end;

procedure TFrm_ParamCaisseSync.btnFermerClick(Sender: TObject);
begin
  Close() ;
end;

procedure TFrm_ParamCaisseSync.btServerUNCClick(Sender: TObject);
begin
  if odServerUNC.Execute then
  begin
    edServerUNC.Text := ExpandFileName(odServerUNC.FileName) ;
  end;
end;

procedure TFrm_ParamCaisseSync.ckCaisseClick(Sender: TObject);
begin
  setModified(true);
end;

procedure TFrm_ParamCaisseSync.edServerUNCChange(Sender: TObject);
begin
  setModified(true);
end;

procedure TFrm_ParamCaisseSync.edSyncTimeChange(Sender: TObject);
begin
  setModified(true) ;
end;

procedure TFrm_ParamCaisseSync.FormHide(Sender: TObject);
begin
  queCaisses.Close ;
end;

procedure TFrm_ParamCaisseSync.FormShow(Sender: TObject);
begin
  FPrmId := 0;

  Log.Log('ParamCaisseSync_Frm', 'FormShow', 'Log', 'queCaisses (avant).', logDebug, True, 0, ltLocal);
  queCaisses.Open;
  Log.Log('ParamCaisseSync_Frm', 'FormShow', 'Log', 'queCaisses (après).', logDebug, True, 0, ltLocal);
end;

procedure TFrm_ParamCaisseSync.setModified(aValue : boolean) ;
begin
  FModified             := aValue ;
  btEnregistrer.Enabled := aValue ;
  btCancel.Enabled      := aValue ;
  dxDBGrid1.Enabled     := not aValue ;
  btnFermer.Enabled     := not aValue ;
end;

procedure TFrm_ParamCaisseSync.editLine ;
begin
  FPrmId         := queCaisses.FieldByName('PRM_ID').AsLargeInt ;
  lbBase.Caption := queCaisses.FieldByName('BAS_SENDER').AsString ;
  ckCaisse.Checked := (queCaisses.FieldByName('PRM_INTEGER').AsInteger = 1) ;
  edSyncTime.Text  := FormatDateTime('hh:nn:ss',TDateTime(queCaisses.FieldByName('PRM_FLOAT').AsFloat)) ;
  edServerUNC.Text := queCaisses.FieldByName('PRM_STRING').asString ;
  setModified(false) ;
end;

procedure TFrm_ParamCaisseSync.storeLine;
var
  vTime : TTime ;
  vPrmId : Int64 ;
begin
  if Fmodified then
  begin
    if fPrmId < 1 then Exit ;

    try
      Log.Log('ParamCaisseSync_Frm', 'storeLine', 'Log', 'update GENPARAM (avant).', logDebug, True, 0, ltLocal);

      queTmp.SQL.Text := 'UPDATE GENPARAM SET PRM_INTEGER = :INTEGER, PRM_FLOAT = :FLOAT, PRM_STRING = :STRING  ' +
                         'WHERE PRM_ID = :PRMID' ;

      if ckCaisse.Checked
        then queTmp.ParamByName('INTEGER').AsInteger := 1
        else queTmp.ParamByName('INTEGER').AsInteger := 0 ;

      vTime := StrToTime(edSyncTime.Text) ;
      queTmp.ParamByName('FLOAT').AsFloat := Frac(vTime) ;
      queTmp.ParamByName('STRING').AsString := edServerUNC.Text ;
      queTmp.ParamByName('PRMID').AsInteger := fPrmId ;
      queTmp.ExecSQL;

      Log.Log('ParamCaisseSync_Frm', 'storeLine', 'Log', 'update GENPARAM (après).', logDebug, True, 0, ltLocal);
      Log.Log('ParamCaisseSync_Frm', 'storeLine', 'Log', 'execute procedure PR_UPDATEK (avant).', logDebug, True, 0, ltLocal);

      queTmp.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:PRMID, 0)' ;
      queTmp.ParamByName('PRMID').AsInteger := fPrmId ;
      queTmp.ExecSQL;

      Log.Log('ParamCaisseSync_Frm', 'storeLine', 'Log', 'execute procedure PR_UPDATEK (après).', logDebug, True, 0, ltLocal);

      queTmp.Transaction.Commit;

      setModified(false);
    except
      on E:Exception do
      begin
        queTmp.Transaction.Rollback ;
        showMessage('Mise à jour impossible : ' + E.Message) ;
      end ;
    end;

    refreshCaisses ;
  end;
end;

procedure TFrm_ParamCaisseSync.refreshCaisses;
begin
  Log.Log('ParamCaisseSync_Frm', 'refreshCaisses', 'Log', 'queCaisses (avant).', logDebug, True, 0, ltLocal);
  queCaisses.Close;
  queCaisses.Open;
  Log.Log('ParamCaisseSync_Frm', 'refreshCaisses', 'Log', 'queCaisses (après).', logDebug, True, 0, ltLocal);

  dxDBGrid1.Refresh;
end;

procedure TFrm_ParamCaisseSync.queCaissesAfterScroll(DataSet: TDataSet);
begin
  EditLine ;
end;

procedure TFrm_ParamCaisseSync.queCaissesCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('PRM_TIME').asString := FormatDateTime('hh:nn:ss', DataSet.FieldByName('PRM_FLOAT').AsFloat) ;
end;

end.


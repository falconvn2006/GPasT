unit FrmDlgSteClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, DB, ComCtrls, StdCtrls, Mask, DBCtrls, Buttons,
  ExtCtrls, dmdClient, DBClient;

type
  TDlgSteCltFrm = class(TCustomGinkoiaDlgFrm)
    DBEDT_SOCIETE: TDBEdit;
    Lab_1: TLabel;
    DTP_FINEXERCICE: TDateTimePicker;
    Lab_2: TLabel;
    DsSociete: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FdmClient: TdmClient;
    FDOSS_ID: integer;
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
    property DOSS_ID: integer read FDOSS_ID write FDOSS_ID;
  end;

var
  DlgSteCltFrm: TDlgSteCltFrm;

implementation

uses dmdClients, uConst, uTool;

{$R *.dfm}

procedure TDlgSteCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
end;

procedure TDlgSteCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsSociete.DataSet:= FdmClient.CDS_SOC;

  case AAction of
    ukModify:
      begin
        DsSociete.DataSet.Edit;
        DTP_FINEXERCICE.Date:= FdmClient.CDS_SOC.FieldByName('SOC_CLOTURE').AsDateTime;
      end;
    ukInsert:
      begin
        DsSociete.DataSet.Append;
      end;
  end;
end;

function TDlgSteCltFrm.PostValues: Boolean;
var
  vSL: TStringList;
begin
  Result:= inherited PostValues;
  vSL:= TStringList.Create;
  try
    try
      vSL.Append('DOSS_ID');
      vSL.Append('SOC_ID');
      vSL.Append('SOC_NOM');
      vSL.Append('SOC_CLOTURE');
      vSL.Append('SOC_SSID');
      vSL.Append('ACTION');

      if DsSociete.DataSet.State = dsBrowse then
        DsSociete.DataSet.Edit;

      if AAction = ukInsert then
        DsSociete.DataSet.FieldByName('DOSS_ID').AsInteger:= FDOSS_ID;

      DsSociete.DataSet.FieldByName('SOC_CLOTURE').AsDateTime:= DTP_FINEXERCICE.Date;

      case AAction of     //SR :
        ukModify : DsSociete.DataSet.FieldByName('ACTION').AsInteger:= cActionModify;
        ukInsert : DsSociete.DataSet.FieldByName('ACTION').AsInteger:= cActionInsert;
        ukDelete : DsSociete.DataSet.FieldByName('ACTION').AsInteger:= cActionDelete;
      end;

      dmClients.PostRecordToXml('Societe', 'TSociete', TClientDataSet(DsSociete.DataSet), vSL);
      DsSociete.DataSet.Post;
      Result:= True;
    except
      Raise;
    end;
  finally
    FreeAndNil(vSL);
  end;
end;

end.

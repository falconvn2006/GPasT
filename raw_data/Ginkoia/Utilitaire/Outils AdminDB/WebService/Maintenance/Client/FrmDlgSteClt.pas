unit FrmDlgSteClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, DB, ComCtrls, StdCtrls, Mask, DBCtrls, Buttons,
  ExtCtrls, dmdClient;

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
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
  end;

var
  DlgSteCltFrm: TDlgSteCltFrm;

implementation

uses dmdClients, uTool;

{$R *.dfm}

procedure TDlgSteCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
end;

procedure TDlgSteCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsSociete.DataSet:= FdmClient.CDS_SOCMAGPOS;
  if AAction = ukModify then
    DTP_FINEXERCICE.Date:= FdmClient.CDS_SOCMAGPOS.FieldByName('SOC_CLOTURE').AsDateTime
  else
    if (AAction = ukInsert) and (DsSociete.DataSet.State = dsBrowse) then
       DsSociete.DataSet.Insert;
end;

function TDlgSteCltFrm.PostValues: Boolean;
var
  vSL: TStringList;
begin
  Result:= inherited PostValues;
  vSL:= TStringList.Create;
  try
    try
      vSL.Append('DOS_ID');
      vSL.Append('SOC_ID');
      vSL.Append('SOC_NOM');
      vSL.Append('SOC_CLOTURE');
      vSL.Append('SOC_SSID');

      if (AAction = ukModify) and (DsSociete.DataSet.State = dsBrowse) then
        DsSociete.DataSet.Edit;

      DsSociete.DataSet.FieldByName('SOC_CLOTURE').AsDateTime:= DTP_FINEXERCICE.Date;

      dmClients.PostRecordToXml('Societe', 'TSociete', FdmClient.CDS_SOCMAGPOS, vSL);
      DsSociete.DataSet.Post;
      dmClients.XmlToDataSet('SteMagPoste?DOS_ID=' + IntToStr(FdmClient.DOS_ID), FdmClient.CDS_SOCMAGPOS);
      Result:= True;
    except
      Raise;
    end;
  finally
    FreeAndNil(vSL);
  end;
end;

end.

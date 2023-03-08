unit FrmDlgPosteClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Mask, DBCtrls, Buttons, ExtCtrls, DB,
  dmdClient;

type
  TDlgPosteCltFrm = class(TCustomGinkoiaDlgFrm)
    Lab_1: TLabel;
    DBEDT_POSTE: TDBEdit;
    DsPoste: TDataSource;
    Lab_2: TLabel;
    Lab_3: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
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
  DlgPosteCltFrm: TDlgPosteCltFrm;

implementation

uses dmdClients;

{$R *.dfm}

procedure TDlgPosteCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
end;

procedure TDlgPosteCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsPoste.DataSet:= FdmClient.CDS_SOCMAGPOS;
end;

function TDlgPosteCltFrm.PostValues: Boolean;
var
  vSL: TStringList;
begin
  Result:= inherited PostValues;
  vSL:= TStringList.Create;
  try
    try
      if Trim(DBEDT_POSTE.Text) = '' then
        Raise Exception.Create('Le nom du poste est obligatoire.');

      vSL.Append('DOS_ID');
      vSL.Append('MAG_ID');
      vSL.Append('POS_ID');
      vSL.Append('POS_NOM');
      vSL.Append('POS_MAGID');

      FdmClient.CDS_SOCMAGPOS.FieldByName('POS_NOM').AsString:= DBEDT_POSTE.Text;

      dmClients.PostRecordToXml('Poste', 'TPoste', FdmClient.CDS_SOCMAGPOS, vSL);
      DsPoste.DataSet.Post;
      Result:= True;
      dmClients.XmlToDataSet('SteMagPoste?DOS_ID=' + IntToStr(FdmClient.DOS_ID), FdmClient.CDS_SOCMAGPOS);
    except
      Raise;
    end;
  finally
    FreeAndNil(vSL);
  end;
end;

end.

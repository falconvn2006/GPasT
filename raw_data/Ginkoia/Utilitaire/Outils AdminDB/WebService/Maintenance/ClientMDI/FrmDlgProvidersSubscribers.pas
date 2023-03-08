unit FrmDlgProvidersSubscribers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Buttons, ExtCtrls, dmdClient, Mask,
  DBCtrls, DB, DBClient;

type
  TTypeProSub = (tpsPRO, tpsSUB);

  TDlgProvidersSubscribersFrm = class(TCustomGinkoiaDlgFrm)
    Lab_1: TLabel;
    Lab_2: TLabel;
    DsPROSUB: TDataSource;
    DBEdtNom: TDBEdit;
    DBEdtLoop: TDBEdit;
    procedure DBEdtLoopKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FdmClient: TdmClient;
    FATypeProSub: TTypeProSub;
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
    property ATypeProSub: TTypeProSub read FATypeProSub write FATypeProSub;
  end;

var
  DlgProvidersSubscribersFrm: TDlgProvidersSubscribersFrm;

implementation

uses uTool, dmdClients;

{$R *.dfm}

procedure TDlgProvidersSubscribersFrm.DBEdtLoopKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  NumberEditKeyPress(Key, False);
end;

procedure TDlgProvidersSubscribersFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
end;

procedure TDlgProvidersSubscribersFrm.FormShow(Sender: TObject);
begin
  inherited;
  case ATypeProSub of
    tpsPRO:
      begin
        DsPROSUB.DataSet:= FdmClient.CDS_GENPROVIDERS_D;
        DBEdtNom.DataField:= 'PRO_NOM';
        DBEdtLoop.DataField:= 'PRO_LOOP';
      end;
    tpsSUB:
      begin
        DsPROSUB.DataSet:= FdmClient.CDS_GENSUBSCRIBERS_D;
        DBEdtNom.DataField:= 'SUB_NOM';
        DBEdtLoop.DataField:= 'SUB_LOOP';
      end;
  end;
end;

function TDlgProvidersSubscribersFrm.PostValues: Boolean;
begin
  Result:= inherited PostValues;

  try
    if DBEdtNom.Field.IsNull then
      Raise Exception.Create('Le nom est obligatoire.');

    DsPROSUB.DataSet.FieldByName('DOSS_ID').AsInteger:= FdmClient.CDS_EMETTEUR.FieldByName('EMET_DOSSID').AsInteger;

    case ATypeProSub of
      tpsPRO: dmClients.PostRecordToXml('GenProviders', 'TGnkGenProviders', TClientDataSet(DsPROSUB.DataSet));
      tpsSUB: dmClients.PostRecordToXml('GenSubscribers', 'TGnkGenSubscribers', TClientDataSet(DsPROSUB.DataSet));
    end;

    DsPROSUB.DataSet.Post;

    Result:= True;
  except
    Raise;
  end;
end;

end.

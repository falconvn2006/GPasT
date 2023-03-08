unit FrmDlgConnexionClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, DBCtrls, Mask, Buttons, ExtCtrls,
  dmdClient, DB;

type
  TDlgConnexionCltFrm = class(TCustomGinkoiaDlgFrm)
    Lab_9: TLabel;
    Lab_10: TLabel;
    DBEDT_NOMCONNEXION: TDBEdit;
    DBEDT_TELCONNEXION: TDBEdit;
    DBChkBxType: TDBCheckBox;
    DsConnexion: TDataSource;
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
  DlgConnexionCltFrm: TDlgConnexionCltFrm;

implementation

uses dmdClients;

{$R *.dfm}

procedure TDlgConnexionCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
end;

procedure TDlgConnexionCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsConnexion.DataSet:= FdmClient.CDS_GENCONNEXION;
end;

function TDlgConnexionCltFrm.PostValues: Boolean;
begin
  Result:= inherited PostValues;
  try
    try
      dmClients.PostRecordToXml('Connexion', 'TConnexion', FdmClient.CDS_GENCONNEXION);
      FdmClient.CDS_GENCONNEXION.Post;
      Result:= True;
    except
      Raise;
    end;
  finally
    //-->
  end;
end;

end.

unit untConfigPesquisa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dxGDIPlusClasses, ExtCtrls, Buttons, DB, IBCustomDataSet,
  Grids, Wwdbigrd, Wwdbgrid, Mask, wwdbedit, DBCtrls, Wwdotdot, Wwdbcomb,
  IBQuery, wwdblook;

type
  TfrmConfigPesquisa = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Panel_btns_cad: TPanel;
    btn_ok: TSpeedButton;
    dseConfig: TIBDataSet;
    dsConfig: TDataSource;
    Panel2: TPanel;
    wwDBGrid1: TwwDBGrid;
    dseContas: TIBDataSet;
    dtsContas: TDataSource;
    wwDBEdit2: TwwDBEdit;
    DBText1: TDBText;
    Label2: TLabel;
    wwDBLookupCombo1: TwwDBLookupCombo;
    qryFields: TIBQuery;
    dseConfigTABELA: TIBStringField;
    dseConfigTITULO: TIBStringField;
    dseContasTABELA: TIBStringField;
    dseContasORDEM: TIntegerField;
    dseContasFIELDNAME: TIBStringField;
    dseContasTITULO: TIBStringField;
    Label3: TLabel;
    wwDBLookupCombo2: TwwDBLookupCombo;
    dseConfigCAMPOPESQUISAINCREMENTAL: TIBStringField;
    qryFields2: TIBQuery;
    qryFieldsFIELDNAME: TIBStringField;
    qryFields2FIELDNAME: TIBStringField;
    procedure FormShow(Sender: TObject);
    procedure dseConfigBeforePost(DataSet: TDataSet);
    procedure dseContasBeforePost(DataSet: TDataSet);
    procedure dseContasBeforeDelete(DataSet: TDataSet);
    procedure btn_okClick(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
    procedure dseConfigAfterOpen(DataSet: TDataSet);
    procedure dseContasNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfigPesquisa: TfrmConfigPesquisa;

implementation

{$R *.dfm}

uses untDados;

procedure TfrmConfigPesquisa.btn_okClick(Sender: TObject);
begin

  if dseContas.State in [dsInsert, dsEdit] then
    dseContas.Post;

  if not dseContas.Locate('FIELDNAME',dseConfigCAMPOPESQUISAINCREMENTAL.AsString,[]) then
  begin
    Application.MessageBox('Campo de Pesquisa Incremental deve estar contido na Lista de Colunas da Pesquisa.',
       'Campo Pesquisa Incremental inválido',MB_OK+MB_ICONERROR);
    Abort;
  end;

  if dseConfig.State in [dsInsert, dsEdit] then
    dseConfig.Post;

  Close;
end;

procedure TfrmConfigPesquisa.btn_sairClick(Sender: TObject);
begin
  CLOSE;
end;

procedure TfrmConfigPesquisa.dseConfigAfterOpen(DataSet: TDataSet);
begin
  dseContas.close;
  dseContas.Open;
end;

procedure TfrmConfigPesquisa.dseConfigBeforePost(DataSet: TDataSet);
begin
  Dados.IBTransaction.CommitRetaining;
end;

procedure TfrmConfigPesquisa.dseContasBeforeDelete(DataSet: TDataSet);
begin
  Dados.IBTransaction.CommitRetaining;
end;

procedure TfrmConfigPesquisa.dseContasBeforePost(DataSet: TDataSet);
begin
  Dados.IBTransaction.CommitRetaining;
end;

procedure TfrmConfigPesquisa.dseContasNewRecord(DataSet: TDataSet);
begin
  dseContasTABELA.AsString := dseConfigTABELA.AsString;
end;

procedure TfrmConfigPesquisa.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;

  qryFields.Close;
  qryFields.Open;

  qryFields2.Close;
  qryFields2.Open;
  
  dseConfig.Close;
  dseConfig.Open;

  if dseConfig.IsEmpty then
    dseConfig.Insert;
end;

end.

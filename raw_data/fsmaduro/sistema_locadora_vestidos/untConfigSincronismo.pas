unit untConfigSincronismo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dxGDIPlusClasses, ExtCtrls, Buttons, DB, IBCustomDataSet,
  Grids, Wwdbigrd, Wwdbgrid, Mask, wwdbedit, DBCtrls, Wwdotdot, Wwdbcomb;

type
  TfrmConfigSincronismo = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Panel_btns_cad: TPanel;
    btn_ok: TSpeedButton;
    dseConfig: TIBDataSet;
    dsConfig: TDataSource;
    dseConfigINTERVALO: TIntegerField;
    dseConfigAGENDASDEPRODUTOS: TIntegerField;
    dseConfigAGENDASDEPEDIDOS: TIntegerField;
    dseConfigAGENDASDERETIRADA: TIntegerField;
    dseConfigAGENDASDEDEVOLUCAO: TIntegerField;
    dseConfigAGENDASDESERVICO: TIntegerField;
    Panel2: TPanel;
    wwDBGrid1: TwwDBGrid;
    dseContas: TIBDataSet;
    dtsContas: TDataSource;
    dseContasUSERNAME: TIBStringField;
    dseContasSENHA: TIBStringField;
    wwDBEdit1: TwwDBEdit;
    Label2: TLabel;
    wwDBEdit2: TwwDBEdit;
    Label3: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    dseContasREMINDER_METODO: TIntegerField;
    dseContasREMINDER_VALOR: TIntegerField;
    dseContasREMINDER_PERIODO: TIntegerField;
    cmbPeriodo: TwwDBComboBox;
    cmbMetodo: TwwDBComboBox;
    procedure FormShow(Sender: TObject);
    procedure dseConfigBeforePost(DataSet: TDataSet);
    procedure dseContasBeforePost(DataSet: TDataSet);
    procedure dseContasBeforeDelete(DataSet: TDataSet);
    procedure btn_okClick(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfigSincronismo: TfrmConfigSincronismo;

implementation

{$R *.dfm}

uses untDados;

procedure TfrmConfigSincronismo.btn_okClick(Sender: TObject);
begin
  if dseConfig.State in [dsInsert, dsEdit] then
    dseConfig.Post;

  if dseContas.State in [dsInsert, dsEdit] then
    dseContas.Post;

  Close;
end;

procedure TfrmConfigSincronismo.btn_sairClick(Sender: TObject);
begin
  CLOSE;
end;

procedure TfrmConfigSincronismo.dseConfigBeforePost(DataSet: TDataSet);
begin
  Dados.IBTransaction.CommitRetaining;
end;

procedure TfrmConfigSincronismo.dseContasBeforeDelete(DataSet: TDataSet);
begin
  Dados.IBTransaction.CommitRetaining;
end;

procedure TfrmConfigSincronismo.dseContasBeforePost(DataSet: TDataSet);
begin
  Dados.IBTransaction.CommitRetaining;
end;

procedure TfrmConfigSincronismo.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  
  dseConfig.Close;
  dseConfig.Open;

  dseContas.close;
  dseContas.Open;

  if dseConfig.IsEmpty then
    dseConfig.Insert;
end;

end.

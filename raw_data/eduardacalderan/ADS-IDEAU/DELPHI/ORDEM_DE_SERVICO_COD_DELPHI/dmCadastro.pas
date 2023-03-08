unit dmCadastro;

// Observações Importantes:
// - Data Module que será herdado para os cadastros.
// - Procedures públicas
// - Eventos no DataModule e em cdsCadastro

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Datasnap.DBClient,
  Datasnap.Provider, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Dialogs, System.UITypes;

type
  TdtmCadastro = class(TDataModule)
    fdqCadastro: TFDQuery;
    dspCadastro: TDataSetProvider;
    cdsCadastro: TClientDataSet;
    fdqConsulta: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsCadastroAfterPost(DataSet: TDataSet);
    procedure cdsCadastroAfterDelete(DataSet: TDataSet);
    procedure cdsCadastroReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo;
    procedure Gravar;
    procedure Excluir;
    procedure Cancelar;
    procedure sqlProcura(SQL: String); // utilizada na consulta
  end;

var
  dtmCadastro: TdtmCadastro;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dmConexao, mensagens;

{$R *.dfm}

procedure TdtmCadastro.Cancelar;
begin
  if cdsCadastro.State in dsEditModes then
    cdsCadastro.Cancel;
end;

procedure TdtmCadastro.cdsCadastroAfterDelete(DataSet: TDataSet);
begin
  if cdsCadastro.ChangeCount > 0 then
  begin
    cdsCadastro.ApplyUpdates(0);
  end;
end;

procedure TdtmCadastro.cdsCadastroAfterPost(DataSet: TDataSet);
begin
  if cdsCadastro.ChangeCount > 0 then
  begin
    cdsCadastro.ApplyUpdates(0);
  end;
end;

procedure TdtmCadastro.cdsCadastroReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  ShowMessage(e.Message); // mostra erro ao aplicar os dados.
  Action := raCancel;
end;

procedure TdtmCadastro.DataModuleCreate(Sender: TObject);
begin
  cdsCadastro.Close;
  cdsCadastro.Open;
end;

procedure TdtmCadastro.Excluir;
begin
  if not(cdsCadastro.State in dsEditModes) then
  begin
    if MessageDlg(CONFIRMA_EXCLUSAO, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      cdsCadastro.Delete;
    end;
  end;
end;

procedure TdtmCadastro.Gravar;
begin
  if cdsCadastro.State in dsEditModes then
    cdsCadastro.Post;
end;

procedure TdtmCadastro.Novo;
begin
  if not(cdsCadastro.State in dsEditModes) then
    cdsCadastro.Append;
end;

procedure TdtmCadastro.sqlProcura(SQL: String);
begin
  fdqConsulta.Close;
  fdqConsulta.SQL.Text := SQL;
  fdqConsulta.Open;
end;

end.

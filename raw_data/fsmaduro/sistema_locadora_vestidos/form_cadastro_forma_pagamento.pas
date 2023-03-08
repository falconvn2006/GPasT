unit form_cadastro_forma_pagamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  wwdbedit, Wwdotdot, Wwdbcomb, wwdblook, Grids, Wwdbigrd, Wwdbgrid, RxLookup;

type
  Tcadastro_forma_pagamento = class(TForm)
    lblCodigo: TLabel;
    lblNome: TLabel;
    Label30: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    edtCodigo: TDBEdit;
    edtNome: TDBEdit;
    Panel2: TPanel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsFormaPagamento: TDataSource;
    qryFormaPagamento: TIBQuery;
    updFormaPagamento: TIBUpdateSQL;
    Image1: TImage;
    qryFormaPagamentoCODIGO: TIntegerField;
    qryFormaPagamentoDESCRICAO: TIBStringField;
    qryFormaPagamentoParcelas: TIBQuery;
    dtsFormaPagamentoParcelas: TDataSource;
    updFormaPagamentoParcelas: TIBUpdateSQL;
    qryFormaPagamentoParcelasCODIGOFORMAPAGAMENTO: TIntegerField;
    qryFormaPagamentoParcelasPARCELA: TIntegerField;
    qryFormaPagamentoParcelasCODIGOTIPODOCUMENTO: TIntegerField;
    qryFormaPagamentoParcelasPORCENTAGEM: TIBBCDField;
    dtsTipodocumento: TDataSource;
    qryTipoDocumento: TIBQuery;
    qryTipoDocumentoCODIGO: TIntegerField;
    qryTipoDocumentoNOME: TIBStringField;
    GroupBox1: TGroupBox;
    grdDetalhe: TwwDBGrid;
    qryFormaPagamentoParcelasNOMETIPODOCUMENTO: TStringField;
    wwDBLookupCombo1: TwwDBLookupCombo;
    qryFormaPagamentoParcelasDIASPARAVENCER: TIntegerField;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryFormaPagamentoAfterPost(DataSet: TDataSet);
    procedure qryFormaPagamentoBeforeDelete(DataSet: TDataSet);
    procedure qryFormaPagamentoBeforePost(DataSet: TDataSet);
    procedure qryFormaPagamentoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsFormaPagamentoStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryFormaPagamentoParcelasNewRecord(DataSet: TDataSet);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  cadastro_forma_pagamento: Tcadastro_forma_pagamento;

implementation

uses untPesquisa, untDados, versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_forma_pagamento.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin 
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_forma_pagamento.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
begin 
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0;
    ControleVersao.ShowAlteracoes(self.Name);
  end
  else
    inherited;
end;
//FIM BOTÃO HELP

procedure Tcadastro_forma_pagamento.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_forma_pagamento.dtsFormaPagamentoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_forma_pagamento.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryFormaPagamento.State in [dsInsert, dsEdit] then
       qryFormaPagamento.Post;
  end;
end;

procedure Tcadastro_forma_pagamento.btn_novoClick(Sender: TObject);
begin
  if dtsFormaPagamento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryFormaPagamento.Post;
  end;
  qryFormaPagamento.Insert;
end;

procedure Tcadastro_forma_pagamento.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsFormaPagamento, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryFormaPagamento.Delete;
end;

procedure Tcadastro_forma_pagamento.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABFORMAPAGAMENTO';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := edtNome.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := lblNome.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryFormaPagamento.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryFormaPagamentoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_forma_pagamento.qryFormaPagamentoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure Tcadastro_forma_pagamento.qryFormaPagamentoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryFormaPagamentoCODIGO.Text + ' Nome: '+qryFormaPagamentoDESCRICAO.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_forma_pagamento.qryFormaPagamentoBeforePost(DataSet: TDataSet);
begin
  IF qryFormaPagamentoCODIGO.Value = 0 THEN
    qryFormaPagamentoCODIGO.Value := Dados.NovoCodigo('TABFORMAPAGAMENTO');
  if dtsFormaPagamento.State = dsInsert then
    dados.Log(3, 'Código: '+ qryFormaPagamentoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsFormaPagamento.State = dsEdit then
    dados.Log(4, 'Código: '+ qryFormaPagamentoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_forma_pagamento.qryFormaPagamentoNewRecord(DataSet: TDataSet);
begin
  qryFormaPagamentoCODIGO.Value := 0;
end;

procedure Tcadastro_forma_pagamento.qryFormaPagamentoParcelasNewRecord(
  DataSet: TDataSet);
begin
  qryFormaPagamentoParcelasCODIGOFORMAPAGAMENTO.AsInteger := qryFormaPagamentoCODIGO.AsInteger;
end;

procedure Tcadastro_forma_pagamento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsFormaPagamento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryFormaPagamento.Post;
  end;
  qryFormaPagamento.Close;
end;

procedure Tcadastro_forma_pagamento.FormCreate(Sender: TObject);
begin
  NomeMenu := 'FormadePagamento1';
end;

procedure Tcadastro_forma_pagamento.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    qryFormaPagamento.Close;
    qryFormaPagamento.Open;

    qryFormaPagamentoParcelas.Close;
    qryFormaPagamentoParcelas.Open;

    qryTipoDocumento.Close;
    qryTipoDocumento.Open;

    Dados.NovoRegistro(qryFormaPagamento);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_forma_pagamento.SpeedButton5Click(Sender: TObject);
begin
  if dtsFormaPagamento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryFormaPagamento.Post;
  end;
  qryFormaPagamento.First;
end;

procedure Tcadastro_forma_pagamento.SpeedButton2Click(Sender: TObject);
begin
  if dtsFormaPagamento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryFormaPagamento.Post;
  end;
  qryFormaPagamento.Prior;
end;

procedure Tcadastro_forma_pagamento.SpeedButton4Click(Sender: TObject);
begin
  if dtsFormaPagamento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryFormaPagamento.Post;
  end;
  qryFormaPagamento.Next;
end;

procedure Tcadastro_forma_pagamento.SpeedButton1Click(Sender: TObject);
begin
  if dtsFormaPagamento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryFormaPagamento.Post;
  end;
  qryFormaPagamento.Last;
end;

procedure Tcadastro_forma_pagamento.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.

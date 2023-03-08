unit untCadastroAgenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, RxLookup, DB, IBCustomDataSet, IBQuery,
  StdCtrls, wwdbdatetimepicker, dxGDIPlusClasses, ExtCtrls, cxButtons, Buttons;

type
  TfrmCadastroAgenda = class(TForm)
    Panel2: TPanel;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label38: TLabel;
    edtData: TwwDBDateTimePicker;
    Label37: TLabel;
    edtHora: TwwDBDateTimePicker;
    Label3: TLabel;
    edtHoraFim: TwwDBDateTimePicker;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    qryProduto: TIBQuery;
    qryProdutoCODIGO: TIntegerField;
    qryProdutoDESCRICAO: TIBStringField;
    dtsProduto: TDataSource;
    Label27: TLabel;
    cbPerfil: TRxDBLookupCombo;
    Label4: TLabel;
    cbProduto: TRxDBLookupCombo;
    SpeedButton7: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    lblMotivoReagendar: TLabel;
    mmDescricao: TMemo;
    mmMotivoReagendar: TMemo;
    procedure FormShow(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure edtHoraExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    vTempoMinimo : TTime;
    { Private declarations }
  public
    reAgendar : Boolean;
    CodigoAgenda: Integer;
    PedidoAgenda: Integer;
    vConfigFlaxibilidadeAgenda : TTime;
    vConfigTempoAgendaPessoa   : TTime;
    vQtdMaximaClientesHorario  : Integer;
    { Public declarations }
  end;

var
  frmCadastroAgenda: TfrmCadastroAgenda;

implementation

uses untDados, form_cadastro_produto, form_cadastro_perfil, funcao, versao;

{$R *.dfm}

procedure TfrmCadastroAgenda.cxButton2Click(Sender: TObject);
var
  Produto: String;
  Perfil,idEvento: String;
  cNovaAgenda : Integer;

  vTextoAgenda: String;
  vHoraFimCalc: TTime;
  cQtdPessoasPedido : Integer;

  xSumTime: TTime;
begin
  if Application.MessageBox('Deseja Realmente Efetuar Agendamento?','Agendar',MB_YESNO+MB_ICONQUESTION) = IDYES THEN
  begin
    if reAgendar and (mmMotivoReagendar.Text = '') then
    begin
      application.messagebox('Motivo é Obrigatório para Reagendamento','Motivo não Informado',MB_OK+MB_ICONEXCLAMATION);
      Abort;
    end;

    if reAgendar then
    begin
      Dados.Geral.Close;
      Dados.Geral.SQL.Text := 'SELECT * FROM TABAGENDA WHERE CODIGO =0'+intToStr(CodigoAgenda);
      Dados.Geral.Open;

      Produto  := Dados.Geral.FieldByName('CODIGOPRODUTO').Text;
      Perfil   := Dados.Geral.FieldByName('IDPERFIL').Text;
      idEvento := Dados.Geral.FieldByName('IDEVENTO').Text;

      if PedidoAgenda <= 0 then
         PedidoAgenda := Dados.Geral.FieldByName('IDPEDIDOAGENDA').AsInteger;

      Dados.Geral3.Close;
      Dados.Geral3.SQL.Text := 'SELECT COUNT(DISTINCT a.codigoperfil) as qtd FROM tabacompanhantespedidoagenda a WHERE a.codigopedido=0'+IntToStr(PedidoAgenda);
      Dados.Geral3.Open;
      cQtdPessoasPedido := Dados.Geral3.FieldByName('qtd').AsInteger;

      Dados.Geral3.Sql.Text := 'select COUNT(DISTINCT a.codigoperfil) as qtd from tabagenda ag '#13+
      ' inner join tabpedidoagendamento p on ag.idpedidoagenda = p.codigo '#13+
      ' inner join tabacompanhantespedidoagenda a on p.codigo = a.codigopedido '#13+
       'where COALESCE(ag.idpedidoagenda,0) > 0 and Coalesce(AG.situacao,1) <> 2 '#13+
       '  and ((ag.data = :data) and ((:horainicio + 1 between ag.hora and ag.horafim) '#13+
       '   or (:horafim between ag.hora and ag.horafim))) ';
      Dados.Geral3.ParamByName('data').AsDateTime       := edtData.Date;
      Dados.Geral3.ParamByName('horainicio').AsDateTime := edtHora.Time + vConfigFlaxibilidadeAgenda;
      Dados.Geral3.ParamByName('horafim').AsDateTime    := edtHoraFim.Time - vConfigFlaxibilidadeAgenda;
      Dados.Geral3.Open;

      if (Dados.Geral3.FieldByName('qtd').AsInteger > vQtdMaximaClientesHorario) or
         ((Dados.Geral3.FieldByName('qtd').AsInteger > 0) and (cQtdPessoasPedido > vQtdMaximaClientesHorario)) then
      begin
        application.MessageBox(Pchar('Já existe agenda para a data '+
                               FormatDateTime('dd/MM/yyyy', edtData.Date)+
                               ' de '+ FormatDateTime('hh:mm:ss', edtHora.Time)+
                               ' à '+ FormatDateTime('hh:mm:ss', edtHoraFim.Time)+'.'#13+
                               'Não é permitido agendar para esse pedido nessas condições.'),'Erro!',MB_OK+MB_ICONERROR);
        Abort;
      end;

      dados.CancelarAgenda(CodigoAgenda,mmMotivoReagendar.Text);

    end
    else
    begin
      Produto := VarToStrDef(cbProduto.KeyValue,'0');
      Perfil := VarToStrDef(cbPerfil.KeyValue,'0');
      idEvento := '0';
    end;

    xSumTime := StrToTime('00:00:30');

    cNovaAgenda := dados.Agendar(PedidoAgenda,StrToIntDef(Perfil,0),StrToIntDef(Produto,0),edtData.Date,edtData.Date,
                                 edtHora.Time+xSumTime,edtHoraFim.Time,mmDescricao.Text,StrToIntDef(idEvento,0));


    if reAgendar then
      dados.CopiarCaracteristicaAgenda(CodigoAgenda,cNovaAgenda,edtData.Date,edtHora.Time);

    Close;
  end;
end;

procedure TfrmCadastroAgenda.cxButton3Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja Realmente Cancelar Agendamento?','Cancelar',MB_YESNO+MB_ICONQUESTION) = IDYES THEN
    Close;
end;

procedure TfrmCadastroAgenda.edtHoraExit(Sender: TObject);
begin
  edtHoraFim.Time := edtHora.Time + vTempoMinimo;
end;

procedure TfrmCadastroAgenda.FormCreate(Sender: TObject);
begin
  edtData.Text := '';
  edtHora.Text := '';
  edtHoraFim.Text := '';
  PedidoAgenda := 0;
  CarregarImagem(Image1,'topo_painel.png');
end;

procedure TfrmCadastroAgenda.FormShow(Sender: TObject);
begin
  lblMotivoReagendar.Visible := reAgendar;
  mmMotivoReagendar.Visible := reAgendar;

  cbPerfil.Visible := not reAgendar;
  cbProduto.Visible := not reAgendar;
  SpeedButton7.Visible := not reAgendar;
  SpeedButton1.Visible := not reAgendar;
  Label27.Visible := not reAgendar;
  Label4.Visible := not reAgendar;

  vTempoMinimo := Dados.ValorConfig('frmAgenda','TEMPOMINIMO',StrToTime('00:30:00'),tcHora).vcTime;
  vConfigFlaxibilidadeAgenda := Dados.ValorConfig('cadastro_pedido_agenda','FLEXIBILIDADEAGENDA', StrToTime('00:05:00'),tcHora).vcTime;
  vConfigTempoAgendaPessoa   := Dados.ValorConfig('cadastro_pedido_agenda','TEMPOPORPERFIL', StrToTime('00:30:00'),tcHora).vcTime;
  vQtdMaximaClientesHorario  := Dados.ValorConfig('cadastro_pedido_agenda','QTDCLIENTESPORHORARIO', 0,tcInteiro).vcInteger;

  cbPerfil.KeyValue := -1;
  cbProduto.KeyValue := -1;
  mmDescricao.Clear;
  mmMotivoReagendar.Clear;

  try

    qryPerfil.Close;
    qryPerfil.Open;

    qryProduto.Close;
    qryProduto.Open;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmCadastroAgenda.SpeedButton1Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_produto') = Nil then
         Application.CreateForm(Tcadastro_produto, cadastro_produto);

  cadastro_produto.ShowModal;

  qryProduto.Close;
  qryProduto.Open;
end;

procedure TfrmCadastroAgenda.SpeedButton7Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_perfil') = Nil then
         Application.CreateForm(Tcadastro_perfil, cadastro_perfil);

  cadastro_perfil.ShowModal;

  qryPerfil.Close;
  qryPerfil.Open;
end;

end.

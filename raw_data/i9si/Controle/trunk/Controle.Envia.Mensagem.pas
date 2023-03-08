unit Controle.Envia.Mensagem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Operacoes, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniGUIClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton,
  uniPanel, uniCheckBox, uniMemo, uniBasicGrid, uniDBGrid, uniPageControl,
  uniProgressBar, Funcoes.client, uniTimer;

type
  TrecebeRetorno = class
  private
    FnRetorno: TRetornos;
    procedure SetnRetorno(const Value: TRetornos);
  published
    property nRetornoM1 : TRetornos read FnRetorno write SetnRetorno;
    property nRetornoM2 : TRetornos read FnRetorno write SetnRetorno;
  end;

type
  TBase64 = class
  private
    FArquivoBase64: string;
  published
    property ArquivoBase64: string read FArquivoBase64 write FArquivoBase64;
  end;


type
  TControleEnviaMensagem = class(TControleOperacoes)
    CdsCloneTotais: TClientDataSet;
    DspCloneTotais: TDataSetProvider;
    DscCloneTotais: TDataSource;
    CdsCloneItens: TClientDataSet;
    DspCloneItens: TDataSetProvider;
    DscCloneItens: TDataSource;
    CdsCloneItens2: TClientDataSet;
    DspCloneItens2: TDataSetProvider;
    DscCloneItens2: TDataSource;
    UniPageControlPrincipal: TUniPageControl;
    UniTabSheet4: TUniTabSheet;
    DBGridDadosTotais: TUniDBGrid;
    UniTabSheet5: TUniTabSheet;
    DBGridDadosItens: TUniDBGrid;
    UniTabSheet11: TUniTabSheet;
    MemoEnvioUrl: TUniMemo;
    UniTabSheet12: TUniTabSheet;
    MemoEnvioJson: TUniMemo;
    UniTabSheet13: TUniTabSheet;
    MemoRetorno: TUniMemo;
    UniCheckBoxEnviaAVencer: TUniCheckBox;
    UniCheckBoxTitulosVencidos: TUniCheckBox;
    CdsConsulta: TClientDataSet;
    CdsConsultaID: TFloatField;
    CdsConsultaSEQUENCIA_PARCELAS: TFloatField;
    CdsConsultaVALOR: TFloatField;
    CdsConsultaCLIENTE: TWideStringField;
    CdsConsultaCELULAR: TWideStringField;
    CdsConsultaDATA_VENCIMENTO: TDateTimeField;
    QryConsulta: TADOQuery;
    QryConsultaID: TFloatField;
    QryConsultaSEQUENCIA_PARCELAS: TFloatField;
    QryConsultaVALOR: TFloatField;
    QryConsultaCLIENTE: TWideStringField;
    QryConsultaCELULAR: TWideStringField;
    QryConsultaDATA_VENCIMENTO: TDateTimeField;
    DscConsulta: TDataSource;
    DspConsulta: TDataSetProvider;
    CdsClone: TClientDataSet;
    QryCadastroID: TFloatField;
    QryCadastroURL_API: TWideStringField;
    QryCadastroTOKEN_API: TWideStringField;
    QryCadastroTEXTO_ANTES_VENCIMENTO: TWideStringField;
    QryCadastroTEXTO_DEPOIS_VENCIMENTO: TWideStringField;
    QryCadastroDIAS_ANTES_VENCIMENTO: TFloatField;
    QryCadastroDIAS_DEPOIS_VENCIMENTO: TFloatField;
    QryCadastroDIAS_INTERVALO_ENTRE_COBRANCA: TFloatField;
    QryCadastroQUANT_DIAS_DE_COBRANCA: TFloatField;
    QryCadastroFOTO_CAMINHO: TWideStringField;
    CdsCadastroID: TFloatField;
    CdsCadastroURL_API: TWideStringField;
    CdsCadastroTOKEN_API: TWideStringField;
    CdsCadastroTEXTO_ANTES_VENCIMENTO: TWideStringField;
    CdsCadastroTEXTO_DEPOIS_VENCIMENTO: TWideStringField;
    CdsCadastroDIAS_ANTES_VENCIMENTO: TFloatField;
    CdsCadastroDIAS_DEPOIS_VENCIMENTO: TFloatField;
    CdsCadastroDIAS_INTERVALO_ENTRE_COBRANCA: TFloatField;
    CdsCadastroQUANT_DIAS_DE_COBRANCA: TFloatField;
    CdsCadastroFOTO_CAMINHO: TWideStringField;
    UniButton1: TUniButton;
    QryConsultaCLIENTE_ID: TFloatField;
    CdsConsultaCLIENTE_ID: TFloatField;
    UniCheckBoxDetalhe: TUniCheckBox;
    UniTimer1: TUniTimer;
    QryCadastroURL_RETORNO: TWideStringField;
    CdsCadastroURL_RETORNO: TWideStringField;
    procedure UniFormShow(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure UniButton1Click(Sender: TObject);
    procedure UniCheckBoxDetalheClick(Sender: TObject);
    procedure UniTimer1Timer(Sender: TObject);
  private
    recebeRetorno : TrecebeRetorno;
    procedure CarregaConfiguracoesAPI(url, tokenAPI, cryptKey,
      uuid_safe: String); stdcall;
    function EnviaMensagemTexto(Numero: string;
                                Texto: string;
                                TokenApi: string;
                                ArquivoBase64: String = '';
                                NumeroClient: String = '1'): TRetornos;
    function EnviaMensagemVerificaAPIAtiva(): TRetornos;
    procedure AlimentaConfiguracoes(url, tokenAPI, cryptKey, uuid_safe: String);
      stdcall;
    procedure SelecionaTitulos;
    Procedure EnviaMensagens(Texto: string;
                                                Celular: string);
    function SubstituiTextoMensagem(Texto: string): String;
    function SelecionaTitulosAVencer(DiasParaVencimento: integer): Boolean;
    function SelecionaTitulosVencidos(DiasAPosVencimento: integer): Boolean;
    procedure AtualizaUltimaMensagemEnviadaCliente(cliente_id: Integer);
    procedure EnviaMensagemParaForm(sequencia: Integer);
    function EnviaMensagemCancelaVerificaWhatsAppAtivo(
      Numero: string): TRetornos;
    function EnviaMensagemVerificaWhatsAppAtivo(Numero: string;
                                                                   IP: String ): TRetornos;
    { Private declarations }
  public
    { Public declarations }
    TempoLimite: integer;
    Celular : string;
  end;

function ControleEnviaMensagem: TControleEnviaMensagem;

var
  Base64 : TBase64;
  ListaOrdenada: string;
  ArquivoBase64: String;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, Envia.Recebe.Dados.Json,
  System.NetEncoding, REST.Types, System.StrUtils, Controle.Funcoes,
  Controle.Envia.Mensagem.Aguarde, uniSweetAlert,
  Controle.Envia.Mensagem.Confirma, Client.Aguarde, Controle.Server.Module;


function ControleEnviaMensagem: TControleEnviaMensagem;
begin
  Result := TControleEnviaMensagem(ControleMainModule.GetFormInstance(TControleEnviaMensagem));
end;

procedure TrecebeRetorno.SetnRetorno(const Value: TRetornos);
begin
  Try
    // FnRetorno := Value;
    // Alimentando os componentes visuais
    With ControleEnviaMensagem do
    begin
      if Value.rClientDataSetCabecalho <> nil then
      begin
        CDSCloneTotais.CloneCursor(Value.rClientDataSetCabecalho, false, false);
        CDSCloneTotais.Open;

        DBGridDadosTotais.DataSource    := DscCloneTotais;

        if Value.rClientDataSetItens <> nil then
        begin
          CDSCloneItens.CloneCursor(Value.rClientDataSetItens, false, false);
          CDSCloneItens.Open;

          DBGridDadosItens.DataSource    := DscCloneItens;
        end;
      end
      else
      begin
        DBGridDadosTotais.DataSource    := Value.rDatasource;
        DBGridDadosItens.DataSource     := nil;
        // Clonando o resultado para um clientdataset
        CDSClone.CloneCursor(Value.rClientDataSet, false, false);
        CDSClone.Open;
      end;

      if Value.rClientDataSetItens2 <> nil then
      begin
        CDSCloneItens2.CloneCursor(Value.rClientDataSetItens2, false, false);
        CDSCloneItens2.Open;
      end;

      MemoEnvioUrl.Text      := Value.rUrlEnvio;
      MemoEnvioJson.Text     := Value.rJsonEnvio;
      MemoRetorno.Text       := Value.rJsonRetorno;
    end;
  Finally
    // metodos para deixar free aqui
  End;
end;

procedure TControleEnviaMensagem.UniButton1Click(Sender: TObject);
begin
  inherited;
  SelecionaTitulosVencidos(StrToInt64Def(CdsCadastroDIAS_DEPOIS_VENCIMENTO.AsString,0));
end;

procedure TControleEnviaMensagem.UniCheckBoxDetalheClick(Sender: TObject);
begin
  inherited;
  if UniCheckBoxDetalhe.Checked = True then
    Height := 385
  else
    Height := 170;
end;

procedure TControleEnviaMensagem.UniFormShow(Sender: TObject);
begin
  inherited;
  Height := 170;
  Top    := 385;
  Width  := 548;

  UniPageControlPrincipal.ActivePageIndex := 0;

  CdsCadastro.Open;

  AlimentaConfiguracoes(CdsCadastroURL_API.AsString,
                        CdsCadastroTOKEN_API.AsString,
                        '',
                        '');

  // Convertendo Base a imagem para Base64
  ArquivoBase64 := ControleMainModule.ConverteToBase64(CdsCadastroFOTO_CAMINHO.AsString,
                                                      'BannerI9ST.txt');

  TempoLimite := 0;
end;

procedure TControleEnviaMensagem.UniTimer1Timer(Sender: TObject);
begin
  TempoLimite := TempoLimite + 1;

  if TempoLimite < 80 then
  begin
    ClientAguarde.UniProgressBar1.Position := TempoLimite;
    if ControleServerModule.RecebeCallBack = snConcorda then
    begin
      UniTimer1.Enabled := False;
      ControleServerModule.RecebeCallBack := snNulo;
      TempoLimite := 0;
      ClientAguarde.Close;
      ShowMessage('Envio de mensagens aceito!');
    end
    else if ControleServerModule.RecebeCallBack = snNaoConcorda then
    begin
      UniTimer1.Enabled := False;
      ControleServerModule.RecebeCallBack := snNulo;
      TempoLimite := 0;
      ClientAguarde.Close;
      ShowMessage('Envio de mensagens recusado!');
    end;
  end
  else
  begin
    UniTimer1.Enabled := False;
    ControleServerModule.RecebeCallBack := snExpirou;
    TempoLimite := 0;
    EnviaMensagemCancelaVerificaWhatsAppAtivo(Celular);
    ShowMessage('Tempo de resposta excedido');
    ClientAguarde.Close;
  end;
end;

procedure TControleEnviaMensagem.BotaoSalvarClick(Sender: TObject);
var
  i: integer;
  EncontrouRegistros: Boolean;
begin
  inherited;
  ControleEnviaMensagemConfirma.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      // Testando se API esta online
      Try
        EnviaMensagemVerificaWhatsAppAtivo(ControleEnviaMensagemConfirma.UniEdtCelular.Text,
                                           CdsCadastroURL_RETORNO.AsString);
        Celular := ControleEnviaMensagemConfirma.UniEdtCelular.Text;
        UniTimer1.Enabled := True;
      Except
        on e:Exception do
        begin
          if AnsiContainsStr(e.Message, 'REST request failed') then
          begin
            ControleMainModule.MensageiroSweetAlerta('Atenção', 'O servidor da API está desligado ou o host está inválido!');
            BotaoSalvar.Enabled := True;
            Exit;
          end;
        end;
      End;

      ClientAguarde.Show;
      ClientAguarde.UniProgressBar1.Max := 20;
    end;
  end);

  EncontrouRegistros := False;

  BotaoSalvar.Enabled := False;
  // Testando se API esta online
  Try
    EnviaMensagemVerificaAPIAtiva();
  Except
    on e:Exception do
    begin
      if AnsiContainsStr(e.Message, 'REST request failed') then
      begin
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'O sistema de envio de mensagens não está ativo ou não está configurado, verifique e tente novamente!');
        BotaoSalvar.Enabled := True;
        Exit;
      end;
    end;
  End;

  if (UniCheckBoxEnviaAVencer.Checked = False) and (UniCheckBoxTitulosVencidos.Checked = False) then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Marque ao menos uma opção para enviar as mensagens!');
    BotaoSalvar.Enabled := True;
    Exit;
  end;

  ControleEnviaMensagemAguarde.Show;

  if UniCheckBoxEnviaAVencer.Checked = True then
  begin
    if SelecionaTitulosAVencer(StrToInt64Def(CdsCadastroDIAS_ANTES_VENCIMENTO.AsString,0))  = True then
    begin
      EncontrouRegistros := True;

      // Exibindo outro formulario para colocar as informações de envio,
      // Porque no mesmo formulario nao atualiza
      ControleEnviaMensagemAguarde.UniProgressBar1.Max := CdsConsulta.RecordCount;
      ControleEnviaMensagemAguarde.UniProgressBar1.Position := 0;

      i := 1;
      CdsConsulta.First;
      while not CdsConsulta.eof do
      begin
        EnviaMensagemParaForm(i);

        UniSession.Synchronize;

        Try
          EnviaMensagens(CdsCadastroTEXTO_ANTES_VENCIMENTO.AsString,
                         CdsConsultaCELULAR.AsString);
        Except
          on e:exception do
          begin
            ControleMainModule.MensageiroSweetAlerta('Atenção', 'A conexão com o servidor de mensagens foi perdida!')
          end;
        End;

        AtualizaUltimaMensagemEnviadaCliente(CdsConsultaCLIENTE_ID.AsInteger);

        CdsConsulta.Next;
        i := i + 1
      end;
    end;
  end;

  if UniCheckBoxTitulosVencidos.Checked = True then
  begin
    if SelecionaTitulosVencidos(StrToInt64Def(CdsCadastroDIAS_DEPOIS_VENCIMENTO.AsString,0))  = True then
    begin
      EncontrouRegistros := True;

      // Exibindo outro formulario para colocar as informações de envio,
      // Porque no mesmo formulario nao atualiza
      ControleEnviaMensagemAguarde.UniProgressBar1.Max := CdsConsulta.RecordCount;
      ControleEnviaMensagemAguarde.UniProgressBar1.Position := 0;

      i := 1;
      CdsConsulta.First;
      while not CdsConsulta.eof do
      begin
        EnviaMensagemParaForm(i);

        UniSession.Synchronize;

        EnviaMensagens(CdsCadastroTEXTO_DEPOIS_VENCIMENTO.AsString,
                       CdsConsultaCELULAR.AsString);


        AtualizaUltimaMensagemEnviadaCliente(CdsConsultaCLIENTE_ID.AsInteger);

        CdsConsulta.Next;
        i := i + 1
      end;
    end;
  end;

  ControleEnviaMensagemAguarde.Close;

  if EncontrouRegistros = true then
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Mensagens enviadas com sucesso!')
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não há mensagens para enviar!');

  ControleEnviaMensagem.Free;

  BotaoSalvar.Enabled := True;
end;

procedure TControleEnviaMensagem.CarregaConfiguracoesAPI(url,
                                                         tokenAPI,
                                                         cryptKey,
                                                         uuid_safe: String); stdcall;
begin
  EnviaRecebeDadosJson := TEnviaRecebeDadosJson.Create;
  With EnviaRecebeDadosJson do
  begin
    if not Assigned(StrListPar) then
      StrListPar := TStringList.Create;

    // Adicionando os parametros iniciais
    FuncoesClient.Add_StrListPar(StrListPar,
                                 'url',
                                  url);
  end;
end;


function TControleEnviaMensagem.EnviaMensagemVerificaAPIAtiva(): TRetornos;
begin
  try
    // código temporario, o correto é passar pelo body, passando na url apenas a url com a autenticação
    With EnviaRecebeDadosJson do
    begin
      FuncoesClient.Add_StrListPar(StrListPar,
                             'testaapi',
                              'True');
    end;

    ListaOrdenada := '';
    ListaOrdenada := '/whatsapp/mensagem?' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'testaapi');

  finally
    Result := EnviaRecebeDadosJson.EnviaRequisicaoAPI('',
                                                      FuncoesClient.ConverteStringToStrinList(ListaOrdenada).Values['strlist'],
                                                      TRESTRequestMethod.rmPOST,
                                                      '');
  end;
end;

function TControleEnviaMensagem.EnviaMensagemTexto(Numero: string;
                                                                Texto: string;
                                                                TokenApi: string;
                                                                ArquivoBase64: String = '';
                                                                NumeroClient: String = '1'): TRetornos;
begin
  try
    Base64 := TBase64.create;
    Base64.ArquivoBase64 := 'json_base64';

    // código temporario, o correto é passar pelo body, passando na url apenas a url com a autenticação
    With EnviaRecebeDadosJson do
    begin
      FuncoesClient.Add_StrListPar(StrListPar,
                             'numero',
                              Numero);

      FuncoesClient.Add_StrListPar(StrListPar,
                             'texto',
                              Texto);

      FuncoesClient.Add_StrListPar(StrListPar,
                             'tokenapi',
                              TokenApi);

      FuncoesClient.Add_StrListPar(StrListPar,
                             'numclient',
                              NumeroClient);
    end;

    ListaOrdenada := '';
    ListaOrdenada := '/whatsapp/mensagem?' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'numero') +
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'texto') +
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'tokenapi') +
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'numclient');


  finally
    Result := EnviaRecebeDadosJson.EnviaRequisicaoAPI(FuncoesClient.RetornaJson(Base64,
                                                                                '{"arquivoBase64":"',
                                                                                '',
                                                                                '"}',
                                                                                ''),
                                                      FuncoesClient.ConverteStringToStrinList(ListaOrdenada).Values['strlist'],
                                                      TRESTRequestMethod.rmPOST,
                                                      ArquivoBase64);

  end;
end;

procedure TControleEnviaMensagem.AlimentaConfiguracoes(url,
                                                      tokenAPI,
                                                      cryptKey,
                                                      uuid_safe: String); stdcall;

begin
  EnviaRecebeDadosJson := TEnviaRecebeDadosJson.Create;
  With EnviaRecebeDadosJson do
  begin
    if not Assigned(StrListPar) then
      StrListPar := TStringList.Create;

    // Adicionando os parametros iniciais
    FuncoesClient.Add_StrListPar(StrListPar,
                           'url',
                            url);
  end;
end;

Procedure TControleEnviaMensagem.SelecionaTitulos();
begin
  CdsConsulta.close;
  CdsConsulta.Params.ParamByName('situacao').AsString := '%INADIMPLENTE%';
  CdsConsulta.Open;
end;

function TControleEnviaMensagem.SelecionaTitulosAVencer(DiasParaVencimento: integer): Boolean;
var
  DataInicio: TDateTime;
begin
  Result := False;

  DataInicio := Date + DiasParaVencimento;

  CdsConsulta.close;
  CdsConsulta.Params.ParamByName('situacao').AsString           := '%ABERTO%';
  CdsConsulta.Params.ParamByName('vencimento_inicial').AsString := DateToStr(Date + 1);
  CdsConsulta.Params.ParamByName('vencimento_final').AsString   := DateToStr(DataInicio);
  CdsConsulta.Open;

  if CdsConsulta.RecordCount > 0 then
    Result := True;
end;

function TControleEnviaMensagem.SelecionaTitulosVencidos(DiasAPosVencimento: integer): Boolean;
var
  DataFim: TDateTime;
begin
  Result := False;

  DataFim := Date + DiasAPosVencimento;

  CdsConsulta.close;
  CdsConsulta.Params.ParamByName('situacao').AsString           := '%INADIMPLENTE%';
  CdsConsulta.Params.ParamByName('vencimento_inicial').AsString := '01/01/2000';
  CdsConsulta.Params.ParamByName('vencimento_final').AsString   := DateToStr(DataFim);
  CdsConsulta.Open;

  if CdsConsulta.RecordCount > 0 then
    Result := True;
end;

Procedure TControleEnviaMensagem.EnviaMensagens(Texto: string;
                                                Celular: string);
var
  CelularOitoDigitos: string;
  Texto_Alterado, novaLinha: string;
  stringListRetiraQuebraLinha : TStringList;
  i : Integer;
begin
  Texto_Alterado := SubstituiTextoMensagem(Texto);
  Texto_Alterado := ControleFuncoes.RetiraEnterFinalFrase(Texto_Alterado);


  // Enviando para o numero com 9 digitos
  try
    recebeRetorno := TrecebeRetorno.Create;
    recebeRetorno.nRetornoM1  :=  EnviaMensagemTexto(ControleFuncoes.RemoveMascara(Celular),
                                                     Texto_Alterado,
                                                     CdsCadastroTOKEN_API.AsString,
                                                     ArquivoBase64,
                                                     '1');
  finally
    recebeRetorno.Free;
  end;


  // Enviando para o numero com 8 digitos
  CelularOitoDigitos := Copy(ControleFuncoes.RemoveMascara(Celular),1,2) + Copy(ControleFuncoes.RemoveMascara(Celular),4,8) ;

  try
    recebeRetorno := TrecebeRetorno.Create;
    recebeRetorno.nRetornoM2  :=  EnviaMensagemTexto(CelularOitoDigitos,
                                                     Texto_Alterado,
                                                     CdsCadastroTOKEN_API.AsString,
                                                     ArquivoBase64,
                                                     '1');
  finally
    recebeRetorno.Free;
  end;
end;

Function TControleEnviaMensagem.SubstituiTextoMensagem(Texto: string):String;
begin
  Result  := StringReplace(Texto,  '<NOME_CLIENTE>', CdsConsultaCLIENTE.AsString, [rfReplaceAll]);
  Result  := StringReplace(Result, '<DATA_VENCIMENTO>', CdsConsultaDATA_VENCIMENTO.AsString, [rfReplaceAll]);
  Result  := StringReplace(Result, '<PARCELA>', CdsConsultaSEQUENCIA_PARCELAS.AsString, [rfReplaceAll]);
  Result  := StringReplace(Result, '<VALOR>', FormatFloat('#,##0.00',CdsConsultaVALOR.AsFloat), [rfReplaceAll]);
  Result  := StringReplace(Result, '<NOME_LOJA>', ControleMainModule.FNomeFantasia, [rfReplaceAll]);
end;


procedure TControleEnviaMensagem.AtualizaUltimaMensagemEnviadaCliente(cliente_id: Integer);
begin
  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Add('UPDATE cliente SET');
    QryAx1.SQL.Add('       ultima_mensagem_enviada = SYSDATE');
    QryAx1.SQL.Add(' WHERE id              = :cliente_id');
    QryAx1.Parameters.ParamByName('cliente_id').Value  := cliente_id;
    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
      // Confirma a transação
      ADOConnection.CommitTrans;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
      end;
    end;
  end;
end;

function TControleEnviaMensagem.EnviaMensagemVerificaWhatsAppAtivo(Numero: string;
                                                                   IP: String ): TRetornos;
var
  ArquivoBase64: string;
begin
  try
    Base64 := TBase64.create;
    Base64.ArquivoBase64 := 'json_base64';

    ArquivoBase64 := ControleMainModule.ConverteToBase64('img\BannerI9ST.png',
                                                         'img\BannerI9ST.txt');

    // código temporario, o correto é passar pelo body, passando na url apenas a url com a autenticação
    With EnviaRecebeDadosJson do
    begin
      FuncoesClient.Add_StrListPar(StrListPar,
                              'testawhatsapp',
                              'True');

      FuncoesClient.Add_StrListPar(StrListPar,
                             'numero',
                              Numero);

      FuncoesClient.Add_StrListPar(StrListPar,
                             'ip',
                              IP);
    end;

    ListaOrdenada := '';
    ListaOrdenada := '/whatsapp/mensagem?' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'testawhatsapp')+
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'numero')+
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'ip');

  finally
    Result := EnviaRecebeDadosJson.EnviaRequisicaoAPI(FuncoesClient.RetornaJson(Base64,
                                                                                '{"arquivoBase64":"',
                                                                                '',
                                                                                '"}',
                                                                                ''),
                                                      FuncoesClient.ConverteStringToStrinList(ListaOrdenada).Values['strlist'],
                                                      TRESTRequestMethod.rmPOST,
                                                      ArquivoBase64);
  end;
end;

function TControleEnviaMensagem.EnviaMensagemCancelaVerificaWhatsAppAtivo(Numero: string): TRetornos;
var
  ArquivoBase64: string;
begin
  try
    ArquivoBase64 := ControleMainModule.ConverteToBase64('img\BannerI9ST.png',
                                                         'img\BannerI9ST.txt');

    // código temporario, o correto é passar pelo body, passando na url apenas a url com a autenticação
    With EnviaRecebeDadosJson do
    begin
      FuncoesClient.Add_StrListPar(StrListPar,
                              'cancelatestawhatsapp',
                              'True');

      FuncoesClient.Add_StrListPar(StrListPar,
                             'numero',
                              Numero);
    end;

    ListaOrdenada := '';
    ListaOrdenada := '/whatsapp/mensagem?' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'cancelatestawhatsapp')+
                     '&' +
                     FuncoesClient.RetornaStringList(EnviaRecebeDadosJson.StrListPar, 'numero');

  finally
    Result := EnviaRecebeDadosJson.EnviaRequisicaoAPI(FuncoesClient.RetornaJson(Base64,
                                                                                '{"arquivoBase64":"',
                                                                                '',
                                                                                '"}',
                                                                                ''),
                                                      FuncoesClient.ConverteStringToStrinList(ListaOrdenada).Values['strlist'],
                                                      TRESTRequestMethod.rmPOST,
                                                      ArquivoBase64);
  end;
end;

procedure TControleEnviaMensagem.EnviaMensagemParaForm(sequencia: Integer);
begin
  ControleEnviaMensagemAguarde.UniProgressBar1.Position := sequencia;
  ControleEnviaMensagemAguarde.unilabel4.Caption := 'Enviando a mensagem de n.º '+ IntToStr(sequencia) +' do total de ' + IntToStr(CdsConsulta.RecordCount) +
                                                    ' .O envio de todas levará até   ' + (IntToStr((CdsConsulta.RecordCount * 5) div 60)) +' minuto(s).';
end;

end.

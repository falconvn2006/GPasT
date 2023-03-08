unit untClasseLembrete;

interface

uses
  Classes, Windows, Messages, SysUtils, Variants, Controls, Forms,
  Dialogs,ExtCtrls, IBQuery, db, untDados, ACBrSMS, IniFiles, ACBrSMSClass, funcao,
  StdCtrls;

type
  Lembrete = class(TThread)
  private
    _Form: TForm;
    _Qry: TIBQuery;
    _Panel: TPanel;
    _SMS: TACBrSMS;
    _mmLog: TMemo;

    _Log: TStringList;

    vDiasAlertaPedido: Integer;
    vLembrarAgenda    : Boolean;
    vTempoLembrate    : TTime;
    vLembrarAgendaSMS : Boolean;
    vTempoLembrateSMS : TTime;
    vModeloModem      : Integer;
    vPortaModem       : String;
    vVelocidadeModem  : Integer;
    vTextoSMS         : TStringList;

    vEnviarEmailAgenda: Boolean;
    vEmail: String;
    vAssunto: String;
    vTexto: TStringList;
    vUrlHtml: String;
    vArquivo: String;
    vSMTP: String;
    vUsuarioID: String;
    vSenha: String;
    vResponderPara: String ;
    vPorta: String;
    vRequerAutenticacao: Boolean;
    vUsarSSL: Boolean;
    vMetodoSSL: integer;
    vModoSSL: integer;
    vUsarTipoTLS: integer;
    vHost_Proxy: String;
    vPorta_Proxy: String;
    vUser_Proxy: String;
    vSenha_Proxy: String;

    vTextoOuHTML : integer;

    vEnviarMalaDireta: Boolean;
    vFiltroMalaDireta: String;
    vEnviarSMSMalaDireta: Boolean;
    vEnviarEmalMalaDireta: Boolean;
    vMensagemMalaDireta: String;

    vTempoX: String;

    procedure SetName;
    function ProximoSinc(iNow: TTime; XTempo: String = '00:10:00'): TTime;
    procedure EviarSMSAgendas;
    procedure EviarEmailAgendas;
    Function AtivarModem: Boolean;
    Function EnviarSMS(Numero: String; Texto: String): Boolean;
    procedure prcEnviarMalaDireta();
    { Private declarations }
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean;
                       Form: Tform;
                       Panel : TPanel;
                       Qry: TIBQuery;
                       SMS: TACBrSMS;
                       mmLog: TMemo = nil;
                       TempoX: String = '00:10:00');

    property EnviarMalaDireta     : Boolean read vEnviarMalaDireta     write vEnviarMalaDireta;
    property FiltroMalaDireta     : String  read vFiltroMalaDireta     write vFiltroMalaDireta;
    property EnviarSMSMalaDireta  : Boolean read vEnviarSMSMalaDireta  write vEnviarSMSMalaDireta;
    property EnviarEmailMalaDireta: Boolean read vEnviarEmalMalaDireta write vEnviarEmalMalaDireta;
    property MensagemMalaDireta   : String  read vMensagemMalaDireta   write vMensagemMalaDireta;
  end;

type
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure Lembrete.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ Lembrete }

procedure Lembrete.SetName;
var
  ThreadNameInfo: TThreadNameInfo;
begin
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'AutoExecute';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
end;

constructor Lembrete.Create(CreateSuspended: Boolean;
                       Form: TForm;
                       Panel : TPanel;
                       Qry: TIBQuery;
                       SMS: TACBrSMS;
                       mmLog: TMemo = nil;
                       TempoX: String = '00:10:00');
begin
  inherited Create (CreateSuspended);

  _Form := Form;
  _Panel := Panel;
  _Qry := Qry;
  _SMS := SMS;
  _mmLog := mmLog;
  vTempoX := TempoX;

  _Log := TStringList.Create;

  if not DirectoryExists(ExtractFilePath(Application.ExeName)+'LOG\') then
    CreateDir(ExtractFilePath(Application.ExeName)+'LOG\');

  vDiasAlertaPedido := Dados.ValorConfig('frmAcompanhaPedidoAgenda','DIASALERTA',30,tcInteiro).vcInteger;

  vLembrarAgenda    := Dados.ValorConfig('principal','LEMBRARAGENDA',0,tcCheck).vcBoolean;

  vTempoLembrate    := Dados.ValorConfig('principal','TempoLembrete',StrToTime('00:10:00'),tcHora).vcTime;

  vLembrarAgendaSMS    := Dados.ValorConfig('principal','LEMBRARAGENDA_SMS',0,tcCheck).vcBoolean;

  vTempoLembrateSMS    := Dados.ValorConfig('principal','TempoLembrete_SMS',StrToTime('23:59:00'),tcHora).vcTime;

  vModeloModem      := Dados.ValorConfig('principal','MODELO_MODEM_SMS',0,tcCodigoLookup).vcInteger;

  vPortaModem       := Dados.ValorConfig('principal','PORTA_MODEM_SMS','COM3',tcTexto).vcString;

  vVelocidadeModem  := Dados.ValorConfig('principal','VELOCIDADE_MODEM_SMS',115200,tcInteiro).vcInteger;

  vTextoSMS         := Dados.ValorConfig('principal','TEXTO_SMS','',tcMemo).vcMemo;

  vEnviarEmailAgenda     := Dados.ValorConfig('principal','EMAIL_ENVIAR',0,tcCheck).vcBoolean;

  vEmail                 := Dados.ValorConfig('principal','EMAIL_EMAIL','',tcTexto).vcString;

  vAssunto               := Dados.ValorConfig('principal','EMAIL_ASSUNTO','',tcTexto).vcString;

  vTextoOuHTML           := Dados.ValorConfig('principal','EMAIL_TEXTO_HTML',0,tcCodigoLookup).vcInteger;

  vTexto                 := Dados.ValorConfig('principal','EMAIL_TEXTO','',tcMemo).vcMemo;

  vURLHtml               := Dados.ValorConfig('principal','EMAIL_URL_HTML','',tcTexto).vcString;

  vArquivo               := Dados.ValorConfig('principal','EMAIL_ARQUIVO','',tcTexto).vcString;

  vSMTP                  := Dados.ValorConfig('principal','EMAIL_SMTP','',tcTexto).vcString;

  vUsuarioID             := Dados.ValorConfig('principal','EMAIL_USUARIO_SMTP','',tcTexto).vcString;

  vSenha                 := Dados.ValorConfig('principal','EMAIL_SENHA_SMTP','',tcTexto).vcString;

  vResponderPara         := Dados.ValorConfig('principal','EMAIL_EMAIL_RESPOSTA','',tcTexto).vcString;

  vPorta                 := Dados.ValorConfig('principal','EMAIL_PORTA_SMTP','584',tcTexto).vcString;

  vRequerAutenticacao    := Dados.ValorConfig('principal','EMAIL_REQUER_AUTENTICACAO',True,tcCheck).vcBoolean;

  vUsarSSL               := Dados.ValorConfig('principal','EMAIL_REQUER_AUTENTICACAO',False,tcCheck).vcBoolean;

  vMetodoSSL             := Dados.ValorConfig('principal','EMAIL_METODO_SSL',4,tcCodigoLookup).vcInteger;

  vModoSSL               := Dados.ValorConfig('principal','EMAIL_MODO_SSL',1,tcCodigoLookup,).vcInteger;

  vUsarTipoTLS               := Dados.ValorConfig('principal','EMAIL_TIPO_TSL',1,tcCodigoLookup,).vcInteger;

  vHost_Proxy                 := Dados.ValorConfig('principal','PROXY_HOST','',tcTexto).vcString;

  vPorta_Proxy                := Dados.ValorConfig('principal','PROXY_PORTA','',tcTexto).vcString;

  vUser_Proxy                 := Dados.ValorConfig('principal','PROXY_USUARIO','',tcTexto).vcString;

  vSenha_Proxy                := Dados.ValorConfig('principal','PROXY_SENHA','',tcTexto).vcString;;

  FreeOnTerminate := false;
end;

function Lembrete.ProximoSinc(iNow: TTime; XTempo: String = '00:10:00'): TTime;
var
  sTime: TTime;
begin

  sTime := StrToTimeDef(XTempo,0);

  result := iNow + sTime;

end;

function Lembrete.AtivarModem: Boolean;
begin
  Result := True;
  try
    if not _SMS.Ativo then
    begin
      _SMS.Modelo       := TACBrSMSModelo(vModeloModem);
      _SMS.Device.Porta := vPortaModem;
      _SMS.Device.Baud  := vVelocidadeModem;
      _SMS.Ativar;
    end;
  Except
    on E: Exception do
    begin
      _Log.Add('Erro ao Ativar MODEL: '+e.Message);
      Result := False;
    end;
  end;
end;

Function Lembrete.EnviarSMS(Numero: String; Texto: String): Boolean;
var
  IndiceMsgEnviada: String;
begin
  Result := True;
  try

    if not AtivarModem() then
    begin
      Result := False;
      Exit;
    end;

//if frm'principal'.ACBrSMS1.BandejasSimCard > 1 then
//  begin
//    if rdgBandeja.ItemIndex = 0 then
//      frm'principal'.ACBrSMS1.TrocarBandeja(simCard1)
//    else
//      frm'principal'.ACBrSMS1.TrocarBandeja(simCard2);
//  end;

    _SMS.QuebraMensagens := True;

    _SMS.EnviarSMS(
      Numero,
      Texto,
      IndiceMsgEnviada
    );

    _Log.Add(
        '('+Numero+') '+
        'Mensagem envida com sucesso. Indice: ' + IndiceMsgEnviada +
        ' - Ultima resposta: ' +_SMS.UltimaResposta);

    _SMS.Desativar;

  except
    on E: Exception do
    begin
      _Log.Add('('+Numero+') Erro ao Enviar SMS: '+e.Message);
      _SMS.Desativar;
      Result := False;
    end;
  end;
end;

procedure Lembrete.EviarSMSAgendas;
var
  xSL: TStringList;
  i: Integer;
  sLinha: String;
  arrEnviados: Array of Integer;
begin
//  if not AtivarModem then
//    Exit;

  _Log.Clear;

  SetLength(arrEnviados,0);

  xSL := TStringList.Create;
  try

    _Qry.SQL.Text := 'Select '+
                     ' a.codigo,p.nome,p.telcelular, a.data, a.hora '+
                     ' from tabagenda a '+
                     ' left join tabperfil p on a.idperfil = p.codigo '+
                     ' where ((a.data < :DataFim) or ((a.data = :DataFim2) and (a.hora <= :HoraFim))) '+
                     ' and a.data >= Current_Date '+
                     ' and Coalesce(a.SMS_ENVIADO,0) = 0 '+
                     ' and coalesce(A.SITUACAO, 1) in (1,3) '+
                     ' and Coalesce(a.idpedidoagenda,0) > 0 ';
    _Qry.ParamByName('DataFim').AsDateTime := ProximoSinc(now,FormatDateTime('hh:mm:ss',vTempoLembrateSMS));
    _Qry.ParamByName('DataFim2').AsDateTime := ProximoSinc(now,FormatDateTime('hh:mm:ss',vTempoLembrateSMS));
    _Qry.ParamByName('HoraFim').AsDateTime := ProximoSinc(now,FormatDateTime('hh:mm:ss',vTempoLembrateSMS));
    _Qry.Open;

    while not _Qry.Eof do
    begin
      xSl.Clear;

      For i := 0 To vTextoSMS.Count - 1 do
      begin
        sLinha := vTextoSMS.Strings[i];
        sLinha := TrocaAcentos(StringReplace(sLinha,'@@PERFIL@@',_Qry.FieldByName('Nome').Text,[rfReplaceAll,rfIgnoreCase]));
        sLinha := TrocaAcentos(StringReplace(sLinha,'@@DATA@@',FormatDateTime('dd/MM/yyyy',_Qry.FieldByName('data').AsDateTime),[rfReplaceAll,rfIgnoreCase]));
        sLinha := TrocaAcentos(StringReplace(sLinha,'@@HORA@@',FormatDateTime('hh:mm',_Qry.FieldByName('hora').AsDateTime),[rfReplaceAll,rfIgnoreCase]));
        xSl.Add(sLinha);
      end;

      if EnviarSMS(_Qry.FieldByName('telcelular').Text,xSl.Text) then
      begin
        SetLength(arrEnviados,length(arrEnviados)+1);
        arrEnviados[length(arrEnviados)-1] := _Qry.FieldByName('codigo').AsInteger;
      end;

      _Qry.Next;
    end;

    _Log.Add(IntToStr(Length(arrEnviados))+' Mensagens Enviadas');

    try
      For i := 0 to Length(arrEnviados) - 1 do
      begin
        _Qry.SQL.Text := 'update TABAGENDA set SMS_ENVIADO = 1 where codigo = :codigo';
        _Qry.ParamByName('codigo').AsInteger := arrEnviados[i];
        _Qry.ExecSQL;
        _Qry.Transaction.CommitRetaining;
      end;
    Except
      on E: Exception do
        _Log.Add('Erro ao Gravar no Banco: '+e.Message);
    end;

  finally
    _Log.SaveToFile(ExtractFilePath(Application.ExeName)+'LOG\SMS'+FormatDateTime('ddMMyyyyhhmmss', now)+'.txt');
    FreeAndNil(xSL);
  end;
end;

procedure Lembrete.prcEnviarMalaDireta;
var
  xSL, xTexto: TStringList;
  i: Integer;
  sLinha: String;
  arrEnviados: Array of Integer;
begin
//  if not AtivarModem then
//    Exit;

  _Log.Clear;

  try

    SetLength(arrEnviados,0);

    xSL := TStringList.Create;
    xTexto := TStringList.Create;
    try

      _Qry.SQL.Text := 'Select '+
                       ' p.nome,p.telcelular, p.email1'+
                       ' from tabperfil p where 1=1'+
                       iif(dados.regMalaDireta.EnviarEmail,' and Coalesce(p.email1,'''') <> ''''','')+
                       iif(dados.regMalaDireta.EnviarSMS,' and Coalesce(p.telcelular,'''') <> ''''','')+
                       iif(dados.regMalaDireta.Filtro <> '',' and '+dados.regMalaDireta.Filtro,'');

      _Log.Add(_Qry.SQL.Text);

      _Qry.Open;

      while not _Qry.Eof do
      begin
        xSl.Clear;

        xTexto.Text := dados.regMalaDireta.Mensagem;

        For i := 0 To xTexto.Count - 1 do
        begin
          sLinha := xTexto.Strings[i];
          sLinha := TrocaAcentos(StringReplace(sLinha,'@@PERFIL@@',_Qry.FieldByName('Nome').Text,[rfReplaceAll,rfIgnoreCase]));
          xSl.Add(sLinha);
        end;

        if dados.regMalaDireta.EnviarSMS then
        begin
          if EnviarSMS(_Qry.FieldByName('telcelular').Text,xSl.Text) then
            _Log.Add('SMS enviado para '+_Qry.FieldByName('telcelular').Text)
          else
            _Log.Add('SMS não enviado para '+_Qry.FieldByName('telcelular').Text);
        end;

        if dados.regMalaDireta.EnviarEmail then
        begin
          if EnviarEmailAutomatico(vEmail,
                                   _Qry.FieldByName('email1').AsString,
                                   '',
                                   vAssunto,
                                   xSl.Text,
                                   nil,
                                   vArquivo,
                                   vSMTP,
                                   vUsuarioID,
                                   vSenha,
                                   vResponderPara,
                                   vPorta,
                                   vRequerAutenticacao,
                                   vUsarSSL,
                                   vMetodoSSL,
                                   vModoSSL,
                                   vUsarTipoTLS,
                                   vHost_Proxy,
                                   vPorta_Proxy,
                                   vUser_Proxy,
                                   vSenha_Proxy,
                                   True,
                                   _Log) then
            _Log.Add('Email enviado para '+_Qry.FieldByName('email1').Text)
          else
            _Log.Add('Email não enviado para '+_Qry.FieldByName('email1').Text);
        end;

        _Qry.Next;
      end;
    except
      on E: Exception do
      _Log.Add('ERROR:'#13#10+e.Message);
    end;

  finally
    _Log.SaveToFile(ExtractFilePath(Application.ExeName)+'LOG\MALADIRETA'+FormatDateTime('ddMMyyyyhhmmss', now)+'.txt');
    FreeAndNil(xSL);
    FreeAndNil(xTexto);

    dados.regMalaDireta.Iniciar := False;
  end;

end;


procedure Lembrete.EviarEmailAgendas;
var
  xSL, xTemp: TStringList;
  i: Integer;
  sLinha: String;
  arrEnviados: Array of Integer;
begin

  _Log.Clear;

  SetLength(arrEnviados,0);

  xSL := TStringList.Create;
  xTemp := TStringList.Create;
  try
    try
      _Qry.SQL.Text := 'Select '+
                       ' a.codigo,p.nome,p.email1, a.data, a.hora, '+
                       ' upper(trim( '+
                       ' case  '+
                       '   when coalesce(A.SITUACAO, 1) = 1 then ''Em Aberto'''+
                       '   when coalesce(A.SITUACAO, 1) = 2 then ''Cancelada'' || '' - Motivo: '' || coalesce(A.MOTIVOCANCELAMENTO, '''') '+
                       '   when coalesce(A.SITUACAO, 1) = 3 then ''Confirmada'''+
                       '   when coalesce(A.SITUACAO, 1) = 4 then ''Finalizada'''+
                       '   else '''' '+
                       ' end)) as xSituacao'+
                       ' from tabagenda a '+
                       ' left join tabperfil p on a.idperfil = p.codigo '+
                       ' where a.data >= Current_Date '+
                       ' and Coalesce(a.EMAIL_ENVIADO,0) = 0 '+
                       ' and Coalesce(a.idpedidoagenda,0) > 0 '+
                       ' and coalesce(A.SITUACAO, 1) <> 4 '+
                       ' AND Coalesce(p.email1,'''') <> ''''';
      _Qry.Open;

      while not _Qry.Eof do
      begin
        xSl.Clear;
        xTemp.Clear;

        if vTextoOuHTML = 0 then
          xTemp.AddStrings(vTexto)
        else
          xTemp.LoadFromFile(vUrlHtml);

        For i := 0 To xTemp.Count - 1 do
        begin
          sLinha := xTemp.Strings[i];
          sLinha := TrocaAcentos(StringReplace(sLinha,'@@PERFIL@@',_Qry.FieldByName('Nome').Text,[rfReplaceAll,rfIgnoreCase]));
          sLinha := TrocaAcentos(StringReplace(sLinha,'@@DATA@@',FormatDateTime('dd/MM/yyyy',_Qry.FieldByName('data').AsDateTime),[rfReplaceAll,rfIgnoreCase]));
          sLinha := TrocaAcentos(StringReplace(sLinha,'@@HORA@@',FormatDateTime('hh:mm',_Qry.FieldByName('hora').AsDateTime),[rfReplaceAll,rfIgnoreCase]));
          sLinha := TrocaAcentos(StringReplace(sLinha,'@@SITUACAO@@',_Qry.FieldByName('xSituacao').AsString,[rfReplaceAll,rfIgnoreCase]));
          xSl.Add(sLinha);
        end;

        if EnviarEmailAutomatico(vEmail,
                                 _Qry.FieldByName('email1').AsString,
                                 '',
                                 vAssunto,
                                 iif(vTextoOuHTML = 0,xSl.Text,''),
                                 xSL,
                                 vArquivo,
                                 vSMTP,
                                 vUsuarioID,
                                 vSenha,
                                 vResponderPara,
                                 vPorta,
                                 vRequerAutenticacao,
                                 vUsarSSL,
                                 vMetodoSSL,
                                 vModoSSL,
                                 vUsarTipoTLS,
                                 vHost_Proxy,
                                 vPorta_Proxy,
                                 vUser_Proxy,
                                 vSenha_Proxy,
                                 True,
                                 _Log) then
        begin
          SetLength(arrEnviados,length(arrEnviados)+1);
          arrEnviados[length(arrEnviados)-1] := _Qry.FieldByName('codigo').AsInteger;
        end;

        _Qry.Next;
      end;

      _Log.Add(IntToStr(Length(arrEnviados))+' Emails Enviados');


      For i := 0 to Length(arrEnviados) - 1 do
      begin
        _Qry.SQL.Text := 'update TABAGENDA set EMAIL_ENVIADO = 1 where codigo = :codigo';
        _Qry.ParamByName('codigo').AsInteger := arrEnviados[i];
        _Qry.ExecSQL;
        _Qry.Transaction.CommitRetaining;
      end;
    Except
      on E: Exception do
        _Log.Add('Erro ao Gravar no Banco: '+e.Message);
    end;

  finally
    _Log.SaveToFile(ExtractFilePath(Application.ExeName)+'LOG\EMAIL'+FormatDateTime('ddMMyyyyhhmmss', now)+'.txt');
    FreeAndNil(xSL);
    FreeAndNil(xTemp);
  end;
end;

procedure Lembrete.Execute;
var
  iTimeRefresh : tTime;
begin
  { Place thread code here }
  SetName;
  try
    iTimeRefresh := StrToTime('00:00:00');

    while (not Terminated) do
    begin
      if ((now >= ProximoSinc(iTimeRefresh, vTempoX)) or (TimeToStr(iTimeRefresh) = '00:00:00')) then
      begin
        if dados.regMalaDireta.Iniciar then
           prcEnviarMalaDireta()
        else
        begin
          _Qry.SQL.Text := 'select Sum(xCount) xCount from (  '#13+
                           ' --Agendas para o dia      '#13+
                           ' select Count(codigo) xCount '#13+
                           ' from tabagenda ag             '#13+
                           '  where ag.data = :datainicio and ag.hora >= :horainicio '#13+
                           '  and Coalesce(ag.situacao,0) in (0,1,3) '#13+
                           ' union                                   '#13+
                           ' --Pedido de Agenda em Alerta            '#13+
                           ' Select Count(distinct p.codigo)         '#13+
                           ' from tabpedidoagendamento p             '#13+
                           ' left join tabacompanhantespedidoagenda a on p.codigo = a.codigopedido '#13+
                           ' where not Exists(Select ag.codigo from tabagenda ag where ag.idpedidoagenda = p.codigo and ag.idperfil = a.codigoperfil and ag.situacao <> 2) '#13+
                           '   and p.dataevento - current_date <= :diasAlertaPedido '#13+
                           '   and p.datacadastro <= :datapedido                    '#13+
                           ' union                                                  '#13+
                           ' --Produtos necessitando de serviço                    '#13+
                           ' SELECT Count(*)                                        '#13+
                           '  FROM VIEWHISTORICOPRODUTO x                          '#13+
                           ' WHERE X.TIPO = 2                                       '#13+
                           '   and not exists(SELECT FIRST 1 1                      '#13+
                           '                   FROM TABMOVIMENTACAOCONTRATO M       '#13+
                           '                   INNER JOIN TABOS OS ON (M.CODIGOREGISTRO = OS.CODIGO )'#13+
                           '                   WHERE M.CODIGO = X.CODIGOREGISTRO                     '#13+
                           '                   AND M.TIPO = 5)                                       '#13+
                           '   and x.DATAINICIO <= :datahistorico                                    '#13+
                           ' union                                                                   '#13+
                           ' --Parcelas a pagar em Atraso                                            '#13+
                           ' Select count(*)                                                         '#13+
                           ' from tabfinanceiro f                                                    '#13+
                           ' left join tabfinanceirodetalhe fd on f.codigo = fd.codigo               '#13+
                           ' left join TABSITUACAOPRODUTO s on fd.codigosituacao = s.codigo          '#13+
                           ' where fd.datavencimento < :dataFinanceiroPagar                          '#13+
                           '  and f.tipo = 1                                                         '#13+
                           '  and coalesce(s.operacao,0) = 0                                         '#13+
                           ' union                                                                   '#13+
                           ' --Parcelas a receber em Atraso                                          '#13+
                           ' Select count(*)                                                         '#13+
                           ' from tabfinanceiro f                                                    '#13+
                           ' left join tabfinanceirodetalhe fd on f.codigo = fd.codigo               '#13+
                           ' left join TABSITUACAOPRODUTO s on fd.codigosituacao = s.codigo          '#13+
                           ' where fd.datavencimento < :dataFinanceiroReceber                        '#13+
                           '  and f.tipo = 2                                                         '#13+
                           '  and coalesce(s.operacao,0) = 0                                         '#13+
                           ' union                                                                   '#13+
                           ' --Parcelas a pagar de hoje                                              '#13+
                           ' Select count(*)                                                         '#13+
                           ' from tabfinanceiro f                                                    '#13+
                           ' left join tabfinanceirodetalhe fd on f.codigo = fd.codigo               '#13+
                           ' left join TABSITUACAOPRODUTO s on fd.codigosituacao = s.codigo          '#13+
                           ' where fd.datavencimento = :dataFinanceiroPagarHoje                      '#13+
                           '  and f.tipo = 1                                                         '#13+
                           '  and coalesce(s.operacao,0) = 0                                         '#13+
                           ' union                                                                   '#13+
                           ' --Parcelas a receber de hoje                                            '#13+
                           ' Select count(*)                                                         '#13+
                           ' from tabfinanceiro f                                                    '#13+
                           ' left join tabfinanceirodetalhe fd on f.codigo = fd.codigo               '#13+
                           ' left join TABSITUACAOPRODUTO s on fd.codigosituacao = s.codigo          '#13+
                           ' where fd.datavencimento = :dataFinanceiroReceberHoje                    '#13+
                           '  and f.tipo = 2                                                         '#13+
                           '  and coalesce(s.operacao,0) = 0                                         '#13+
                           '  )                                                                      ';

  //             'select Count(codigo) xCount '+
  //             ' from tabagenda ag '+
  //             ' where ag.data = :datainicio and ag.hora >= :horainicio '+
  //             ' and Coalesce(ag.situacao,0) in (0,1,3) ';

          _Qry.ParamByName('datainicio').AsDateTime := now;
          _Qry.ParamByName('horainicio').AsDateTime := now;
          _Qry.ParamByName('datapedido').AsDateTime := now;
          _Qry.ParamByName('datahistorico').AsDateTime := now;
          _Qry.ParamByName('dataFinanceiroPagar').AsDateTime := now;
          _Qry.ParamByName('dataFinanceiroReceber').AsDateTime := now;
          _Qry.ParamByName('dataFinanceiroPagarHoje').AsDateTime := now;
          _Qry.ParamByName('dataFinanceiroReceberHoje').AsDateTime := now;
          _Qry.ParamByName('diasAlertaPedido').AsInteger := vDiasAlertaPedido;

          _Qry.Open;

          _Panel.Caption := IntToStr(_Qry.FieldByName('xCount').AsInteger)+' NOTIFICAÇÕES';

          //Enviar SMS
          if vLembrarAgendaSMS then
            EviarSMSAgendas();

          //Enviar Email
          if vEnviarEmailAgenda then
            EviarEmailAgendas();
        end;

        iTimeRefresh := now;
      end;
    end;
  Except
  end;
  { Place thread code here }
end;

end.

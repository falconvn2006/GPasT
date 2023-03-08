unit Controle.Relatorio.Cadastro.ContasReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Relatorio.Cadastro, frxClass,
  frxExportBaseDialog, frxExportPDF, frxDBSet, uniGUIBaseClasses, uniImageList,
  Data.DB, Datasnap.Provider, Data.Win.ADODB, Datasnap.DBClient, uniButton,
  uniLabel, uniPanel, uniBitBtn, uniDateTimePicker, uniEdit, uniMultiItem,
  uniComboBox, uniCheckBox, uniGroupBox, uniBasicGrid, uniDBGrid, uniScrollBox,
  System.DateUtils;

type
  TControleRelatorioCadastroContasReceber = class(TControleRelatorioCadastro)
    CheckBoxTodosClientes: TUniCheckBox;
    EditCliente: TUniEdit;
    UniLabel2: TUniLabel;
    BtPesquisaCliente: TUniBitBtn;
    GroupBoxSituacao: TUniGroupBox;
    CheckBoxAberto: TUniCheckBox;
    CheckBoxInadimplente: TUniCheckBox;
    CheckBoxLiquidado: TUniCheckBox;
    Relatorio: TfrxReport;
    Conexao: TfrxDBDataset;
    CdsConsultaRAZAO_SOCIAL_EMPRESA: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaNUMERO_DOCUMENTO: TWideStringField;
    CdsConsultaDATA_EMISSAO: TWideStringField;
    CdsConsultaDATA_VENCIMENTO: TDateTimeField;
    CdsConsultaDATA_VENC_ORIGINAL: TDateTimeField;
    CdsConsultaVALOR: TFloatField;
    CdsConsultaRAZAO_SOCIAL_CLIENTE: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaLOGRADOURO: TWideStringField;
    CdsConsultaCIDADE: TWideStringField;
    CdsConsultaTELEFONE: TWideStringField;
    CdsConsultaSEQUENCIA_PARCELAS: TFloatField;
    CdsConsultaLOGOMARCA_CAMINHO: TWideStringField;
    CdsConsultaSITUACAO: TWideStringField;
    CheckBoxNegociado: TUniCheckBox;
    CheckBoxCancelado: TUniCheckBox;
    UniPanelDataCadastro: TUniPanel;
    CbDataCadastro: TUniCheckBox;
    CbDataVencimento: TUniCheckBox;
    UniEditDataCadastroInicio: TUniEdit;
    UniEditDataCadastroFim: TUniEdit;
    UniLabel3: TUniLabel;
    UniLabel4: TUniLabel;
    UniPanelDataVencimento: TUniPanel;
    UniEditDataVencimentoInicio: TUniEdit;
    UniEditDataVencimentoFim: TUniEdit;
    UniLabel5: TUniLabel;
    UniLabel6: TUniLabel;
    CheckBoxParcial: TUniCheckBox;
    CdsConsultaDIAS_EM_ATRASO: TFloatField;
    CdsConsultaPORCENTAGEM_JUROS: TWideStringField;
    CdsConsultaJUROS_DIA: TFloatField;
    procedure CheckBoxTodosClientesClick(Sender: TObject);
    procedure BtImprimirClick(Sender: TObject);
    procedure BtPesquisaClienteClick(Sender: TObject);
    procedure UniFrameCreate(Sender: TObject);
    procedure CbDataCadastroChange(Sender: TObject);
    procedure CbDataVencimentoChange(Sender: TObject);
  private
    idpessoa : string;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Controle.Server.Module,
  Controle.Impressao.Documento,
  Controle.Main.Module,
  Controle.Consulta.Modal.Pessoa;


procedure TControleRelatorioCadastroContasReceber.BtImprimirClick(
  Sender: TObject);
var
  situacao : array[0..5] of string;
  Marcou : Integer;
  i : Integer;
  FFolder, URL, Arquivo: String;
  DtInicial,DtFinal : string;
  Sql : string;
begin
 inherited;
  Marcou :=0;
  for i := 0 to (GroupBoxSituacao.ControlCount -1) do
  begin
    if GroupBoxSituacao.Controls[i].ClassType = TUniCheckBox then
    begin
      if (TUniCheckBox(GroupBoxSituacao.Controls[i]).checked = True) then
      begin
        Marcou := Marcou + 1;
//        situacao[i] := copy(TUniCheckBox(GroupBoxSituacao.Controls[i]).Caption,1,1);
        situacao[i] := TUniCheckBox(GroupBoxSituacao.Controls[i]).Caption;
      end;
    end;
  end;

  if Marcou <=0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','É preciso escolher uma situação para emitir o relatório!');
    Exit;
  end
  else
  begin
    CdsConsulta.Close;
    QryConsulta.SQL.Clear;
    Sql :=
                           ' SELECT'
                          +'        CASE '
                          +'          WHEN tit.data_vencimento < sysdate THEN'
                          +'           (to_date(to_char(sysdate,''dd/mm/yyyy''),''dd/mm/yyyy'') - to_date(to_char(tit.data_vencimento,''dd/mm/yyyy''),''dd/mm/yyyy''))'
                          +'        ELSE'
                          +'          0'
                          +'        END dias_em_atraso,'
                          +'        CASE '
                          +'          WHEN tit.data_vencimento < sysdate THEN'
                          +'               '''+ FloatToStr(ControleMainModule.percentual_juros) +''''
                          +'        ELSE'
                          +'          ''0'''
                          +'        END Porcentagem_juros,'
                          +'        CASE '
                          +'          WHEN tit.data_vencimento < sysdate THEN'
                          +'            tit.valor * LTRIM('+ FloatToStr(ControleMainModule.percentual_juros) +')/100/30 * (to_date(to_char(sysdate,''dd/mm/yyyy''),''dd/mm/yyyy'') - to_date(to_char(tit.data_vencimento,''dd/mm/yyyy''),''dd/mm/yyyy''))'
                          +'        ELSE'
                          +'          0'
                          +'        END Juros_dia,'
                          +'        (SELECT razao_social FROM pessoa WHERE id=fil.id) razao_social_empresa,'
                          +'        tit.id,'
                          +'        tit.numero_documento,'
                          +'        TO_CHAR(tit.data_emissao,''dd/mm/yyyy'') data_emissao,'
                          +'        tit.data_vencimento,'
                          +'        tit.data_venc_original,'
                          +'        tit.valor,'
                          +'        pes.razao_social razao_social_cliente,'
                          +'        CASE pes.tipo'
                          +'          WHEN ''J'' THEN regexp_replace(LPAD( pes.cpf_cnpj, 14, ''0''),''([0-9]{2})([0-9]{3})([0-9]{3})([0-9]{4})([0-9]{2})'',''\1.\2.\3/\4-\5'')'
                          +'          WHEN ''F'' THEN regexp_replace(LPAD( pes.cpf_cnpj, 11, ''0''), ''([0-9]{3})([0-9]{3})([0-9]{3})([0-9]{2})'',''\1.\2.\3-\4'')'
                          +'        END  cpf_cnpj,'
                          +'        ped.logradouro,'
                          +'        cid.nome cidade,'
                          +'        (ped.telefone_1||''/''||ped.celular) telefone,'
                          +'        tit.sequencia_parcelas,'
                          +'        fil.logomarca_caminho,'
                       		+'	CASE '
                          +'        WHEN (tit.situacao = ''A'') AND (TRUNC(tit.data_vencimento) < TRUNC(SYSDATE)) THEN      '
                          +'            ''INADIMPLENTE''                                                                    '
                          +'        WHEN (tit.situacao = ''P'') THEN                                                        '
                          +'            ''PARCIAL''                                                                         '
                          +'        WHEN (tit.situacao = ''A'') THEN                                                        '
                          +'            ''ABERTO''                                                                          '
                          +'        WHEN (tit.situacao = ''L'') THEN                                                        '
                          +'            ''LIQUIDADO''                                                                       '
                          +'        WHEN (tit.situacao = ''C'') THEN                                                        '
                          +'            ''CANCELADO''                                                                       '
                          +'        WHEN (tit.situacao = ''N'') THEN                                                        '
                          +'            ''NEGOCIADO''                                                                       '
                          +'        ELSE                                                                                  '
                          +'          ''OUTRA'' '
                          +'      END situacao '
                          +'   from titulo tit'
                          +'  inner join titulo_receber tir'
                          +'     on tir.id = tit.id'
                          +'  inner join cliente cli'
                          +'     on cli.id = tir.cliente_id'
                          +'  inner join pessoa pes'
                          +'     on pes.id = cli.id'
                          +'  inner join pessoa_endereco ped'
                          +'     on ped.pessoa_id = pes.id'
                          +'   left join fonte.cidade cid'
                          +'     on cid.id = ped.cidade_id'
                          +'  inner join filial fil'
                          +'     on fil.id = tit.filial_id'
                          +'  where ';
                          if CheckBoxTodosClientes.Checked = False then
                            Sql := Sql +'pes.id = ' + idpessoa
                          else
                            Sql := Sql +'pes.id like ''%%''';

//                          Sql := Sql  +'    AND tit.situacao in ('+''''+situacao[0]+''','''+situacao[1]+''','''+situacao[2]+''','''+situacao[3]+''','''+situacao[4]+''')';



               Sql := Sql +' AND nvl(                                                                                            '
                          +'                     CASE                                                                            '
                          +'                WHEN (tit.situacao = ''A'') AND (TRUNC(tit.data_vencimento) < TRUNC(SYSDATE)) THEN   '
                          +'                    ''INADIMPLENTE''                                                                 '
                          +'                WHEN (tit.situacao = ''P'') THEN                                                       '
                          +'                    ''PARCIAL''                                                                      '
                          +'                WHEN (tit.situacao = ''A'') THEN                                                     '
                          +'                    ''ABERTO''                                                                       '
                          +'                WHEN (tit.situacao = ''L'') THEN                                                     '
                          +'                    ''LIQUIDADO''                                                                    '
                          +'                WHEN (tit.situacao = ''C'') THEN                                                     '
                          +'                    ''CANCELADO''                                                                    '
                          +'                WHEN (tit.situacao = ''N'') THEN                                                     '
                          +'                    ''NEGOCIADO''                                                                    '
                          +'                ELSE                                                                                 '
                          +'                  ''OUTRA''                                                                          '
                          +'              END ,'' '') in ('+''''+UpperCase(situacao[0])+''','''+UpperCase(situacao[1])+''','''+UpperCase(situacao[2])+''','''+UpperCase(situacao[3])+''','''+UpperCase(situacao[4])+''','''+UpperCase(situacao[5])+''')';


             if CbDataCadastro.Checked = True then
             begin
               Sql := Sql  + '            and  trunc(tit.data_emissao)'
                           + '        between to_date(''' + Trim(UniEditDataCadastroInicio.Text) + ''', ''dd/mm/yyyy'')'
                           + '            and to_date(''' + Trim(UniEditDataCadastroFim.Text) + ''', ''dd/mm/yyyy'')'
             end;

             if CbDataVencimento.Checked = True then
             begin
               Sql := Sql  + '            and  trunc(tit.data_venc_original)'
                           + '        between to_date(''' + Trim(UniEditDataVencimentoInicio.Text) + ''', ''dd/mm/yyyy'')'
                           + '            and to_date(''' + Trim(UniEditDataVencimentoFim.Text) + ''', ''dd/mm/yyyy'')'
             end;

             Sql := Sql    + '  order by 5 desc';

    QryConsulta.SQL.Text := Sql;
    QryConsulta.SQL.SaveToFile('QryConsulta.txt');
    CdsConsulta.Open;

    if CdsConsulta.RecordCount <=0 then
    begin
      ControleMainModule.MensageiroSweetAlerta('Atenção','Nenhuma informação encontrada com os parametros informado!');
      Exit;
    end
    else
    begin
      Relatorio.Variables.Variables['RazaoEmpresa']         := QuotedStr(ControleMainModule.FRazaoSocial);
      Relatorio.Variables.Variables['DtVencimentoInicial']  := QuotedStr(UniEditDataCadastroInicio.Text);
      Relatorio.Variables.Variables['DtVencimentoFinal']    := QuotedStr(UniEditDataCadastroFim.Text);
      ControleMainModule.ExportarPDF('Relatorio',relatorio);
    end;
  end;
end;


procedure TControleRelatorioCadastroContasReceber.BtPesquisaClienteClick(
  Sender: TObject);
begin
  inherited;
  // Abre o formulário em modal e aguarda
  ControleConsultaModalPessoa.ShowModal(procedure(Sender: TComponent; Result: Integer)
  begin
    if Result = 1 then
    begin
      // Pega o id da pessoa selecionada
      idpessoa := ControleConsultaModalPessoa.CdsConsulta.FieldByName('id').AsString;
      EditCliente.Text := ControleConsultaModalPessoa.CdsConsulta.FieldByName('razao_social').AsString;
    end;
  end);
end;

procedure TControleRelatorioCadastroContasReceber.CheckBoxTodosClientesClick(
  Sender: TObject);
begin
  inherited;
  if CheckBoxTodosClientes.Checked = True then
  begin
    EditCliente.Enabled := False;
    BtPesquisaCliente.Enabled := False;
  end
  else
  begin
    EditCliente.Enabled := True;
    BtPesquisaCliente.Enabled := True;
  end;
end;

procedure TControleRelatorioCadastroContasReceber.CbDataCadastroChange(
  Sender: TObject);
begin
  inherited;
  if CbDataCadastro.Checked = True then
  begin
    UniEditDataCadastroInicio.Text  := DateToStr(StartOfTheMonth(Date));
    UniEditDataCadastroFim.Text     := DateToStr(EndOfTheMonth(Date));
    UniPanelDataCadastro.Visible := True
  end
  else
  begin
    UniEditDataCadastroInicio.Text  := '';
    UniEditDataCadastroFim.Text     := '';
    UniPanelDataCadastro.Visible := False;
  end;
end;

procedure TControleRelatorioCadastroContasReceber.CbDataVencimentoChange(
  Sender: TObject);
begin
  inherited;
  if CbDataVencimento.Checked = True then
  begin
    UniEditDataVencimentoInicio.Text  := DateToStr(StartOfTheMonth(Date));
    UniEditDataVencimentoFim.Text     := DateToStr(EndOfTheMonth(Date));
    UniPanelDataVencimento.Visible := True
  end
  else
  begin
    UniEditDataCadastroInicio.Text  := '';
    UniEditDataCadastroFim.Text     := '';
    UniPanelDataVencimento.Visible := False;
  end;
end;

procedure TControleRelatorioCadastroContasReceber.UniFrameCreate(
  Sender: TObject);
begin
  inherited;
  UniEditDataCadastroInicio.Text  := DateToStr(StartOfTheMonth(Date));
  UniEditDataCadastroFim.Text     := DateToStr(EndOfTheMonth(Date));

  //Verifica se recebe parcial
  if ControleMainModule.CdsParametros.Locate('campo','RECEBE_PARCIAL',[])= True then
  begin
    if ControleMainModule.CdsParametros.FieldByName('valor').AsString = 'S' then
      CheckBoxParcial.Visible := True;
  end;

end;

end.

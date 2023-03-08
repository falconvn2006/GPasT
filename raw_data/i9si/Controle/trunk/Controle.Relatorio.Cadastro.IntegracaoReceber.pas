unit Controle.Relatorio.Cadastro.IntegracaoReceber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Relatorio.Cadastro, uniGUIBaseClasses,
  uniImageList, Data.DB, Datasnap.Provider, Data.Win.ADODB, Datasnap.DBClient,
  uniButton, uniLabel, uniPanel, uniScrollBox, uniMultiItem, uniComboBox,
  uniEdit, uniCheckBox, uniGroupBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, frxClass, frxDBSet, uniBasicGrid, uniDBGrid;

type
  TControleRelatorioCadastroIntegracaoReceber = class(TControleRelatorioCadastro)
    UniLabel2: TUniLabel;
    CbDataCadastro: TUniCheckBox;
    UniEditDataCadastroInicio: TUniEdit;
    UniLabel3: TUniLabel;
    UniEditDataCadastroFim: TUniEdit;
    UniLabel4: TUniLabel;
    FDQueryClientes: TFDQuery;
    UniComboBoxPesquisaCliente: TUniComboBox;
    FDQueryClientesCODIGO: TIntegerField;
    FDQueryClientesNOME: TStringField;
    FDQueryClientesRAZAOSOCIAL: TStringField;
    FDQueryClientesCNPJCPF: TStringField;
    FDQueryClientesINSCRG: TStringField;
    FDQueryClientesINSCRGANT: TStringField;
    FDQueryClientesENDERECO: TStringField;
    FDQueryClientesBAIRRO: TStringField;
    FDQueryClientesCIDADE: TStringField;
    FDQueryClientesESTADO: TStringField;
    FDQueryClientesCEP: TStringField;
    FDQueryClientesFONES: TStringField;
    FDQueryClientesFAX: TStringField;
    FDQueryClientesCELULAR: TStringField;
    FDQueryClientesSITE: TStringField;
    FDQueryClientesEMAIL: TStringField;
    FDQueryClientesTITULAR: TStringField;
    FDQueryClientesFONETIT: TStringField;
    FDQueryClientesCELTIT: TStringField;
    FDQueryClientesDTNASC: TDateField;
    FDQueryClientesDTCAD: TDateField;
    FDQueryClientesULTCOMPRA: TDateField;
    FDQueryClientesVLRCOMPRA: TFloatField;
    FDQueryClientesINFORPES1: TStringField;
    FDQueryClientesFONEPES1: TStringField;
    FDQueryClientesINFORPES2: TStringField;
    FDQueryClientesFONEPES2: TStringField;
    FDQueryClientesINFORPES3: TStringField;
    FDQueryClientesFONEPES3: TStringField;
    FDQueryClientesINFCOM1: TStringField;
    FDQueryClientesCONTCOM1: TStringField;
    FDQueryClientesFONECOM1: TStringField;
    FDQueryClientesINFCOM2: TStringField;
    FDQueryClientesCONTCOM2: TStringField;
    FDQueryClientesFONECOM2: TStringField;
    FDQueryClientesINFCOM3: TStringField;
    FDQueryClientesCONTCOM3: TStringField;
    FDQueryClientesFONECOM3: TStringField;
    FDQueryClientesOBS: TMemoField;
    FDQueryClientesFOTO: TBlobField;
    FDQueryClientesPAI: TStringField;
    FDQueryClientesMAE: TStringField;
    FDQueryClientesCONJUGE: TStringField;
    FDQueryClientesLIMITE: TSingleField;
    FDQueryClientesMARCA: TStringField;
    FDQueryClientesSEXO: TStringField;
    FDQueryClientesDATA: TDateField;
    FDQueryClientesNATURALIDADE: TStringField;
    FDQueryClientesUFNAT: TStringField;
    FDQueryClientesCARGO: TStringField;
    FDQueryClientesEMPRESA: TStringField;
    FDQueryClientesRENDA: TSingleField;
    FDQueryClientesESTCIV: TStringField;
    FDQueryClientesTRABCONJ: TStringField;
    FDQueryClientesFONECONJ: TStringField;
    FDQueryClientesENDCOM: TStringField;
    FDQueryClientesBAICOM: TStringField;
    FDQueryClientesCIDCOM: TStringField;
    FDQueryClientesESTCOM: TStringField;
    FDQueryClientesCEPCOM: TStringField;
    FDQueryClientesFONECOM: TStringField;
    FDQueryClientesFONETRAB: TStringField;
    FDQueryClientesTEMPO: TStringField;
    FDQueryClientesSPC: TStringField;
    FDQueryConsulta: TFDQuery;
    FDQueryConsultaNUMPEDIDO: TIntegerField;
    FDQueryConsultaVALOR: TFloatField;
    FDQueryConsultaVENCIM: TDateField;
    FDQueryConsultaDIAS_ATRASO: TIntegerField;
    FDQueryConsultaTRANSFERIDO: TStringField;
    FDQueryConsultaCODIGO: TIntegerField;
    FDQueryConsultaNOME: TStringField;
    FDQueryConsultaRAZAOSOCIAL: TStringField;
    FDQueryConsultaENDERECO: TStringField;
    FDQueryConsultaBAIRRO: TStringField;
    FDQueryConsultaCNPJCPF: TStringField;
    FDQueryConsultaINSCRG: TStringField;
    FDQueryConsultaESTADO: TStringField;
    FDQueryConsultaCEP: TStringField;
    FDQueryConsultaFONES: TStringField;
    FDQueryConsultaFAX: TStringField;
    FDQueryConsultaCELULAR: TStringField;
    FDQueryConsultaEMAIL: TStringField;
    FDQueryConsultaDTNASC: TDateField;
    FDQueryConsultaDTCAD: TDateField;
    FDQueryConsultaOBS: TMemoField;
    FDQueryConsultaSEXO: TStringField;
    FDQueryConsultaESTCIV: TStringField;
    FDQueryConsultaMAE: TStringField;
    FDQueryConsultaPAI: TStringField;
    Relatorio: TfrxReport;
    Conexao: TfrxDBDataset;
    FDQueryConsultaNUMERO: TIntegerField;
    FDQueryConsultaCODCLI: TIntegerField;
    FDQueryConsultaREFER: TStringField;
    FDQueryConsultaTIPO: TStringField;
    FDQueryConsultaEMISSAO: TDateField;
    FDQueryConsultaORIGINAL: TFloatField;
    FDQueryConsultaPAGTO: TFloatField;
    FDQueryConsultaDTPAG: TDateField;
    FDQueryConsultaVLRATUAL: TFloatField;
    FDQueryConsultaTOTPAG: TFloatField;
    FDQueryConsultaPARC: TIntegerField;
    FDQueryConsultaQPARC: TIntegerField;
    FDQueryConsultaJUROS: TFloatField;
    FDQueryConsultaJUROSACUM: TFloatField;
    FDQueryConsultaDESCONTO: TFloatField;
    FDQueryConsultaDESCONTOACUM: TFloatField;
    FDQueryConsultaSIT: TStringField;
    FDQueryConsultaCODVEN: TIntegerField;
    FDQueryConsultaCODCONTA: TStringField;
    FDQueryConsultaNOMECONTA: TStringField;
    FDQueryConsultaNUMDOC: TStringField;
    FDQueryConsultaEXT: TStringField;
    FDQueryConsultaCIDADE: TStringField;
    FDQueryConsultaSOMAVALOR: TAggregateField;
    FDQueryConsultaSOMAJUROS: TAggregateField;
    FDQueryConsultaSOMATOTAL: TAggregateField;
    UniCheckBoxCalcularJuros: TUniCheckBox;
    DataSource1: TDataSource;
    FDQueryConsultaJUROS_CALC: TFloatField;
    FDQueryConsultaVALOR_CALC: TFloatField;
    procedure UniFrameCreate(Sender: TObject);
    procedure BtImprimirClick(Sender: TObject);
    procedure CbDataCadastroChange(Sender: TObject);
    procedure UniComboBoxPesquisaClienteChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  var
    IdClienteSelecionado : Integer = 0;

implementation

{$R *.dfm}

uses
 Controle.Main.Module, System.DateUtils;

procedure TControleRelatorioCadastroIntegracaoReceber.BtImprimirClick(
  Sender: TObject);
var
  Sql : string;
begin
  inherited;

  if UniComboBoxPesquisaCliente.Text = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','É preciso escolher ao menos um cliente!');
    UniComboBoxPesquisaCliente.SetFocus;
    Exit;
  end;

  if IdClienteSelecionado = 0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Id do cliente está zerado.');
    Exit;
  end;

  FDQueryConsulta.Close;
  FDQueryConsulta.SQL.Clear;
  Sql := '	SELECT'
        +'		rec.NUMPEDIDO,'
        +'		(rec.ORIGINAL - COALESCE( rec.TOTPAG, 0.0)) as valor,'
        +'		rec.VENCIM,'
        +'	  CASE'
        +'	    WHEN rec.VENCIM < CURRENT_DATE THEN'
        +'	         CURRENT_DATE - rec.VENCIM'
        +'	    ELSE'
        +'	      0'
        +'	  END dias_atraso,'
//        +'	  NULLIF(rec.TRANSFERIDO,''N'') TRANSFERIDO,'
        +'	  rec.TRANSFERIDO,'
        +'	  cli.codigo,'
        +'	  cli.nome,'
        +'	  cli.razaosocial,'
        +'	  cli.endereco,'
        +'	  cli.bairro,'
        +'	  cli.cnpjcpf,'
        +'	  cli.inscrg,'
        +'	  cli.estado,'
        +'	  cli.cep,'
        +'	  cli.fones,'
        +'	  cli.fax,'
        +'	  cli.celular,'
        +'	  cli.email,'
        +'	  cli.dtnasc,'
        +'	  cli.dtcad,'
        +'	  cli.obs,'
        +'	  cli.sexo,'
        +'	  cli.estciv,'
        +'	  cli.mae,'
        +'	  cli.pai,'
        +'	  cli.cidade,'
        +'	  rec.NUMERO,'
        +'	  rec.CODCLI,'
        +'	  rec.NOME,'
        +'	  rec.REFER,'
        +'	  rec.TIPO,'
        +'	  rec.EMISSAO,'
        +'	  rec.ORIGINAL,'
        +'	  rec.PAGTO,'
        +'	  rec.DTPAG,'
        +'	  rec.VLRATUAL,'
        +'	  rec.TOTPAG,'
        +'	  rec.OBS,'
        +'	  rec.PARC,'
        +'	  rec.QPARC,'
        +'	  rec.JUROS,';

  if UniCheckBoxCalcularJuros.Checked = True then
  begin
    Sql := Sql
          +'	  CASE'
          +'	    WHEN rec.VENCIM < CURRENT_DATE THEN'
          +'	           (((rec.VLRATUAL * '+ StringReplace(FloatTostr((ControleMainModule.percentual_juros/100)), ',', '.', [rfReplaceAll]) +')/ 30) * (CURRENT_DATE - rec.VENCIM))'
          +'	    ELSE'
          +'	      0'
          +'	  END juros_calc,'
          +'	  CASE'
          +'	    WHEN rec.VENCIM < CURRENT_DATE THEN'
          +'	      rec.VLRATUAL + (((rec.VLRATUAL * '+ StringReplace(FloatTostr((ControleMainModule.percentual_juros/100)), ',', '.', [rfReplaceAll])+') / 30) * (CURRENT_DATE - rec.VENCIM))'
          +'	    ELSE'
          +'	      rec.VLRATUAL'
          +'	  END valor_calc,';
  end
  else
  begin
    Sql := Sql
          +'	  juros juros_calc,'
          +'	  rec.VLRATUAL valor_calc,';
  end;

    Sql := Sql
        +'	  rec.JUROSACUM,'
        +'	  rec.DESCONTO,'
        +'	  rec.DESCONTOACUM,'
        +'	  rec.SIT,'
        +'	  rec.CODVEN,'
        +'	  rec.CODCONTA,'
        +'	  rec.NOMECONTA,'
        +'	  rec.NUMDOC,'
        +'	  rec.EXT'
        +'	FROM'
        +'		RECEBER rec'
        +'	LEFT join clientes cli'
        +'	  ON cli.codigo = rec.codcli'
        +'	WHERE CLI.codigo = '+ IntToStr(IdClienteSelecionado);


  FDQueryConsulta.SQL.Text := Sql;
  FDQueryConsulta.SQL.SaveToFile('text1.txt');
  FDQueryConsulta.Open;

  if FDQueryConsulta.RecordCount <=0 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção','Nenhuma informação encontrada com os parametros informado!');
    Exit;
  end
  else
  begin
    Relatorio.Variables.Variables['RazaoEmpresa']         := QuotedStr(ControleMainModule.FRazaoSocial);
    Relatorio.Variables.Variables['DtCadastroInicial']    := QuotedStr(UniEditDataCadastroInicio.Text);
    Relatorio.Variables.Variables['DtCadastroFinal']      := QuotedStr(UniEditDataCadastroFim.Text);

    ControleMainModule.ExportarPDF('Relatorio',relatorio);
  end;
end;

procedure TControleRelatorioCadastroIntegracaoReceber.CbDataCadastroChange(
  Sender: TObject);
begin
  inherited;
  if CbDataCadastro.Checked then
  begin
    UniEditDataCadastroInicio.Text    := DateToStr(StartOfTheMonth(Date));
    UniEditDataCadastroFim.Text       := DateToStr(EndOfTheMonth(Date));
    UniEditDataCadastroInicio.Enabled := True;
    UniEditDataCadastroFim.Enabled    := True;
  end
  else
  begin
    UniEditDataCadastroInicio.Enabled := False;
    UniEditDataCadastroFim.Enabled := False;
  end;
end;

procedure TControleRelatorioCadastroIntegracaoReceber.UniComboBoxPesquisaClienteChange(
  Sender: TObject);
begin
  inherited;
  if FDQueryClientes.Locate('NOME', UniComboBoxPesquisaCliente.Text, []) then
  begin
    IdClienteSelecionado := FDQueryClientesCODIGO.AsInteger;
  end;
end;

procedure TControleRelatorioCadastroIntegracaoReceber.UniFrameCreate(
  Sender: TObject);
begin
  inherited;
  if ControleMainModule.ConectaBancoIntegracao then
  begin
    With UniComboBoxPesquisaCliente do
    begin
      Clear;
      FDQueryClientes.Close;
      FDQueryClientes.Open;
      FDQueryClientes.First;
      while not FDQueryClientes.eof do
      begin
        Items.Add(FDQueryClientesNOME.AsString);
        FDQueryClientes.Next;
      end;
      FDQueryClientes.First;
    end;
  end;
end;

end.

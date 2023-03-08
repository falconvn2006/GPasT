unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Vcl.StdCtrls, FireDAC.Moni.Base,
  FireDAC.Moni.FlatFile, FireDAC.Phys.IBBase, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,System.IniFiles, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, MidasLib;

type
  TIntegracao = record
    VendorLib : string;
    Database  : string;
    UserName  : string;
    Password  : string;
    Protocol  : string;
    Server    : string;
  end;


type
  TForm3 = class(TForm)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDMoniFlatFileClientLink1: TFDMoniFlatFileClientLink;
    Button1: TButton;
    DBGrid1: TDBGrid;
    CdsAx1: TClientDataSet;
    ADOConnection: TADOConnection;
    DspAx1: TDataSetProvider;
    QryAx1: TADOQuery;
    FDQuery2: TFDQuery;
    FDQuery3: TFDQuery;
    FDQuery4: TFDQuery;
    FDQuery5: TFDQuery;
    FDQuery6: TFDQuery;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    ADOQuery3: TADOQuery;
    ADOQuery4: TADOQuery;
    ADOQuery5: TADOQuery;
    ADOQuery6: TADOQuery;
    Memo1: TMemo;
    DspAx2: TDataSetProvider;
    QryAx2: TADOQuery;
    CdsAx2: TClientDataSet;
    DspAx3: TDataSetProvider;
    QryAx3: TADOQuery;
    CdsAx3: TClientDataSet;
    DspAx4: TDataSetProvider;
    QryAx4: TADOQuery;
    CdsAx4: TClientDataSet;
    DspAx5: TDataSetProvider;
    QryAx5: TADOQuery;
    CdsAx5: TClientDataSet;
    DspAx6: TDataSetProvider;
    QryAx6: TADOQuery;
    CdsAx6: TClientDataSet;
    DspAx7: TDataSetProvider;
    QryAx7: TADOQuery;
    CdsAx7: TClientDataSet;
    CdsAx8: TClientDataSet;
    QryAx8: TADOQuery;
    DspAx8: TDataSetProvider;
    CdsAx9: TClientDataSet;
    QryAx9: TADOQuery;
    DspAx9: TDataSetProvider;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function LerIniIntegracao: TIntegracao;
    function ConectaBanco: Boolean;
    function GeraId(Tabela: String): Integer;
    function GeraCPF(const Ponto: Boolean): string;
    function ProcuraCpfCnpj(cpf_cnpj: string): Boolean;
    function ProcuraCondicoesPagamento(descricao: string): integer;
    function RemoveMascara(Texto: String): String;
    function ProcuraClienteID(id : integer): integer;
    function ProcuraTitulo(TituloId: integer): integer;
    function ProcuraClienteNome(Razao: string): integer;
    function ProcuraCpf_Cnpj(cpf_cnpj: string): integer;
    function ProcuraCidade(cidade : string): string;
    function ProcuraBanco(banco: string): integer;
    function ProcuraChequeDestino(Destino: integer): integer;
    function ProcuraEmitente(cpf_cnpj, Nome: string): Integer;
    function ProcuraChequeCabecalho(id: integer): integer;
    function ProcuraCheque(id: integer): integer;
    function ProcuraFornecedorId(id: integer): integer;
    function ProcuraClienteNomeBoolean(Razao: string): Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  DadosAdicionaisId,
  EnderecoGEId,
  PessoaId,
  TipoQtd,
  CelularQtd,
  CondicoesPagamento,
  TituloId,
  TituloReceberId,
  TituloPagarId,
  TituloPagamentosId,
  ChequeId,
  ChequeDestinoId,
  ChequeBaixaCabecalhoId,
  ChequeBaixaItensId,
  CategoriaId : Integer;

  NomeCliente,
  Tipo,
  CpfCnpj,
  Celular,
  CidadeId,
  Obs,
  MotivoDevolucao,
  Erro : string;
  currentDate: TDateTime;
begin
  currentDate := Now;

  Erro := '';
  if ConectaBanco then
  begin
    Memo1.Lines.Add(DateToStr(currentDate) + ' - ' + TimeToStr(currentDate)) ;
    // Passo 2 - Salva os dados da pessoa
    QryAx4.Parameters.Clear;
    QryAx4.SQL.Clear;

    CdsAx4.Close;
    QryAx4.SQL.Add(' SELECT  c.id,                                                                     '
                  +'	TRANSLATE((upper(c.NOME) || ''-'' || e.UF),                                 '
                  +'				''ŠŽšžŸÁÇÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕËÜÏÖÑÝåáçéíóúàèìòùâêîôûãõëüïöñýÿ?'',         '
                  +'				''SZszYACEIOUAEIOUAEIOUAOEUIONYaaceiouaeiouaeiouaoeuionyy'') CIDADE   '
                  +'  FROM                                                                        '
                  +'  	fonte.CIDADE c                                                            '
                  +'  INNER JOIN fonte.ESTADO E ON                                                '
                  +'  	E.ID = c.ESTADO_ID                                                        ');
    CdsAx4.Open;



    // Passo 2 - Salva os dados da pessoa
    QryAx7.Parameters.Clear;
    QryAx7.SQL.Clear;

    CdsAx7.Close;
    QryAx7.SQL.Add('SELECT id,codigo,nome,ISBP FROM FONTE.BANCOS');
    CdsAx7.Open;



    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
               'SELECT '
            	+'ID_CLIENTE id,'
	            +'''tipo'' tipo,'
	            +' upper(nome) razao_social,'
	            +' upper(FANTASIA) nome_fantasia,'
	            +'cpf cpf_cnpj,'
	            +'rg rg_insc_estadual,'
	            +'DATANASCIMENTO DATA_NASCIMENTO,'
	            +'SEXO,'
	            +'NOMEMAE nome_mae,'
	            +'NOMEPAI nome_pai,'
              +'ID_CLIENTE PESSOA_ID,'
              +'''GE'' TIPO,'
              +'ENDERECO LOGRADOURO,'
              +'NUMERO,'
              +'COMPLEMENTO,'
              +'CEP,'
              +'BAIRRO,'
              +'FONE1 TELEFONE_1,'
              +'FONE2 TELEFONE_2,'
              +'CELULAR,'
              +'EMAIL '
	            +'FROM CLIENTES c ';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;



    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
       // Passo 1 - Salva os dados da pessoa
      ADOQuery1.Parameters.Clear;
      ADOQuery1.SQL.Clear;

      if Erro = '' then
      begin
        // Gera um novo id para a pessoa
        PessoaId := GeraId('pessoa');

        ADOQuery1.SQL.Add('INSERT INTO pessoa (');
        ADOQuery1.SQL.Add('       id,');
        ADOQuery1.SQL.Add('       tipo,');
        ADOQuery1.SQL.Add('       razao_social,');
        ADOQuery1.SQL.Add('       nome_fantasia,');
        ADOQuery1.SQL.Add('       cpf_cnpj,');
        ADOQuery1.SQL.Add('       rg_insc_estadual,');
        ADOQuery1.SQL.Add('       data_nascimento,');
        ADOQuery1.SQL.Add('       integracao_id)');
        ADOQuery1.SQL.Add('VALUES (');
        ADOQuery1.SQL.Add('       :id,');
        ADOQuery1.SQL.Add('       :tipo,');
        ADOQuery1.SQL.Add('       :razao_social,');
        ADOQuery1.SQL.Add('       :nome_fantasia,');
        ADOQuery1.SQL.Add('       :cpf_cnpj,');
        ADOQuery1.SQL.Add('       :rg_insc_estadual,');
        ADOQuery1.SQL.Add('       :data_nascimento,');
        ADOQuery1.SQL.Add('       :integracao_id)');

        TipoQtd := Length(FDQuery1.FieldByName('cpf_cnpj').AsString);
        if TipoQtd = 14 then
        begin
          Tipo := 'J';
          CpfCnpj := FDQuery1.FieldByName('cpf_cnpj').AsString;
        end
        else if TipoQtd = 11 then
        begin
          Tipo := 'F' ;
          CpfCnpj:= FDQuery1.FieldByName('cpf_cnpj').AsString;
        end
        else
        begin
          Tipo := 'F';
          CpfCnpj:= GeraCPF(False);
        end;

        ADOQuery1.Parameters.ParamByName('id').Value                 := PessoaId;
        ADOQuery1.Parameters.ParamByName('tipo').Value               := Tipo;
        ADOQuery1.Parameters.ParamByName('razao_social').Value       := FDQuery1.FieldByName('razao_social').AsString;
        ADOQuery1.Parameters.ParamByName('nome_fantasia').Value      := FDQuery1.FieldByName('nome_fantasia').AsString;
        ADOQuery1.Parameters.ParamByName('cpf_cnpj').Value           := CpfCnpj;
        ADOQuery1.Parameters.ParamByName('rg_insc_estadual').Value   := FDQuery1.FieldByName('rg_insc_estadual').AsString;
        ADOQuery1.Parameters.ParamByName('data_nascimento').Value    := FDQuery1.FieldByName('data_nascimento').AsDateTime;
        ADOQuery1.Parameters.ParamByName('integracao_id').Value      := FDQuery1.FieldByName('id').AsString;

        try
          // Tenta salvar os dados
          ADOQuery1.ExecSQL;
          Application.ProcessMessages;
        except
          on E: Exception do
          begin
           Erro := (E.Message);
           Memo1.Lines.Add(Erro);
           Break;
          end;
        end;
      end;


      if Erro = '' then
      begin
        // Gera um novo id para a pessoa
        EnderecoGEId := GeraId('pessoa_endereco');

        ADOQuery2.Parameters.Clear;
        ADOQuery2.SQL.Clear;

        // Insert
        ADOQuery2.SQL.Add('INSERT INTO pessoa_endereco (');
        ADOQuery2.SQL.Add('       id,');
        ADOQuery2.SQL.Add('       pessoa_id,');
        ADOQuery2.SQL.Add('       tipo,');
        ADOQuery2.SQL.Add('       logradouro,');
        ADOQuery2.SQL.Add('       numero,');
        ADOQuery2.SQL.Add('       complemento,');
        ADOQuery2.SQL.Add('       cep,');
        ADOQuery2.SQL.Add('       bairro,');
        ADOQuery2.SQL.Add('       cidade_id,');
        ADOQuery2.SQL.Add('       telefone_1,');
        ADOQuery2.SQL.Add('       telefone_2,');
        ADOQuery2.SQL.Add('       celular,');
        ADOQuery2.SQL.Add('       email)');
        ADOQuery2.SQL.Add('VALUES (');
        ADOQuery2.SQL.Add('       :id,');
        ADOQuery2.SQL.Add('       :pessoa_id,');
        ADOQuery2.SQL.Add('       ''GE'',');
        ADOQuery2.SQL.Add('       :logradouro,');
        ADOQuery2.SQL.Add('       :numero,');
        ADOQuery2.SQL.Add('       :complemento,');
        ADOQuery2.SQL.Add('       :cep,');
        ADOQuery2.SQL.Add('       :bairro,');
        ADOQuery2.SQL.Add('       :cidade_id,');
        ADOQuery2.SQL.Add('       :telefone_1,');
        ADOQuery2.SQL.Add('       :telefone_2,');
        ADOQuery2.SQL.Add('       :celular,');
        ADOQuery2.SQL.Add('       :email)');

        ADOQuery2.Parameters.ParamByName('pessoa_id').Value        := PessoaId;
        ADOQuery2.Parameters.ParamByName('id').Value               := EnderecoGEId;
        ADOQuery2.Parameters.ParamByName('logradouro').Value       := FDQuery1.FieldByName('logradouro').AsString;
        ADOQuery2.Parameters.ParamByName('numero').Value           := FDQuery1.FieldByName('numero').AsString;
        ADOQuery2.Parameters.ParamByName('complemento').Value      := FDQuery1.FieldByName('complemento').AsString;
        ADOQuery2.Parameters.ParamByName('cep').Value              := FDQuery1.FieldByName('cep').AsString;
        ADOQuery2.Parameters.ParamByName('bairro').Value           := FDQuery1.FieldByName('bairro').AsString;
        ADOQuery2.Parameters.ParamByName('telefone_1').Value       := FDQuery1.FieldByName('telefone_1').AsString;
        ADOQuery2.Parameters.ParamByName('telefone_2').Value       := FDQuery1.FieldByName('telefone_2').AsString;

        CelularQtd := Length(FDQuery1.FieldByName('celular').AsString);

        if CelularQtd = 7 then
        begin
          Celular := '819'+ FDQuery1.FieldByName('celular').AsString;
        end
        else if CelularQtd = 8 then
        begin
          Celular := '81'+ FDQuery1.FieldByName('celular').AsString;
        end
        else if CelularQtd <=0 then
        begin
          Celular := '8199810629'
        end
        else
        begin
          Celular := FDQuery1.FieldByName('celular').AsString;
        end;

        ADOQuery2.Parameters.ParamByName('celular').Value          := Celular;

        if FDQuery1.FieldByName('email').AsString = '' then
          ADOQuery2.Parameters.ParamByName('email').Value          := 'bergtecidos@gmail.com'
        else
          ADOQuery2.Parameters.ParamByName('email').Value          := FDQuery1.FieldByName('email').AsString;

        ADOQuery2.Parameters.ParamByName('cidade_id').Value        := '';
      end;

      try
        // Tenta salvar os dados
        ADOQuery2.ExecSQL;
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Erro := (E.Message);
          Memo1.Lines.Add(Erro);
          Break;
        end;
      end;


      if Erro = '' then
      begin
        ADOQuery3.Parameters.Clear;
        ADOQuery3.SQL.Clear;

        // Insert
        ADOQuery3.SQL.Add('INSERT INTO cliente (');
        ADOQuery3.SQL.Add('       id)');
        ADOQuery3.SQL.Add('VALUES (');
        ADOQuery3.SQL.Add('       :id)');

        ADOQuery3.Parameters.ParamByName('id').Value := PessoaId;

       try
        // Tenta salvar os dados
         ADOQuery3.ExecSQL;
         Application.ProcessMessages;
       except
        on E: Exception do
        begin
          Erro := (E.Message);
          Memo1.Lines.Add(Erro);
          Break;
        end;
       end;
      end;


      if Erro = '' then
      begin
        ADOQuery4.Parameters.Clear;
        ADOQuery4.SQL.Clear;


        //gera novo codigo
        DadosAdicionaisId:= GeraId('cliente_dados_adicionais');

        // Insert
        ADOQuery4.SQL.Add('INSERT INTO cliente_dados_adicionais (');
        ADOQuery4.SQL.Add('       id,');
        ADOQuery4.SQL.Add('       cliente_id,');
        ADOQuery4.SQL.Add('       nome_mae,');
        ADOQuery4.SQL.Add('       nome_pai)');
        ADOQuery4.SQL.Add('VALUES (');
        ADOQuery4.SQL.Add('       :id,');
        ADOQuery4.SQL.Add('       :cliente_id,');
        ADOQuery4.SQL.Add('       :nome_mae,');
        ADOQuery4.SQL.Add('       :nome_pai)');


        ADOQuery4.Parameters.ParamByName('id').Value                      := DadosAdicionaisId;
        ADOQuery4.Parameters.ParamByName('cliente_id').Value              := PessoaId;
        ADOQuery4.Parameters.ParamByName('nome_mae').Value                := FDQuery1.FieldByName('nome_mae').AsString;
        ADOQuery4.Parameters.ParamByName('nome_pai').Value                := FDQuery1.FieldByName('nome_pai').AsString;

        try
          // Tenta salvar os dados
          ADOQuery4.ExecSQL;
          Application.ProcessMessages;
        except
          on E: Exception do
          begin
            Erro := (E.Message);
            Memo1.Lines.Add(Erro);
            Break;
          end;
        end;
      end;

      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu pessoa!');
    end;


  end;
//
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
  Erro := '';
  if ConectaBanco then
  begin
   With FDQuery1 do
   begin
      SQL.Clear;
      SQL.Text :=
                 'SELECT '
                +'f.ID_FORNECEDOR id,'
                +'f.RAZAOSOCIAL RAZAO_SOCIAL,'
                +'f.NOMEFANTASIA NOME_FANTASIA,'
                +'f.CNPJ CPF_CNPJ,'
                +'f.INSCRICAOESTADUAL RG_INSC_ESTADUAL,'
                +'f.DATACADASTRO DATA_ABERTURA_EMPRESA,'
                +'f.ID_FORNECEDOR PESSOA_ID,'
                +'''TIPO'' TIPO,'
                +'f.ENDERECO LOGRADOURO,'
                +'f.NUMERO,'
                +'f.COMPLEMENTO,'
                +'f.CEP,'
                +'f.BAIRRO,'
                +'f.TELEFONE1 TELEFONE_1,'
                +'f.TELEFONE2 TELEFONE_2,'
                +'f.CELULAR,'
                +'f.EMAL '
                +'FROM FORNECEDOR f '
    end;
    FDQuery1.Open();

// Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;



    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
       // Passo 2 - Salva os dados da pessoa
      ADOQuery1.Parameters.Clear;
      ADOQuery1.SQL.Clear;

      if Erro = '' then
      begin
        // Gera um novo id para a pessoa
        PessoaId := GeraId('pessoa');

        ADOQuery1.SQL.Add('INSERT INTO pessoa (');
        ADOQuery1.SQL.Add('       id,');
        ADOQuery1.SQL.Add('       tipo,');
        ADOQuery1.SQL.Add('       razao_social,');
        ADOQuery1.SQL.Add('       nome_fantasia,');
        ADOQuery1.SQL.Add('       cpf_cnpj,');
        ADOQuery1.SQL.Add('       rg_insc_estadual,');
        ADOQuery1.SQL.Add('       data_abertura_empresa,');
        ADOQuery1.SQL.Add('       integracao_id)');
        ADOQuery1.SQL.Add('VALUES (');
        ADOQuery1.SQL.Add('       :id,');
        ADOQuery1.SQL.Add('       :tipo,');
        ADOQuery1.SQL.Add('       :razao_social,');
        ADOQuery1.SQL.Add('       :nome_fantasia,');
        ADOQuery1.SQL.Add('       :cpf_cnpj,');
        ADOQuery1.SQL.Add('       :rg_insc_estadual,');
        ADOQuery1.SQL.Add('       :data_abertura_empresa,');
        ADOQuery1.SQL.Add('       :integracao_id)');

        TipoQtd := Length(FDQuery1.FieldByName('cpf_cnpj').AsString);
        if TipoQtd = 14 then
        begin
          Tipo := 'J';
          CpfCnpj := FDQuery1.FieldByName('cpf_cnpj').AsString;
        end
        else if TipoQtd = 11 then
        begin
          Tipo := 'F' ;
          CpfCnpj:= FDQuery1.FieldByName('cpf_cnpj').AsString;
        end
        else
        begin
          Tipo := 'F';
          CpfCnpj:= GeraCPF(False);
        end;

        ADOQuery1.Parameters.ParamByName('id').Value                       := PessoaId;
        ADOQuery1.Parameters.ParamByName('tipo').Value                     := Tipo;
        ADOQuery1.Parameters.ParamByName('razao_social').Value             := FDQuery1.FieldByName('razao_social').AsString;
        ADOQuery1.Parameters.ParamByName('nome_fantasia').Value            := FDQuery1.FieldByName('nome_fantasia').AsString;
        ADOQuery1.Parameters.ParamByName('cpf_cnpj').Value                 := CpfCnpj;
        ADOQuery1.Parameters.ParamByName('rg_insc_estadual').Value         := FDQuery1.FieldByName('rg_insc_estadual').AsString;
        ADOQuery1.Parameters.ParamByName('data_abertura_empresa').Value    := FDQuery1.FieldByName('DATA_ABERTURA_EMPRESA').AsDateTime;
        ADOQuery1.Parameters.ParamByName('integracao_id').Value            := FDQuery1.FieldByName('id').AsString;

        try
          // Tenta salvar os dados
          ADOQuery1.ExecSQL;
          Application.ProcessMessages;
        except
          on E: Exception do
          begin
           Erro := (E.Message);
           Memo1.Lines.Add(Erro);
           Break;
          end;
        end;
      end;


      if Erro = '' then
      begin
        // Gera um novo id para a pessoa
        EnderecoGEId := GeraId('pessoa_endereco');

        ADOQuery2.Parameters.Clear;
        ADOQuery2.SQL.Clear;

        // Insert
        ADOQuery2.SQL.Add('INSERT INTO pessoa_endereco (');
        ADOQuery2.SQL.Add('       id,');
        ADOQuery2.SQL.Add('       pessoa_id,');
        ADOQuery2.SQL.Add('       tipo,');
        ADOQuery2.SQL.Add('       logradouro,');
        ADOQuery2.SQL.Add('       numero,');
        ADOQuery2.SQL.Add('       complemento,');
        ADOQuery2.SQL.Add('       cep,');
        ADOQuery2.SQL.Add('       bairro,');
        ADOQuery2.SQL.Add('       cidade_id,');
        ADOQuery2.SQL.Add('       telefone_1,');
        ADOQuery2.SQL.Add('       telefone_2,');
        ADOQuery2.SQL.Add('       celular,');
        ADOQuery2.SQL.Add('       email)');
        ADOQuery2.SQL.Add('VALUES (');
        ADOQuery2.SQL.Add('       :id,');
        ADOQuery2.SQL.Add('       :pessoa_id,');
        ADOQuery2.SQL.Add('       ''GE'',');
        ADOQuery2.SQL.Add('       :logradouro,');
        ADOQuery2.SQL.Add('       :numero,');
        ADOQuery2.SQL.Add('       :complemento,');
        ADOQuery2.SQL.Add('       :cep,');
        ADOQuery2.SQL.Add('       :bairro,');
        ADOQuery2.SQL.Add('       :cidade_id,');
        ADOQuery2.SQL.Add('       :telefone_1,');
        ADOQuery2.SQL.Add('       :telefone_2,');
        ADOQuery2.SQL.Add('       :celular,');
        ADOQuery2.SQL.Add('       :email)');

        ADOQuery2.Parameters.ParamByName('pessoa_id').Value        := PessoaId;
        ADOQuery2.Parameters.ParamByName('id').Value               := EnderecoGEId;
        ADOQuery2.Parameters.ParamByName('logradouro').Value       := FDQuery1.FieldByName('logradouro').AsString;
        ADOQuery2.Parameters.ParamByName('numero').Value           := FDQuery1.FieldByName('numero').AsString;
        ADOQuery2.Parameters.ParamByName('complemento').Value      := FDQuery1.FieldByName('complemento').AsString;
        ADOQuery2.Parameters.ParamByName('cep').Value              := FDQuery1.FieldByName('cep').AsString;
        ADOQuery2.Parameters.ParamByName('bairro').Value           := FDQuery1.FieldByName('bairro').AsString;
        ADOQuery2.Parameters.ParamByName('telefone_1').Value       := FDQuery1.FieldByName('telefone_1').AsString;
        ADOQuery2.Parameters.ParamByName('telefone_2').Value       := FDQuery1.FieldByName('telefone_2').AsString;

        CelularQtd := Length(FDQuery1.FieldByName('celular').AsString);

        if CelularQtd = 7 then
        begin
          Celular := '829'+ FDQuery1.FieldByName('celular').AsString;
        end
        else if CelularQtd = 8 then
        begin
          Celular := '82'+ FDQuery1.FieldByName('celular').AsString;
        end
        else if CelularQtd <=0 then
        begin
          Celular := '8299820629'
        end
        else
        begin
          Celular := FDQuery1.FieldByName('celular').AsString;
        end;

        ADOQuery2.Parameters.ParamByName('celular').Value          := Celular;

        if FDQuery1.FieldByName('emal').AsString = '' then
          ADOQuery2.Parameters.ParamByName('email').Value          := 'bergtecidos@gmail.com'
        else
          ADOQuery2.Parameters.ParamByName('email').Value          := FDQuery1.FieldByName('email').AsString;

        ADOQuery2.Parameters.ParamByName('cidade_id').Value        := '';
      end;

      try
        // Tenta salvar os dados
        ADOQuery2.ExecSQL;
      except
        on E: Exception do
        begin
          Erro := (E.Message);
          ShowMessage(E.Message);
          Break;
        end;
      end;


      if Erro = '' then
      begin
        ADOQuery3.Parameters.Clear;
        ADOQuery3.SQL.Clear;

        // Insert
        ADOQuery3.SQL.Add('INSERT INTO fornecedor (');
        ADOQuery3.SQL.Add('       id)');
        ADOQuery3.SQL.Add('VALUES (');
        ADOQuery3.SQL.Add('       :id)');

        ADOQuery3.Parameters.ParamByName('id').Value := PessoaId;

       try
        // Tenta salvar os dados
         ADOQuery3.ExecSQL;
         Application.ProcessMessages;
       except
        on E: Exception do
        begin
          Erro := (E.Message);
          Memo1.Lines.Add(Erro);
          Break;
        end;
       end;
      end;
      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu fornecedor!');
    end;

    // Passo 2 - Salva os dados da pessoa
    QryAx6.Parameters.Clear;
    QryAx6.SQL.Clear;

    CdsAx6.Close;
    QryAx6.SQL.Add('select * from pessoa');
    CdsAx6.Open;
  end;


  //////////////////////////////////////////////////////////////////////////////////////////////
  ///  primeira vez retirando os  registros em branco
  Erro := '';
  if ConectaBanco then
  begin
   With FDQuery1 do
   begin
      SQL.Clear;
      SQL.Text :=
                ' SELECT '
                +' 	EMITENTE,'
                +' 	CPF_CGC '
                +' FROM '
                +' 	cheque '
                +' where CPF_CGC <> '''' '
                +' GROUP BY '
                +' 	EMITENTE,'
                +' 	CPF_CGC ';
    end;
    FDQuery1.Open();

// Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;



    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
      if  ProcuraClienteNomeBoolean(FDQuery1.FieldByName('EMITENTE').AsString) = False then //procura pelo nome
      begin
        if ProcuraCpfCnpj(FDQuery1.FieldByName('CPF_CGC').AsString) = False then; //procura se cpf ja esta cadastrado
        begin
           // Passo 2 - Salva os dados da pessoa
          ADOQuery1.Parameters.Clear;
          ADOQuery1.SQL.Clear;

          if Erro = '' then
          begin
            // Gera um novo id para a pessoa
            PessoaId := GeraId('pessoa');

            ADOQuery1.SQL.Add('INSERT INTO pessoa (');
            ADOQuery1.SQL.Add('       id,');
            ADOQuery1.SQL.Add('       tipo,');
            ADOQuery1.SQL.Add('       razao_social,');
            ADOQuery1.SQL.Add('       nome_fantasia,');
            ADOQuery1.SQL.Add('       cpf_cnpj)');
            ADOQuery1.SQL.Add('VALUES (');
            ADOQuery1.SQL.Add('       :id,');
            ADOQuery1.SQL.Add('       :tipo,');
            ADOQuery1.SQL.Add('       :razao_social,');
            ADOQuery1.SQL.Add('       :nome_fantasia,');
            ADOQuery1.SQL.Add('       :cpf_cnpj)');

            TipoQtd := Length(FDQuery1.FieldByName('CPF_CGC').AsString);
            if TipoQtd = 14 then
            begin
              Tipo := 'J';
              CpfCnpj := FDQuery1.FieldByName('CPF_CGC').AsString;
            end
            else if TipoQtd = 11 then
            begin
              Tipo := 'F' ;
              CpfCnpj:= FDQuery1.FieldByName('CPF_CGC').AsString;
            end
            else
            begin
              Tipo := 'F';
              if TipoQtd = 0 then
                CpfCnpj:= GeraCPF(False);
            end;

            ADOQuery1.Parameters.ParamByName('id').Value                       := PessoaId;
            ADOQuery1.Parameters.ParamByName('tipo').Value                     := Tipo;
            ADOQuery1.Parameters.ParamByName('razao_social').Value             := FDQuery1.FieldByName('EMITENTE').AsString;
            ADOQuery1.Parameters.ParamByName('nome_fantasia').Value            := FDQuery1.FieldByName('EMITENTE').AsString;
            ADOQuery1.Parameters.ParamByName('cpf_cnpj').Value                 := CpfCnpj;

            try
              // Tenta salvar os dados
              ADOQuery1.ExecSQL;
              Application.ProcessMessages;
            except
              on E: Exception do
              begin
               Erro := (E.Message);
               Memo1.Lines.Add(Erro);
               Break;
              end;
            end;
          end;


           if Erro = '' then
          begin
            // Gera um novo id para a pessoa
            EnderecoGEId := GeraId('pessoa_endereco');

            ADOQuery2.Parameters.Clear;
            ADOQuery2.SQL.Clear;

            // Insert
            ADOQuery2.SQL.Add('INSERT INTO pessoa_endereco (');
            ADOQuery2.SQL.Add('       id,');
            ADOQuery2.SQL.Add('       pessoa_id,');
            ADOQuery2.SQL.Add('       tipo,');
            ADOQuery2.SQL.Add('       celular,');
            ADOQuery2.SQL.Add('       email)');
            ADOQuery2.SQL.Add('VALUES (');
            ADOQuery2.SQL.Add('       :id,');
            ADOQuery2.SQL.Add('       :pessoa_id,');
            ADOQuery2.SQL.Add('       ''GE'',');
            ADOQuery2.SQL.Add('       :celular,');
            ADOQuery2.SQL.Add('       :email)');

            ADOQuery2.Parameters.ParamByName('pessoa_id').Value        := PessoaId;
            ADOQuery2.Parameters.ParamByName('id').Value               := EnderecoGEId;
            ADOQuery2.Parameters.ParamByName('celular').Value          := '8299820629';
            ADOQuery2.Parameters.ParamByName('email').Value          := 'bergtecidos@gmail.com'
          end;

          try
            // Tenta salvar os dados
            ADOQuery2.ExecSQL;
            Application.ProcessMessages;
          except
            on E: Exception do
            begin
              Erro := (E.Message);
              Memo1.Lines.Add(Erro);
              Break;
            end;
          end;


          if Erro = '' then
          begin
            ADOQuery3.Parameters.Clear;
            ADOQuery3.SQL.Clear;

            // Insert
            ADOQuery3.SQL.Add('INSERT INTO cliente (');
            ADOQuery3.SQL.Add('       id)');
            ADOQuery3.SQL.Add('VALUES (');
            ADOQuery3.SQL.Add('       :id)');

            ADOQuery3.Parameters.ParamByName('id').Value := PessoaId;

           try
            // Tenta salvar os dados
             ADOQuery3.ExecSQL;
           except
            on E: Exception do
            begin
              Erro := (E.Message);
              Memo1.Lines.Add(Erro);
              Break;
            end;
           end;
          end;
         end;
      end;
      FDQuery1.Next;
    end;

    // Passo 2 - Salva os dados da pessoa
    QryAx6.Parameters.Clear;
    QryAx6.SQL.Clear;

    CdsAx6.Close;
    QryAx6.SQL.Add('select * from pessoa');
    CdsAx6.Open;


    //////////////////////////////////////////////////////////////////////////////////////////////
  ///  SEGUNDA vez SOMENTE os  registros em branco

   With FDQuery1 do
   begin
      SQL.Clear;
      SQL.Text :=
                ' SELECT '
                +' 	EMITENTE,'
                +' 	CPF_CGC '
                +' FROM '
                +' 	cheque '
                +' where CPF_CGC = '''' '
                +' GROUP BY '
                +' 	EMITENTE,'
                +' 	CPF_CGC ';
    end;
    FDQuery1.Open();

// Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;



    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
      if  ProcuraClienteNomeBoolean(FDQuery1.FieldByName('EMITENTE').AsString) = False then //procura pelo nome
      begin
        if ProcuraCpfCnpj(FDQuery1.FieldByName('CPF_CGC').AsString) = False then; //procura se cpf ja esta cadastrado
        begin
           // Passo 2 - Salva os dados da pessoa
          ADOQuery1.Parameters.Clear;
          ADOQuery1.SQL.Clear;

          if Erro = '' then
          begin
            // Gera um novo id para a pessoa
            PessoaId := GeraId('pessoa');

            ADOQuery1.SQL.Add('INSERT INTO pessoa (');
            ADOQuery1.SQL.Add('       id,');
            ADOQuery1.SQL.Add('       tipo,');
            ADOQuery1.SQL.Add('       razao_social,');
            ADOQuery1.SQL.Add('       nome_fantasia,');
            ADOQuery1.SQL.Add('       cpf_cnpj)');
            ADOQuery1.SQL.Add('VALUES (');
            ADOQuery1.SQL.Add('       :id,');
            ADOQuery1.SQL.Add('       :tipo,');
            ADOQuery1.SQL.Add('       :razao_social,');
            ADOQuery1.SQL.Add('       :nome_fantasia,');
            ADOQuery1.SQL.Add('       :cpf_cnpj)');

            TipoQtd := Length(FDQuery1.FieldByName('CPF_CGC').AsString);
            if TipoQtd = 14 then
            begin
              Tipo := 'J';
              CpfCnpj := FDQuery1.FieldByName('CPF_CGC').AsString;
            end
            else if TipoQtd = 11 then
            begin
              Tipo := 'F' ;
              CpfCnpj:= FDQuery1.FieldByName('CPF_CGC').AsString;
            end
            else
            begin
              Tipo := 'F';
              if TipoQtd = 0 then
                CpfCnpj:= GeraCPF(False);
            end;

            ADOQuery1.Parameters.ParamByName('id').Value                       := PessoaId;
            ADOQuery1.Parameters.ParamByName('tipo').Value                     := Tipo;
            ADOQuery1.Parameters.ParamByName('razao_social').Value             := FDQuery1.FieldByName('EMITENTE').AsString;
            ADOQuery1.Parameters.ParamByName('nome_fantasia').Value            := FDQuery1.FieldByName('EMITENTE').AsString;
            ADOQuery1.Parameters.ParamByName('cpf_cnpj').Value                 := CpfCnpj;

            try
              // Tenta salvar os dados
              ADOQuery1.ExecSQL;
              Application.ProcessMessages;
            except
              on E: Exception do
              begin
               Erro := (E.Message);
               Memo1.Lines.Add(Erro);
               Break;
              end;
            end;
          end;


           if Erro = '' then
          begin
            // Gera um novo id para a pessoa
            EnderecoGEId := GeraId('pessoa_endereco');

            ADOQuery2.Parameters.Clear;
            ADOQuery2.SQL.Clear;

            // Insert
            ADOQuery2.SQL.Add('INSERT INTO pessoa_endereco (');
            ADOQuery2.SQL.Add('       id,');
            ADOQuery2.SQL.Add('       pessoa_id,');
            ADOQuery2.SQL.Add('       tipo,');
            ADOQuery2.SQL.Add('       celular,');
            ADOQuery2.SQL.Add('       email)');
            ADOQuery2.SQL.Add('VALUES (');
            ADOQuery2.SQL.Add('       :id,');
            ADOQuery2.SQL.Add('       :pessoa_id,');
            ADOQuery2.SQL.Add('       ''GE'',');
            ADOQuery2.SQL.Add('       :celular,');
            ADOQuery2.SQL.Add('       :email)');

            ADOQuery2.Parameters.ParamByName('pessoa_id').Value        := PessoaId;
            ADOQuery2.Parameters.ParamByName('id').Value               := EnderecoGEId;
            ADOQuery2.Parameters.ParamByName('celular').Value          := '8299820629';
            ADOQuery2.Parameters.ParamByName('email').Value          := 'bergtecidos@gmail.com'
          end;

          try
            // Tenta salvar os dados
            ADOQuery2.ExecSQL;
            Application.ProcessMessages;
          except
            on E: Exception do
            begin
              Erro := (E.Message);
              Memo1.Lines.Add(Erro);
              Break;
            end;
          end;


          if Erro = '' then
          begin
            ADOQuery3.Parameters.Clear;
            ADOQuery3.SQL.Clear;

            // Insert
            ADOQuery3.SQL.Add('INSERT INTO cliente (');
            ADOQuery3.SQL.Add('       id)');
            ADOQuery3.SQL.Add('VALUES (');
            ADOQuery3.SQL.Add('       :id)');

            ADOQuery3.Parameters.ParamByName('id').Value := PessoaId;

           try
            // Tenta salvar os dados
             ADOQuery3.ExecSQL;
             Application.ProcessMessages;
           except
            on E: Exception do
            begin
              Erro := (E.Message);
              Memo1.Lines.Add(Erro);
              ShowMessage(Erro);
              Break;
            end;
           end;
          end;
         end;
      end;
      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu Emitente!');
    end;

    // Passo 2 - Salva os dados da pessoa
    QryAx6.Parameters.Clear;
    QryAx6.SQL.Clear;

    CdsAx6.Close;
    QryAx6.SQL.Add('select * from pessoa');
    CdsAx6.Open;
//
    //////////////////////////////////////////////////////////////////////////////////////////////////////
//    ///
//
    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
                 '  SELECT '
                +'  ta.ID_TIPO_ARECEBER AS id,'
                +'  ta.TIPO_ARECEBER AS descricao,'
                +'  ''C'' AS TIPO,'
                +'  ID_TIPO_ARECEBER AS ORDEM_EXIBICAO '
                +'  FROM TIPO_ARECEBER ta ';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
      // Gera um novo id
      CondicoesPagamento := GeraId('condicoes_pagamento');

      ADOQuery3.Parameters.Clear;
      ADOQuery3.SQL.Clear;

      ADOQuery3.SQL.Add('INSERT INTO condicoes_pagamento (');
      ADOQuery3.SQL.Add('       id,');
      ADOQuery3.SQL.Add('       descricao,');
      ADOQuery3.SQL.Add('       tipo,');
      ADOQuery3.SQL.Add('       ordem_exibicao)');
      ADOQuery3.SQL.Add('VALUES (');
      ADOQuery3.SQL.Add('       :id,');
      ADOQuery3.SQL.Add('       :descricao,');
      ADOQuery3.SQL.Add('       ''C'',');
      ADOQuery3.SQL.Add('       :ordem_exibicao)');

      ADOQuery3.Parameters.ParamByName('id').Value              := CondicoesPagamento;
      ADOQuery3.Parameters.ParamByName('descricao').Value       := FDQuery1.FieldByName('descricao').AsString;
      ADOQuery3.Parameters.ParamByName('ordem_exibicao').Value  := CondicoesPagamento;

      try
        // Tenta salvar os dados
        ADOQuery3.ExecSQL;
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Erro := (E.Message);
          Memo1.Lines.Add(Erro);
          Break;
        end;
      end;
      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu tipo cobrança!');
    end;
//
//
    ////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    try
      // Inicia a transação
      if ADOConnection.Connected = false then
        ADOConnection.Open;

      if ADOConnection.InTransaction = False then
        ADOConnection.BeginTrans;

      // Gera um novo id
      CondicoesPagamento := GeraId('condicoes_pagamento');
      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;
      ADOQuery4.SQL.Text := 'insert into condicoes_pagamento (id,descricao,tipo,ordem_exibicao) values (:id,''DINHEIRO'',''R'',:ordem_exibicao)';
      ADOQuery4.Parameters.ParamByName('id').Value              := CondicoesPagamento;
      ADOQuery4.Parameters.ParamByName('ordem_exibicao').Value  := CondicoesPagamento;
      ADOQuery4.ExecSQL;

      CondicoesPagamento := GeraId('condicoes_pagamento');
      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;
      ADOQuery4.SQL.Text := 'insert into condicoes_pagamento (id,descricao,tipo,ordem_exibicao) values (:id,''CARTAO'',''R'',:ordem_exibicao)';
      ADOQuery4.Parameters.ParamByName('id').Value              := CondicoesPagamento;
      ADOQuery4.Parameters.ParamByName('ordem_exibicao').Value  := CondicoesPagamento;
      ADOQuery4.ExecSQL;

      CondicoesPagamento := GeraId('condicoes_pagamento');
      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;
      ADOQuery4.SQL.Text := 'insert into condicoes_pagamento (id,descricao,tipo,ordem_exibicao,gera_cheque) values (:id,''CHEQUE (R)'',''R'',:ordem_exibicao,''S'')';
      ADOQuery4.Parameters.ParamByName('id').Value              := CondicoesPagamento;
      ADOQuery4.Parameters.ParamByName('ordem_exibicao').Value  := CondicoesPagamento;
      ADOQuery4.ExecSQL;

      CondicoesPagamento := GeraId('condicoes_pagamento');
      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;
      ADOQuery4.SQL.Text := 'insert into condicoes_pagamento (id,descricao,tipo,ordem_exibicao) values (:id,''OUTROS'',''R'',:ordem_exibicao)';
      ADOQuery4.Parameters.ParamByName('id').Value              := CondicoesPagamento;
      ADOQuery4.Parameters.ParamByName('ordem_exibicao').Value  := CondicoesPagamento;
      ADOQuery4.ExecSQL;

      Application.ProcessMessages;
    except
      on E: Exception do
      begin
        Erro := (E.Message);
        Memo1.Lines.Add(Erro);
      end;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu tipo recebimento!');
    end;

    QryAx9.Parameters.Clear;
    QryAx9.SQL.Clear;

    CdsAx9.Close;
    QryAx9.SQL.Add('select * from condicoes_pagamento');
    CdsAx9.Open;



    ////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    try
      // Inicia a transação
      if ADOConnection.Connected = false then
        ADOConnection.Open;

      if ADOConnection.InTransaction = False then
        ADOConnection.BeginTrans;

      CategoriaId := GeraId('titulo_categoria');
      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;
      ADOQuery4.SQL.Text := 'insert into titulo_categoria (id,descricao,tipo_titulo) values (:id,''CATEGORIA_TESTE'',''R'')';
      ADOQuery4.Parameters.ParamByName('id').Value              := CategoriaId;
      ADOQuery4.ExecSQL;
      Application.ProcessMessages;
    except
      on E: Exception do
      begin
        Erro := (E.Message);
        ShowMessage(Erro);
      end;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu titulo categoria!');
    end;
//
//
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///

    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
                 '	SELECT 												                      	'
                +'		a.ID_ARECEBER AS ID,                                '
                +'		''1'' AS filial_id,                                 '
                +'		a.ID_CLIENTE cliente_id,                            '
                +'		a.id_tipo_areceber AS condicoes_pagamento_id,       '
                +'    tpa.tipo_areceber,                                  '
                +'		''C'' AS NATUREZA,                                  '
                +'    CASE WHEN a.DOCUMENTO IS NULL THEN 0                '
                +'         WHEN a.DOCUMENTO = '','' THEN 0                '
             	  +'      ELSE                                              '
             		+'         a.DOCUMENTO                                    '
             	  +'    END AS NUMERO_DOCUMENTO,                            '
                +'		a.DATA_CAD AS DATA_EMISSAO,                         '
                +'		a.VENCIMENTO AS DATA_VENCIMENTO,                    '
                +'		a.VENCIMENTO AS DATA_VENC_ORIGINAL,                 '
                +'		a.VALOR_DEBITO AS VALOR,                            '
                +'		a.VALOR_DEBITO AS VALOR_ORIGINAL,                   '
                +'		a.DESCONTO AS VALOR_DESCONTO,                       '
                +'		CASE WHEN (a.VALOR_PAGO)=0 THEN ''A''               '
                +'			   WHEN (a.APAGAR)=0 THEN ''L''                      '
                +'			   WHEN (a.VALOR_DEBITO - a.VALOR_PAGO)>0 THEN ''P'' '
                +'			   WHEN a.VALOR_PAGO > a.VALOR_DEBITO THEN ''L'' '
                +'		END AS SITUACAO,                                    '
                +'		a.JUROS VALOR_JUROS,                                '
                +'		a.VALOR_PAGO,                                       '
                +' CASE WHEN (a.apagar) < 0 THEN 0                        '
             	  +'  ELSE                                                  '
             		+'  a.apagar                                              '
             	  +'  END AS valor_saldo,                                   '
                +'		a.observacao AS historico,                          '
                +'		''1'' AS titulo_categoria_id                        '
                +'	FROM ARECEBER a                                       '
                +'  INNER JOIN  TIPO_ARECEBER tpa ON                      '
                +'  tpa.ID_TIPO_ARECEBER = a.id_tipo_areceber             ';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
      // Gera um novo id
      TituloId := GeraId('titulo');

      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;

      ADOQuery4.SQL.Add('INSERT INTO titulo (');
      ADOQuery4.SQL.Add('       id,');
      ADOQuery4.SQL.Add('       integracaoid,');
      ADOQuery4.SQL.Add('       filial_id,');
      ADOQuery4.SQL.Add('       condicoes_pagamento_id,');
      ADOQuery4.SQL.Add('       NATUREZA,');
      ADOQuery4.SQL.Add('       NUMERO_DOCUMENTO,');
      ADOQuery4.SQL.Add('       DATA_EMISSAO,');
      ADOQuery4.SQL.Add('       DATA_VENCIMENTO,');
      ADOQuery4.SQL.Add('       DATA_VENC_ORIGINAL,');
      ADOQuery4.SQL.Add('       VALOR,');
      ADOQuery4.SQL.Add('       VALOR_ORIGINAL,');
      ADOQuery4.SQL.Add('       VALOR_DESCONTO,');
      ADOQuery4.SQL.Add('       SITUACAO,');
      ADOQuery4.SQL.Add('       VALOR_JUROS,');
      ADOQuery4.SQL.Add('       VALOR_PAGO,');
      ADOQuery4.SQL.Add('       valor_saldo,');
      ADOQuery4.SQL.Add('       historico,');
      ADOQuery4.SQL.Add('       titulo_categoria_id)');
      ADOQuery4.SQL.Add('VALUES (');
      ADOQuery4.SQL.Add('       :id,');
      ADOQuery4.SQL.Add('       :integracaoid,');
      ADOQuery4.SQL.Add('       ''1'',');
      ADOQuery4.SQL.Add('       :condicoes_pagamento_id,');
      ADOQuery4.SQL.Add('       ''C'',');
      ADOQuery4.SQL.Add('       :NUMERO_DOCUMENTO,');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('DATA_EMISSAO').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('DATA_VENCIMENTO').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('DATA_VENC_ORIGINAL').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery4.SQL.Add('       :VALOR,');
      ADOQuery4.SQL.Add('       :VALOR_ORIGINAL,');
      ADOQuery4.SQL.Add('       :VALOR_DESCONTO,');
      ADOQuery4.SQL.Add('       :SITUACAO,');
      ADOQuery4.SQL.Add('       :VALOR_JUROS,');
      ADOQuery4.SQL.Add('       :VALOR_PAGO,');
      ADOQuery4.SQL.Add('       :valor_saldo,');
      ADOQuery4.SQL.Add('       :historico,');
      ADOQuery4.SQL.Add('       ''1'')');

      ADOQuery4.Parameters.ParamByName('id').Value                        := TituloId;
      ADOQuery4.Parameters.ParamByName('integracaoid').Value              := FDQuery1.FieldByName('ID').AsString;
      ADOQuery4.Parameters.ParamByName('condicoes_pagamento_id').Value    := ProcuraCondicoesPagamento(FDQuery1.FieldByName('tipo_areceber').AsString);
      ADOQuery4.Parameters.ParamByName('NUMERO_DOCUMENTO').Value          := RemoveMascara(FDQuery1.FieldByName('NUMERO_DOCUMENTO').AsString);
      ADOQuery4.Parameters.ParamByName('VALOR').Value                     := FDQuery1.FieldByName('VALOR').AsFloat;
      ADOQuery4.Parameters.ParamByName('VALOR_ORIGINAL').Value            := FDQuery1.FieldByName('VALOR_ORIGINAL').AsFloat;
      ADOQuery4.Parameters.ParamByName('VALOR_DESCONTO').Value            := FDQuery1.FieldByName('VALOR_DESCONTO').AsFloat;
      ADOQuery4.Parameters.ParamByName('SITUACAO').Value                  := FDQuery1.FieldByName('SITUACAO').AsString;
      ADOQuery4.Parameters.ParamByName('VALOR_JUROS').Value               := FDQuery1.FieldByName('VALOR_JUROS').AsFloat;
      ADOQuery4.Parameters.ParamByName('VALOR_PAGO').Value                := FDQuery1.FieldByName('VALOR_PAGO').AsFloat;
      ADOQuery4.Parameters.ParamByName('valor_saldo').Value               := FDQuery1.FieldByName('valor_saldo').AsFloat;
      ADOQuery4.Parameters.ParamByName('historico').Value                 := FDQuery1.FieldByName('historico').AsString;

      try
        // Tenta salvar os dados
        ADOQuery4.ExecSQL;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add(RemoveMascara(FDQuery1.FieldByName('NUMERO_DOCUMENTO').AsString));
          Memo1.Lines.Add(FDQuery1.FieldByName('ID').AsString);
          Erro := (E.Message);
          ShowMessage(Erro);
          Break;
        end;
      end;

      ADOQuery5.Parameters.Clear;
      ADOQuery5.SQL.Clear;

      ADOQuery5.SQL.Add('INSERT INTO titulo_receber (');
      ADOQuery5.SQL.Add('       id,');
      ADOQuery5.SQL.Add('       cliente_id)');
      ADOQuery5.SQL.Add('VALUES (');
      ADOQuery5.SQL.Add('       :id,');
      ADOQuery5.SQL.Add('       :cliente_id)');

      ADOQuery5.Parameters.ParamByName('id').Value         := TituloId;
      ADOQuery5.Parameters.ParamByName('cliente_id').Value := ProcuraClienteID(FDQuery1.FieldByName('cliente_id').AsInteger);

      try
        // Tenta salvar os dados
        ADOQuery5.ExecSQL;
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add(RemoveMascara(FDQuery1.FieldByName('NUMERO_DOCUMENTO').AsString));
          Memo1.Lines.Add(FDQuery1.FieldByName('ID').AsString);
          Erro := (E.Message);
          Memo1.Lines.Add(Erro);
        end;
      end;
      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu titulos!');
    end;

    QryAx8.Parameters.Clear;
    QryAx8.SQL.Clear;

    CdsAx8.Close;
    QryAx8.SQL.Add('select * from titulo');
    CdsAx8.Open;



    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///

    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
                 '  SELECT                                      '
                +'  mad.ID_M_ARECEBER AS ID,                    '
                +'  mad.ID_ARECEBER AS titulo_id,               '
                +'  mad.FORMA_PAGTO AS CONDICOES_PAGAMENTO_DESCRICAO,  '
                +'  mad.VALOR                                   '
                +'  FROM M_ARECEBER_DETALHADA mad               ';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    FDQuery1.First;
    while not FDQuery1.Eof do
    begin

      // Gera um novo id
      TituloPagamentosId := GeraId('titulo_pagamentos');

      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;

      ADOQuery4.SQL.Add('INSERT INTO titulo_pagamentos (');
      ADOQuery4.SQL.Add('       id,');
      ADOQuery4.SQL.Add('       titulo_id,');
      ADOQuery4.SQL.Add('       condicoes_pagamento_id,');
      ADOQuery4.SQL.Add('       valor_pago)');
      ADOQuery4.SQL.Add('VALUES (');
      ADOQuery4.SQL.Add('       :id,');
      ADOQuery4.SQL.Add('       :titulo_id,');
      ADOQuery4.SQL.Add('       :condicoes_pagamento_id,');
      ADOQuery4.SQL.Add('       :valor_pago)');

      ADOQuery4.Parameters.ParamByName('id').Value                      := TituloPagamentosId;
      ADOQuery4.Parameters.ParamByName('titulo_id').Value               := ProcuraTitulo(FDQuery1.FieldByName('titulo_id').AsInteger);
      ADOQuery4.Parameters.ParamByName('condicoes_pagamento_id').Value  := ProcuraCondicoesPagamento(FDQuery1.FieldByName('CONDICOES_PAGAMENTO_DESCRICAO').AsString);
      ADOQuery4.Parameters.ParamByName('valor_pago').Value              := FDQuery1.FieldByName('VALOR').AsFloat;

      try
        // Tenta salvar os dados
        ADOQuery4.ExecSQL;
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add(FDQuery1.FieldByName('ID').AsString);
          Erro := (E.Message);
          ShowMessage(Erro);
        end;
      end;

      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu titulos pagamentos!');
    end;
//
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///

    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
                 ' SELECT ID_DESTINO, DESTINO FROM DESTINO ';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    FDQuery1.First;
    while not FDQuery1.Eof do
    begin

      // Gera um novo id
      ChequeDestinoId := GeraId('cheque_destino');

      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;

      ADOQuery4.SQL.Add('INSERT INTO cheque_destino (');
      ADOQuery4.SQL.Add('       id,');
      ADOQuery4.SQL.Add('       descricao)');
      ADOQuery4.SQL.Add('VALUES (');
      ADOQuery4.SQL.Add('       :id,');
      ADOQuery4.SQL.Add('       :descricao)');

      ADOQuery4.Parameters.ParamByName('id').Value                      := ChequeDestinoId;
      ADOQuery4.Parameters.ParamByName('descricao').Value               := FDQuery1.FieldByName('DESTINO').AsString;

      try
        // Tenta salvar os dados
        ADOQuery4.ExecSQL;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add(FDQuery1.FieldByName('ID_DESTINO').AsString);
          Erro := (E.Message);
          ShowMessage(Erro);
          Break;
        end;
      end;

      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu cheque destino!');
    end;
//
    QryAx5.Parameters.Clear;
    QryAx5.SQL.Clear;
    CdsAx5.Close;
    QryAx5.SQL.Add('select * from cheque_destino');
    CdsAx5.Open;

   ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///

    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
                 '	SELECT 									              '
                +'		c.ID_CHEQUE id,	                    '
                +'		c.ID_CLIENTE cliente_id,	          '
                +'		c2.NOME,	                          '
                +'		c.lote lote_numero,	                '
                +'		c.CPF_CGC cpf_cnpj_emitente,  	    '
                +'		c.emitente nome_emitente,     	    '
                +'		c.DATA_CADASTRO,	                  '
                +'		c.PROPRIO proprio_cliente,	        '
                +'		c.NUMERO_CHEQUE numero,	            '
                +'		c.DIGITO_CHEQUE digito,	            '
                +'		c.CONTA_CORRENTE,	                  '
                +'		c.ID_BANCO banco_id,	              '
                +'		c.ID_AGENCIA agencia,	              '
                +'		c.CIDADE_CHEQUE cidade_id,	        '
                +'		c.ID_VENDEDOR vendedor_id,	        '
                +'		c.DT_DEPOSITO data_deposito,	      '
                +'		c.ID_DESTINO destino_id,	          '
                +'		c.OBSERVACAO,	                      '
                +'		'''' codigo_cmc7,	                  '
                +'		c.DT_DEVOLUCAO data_devolucao,	    '
                +'		c.DT_VENCIMENTO data_vencimento,	  '
                +'		c.OBS_DEVOLUCAO1 motivo_devolucao,	'
                +'		c.SITUACAO,	                        '
                +'		''0'' titulo_pagamento_id,	        '
                +'		c.VALOR valor_cheque,'
                +'		''N'' marcado_para_depositar'
                +'	FROM CHEQUE c'
                +' INNER JOIN CLIENTES c2'
                +'  ON c.ID_CLIENTE  = c2.ID_CLIENTE';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
      // Gera um novo id
      ChequeId := GeraId('cheque');

      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;


      CidadeId := ProcuraCidade(FDQuery1.FieldByName('cidade_id').AsString);
      Obs      := FDQuery1.FieldByName('OBSERVACAO').AsString;
      MotivoDevolucao := FDQuery1.FieldByName('motivo_devolucao').AsString;


      ADOQuery4.SQL.Add('INSERT INTO cheque (');
      ADOQuery4.SQL.Add('       id,');
      ADOQuery4.SQL.Add('       cliente_id,');
      ADOQuery4.SQL.Add('       lote_numero,');
      ADOQuery4.SQL.Add('       cliente_emitente_id,');
      ADOQuery4.SQL.Add('       DATA_CADASTRO,');
      ADOQuery4.SQL.Add('       proprio_cliente,');
      ADOQuery4.SQL.Add('       numero,');
      ADOQuery4.SQL.Add('       digito,');
      ADOQuery4.SQL.Add('       CONTA_CORRENTE,');
      ADOQuery4.SQL.Add('       banco_id,');
      ADOQuery4.SQL.Add('       agencia,');

      if CidadeId <> '0' then
        ADOQuery4.SQL.Add('       cidade_id,');

      ADOQuery4.SQL.Add('       vendedor_id,');
      ADOQuery4.SQL.Add('       data_deposito,');
      ADOQuery4.SQL.Add('       destino_id,');

      if Obs <> '' then
        ADOQuery4.SQL.Add('       OBSERVACAO,');

      ADOQuery4.SQL.Add('       codigo_cmc7,');
      ADOQuery4.SQL.Add('       data_devolucao,');
      ADOQuery4.SQL.Add('       data_vencimento,');

      if MotivoDevolucao <> '' then
        ADOQuery4.SQL.Add('       motivo_devolucao,');

      ADOQuery4.SQL.Add('       SITUACAO,');
      ADOQuery4.SQL.Add('       titulo_pagamento_id,');
      ADOQuery4.SQL.Add('       valor_cheque,');
      ADOQuery4.SQL.Add('       marcado_para_depositar,');
      ADOQuery4.SQL.Add('       integracaoid)');
      ADOQuery4.SQL.Add('VALUES (');
      ADOQuery4.SQL.Add('       :id,');
      ADOQuery4.SQL.Add('       :cliente_id,');
      ADOQuery4.SQL.Add('       :lote_numero,');
      ADOQuery4.SQL.Add('       :cliente_emitente_id,');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('DATA_CADASTRO').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery4.SQL.Add('       :proprio_cliente,');
      ADOQuery4.SQL.Add('       :numero,');
      ADOQuery4.SQL.Add('       :digito,');
      ADOQuery4.SQL.Add('       :CONTA_CORRENTE,');
      ADOQuery4.SQL.Add('       :banco_id,');
      ADOQuery4.SQL.Add('       :agencia,');

      if CidadeId <> '0' then
        ADOQuery4.SQL.Add('     '''+CidadeId+''',');

      ADOQuery4.SQL.Add('       ''1'',');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('data_deposito').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery4.SQL.Add('       :destino_id,');

      if Obs <> '' then
        ADOQuery4.SQL.Add('       '''+Obs+''',');

      ADOQuery4.SQL.Add('       '''',');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('data_devolucao').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('data_vencimento').AsString) + ''', ''dd/mm/yyyy''),');

      if MotivoDevolucao <> '' then
        ADOQuery4.SQL.Add('      '''+MotivoDevolucao+''',');

      ADOQuery4.SQL.Add('       '''',');
      ADOQuery4.SQL.Add('       ''0'',');
      ADOQuery4.SQL.Add('       :valor_cheque,');
      ADOQuery4.SQL.Add('       ''N'',');
      ADOQuery4.SQL.Add('       :integracaoid)');

      ADOQuery4.Parameters.ParamByName('id').Value                  := ChequeId;
      ADOQuery4.Parameters.ParamByName('cliente_id').Value          := ProcuraClienteNome(FDQuery1.FieldByName('NOME').AsString);
      ADOQuery4.Parameters.ParamByName('lote_numero').Value         := FDQuery1.FieldByName('lote_numero').AsString;
      ADOQuery4.Parameters.ParamByName('cliente_emitente_id').Value := ProcuraEmitente(FDQuery1.FieldByName('cpf_cnpj_emitente').AsString,FDQuery1.FieldByName('nome_emitente').AsString);
      ADOQuery4.Parameters.ParamByName('proprio_cliente').Value     := FDQuery1.FieldByName('proprio_cliente').AsString;
      ADOQuery4.Parameters.ParamByName('numero').Value              := FDQuery1.FieldByName('numero').AsString;
      ADOQuery4.Parameters.ParamByName('digito').Value              := FDQuery1.FieldByName('digito').AsString;
      ADOQuery4.Parameters.ParamByName('CONTA_CORRENTE').Value      := FDQuery1.FieldByName('CONTA_CORRENTE').AsString;
      ADOQuery4.Parameters.ParamByName('banco_id').Value            := ProcuraBanco(FDQuery1.FieldByName('banco_id').AsString);
      ADOQuery4.Parameters.ParamByName('agencia').Value             := FDQuery1.FieldByName('agencia').AsString;

      ADOQuery4.Parameters.ParamByName('destino_id').Value          := FDQuery1.FieldByName('destino_id').AsString;

      ADOQuery4.Parameters.ParamByName('valor_cheque').Value        := StrToFloatDef(FDQuery1.FieldByName('valor_cheque').AsString,0);
      ADOQuery4.Parameters.ParamByName('integracaoid').Value        := FDQuery1.FieldByName('id').AsString;

      try
        // Tenta salvar os dados
        ADOQuery4.ExecSQL;
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add(FDQuery1.FieldByName('id').AsString);
          Memo1.Lines.add(E.Message);
        end;
      end;

      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu cheque destino!');
    end;
//
//
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///

    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
                 '  SELECT                          '
                +'  	ID_BAIXA  id,                 '
                +'  	DT_BAIXA DATA,                '
                +'  	ID_DESTINO cheque_destino_id  '
                +'  FROM CHEQUE_BAIXA cb            ';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
      // Gera um novo id
      ChequeBaixaCabecalhoId := GeraId('cheque_baixa_cabecalho');

      ADOQuery3.Parameters.Clear;
      ADOQuery3.SQL.Clear;

      ADOQuery3.SQL.Add('INSERT INTO cheque_baixa_cabecalho (');
      ADOQuery3.SQL.Add('       id,');
      ADOQuery3.SQL.Add('       data,');
      ADOQuery3.SQL.Add('       cheque_destino_id,');
      ADOQuery3.SQL.Add('       integracaoid)');
      ADOQuery3.SQL.Add('VALUES (');
      ADOQuery3.SQL.Add('       :id,');
      ADOQuery3.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('DATA').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery3.SQL.Add('       :cheque_destino_id,');
      ADOQuery3.SQL.Add('       :integracaoid)');

      ADOQuery3.Parameters.ParamByName('id').Value                  := ChequeBaixaCabecalhoId;
      ADOQuery3.Parameters.ParamByName('cheque_destino_id').Value   := ProcuraChequeDestino(FDQuery1.FieldByName('cheque_destino_id').AsInteger);
      ADOQuery3.Parameters.ParamByName('integracaoid').Value        := FDQuery1.FieldByName('id').AsString;

      try
        // Tenta salvar os dados
        ADOQuery3.ExecSQL;
      Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Erro := (E.Message);
          ShowMessage(Erro);
          Break;
        end;
      end;
      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu cheque cabecalho!');
    end;
//
          ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///

    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
                 '	SELECT										                '
                +'		c.ID_BAIXA id,                          '
                +'		c.ID_BAIXA cheque_baixa_cabecalho_id,   '
                +'		c.ID_CHEQUE cheque_id                   '
                +'	FROM                                      '
                +'		CHEQUE c                                '
                +'	INNER JOIN CHEQUE_BAIXA cb                '
                +'	ON                                        '
                +'		c.ID_BAIXA = cb.ID_BAIXA                ';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
      // Gera um novo id
      ChequeBaixaItensId := GeraId('cheque_baixa_itens');

      ADOQuery3.Parameters.Clear;
      ADOQuery3.SQL.Clear;

      ADOQuery3.SQL.Add('INSERT INTO cheque_baixa_itens (');
      ADOQuery3.SQL.Add('       id,');
      ADOQuery3.SQL.Add('       cheque_baixa_cabecalho_id,');
      ADOQuery3.SQL.Add('       cheque_id)');
      ADOQuery3.SQL.Add('VALUES (');
      ADOQuery3.SQL.Add('       :id,');
      ADOQuery3.SQL.Add('       :cheque_baixa_cabecalho_id,');
      ADOQuery3.SQL.Add('       :cheque_id)');

      ADOQuery3.Parameters.ParamByName('id').Value                          := ChequeBaixaItensId;
      ADOQuery3.Parameters.ParamByName('cheque_baixa_cabecalho_id').Value   := ProcuraChequeCabecalho(FDQuery1.FieldByName('cheque_baixa_cabecalho_id').AsInteger);
      ADOQuery3.Parameters.ParamByName('cheque_id').Value                   := ProcuraCheque(FDQuery1.FieldByName('cheque_id').AsInteger);

      try
        // Tenta salvar os dados
        ADOQuery3.ExecSQL;
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add('cheque id'+FDQuery1.FieldByName('ID_CHEQUE').AsString);
          Memo1.Lines.Add('cheque baixa'+FDQuery1.FieldByName('cheque_baixa_cabecalho_id').AsString);
          Memo1.Lines.Add(Erro);
        end;
      end;
      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu cheque baixa itens!');
    end;
//
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///

    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
                 'SELECT 												                        '
                +'	a.ID_APAGAR AS ID,                                  '
                +'	''1'' AS filial_id,                                 '
                +'	''DINHEIRO'' AS condicoes_pagamento_id,             '
                +'	a.id_fornecedor fornecedor_id,                      '
                +'	''D'' AS NATUREZA,                                  '
                +'	CASE                                                '
                +'		WHEN a.DOCUMENTO is null THEN ''0''               '
                +'		ELSE a.DOCUMENTO                                  '
                +'	END AS NUMERO_DOCUMENTO,                            '
                +'	a.DOCUMENTO AS NUMERO_DOCUMENTO,                    '
                +'	a.DATA_CADASTRO AS DATA_EMISSAO,                    '
                +'	a.DT_VENCIMENTO AS DATA_VENCIMENTO,                 '
                +'	a.DT_VENCIMENTO AS DATA_VENC_ORIGINAL,              '
                +'	a.VALOR_DEBITO AS VALOR,                            '
                +'	a.VALOR_DEBITO AS VALOR_ORIGINAL,                   '
                +'	a.DESCONTO AS VALOR_DESCONTO,                       '
                +'	CASE                                                '
                +'		WHEN (a.VALOR_PAGO)= 0 THEN ''A''                 '
                +'		WHEN (a.TOTAL_APAGAR)= 0 THEN ''L''               '
                +'		WHEN (a.VALOR_DEBITO - a.VALOR_PAGO)>0 THEN ''P'' '
                +'	END AS SITUACAO,                                    '
                +'	a.JUROS VALOR_JUROS,                                '
                +'	a.VALOR_PAGO,                                       '
                +'	a.TOTAL_APAGAR AS valor_saldo,                      '
                +'	a.observacao AS historico,                          '
                +'	''1'' AS titulo_categoria_id                        '
                +'FROM                                                  '
                +'	APAGAR a                                            ';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
      // Gera um novo id
      TituloId := GeraId('titulo');

      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;

      ADOQuery4.SQL.Add('INSERT INTO titulo (');
      ADOQuery4.SQL.Add('       id,');
      ADOQuery4.SQL.Add('       integracaoid,');
      ADOQuery4.SQL.Add('       filial_id,');
      ADOQuery4.SQL.Add('       condicoes_pagamento_id,');
      ADOQuery4.SQL.Add('       NATUREZA,');
      ADOQuery4.SQL.Add('       NUMERO_DOCUMENTO,');
      ADOQuery4.SQL.Add('       DATA_EMISSAO,');
      ADOQuery4.SQL.Add('       DATA_VENCIMENTO,');
      ADOQuery4.SQL.Add('       DATA_VENC_ORIGINAL,');
      ADOQuery4.SQL.Add('       VALOR,');
      ADOQuery4.SQL.Add('       VALOR_ORIGINAL,');
      ADOQuery4.SQL.Add('       VALOR_DESCONTO,');
      ADOQuery4.SQL.Add('       SITUACAO,');
      ADOQuery4.SQL.Add('       VALOR_JUROS,');
      ADOQuery4.SQL.Add('       VALOR_PAGO,');
      ADOQuery4.SQL.Add('       valor_saldo,');
      ADOQuery4.SQL.Add('       historico,');
      ADOQuery4.SQL.Add('       titulo_categoria_id)');
      ADOQuery4.SQL.Add('VALUES (');
      ADOQuery4.SQL.Add('       :id,');
      ADOQuery4.SQL.Add('       :integracaoid,');
      ADOQuery4.SQL.Add('       ''1'',');
      ADOQuery4.SQL.Add('       :condicoes_pagamento_id,');
      ADOQuery4.SQL.Add('       ''C'',');
      ADOQuery4.SQL.Add('       :NUMERO_DOCUMENTO,');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('DATA_EMISSAO').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('DATA_VENCIMENTO').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery4.SQL.Add('       TO_DATE(''' + Trim(FDQuery1.FieldByName('DATA_VENC_ORIGINAL').AsString) + ''', ''dd/mm/yyyy''),');
      ADOQuery4.SQL.Add('       :VALOR,');
      ADOQuery4.SQL.Add('       :VALOR_ORIGINAL,');
      ADOQuery4.SQL.Add('       :VALOR_DESCONTO,');
      ADOQuery4.SQL.Add('       :SITUACAO,');
      ADOQuery4.SQL.Add('       :VALOR_JUROS,');
      ADOQuery4.SQL.Add('       :VALOR_PAGO,');
      ADOQuery4.SQL.Add('       :valor_saldo,');
      ADOQuery4.SQL.Add('       :historico,');
      ADOQuery4.SQL.Add('       ''1'')');

      ADOQuery4.Parameters.ParamByName('id').Value                        := TituloId;
      ADOQuery4.Parameters.ParamByName('integracaoid').Value              := FDQuery1.FieldByName('ID').AsString;
      ADOQuery4.Parameters.ParamByName('condicoes_pagamento_id').Value    := ProcuraCondicoesPagamento(FDQuery1.FieldByName('condicoes_pagamento_id').AsString);
      ADOQuery4.Parameters.ParamByName('NUMERO_DOCUMENTO').Value          := RemoveMascara(FDQuery1.FieldByName('NUMERO_DOCUMENTO').AsString);
      ADOQuery4.Parameters.ParamByName('VALOR').Value                     := FDQuery1.FieldByName('VALOR').AsFloat;
      ADOQuery4.Parameters.ParamByName('VALOR_ORIGINAL').Value            := FDQuery1.FieldByName('VALOR_ORIGINAL').AsFloat;
      ADOQuery4.Parameters.ParamByName('VALOR_DESCONTO').Value            := FDQuery1.FieldByName('VALOR_DESCONTO').AsFloat;
      ADOQuery4.Parameters.ParamByName('SITUACAO').Value                  := FDQuery1.FieldByName('SITUACAO').AsString;
      ADOQuery4.Parameters.ParamByName('VALOR_JUROS').Value               := FDQuery1.FieldByName('VALOR_JUROS').AsFloat;
      ADOQuery4.Parameters.ParamByName('VALOR_PAGO').Value                := FDQuery1.FieldByName('VALOR_PAGO').AsFloat;
      ADOQuery4.Parameters.ParamByName('valor_saldo').Value               := FDQuery1.FieldByName('valor_saldo').AsFloat;
      ADOQuery4.Parameters.ParamByName('historico').Value                 := FDQuery1.FieldByName('historico').AsString;

      try
        // Tenta salvar os dados
        ADOQuery4.ExecSQL;
          Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add(RemoveMascara(FDQuery1.FieldByName('NUMERO_DOCUMENTO').AsString));
          Memo1.Lines.Add(FDQuery1.FieldByName('ID').AsString);
          Erro := (E.Message);
          ShowMessage(Erro);
          Break;
        end;
      end;

      ADOQuery5.Parameters.Clear;
      ADOQuery5.SQL.Clear;

      ADOQuery5.SQL.Add('INSERT INTO titulo_pagar (');
      ADOQuery5.SQL.Add('       id,');
      ADOQuery5.SQL.Add('       fornecedor_id)');
      ADOQuery5.SQL.Add('VALUES (');
      ADOQuery5.SQL.Add('       :id,');
      ADOQuery5.SQL.Add('       :fornecedor_id)');

      ADOQuery5.Parameters.ParamByName('id').Value         := TituloId;
      ADOQuery5.Parameters.ParamByName('fornecedor_id').Value := ProcuraFornecedorId(FDQuery1.FieldByName('fornecedor_id').AsInteger);

      try
        // Tenta salvar os dados
        ADOQuery5.ExecSQL;
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add(RemoveMascara(FDQuery1.FieldByName('NUMERO_DOCUMENTO').AsString));
          Memo1.Lines.Add(FDQuery1.FieldByName('ID').AsString);
          Erro := (E.Message);
          ShowMessage(Erro);
          Break;
        end;
      end;
      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu titulos!');
    end;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///

    With FDQuery1 do
    begin
      SQL.Clear;
      SQL.Text :=
                 '  SELECT                                 '
                +'  	ma.ID_apagar titulo_id,              '
                +'  	''DINHEIRO'' CONDICOES_PAGAMENTO_DESCRICAO, '
                +'  	ma.total_pago valor_pago             '
                +'  FROM                                   '
                +'  	M_APAGAR ma                          ';
    end;
    FDQuery1.Open();

    // Inicia a transação
    if ADOConnection.Connected = false then
      ADOConnection.Open;

    if ADOConnection.InTransaction = False then
      ADOConnection.BeginTrans;

    FDQuery1.First;
    while not FDQuery1.Eof do
    begin

      // Gera um novo id
      TituloPagamentosId := GeraId('titulo_pagamentos');

      ADOQuery4.Parameters.Clear;
      ADOQuery4.SQL.Clear;

      ADOQuery4.SQL.Add('INSERT INTO titulo_pagamentos (');
      ADOQuery4.SQL.Add('       id,');
      ADOQuery4.SQL.Add('       titulo_id,');
      ADOQuery4.SQL.Add('       condicoes_pagamento_id,');
      ADOQuery4.SQL.Add('       valor_pago)');
      ADOQuery4.SQL.Add('VALUES (');
      ADOQuery4.SQL.Add('       :id,');
      ADOQuery4.SQL.Add('       :titulo_id,');
      ADOQuery4.SQL.Add('       :condicoes_pagamento_id,');
      ADOQuery4.SQL.Add('       :valor_pago)');

      ADOQuery4.Parameters.ParamByName('id').Value                      := TituloPagamentosId;
      ADOQuery4.Parameters.ParamByName('titulo_id').Value               := ProcuraTitulo(FDQuery1.FieldByName('titulo_id').AsInteger);
      ADOQuery4.Parameters.ParamByName('condicoes_pagamento_id').Value  := ProcuraCondicoesPagamento(FDQuery1.FieldByName('CONDICOES_PAGAMENTO_DESCRICAO').AsString);
      ADOQuery4.Parameters.ParamByName('valor_pago').Value              := FDQuery1.FieldByName('valor_pago').AsFloat;

      try
        // Tenta salvar os dados
        ADOQuery4.ExecSQL;
        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          Memo1.Lines.Add(FDQuery1.FieldByName('ID').AsString);
          Erro := (E.Message);
          ShowMessage(Erro);
          Break;
        end;
      end;

      FDQuery1.Next;
    end;

    if Erro <> '' then
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
      Showmessage(Erro);
    end
    else
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;
      Memo1.Lines.Add('Concluiu titulos pagamentos!');
    end;

    currentDate := Now;
    Memo1.Lines.Add(DateToStr(currentDate) + ' - ' + TimeToStr(currentDate)) ;
  end
  else
  begin
   ShowMessage('Não foi possível conectar ao banco de dados.');
  end;

end;

function TForm3.RemoveMascara(Texto: String): String;
begin
  Result := StringReplace(Texto,  '.', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ',', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ':', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ';', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '/', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '\', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '|', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '+', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '_', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '[', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ']', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '{', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '(', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ')', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '<', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '>', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '@', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '#', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '$', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '&', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '*', '', [rfReplaceAll, rfIgnoreCase]);
//  Result := StringReplace(Result, ' ', '', [rfReplaceAll, rfIgnoreCase]);
end;

function TForm3.ProcuraFornecedorId(id : integer):integer;
begin
  Result := 1;

  // pega nome do cliente no banco firebird
  With FDQuery6 do
  begin
    SQL.Clear;
    SQL.Text :=
           ' SELECT              '
          +'	id_fornecedor id,  '
          +'	razaosocial        '
          +' FROM fornecedor f     '
          +' where id_fornecedor = :id '

  end;
  FDQuery6.Params.ParamByName('id').Value := id;
  FDQuery6.Open();

  if FDQuery6.RecordCount >0 then
  begin
    //procura nome no banco novo com id novo
    QryAx3.Parameters.Clear;
    QryAx3.SQL.Clear;

    CdsAx3.Close;
    QryAx3.SQL.Add('select id from pessoa  where razao_social = :razao_social');
    QryAx3.Parameters.ParamByName('razao_social').Value := FDQuery6.FieldByName('razaosocial').AsString;
    CdsAx3.Open;

    if CdsAx3.RecordCount >0 then
      Result := CdsAx3.FieldByName('id').AsInteger
  end;
end;




function TForm3.ProcuraClienteID(id : integer):integer;
begin
  Result := 1;

  // pega nome do cliente no banco firebird
  With FDQuery6 do
  begin
    SQL.Clear;
    SQL.Text :=
           ' SELECT              '
          +'	id_cliente id,     '
          +'	nome razao_social  '
          +' FROM clientes c     '
          +' where id_cliente = :id '

  end;
  FDQuery6.Params.ParamByName('id').Value := id;
  FDQuery6.Open();

  if FDQuery6.RecordCount >0 then
  begin
    //procura nome no banco novo com id novo
    QryAx3.Parameters.Clear;
    QryAx3.SQL.Clear;

    CdsAx3.Close;
    QryAx3.SQL.Add('select id from pessoa  where razao_social = :razao_social');
    QryAx3.Parameters.ParamByName('razao_social').Value := FDQuery6.FieldByName('razao_social').AsString;
    CdsAx3.Open;

    if CdsAx3.RecordCount >0 then
      Result := CdsAx3.FieldByName('id').AsInteger
  end;
end;

function TForm3.ProcuraChequeCabecalho(id : integer):integer;
begin
  Result := 1;
  //procura nome no banco novo com id novo
  QryAx3.Parameters.Clear;
  QryAx3.SQL.Clear;

  CdsAx3.Close;
  QryAx3.SQL.Add('select id,data,cheque_destino_id from cheque_baixa_cabecalho where integracaoid = :integracaoid');
  QryAx3.Parameters.ParamByName('integracaoid').Value := id;
  CdsAx3.Open;

  if CdsAx3.RecordCount >0 then
    Result := CdsAx3.FieldByName('id').AsInteger
end;

function TForm3.ProcuraCheque(id : integer):integer;
begin
  Result := 1;
  //procura nome no banco novo com id novo
  QryAx3.Parameters.Clear;
  QryAx3.SQL.Clear;

  CdsAx3.Close;
  QryAx3.SQL.Add('select id from cheque where integracaoid = :integracaoid');
  QryAx3.Parameters.ParamByName('integracaoid').Value := id;
  CdsAx3.Open;

  if CdsAx3.RecordCount >0 then
    Result := CdsAx3.FieldByName('id').AsInteger
end;



function TForm3.ProcuraCpfCnpj(cpf_cnpj : string):Boolean;
begin
  Result := False;
  //Ax6 pessoa
  if CdsAx6.Locate( 'cpf_cnpj',cpf_cnpj,[]) then
  begin
    Result := True;
  end;
end;


function TForm3.ProcuraEmitente(cpf_cnpj : string; Nome : string):Integer;
begin
  Result := 0;

  //Ax6 pessoa
  if CdsAx6.Locate('razao_social',Nome,[]) then
  begin
    Result := CdsAx6.FieldByName('id').AsInteger;
  end
  else
  begin
    //Ax6 pessoa
    if CdsAx6.Locate('cpf_cnpj',cpf_cnpj,[]) then
    begin
      Result := CdsAx6.FieldByName('id').AsInteger;
    end;
  end;
end;

function TForm3.ProcuraCpf_Cnpj(cpf_cnpj : string):integer;
begin
  Result := 0;
  if CdsAx6.Locate( 'cpf_cnpj',cpf_cnpj,[]) then
  begin
    Result := CdsAx6.FieldByName('id').AsInteger;
  end;
end;

function TForm3.ProcuraChequeDestino(Destino : integer):integer;
begin
  Result := 1;
  //Ax5 cheque
  if CdsAx5.Locate( 'descricao',Destino,[]) then
  begin
    Result :=  CdsAx5.FieldByName('id').AsInteger;
  end;
end;


function TForm3.ProcuraCidade(cidade : string):string;
var
  NomeCidade : string;
begin
  Result := '0';

  NomeCidade :=  UpperCase(RemoveMascara(cidade));

  if CdsAx4.Locate( 'CIDADE',NomeCidade,[]) then
  begin
     Result :=  CdsAx4.FieldByName('id').AsString;
  end;
end;

function TForm3.ProcuraBanco(banco : string):integer;
begin
  Result := 0;

  //Ax7 Banco
  if CdsAx7.Locate( 'codigo',banco,[]) then
  begin
     Result :=  CdsAx7.FieldByName('id').AsInteger;
  end;
end;


function TForm3.ProcuraClienteNome(Razao : string):integer;
begin
  Result := 1;
  //Ax8 titulo
  if CdsAx6.Locate( 'razao_social',Razao,[]) then
  begin
    Result := CdsAx6.FieldByName('id').AsInteger;
  end;
end;

function TForm3.ProcuraClienteNomeBoolean(Razao : string):Boolean;
begin
  Result := False;
  //Ax8 titulo
  if CdsAx6.Locate( 'razao_social',Razao,[]) then
  begin
    Result := True;
  end
  else
  begin
    if CdsAx6.Locate( 'nome_fantasia',Razao,[]) then
    begin
      Result := True;
    end;
  end;
end;

function TForm3.ProcuraTitulo(TituloId : integer):integer;
begin
  Result := 0;
  //Ax8 titulo
  if CdsAx8.Locate( 'integracaoid',TituloId,[]) then
  begin
    Result := CdsAx8.FieldByName('id').AsInteger;
  end;
end;


function TForm3.ProcuraCondicoesPagamento(descricao : string):integer;
begin
  Result := 0;
  //Ax9 titulo
  if CdsAx9.Locate( 'descricao',descricao,[]) then
  begin
    Result := CdsAx9.FieldByName('id').AsInteger;
  end;

end;


function TForm3.ConectaBanco :Boolean;
var
  vDllFirebird,
  vName : String;
  Integracao : TIntegracao;
begin
  Result := False;

  Integracao := LerIniIntegracao;

  FDPhysFBDriverLink1.VendorLib := Integracao.VendorLib;

  FDConnection1.Connected := False;

  with FDConnection1 do
  begin
    Params.Values['Database']  := Integracao.Database;
    Params.Values['User_name'] := Integracao.UserName;
    Params.Values['Password']  := Integracao.Password;
    Params.Values['Protocol']  := Integracao.Protocol;
    Params.Values['Server']    := Integracao.Server;

    Result := True;
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  if ConectaBanco = False then
  begin
    ShowMessage('Não foi possível conectar ao banco.');
  end;
end;

Function TForm3.LerIniIntegracao: TIntegracao;
var
  Config : TiniFile;
begin
  // Carregando os parametros e conexao
  Try
    try
      Config := TiniFile.Create( '.\Config.ini' );

      with Result do
      begin
        VendorLib := Config.ReadString( 'INTEGRACAO', 'VendorLib','');
        Database  := Config.ReadString( 'INTEGRACAO', 'Database','');
        UserName  := Config.ReadString( 'INTEGRACAO', 'UserName','');
        Password  := Config.ReadString( 'INTEGRACAO', 'Password','');
        Protocol  := Config.ReadString( 'INTEGRACAO', 'Protocol','');
        Server    := Config.ReadString( 'INTEGRACAO', 'Server','');
      end;
    finally
      Config.Free;
    end;
  Except
    ShowMessage('Não foi possível ler o config.ini da integração');
    Exit;
  end;

end;



function TForm3.GeraCPF(const Ponto: Boolean): string;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, d1, d2: LongInt;
begin
  n1 := Trunc(Random(10));
  n2 := Trunc(Random(10));
  n3 := Trunc(Random(10));
  n4 := Trunc(Random(10));
  n5 := Trunc(Random(10));
  n6 := Trunc(Random(10));
  n7 := Trunc(Random(10));
  n8 := Trunc(Random(10));
  n9 := Trunc(Random(10));
  d1 := (n9 * 2) + (n8 * 3) + (n7 * 4) + (n6 *  5) + (n5 * 6) +
  (n4 * 7) + (n3 * 8) + (n2 * 9) + (n1 * 10);
  d1 := 11 - (d1 mod 11);
  if (d1 >= 10) then d1 := 0;
    d2 := (d1 * 2) + (n9 * 3) + (n8 * 4) + (n7 *  5) + (n6 *  6) +
   (n5 * 7) + (n4 * 8) + (n3 * 9) + (n2 * 10) + (n1 * 11);
    d2 := 11 - (d2 mod 11);
  if (d2>=10) then d2 := 0;
    Result := IntToStr(n1) + IntToStr(n2) + IntToStr(n3) + IntToStr(n4) + IntToStr(n5) + IntToStr(n6) +
              IntToStr(n7) + IntToStr(n8) + IntToStr(n9) + IntToStr(d1) + IntToStr(d2);
  if Ponto then
     Result := Copy(Result, 1, 3) + '.' + Copy(Result, 4, 3) + '.' + Copy(Result, 7, 3) + '-' + Copy(Result, 10, 2);
end;


function TForm3.GeraId(Tabela: String): Integer;
var
  Query: TADOQuery;
  Sequencia: String;
begin
  Result := -1;

  // Define o nome da sequência.
  // NOTE: O nome da sequência deve ter no máximo 30 caracteres (conforme o
  //       padrão de nomeclatura do Oracle).
  Sequencia := Copy('se_' + Tabela, 1, 30);

  Query := TADOQuery.Create(Self);
  Query.Connection := ADOConnection;

  // Carrega o id gerado pela sequência
  Query.SQL.Text := 'SELECT ' + Sequencia + '.NEXTVAL FROM dual';
  Query.Open;

  Result := Query.Fields[0].AsInteger;

  // Fecha e descarta a query
  Query.Close;
  Query.Destroy;
end;

end.

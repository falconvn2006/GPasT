unit dat.cadPessoas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, System.StrUtils,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaPessoa(XIdPessoa: integer): TJSONObject;
function RetornaListaPessoas(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
function RetornaTotalPessoas(const XQuery: TDictionary<string, string>): TJSONObject;
function IncluiPessoa(XPessoa: TJSONObject): TJSONObject;
function AlteraPessoa(XIdPessoa: integer; XPessoa: TJSONObject): TJSONObject;
function ApagaPessoa(XIdPessoa: integer): TJSONObject;
function VerificaRequisicao(XPessoa: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaPessoa(XIdPessoa: integer): TJSONObject;
var wquery: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wret: TJSONObject;
begin
  try
// cria provider de conexão com BD
    wconexao := TProviderDataModuleConexao.Create(nil);

    wquery   := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       with wquery do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select  "CodigoInternoPessoa"       as id,');
         SQL.Add('        "CodigoPessoa"              as codigo,');
         SQL.Add('        "NomePessoa"                as nome,');
         SQL.Add('        "EhPessoaFisica"            as ehfisica,');
         SQL.Add('        "CodigoAtividadePessoa"     as idatividade,');
         SQL.Add('        cast((select "NomeAtividade" from "Atividade" where "CodigoInternoAtividade" = "PessoaGeral"."CodigoAtividadePessoa") as varchar) as xatividade,');
         SQL.Add('        "CodigoContabilPessoa"      as idcontabil,');
         SQL.Add('        "ContaCorrentePessoa"       as ctacorrente,');
         SQL.Add('        "CodigoCobrancaPessoa"      as idcobranca,');
         SQL.Add('        cast((select "NomeDocumentoCobranca" from "DocumentoCobranca" where "CodigoInternoCobranca"="PessoaGeral"."CodigoCobrancaPessoa") as varchar) as xcobranca,');
         SQL.Add('        "CodigoRepresentantePessoa" as idrepresentante,');
         SQL.Add('        cast((select "NomePessoa" from "PessoaGeral" as "representante" where "representante"."CodigoInternoPessoa"="PessoaGeral"."CodigoRepresentantePessoa") as varchar) as xrepresentante,');
         SQL.Add('        "CodigoBancoPessoa"         as idbanco,');
         SQL.Add('        cast((select "banco"."NomePessoa" from "PessoaGeral" as "banco" where "banco"."CodigoInternoPessoa" = "PessoaGeral"."CodigoBancoPessoa") as varchar) as xbanco,');
         SQL.Add('        "ObservacaoPessoa"          as observacao,');
         SQL.Add('        "EhClientePessoa"           as ehcliente,');
         SQL.Add('        "EhFornecedorPessoa"        as ehfornecedor,');
         SQL.Add('        "EhEmpresaPessoa"           as ehempresa,');
         SQL.Add('        "EhBancoPessoa"             as ehbanco,');
         SQL.Add('        "EhRepresentantePessoa"     as ehrepresentante,');
         SQL.Add('        "EhTransportadoraPessoa"    as ehtransportador,');
         SQL.Add('        "EhConvenioPessoa"          as ehconvenio,');
         SQL.Add('        "EhFuncionarioPessoa"       as ehfuncionario,');
         SQL.Add('        "ContatoPessoa"             as contato,');
         SQL.Add('        "DataCadastramentoPessoa"   as datacadastramento,');
         SQL.Add('        "EntregaEnderecoPessoa"     as endereco,');
         SQL.Add('        "EntregaComplementoPessoa"  as complemento,');
         SQL.Add('        "EntregaBairroPessoa"       as bairro,');
         SQL.Add('        "EntregaCodigoCidadePessoa" as idlocalidade,');
         SQL.Add('        cast("Localidade"."NomeLocalidade" as varchar) as xlocalidade,');
         SQL.Add('        cast(("Localidade"."NomeLocalidade"||'' - ''||"Localidade"."EstadoLocalidade") as varchar) as xnomelocalidade,');
         SQL.Add('        "EntregaCepPessoa"          as cep,');
         SQL.Add('        "EntregaTelefonePessoa"     as telefone,');
         SQL.Add('        "EntregaFaxPessoa"          as fax,');
         SQL.Add('        "CodigoAlvoPessoa"          as idalvo,');
         SQL.Add('        cast((select "alvo"."NomePessoa" from "PessoaGeral" as "alvo" where "alvo"."CodigoInternoPessoa" = "PessoaGeral"."CodigoAlvoPessoa") as varchar) as xcobrarde,');
         SQL.Add('        "InscricaoEstadualPessoa"   as inscricaoestadual,');
         SQL.Add('        "CgcPessoa"                 as cnpj,');
         SQL.Add('        "IdentidadePessoa"          as rg,');
         SQL.Add('        "CicPessoa"                 as cpf,');
         SQL.Add('        (case when "EhPessoaFisica" then "CicPessoa" else "CgcPessoa" end) as xdocumento1,');
         SQL.Add('        (case when "EhPessoaFisica" then "IdentidadePessoa" else "InscricaoEstadualPessoa" end) as xdocumento2,');
         SQL.Add('        "SexoPessoa"                as sexo,');
         SQL.Add('        "DataNascimentoPessoa"      as datanascimento,');
         SQL.Add('        "EstadoCivilPessoa"         as estadocivil,');
         SQL.Add('        "NomePaiPessoa"             as nomepai,');
         SQL.Add('        "NomeMaePessoa"             as nomemae,');
         SQL.Add('        "NomeEmpresaPessoa"         as nomeempresa,');
         SQL.Add('        "CodigoCargoPessoa"         as codcargo,');
         SQL.Add('        "EnderecoTrabalhoPessoa"    as enderecotrabalho,');
         SQL.Add('        "BairroTrabalhoPessoa"      as bairrotrabalho,');
         SQL.Add('        "CEPTrabalhoPessoa"         as ceptrabalho,');
         SQL.Add('        "TelefoneTrabalhoPessoa"    as telefonetrabalho,');
         SQL.Add('        "SalarioPessoa"             as salario,');
         SQL.Add('        "SenhaPessoa"               as senha,');
         SQL.Add('        "VerificaDebitosPessoa"     as verificadebitos,');
         SQL.Add('        "NomeConjugePessoa"         as nomeconjuge,');
         SQL.Add('        "NomeEmpresaConjugePessoa"  as nomeempresaconjuge,');
         SQL.Add('        "CodigoAtividadeConjugePessoa" as idatividadeconjuge,');
         SQL.Add('        cast((select "NomeAtividade" from "Atividade" where "CodigoInternoAtividade" = "PessoaGeral"."CodigoAtividadeConjugePessoa") as varchar) as xatividadeconjuge,');
         SQL.Add('        "DataNascimentoConjugePessoa"  as datanascimentoconjuge,');
         SQL.Add('        "SalarioConjugePessoa"         as salarioconjuge,');
         SQL.Add('        "NomeDiretor1Pessoa"           as nomediretor1empresa,');
         SQL.Add('        "NomeDiretor2Pessoa"           as nomediretor2empresa,');
         SQL.Add('        "DataFundacaoEmpresaPessoa"    as datafundacaoempresa,');
         SQL.Add('        "ReferenciaComercial1Pessoa"   as referenciacomercial1,');
         SQL.Add('        "ReferenciaComercial2Pessoa"   as referenciacomercial2,');
         SQL.Add('        "NaturalidadePessoa"           as idnaturalidade,');
         SQL.Add('        cast("naturalidade"."NomeLocalidade" as varchar) as xnaturalidade,');
         SQL.Add('        cast(("naturalidade"."NomeLocalidade"||'' - ''||"naturalidade"."EstadoLocalidade") as varchar) as xnomenaturalidade,');
         SQL.Add('        "LimiteCreditoPessoa"          as limitecredito,');
         SQL.Add('        "DigitoBancoPessoa"            as digitobanco,');
         SQL.Add('        "EhSupervisorPessoa"           as ehsupervisor,');
         SQL.Add('        "EhUsuarioPessoa"              as ehusuario,');
         SQL.Add('        "EhOperadorPessoa"             as ehoperador,');
         SQL.Add('        "AgenciaBancoPessoa"           as agenciabanco,');
         SQL.Add('        "PercentualComissaoPessoa"     as perccomissao,');
         SQL.Add('        "PessoaGeral"."DataUltimaAlteracao"          as dataultimaalteracao,');
         SQL.Add('        "EhMedicoPessoa"               as ehmedico,');
         SQL.Add('        "AtivoPessoa"                  as ativo,');
         SQL.Add('        "CodigoTabelaPrecoPessoa"      as idtabelapreco,');
         SQL.Add('        cast((select "DescricaoTabela" from "TabelaPreco" where "CodigoInternoTabela" = "PessoaGeral"."CodigoTabelaPrecoPessoa") as varchar)  as xtabela,');
         SQL.Add('        "CodigoCondicaoPessoa"         as idcondicao,');
         SQL.Add('        cast((select "DescricaoCondicao" from "CondicaoPagamento" where "CodigoInternoCondicao" = "PessoaGeral"."CodigoCondicaoPessoa") as varchar)  as xcondicao,');
         SQL.Add('        "EntregaEmailPessoa"           as email,');
         SQL.Add('        "EntregaCaixaPostalPessoa"     as caixapostal,');
         SQL.Add('        "CaminhoFotoPessoa"            as caminhofoto,');
         SQL.Add('        "CreditoPessoa"                as credito,');
         SQL.Add('        "NomeFantasiaPessoa"           as nomefantasia,');
         SQL.Add('        "PercentualDescontoPessoa"     as percdesconto,');
         SQL.Add('        "PrazoCondicaoPessoa"          as prazocondicao,');
         SQL.Add('        "EmiteEtiquetaPessoa"          as emiteetiqueta,');
         SQL.Add('        "MeuRelatorioConfiguravelPessoa" as meurelatorioconfiguravel,');
         SQL.Add('        "EhOftalmoPessoa"              as ehoftalmo,');
         SQL.Add('        "PerfilPermissaoPessoa"        as idperfilpermissao,');
         SQL.Add('        "DataPermissaoInicialPessoa"   as datainicialpermissao,');
         SQL.Add('        "DataPermissaoFinalPessoa"     as datafinalpermissao,');
         SQL.Add('        "EhSuperUsuarioPessoa"         as ehsuperusuario,');
         SQL.Add('        "SenhaSuperUsuarioPessoa"      as senhasuperusuario,');
         SQL.Add('        "EhRepresentanteSupervisorPessoa" as ehrepresentantesupervisor,');
         SQL.Add('        "DataIngressoFidelidadePessoa"    as dataingressofidelidade,');
         SQL.Add('        "PreCadastroPessoa"               as ehprecadastro,');
         SQL.Add('        "ObservacaoDiversaPessoa"         as observacaodiversa,');
         SQL.Add('        "HostEmailPessoa"                 as hostemail,');
         SQL.Add('        "PortaHostPessoa"                 as portahostemail,');
         SQL.Add('        "SenhaHostPessoa"                 as senhahostemail,');
         SQL.Add('        "NomeRemetenteEmailPessoa"        as nomeremetenteemail,');
         SQL.Add('        "MensagemFinalEmailPessoa"        as mensagemfinalemail,');
         SQL.Add('        "RequerAutenticacaoEmailPessoa"   as requerautenticacaoemail,');
         SQL.Add('        "ConfirmacaoLeituraEmailPessoa"   as confirmacaoleituraemail,');
         SQL.Add('        "CopiaEmailRemetentePessoa"       as copiarementeemail,');
         SQL.Add('        "PrioridadeEmailPessoa"           as prioridadeemail,');
         SQL.Add('        "GerarRemessaPessoa"              as geraremessa,');
         SQL.Add('        "CodigoEmpresaFuncionarioPessoa"  as idempresafuncionario,');
         SQL.Add('        "InscricaoSuframaPessoa"          as suframa,');
         SQL.Add('        "CobrancaEnderecoPessoa"          as enderecocobranca,');
         SQL.Add('        "CobrancaComplementoPessoa"       as complementocobranca,');
         SQL.Add('        "CobrancaBairroPessoa"            as bairrocobranca,');
         SQL.Add('        "CobrancaCodigoCidadePessoa"      as idlocalidadecobranca,');
         SQL.Add('        cast("localidade2"."NomeLocalidade" as varchar) as xlocalidadecobranca,');
         SQL.Add('        cast(("localidade2"."NomeLocalidade"||'' - ''||"localidade2"."EstadoLocalidade") as varchar) as xnomelocalidadecobranca,');
         SQL.Add('        "CobrancaCepPessoa"               as cepcobranca,');
         SQL.Add('        "CobrancaTelefonePessoa"          as telefonecobranca,');
         SQL.Add('        "TemplateBiometricoPessoa"        as templatebiometrico,');
         SQL.Add('        "ContaDebitoPessoa"               as idcontadebito,');
         SQL.Add('        "ContaCreditoPessoa"              as idcontacredito,');
         SQL.Add('        "HabilitarCalculoRetencaoParcelasPessoa" as habilitarcalculoretencao,');
         SQL.Add('        "InscricaoMunicipalPessoa"        as inscricaomunicipal,');
         SQL.Add('        "PossuiConfiguracaoIniPessoa"     as possuiconfiguracaoini,');
         SQL.Add('        "ValorFaturarPessoa"              as valorfaturar,');
         SQL.Add('        "SitePessoa"                      as site,');
         SQL.Add('        "NaoGerarRemessaPessoa"           as naogeraremessa,');
         SQL.Add('        "EhRepresentanteMobilePessoa"     as ehrepresentantemobile,');
         SQL.Add('        "DataEnvioPessoa"                 as dataenvio,');
         SQL.Add('        "IdentificadorIEPessoa"           as identificadorinscricaoestadual,');
         SQL.Add('        "AceitaDevolucaoPessoa"           as aceitadevolucao,');
         SQL.Add('        "UseTlsExplicitEmailPessoa"       as tlsexplicitoemail,');
         SQL.Add('        "InscricaoEstadualSubstitutoPessoa" as inscricaoestadualsubstituto,');
         SQL.Add('        "CobrancaEmailPessoa"             as emailcobranca,');
         SQL.Add('        "EhClienteRevenda"                as ehclienterevenda,');
         SQL.Add('        "ParticipanteREIDIPessoa"         as participantereidi,');
         SQL.Add('        "AceitaFracionarBancarioPessoa"   as aceitafracionarbancario,');
         SQL.Add('        "AceitaTransferenciaBancarioPessoa" as aceitatransferenciabancario ');
         SQL.Add('from "PessoaGeral" left join "Localidade" on "PessoaGeral"."EntregaCodigoCidadePessoa" = "Localidade"."CodigoInternoLocalidade" ');
         SQL.Add('                   left join "Localidade"  as "localidade2"  on "PessoaGeral"."CobrancaCodigoCidadePessoa" = "localidade2"."CodigoInternoLocalidade" ');
         SQL.Add('                   left join "Localidade"  as "naturalidade" on "PessoaGeral"."NaturalidadePessoa" = "naturalidade"."CodigoInternoLocalidade" ');
         SQL.Add('where "PessoaGeral"."CodigoInternoPessoa"=:xid ');
         ParamByName('xid').AsInteger := XIdPessoa;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma Pessoa encontrada');
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end;

  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao retornar Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

function RetornaTotalPessoas(const XQuery: TDictionary<string, string>): TJSONObject;
var wquery: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wret: TJSONObject;
begin
  try
// cria provider de conexão com BD
    wconexao := TProviderDataModuleConexao.Create(nil);

    wquery   := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       with wquery do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select count(*) as registros ');
         SQL.Add('from "PessoaGeral" left join "Localidade" on "PessoaGeral"."EntregaCodigoCidadePessoa" = "Localidade"."CodigoInternoLocalidade" ');
         SQL.Add('where "CodigoEmpresaPessoa"=:xempresa ');
         if XQuery.ContainsKey('codigo') then // filtro por código
            begin
              SQL.Add('and cast("CodigoPessoa" as varchar) like :xcodigo ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo']+'%';
            end;
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomePessoa") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
            end;
         if XQuery.ContainsKey('cpf') then // filtro por cpf
            begin
              SQL.Add('and "CicPessoa" like :xcpf ');
              ParamByName('xcpf').AsString := XQuery.Items['cpf']+'%';
            end;
         if XQuery.ContainsKey('cnpj') then // filtro por cnpj
            begin
              SQL.Add('and "CgcPessoa" like :xcnpj ');
              ParamByName('xcnpj').AsString := XQuery.Items['cnpj']+'%';
            end;
         if XQuery.ContainsKey('rg') then // filtro por rg
            begin
              SQL.Add('and "IdentidadePessoa" like :xrg ');
              ParamByName('xrg').AsString := XQuery.Items['rg']+'%';
            end;
         if XQuery.ContainsKey('inscricaoestadual') then // filtro por ie
            begin
              SQL.Add('and "InscricaoEstadualPessoa" like :xinscricaoestadual ');
              ParamByName('xinscricaoestadual').AsString := XQuery.Items['inscricaoestadual']+'%';
            end;
         if XQuery.ContainsKey('ativo') then // filtro por ativo
            begin
              SQL.Add('and "AtivoPessoa" =:xativo ');
              ParamByName('xativo').AsBoolean := strtobooldef(XQuery.Items['ativo'],false);
            end;
         if XQuery.ContainsKey('ehbanco') then // filtro por banco
            begin
              SQL.Add('and "EhBancoPessoa" =:xehbanco ');
              ParamByName('xehbanco').AsBoolean := strtobooldef(XQuery.Items['ehbanco'],false);
            end;
         if XQuery.ContainsKey('ehcliente') then // filtro por cliente
            begin
              SQL.Add('and "EhClientePessoa" =:xehcliente ');
              ParamByName('xehcliente').AsBoolean := strtobooldef(XQuery.Items['ehcliente'],false);
            end;
         if XQuery.ContainsKey('ehconvenio') then // filtro por convenio
            begin
              SQL.Add('and "EhConvenioPessoa" =:xehconvenio ');
              ParamByName('xehconvenio').AsBoolean := strtobooldef(XQuery.Items['ehconvenio'],false);
            end;
         if XQuery.ContainsKey('ehfornecedor') then // filtro por fornecedor
            begin
              SQL.Add('and "EhFornecedorPessoa" =:xehfornecedor ');
              ParamByName('xehfornecedor').AsBoolean := strtobooldef(XQuery.Items['ehfornecedor'],false);
            end;
         if XQuery.ContainsKey('ehfuncionario') then // filtro por funcionario
            begin
              SQL.Add('and "EhFuncionarioPessoa" =:xehfuncionario ');
              ParamByName('xehfuncionario').AsBoolean := strtobooldef(XQuery.Items['ehfuncionario'],false);
            end;
         if XQuery.ContainsKey('ehrepresentante') then // filtro por representante
            begin
              SQL.Add('and "EhRepresentantePessoa" =:xehrepresentante ');
              ParamByName('xehrepresentante').AsBoolean := strtobooldef(XQuery.Items['ehrepresentante'],false);
            end;
         if XQuery.ContainsKey('ehtranportador') then // filtro por transportador
            begin
              SQL.Add('and "EhTransportadoraPessoa" =:xehtransportador ');
              ParamByName('xehtransportador').AsBoolean := strtobooldef(XQuery.Items['ehtransportador'],false);
            end;
         if XQuery.ContainsKey('ehrepresentantemobile') then // filtro por representante mobile
            begin
              SQL.Add('and "EhRepresentanteMobilePessoa" =:xehrepresentantemobile ');
              ParamByName('xehrepresentantemobile').AsBoolean := strtobooldef(XQuery.Items['ehrepresentantemobile'],false);
            end;
         if XQuery.ContainsKey('ehoftalmo') then // filtro por oftalmo
            begin
              SQL.Add('and "EhOftalmologitaPessoa" =:xehoftalmo ');
              ParamByName('xehoftalmo').AsBoolean := strtobooldef(XQuery.Items['ehoftalmo'],false);
            end;
         if XQuery.ContainsKey('ehmedico') then // filtro por medico
            begin
              SQL.Add('and "EhMedicoPessoa" =:xehmedico ');
              ParamByName('xehmedico').AsBoolean := strtobooldef(XQuery.Items['ehmedico'],false);
            end;
         if XQuery.ContainsKey('xdocumento1') then // filtro por documento1
            begin
              SQL.Add('and (case when "EhPessoaFisica" then "CicPessoa" else "CgcPessoa" end) like :xdocumento1 ');
              ParamByName('xdocumento1').AsString := XQuery.Items['xdocumento1']+'%';
            end;
         if XQuery.ContainsKey('xdocumento2') then // filtro por documento2
            begin
              SQL.Add('and (case when "EhPessoaFisica" then "IdentidadePessoa" else "InscricaoEstadualPessoa" end) like :xdocumento2 ');
              ParamByName('xdocumento2').AsString := XQuery.Items['xdocumento2']+'%';
            end;
         if XQuery.ContainsKey('xnomelocalidade') then // filtro por nome localidade
            begin
              SQL.Add('and lower("Localidade"."NomeLocalidade") like lower(:xnomelocalidade) ');
              ParamByName('xnomelocalidade').AsString := XQuery.Items['xnomelocalidade']+'%';
            end;
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaPessoa;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma pessoa encontrada');
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end;

  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao retornar localidade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

function RetornaListaPessoas(const XQuery: TDictionary<string, string>; XLimit,XOffset: integer): TJSONArray;
var wqueryLista: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
    wordem: string;
begin
  try
// cria provider de conexão com BD
    wconexao    := TProviderDataModuleConexao.Create(nil);
    wqueryLista := TFDQuery.Create(nil);

    if wconexao.EstabeleceConexaoDB then
       with wqueryLista do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select  "CodigoInternoPessoa"       as id,');
         SQL.Add('        "CodigoPessoa"              as codigo,');
         SQL.Add('        "NomePessoa"                as nome,');
         SQL.Add('        "EhPessoaFisica"            as ehfisica,');
         SQL.Add('        "CodigoAtividadePessoa"     as idatividade,');
         SQL.Add('        cast((select "NomeAtividade" from "Atividade" where "CodigoInternoAtividade" = "PessoaGeral"."CodigoAtividadePessoa") as varchar) as xatividade,');
         SQL.Add('        "CodigoContabilPessoa"      as idcontabil,');
         SQL.Add('        "ContaCorrentePessoa"       as ctacorrente,');
         SQL.Add('        "CodigoCobrancaPessoa"      as idcobranca,');
         SQL.Add('        cast((select "NomeDocumentoCobranca" from "DocumentoCobranca" where "CodigoInternoCobranca"="PessoaGeral"."CodigoCobrancaPessoa") as varchar) as xcobranca,');
         SQL.Add('        "CodigoRepresentantePessoa" as idrepresentante,');
         SQL.Add('        cast((select "NomePessoa" from "PessoaGeral" as "representante" where "representante"."CodigoInternoPessoa"="PessoaGeral"."CodigoRepresentantePessoa") as varchar) as xrepresentante,');
         SQL.Add('        "CodigoBancoPessoa"         as idbanco,');
         SQL.Add('        cast((select "banco"."NomePessoa" from "PessoaGeral" as "banco" where "banco"."CodigoInternoPessoa" = "PessoaGeral"."CodigoBancoPessoa") as varchar) as xbanco,');
         SQL.Add('        "ObservacaoPessoa"          as observacao,');
         SQL.Add('        "EhClientePessoa"           as ehcliente,');
         SQL.Add('        "EhFornecedorPessoa"        as ehfornecedor,');
         SQL.Add('        "EhEmpresaPessoa"           as ehempresa,');
         SQL.Add('        "EhBancoPessoa"             as ehbanco,');
         SQL.Add('        "EhRepresentantePessoa"     as ehrepresentante,');
         SQL.Add('        "EhTransportadoraPessoa"    as ehtransportador,');
         SQL.Add('        "EhConvenioPessoa"          as ehconvenio,');
         SQL.Add('        "EhFuncionarioPessoa"       as ehfuncionario,');
         SQL.Add('        "ContatoPessoa"             as contato,');
         SQL.Add('        "DataCadastramentoPessoa"   as datacadastramento,');
         SQL.Add('        "EntregaEnderecoPessoa"     as endereco,');
         SQL.Add('        "EntregaComplementoPessoa"  as complemento,');
         SQL.Add('        "EntregaBairroPessoa"       as bairro,');
         SQL.Add('        "EntregaCodigoCidadePessoa" as idlocalidade,');
         SQL.Add('        cast("Localidade"."NomeLocalidade" as varchar) as xlocalidade,');
         SQL.Add('        cast(("Localidade"."NomeLocalidade"||'' - ''||"Localidade"."EstadoLocalidade") as varchar) as xnomelocalidade,');
         SQL.Add('        "EntregaCepPessoa"          as cep,');
         SQL.Add('        "EntregaTelefonePessoa"     as telefone,');
         SQL.Add('        "EntregaFaxPessoa"          as fax,');
         SQL.Add('        "CodigoAlvoPessoa"          as idalvo,');
         SQL.Add('        cast((select "alvo"."NomePessoa" from "PessoaGeral" as "alvo" where "alvo"."CodigoInternoPessoa" = "PessoaGeral"."CodigoAlvoPessoa") as varchar) as xcobrarde,');
         SQL.Add('        "InscricaoEstadualPessoa"   as inscricaoestadual,');
         SQL.Add('        "CgcPessoa"                 as cnpj,');
         SQL.Add('        "IdentidadePessoa"          as rg,');
         SQL.Add('        "CicPessoa"                 as cpf,');
         SQL.Add('        (case when "EhPessoaFisica" then "CicPessoa" else "CgcPessoa" end) as xdocumento1,');
         SQL.Add('        (case when "EhPessoaFisica" then "IdentidadePessoa" else "InscricaoEstadualPessoa" end) as xdocumento2,');
         SQL.Add('        "SexoPessoa"                as sexo,');
         SQL.Add('        "DataNascimentoPessoa"      as datanascimento,');
         SQL.Add('        "EstadoCivilPessoa"         as estadocivil,');
         SQL.Add('        "NomePaiPessoa"             as nomepai,');
         SQL.Add('        "NomeMaePessoa"             as nomemae,');
         SQL.Add('        "NomeEmpresaPessoa"         as nomeempresa,');
         SQL.Add('        "CodigoCargoPessoa"         as codcargo,');
         SQL.Add('        "EnderecoTrabalhoPessoa"    as enderecotrabalho,');
         SQL.Add('        "BairroTrabalhoPessoa"      as bairrotrabalho,');
         SQL.Add('        "CEPTrabalhoPessoa"         as ceptrabalho,');
         SQL.Add('        "TelefoneTrabalhoPessoa"    as telefonetrabalho,');
         SQL.Add('        "SalarioPessoa"             as salario,');
         SQL.Add('        "SenhaPessoa"               as senha,');
         SQL.Add('        "VerificaDebitosPessoa"     as verificadebitos,');
         SQL.Add('        "NomeConjugePessoa"         as nomeconjuge,');
         SQL.Add('        "NomeEmpresaConjugePessoa"  as nomeempresaconjuge,');
         SQL.Add('        "CodigoAtividadeConjugePessoa" as idatividadeconjuge,');
         SQL.Add('        cast((select "NomeAtividade" from "Atividade" where "CodigoInternoAtividade" = "PessoaGeral"."CodigoAtividadeConjugePessoa") as varchar) as xatividadeconjuge,');
         SQL.Add('        "DataNascimentoConjugePessoa"  as datanascimentoconjuge,');
         SQL.Add('        "SalarioConjugePessoa"         as salarioconjuge,');
         SQL.Add('        "NomeDiretor1Pessoa"           as nomediretor1empresa,');
         SQL.Add('        "NomeDiretor2Pessoa"           as nomediretor2empresa,');
         SQL.Add('        "DataFundacaoEmpresaPessoa"    as datafundacaoempresa,');
         SQL.Add('        "ReferenciaComercial1Pessoa"   as referenciacomercial1,');
         SQL.Add('        "ReferenciaComercial2Pessoa"   as referenciacomercial2,');
         SQL.Add('        "NaturalidadePessoa"           as idnaturalidade,');
         SQL.Add('        cast("naturalidade"."NomeLocalidade" as varchar) as xnaturalidade,');
         SQL.Add('        cast(("naturalidade"."NomeLocalidade"||'' - ''||"naturalidade"."EstadoLocalidade") as varchar) as xnomenaturalidade,');
         SQL.Add('        "LimiteCreditoPessoa"          as limitecredito,');
         SQL.Add('        "DigitoBancoPessoa"            as digitobanco,');
         SQL.Add('        "EhSupervisorPessoa"           as ehsupervisor,');
         SQL.Add('        "EhUsuarioPessoa"              as ehusuario,');
         SQL.Add('        "EhOperadorPessoa"             as ehoperador,');
         SQL.Add('        "AgenciaBancoPessoa"           as agenciabanco,');
         SQL.Add('        "PercentualComissaoPessoa"     as perccomissao,');
         SQL.Add('        "PessoaGeral"."DataUltimaAlteracao"          as dataultimaalteracao,');
         SQL.Add('        "EhMedicoPessoa"               as ehmedico,');
         SQL.Add('        "AtivoPessoa"                  as ativo,');
         SQL.Add('        "CodigoTabelaPrecoPessoa"      as idtabelapreco,');
         SQL.Add('        cast((select "DescricaoTabela" from "TabelaPreco" where "CodigoInternoTabela" = "PessoaGeral"."CodigoTabelaPrecoPessoa") as varchar)  as xtabela,');
         SQL.Add('        "CodigoCondicaoPessoa"         as icondicao,');
         SQL.Add('        cast((select "DescricaoCondicao" from "CondicaoPagamento" where "CodigoInternoCondicao" = "PessoaGeral"."CodigoCondicaoPessoa") as varchar)  as xcondicao,');
         SQL.Add('        "EntregaEmailPessoa"           as email,');
         SQL.Add('        "EntregaCaixaPostalPessoa"     as caixapostal,');
         SQL.Add('        "CaminhoFotoPessoa"            as caminhofoto,');
         SQL.Add('        "CreditoPessoa"                as credito,');
         SQL.Add('        "NomeFantasiaPessoa"           as nomefantasia,');
         SQL.Add('        "PercentualDescontoPessoa"     as percdesconto,');
         SQL.Add('        "PrazoCondicaoPessoa"          as prazocondicao,');
         SQL.Add('        "EmiteEtiquetaPessoa"          as emiteetiqueta,');
         SQL.Add('        "MeuRelatorioConfiguravelPessoa" as meurelatorioconfiguravel,');
         SQL.Add('        "EhOftalmoPessoa"              as ehoftalmo,');
         SQL.Add('        "PerfilPermissaoPessoa"        as idperfilpermissao,');
         SQL.Add('        "DataPermissaoInicialPessoa"   as datainicialpermissao,');
         SQL.Add('        "DataPermissaoFinalPessoa"     as datafinalpermissao,');
         SQL.Add('        "EhSuperUsuarioPessoa"         as ehsuperusuario,');
         SQL.Add('        "SenhaSuperUsuarioPessoa"      as senhasuperusuario,');
         SQL.Add('        "EhRepresentanteSupervisorPessoa" as ehrepresentantesupervisor,');
         SQL.Add('        "DataIngressoFidelidadePessoa"    as dataingressofidelidade,');
         SQL.Add('        "PreCadastroPessoa"               as ehprecadastro,');
         SQL.Add('        "ObservacaoDiversaPessoa"         as observacaodiversa,');
         SQL.Add('        "HostEmailPessoa"                 as hostemail,');
         SQL.Add('        "PortaHostPessoa"                 as portahostemail,');
         SQL.Add('        "SenhaHostPessoa"                 as senhahostemail,');
         SQL.Add('        "NomeRemetenteEmailPessoa"        as nomeremetenteemail,');
         SQL.Add('        "MensagemFinalEmailPessoa"        as mensagemfinalemail,');
         SQL.Add('        "RequerAutenticacaoEmailPessoa"   as requerautenticacaoemail,');
         SQL.Add('        "ConfirmacaoLeituraEmailPessoa"   as confirmacaoleituraemail,');
         SQL.Add('        "CopiaEmailRemetentePessoa"       as copiarementeemail,');
         SQL.Add('        "PrioridadeEmailPessoa"           as prioridadeemail,');
         SQL.Add('        "GerarRemessaPessoa"              as geraremessa,');
         SQL.Add('        "CodigoEmpresaFuncionarioPessoa"  as idempresafuncionario,');
         SQL.Add('        "InscricaoSuframaPessoa"          as suframa,');
         SQL.Add('        "CobrancaEnderecoPessoa"          as enderecocobranca,');
         SQL.Add('        "CobrancaComplementoPessoa"       as complementocobranca,');
         SQL.Add('        "CobrancaBairroPessoa"            as bairrocobranca,');
         SQL.Add('        "CobrancaCodigoCidadePessoa"      as idlocalidadecobranca,');
         SQL.Add('        cast("localidade2"."NomeLocalidade" as varchar) as xlocalidadecobranca,');
         SQL.Add('        cast(("localidade2"."NomeLocalidade"||'' - ''||"localidade2"."EstadoLocalidade") as varchar) as xnomelocalidadecobranca,');
         SQL.Add('        "CobrancaCepPessoa"               as cepcobranca,');
         SQL.Add('        "CobrancaTelefonePessoa"          as telefonecobranca,');
         SQL.Add('        "TemplateBiometricoPessoa"        as templatebiometrico,');
         SQL.Add('        "ContaDebitoPessoa"               as idcontadebito,');
         SQL.Add('        "ContaCreditoPessoa"              as idcontacredito,');
         SQL.Add('        "HabilitarCalculoRetencaoParcelasPessoa" as habilitarcalculoretencao,');
         SQL.Add('        "InscricaoMunicipalPessoa"        as inscricaomunicipal,');
         SQL.Add('        "PossuiConfiguracaoIniPessoa"     as possuiconfiguracaoini,');
         SQL.Add('        "ValorFaturarPessoa"              as valorfaturar,');
         SQL.Add('        "SitePessoa"                      as site,');
         SQL.Add('        "NaoGerarRemessaPessoa"           as naogeraremessa,');
         SQL.Add('        "EhRepresentanteMobilePessoa"     as ehrepresentantemobile,');
         SQL.Add('        "DataEnvioPessoa"                 as dataenvio,');
         SQL.Add('        "IdentificadorIEPessoa"           as identificadorinscricaoestadual,');
         SQL.Add('        "AceitaDevolucaoPessoa"           as aceitadevolucao,');
         SQL.Add('        "UseTlsExplicitEmailPessoa"       as tlsexplicitoemail,');
         SQL.Add('        "InscricaoEstadualSubstitutoPessoa" as inscricaoestadualsubstituto,');
         SQL.Add('        "CobrancaEmailPessoa"             as emailcobranca,');
         SQL.Add('        "EhClienteRevenda"                as ehclienterevenda,');
         SQL.Add('        "ParticipanteREIDIPessoa"         as participantereidi,');
         SQL.Add('        "AceitaFracionarBancarioPessoa"   as aceitafracionarbancario,');
         SQL.Add('        "AceitaTransferenciaBancarioPessoa" as aceitatransferenciabancario ');
         SQL.Add('from "PessoaGeral" left join "Localidade" on "PessoaGeral"."EntregaCodigoCidadePessoa" = "Localidade"."CodigoInternoLocalidade" ');
         SQL.Add('                   left join "Localidade" as "localidade2" on "PessoaGeral"."CobrancaCodigoCidadePessoa" = "localidade2"."CodigoInternoLocalidade" ');
         SQL.Add('                   left join "Localidade"  as "naturalidade" on "PessoaGeral"."NaturalidadePessoa" = "naturalidade"."CodigoInternoLocalidade" ');
         SQL.Add('where "CodigoEmpresaPessoa"=:xempresa ');
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomePessoa") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
            end;
         if XQuery.ContainsKey('codigo') then // filtro por codigo
            begin
              SQL.Add('and cast("CodigoPessoa" as varchar) like :xcodigo ');
              ParamByName('xcodigo').AsString := XQuery.Items['codigo']+'%';
            end;
         if XQuery.ContainsKey('cpf') then // filtro por cpf
            begin
              SQL.Add('and "CicPessoa" like :xcpf ');
              ParamByName('xcpf').AsString := XQuery.Items['cpf']+'%';
            end;
         if XQuery.ContainsKey('cnpj') then // filtro por cnpj
            begin
              SQL.Add('and "CgcPessoa" like :xcnpj ');
              ParamByName('xcnpj').AsString := XQuery.Items['cnpj']+'%';
            end;
         if XQuery.ContainsKey('rg') then // filtro por rg
            begin
              SQL.Add('and "IdentidadePessoa" like :xrg ');
              ParamByName('xrg').AsString := XQuery.Items['rg']+'%';
            end;
         if XQuery.ContainsKey('inscricaoestadual') then // filtro por ie
            begin
              SQL.Add('and "InscricaoEstadualPessoa" like :xinscricaoestadual ');
              ParamByName('xinscricaoestadual').AsString := XQuery.Items['inscricaoestadual']+'%';
            end;
         if XQuery.ContainsKey('ativo') then // filtro por ativo
            begin
              SQL.Add('and "AtivoPessoa" =:xativo ');
              ParamByName('xativo').AsBoolean := strtobooldef(XQuery.Items['ativo'],false);
            end;
         if XQuery.ContainsKey('ehbanco') then // filtro por banco
            begin
              SQL.Add('and "EhBancoPessoa" =:xehbanco ');
              ParamByName('xehbanco').AsBoolean := strtobooldef(XQuery.Items['ehbanco'],false);
            end;
         if XQuery.ContainsKey('ehcliente') then // filtro por cliente
            begin
              SQL.Add('and "EhClientePessoa" =:xehcliente ');
              ParamByName('xehcliente').AsBoolean := strtobooldef(XQuery.Items['ehcliente'],false);
            end;
         if XQuery.ContainsKey('ehconvenio') then // filtro por convenio
            begin
              SQL.Add('and "EhConvenioPessoa" =:xehconvenio ');
              ParamByName('xehconvenio').AsBoolean := strtobooldef(XQuery.Items['ehconvenio'],false);
            end;
         if XQuery.ContainsKey('ehfornecedor') then // filtro por fornecedor
            begin
              SQL.Add('and "EhFornecedorPessoa" =:xehfornecedor ');
              ParamByName('xehfornecedor').AsBoolean := strtobooldef(XQuery.Items['ehfornecedor'],false);
            end;
         if XQuery.ContainsKey('ehfuncionario') then // filtro por funcionario
            begin
              SQL.Add('and "EhFuncionarioPessoa" =:xehfuncionario ');
              ParamByName('xehfuncionario').AsBoolean := strtobooldef(XQuery.Items['ehfuncionario'],false);
            end;
         if XQuery.ContainsKey('ehrepresentante') then // filtro por representante
            begin
              SQL.Add('and "EhRepresentantePessoa" =:xehrepresentante ');
              ParamByName('xehrepresentante').AsBoolean := strtobooldef(XQuery.Items['ehrepresentante'],false);
            end;
         if XQuery.ContainsKey('ehtranportador') then // filtro por transportador
            begin
              SQL.Add('and "EhTransportadoraPessoa" =:xehtransportador ');
              ParamByName('xehtransportador').AsBoolean := strtobooldef(XQuery.Items['ehtransportador'],false);
            end;
         if XQuery.ContainsKey('ehrepresentantemobile') then // filtro por representante mobile
            begin
              SQL.Add('and "EhRepresentanteMobilePessoa" =:xehrepresentantemobile ');
              ParamByName('xehrepresentantemobile').AsBoolean := strtobooldef(XQuery.Items['ehrepresentantemobile'],false);
            end;
         if XQuery.ContainsKey('ehoftalmo') then // filtro por oftalmo
            begin
              SQL.Add('and "EhOftalmologitaPessoa" =:xehoftalmo ');
              ParamByName('xehoftalmo').AsBoolean := strtobooldef(XQuery.Items['ehoftalmo'],false);
            end;
         if XQuery.ContainsKey('ehmedico') then // filtro por medico
            begin
              SQL.Add('and "EhMedicoPessoa" =:xehmedico ');
              ParamByName('xehmedico').AsBoolean := strtobooldef(XQuery.Items['ehmedico'],false);
            end;
         if XQuery.ContainsKey('xdocumento1') then // filtro por documento1
            begin
              SQL.Add('and (case when "EhPessoaFisica" then "CicPessoa" else "CgcPessoa" end) like :xdocumento1 ');
              ParamByName('xdocumento1').AsString := XQuery.Items['xdocumento1']+'%';
            end;
         if XQuery.ContainsKey('xdocumento2') then // filtro por documento2
            begin
              SQL.Add('and (case when "EhPessoaFisica" then "IdentidadePessoa" else "InscricaoEstadualPessoa" end) like :xdocumento2 ');
              ParamByName('xdocumento2').AsString := XQuery.Items['xdocumento2']+'%';
            end;
         if XQuery.ContainsKey('xnomelocalidade') then // filtro por nome localidade
            begin
              SQL.Add('and lower("Localidade"."NomeLocalidade") like lower(:xnomelocalidade) ');
              ParamByName('xnomelocalidade').AsString := XQuery.Items['xnomelocalidade']+'%';
            end;
         if XQuery.ContainsKey('order') then // ordenação
            begin
              if XQuery.Items['order']='codigo' then
                 wordem := 'order by "CodigoPessoa" '
              else if XQuery.Items['order']='nome' then
                 wordem := 'order by lower("NomePessoa") '
              else if XQuery.Items['order']='cpf' then
                 wordem := 'order by "CicPessoa" '
              else if XQuery.Items['order']='cnpj' then
                 wordem := 'order by "CgcPessoa" '
              else if XQuery.Items['order']='rg' then
                 wordem := 'order by "IdentidadePessoa" '
              else if XQuery.Items['order']='inscricaoestadual' then
                 wordem := 'order by "InscricaoEstadualPessoa" '
              else if XQuery.Items['order']='ativo' then
                 wordem := 'order by "AtivoPessoa" '
              else if XQuery.Items['order']='xdocumento1' then
                 wordem := 'order by "CicPessoa" '+XQuery.Items['dir']+',"CgcPessoa" '
              else if XQuery.Items['order']='xdocumento2' then
                 wordem := 'order by "IdentidadePessoa"' +XQuery.Items['dir']+',"InscricaoEstadualPessoa" '
              else if XQuery.Items['order']='xnomelocalidade' then
                 wordem := 'order by "Localidade"."NomeLocalidade" ';
              if XQuery.ContainsKey('dir') then // direção
                 wordem := wordem +XQuery.Items['dir'];
              SQL.Add(wordem);
            end
         else
            SQL.Add('order by lower("NomePessoa") ');
         if XLimit>0 then
            SQL.Add('Limit '+inttostr(XLimit)+' offset '+inttostr(XOffset));
         ParambyName('xempresa').asInteger := wconexao.FIdEmpresaPessoa;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Pessoa encontrada');
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret := TJSONArray.Create;
         wret.AddElement(wobj);
       end;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wobj := TJSONObject.Create;
      wobj.AddPair('status','500');
      wobj.AddPair('description',E.Message);
      wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      wret := TJSONArray.Create;
      wret.AddElement(wobj);
//      messagedlg('Problema ao retorna listas de Atividades'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

function IncluiPessoa(XPessoa: TJSONObject): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
    wval: string;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryInsert := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Insert into "PessoaGeral" ("CodigoEmpresaPessoa","CodigoPessoa","NomePessoa","EhPessoaFisica","CodigoAtividadePessoa","CodigoContabilPessoa",');
           SQL.Add('"ContaCorrentePessoa","CodigoCobrancaPessoa","CodigoRepresentantePessoa","CodigoBancoPessoa","ObservacaoPessoa","EhClientePessoa",');
           SQL.Add('"EhFornecedorPessoa","EhEmpresaPessoa","EhBancoPessoa","EhRepresentantePessoa","EhTransportadoraPessoa","EhConvenioPessoa","EhFuncionarioPessoa",');
           SQL.Add('"ContatoPessoa","DataCadastramentoPessoa","EntregaEnderecoPessoa","EntregaComplementoPessoa","EntregaBairroPessoa","EntregaCodigoCidadePessoa",');
           SQL.Add('"EntregaCepPessoa","EntregaTelefonePessoa","EntregaFaxPessoa","CodigoAlvoPessoa","InscricaoEstadualPessoa","CgcPessoa","IdentidadePessoa","CicPessoa",');
           SQL.Add('"SexoPessoa","DataNascimentoPessoa","EstadoCivilPessoa","NomePaiPessoa","NomeMaePessoa","NomeEmpresaPessoa","CodigoCargoPessoa","EnderecoTrabalhoPessoa",');
           SQL.Add('"BairroTrabalhoPessoa","CEPTrabalhoPessoa","TelefoneTrabalhoPessoa","SalarioPessoa","SenhaPessoa","VerificaDebitosPessoa","NomeConjugePessoa",');
           SQL.Add('"NomeEmpresaConjugePessoa","CodigoAtividadeConjugePessoa","DataNascimentoConjugePessoa","SalarioConjugePessoa","NomeDiretor1Pessoa","NomeDiretor2Pessoa",');
           SQL.Add('"DataFundacaoEmpresaPessoa","ReferenciaComercial1Pessoa","ReferenciaComercial2Pessoa","NaturalidadePessoa","LimiteCreditoPessoa","DigitoBancoPessoa",');
           SQL.Add('"EhSupervisorPessoa","EhUsuarioPessoa","EhOperadorPessoa","AgenciaBancoPessoa","PercentualComissaoPessoa","DataUltimaAlteracao","EhMedicoPessoa",');
           SQL.Add('"AtivoPessoa","CodigoTabelaPrecoPessoa","CodigoCondicaoPessoa","EntregaEmailPessoa","EntregaCaixaPostalPessoa","CaminhoFotoPessoa","CreditoPessoa",');
           SQL.Add('"NomeFantasiaPessoa","PercentualDescontoPessoa","PrazoCondicaoPessoa","EmiteEtiquetaPessoa","MeuRelatorioConfiguravelPessoa","EhOftalmoPessoa","PerfilPermissaoPessoa",');
           SQL.Add('"DataPermissaoInicialPessoa","DataPermissaoFinalPessoa","EhSuperUsuarioPessoa","SenhaSuperUsuarioPessoa","EhRepresentanteSupervisorPessoa","DataIngressoFidelidadePessoa",');
           SQL.Add('"PreCadastroPessoa","ObservacaoDiversaPessoa","HostEmailPessoa","PortaHostPessoa","SenhaHostPessoa","NomeRemetenteEmailPessoa","MensagemFinalEmailPessoa",');
           SQL.Add('"RequerAutenticacaoEmailPessoa","ConfirmacaoLeituraEmailPessoa","CopiaEmailRemetentePessoa","PrioridadeEmailPessoa","GerarRemessaPessoa","CodigoEmpresaFuncionarioPessoa",');
           SQL.Add('"InscricaoSuframaPessoa","CobrancaEnderecoPessoa","CobrancaComplementoPessoa","CobrancaBairroPessoa","CobrancaCodigoCidadePessoa","CobrancaCepPessoa",');
           SQL.Add('"CobrancaTelefonePessoa","TemplateBiometricoPessoa","ContaDebitoPessoa","ContaCreditoPessoa","HabilitarCalculoRetencaoParcelasPessoa","InscricaoMunicipalPessoa",');
           SQL.Add('"PossuiConfiguracaoIniPessoa","ValorFaturarPessoa","SitePessoa","NaoGerarRemessaPessoa","EhRepresentanteMobilePessoa","DataEnvioPessoa","IdentificadorIEPessoa",');
           SQL.Add('"AceitaDevolucaoPessoa","UseTlsExplicitEmailPessoa","InscricaoEstadualSubstitutoPessoa","CobrancaEmailPessoa","EhClienteRevenda","ParticipanteREIDIPessoa",');
           SQL.Add('"AceitaFracionarBancarioPessoa","AceitaTransferenciaBancarioPessoa") ');
           SQL.Add('values (:xidempresa,:xcodigo,:xnome,:xehfisica,:xidatividade,:xidcontabil,');
           SQL.Add(':xctacorrente,(case when :xidcobranca>0 then :xidcobranca else null end),(case when :xidrepresentante>0 then :xidrepresentante else null end),(case when :xidbanco>0 then :xidbanco else null end),');
           SQL.Add('(case when :xobservacao=''null'' then null else :xobservacao end),:xehcliente,');
           SQL.Add(':xehfornecedor,:xehempresa,:xehbanco,:xehrepresentante,:xehtransportador,:xehconvenio,:xehfuncionario,');
           SQL.Add('(case when :xcontato=''null'' then null else :xcontato end),:xdatacadastramento,(case when :xendereco=''null'' then null else :xendereco end),(case when :xcomplemento=''null'' then null else :xcomplemento end),');
           SQL.Add('(case when :xbairro=''null'' then null else :xbairro end),:xidlocalidade,');
           SQL.Add('(case when :xcep=''null'' then null else :xcep end),(case when :xtelefone=''null'' then null else :xtelefone end),(case when :xfax=''null'' then null else :xfax end),(case when :xidalvo>0 then :xidalvo else null end),');
           SQL.Add('(case when :xinscricaoestadual=''null'' then null else :xinscricaoestadual end),(case when :xcnpj=''null'' then null else :xcnpj end),');
           SQL.Add('(case when :xrg=''null'' then null else :xrg end),(case when :xcpf=''null'' then null else :xcpf end),');
           SQL.Add('(case when :xsexo=''null'' then null else :xsexo end),:xdatanascimento,(case when :xestadocivil=''null'' then null else :xestadocivil end),');
           SQL.Add('(case when :xnomepai=''null'' then null else :xnomepai end),(case when :xnomemae=''null'' then null else :xnomemae end) ,(case when :xnomeempresa=''null'' then null else :xnomeempresa end),');
           SQL.Add('(case when :xcodcargo>0 then :xcodcargo else null end),(case when :xenderecotrabalho=''null'' then null else :xenderecotrabalho end),');
           SQL.Add('(case when :xbairrotrabalho=''null'' then null else :xbairrotrabalho end),(case when :xceptrabalho=''null'' then null else :xceptrabalho end),(case when :xtelefonetrabalho=''null'' then null else :xtelefonetrabalho end),');
           SQL.Add(':xsalario,(case when :xsenha=''null'' then null else :xsenha end),:xverificadebitos,(case when :xnomeconjuge=''null'' then null else :xnomeconjuge end),');
           SQL.Add('(case when :xnomeempresaconjuge=''null'' then null else :xnomeempresaconjuge end),(case when :xidatividadeconjuge>0 then :xidatividadeconjuge else  null end),:xdatanascimentoconjuge,:xsalarioconjuge,');
           SQL.Add('(case when :xnomediretor1empresa=''null'' then null else :xnomediretor1empresa end),(case when :xnomediretor2empresa=''null'' then null else :xnomediretor2empresa end),');
           SQL.Add(':xdatafundacaoempresa,(case when :xreferenciacomercial1=''null'' then null else :xreferenciacomercial1 end),(case when :xreferenciacomercial2=''null'' then null else :xreferenciacomercial2 end),');
           SQL.Add('(case when :xidnaturalidade>0 then :xidnaturalidade else null end),:xlimitecredito,(case when :xdigitobanco=''null'' then null else :xdigitobanco end),');
           SQL.Add(':xehsupervisor,:xehusuario,:xehoperador,:xagenciabanco,:xperccomissao,:xdataultimaalteracao,:xehmedico, ');

           SQL.Add(':xativo,(case when :xidtabelapreco>0 then :xidtabelapreco else null end),(case when :xidcondicao>0 then :xidcondicao else null end),(case when :xemail=''null'' then null else :xemail end),(case when :xcaixapostal=''null'' then null else :xcaixapostal end),');
           SQL.Add('(case when :xcaminhofoto=''null'' then null else :xcaminhofoto end),:xcredito,');
           SQL.Add('(case when :xnomefantasia=''null'' then null else :xnomefantasia end),:xpercdesconto,:xprazocondicao,:xemiteetiqueta,(case when :xmeurelatorioconfiguravel=''null'' then null else :xmeurelatorioconfiguravel end),:xehoftalmo,');
           SQL.Add('(case when :xidperfilpermissao>0 then :xidperfilpermissao else null end),');
           SQL.Add(':xdatainicialpermissao,:xdatafinalpermissao,:xehsuperusuario,:xsenhasuperusuario,:xehrepresentantesupervisor,:xdataingressofidelidade,');
           SQL.Add(':xehprecadastro,(case when :xobservacaodiversa=''null'' then null else :xobservacaodiversa end),(case when :xhostemail=''null'' then null else :xhostemail end),:xportahostemail,(case when :xsenhahostemail=''null'' then null else :xsenhahostemail end),');
           SQL.Add('(case when :xnomeremetenteemail=''null'' then null else :xnomeremetenteemail end),(case when :xmensagemfinalemail=''null'' then null else :xmensagemfinalemail end),');
           SQL.Add(':xrequerautenticacaoemail,:xconfirmacaoleituraemail,:xcopiaremetenteemail,:xprioridadeemail,:xgeraremessa,(case when :xidempresafuncionario>0 then :xidempresafuncionario else null end),');
           SQL.Add('(case when :xsuframa=''null'' then null else :xsuframa end),(case when :xenderecocobranca=''null'' then null else :xenderecocobranca end),(case when :xcomplementocobranca=''null'' then null else :xcomplementocobranca end),');
           SQL.Add('(case when :xbairrocobranca=''null'' then null else :xbairrocobranca end),(case when :xidlocalidadecobranca>0 then :xidlocalidadecobranca else null end),(case when :xcepcobranca=''null'' then null else :xcepcobranca end),');
           SQL.Add('(case when :xtelefonecobranca=''null'' then null else :xtelefonecobranca end),(case when :xtemplatebiometrico=''null'' then null else :xtemplatebiometrico end),(case when :xidcontadebito>0 then :xidcontadebito else null end),');
           SQL.Add('(case when :xidcontacredito>0 then :xidcontacredito else null end),:xhabilitarcalculoretencao,(case when :xinscricaomunicipal=''null'' then null else :xinscricaomunicipal end),');
           SQL.Add(':xpossuiconfiguracaoini,:xvalorfaturar,(case when :xsite=''null'' then null else :xsite end),:xnaogeraremessa,:xehrepresentantemobile,:xdataenvio,(case when :xidentificadorinscricaoestadual=''null'' then null else :xidentificadorinscricaoestadual end),');
           SQL.Add(':xaceitadevolucao,:xtlsexplicitoemail,(case when :xinscricaoestadualsubstituto=''null'' then null else :xinscricaoestadualsubstituto end),(case when :xemailcobranca=''null'' then null else :xemailcobranca end),:xehclienterevenda,:xparticipantereidi,');
           SQL.Add(':xaceitafracionarbancario,:xaceitatransferenciabancario) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaPessoa;
           if XPessoa.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsInteger := strtointdef(XPessoa.GetValue('codigo').Value,0)
           else
              ParamByName('xcodigo').AsInteger := 0;
           if XPessoa.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString := XPessoa.GetValue('nome').Value
           else
              ParamByName('xnome').AsString := '';
           if XPessoa.TryGetValue('ehfisica',wval) then
              ParamByName('xehfisica').AsBoolean := strtobooldef(XPessoa.GetValue('ehfisica').Value,false)
           else
              ParamByName('xehfisica').AsBoolean := false;
           if XPessoa.TryGetValue('idatividade',wval) then
              ParamByName('xidatividade').AsInteger := strtointdef(XPessoa.GetValue('idatividade').Value,0)
           else
              ParamByName('xidatividade').AsInteger := 0;
           if XPessoa.TryGetValue('idcontabil',wval) then
              ParamByName('xidcontabil').AsInteger := strtointdef(XPessoa.GetValue('idcontabil').Value,0)
           else
              ParamByName('xidcontabil').AsInteger := 0;
           if XPessoa.TryGetValue('ctacorrente',wval) then
              ParamByName('xctacorrente').AsString := XPessoa.GetValue('ctacorrente').Value
           else
              ParamByName('xctacorrente').AsString := '';
           if XPessoa.TryGetValue('idcobranca',wval) then
              ParamByName('xidcobranca').AsInteger := strtointdef(XPessoa.GetValue('idcobranca').Value,0)
           else
              ParamByName('xidcobranca').AsInteger := 0;
           if XPessoa.TryGetValue('idrepresentante',wval) then
              ParamByName('xidrepresentante').AsInteger := strtointdef(XPessoa.GetValue('idrepresentante').Value,0)
           else
              ParamByName('xidrepresentante').AsInteger := 0;
           if XPessoa.TryGetValue('idbanco',wval) then
              ParamByName('xidbanco').AsInteger := strtointdef(XPessoa.GetValue('idbanco').Value,0)
           else
              ParamByName('xidbanco').AsInteger := 0;
           if XPessoa.TryGetValue('observacao',wval) then
              ParamByName('xobservacao').AsString := XPessoa.GetValue('observacao').Value
           else
              ParamByName('xobservacao').AsString := '';
           if XPessoa.TryGetValue('ehcliente',wval) then
              ParamByName('xehcliente').AsBoolean := strtobooldef(XPessoa.GetValue('ehcliente').Value,false)
           else
              ParamByName('xehcliente').AsBoolean := false;
           if XPessoa.TryGetValue('ehfornecedor',wval) then
              ParamByName('xehfornecedor').AsBoolean := strtobooldef(XPessoa.GetValue('ehfornecedor').Value,false)
           else
              ParamByName('xehfornecedor').AsBoolean := false;
           if XPessoa.TryGetValue('ehempresa',wval) then
              ParamByName('xehempresa').AsBoolean := strtobooldef(XPessoa.GetValue('ehempresa').Value,false)
           else
              ParamByName('xehempresa').AsBoolean := false;
           if XPessoa.TryGetValue('ehbanco',wval) then
              ParamByName('xehbanco').AsBoolean := strtobooldef(XPessoa.GetValue('ehbanco').Value,false)
           else
              ParamByName('xehbanco').AsBoolean := false;
           if XPessoa.TryGetValue('ehrepresentante',wval) then
              ParamByName('xehrepresentante').AsBoolean := strtobooldef(XPessoa.GetValue('ehrepresentante').Value,false)
           else
              ParamByName('xehrepresentante').AsBoolean := false;
           if XPessoa.TryGetValue('ehtransportador',wval) then
              ParamByName('xehtransportador').AsBoolean := strtobooldef(XPessoa.GetValue('ehtransportador').Value,false)
           else
              ParamByName('xehtransportador').AsBoolean := false;
           if XPessoa.TryGetValue('ehconvenio',wval) then
              ParamByName('xehconvenio').AsBoolean := strtobooldef(XPessoa.GetValue('ehconvenio').Value,false)
           else
              ParamByName('xehconvenio').AsBoolean := false;
           if XPessoa.TryGetValue('ehfuncionario',wval) then
              ParamByName('xehfuncionario').AsBoolean := strtobooldef(XPessoa.GetValue('ehfuncionario').Value,false)
           else
              ParamByName('xehfuncionario').AsBoolean := false;
           if XPessoa.TryGetValue('contato',wval) then
              ParamByName('xcontato').AsString := XPessoa.GetValue('observacao').Value
           else
              ParamByName('xcontato').AsString := '';
           if XPessoa.TryGetValue('datacadastramento',wval) then
              ParamByName('xdatacadastramento').AsDate := strtodatedef(XPessoa.GetValue('datacadastramento').Value,date)
           else
              ParamByName('xdatacadastramento').AsDate := date;
           if XPessoa.TryGetValue('endereco',wval) then
              ParamByName('xendereco').AsString := XPessoa.GetValue('endereco').Value
           else
              ParamByName('xendereco').AsString := '';
           if XPessoa.TryGetValue('complemento',wval) then
              ParamByName('xcomplemento').AsString := XPessoa.GetValue('complemento').Value
           else
              ParamByName('xcomplemento').AsString := '';
           if XPessoa.TryGetValue('bairro',wval) then
              ParamByName('xbairro').AsString := XPessoa.GetValue('bairro').Value
           else
              ParamByName('xbairro').AsString := '';
           if XPessoa.TryGetValue('idlocalidade',wval) then
              ParamByName('xidlocalidade').AsInteger := strtointdef(XPessoa.GetValue('idlocalidade').Value,0)
           else
              ParamByName('xidlocalidade').AsInteger := 0;
           if XPessoa.TryGetValue('cep',wval) then
              ParamByName('xcep').AsString := XPessoa.GetValue('cep').Value
           else
              ParamByName('xcep').AsString := '';
           if XPessoa.TryGetValue('telefone',wval) then
              ParamByName('xtelefone').AsString := XPessoa.GetValue('telefone').Value
           else
              ParamByName('xtelefone').AsString := '';
           if XPessoa.TryGetValue('fax',wval) then
              ParamByName('xfax').AsString := XPessoa.GetValue('fax').Value
           else
              ParamByName('xfax').AsString := '';
           if XPessoa.TryGetValue('idalvo',wval) then
              ParamByName('xidalvo').AsInteger := strtointdef(XPessoa.GetValue('idalvo').Value,0)
           else
              ParamByName('xidalvo').AsInteger := 0;
           if XPessoa.TryGetValue('inscricaoestadual',wval) then
              ParamByName('xinscricaoestadual').AsString := XPessoa.GetValue('inscricaoestadual').Value
           else
              ParamByName('xinscricaoestadual').AsString := '';
           if XPessoa.TryGetValue('cnpj',wval) then
              ParamByName('xcnpj').AsString := XPessoa.GetValue('cnpj').Value
           else
              ParamByName('xcnpj').AsString := '';
           if XPessoa.TryGetValue('rg',wval) then
              ParamByName('xrg').AsString := XPessoa.GetValue('rg').Value
           else
              ParamByName('xrg').AsString := '';
           if XPessoa.TryGetValue('cpf',wval) then
              ParamByName('xcpf').AsString := XPessoa.GetValue('cpf').Value
           else
              ParamByName('xcpf').AsString := '';
           if XPessoa.TryGetValue('sexo',wval) then
              ParamByName('xsexo').AsString := XPessoa.GetValue('sexo').Value
           else
              ParamByName('xsexo').AsString := '';
           if XPessoa.TryGetValue('datanascimento',wval) then
              ParamByName('xdatanascimento').AsDate := strtodatedef(XPessoa.GetValue('datanascimento').Value,0)
           else
              ParamByName('xdatanascimento').AsDate := 0;
           if XPessoa.TryGetValue('estadocivil',wval) then
              ParamByName('xestadocivil').AsString := XPessoa.GetValue('estadocivil').Value
           else
              ParamByName('xestadocivil').AsString := '';
           if XPessoa.TryGetValue('nomepai',wval) then
              ParamByName('xnomepai').AsString := XPessoa.GetValue('nomepai').Value
           else
              ParamByName('xnomepai').AsString := '';
           if XPessoa.TryGetValue('nomemae',wval) then
              ParamByName('xnomemae').AsString := XPessoa.GetValue('nomemae').Value
           else
              ParamByName('xnomemae').AsString := '';
           if XPessoa.TryGetValue('nomeempresa',wval) then
              ParamByName('xnomeempresa').AsString := XPessoa.GetValue('nomeempresa').Value
           else
              ParamByName('xnomeempresa').AsString := '';
           if XPessoa.TryGetValue('codcargo',wval) then
              ParamByName('xcodcargo').AsInteger := strtointdef(XPessoa.GetValue('codcargo').Value,0)
           else
              ParamByName('xcodcargo').AsInteger := 0;
           if XPessoa.TryGetValue('enderecotrabalho',wval) then
              ParamByName('xenderecotrabalho').AsString := XPessoa.GetValue('enderecotrabalho').Value
           else
              ParamByName('xenderecotrabalho').AsString := '';
           if XPessoa.TryGetValue('bairrotrabalho',wval) then
              ParamByName('xbairrotrabalho').AsString := XPessoa.GetValue('bairrotrabalho').Value
           else
              ParamByName('xbairrotrabalho').AsString := '';
           if XPessoa.TryGetValue('ceptrabalho',wval) then
              ParamByName('xceptrabalho').AsString := XPessoa.GetValue('ceptrabalho').Value
           else
              ParamByName('xceptrabalho').AsString := '';
           if XPessoa.TryGetValue('telefonetrabalho',wval) then
              ParamByName('xtelefonetrabalho').AsString := XPessoa.GetValue('telefonetrabalho').Value
           else
              ParamByName('xtelefonetrabalho').AsString := '';
           if XPessoa.TryGetValue('salario',wval) then
              ParamByName('xsalario').AsFloat := strtofloatdef(XPessoa.GetValue('salario').Value,0)
           else
              ParamByName('xsalario').AsFloat := 0;
           if XPessoa.TryGetValue('senha',wval) then
              ParamByName('xsenha').AsString := XPessoa.GetValue('senha').Value
           else
              ParamByName('xsenha').AsString := '';
           if XPessoa.TryGetValue('verificadebitos',wval) then
              ParamByName('xverificadebitos').AsBoolean := strtobooldef(XPessoa.GetValue('verificadebitos').Value,false)
           else
              ParamByName('xverificadebitos').AsBoolean := false;
           if XPessoa.TryGetValue('nomeconjuge',wval) then
              ParamByName('xnomeconjuge').AsString := XPessoa.GetValue('nomeconjuge').Value
           else
              ParamByName('xnomeconjuge').AsString := '';
           if XPessoa.TryGetValue('nomeempresaconjuge',wval) then
              ParamByName('xnomeempresaconjuge').AsString := XPessoa.GetValue('nomeempresaconjuge').Value
           else
              ParamByName('xnomeempresaconjuge').AsString := '';
           if XPessoa.TryGetValue('idatividadeconjuge',wval) then
              ParamByName('xidatividadeconjuge').AsInteger := strtointdef(XPessoa.GetValue('idatividadeconjuge').Value,0)
           else
              ParamByName('xidatividadeconjuge').AsInteger := 0;
           if XPessoa.TryGetValue('datanascimentoconjuge',wval) then
              ParamByName('xdatanascimentoconjuge').AsDate := strtodatedef(XPessoa.GetValue('datanascimentoconjuge').Value,0)
           else
              ParamByName('xdatanascimentoconjuge').AsDate := 0;
           if XPessoa.TryGetValue('salarioconjuge',wval) then
              ParamByName('xsalarioconjuge').AsFloat := strtofloatdef(XPessoa.GetValue('salarioconjuge').Value,0)
           else
              ParamByName('xsalarioconjuge').AsFloat := 0;
           if XPessoa.TryGetValue('nomediretor1empresa',wval) then
              ParamByName('xnomediretor1empresa').AsString := XPessoa.GetValue('nomediretor1empresa').Value
           else
              ParamByName('xnomediretor1empresa').AsString := '';
           if XPessoa.TryGetValue('nomediretor2empresa',wval) then
              ParamByName('xnomediretor2empresa').AsString := XPessoa.GetValue('nomediretor2empresa').Value
           else
              ParamByName('xnomediretor2empresa').AsString := '';
           if XPessoa.TryGetValue('datafundacaoempresa',wval) then
              ParamByName('xdatafundacaoempresa').AsDate := strtodatedef(XPessoa.GetValue('datafundacaoempresa').Value,0)
           else
              ParamByName('xdatafundacaoempresa').AsDate := 0;
           if XPessoa.TryGetValue('referenciacomercial1',wval) then
              ParamByName('xreferenciacomercial1').AsString := XPessoa.GetValue('referenciacomercial1').Value
           else
              ParamByName('xreferenciacomercial1').AsString := '';
           if XPessoa.TryGetValue('referenciacomercial2',wval) then
              ParamByName('xreferenciacomercial2').AsString := XPessoa.GetValue('referenciacomercial2').Value
           else
              ParamByName('xreferenciacomercial2').AsString := '';
           if XPessoa.TryGetValue('idnaturalidade',wval) then
              ParamByName('xidnaturalidade').AsInteger := strtointdef(XPessoa.GetValue('idnaturalidade').Value,0)
           else
              ParamByName('xidnaturalidade').AsInteger := 0;
           if XPessoa.TryGetValue('limitecredito',wval) then
              ParamByName('xlimitecredito').AsFloat := strtofloatdef(XPessoa.GetValue('limitecredito').Value,0)
           else
              ParamByName('xlimitecredito').AsFloat := 0;
           if XPessoa.TryGetValue('digitobanco',wval) then
              ParamByName('xdigitobanco').AsString := XPessoa.GetValue('digitobanco').Value
           else
              ParamByName('xdigitobanco').AsString := '';
           if XPessoa.TryGetValue('ehsupervisor',wval) then
              ParamByName('xehsupervisor').AsBoolean := strtobooldef(XPessoa.GetValue('ehsupervisor').Value,false)
           else
              ParamByName('xehsupervisor').AsBoolean := false;
           if XPessoa.TryGetValue('ehusuario',wval) then
              ParamByName('xehusuario').AsBoolean := strtobooldef(XPessoa.GetValue('ehusuario').Value,false)
           else
              ParamByName('xehusuario').AsBoolean := false;
           if XPessoa.TryGetValue('ehoperador',wval) then
              ParamByName('xehoperador').AsBoolean := strtobooldef(XPessoa.GetValue('ehoperador').Value,false)
           else
              ParamByName('xehoperador').AsBoolean := false;
           if XPessoa.TryGetValue('agenciabanco',wval) then
              ParamByName('xagenciabanco').AsString := XPessoa.GetValue('agenciabanco').Value
           else
              ParamByName('xagenciabanco').AsString := '';
           if XPessoa.TryGetValue('perccomissao',wval) then
              ParamByName('xperccomissao').AsFloat := strtofloatdef(XPessoa.GetValue('perccomissao').Value,0)
           else
              ParamByName('xperccomissao').AsFloat := 0;
           if XPessoa.TryGetValue('dataultimaalteracao',wval) then
              ParamByName('xdataultimaalteracao').AsDate := strtodatedef(XPessoa.GetValue('dataultimaalteracao').Value,date)
           else
              ParamByName('xdataultimaalteracao').AsDate := date;
           if XPessoa.TryGetValue('ehmedico',wval) then
              ParamByName('xehmedico').AsBoolean := strtobooldef(XPessoa.GetValue('ehmedico').Value,false)
           else
              ParamByName('xehmedico').AsBoolean := false;
           if XPessoa.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean := strtobooldef(XPessoa.GetValue('ativo').Value,false)
           else
              ParamByName('xativo').AsBoolean := false;
           if XPessoa.TryGetValue('idtabelapreco',wval) then
              ParamByName('xidtabelapreco').AsInteger := strtointdef(XPessoa.GetValue('idtabelapreco').Value,0)
           else
              ParamByName('xidtabelapreco').AsInteger := 0;
           if XPessoa.TryGetValue('idcondicao',wval) then
              ParamByName('xidcondicao').AsInteger := strtointdef(XPessoa.GetValue('idcondicao').Value,0)
           else
              ParamByName('xidcondicao').AsInteger := 0;
           if XPessoa.TryGetValue('email',wval) then
              ParamByName('xemail').AsString := XPessoa.GetValue('email').Value
           else
              ParamByName('xemail').AsString := '';
           if XPessoa.TryGetValue('caixapostal',wval) then
              ParamByName('xcaixapostal').AsString := XPessoa.GetValue('caixapostal').Value
           else
              ParamByName('xcaixapostal').AsString := '';
           if XPessoa.TryGetValue('caminhofoto',wval) then
              ParamByName('xcaminhofoto').AsString := XPessoa.GetValue('caminhofoto').Value
           else
              ParamByName('xcaminhofoto').AsString := '';
           if XPessoa.TryGetValue('credito',wval) then
              ParamByName('xcredito').AsFloat := strtofloatdef(XPessoa.GetValue('credito').Value,0)
           else
              ParamByName('xcredito').AsFloat := 0;
           if XPessoa.TryGetValue('nomefantasia',wval) then
              ParamByName('xnomefantasia').AsString := XPessoa.GetValue('nomefantasia').Value
           else
              ParamByName('xnomefantasia').AsString := '';
           if XPessoa.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat := strtofloatdef(XPessoa.GetValue('percdesconto').Value,0)
           else
              ParamByName('xpercdesconto').AsFloat := 0;
           if XPessoa.TryGetValue('prazocondicao',wval) then
              ParamByName('xprazocondicao').AsInteger := strtointdef(XPessoa.GetValue('prazocondicao').Value,0)
           else
              ParamByName('xprazocondicao').AsInteger := 0;
           if XPessoa.TryGetValue('emiteetiqueta',wval) then
              ParamByName('xemiteetiqueta').AsBoolean := strtobooldef(XPessoa.GetValue('emiteetiqueta').Value,false)
           else
              ParamByName('xemiteetiqueta').AsBoolean := false;
           if XPessoa.TryGetValue('meurelatorioconfiguravel',wval) then
              ParamByName('xmeurelatorioconfiguravel').AsString := XPessoa.GetValue('meurelatorioconfiguravel').Value
           else
              ParamByName('xmeurelatorioconfiguravel').AsString := '';
           if XPessoa.TryGetValue('ehoftalmo',wval) then
              ParamByName('xehoftalmo').AsBoolean := strtobooldef(XPessoa.GetValue('ehoftalmo').Value,false)
           else
              ParamByName('xehoftalmo').AsBoolean := false;
           if XPessoa.TryGetValue('idperfilpermissao',wval) then
              ParamByName('xidperfilpermissao').AsInteger := strtointdef(XPessoa.GetValue('idperfilpermissao').Value,0)
           else
              ParamByName('xidperfilpermissao').AsInteger := 0;
           if XPessoa.TryGetValue('datainicialpermissao',wval) then
              ParamByName('xdatainicialpermissao').AsDate := strtodatedef(XPessoa.GetValue('datainicialpermissao').Value,0)
           else
              ParamByName('xdatainicialpermissao').AsDate := 0;
           if XPessoa.TryGetValue('datafinalpermissao',wval) then
              ParamByName('xdatafinalpermissao').AsDate := strtodatedef(XPessoa.GetValue('datafinalpermissao').Value,0)
           else
              ParamByName('xdatafinalpermissao').AsDate := 0;
           if XPessoa.TryGetValue('ehsuperusuario',wval) then
              ParamByName('xehsuperusuario').AsBoolean := strtobooldef(XPessoa.GetValue('ehsuperusuario').Value,false)
           else
              ParamByName('xehsuperusuario').AsBoolean := false;
           if XPessoa.TryGetValue('senhasuperusuario',wval) then
              ParamByName('xsenhasuperusuario').AsString := XPessoa.GetValue('senhasuperusuario').Value
           else
              ParamByName('xsenhasuperusuario').AsString := '';
           if XPessoa.TryGetValue('ehrepresentantesupervisor',wval) then
              ParamByName('xehrepresentantesupervisor').AsBoolean := strtobooldef(XPessoa.GetValue('ehrepresentantesupervisor').Value,false)
           else
              ParamByName('xehrepresentantesupervisor').AsBoolean := false;
           if XPessoa.TryGetValue('dataingressofidelidade',wval) then
              ParamByName('xdataingressofidelidade').AsDate := strtodatedef(XPessoa.GetValue('dataingressofidelidade').Value,0)
           else
              ParamByName('xdataingressofidelidade').AsDate := 0;
           if XPessoa.TryGetValue('ehprecadastro',wval) then
              ParamByName('xehprecadastro').AsBoolean := strtobooldef(XPessoa.GetValue('ehprecadastro').Value,false)
           else
              ParamByName('xehprecadastro').AsBoolean := false;
           if XPessoa.TryGetValue('observacaodiversa',wval) then
              ParamByName('xobservacaodiversa').AsString := XPessoa.GetValue('observacaodiversa').Value
           else
              ParamByName('xobservacaodiversa').AsString := '';
           if XPessoa.TryGetValue('hostemail',wval) then
              ParamByName('xhostemail').AsString := XPessoa.GetValue('hostemail').Value
           else
              ParamByName('xhostemail').AsString := '';
           if XPessoa.TryGetValue('portahostemail',wval) then
              ParamByName('xportahostemail').AsInteger := strtointdef(XPessoa.GetValue('portahostemail').Value,0)
           else
              ParamByName('xportahostemail').AsInteger := 0;
           if XPessoa.TryGetValue('senhahostemail',wval) then
              ParamByName('xsenhahostemail').AsString := XPessoa.GetValue('senhahostemail').Value
           else
              ParamByName('xsenhahostemail').AsString := '';
           if XPessoa.TryGetValue('nomeremetenteemail',wval) then
              ParamByName('xnomeremetenteemail').AsString := XPessoa.GetValue('nomeremetenteemail').Value
           else
              ParamByName('xnomeremetenteemail').AsString := '';
           if XPessoa.TryGetValue('mensagemfinalemail',wval) then
              ParamByName('xmensagemfinalemail').AsString := XPessoa.GetValue('mensagemfinalemail').Value
           else
              ParamByName('xmensagemfinalemail').AsString := '';
           if XPessoa.TryGetValue('requerautenticacaoemail',wval) then
              ParamByName('xrequerautenticacaoemail').AsBoolean := strtobooldef(XPessoa.GetValue('requerautenticacaoemail').Value,false)
           else
              ParamByName('xrequerautenticacaoemail').AsBoolean := false;
           if XPessoa.TryGetValue('confirmacaoleituraemail',wval) then
              ParamByName('xconfirmacaoleituraemail').AsBoolean := strtobooldef(XPessoa.GetValue('confirmacaoleituraemail').Value,false)
           else
              ParamByName('xconfirmacaoleituraemail').AsBoolean := false;
           if XPessoa.TryGetValue('copiaremetenteemail',wval) then
              ParamByName('xcopiaremetenteemail').AsBoolean := strtobooldef(XPessoa.GetValue('copiaremetenteemail').Value,false)
           else
              ParamByName('xcopiaremetenteemail').AsBoolean := false;
           if XPessoa.TryGetValue('prioridadeemail',wval) then
              ParamByName('xprioridadeemail').AsString := XPessoa.GetValue('prioridadeemail').Value
           else
              ParamByName('xprioridadeemail').AsString := '';
           if XPessoa.TryGetValue('geraremessa',wval) then
              ParamByName('xgeraremessa').AsBoolean := strtobooldef(XPessoa.GetValue('geraremessa').Value,false)
           else
              ParamByName('xgeraremessa').AsBoolean := false;
           if XPessoa.TryGetValue('idempresafuncionario',wval) then
              ParamByName('xidempresafuncionario').AsInteger := strtointdef(XPessoa.GetValue('idempresafuncionario').Value,0)
           else
              ParamByName('xidempresafuncionario').AsInteger := 0;
           if XPessoa.TryGetValue('suframa',wval) then
              ParamByName('xsuframa').AsString := XPessoa.GetValue('suframa').Value
           else
              ParamByName('xsuframa').AsString := '';
           if XPessoa.TryGetValue('enderecocobranca',wval) then
              ParamByName('xenderecocobranca').AsString := XPessoa.GetValue('enderecocobranca').Value
           else
              ParamByName('xenderecocobranca').AsString := '';
           if XPessoa.TryGetValue('complementocobranca',wval) then
              ParamByName('xcomplementocobranca').AsString := XPessoa.GetValue('complementocobranca').Value
           else
              ParamByName('xcomplementocobranca').AsString := '';
           if XPessoa.TryGetValue('bairrocobranca',wval) then
              ParamByName('xbairrocobranca').AsString := XPessoa.GetValue('bairrocobranca').Value
           else
              ParamByName('xbairrocobranca').AsString := '';
           if XPessoa.TryGetValue('idlocalidadecobranca',wval) then
              ParamByName('xidlocalidadecobranca').AsInteger := strtointdef(XPessoa.GetValue('idlocalidadecobranca').Value,0)
           else
              ParamByName('xidlocalidadecobranca').AsInteger := 0;
           if XPessoa.TryGetValue('cepcobranca',wval) then
              ParamByName('xcepcobranca').AsString := XPessoa.GetValue('cepcobranca').Value
           else
              ParamByName('xcepcobranca').AsString := '';
           if XPessoa.TryGetValue('telefonecobranca',wval) then
              ParamByName('xtelefonecobranca').AsString := XPessoa.GetValue('telefonecobranca').Value
           else
              ParamByName('xtelefonecobranca').AsString := '';
           if XPessoa.TryGetValue('templatebiometrico',wval) then
              ParamByName('xtemplatebiometrico').AsString := XPessoa.GetValue('templatebiometrico').Value
           else
              ParamByName('xtemplatebiometrico').AsString := '';
           if XPessoa.TryGetValue('idcontadebito',wval) then
              ParamByName('xidcontadebito').AsInteger := strtointdef(XPessoa.GetValue('idcontadebito').Value,0)
           else
              ParamByName('xidcontadebito').AsInteger := 0;
           if XPessoa.TryGetValue('idcontacredito',wval) then
              ParamByName('xidcontacredito').AsInteger := strtointdef(XPessoa.GetValue('idcontacredito').Value,0)
           else
              ParamByName('xidcontacredito').AsInteger := 0;
           if XPessoa.TryGetValue('habilitarcalculoretencao',wval) then
              ParamByName('xhabilitarcalculoretencao').AsBoolean := strtobooldef(XPessoa.GetValue('habilitarcalculoretencao').Value,false)
           else
              ParamByName('xhabilitarcalculoretencao').AsBoolean := false;
           if XPessoa.TryGetValue('inscricaomunicipal',wval) then
              ParamByName('xinscricaomunicipal').AsString := XPessoa.GetValue('inscricaomunicipal').Value
           else
              ParamByName('xinscricaomunicipal').AsString := '';
           if XPessoa.TryGetValue('possuiconfiguracaoini',wval) then
              ParamByName('xpossuiconfiguracaoini').AsBoolean := strtobooldef(XPessoa.GetValue('possuiconfiguracaoini').Value,false)
           else
              ParamByName('xpossuiconfiguracaoini').AsBoolean := false;
           if XPessoa.TryGetValue('valorfaturar',wval) then
              ParamByName('xvalorfaturar').AsFloat := strtofloatdef(XPessoa.GetValue('valorfaturar').Value,0)
           else
              ParamByName('xvalorfaturar').AsFloat := 0;
           if XPessoa.TryGetValue('site',wval) then
              ParamByName('xsite').AsString := XPessoa.GetValue('site').Value
           else
              ParamByName('xsite').AsString := '';
           if XPessoa.TryGetValue('naogeraremessa',wval) then
              ParamByName('xnaogeraremessa').AsBoolean := strtobooldef(XPessoa.GetValue('naogeraremessa').Value,false)
           else
              ParamByName('xnaogeraremessa').AsBoolean := false;
           if XPessoa.TryGetValue('ehrepresentantemobile',wval) then
              ParamByName('xehrepresentantemobile').AsBoolean := strtobooldef(XPessoa.GetValue('ehrepresentantemobile').Value,false)
           else
              ParamByName('xehrepresentantemobile').AsBoolean := false;
           if XPessoa.TryGetValue('dataenvio',wval) then
              ParamByName('xdataenvio').AsDate := strtodatedef(XPessoa.GetValue('dataenvio').Value,0)
           else
              ParamByName('xdataenvio').AsDate := 0;
           if XPessoa.TryGetValue('identificadorinscricaoestadual',wval) then
              ParamByName('xidentificadorinscricaoestadual').AsString := XPessoa.GetValue('identificadorinscricaoestadual').Value
           else
              ParamByName('xidentificadorinscricaoestadual').AsString := '';
           if XPessoa.TryGetValue('aceitadevolucao',wval) then
              ParamByName('xaceitadevolucao').AsBoolean := strtobooldef(XPessoa.GetValue('aceitadevolucao').Value,false)
           else
              ParamByName('xaceitadevolucao').AsBoolean := false;
           if XPessoa.TryGetValue('tlsexplicitoemail',wval) then
              ParamByName('xtlsexplicitoemail').AsBoolean := strtobooldef(XPessoa.GetValue('tlsexplicitoemail').Value,false)
           else
              ParamByName('xtlsexplicitoemail').AsBoolean := false;
           if XPessoa.TryGetValue('inscricaoestadualsubstituto',wval) then
              ParamByName('xinscricaoestadualsubstituto').AsString := XPessoa.GetValue('inscricaoestadualsubstituto').Value
           else
              ParamByName('xinscricaoestadualsubstituto').AsString := '';
           if XPessoa.TryGetValue('emailcobranca',wval) then
              ParamByName('xemailcobranca').AsString := XPessoa.GetValue('emailcobranca').Value
           else
              ParamByName('xemailcobranca').AsString := '';
           if XPessoa.TryGetValue('ehclienterevenda',wval) then
              ParamByName('xehclienterevenda').AsBoolean := strtobooldef(XPessoa.GetValue('ehclienterevenda').Value,false)
           else
              ParamByName('xehclienterevenda').AsBoolean := false;
           if XPessoa.TryGetValue('participantereidi',wval) then
              ParamByName('xparticipantereidi').AsBoolean := strtobooldef(XPessoa.GetValue('participantereidi').Value,false)
           else
              ParamByName('xparticipantereidi').AsBoolean := false;
           if XPessoa.TryGetValue('aceitafracionarbancario',wval) then
              ParamByName('xaceitafracionarbancario').AsBoolean := strtobooldef(XPessoa.GetValue('aceitafracionarbancario').Value,false)
           else
              ParamByName('xaceitafracionarbancario').AsBoolean := false;
           if XPessoa.TryGetValue('aceitatransferenciabancario',wval) then
              ParamByName('xaceitatransferenciabancario').AsBoolean := strtobooldef(XPessoa.GetValue('aceitatransferenciabancario').Value,false)
           else
              ParamByName('xaceitatransferenciabancario').AsBoolean := false;
           ExecSQL;
           EnableControls;
           wnum := RowsAffected;
         end;

         if wnum>0 then
            begin
              wquerySelect := TFDQuery.Create(nil);
              with wquerySelect do
              begin
                Connection := wconexao.FDConnectionApi;
                DisableControls;
                Close;
                SQL.Clear;
                Params.Clear;
                SQL.Add('select  "CodigoInternoPessoa"       as id,');
                SQL.Add('        "CodigoPessoa"              as codigo,');
                SQL.Add('        "NomePessoa"                as nome,');
                SQL.Add('        "EhPessoaFisica"            as ehfisica,');
                SQL.Add('        "CodigoAtividadePessoa"     as idatividade,');
                SQL.Add('        "CodigoContabilPessoa"      as idcontabil,');
                SQL.Add('        "ContaCorrentePessoa"       as ctacorrente,');
                SQL.Add('        "CodigoCobrancaPessoa"      as idcobranca,');
                SQL.Add('        "CodigoRepresentantePessoa" as idrepresentante,');
                SQL.Add('        "CodigoBancoPessoa"         as idbanco,');
                SQL.Add('        "ObservacaoPessoa"          as observacao,');
                SQL.Add('        "EhClientePessoa"           as ehcliente,');
                SQL.Add('        "EhFornecedorPessoa"        as ehfornecedor,');
                SQL.Add('        "EhEmpresaPessoa"           as ehempresa,');
                SQL.Add('        "EhBancoPessoa"             as ehbanco,');
                SQL.Add('        "EhRepresentantePessoa"     as ehrepresentante,');
                SQL.Add('        "EhTransportadoraPessoa"    as ehtransportador,');
                SQL.Add('        "EhConvenioPessoa"          as ehconvenio,');
                SQL.Add('        "EhFuncionarioPessoa"       as ehfuncionario,');
                SQL.Add('        "ContatoPessoa"             as contato,');
                SQL.Add('        "DataCadastramentoPessoa"   as datacadastramento,');
                SQL.Add('        "EntregaEnderecoPessoa"     as endereco,');
                SQL.Add('        "EntregaComplementoPessoa"  as complemento,');
                SQL.Add('        "EntregaBairroPessoa"       as bairro,');
                SQL.Add('        "EntregaCodigoCidadePessoa" as idlocalidade,');
                SQL.Add('        "EntregaCepPessoa"          as cep,');
                SQL.Add('        "EntregaTelefonePessoa"     as telefone,');
                SQL.Add('        "EntregaFaxPessoa"          as fax,');
                SQL.Add('        "CodigoAlvoPessoa"          as idalvo,');
                SQL.Add('        "InscricaoEstadualPessoa"   as inscricaoestadual,');
                SQL.Add('        "CgcPessoa"                 as cnpj,');
                SQL.Add('        "IdentidadePessoa"          as rg,');
                SQL.Add('        "CicPessoa"                 as cpf,');
                SQL.Add('        "SexoPessoa"                as sexo,');
                SQL.Add('        "DataNascimentoPessoa"      as datanascimento,');
                SQL.Add('        "EstadoCivilPessoa"         as estadocivil,');
                SQL.Add('        "NomePaiPessoa"             as nomepai,');
                SQL.Add('        "NomeMaePessoa"             as nomemae,');
                SQL.Add('        "NomeEmpresaPessoa"         as nomeempresa,');
                SQL.Add('        "CodigoCargoPessoa"         as codcargo,');
                SQL.Add('        "EnderecoTrabalhoPessoa"    as enderecotrabalho,');
                SQL.Add('        "BairroTrabalhoPessoa"      as bairrotrabalho,');
                SQL.Add('        "CEPTrabalhoPessoa"         as ceptrabalho,');
                SQL.Add('        "TelefoneTrabalhoPessoa"    as telefonetrabalho,');
                SQL.Add('        "SalarioPessoa"             as salario,');
                SQL.Add('        "SenhaPessoa"               as senha,');
                SQL.Add('        "VerificaDebitosPessoa"     as verificadebitos,');
                SQL.Add('        "NomeConjugePessoa"         as nomeconjuge,');
                SQL.Add('        "NomeEmpresaConjugePessoa"  as nomeempresaconjuge,');
                SQL.Add('        "CodigoAtividadeConjugePessoa" as idatividadeconjuge,');
                SQL.Add('        "DataNascimentoConjugePessoa"  as datanascimentoconjuge,');
                SQL.Add('        "SalarioConjugePessoa"         as salarioconjuge,');
                SQL.Add('        "NomeDiretor1Pessoa"           as nomediretor1empresa,');
                SQL.Add('        "NomeDiretor2Pessoa"           as nomediretor2empresa,');
                SQL.Add('        "DataFundacaoEmpresaPessoa"    as datafundacaoempresa,');
                SQL.Add('        "ReferenciaComercial1Pessoa"   as referenciacomercial1,');
                SQL.Add('        "ReferenciaComercial2Pessoa"   as referenciacomercial2,');
                SQL.Add('        "NaturalidadePessoa"           as idnaturalidade,');
                SQL.Add('        "LimiteCreditoPessoa"          as limitecredito,');
                SQL.Add('        "DigitoBancoPessoa"            as digitobanco,');
                SQL.Add('        "EhSupervisorPessoa"           as ehsupervisor,');
                SQL.Add('        "EhUsuarioPessoa"              as ehusuario,');
                SQL.Add('        "EhOperadorPessoa"             as ehoperador,');
                SQL.Add('        "AgenciaBancoPessoa"           as agenciabanco,');
                SQL.Add('        "PercentualComissaoPessoa"     as perccomissao,');
                SQL.Add('        "DataUltimaAlteracao"          as dataultimaalteracao,');
                SQL.Add('        "EhMedicoPessoa"               as ehmedico,');
                SQL.Add('        "AtivoPessoa"                  as ativo,');
                SQL.Add('        "CodigoTabelaPrecoPessoa"      as idtabelapreco,');
                SQL.Add('        "CodigoCondicaoPessoa"         as idcondicao,');
                SQL.Add('        "EntregaEmailPessoa"           as email,');
                SQL.Add('        "EntregaCaixaPostalPessoa"     as caixapostal,');
                SQL.Add('        "CaminhoFotoPessoa"            as caminhofoto,');
                SQL.Add('        "CreditoPessoa"                as credito,');
                SQL.Add('        "NomeFantasiaPessoa"           as nomefantasia,');
                SQL.Add('        "PercentualDescontoPessoa"     as percdesconto,');
                SQL.Add('        "PrazoCondicaoPessoa"          as prazocondicao,');
                SQL.Add('        "EmiteEtiquetaPessoa"          as emiteetiqueta,');
                SQL.Add('        "MeuRelatorioConfiguravelPessoa" as meurelatorioconfiguravel,');
                SQL.Add('        "EhOftalmoPessoa"              as ehoftalmo,');
                SQL.Add('        "PerfilPermissaoPessoa"        as idperfilpermissao,');
                SQL.Add('        "DataPermissaoInicialPessoa"   as datainicialpermissao,');
                SQL.Add('        "DataPermissaoFinalPessoa"     as datafinalpermissao,');
                SQL.Add('        "EhSuperUsuarioPessoa"         as ehsuperusuario,');
                SQL.Add('        "SenhaSuperUsuarioPessoa"      as senhasuperusuario,');
                SQL.Add('        "EhRepresentanteSupervisorPessoa" as ehrepresentantesupervisor,');
                SQL.Add('        "DataIngressoFidelidadePessoa"    as dataingressofidelidade,');
                SQL.Add('        "PreCadastroPessoa"               as ehprecadastro,');
                SQL.Add('        "ObservacaoDiversaPessoa"         as observacaodiversa,');
                SQL.Add('        "HostEmailPessoa"                 as hostemail,');
                SQL.Add('        "PortaHostPessoa"                 as portahostemail,');
                SQL.Add('        "SenhaHostPessoa"                 as senhahostemail,');
                SQL.Add('        "NomeRemetenteEmailPessoa"        as nomeremetenteemail,');
                SQL.Add('        "MensagemFinalEmailPessoa"        as mensagemfinalemail,');
                SQL.Add('        "RequerAutenticacaoEmailPessoa"   as requerautenticacaoemail,');
                SQL.Add('        "ConfirmacaoLeituraEmailPessoa"   as confirmacaoleituraemail,');
                SQL.Add('        "CopiaEmailRemetentePessoa"       as copiarementeemail,');
                SQL.Add('        "PrioridadeEmailPessoa"           as prioridadeemail,');
                SQL.Add('        "GerarRemessaPessoa"              as geraremessa,');
                SQL.Add('        "CodigoEmpresaFuncionarioPessoa"  as idempresafuncionario,');
                SQL.Add('        "InscricaoSuframaPessoa"          as suframa,');
                SQL.Add('        "CobrancaEnderecoPessoa"          as enderecocobranca,');
                SQL.Add('        "CobrancaComplementoPessoa"       as complementocobranca,');
                SQL.Add('        "CobrancaBairroPessoa"            as bairrocobranca,');
                SQL.Add('        "CobrancaCodigoCidadePessoa"      as idlocalidadecobranca,');
                SQL.Add('        "CobrancaCepPessoa"               as cepcobranca,');
                SQL.Add('        "CobrancaTelefonePessoa"          as telefonecobranca,');
                SQL.Add('        "TemplateBiometricoPessoa"        as templatebiometrico,');
                SQL.Add('        "ContaDebitoPessoa"               as idcontadebito,');
                SQL.Add('        "ContaCreditoPessoa"              as idcontacredito,');
                SQL.Add('        "HabilitarCalculoRetencaoParcelasPessoa" as habilitarcalculoretencao,');
                SQL.Add('        "InscricaoMunicipalPessoa"        as inscricaomunicipal,');
                SQL.Add('        "PossuiConfiguracaoIniPessoa"     as possuiconfiguracaoini,');
                SQL.Add('        "ValorFaturarPessoa"              as valorfaturar,');
                SQL.Add('        "SitePessoa"                      as site,');
                SQL.Add('        "NaoGerarRemessaPessoa"           as naogeraremessa,');
                SQL.Add('        "EhRepresentanteMobilePessoa"     as ehrepresentantemobile,');
                SQL.Add('        "DataEnvioPessoa"                 as dataenvio,');
                SQL.Add('        "IdentificadorIEPessoa"           as identificadorinscricaoestadual,');
                SQL.Add('        "AceitaDevolucaoPessoa"           as aceitadevolucao,');
                SQL.Add('        "UseTlsExplicitEmailPessoa"       as tlsexplicitoemail,');
                SQL.Add('        "InscricaoEstadualSubstitutoPessoa" as inscricaoestadualsubstituto,');
                SQL.Add('        "CobrancaEmailPessoa"             as emailcobranca,');
                SQL.Add('        "EhClienteRevenda"                as ehclienterevenda,');
                SQL.Add('        "ParticipanteREIDIPessoa"         as participantereidi,');
                SQL.Add('        "AceitaFracionarBancarioPessoa"   as aceitafracionarbancario,');
                SQL.Add('        "AceitaTransferenciaBancarioPessoa" as aceitatransferenciabancario ');
                SQL.Add('from "PessoaGeral" where "CodigoPessoa"=:xcodigo ');
                ParamByName('xcodigo').AsInteger  := strtointdef(XPessoa.GetValue('codigo').Value,0);
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Pessoa incluída');
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
        end;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao incluir nova Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;


function AlteraPessoa(XIdPessoa: integer; XPessoa: TJSONObject): TJSONObject;
var wquery: TFDMemTable;
    wqueryUpdate,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wconexao: TProviderDataModuleConexao;
    wcampos,wval: string;
    wnum: integer;
begin
  try
    wcampos      := '';
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryUpdate := TFDQuery.Create(nil);

    //define quais campos serão alterados
    if XPessoa.TryGetValue('codigo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoPessoa"=:xcodigo'
         else
            wcampos := wcampos+',"CodigoPessoa"=:xcodigo';
       end;
    if XPessoa.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomePessoa"=:xnome'
         else
            wcampos := wcampos+',"NomePessoa"=:xnome';
       end;
    if XPessoa.TryGetValue('ehfisica',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhPessoaFisica"=:xehfisica'
         else
            wcampos := wcampos+',"EhPessoaFisica"=:xehfisica';
       end;
    if XPessoa.TryGetValue('idatividade',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoAtividadePessoa"='+ifthen(wval='0','null',':xidatividade')
         else
            wcampos := wcampos+',"CodigoAtividadePessoa"='+ifthen(wval='0','null',':xidatividade');
       end;
    if XPessoa.TryGetValue('idcontabil',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoContabilPessoa"='+ifthen(wval='0','null',':xidcontabil')
         else
            wcampos := wcampos+',"CodigoContabilPessoa"='+ifthen(wval='0','null',':xidcontabil');
       end;
    if XPessoa.TryGetValue('ctacorrente',wval) then
       begin
         if wcampos='' then
            wcampos := '"ContaCorrentePessoa"='+ifthen(wval='null','null',':xctacorrente')
         else
            wcampos := wcampos+',"ContaCorrentePessoa"='+ifthen(wval='null','null',':xctacorrente');
       end;
    if XPessoa.TryGetValue('idcobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCobrancaPessoa"='+ifthen(wval='0','null',':xidcobranca')
         else
            wcampos := wcampos+',"CodigoCobrancaPessoa"='+ifthen(wval='0','null',':xidcobranca');
       end;
    if XPessoa.TryGetValue('idrepresentante',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoRepresentantePessoa"='+ifthen(wval='0','null',':xidrepresentante')
         else
            wcampos := wcampos+',"CodigoRepresentantePessoa"='+ifthen(wval='0','null',':xidrepresentante');
       end;
    if XPessoa.TryGetValue('idbanco',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoBancoPessoa"='+ifthen(wval='0','null',':xidbanco')
         else
            wcampos := wcampos+',"CodigoBancoPessoa"='+ifthen(wval='0','null',':xidbanco');
       end;
    if XPessoa.TryGetValue('observacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoPessoa"='+ifthen(wval='null','null',':xobservacao')
         else
            wcampos := wcampos+',"ObservacaoPessoa"='+ifthen(wval='null','null',':xobservacao');
       end;
    if XPessoa.TryGetValue('ehcliente',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhClientePessoa"=:xehcliente'
         else
            wcampos := wcampos+',"EhClientePessoa"=:xehcliente';
       end;
    if XPessoa.TryGetValue('ehfornecedor',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhFornecedorPessoa"=:xehfornecedor'
         else
            wcampos := wcampos+',"EhFornecedorPessoa"=:xehfornecedor';
       end;
    if XPessoa.TryGetValue('ehempresa',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhEmpresaPessoa"=:xehempresa'
         else
            wcampos := wcampos+',"EhEmpresaPessoa"=:xehempresa';
       end;
    if XPessoa.TryGetValue('ehbanco',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhBancoPessoa"=:xehbanco'
         else
            wcampos := wcampos+',"EhBancoPessoa"=:xehbanco';
       end;
    if XPessoa.TryGetValue('ehrepresentante',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhRepresentantePessoa"=:xehrepresentante'
         else
            wcampos := wcampos+',"EhRepresentantePessoa"=:xehrepresentante';
       end;
    if XPessoa.TryGetValue('ehtransportador',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhTransportadoraPessoa"=:xehtransportador'
         else
            wcampos := wcampos+',"EhTransportadoraPessoa"=:xehtransportador';
       end;
    if XPessoa.TryGetValue('ehconvenio',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhConvenioPessoa"=:xehconvenio'
         else
            wcampos := wcampos+',"EhConvenioPessoa"=:xehconvenio';
       end;
    if XPessoa.TryGetValue('ehfuncionario',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhFuncionarioPessoa"=:xehfuncionario'
         else
            wcampos := wcampos+',"EhFuncionarioPessoa"=:xehfuncionario';
       end;
    if XPessoa.TryGetValue('contato',wval) then
       begin
         if wcampos='' then
            wcampos := '"ContatoPessoa"='+ifthen(wval='null','null',':xcontato')
         else
            wcampos := wcampos+',"ContatoPessoa"='+ifthen(wval='null','null',':xcontato');
       end;
    if XPessoa.TryGetValue('datacadastramento',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataCadastramentoPessoa"=:xdatacadastramento'
         else
            wcampos := wcampos+',"DataCadastramentoPessoa"=:xdatacadastramento';
       end;
    if XPessoa.TryGetValue('endereco',wval) then
       begin
         if wcampos='' then
            wcampos := '"EntregaEnderecoPessoa"='+ifthen(wval='null','null',':xendereco')
         else
            wcampos := wcampos+',"EntregaEnderecoPessoa"='+ifthen(wval='null','null',':xendereco');
       end;
    if XPessoa.TryGetValue('complemento',wval) then
       begin
         if wcampos='' then
            wcampos := '"EntregaComplementoPessoa"='+ifthen(wval='null','null',':xcomplemento')
         else
            wcampos := wcampos+',"EntregaComplementoPessoa"='+ifthen(wval='null','null',':xcomplemento');
       end;
    if XPessoa.TryGetValue('bairro',wval) then
       begin
         if wcampos='' then
            wcampos := '"EntregaBairroPessoa"='+ifthen(wval='null','null',':xbairro')
         else
            wcampos := wcampos+',"EntregaBairroPessoa"='+ifthen(wval='null','null',':xbairro');
       end;
    if XPessoa.TryGetValue('idlocalidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"EntregaCodigoCidadePessoa"='+ifthen(wval='0','null',':xidlocalidade')
         else
            wcampos := wcampos+',"EntregaCodigoCidadePessoa"='+ifthen(wval='0','null',':xidlocalidade');
       end;
    if XPessoa.TryGetValue('cep',wval) then
       begin
         if wcampos='' then
            wcampos := '"EntregaCepPessoa"='+ifthen(wval='null','null',':xcep')
         else
            wcampos := wcampos+',"EntregaCepPessoa"='+ifthen(wval='null','null',':xcep');
       end;
    if XPessoa.TryGetValue('telefone',wval) then
       begin
         if wcampos='' then
            wcampos := '"EntregaTelefonePessoa"='+ifthen(wval='null','null',':xtelefone')
         else
            wcampos := wcampos+',"EntregaTelefonePessoa"='+ifthen(wval='null','null',':xtelefone');
       end;
    if XPessoa.TryGetValue('fax',wval) then
       begin
         if wcampos='' then
            wcampos := '"EntregaFaxPessoa"='+ifthen(wval='null','null',':xfax')
         else
            wcampos := wcampos+',"EntregaFaxPessoa"='+ifthen(wval='null','null',':xfax');
       end;
    if XPessoa.TryGetValue('idalvo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoAlvoPessoa"='+ifthen(wval='0','null',':xidalvo')
         else
            wcampos := wcampos+',"CodigoAlvoPessoa"='+ifthen(wval='0','null',':xidalvo');
       end;
    if XPessoa.TryGetValue('inscricaoestadual',wval) then
       begin
         if wcampos='' then
            wcampos := '"InscricaoEstadualPessoa"='+ifthen(wval='null','null',':xinscricaoestadual')
         else
            wcampos := wcampos+',"InscricaoEstadualPessoa"='+ifthen(wval='null','null',':xinscricaoestadual');
       end;
    if XPessoa.TryGetValue('cnpj',wval) then
       begin
         if wcampos='' then
            wcampos := '"CgcPessoa"='+ifthen(wval='null','null',':xcnpj')
         else
            wcampos := wcampos+',"CgcPessoa"='+ifthen(wval='null','null',':xcnpj');
       end;
    if XPessoa.TryGetValue('rg',wval) then
       begin
         if wcampos='' then
            wcampos := '"IdentidadePessoa"='+ifthen(wval='null','null',':xrg')
         else
            wcampos := wcampos+',"IdentidadePessoa"='+ifthen(wval='null','null',':xrg');
       end;
    if XPessoa.TryGetValue('cpf',wval) then
       begin
         if wcampos='' then
            wcampos := '"CicPessoa"='+ifthen(wval='null','null',':xcpf')
         else
            wcampos := wcampos+',"CicPessoa"='+ifthen(wval='null','null',':xcpf');
       end;
    if XPessoa.TryGetValue('sexo',wval) then
       begin
         if wcampos='' then
            wcampos := '"SexoPessoa"='+ifthen(wval='null','null',':xsexo')
         else
            wcampos := wcampos+',"SexoPessoa"='+ifthen(wval='null','null',':xsexo');
       end;
    if XPessoa.TryGetValue('datanascimento',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataNascimentoPessoa"=:xdatanascimento'
         else
            wcampos := wcampos+',"DataNascimentoPessoa"=:xdatanascimento';
       end;
    if XPessoa.TryGetValue('estadocivil',wval) then
       begin
         if wcampos='' then
            wcampos := '"EstadoCivilPessoa"='+ifthen(wval='null','null',':xestadocivil')
         else
            wcampos := wcampos+',"EstadoCivilPessoa"='+ifthen(wval='null','null',':xestadocivil');
       end;
    if XPessoa.TryGetValue('nomepai',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomePaiPessoa"='+ifthen(wval='null','null',':xnomepai')
         else
            wcampos := wcampos+',"NomePaiPessoa"='+ifthen(wval='null','null',':xnomepai');
       end;
    if XPessoa.TryGetValue('nomemae',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeMaePessoa"='+ifthen(wval='null','null',':xnomemae')
         else
            wcampos := wcampos+',"NomeMaePessoa"='+ifthen(wval='null','null',':xnomemae');
       end;
    if XPessoa.TryGetValue('nomeempresa',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeEmpresaPessoa"='+ifthen(wval='null','null',':xnomeempresa')
         else
            wcampos := wcampos+',"NomeEmpresaPessoa"='+ifthen(wval='null','null',':xnomeempresa');
       end;
    if XPessoa.TryGetValue('codcargo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCargoPessoa"='+ifthen(wval='0','null',':xcodcargo')
         else
            wcampos := wcampos+',"CodigoCargoPessoa"='+ifthen(wval='0','null',':xcodcargo');
       end;
    if XPessoa.TryGetValue('enderecotrabalho',wval) then
       begin
         if wcampos='' then
            wcampos := '"EnderecoTrabalhoPessoa"='+ifthen(wval='null','null',':xenderecotrabalho')
         else
            wcampos := wcampos+',"EnderecoTrabalhoPessoa"='+ifthen(wval='null','null',':xenderecotrabalho');
       end;
    if XPessoa.TryGetValue('bairrotrabalho',wval) then
       begin
         if wcampos='' then
            wcampos := '"BairroTrabalhoPessoa"='+ifthen(wval='null','null',':xbairrotrabalho')
         else
            wcampos := wcampos+',"BairroTrabalhoPessoa"='+ifthen(wval='null','null',':xbairrotrabalho');
       end;
    if XPessoa.TryGetValue('ceptrabalho',wval) then
       begin
         if wcampos='' then
            wcampos := '"CEPTrabalhoPessoa"='+ifthen(wval='null','null',':xceptrabalho')
         else
            wcampos := wcampos+',"CEPTrabalhoPessoa"='+ifthen(wval='null','null',':xceptrabalho');
       end;
    if XPessoa.TryGetValue('telefonetrabalho',wval) then
       begin
         if wcampos='' then
            wcampos := '"TelefoneTrabalhoPessoa"='+ifthen(wval='null','null',':xtelefonetrabalho')
         else
            wcampos := wcampos+',"TelefoneTrabalhoPessoa"='+ifthen(wval='null','null',':xtelefonetrabalho');
       end;
    if XPessoa.TryGetValue('salario',wval) then
       begin
         if wcampos='' then
            wcampos := '"SalarioPessoa"=:xsalario'
         else
            wcampos := wcampos+',"SalarioPessoa"=:xsalario';
       end;
    if XPessoa.TryGetValue('senha',wval) then
       begin
         if wcampos='' then
            wcampos := '"SenhaPessoa"='+ifthen(wval='null','null',':xsenha')
         else
            wcampos := wcampos+',"SenhaPessoa"='+ifthen(wval='null','null',':xsenha');
       end;
    if XPessoa.TryGetValue('verificadebitos',wval) then
       begin
         if wcampos='' then
            wcampos := '"VerificaDebitosPessoa"=:xverificadebitos'
         else
            wcampos := wcampos+',"VerificaDebitosPessoa"=:xverificadebitos';
       end;
    if XPessoa.TryGetValue('nomeconjuge',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeConjugePessoa"='+ifthen(wval='null','null',':xnomeconjuge')
         else
            wcampos := wcampos+',"NomeConjugePessoa"='+ifthen(wval='null','null',':xnomeconjuge');
       end;
    if XPessoa.TryGetValue('nomeempresaconjuge',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeEmpresaConjugePessoa"='+ifthen(wval='null','null',':xnomeempresaconjuge')
         else
            wcampos := wcampos+',"NomeEmpresaConjugePessoa"='+ifthen(wval='null','null',':xnomeempresaconjuge');
       end;
    if XPessoa.TryGetValue('idatividadeconjuge',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoAtividadeConjugePessoa"='+ifthen(wval='0','null',':xidatividadeconjuge')
         else
            wcampos := wcampos+',"CodigoAtividadeConjugePessoa"='+ifthen(wval='0','null',':xidatividadeconjuge');
       end;
    if XPessoa.TryGetValue('datanascimentoconjuge',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataNascimentoConjugePessoa"=:xdatanascimentoconjuge'
         else
            wcampos := wcampos+',"DataNascimentoConjugePessoa"=:xdatanascimentoconjuge';
       end;
    if XPessoa.TryGetValue('salarioconjuge',wval) then
       begin
         if wcampos='' then
            wcampos := '"SalarioConjugePessoa"=:xsalarioconjuge'
         else
            wcampos := wcampos+',"SalarioConjugePessoa"=:xsalarioconjuge';
       end;
    if XPessoa.TryGetValue('nomediretor1empresa',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeDiretor1Pessoa"='+ifthen(wval='null','null',':xnomediretor1empresa')
         else
            wcampos := wcampos+',"NomeDiretor1Pessoa"='+ifthen(wval='null','null',':xnomediretor1empresa');
       end;
    if XPessoa.TryGetValue('nomediretor2empresa',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeDiretor2Pessoa"='+ifthen(wval='null','null',':xnomediretor2empresa')
         else
            wcampos := wcampos+',"NomeDiretor2Pessoa"='+ifthen(wval='null','null',':xnomediretor2empresa');
       end;
    if XPessoa.TryGetValue('datafundacaoempresa',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataFundacaoEmpresaPessoa"=:xdatafundacaoempresa'
         else
            wcampos := wcampos+',"DataFundacaoEmpresaPessoa"=:xdatafundacaoempresa';
       end;
    if XPessoa.TryGetValue('referenciacomercial1',wval) then
       begin
         if wcampos='' then
            wcampos := '"ReferenciaComercial1Pessoa"='+ifthen(wval='null','null',':xreferenciacomercial1')
         else
            wcampos := wcampos+',"ReferenciaComercial1Pessoa"='+ifthen(wval='null','null',':xreferenciacomercial1');
       end;
    if XPessoa.TryGetValue('referenciacomercial2',wval) then
       begin
         if wcampos='' then
            wcampos := '"ReferenciaComercial2Pessoa"='+ifthen(wval='null','null',':xreferenciacomercial2')
         else
            wcampos := wcampos+',"ReferenciaComercial2Pessoa"='+ifthen(wval='null','null',':xreferenciacomercial2');
       end;
    if XPessoa.TryGetValue('idnaturalidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"NaturalidadePessoa"='+ifthen(wval='0','null',':xidnaturalidade')
         else
            wcampos := wcampos+',"NaturalidadePessoa"='+ifthen(wval='0','null',':xidnaturalidade');
       end;
    if XPessoa.TryGetValue('limitecredito',wval) then
       begin
         if wcampos='' then
            wcampos := '"LimiteCreditoPessoa"=:xlimitecredito'
         else
            wcampos := wcampos+',"LimiteCreditoPessoa"=:xlimitecredito';
       end;
    if XPessoa.TryGetValue('digitobanco',wval) then
       begin
         if wcampos='' then
            wcampos := '"DigitoBancoPessoa"='+ifthen(wval='null','null',':xdigitobanco')
         else
            wcampos := wcampos+',"DigitoBancoPessoa"='+ifthen(wval='null','null',':xdigitobanco');
       end;
    if XPessoa.TryGetValue('ehsupervisor',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhSupervisorPessoa"=:xehsupervisor'
         else
            wcampos := wcampos+',"EhSupervisorPessoa"=:xehsupervisor';
       end;
    if XPessoa.TryGetValue('ehusuario',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhUsuarioPessoa"=:xehusuario'
         else
            wcampos := wcampos+',"EhUsuarioPessoa"=:xehusuario';
       end;
    if XPessoa.TryGetValue('ehoperador',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhOperadorPessoa"=:xehoperador'
         else
            wcampos := wcampos+',"EhOperadorPessoa"=:xehoperador';
       end;
    if XPessoa.TryGetValue('agenciabanco',wval) then
       begin
         if wcampos='' then
            wcampos := '"AgenciaBancoPessoa"='+ifthen(wval='null','null',':xagenciabanco')
         else
            wcampos := wcampos+',"AgenciaBancoPessoa"='+ifthen(wval='null','null',':xagenciabanco');
       end;
    if XPessoa.TryGetValue('perccomissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualComissaoPessoa"=:xperccomissao'
         else
            wcampos := wcampos+',"PercentualComissaoPessoa"=:xperccomissao';
       end;
    if XPessoa.TryGetValue('ehmedico',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhMedicoPessoa"=:xehmedico'
         else
            wcampos := wcampos+',"EhMedicoPessoa"=:xehmedico';
       end;
    if XPessoa.TryGetValue('ativo',wval) then
       begin
         if wcampos='' then
            wcampos := '"AtivoPessoa"=:xativo'
         else
            wcampos := wcampos+',"AtivoPessoa"=:xativo';
       end;
    if XPessoa.TryGetValue('idtabelapreco',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoTabelaPrecoPessoa"='+ifthen(wval='0','null',':xidtabelapreco')
         else
            wcampos := wcampos+',"CodigoTabelaPrecoPessoa"='+ifthen(wval='0','null',':xidtabelapreco');
       end;
    if XPessoa.TryGetValue('idcondicao',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCondicaoPessoa"='+ifthen(wval='0','null',':xidcondicao')
         else
            wcampos := wcampos+',"CodigoCondicaoPessoa"='+ifthen(wval='0','null',':xidcondicao');
       end;
    if XPessoa.TryGetValue('email',wval) then
       begin
         if wcampos='' then
            wcampos := '"EntregaEmailPessoa"='+ifthen(wval='null','null',':xemail')
         else
            wcampos := wcampos+',"EntregaEmailPessoa"='+ifthen(wval='null','null',':xemail');
       end;
    if XPessoa.TryGetValue('caixapostal',wval) then
       begin
         if wcampos='' then
            wcampos := '"EntregaCaixaPostalPessoa"='+ifthen(wval='null','null',':xcaixapostal')
         else
            wcampos := wcampos+',"EntregaCaixaPostalPessoa"='+ifthen(wval='null','null',':xcaixapostal');
       end;
    if XPessoa.TryGetValue('caminhofoto',wval) then
       begin
         if wcampos='' then
            wcampos := '"CaminhoFotoPessoa"='+ifthen(wval='null','null',':xcaminhofoto')
         else
            wcampos := wcampos+',"CaminhoFotoPessoa"='+ifthen(wval='null','null',':xcaminhofoto');
       end;
    if XPessoa.TryGetValue('credito',wval) then
       begin
         if wcampos='' then
            wcampos := '"CreditoPessoa"=:xcredito'
         else
            wcampos := wcampos+',"CreditoPessoa"=:xcredito';
       end;
    if XPessoa.TryGetValue('nomefantasia',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeFantasiaPessoa"='+ifthen(wval='null','null',':xnomefantasia')
         else
            wcampos := wcampos+',"NomeFantasiaPessoa"='+ifthen(wval='null','null',':xnomefantasia');
       end;
    if XPessoa.TryGetValue('percdesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualDescontoPessoa"=:xpercdesconto'
         else
            wcampos := wcampos+',"PercentualDescontoPessoa"=:xpercdesconto';
       end;
    if XPessoa.TryGetValue('prazocondicao',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrazoCondicaoPessoa"=:xprazocondicao'
         else
            wcampos := wcampos+',"PrazoCondicaoPessoa"=:xprazocondicao';
       end;
    if XPessoa.TryGetValue('emiteetiqueta',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmiteEtiquetaPessoa"=:xemiteetiqueta'
         else
            wcampos := wcampos+',"EmiteEtiquetaPessoa"=:xemiteetiqueta';
       end;
    if XPessoa.TryGetValue('meurelatorioconfiguravel',wval) then
       begin
         if wcampos='' then
            wcampos := '"MeuRelatorioConfiguravelPessoa"='+ifthen(wval='null','null',':xmeurelatorioconfiguravel')
         else
            wcampos := wcampos+',"MeuRelatorioConfiguravelPessoa"='+ifthen(wval='null','null',':xmeurelatorioconfiguravel');
       end;
    if XPessoa.TryGetValue('ehoftalmo',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhOftalmoPessoa"=:xehoftalmo'
         else
            wcampos := wcampos+',"EhOftalmoPessoa"=:xehoftalmo';
       end;
    if XPessoa.TryGetValue('idperfilpermissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"PerfilPermissaoPessoa"=:xidperfilpermissao'
         else
            wcampos := wcampos+',"PerfilPermissaoPessoa"=:xidperfilpermissao';
       end;
    if XPessoa.TryGetValue('datainicialpermissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataPermissaoInicialPessoa"=:xdatainicialpermissao'
         else
            wcampos := wcampos+',"DataPermissaoInicialPessoa"=:xdatainicialpermissao';
       end;
    if XPessoa.TryGetValue('datafinalpermissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataPermissaoFinalPessoa"=:xdatafinalpermissao'
         else
            wcampos := wcampos+',"DataPermissaoFinalPessoa"=:xdatafinalpermissao';
       end;
    if XPessoa.TryGetValue('ehsuperusuario',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhSuperUsuarioPessoa"=:xehsuperusuario'
         else
            wcampos := wcampos+',"EhSuperUsuarioPessoa"=:xehsuperusuario';
       end;
    if XPessoa.TryGetValue('senhasuperusuario',wval) then
       begin
         if wcampos='' then
            wcampos := '"SenhaSuperUsuarioPessoa"='+ifthen(wval='null','null',':xsenhasuperusuario')
         else
            wcampos := wcampos+',"SenhaSuperUsuarioPessoa"='+ifthen(wval='null','null',':xsenhasuperusuario');
       end;
    if XPessoa.TryGetValue('ehrepresentantesupervisor',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhRepresentateSupervisorPessoa"=:xehrepresentantesupervisor'
         else
            wcampos := wcampos+',"EhRepresentanteSupervisorPessoa"=:xehrepresentantesupervisor';
       end;
    if XPessoa.TryGetValue('dataingressofidelidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataIngressoFidelidadePessoa"=:xdataingressofidelidade'
         else
            wcampos := wcampos+',"DataIngressoFidelidadePessoa"=:xdataingressofidelidade';
       end;
    if XPessoa.TryGetValue('ehprecadastro',wval) then
       begin
         if wcampos='' then
            wcampos := '"PreCadastroPessoa"=:xehprecadastro'
         else
            wcampos := wcampos+',"PreCadastroPessoa"=:xehprecadastro';
       end;
    if XPessoa.TryGetValue('observacaodiversa',wval) then
       begin
         if wcampos='' then
            wcampos := '"ObservacaoDiversaPessoa"='+ifthen(wval='null','null',':xobservacaodiversa')
         else
            wcampos := wcampos+',"ObservacaoDiversaPessoa"='+ifthen(wval='null','null',':xobservacaodiversa');
       end;
    if XPessoa.TryGetValue('hostemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"HostEmailPessoa"='+ifthen(wval='null','null',':xhostemail')
         else
            wcampos := wcampos+',"HostEmailPessoa"='+ifthen(wval='null','null',':xhostemail');
       end;
    if XPessoa.TryGetValue('portahostemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"PortaHostPessoa"=:xportahostemail'
         else
            wcampos := wcampos+',"PortaHostPessoa"=:xportahostemail';
       end;
    if XPessoa.TryGetValue('senhahostemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"SenhaHostPessoa"='+ifthen(wval='null','null',':xsenhahostemail')
         else
            wcampos := wcampos+',"SenhaHostPessoa"='+ifthen(wval='null','null',':xsenhahostemail');
       end;
    if XPessoa.TryGetValue('nomeremetenteemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomeRemetenteEmailPessoa"='+ifthen(wval='null','null',':xnomeremetenteemail')
         else
            wcampos := wcampos+',"NomeRemetenteEmailPessoa"='+ifthen(wval='null','null',':xnomeremetenteemail');
       end;
    if XPessoa.TryGetValue('mensagemfinalemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"MensagemFinalEmailPessoa"='+ifthen(wval='null','null',':xmensagemfinalemail')
         else
            wcampos := wcampos+',"MensagemFinalEmailPessoa"='+ifthen(wval='null','null',':xmensagemfinalemail');
       end;
    if XPessoa.TryGetValue('requerautenticacaoemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"RequerAutenticacaoEmailPessoa"=:xrequerautenticacaoemail'
         else
            wcampos := wcampos+',"RequerAutenticacaoEmailPessoa"=:xrequerautenticacaoemail';
       end;
    if XPessoa.TryGetValue('confirmacaoleituraemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"ConfirmacaoLeituraEmailPessoa"=:xconfirmacaoleituraemail'
         else
            wcampos := wcampos+',"ConfirmacaoLeituraEmailPessoa"=:xconfirmacaoleituraemail';
       end;
    if XPessoa.TryGetValue('copiaremetenteemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"CopiaEmailRemetentePessoa"=:xcopiaremetenteemail'
         else
            wcampos := wcampos+',"CopiaEmailRemetentePessoa"=:xcopiaremetenteemail';
       end;
    if XPessoa.TryGetValue('prioridadeemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"PrioridadeEmailPessoa"=:xprioridadeemail'
         else
            wcampos := wcampos+',"PrioridadeEmailPessoa"=:xprioridadeemail';
       end;
    if XPessoa.TryGetValue('geraremessa',wval) then
       begin
         if wcampos='' then
            wcampos := '"GerarRemessaPessoa"=:xgeraremessa'
         else
            wcampos := wcampos+',"GerarRemessaPessoa"=:xgeraremessa';
       end;
    if XPessoa.TryGetValue('idempresafuncionario',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoEmpresaFuncionarioPessoa"='+ifthen(wval='0','null',':xidempresafuncionario')
         else
            wcampos := wcampos+',"CodigoEmpresaFuncionarioPessoa"='+ifthen(wval='0','null',':xidempresafuncionario');
       end;
    if XPessoa.TryGetValue('suframa',wval) then
       begin
         if wcampos='' then
            wcampos := '"InscricaoSuframaPessoa"='+ifthen(wval='null','null',':xsuframa')
         else
            wcampos := wcampos+',"InscricaoSuframaPessoa"='+ifthen(wval='null','null',':xsuframa');
       end;
    if XPessoa.TryGetValue('enderecocobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"CobrancaEnderecoPessoa"='+ifthen(wval='null','null',':xenderecocobranca')
         else
            wcampos := wcampos+',"CobrancaEnderecoPessoa"='+ifthen(wval='null','null',':xenderecocobranca');
       end;
    if XPessoa.TryGetValue('complementocobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"CobrancaComplementoPessoa"='+ifthen(wval='null','null',':xcomplementocobranca')
         else
            wcampos := wcampos+',"CobrancaComplementoPessoa"='+ifthen(wval='null','null',':xcomplementocobranca');
       end;
    if XPessoa.TryGetValue('bairrocobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"CobrancaBairroPessoa"='+ifthen(wval='null','null',':xbairrocobranca')
         else
            wcampos := wcampos+',"CobrancaBairroPessoa"='+ifthen(wval='null','null',':xbairrocobranca');
       end;
    if XPessoa.TryGetValue('idlocalidadecobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"CobrancaCodigoCidadePessoa"='+ifthen(wval='0','null',':xidlocalidadecobranca')
         else
            wcampos := wcampos+',"CobrancaCodigoCidadePessoa"='+ifthen(wval='0','null',':xidlocalidadecobranca');
       end;
    if XPessoa.TryGetValue('cepcobranca',wval) then
        begin
         if wcampos='' then
            wcampos := '"CobrancaCepPessoa"='+ifthen(wval='null','null',':xcepcobranca')
         else
            wcampos := wcampos+',"CobrancaCepPessoa"='+ifthen(wval='null','null',':xcepcobranca');
       end;
    if XPessoa.TryGetValue('telefonecobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"CobrancaTelefonePessoa"='+ifthen(wval='null','null',':xtelefonecobranca')
         else
            wcampos := wcampos+',"CobrancaTelefonePessoa"='+ifthen(wval='null','null',':xtelefonecobranca');
       end;
    if XPessoa.TryGetValue('templatebiometrico',wval) then
       begin
         if wcampos='' then
            wcampos := '"TemplateBiometricoPessoa"='+ifthen(wval='null','null',':xtemplatebiometrico')
         else
            wcampos := wcampos+',"TemplateBiometricoPessoa"='+ifthen(wval='null','null',':xtemplatebiometrico');
       end;
    if XPessoa.TryGetValue('idcontadebito',wval) then
       begin
         if wcampos='' then
            wcampos := '"ContaDebitoPessoa"='+ifthen(wval='0','null',':xidcontadebito')
         else
            wcampos := wcampos+',"ContaDebitoPessoa"='+ifthen(wval='0','null',':xidcontadebito');
       end;
    if XPessoa.TryGetValue('idcontacredito',wval) then
       begin
         if wcampos='' then
            wcampos := '"ContaCreditoPessoa"='+ifthen(wval='0','null',':xidcontacredito')
         else
            wcampos := wcampos+',"ContaCreditoPessoa"='+ifthen(wval='0','null',':xidcontacredito');
       end;
    if XPessoa.TryGetValue('habilitarcalculoretencao',wval) then
       begin
         if wcampos='' then
            wcampos := '"HabilitarCalculoRetencaoParcelasPessoa"=:xhabilitarcalculoretencao'
         else
            wcampos := wcampos+',"HabilitarCalculoRetencaoParcelasPessoa"=:xhabilitarcalculoretencao';
       end;
    if XPessoa.TryGetValue('inscricaomunicipal',wval) then
       begin
         if wcampos='' then
            wcampos := '"InscricaoMunicipalPessoa"='+ifthen(wval='null','null',':xinscricaomunicipal')
         else
            wcampos := wcampos+',"InscricaoMunicipalPessoa"='+ifthen(wval='null','null',':xinscricaomunicipal');
       end;
    if XPessoa.TryGetValue('possuiconfiguracaoini',wval) then
       begin
         if wcampos='' then
            wcampos := '"PossuiConfiguracaoIniPessoa"=:xpossuiconfiguracaoini'
         else
            wcampos := wcampos+',"PossuiConfiguracaoIniPessoa"=:xpossuiconfiguracaoini';
       end;
    if XPessoa.TryGetValue('valorfaturar',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorFaturarPessoa"=:xvalorfaturar'
         else
            wcampos := wcampos+',"ValorFaturarPessoa"=:xvalorfaturar';
       end;
    if XPessoa.TryGetValue('site',wval) then
       begin
         if wcampos='' then
            wcampos := '"SitePessoa"='+ifthen(wval='null','null',':xsite')
         else
            wcampos := wcampos+',"SitePessoa"='+ifthen(wval='null','null',':xsite');
       end;
    if XPessoa.TryGetValue('naogeraremessa',wval) then
       begin
         if wcampos='' then
            wcampos := '"NaoGerarRemessaPessoa"=:xnaogeraremessa'
         else
            wcampos := wcampos+',"NaoGerarRemessaPessoa"=:xnaogeraremessa';
       end;
    if XPessoa.TryGetValue('ehrepresentantemobile',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhRepresentanteMobilePessoa"=:xehrepresentantemobile'
         else
            wcampos := wcampos+',"EhRepresentanteMobilePessoa"=:xehrepresentantemobile';
       end;
    if XPessoa.TryGetValue('dataenvio',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataEnvioPessoa"=:xdataenvio'
         else
            wcampos := wcampos+',"DataEnvioPessoa"=:xdataenvio';
       end;
    if XPessoa.TryGetValue('identificadorinscricaoestadual',wval) then
       begin
         if wcampos='' then
            wcampos := '"IdentificadorIEPessoa"='+ifthen(wval='null','null',':xidentificadorinscricaoestadual')
         else
            wcampos := wcampos+',"IdentificadorIEPessoa"='+ifthen(wval='null','null',':xidentificadorinscricaoestadual');
       end;
    if XPessoa.TryGetValue('aceitadevolucao',wval) then
       begin
         if wcampos='' then
            wcampos := '"AceitaDevolucaoPessoa"=:xaceitadevolucao'
         else
            wcampos := wcampos+',"AceitaDevolucaoPessoa"=:xaceitadevolucao';
       end;
    if XPessoa.TryGetValue('tlsexplicitoemail',wval) then
       begin
         if wcampos='' then
            wcampos := '"UseTlsExplicitEmailPessoa"=:xtlsexplicitoemail'
         else
            wcampos := wcampos+',"UseTlsExplicitEmailPessoa"=:xtlsexplicitoemail';
       end;
    if XPessoa.TryGetValue('inscricaoestadualsubstituto',wval) then
       begin
         if wcampos='' then
            wcampos := '"InscricaoEstadualSubstitutoPessoa"='+ifthen(wval='null','null',':xinscricaoestadualsubstituto')
         else
            wcampos := wcampos+',"InscricaoEstadualSubstitutoPessoa"='+ifthen(wval='null','null',':xinscricaoestadualsubstituto');
       end;
    if XPessoa.TryGetValue('emailcobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"CobrancaEmailPessoa"='+ifthen(wval='null','null',':xemailcobranca')
         else
            wcampos := wcampos+',"CobrancaEmailPessoa"='+ifthen(wval='null','null',':xemailcobranca');
       end;
    if XPessoa.TryGetValue('ehclienterevenda',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhClienteRevenda"=:xehclienterevenda'
         else
            wcampos := wcampos+',"EhClienteRevenda"=:xehclienterevenda';
       end;
    if XPessoa.TryGetValue('participantereidi',wval) then
       begin
         if wcampos='' then
            wcampos := '"ParticipanteREIDIPessoa"=:xparticipantereidi'
         else
            wcampos := wcampos+',"ParticipanteREIDIPessoa"=:xparticipantereidi';
       end;
    if XPessoa.TryGetValue('aceitafracionarbancario',wval) then
       begin
         if wcampos='' then
            wcampos := '"AceitaFracionarBancarioPessoa"=:xaceitafracionarbancario'
         else
            wcampos := wcampos+',"AceitaFracionarBancarioPessoa"=:xaceitafracionarbancario';
       end;
    if XPessoa.TryGetValue('aceitatransferenciabancario',wval) then
       begin
         if wcampos='' then
            wcampos := '"AceitaTransferenciaBancarioPessoa"=:xaceitatransferenciabancario'
         else
            wcampos := wcampos+',"AceitaTransferenciaBancarioPessoa"=:xaceitatransferenciabancario';
       end;

    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryUpdate do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Update "PessoaGeral" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPessoa"=:xid ');
           ParamByName('xid').AsInteger                := XIdPessoa;
           if XPessoa.TryGetValue('codigo',wval) then
              ParamByName('xcodigo').AsInteger         := strtointdef(XPessoa.GetValue('codigo').Value,0);
           if XPessoa.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString            := XPessoa.GetValue('nome').Value;
           if XPessoa.TryGetValue('ehfisica',wval) then
              ParamByName('xehfisica').AsBoolean       := strtobooldef(XPessoa.GetValue('ehfisica').Value,false);
           if XPessoa.TryGetValue('idatividade',wval) then
              ParamByName('xidatividade').AsInteger    := strtointdef(XPessoa.GetValue('idatividade').Value,0);
           if XPessoa.TryGetValue('idcontabil',wval) and (wval<>'0') then
              ParamByName('xidcontabil').AsInteger     := strtointdef(XPessoa.GetValue('idcontabil').Value,0);
           if XPessoa.TryGetValue('ctacorrente',wval) and (wval<>'null') then
              ParamByName('xctacorrente').AsString     := XPessoa.GetValue('ctacorrente').Value;
           if XPessoa.TryGetValue('idcobranca',wval) and (wval<>'0') then
              ParamByName('xidcobranca').AsInteger     := strtointdef(XPessoa.GetValue('idcobranca').Value,0);
           if XPessoa.TryGetValue('idrepresentante',wval) and (wval<>'0') then
              ParamByName('xidrepresentante').AsInteger     := strtointdef(XPessoa.GetValue('idrepresentante').Value,0);
           if XPessoa.TryGetValue('idbanco',wval) and (wval<>'0') then
              ParamByName('xidbanco').AsInteger        := strtointdef(XPessoa.GetValue('idbanco').Value,0);
           if XPessoa.TryGetValue('observacao',wval) and (wval<>'null') then
              ParamByName('xobservacao').AsString      := XPessoa.GetValue('observacao').Value;
           if XPessoa.TryGetValue('ehcliente',wval) then
              ParamByName('xehcliente').AsBoolean      := strtobooldef(XPessoa.GetValue('ehcliente').Value,false);
           if XPessoa.TryGetValue('ehfornecedor',wval) then
              ParamByName('xehfornecedor').AsBoolean   := strtobooldef(XPessoa.GetValue('ehfornecedor').Value,false);
           if XPessoa.TryGetValue('ehempresa',wval) then
              ParamByName('xehempresa').AsBoolean      := strtobooldef(XPessoa.GetValue('ehempresa').Value,false);
           if XPessoa.TryGetValue('ehbanco',wval) then
              ParamByName('xehbanco').AsBoolean      := strtobooldef(XPessoa.GetValue('ehbanco').Value,false);
           if XPessoa.TryGetValue('ehrepresentante',wval) then
              ParamByName('xehrepresentante').AsBoolean   := strtobooldef(XPessoa.GetValue('ehrepresentante').Value,false);
           if XPessoa.TryGetValue('ehtransportador',wval) then
              ParamByName('xehtransportador').AsBoolean   := strtobooldef(XPessoa.GetValue('ehtransportador').Value,false);
           if XPessoa.TryGetValue('ehconvenio',wval) then
              ParamByName('xehconvenio').AsBoolean   := strtobooldef(XPessoa.GetValue('ehconvenio').Value,false);
           if XPessoa.TryGetValue('ehfuncionario',wval) then
              ParamByName('xehfuncionario').AsBoolean   := strtobooldef(XPessoa.GetValue('ehfuncionario').Value,false);
           if XPessoa.TryGetValue('contato',wval) and (wval<>'null') then
              ParamByName('xcontato').AsString          := XPessoa.GetValue('contato').Value;
           if XPessoa.TryGetValue('datacadastramento',wval) then
              ParamByName('xdatacadastramento').AsDate  := strtodatedef(XPessoa.GetValue('datacadastramento').Value,date);
           if XPessoa.TryGetValue('endereco',wval) and (wval<>'null') then
              ParamByName('xendereco').AsString         := XPessoa.GetValue('endereco').Value;
           if XPessoa.TryGetValue('complemento',wval) and (wval<>'null') then
              ParamByName('xcomplemento').AsString      := XPessoa.GetValue('complemento').Value;
           if XPessoa.TryGetValue('bairro',wval) and (wval<>'null') then
              ParamByName('xbairro').AsString           := XPessoa.GetValue('bairro').Value;
           if XPessoa.TryGetValue('idlocalidade',wval) and (wval<>'0') then
              ParamByName('xidlocalidade').AsInteger    := strtointdef(XPessoa.GetValue('idlocalidade').Value,0);
           if XPessoa.TryGetValue('cep',wval) and (wval<>'null') then
              ParamByName('xcep').AsString              := XPessoa.GetValue('cep').Value;
           if XPessoa.TryGetValue('telefone',wval) and (wval<>'null') then
              ParamByName('xtelefone').AsString         := XPessoa.GetValue('telefone').Value;
           if XPessoa.TryGetValue('fax',wval) and (wval<>'null') then
              ParamByName('xfax').AsString              := XPessoa.GetValue('fax').Value;
           if XPessoa.TryGetValue('idalvo',wval) and (wval<>'0') then
              ParamByName('xidalvo').AsInteger          := strtointdef(XPessoa.GetValue('idalvo').Value,0);
           if XPessoa.TryGetValue('inscricaoestadual',wval) and (wval<>'null') then
              ParamByName('xinscricaoestadual').AsString:= XPessoa.GetValue('inscricaoestadual').Value;
           if XPessoa.TryGetValue('cnpj',wval) and (wval<>'null') then
              ParamByName('xcnpj').AsString             := XPessoa.GetValue('cnpj').Value;
           if XPessoa.TryGetValue('rg',wval) and (wval<>'null') then
              ParamByName('xrg').AsString               := XPessoa.GetValue('rg').Value;
           if XPessoa.TryGetValue('cpf',wval) and (wval<>'null') then
              ParamByName('xcpf').AsString              := XPessoa.GetValue('cpf').Value;
           if XPessoa.TryGetValue('sexo',wval) and (wval<>'null') then
              ParamByName('xsexo').AsString             := XPessoa.GetValue('sexo').Value;
           if XPessoa.TryGetValue('datanascimento',wval) then
              ParamByName('xdatanascimento').AsDate     := strtodatedef(XPessoa.GetValue('datanascimento').Value,0);
           if XPessoa.TryGetValue('estadocivil',wval) and (wval<>'null') then
              ParamByName('xestadocivil').AsString      := XPessoa.GetValue('estadocivil').Value;
           if XPessoa.TryGetValue('nomepai',wval) and (wval<>'null') then
              ParamByName('xnomepai').AsString          := XPessoa.GetValue('nomepai').Value;
           if XPessoa.TryGetValue('nomemae',wval) and (wval<>'null') then
              ParamByName('xnomemae').AsString          := XPessoa.GetValue('nomemae').Value;
           if XPessoa.TryGetValue('nomeempresa',wval) and (wval<>'null') then
              ParamByName('xnomeempresa').AsString      := XPessoa.GetValue('nomeempresa').Value;
           if XPessoa.TryGetValue('codcargo',wval) and (wval<>'0') then
              ParamByName('xcodcargo').AsInteger        := strtointdef(XPessoa.GetValue('codcargo').Value,0);
           if XPessoa.TryGetValue('enderecotrabalho',wval) and (wval<>'null') then
              ParamByName('xenderecotrabalho').AsString := XPessoa.GetValue('enderecotrabalho').Value;
           if XPessoa.TryGetValue('bairrotrabalho',wval) and (wval<>'null') then
              ParamByName('xbairrotrabalho').AsString   := XPessoa.GetValue('bairrotrabalho').Value;
           if XPessoa.TryGetValue('ceptrabalho',wval) and (wval<>'null') then
              ParamByName('xceptrabalho').AsString      := XPessoa.GetValue('ceptrabalho').Value;
           if XPessoa.TryGetValue('telefonetrabalho',wval) and (wval<>'null') then
              ParamByName('xtelefonetrabalho').AsString := XPessoa.GetValue('telefonetrabalho').Value;
           if XPessoa.TryGetValue('salario',wval) then
              ParamByName('xsalario').AsFloat           := strtofloatdef(XPessoa.GetValue('salario').Value,0);
           if XPessoa.TryGetValue('senha',wval) and (wval<>'null') then
              ParamByName('xsenha').AsString            := XPessoa.GetValue('senha').Value;
           if XPessoa.TryGetValue('verificadebitos',wval) then
              ParamByName('xverificadebitos').AsBoolean := strtobooldef(XPessoa.GetValue('verificadebitos').Value,false);
           if XPessoa.TryGetValue('nomeconjuge',wval) and (wval<>'null') then
              ParamByName('xnomeconjuge').AsString      := XPessoa.GetValue('nomeconjuge').Value;
           if XPessoa.TryGetValue('nomeempresaconjuge',wval) and (wval<>'null') then
              ParamByName('xnomeempresaconjuge').AsString      := XPessoa.GetValue('nomeempresaconjuge').Value;
           if XPessoa.TryGetValue('idatividadeconjuge',wval) and (wval<>'0') then
              ParamByName('xidatividadeconjuge').AsInteger     := strtointdef(XPessoa.GetValue('idatividadeconjuge').Value,0);
           if XPessoa.TryGetValue('datanascimentoconjuge',wval) then
              ParamByName('xdatanascimentoconjuge').AsDate     := strtodatedef(XPessoa.GetValue('datanascimentoconjuge').Value,0);
           if XPessoa.TryGetValue('salarioconjuge',wval) then
              ParamByName('xsalarioconjuge').AsFloat           := strtofloatdef(XPessoa.GetValue('salarioconjuge').Value,0);
           if XPessoa.TryGetValue('nomediretor1empresa',wval) and (wval<>'null') then
              ParamByName('xnomediretor1empresa').AsString      := XPessoa.GetValue('nomediretor1empresa').Value;
           if XPessoa.TryGetValue('nomediretor2empresa',wval) and (wval<>'null') then
              ParamByName('xnomediretor2empresa').AsString      := XPessoa.GetValue('nomediretor2empresa').Value;
           if XPessoa.TryGetValue('datafundacaoempresa',wval) then
              ParamByName('xdatafundacaoempresa').AsDate        := strtodatedef(XPessoa.GetValue('datafundacaoempresa').Value,0);
           if XPessoa.TryGetValue('referenciacomercial1',wval) and (wval<>'null') then
              ParamByName('xreferenciacomercial1').AsString     := XPessoa.GetValue('referenciacomercial1').Value;
           if XPessoa.TryGetValue('referenciacomercial2',wval) and (wval<>'null') then
              ParamByName('xreferenciacomercial2').AsString     := XPessoa.GetValue('referenciacomercial2').Value;
           if XPessoa.TryGetValue('idnaturalidade',wval) and (wval<>'0') then
              ParamByName('xidnaturalidade').AsInteger          := strtointdef(XPessoa.GetValue('idnaturalidade').Value,0);
           if XPessoa.TryGetValue('limitecredito',wval) then
              ParamByName('xlimitecredito').AsFloat             := strtofloatdef(XPessoa.GetValue('limitecredito').Value,0);
           if XPessoa.TryGetValue('digitobanco',wval) and (wval<>'null') then
              ParamByName('xdigitobanco').AsString              := XPessoa.GetValue('digitobanco').Value;
           if XPessoa.TryGetValue('ehsupervisor',wval) then
              ParamByName('xehsupervisor').AsBoolean            := strtobooldef(XPessoa.GetValue('ehsupervisor').Value,false);
           if XPessoa.TryGetValue('ehusuario',wval) then
              ParamByName('xehusuario').AsBoolean               := strtobooldef(XPessoa.GetValue('ehusuario').Value,false);
           if XPessoa.TryGetValue('ehoperador',wval) then
              ParamByName('xehoperador').AsBoolean              := strtobooldef(XPessoa.GetValue('ehoperador').Value,false);
           if XPessoa.TryGetValue('agenciabanco',wval) and (wval<>'null') then
              ParamByName('xagenciabanco').AsString             := XPessoa.GetValue('agenciabanco').Value;
           if XPessoa.TryGetValue('perccomissao',wval) then
              ParamByName('xperccomissao').AsFloat              := strtofloatdef(XPessoa.GetValue('perccomissao').Value,0);
           if XPessoa.TryGetValue('ehmedico',wval) then
              ParamByName('xehmedico').AsBoolean                := strtobooldef(XPessoa.GetValue('ehmedico').Value,false);
           if XPessoa.TryGetValue('ativo',wval) then
              ParamByName('xativo').AsBoolean                   := strtobooldef(XPessoa.GetValue('ativo').Value,false);
           if XPessoa.TryGetValue('idtabelapreco',wval) and (wval<>'0') then
              ParamByName('xidtabelapreco').AsInteger           := strtointdef(XPessoa.GetValue('idtabelapreco').Value,0);
           if XPessoa.TryGetValue('idcondicao',wval) and (wval<>'0') then
              ParamByName('xidcondicao').AsInteger              := strtointdef(XPessoa.GetValue('idcondicao').Value,0);
           if XPessoa.TryGetValue('email',wval) and (wval<>'null') then
              ParamByName('xemail').AsString                    := XPessoa.GetValue('email').Value;
           if XPessoa.TryGetValue('caixapostal',wval) and (wval<>'null') then
              ParamByName('xcaixapostal').AsString              := XPessoa.GetValue('caixapostal').Value;
           if XPessoa.TryGetValue('caminhofoto',wval) and (wval<>'null') then
              ParamByName('xcaminhofoto').AsString              := XPessoa.GetValue('caminhofoto').Value;
           if XPessoa.TryGetValue('credito',wval) then
              ParamByName('xcredito').AsFloat                   := strtofloatdef(XPessoa.GetValue('credito').Value,0);
           if XPessoa.TryGetValue('nomefantasia',wval) and (wval<>'null') then
              ParamByName('xnomefantasia').AsString             := XPessoa.GetValue('nomefantasia').Value;
           if XPessoa.TryGetValue('percdesconto',wval) then
              ParamByName('xpercdesconto').AsFloat              := strtofloatdef(XPessoa.GetValue('percdesconto').Value,0);
           if XPessoa.TryGetValue('prazocondicao',wval) then
              ParamByName('xprazocondicao').AsInteger           := strtointdef(XPessoa.GetValue('prazocondicao').Value,0);
           if XPessoa.TryGetValue('emiteetiqueta',wval) then
              ParamByName('xemiteetiqueta').AsBoolean           := strtobooldef(XPessoa.GetValue('emiteetiqueta').Value,false);
           if XPessoa.TryGetValue('meurelatorioconfiguravel',wval) and (wval<>'null') then
              ParamByName('xmeurelatorioconfiguravel').AsString := XPessoa.GetValue('meurelatorioconfiguravel').Value;
           if XPessoa.TryGetValue('ehoftalmo',wval) then
              ParamByName('xehoftalmo').AsBoolean           := strtobooldef(XPessoa.GetValue('ehoftalmo').Value,false);
           if XPessoa.TryGetValue('idperfilpermissao',wval) and (wval<>'0') then
              ParamByName('xidperfilpermissao').AsInteger       := strtointdef(XPessoa.GetValue('idperfilpermissao').Value,0);
           if XPessoa.TryGetValue('datainicialpermissao',wval) then
              ParamByName('xdatainicialpermissao').AsDate       := strtodatedef(XPessoa.GetValue('datainicialpermissao').Value,0);
           if XPessoa.TryGetValue('datafinalpermissao',wval) then
              ParamByName('xdatafinalpermissao').AsDate       := strtodatedef(XPessoa.GetValue('datafinalpermissao').Value,0);
           if XPessoa.TryGetValue('ehsuperusuario',wval) then
              ParamByName('xehsuperusuario').AsBoolean           := strtobooldef(XPessoa.GetValue('ehsuperusuario').Value,false);
           if XPessoa.TryGetValue('senhasuperusuario',wval) and (wval<>'null') then
              ParamByName('xsenhasuperusuario').AsString         := XPessoa.GetValue('senhasuperusuario').Value;
           if XPessoa.TryGetValue('ehrepresentantesupervisor',wval) then
              ParamByName('xehrepresentantesupervisor').AsBoolean  := strtobooldef(XPessoa.GetValue('ehrepresentantesupervisor').Value,false);
           if XPessoa.TryGetValue('dataingressofidelidade',wval) then
              ParamByName('xdataingressofidelidade').AsDate       := strtodatedef(XPessoa.GetValue('dataingressofidelidade').Value,0);
           if XPessoa.TryGetValue('ehprecadastro',wval) then
              ParamByName('xehprecadastro').AsBoolean  := strtobooldef(XPessoa.GetValue('ehprecadastro').Value,false);
           if XPessoa.TryGetValue('observacaodiversa',wval) and (wval<>'null') then
              ParamByName('xobservacaodiversa').AsString         := XPessoa.GetValue('observacaodiversa').Value;
           if XPessoa.TryGetValue('hostemail',wval) and (wval<>'null') then
              ParamByName('xhostemail').AsString                 := XPessoa.GetValue('hostemail').Value;
           if XPessoa.TryGetValue('portahostemail',wval) then
              ParamByName('xportahostemail').AsInteger           := strtointdef(XPessoa.GetValue('portahostemail').Value,0);
           if XPessoa.TryGetValue('senhahostemail',wval) and (wval<>'null') then
              ParamByName('xsenhahostemail').AsString            := XPessoa.GetValue('senhahostemail').Value;
           if XPessoa.TryGetValue('nomeremetenteemail',wval) and (wval<>'null') then
              ParamByName('xnomeremetenteemail').AsString        := XPessoa.GetValue('nomeremetenteemail').Value;
           if XPessoa.TryGetValue('mensagemfinalemail',wval) and (wval<>'null') then
              ParamByName('xmensagemfinalemail').AsString        := XPessoa.GetValue('mensagemfinalemail').Value;
           if XPessoa.TryGetValue('requerautenticacaoemail',wval) then
              ParamByName('xrequerautenticacaoemail').AsBoolean  := strtobooldef(XPessoa.GetValue('requerautenticacaoemail').Value,false);
           if XPessoa.TryGetValue('confirmacaoleituraemail',wval) then
              ParamByName('xconfirmacaoleituraemail').AsBoolean  := strtobooldef(XPessoa.GetValue('confirmacaoleituraemail').Value,false);
           if XPessoa.TryGetValue('copiaremetenteemail',wval) then
              ParamByName('xcopiaremetenteemail').AsBoolean      := strtobooldef(XPessoa.GetValue('copiaremetenteemail').Value,false);
           if XPessoa.TryGetValue('prioridadeemail',wval) and (wval<>'null') then
              ParamByName('xprioridadeemail').AsString           := XPessoa.GetValue('prioridadeemail').Value;
           if XPessoa.TryGetValue('geraremessa',wval) then
              ParamByName('xgeraremessa').AsBoolean              := strtobooldef(XPessoa.GetValue('geraremessa').Value,false);
           if XPessoa.TryGetValue('idempresafuncionario',wval) and (wval<>'0') then
              ParamByName('xidempresafuncionario').AsInteger     := strtointdef(XPessoa.GetValue('idempresafuncionario').Value,0);
           if XPessoa.TryGetValue('suframa',wval) and (wval<>'null') then
              ParamByName('xsuframa').AsString                   := XPessoa.GetValue('suframa').Value;
           if XPessoa.TryGetValue('enderecocobranca',wval) and (wval<>'null') then
              ParamByName('xenderecocobranca').AsString          := XPessoa.GetValue('enderecocobranca').Value;
           if XPessoa.TryGetValue('complementocobranca',wval) and (wval<>'null') then
              ParamByName('xcomplementocobranca').AsString       := XPessoa.GetValue('complementocobranca').Value;
           if XPessoa.TryGetValue('bairrocobranca',wval) and (wval<>'null') then
              ParamByName('xbairrocobranca').AsString            := XPessoa.GetValue('bairrocobranca').Value;
           if XPessoa.TryGetValue('idlocalidadecobranca',wval) and (wval<>'0') then
              ParamByName('xidlocalidadecobranca').AsInteger     := strtointdef(XPessoa.GetValue('idlocalidadecobranca').Value,0);
           if XPessoa.TryGetValue('cepcobranca',wval) and (wval<>'null') then
              ParamByName('xcepcobranca').AsString               := XPessoa.GetValue('cepcobranca').Value;
           if XPessoa.TryGetValue('telefonecobranca',wval) and (wval<>'null') then
              ParamByName('xtelefonecobranca').AsString          := XPessoa.GetValue('telefonecobranca').Value;
           if XPessoa.TryGetValue('templatebiometrico',wval) and (wval<>'null') then
              ParamByName('xtemplatebiometrico').AsString        := XPessoa.GetValue('templatebiometrico').Value;
           if XPessoa.TryGetValue('idcontadebito',wval) and (wval<>'0') then
              ParamByName('xidcontadebito').AsInteger            := strtointdef(XPessoa.GetValue('idcontadebito').Value,0);
           if XPessoa.TryGetValue('idcontacredito',wval) and (wval<>'0') then
              ParamByName('xidcontacredito').AsInteger           := strtointdef(XPessoa.GetValue('idcontacredito').Value,0);
           if XPessoa.TryGetValue('habilitarcalculoretencao',wval) then
              ParamByName('xhabilitarcalculoretencao').AsBoolean := strtobooldef(XPessoa.GetValue('habilitarcalculoretencao').Value,false);
           if XPessoa.TryGetValue('inscricaomunicipal',wval) and (wval<>'null') then
              ParamByName('xinscricaomunicipal').AsString        := XPessoa.GetValue('inscricaomunicipal').Value;
           if XPessoa.TryGetValue('possuiconfiguracaoini',wval) then
              ParamByName('xpossuiconfiguracaoini').AsBoolean    := strtobooldef(XPessoa.GetValue('possuiconfiguracaoini').Value,false);
           if XPessoa.TryGetValue('valorfaturar',wval) then
              ParamByName('xvalorfaturar').AsFloat               := strtofloatdef(XPessoa.GetValue('valorfaturar').Value,0);
           if XPessoa.TryGetValue('site',wval) and (wval<>'null') then
              ParamByName('xsite').AsString                      := XPessoa.GetValue('site').Value;
           if XPessoa.TryGetValue('naogeraremessa',wval) then
              ParamByName('xnaogeraremessa').AsBoolean           := strtobooldef(XPessoa.GetValue('naogeraremessa').Value,false);
           if XPessoa.TryGetValue('ehrepresentantemobile',wval) then
              ParamByName('xehrepresentantemobile').AsBoolean    := strtobooldef(XPessoa.GetValue('ehrepresentantemobile').Value,false);
           if XPessoa.TryGetValue('dataenvio',wval) then
              ParamByName('xdataenvio').AsDate                   := strtodatedef(XPessoa.GetValue('dataenvio').Value,0);
           if XPessoa.TryGetValue('identificadorinscricaoestadual',wval) and (wval<>'null') then
              ParamByName('xidentificadorinscricaoestadual').AsString := XPessoa.GetValue('identificadorinscricaoestadual').Value;
           if XPessoa.TryGetValue('aceitadevolucao',wval) then
              ParamByName('xaceitadevolucao').AsBoolean          := strtobooldef(XPessoa.GetValue('aceitadevolucao').Value,false);
           if XPessoa.TryGetValue('tlsexplicitoemail',wval) then
              ParamByName('xtlsexplicitoemail').AsBoolean          := strtobooldef(XPessoa.GetValue('tlsexplicitoemail').Value,false);
           if XPessoa.TryGetValue('inscricaoestadualsubstituto',wval) and (wval<>'null') then
              ParamByName('xinscricaoestadualsubstituto').AsString := XPessoa.GetValue('inscricaoestadualsubstituto').Value;
           if XPessoa.TryGetValue('emailcobranca',wval) and (wval<>'null') then
              ParamByName('xemailcobranca').AsString := XPessoa.GetValue('emailcobranca').Value;
           if XPessoa.TryGetValue('ehclienterevenda',wval) then
              ParamByName('xehclienterevenda').AsBoolean          := strtobooldef(XPessoa.GetValue('ehclienterevenda').Value,false);
           if XPessoa.TryGetValue('participantereidi',wval) then
              ParamByName('xparticipantereidi').AsBoolean         := strtobooldef(XPessoa.GetValue('participantereidi').Value,false);
           if XPessoa.TryGetValue('aceitafracionarbancario',wval) then
              ParamByName('xaceitafracionarbancario').AsBoolean   := strtobooldef(XPessoa.GetValue('aceitafracionarbancario').Value,false);
           if XPessoa.TryGetValue('aceitatransferenciabancario',wval) then
              ParamByName('xaceitatransferenciabancario').AsBoolean   := strtobooldef(XPessoa.GetValue('aceitatransferenciabancario').Value,false);
           ExecSQL;
           EnableControls;
           wnum := RowsAffected;
         end;

         wquerySelect := TFDQuery.Create(nil);

         if wnum>0 then
            with wquerySelect do
            begin
              Connection := wconexao.FDConnectionApi;
              DisableControls;
              Close;
              SQL.Clear;
              Params.Clear;
              SQL.Add('select  "CodigoInternoPessoa"       as id,');
              SQL.Add('        "CodigoPessoa"              as codigo,');
              SQL.Add('        "NomePessoa"                as nome,');
              SQL.Add('        "EhPessoaFisica"            as ehfisica,');
              SQL.Add('        "CodigoAtividadePessoa"     as idatividade,');
              SQL.Add('        "CodigoContabilPessoa"      as idcontabil,');
              SQL.Add('        "ContaCorrentePessoa"       as ctacorrente,');
              SQL.Add('        "CodigoCobrancaPessoa"      as idcobranca,');
              SQL.Add('        "CodigoRepresentantePessoa" as idrepresentante,');
              SQL.Add('        "CodigoBancoPessoa"         as idbanco,');
              SQL.Add('        "ObservacaoPessoa"          as observacao,');
              SQL.Add('        "EhClientePessoa"           as ehcliente,');
              SQL.Add('        "EhFornecedorPessoa"        as ehfornecedor,');
              SQL.Add('        "EhEmpresaPessoa"           as ehempresa,');
              SQL.Add('        "EhBancoPessoa"             as ehbanco,');
              SQL.Add('        "EhRepresentantePessoa"     as ehrepresentante,');
              SQL.Add('        "EhTransportadoraPessoa"    as ehtransportador,');
              SQL.Add('        "EhConvenioPessoa"          as ehconvenio,');
              SQL.Add('        "EhFuncionarioPessoa"       as ehfuncionario,');
              SQL.Add('        "ContatoPessoa"             as contato,');
              SQL.Add('        "DataCadastramentoPessoa"   as datacadastramento,');
              SQL.Add('        "EntregaEnderecoPessoa"     as endereco,');
              SQL.Add('        "EntregaComplementoPessoa"  as complemento,');
              SQL.Add('        "EntregaBairroPessoa"       as bairro,');
              SQL.Add('        "EntregaCodigoCidadePessoa" as idlocalidade,');
              SQL.Add('        "EntregaCepPessoa"          as cep,');
              SQL.Add('        "EntregaTelefonePessoa"     as telefone,');
              SQL.Add('        "EntregaFaxPessoa"          as fax,');
              SQL.Add('        "CodigoAlvoPessoa"          as idalvo,');
              SQL.Add('        "InscricaoEstadualPessoa"   as inscricaoestadual,');
              SQL.Add('        "CgcPessoa"                 as cnpj,');
              SQL.Add('        "IdentidadePessoa"          as rg,');
              SQL.Add('        "CicPessoa"                 as cpf,');
              SQL.Add('        "SexoPessoa"                as sexo,');
              SQL.Add('        "DataNascimentoPessoa"      as datanascimento,');
              SQL.Add('        "EstadoCivilPessoa"         as estadocivil,');
              SQL.Add('        "NomePaiPessoa"             as nomepai,');
              SQL.Add('        "NomeMaePessoa"             as nomemae,');
              SQL.Add('        "NomeEmpresaPessoa"         as nomeempresa,');
              SQL.Add('        "CodigoCargoPessoa"         as codcargo,');
              SQL.Add('        "EnderecoTrabalhoPessoa"    as enderecotrabalho,');
              SQL.Add('        "BairroTrabalhoPessoa"      as bairrotrabalho,');
              SQL.Add('        "CEPTrabalhoPessoa"         as ceptrabalho,');
              SQL.Add('        "TelefoneTrabalhoPessoa"    as telefonetrabalho,');
              SQL.Add('        "SalarioPessoa"             as salario,');
              SQL.Add('        "SenhaPessoa"               as senha,');
              SQL.Add('        "VerificaDebitosPessoa"     as verificadebitos,');
              SQL.Add('        "NomeConjugePessoa"         as nomeconjuge,');
              SQL.Add('        "NomeEmpresaConjugePessoa"  as nomeempresaconjuge,');
              SQL.Add('        "CodigoAtividadeConjugePessoa" as idatividadeconjuge,');
              SQL.Add('        "DataNascimentoConjugePessoa"  as datanascimentoconjuge,');
              SQL.Add('        "SalarioConjugePessoa"         as salarioconjuge,');
              SQL.Add('        "NomeDiretor1Pessoa"           as nomediretor1empresa,');
              SQL.Add('        "NomeDiretor2Pessoa"           as nomediretor2empresa,');
              SQL.Add('        "DataFundacaoEmpresaPessoa"    as datafundacaoempresa,');
              SQL.Add('        "ReferenciaComercial1Pessoa"   as referenciacomercial1,');
              SQL.Add('        "ReferenciaComercial2Pessoa"   as referenciacomercial2,');
              SQL.Add('        "NaturalidadePessoa"           as idnaturalidade,');
              SQL.Add('        "LimiteCreditoPessoa"          as limitecredito,');
              SQL.Add('        "DigitoBancoPessoa"            as digitobanco,');
              SQL.Add('        "EhSupervisorPessoa"           as ehsupervisor,');
              SQL.Add('        "EhUsuarioPessoa"              as ehusuario,');
              SQL.Add('        "EhOperadorPessoa"             as ehoperador,');
              SQL.Add('        "AgenciaBancoPessoa"           as agenciabanco,');
              SQL.Add('        "PercentualComissaoPessoa"     as perccomissao,');
              SQL.Add('        "DataUltimaAlteracao"          as dataultimaalteracao,');
              SQL.Add('        "EhMedicoPessoa"               as ehmedico,');
              SQL.Add('        "AtivoPessoa"                  as ativo,');
              SQL.Add('        "CodigoTabelaPrecoPessoa"      as idtabelapreco,');
              SQL.Add('        "CodigoCondicaoPessoa"         as idcondicao,');
              SQL.Add('        "EntregaEmailPessoa"           as email,');
              SQL.Add('        "EntregaCaixaPostalPessoa"     as caixapostal,');
              SQL.Add('        "CaminhoFotoPessoa"            as caminhofoto,');
              SQL.Add('        "CreditoPessoa"                as credito,');
              SQL.Add('        "NomeFantasiaPessoa"           as nomefantasia,');
              SQL.Add('        "PercentualDescontoPessoa"     as percdesconto,');
              SQL.Add('        "PrazoCondicaoPessoa"          as prazocondicao,');
              SQL.Add('        "EmiteEtiquetaPessoa"          as emiteetiqueta,');
              SQL.Add('        "MeuRelatorioConfiguravelPessoa" as meurelatorioconfiguravel,');
              SQL.Add('        "EhOftalmoPessoa"              as ehoftalmo,');
              SQL.Add('        "PerfilPermissaoPessoa"        as idperfilpermissao,');
              SQL.Add('        "DataPermissaoInicialPessoa"   as datainicialpermissao,');
              SQL.Add('        "DataPermissaoFinalPessoa"     as datafinalpermissao,');
              SQL.Add('        "EhSuperUsuarioPessoa"         as ehsuperusuario,');
              SQL.Add('        "SenhaSuperUsuarioPessoa"      as senhasuperusuario,');
              SQL.Add('        "EhRepresentanteSupervisorPessoa" as ehrepresentantesupervisor,');
              SQL.Add('        "DataIngressoFidelidadePessoa"    as dataingressofidelidade,');
              SQL.Add('        "PreCadastroPessoa"               as ehprecadastro,');
              SQL.Add('        "ObservacaoDiversaPessoa"         as observacaodiversa,');
              SQL.Add('        "HostEmailPessoa"                 as hostemail,');
              SQL.Add('        "PortaHostPessoa"                 as portahostemail,');
              SQL.Add('        "SenhaHostPessoa"                 as senhahostemail,');
              SQL.Add('        "NomeRemetenteEmailPessoa"        as nomeremetenteemail,');
              SQL.Add('        "MensagemFinalEmailPessoa"        as mensagemfinalemail,');
              SQL.Add('        "RequerAutenticacaoEmailPessoa"   as requerautenticacaoemail,');
              SQL.Add('        "ConfirmacaoLeituraEmailPessoa"   as confirmacaoleituraemail,');
              SQL.Add('        "CopiaEmailRemetentePessoa"       as copiarementeemail,');
              SQL.Add('        "PrioridadeEmailPessoa"           as prioridadeemail,');
              SQL.Add('        "GerarRemessaPessoa"              as geraremessa,');
              SQL.Add('        "CodigoEmpresaFuncionarioPessoa"  as idempresafuncionario,');
              SQL.Add('        "InscricaoSuframaPessoa"          as suframa,');
              SQL.Add('        "CobrancaEnderecoPessoa"          as enderecocobranca,');
              SQL.Add('        "CobrancaComplementoPessoa"       as complementocobranca,');
              SQL.Add('        "CobrancaBairroPessoa"            as bairrocobranca,');
              SQL.Add('        "CobrancaCodigoCidadePessoa"      as idlocalidadecobranca,');
              SQL.Add('        "CobrancaCepPessoa"               as cepcobranca,');
              SQL.Add('        "CobrancaTelefonePessoa"          as telefonecobranca,');
              SQL.Add('        "TemplateBiometricoPessoa"        as templatebiometrico,');
              SQL.Add('        "ContaDebitoPessoa"               as idcontadebito,');
              SQL.Add('        "ContaCreditoPessoa"              as idcontacredito,');
              SQL.Add('        "HabilitarCalculoRetencaoParcelasPessoa" as habilitarcalculoretencao,');
              SQL.Add('        "InscricaoMunicipalPessoa"        as inscricaomunicipal,');
              SQL.Add('        "PossuiConfiguracaoIniPessoa"     as possuiconfiguracaoini,');
              SQL.Add('        "ValorFaturarPessoa"              as valorfaturar,');
              SQL.Add('        "SitePessoa"                      as site,');
              SQL.Add('        "NaoGerarRemessaPessoa"           as naogeraremessa,');
              SQL.Add('        "EhRepresentanteMobilePessoa"     as ehrepresentantemobile,');
              SQL.Add('        "DataEnvioPessoa"                 as dataenvio,');
              SQL.Add('        "IdentificadorIEPessoa"           as identificadorinscricaoestadual,');
              SQL.Add('        "AceitaDevolucaoPessoa"           as aceitadevolucao,');
              SQL.Add('        "UseTlsExplicitEmailPessoa"       as tlsexplicitoemail,');
              SQL.Add('        "InscricaoEstadualSubstitutoPessoa" as inscricaoestadualsubstituto,');
              SQL.Add('        "CobrancaEmailPessoa"             as emailcobranca,');
              SQL.Add('        "EhClienteRevenda"                as ehclienterevenda,');
              SQL.Add('        "ParticipanteREIDIPessoa"         as participantereidi,');
              SQL.Add('        "AceitaFracionarBancarioPessoa"   as aceitafracionarbancario,');
              SQL.Add('        "AceitaTransferenciaBancarioPessoa" as aceitatransferenciabancario ');
              SQL.Add('from "PessoaGeral" ');
              SQL.Add('where "CodigoInternoPessoa" =:xid ');
              ParamByName('xid').AsInteger := XIdPessoa;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Pessoa alterada');
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
       end;

    wret   := wquerySelect.ToJSONObject();
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao alterar Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

function VerificaRequisicao(XPessoa: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XPessoa.TryGetValue('codigo',wval) then
       wret := false;
    if not XPessoa.TryGetValue('nome',wval) then
       wret := false;
    if not XPessoa.TryGetValue('idatividade',wval) then
       wret := false;
    if not XPessoa.TryGetValue('idlocalidade',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaPessoa(XIdPessoa: integer): TJSONObject;
var wret: TJSONObject;
    wconexao: TProviderDataModuleConexao;
    wqueryDelete: TFDQuery;
    wnum: integer;
begin
  try
    wret         := TJSONObject.Create;
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryDelete := TFDQuery.Create(nil);

    if wconexao.EstabeleceConexaoDB then
       with wqueryDelete do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('delete from "PessoaGeral" where "CodigoInternoPessoa"=:xid ');
         ParamByName('xid').AsInteger := XIdPessoa;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Pessoa excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Pessoa excluída');
       end;
    wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao excluir Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;
end.

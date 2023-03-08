unit dat.cadOrigens;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaOrigem(XIdOrigem: integer): TJSONObject;
function RetornaListaOrigens(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiOrigem(XOrigem: TJSONObject; XIdEmpresa: integer): TJSONObject;
function AlteraOrigem(XIdOrigem: integer; XOrigem: TJSONObject): TJSONObject;
function ApagaOrigem(XIdOrigem: integer): TJSONObject;
function VerificaRequisicao(XOrigem: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaOrigem(XIdOrigem: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoOrigem"        as id,');
         SQL.Add('        "EmpresaAtividadeOrigem"     as idempresaatividade,');
         SQL.Add('        "EmpresaLocalidadeOrigem"    as idempresalocalidade,');
         SQL.Add('        "EmpresaPessoaOrigem"        as idempresapessoa,');
         SQL.Add('        "EmpresaSetorOrigem"         as idempresasetor,');
         SQL.Add('        "EmpresaPlanoEstoqueOrigem"  as idempresaplanoestoque,');
         SQL.Add('        "EmpresaNumerarioOrigem"     as idempresanumerario,');
         SQL.Add('        "EmpresaClassificacaoOrigem" as idempresaclassificacao,');
         SQL.Add('        "EmpresaOcorrenciaOrigem"    as idempresaocorrencia,');
         SQL.Add('        "EmpresaCondicaoOrigem"      as idempresacondicao,');
         SQL.Add('        "EmpresaProdutoOrigem"       as idempresaproduto,');
         SQL.Add('        "EmpresaFabricanteOrigem"    as idempresafabricante,');
         SQL.Add('        "EmpresaSituacaoTributariaOrigem" as idempresasituacaotributaria,');
         SQL.Add('        "EmpresaAliquotaOrigem"      as idempresaaliquota,');
         SQL.Add('        "EmpresaFormulaOrigem"       as idempresaformula,');
         SQL.Add('        "EmpresaGradeOrigem"         as idempresagrade,');
         SQL.Add('        "EmpresaCorOrigem"           as idempresacor,');
         SQL.Add('        "EmpresaCodigoFiscalOrigem"  as idempresacodigofiscal,');
         SQL.Add('        "EmpresaCobrancaOrigem"      as idempresacobranca,');
         SQL.Add('        "EmpresaOperacaoOrigem"      as idempresaoperacao,');
         SQL.Add('        "EmpresaValidacaoOrigem"     as idempresavalidacao,');
         SQL.Add('        "EmpresaIndexadorOrigem"     as idempresaindexador,');
         SQL.Add('        "EmpresaDescontoOrigem"      as idempresadesconto,');
         SQL.Add('        "EmpresaTipoLente"           as idempresatipolente,');
         SQL.Add('        "EmpresaIdentificadorOrigem" as idempresaidentificador,');
         SQL.Add('        "EmpresaHistoricoPadraoOrigem" as idempresahistorico,');
         SQL.Add('        "EmpresaPlanoContasOrigem"   as idempresaplanocontas,');
         SQL.Add('        "EmpresaProdutoPrecoOrigem"  as idempresaprodutopreco,');
         SQL.Add('        "EmpresaCategoriaOrigem"     as idempresacategoria,');
         SQL.Add('        "EmpresaTabelaPrecoOrigem"   as idempresatabelapreco,');
         SQL.Add('        "EmpresaFamiliaOrigem"       as idempresafamilia ');
         SQL.Add('from "Origem" ');
         SQL.Add('where "CodigoInternoOrigem"=:xid ');
         ParamByName('xid').AsInteger := XIdOrigem;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma Origem encontrada');
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

function RetornaListaOrigens(const XQuery: TDictionary<string, string>): TJSONArray;
var wqueryLista: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
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
         SQL.Add('select  "CodigoInternoOrigem"        as id,');
         SQL.Add('        "EmpresaAtividadeOrigem"     as idempresaatividade,');
         SQL.Add('        "EmpresaLocalidadeOrigem"    as idempresalocalidade,');
         SQL.Add('        "EmpresaPessoaOrigem"        as idempresapessoa,');
         SQL.Add('        "EmpresaSetorOrigem"         as idempresasetor,');
         SQL.Add('        "EmpresaPlanoEstoqueOrigem"  as idempresaplanoestoque,');
         SQL.Add('        "EmpresaNumerarioOrigem"     as idempresanumerario,');
         SQL.Add('        "EmpresaClassificacaoOrigem" as idempresaclassificacao,');
         SQL.Add('        "EmpresaOcorrenciaOrigem"    as idempresaocorrencia,');
         SQL.Add('        "EmpresaCondicaoOrigem"      as idempresacondicao,');
         SQL.Add('        "EmpresaProdutoOrigem"       as idempresaproduto,');
         SQL.Add('        "EmpresaFabricanteOrigem"    as idempresafabricante,');
         SQL.Add('        "EmpresaSituacaoTributariaOrigem" as idempresasituacaotributaria,');
         SQL.Add('        "EmpresaAliquotaOrigem"      as idempresaaliquota,');
         SQL.Add('        "EmpresaFormulaOrigem"       as idempresaformula,');
         SQL.Add('        "EmpresaGradeOrigem"         as idempresagrade,');
         SQL.Add('        "EmpresaCorOrigem"           as idempresacor,');
         SQL.Add('        "EmpresaCodigoFiscalOrigem"  as idempresacodigofiscal,');
         SQL.Add('        "EmpresaCobrancaOrigem"      as idempresacobranca,');
         SQL.Add('        "EmpresaOperacaoOrigem"      as idempresaoperacao,');
         SQL.Add('        "EmpresaValidacaoOrigem"     as idempresavalidacao,');
         SQL.Add('        "EmpresaIndexadorOrigem"     as idempresaindexador,');
         SQL.Add('        "EmpresaDescontoOrigem"      as idempresadesconto,');
         SQL.Add('        "EmpresaTipoLente"           as idempresatipolente,');
         SQL.Add('        "EmpresaIdentificadorOrigem" as idempresaidentificador,');
         SQL.Add('        "EmpresaHistoricoPadraoOrigem" as idempresahistorico,');
         SQL.Add('        "EmpresaPlanoContasOrigem"   as idempresaplanocontas,');
         SQL.Add('        "EmpresaProdutoPrecoOrigem"  as idempresaprodutopreco,');
         SQL.Add('        "EmpresaCategoriaOrigem"     as idempresacategoria,');
         SQL.Add('        "EmpresaTabelaPrecoOrigem"   as idempresatabelapreco,');
         SQL.Add('        "EmpresaFamiliaOrigem"       as idempresafamilia ');
         SQL.Add('from "Origem" ');
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Origem encontrada');
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

function IncluiOrigem(XOrigem: TJSONObject; XIdEmpresa: integer): TJSONObject;
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
           SQL.Add('Insert into "Origem" ("CodigoEmpresaOrigem","EmpresaAtividadeOrigem","EmpresaLocalidadeOrigem","EmpresaPessoaOrigem",');
           SQL.Add('"EmpresaSetorOrigem","EmpresaPlanoEstoqueOrigem","EmpresaNumerarioOrigem","EmpresaClassificacaoOrigem","EmpresaOcorrenciaOrigem",');
           SQL.Add('"EmpresaCondicaoOrigem","EmpresaProdutoOrigem","EmpresaFabricanteOrigem","EmpresaSituacaoTributariaOrigem","EmpresaAliquotaOrigem",');
           SQL.Add('"EmpresaFormulaOrigem","EmpresaGradeOrigem","EmpresaCorOrigem","EmpresaCodigoFiscalOrigem","EmpresaCobrancaOrigem",');
           SQL.Add('"EmpresaOperacaoOrigem","EmpresaValidacaoOrigem","EmpresaIndexadorOrigem","EmpresaDescontoOrigem","EmpresaTipoLente",');
           SQL.Add('"EmpresaIdentificadorOrigem","EmpresaHistoricoPadraoOrigem","EmpresaPlanoContasOrigem","EmpresaProdutoPrecoOrigem",');
           SQL.Add('"EmpresaCategoriaOrigem","EmpresaTabelaPrecoOrigem","EmpresaFamiliaOrigem") ');
           SQL.Add('values (:xidempresa,:xidempresaatividade,:xidempresalocalidade,:xidempresapessoa,');
           SQL.Add(':xidempresasetor,:xidempresaplanoestoque,:xidempresanumerario,:xidempresaclassificacao,:xidempresaocorrencia,');
           SQL.Add(':xidempresacondicao,:xidempresaproduto,:xidempresafabricante,:xidempresasituacaotributaria,:xidempresaaliquota,');
           SQL.Add(':xidempresaformula,:xidempresagrade,:xidempresacor,:xidempresacodigofiscal,:xidempresacobranca,');
           SQL.Add(':xidempresaoperacao,:xidempresavalidacao,:xidempresaindexador,:xidempresadesconto,:xidempresatipolente,');
           SQL.Add(':xidempresaidentificador,:xidempresahistorico,:xidempresaplanocontas,:xidempresaprodutopreco,');
           SQL.Add(':xidempresacategoria,:xidempresatabelapreco,:xidempresafamilia) ');
           ParamByName('xidempresa').AsInteger   := XIdEmpresa;
           if XOrigem.TryGetValue('idempresaatividade',wval) then
              ParamByName('xidempresaatividade').AsInteger := strtointdef(XOrigem.GetValue('idempresaatividade').Value,0)
           else
              ParamByName('xidempresaatividade').AsInteger := 0;
           if XOrigem.TryGetValue('idempresalocalidade',wval) then
              ParamByName('xidempresalocalidade').AsInteger := strtointdef(XOrigem.GetValue('idempresalocalidade').Value,0)
           else
              ParamByName('xidempresalocalidade').AsInteger := 0;
           if XOrigem.TryGetValue('idempresapessoa',wval) then
              ParamByName('xidempresapessoa').AsInteger := strtointdef(XOrigem.GetValue('idempresapessoa').Value,0)
           else
              ParamByName('xidempresapessoa').AsInteger := 0;
           if XOrigem.TryGetValue('idempresasetor',wval) then
              ParamByName('xidempresasetor').AsInteger := strtointdef(XOrigem.GetValue('idempresasetor').Value,0)
           else
              ParamByName('xidempresasetor').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaplanoestoque',wval) then
              ParamByName('xidempresaplanoestoque').AsInteger := strtointdef(XOrigem.GetValue('idempresaplanoestoque').Value,0)
           else
              ParamByName('xidempresaplanoestoque').AsInteger := 0;
           if XOrigem.TryGetValue('idempresanumerario',wval) then
              ParamByName('xidempresanumerario').AsInteger := strtointdef(XOrigem.GetValue('idempresanumerario').Value,0)
           else
              ParamByName('xidempresanumerario').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaclassificacao',wval) then
              ParamByName('xidempresaclassificacao').AsInteger := strtointdef(XOrigem.GetValue('idempresaclassificacao').Value,0)
           else
              ParamByName('xidempresaclassificacao').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaocorrencia',wval) then
              ParamByName('xidempresaocorrencia').AsInteger := strtointdef(XOrigem.GetValue('idempresaocorrencia').Value,0)
           else
              ParamByName('xidempresaocorrencia').AsInteger := 0;
           if XOrigem.TryGetValue('idempresacondicao',wval) then
              ParamByName('xidempresacondicao').AsInteger := strtointdef(XOrigem.GetValue('idempresacondicao').Value,0)
           else
              ParamByName('xidempresacondicao').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaproduto',wval) then
              ParamByName('xidempresaproduto').AsInteger := strtointdef(XOrigem.GetValue('idempresaproduto').Value,0)
           else
              ParamByName('xidempresaproduto').AsInteger := 0;
           if XOrigem.TryGetValue('idempresafabricante',wval) then
              ParamByName('xidempresafabricante').AsInteger := strtointdef(XOrigem.GetValue('idempresafabricante').Value,0)
           else
              ParamByName('xidempresafabricante').AsInteger := 0;
           if XOrigem.TryGetValue('idempresasituacaotributaria',wval) then
              ParamByName('xidempresasituacaotributaria').AsInteger := strtointdef(XOrigem.GetValue('idempresasituacaotributaria').Value,0)
           else
              ParamByName('xidempresasituacaotributaria').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaaliquota',wval) then
              ParamByName('xidempresaaliquota').AsInteger := strtointdef(XOrigem.GetValue('idempresaaliquota').Value,0)
           else
              ParamByName('xidempresaaliquota').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaformula',wval) then
              ParamByName('xidempresaformula').AsInteger := strtointdef(XOrigem.GetValue('idempresaformula').Value,0)
           else
              ParamByName('xidempresaformula').AsInteger := 0;
           if XOrigem.TryGetValue('idempresagrade',wval) then
              ParamByName('xidempresagrade').AsInteger := strtointdef(XOrigem.GetValue('idempresagrade').Value,0)
           else
              ParamByName('xidempresagrade').AsInteger := 0;
           if XOrigem.TryGetValue('idempresacor',wval) then
              ParamByName('xidempresacor').AsInteger := strtointdef(XOrigem.GetValue('idempresacor').Value,0)
           else
              ParamByName('xidempresacor').AsInteger := 0;
           if XOrigem.TryGetValue('idempresacodigofiscal',wval) then
              ParamByName('xidempresacodigofiscal').AsInteger := strtointdef(XOrigem.GetValue('idempresacodigofiscal').Value,0)
           else
              ParamByName('xidempresacodigofiscal').AsInteger := 0;
           if XOrigem.TryGetValue('idempresacobranca',wval) then
              ParamByName('xidempresacobranca').AsInteger := strtointdef(XOrigem.GetValue('idempresacobranca').Value,0)
           else
              ParamByName('xidempresacobranca').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaoperacao',wval) then
              ParamByName('xidempresaoperacao').AsInteger := strtointdef(XOrigem.GetValue('idempresaoperacao').Value,0)
           else
              ParamByName('xidempresaoperacao').AsInteger := 0;
           if XOrigem.TryGetValue('idempresavalidacao',wval) then
              ParamByName('xidempresavalidacao').AsInteger := strtointdef(XOrigem.GetValue('idempresavalidacao').Value,0)
           else
              ParamByName('xidempresavalidacao').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaindexador',wval) then
              ParamByName('xidempresaindexador').AsInteger := strtointdef(XOrigem.GetValue('idempresaindexador').Value,0)
           else
              ParamByName('xidempresaindexador').AsInteger := 0;
           if XOrigem.TryGetValue('idempresadesconto',wval) then
              ParamByName('xidempresadesconto').AsInteger := strtointdef(XOrigem.GetValue('idempresadesconto').Value,0)
           else
              ParamByName('xidempresadesconto').AsInteger := 0;
           if XOrigem.TryGetValue('idempresatipolente',wval) then
              ParamByName('xidempresatipolente').AsInteger := strtointdef(XOrigem.GetValue('idempresatipolente').Value,0)
           else
              ParamByName('xidempresatipolente').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaidentificador',wval) then
              ParamByName('xidempresaidentificador').AsInteger := strtointdef(XOrigem.GetValue('idempresaidentificador').Value,0)
           else
              ParamByName('xidempresaidentificador').AsInteger := 0;
           if XOrigem.TryGetValue('idempresahistorico',wval) then
              ParamByName('xidempresahistorico').AsInteger := strtointdef(XOrigem.GetValue('idempresahistorico').Value,0)
           else
              ParamByName('xidempresahistorico').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaplanocontas',wval) then
              ParamByName('xidempresaplanocontas').AsInteger := strtointdef(XOrigem.GetValue('idempresaplanocontas').Value,0)
           else
              ParamByName('xidempresaplanocontas').AsInteger := 0;
           if XOrigem.TryGetValue('idempresaprodutopreco',wval) then
              ParamByName('xidempresaprodutopreco').AsInteger := strtointdef(XOrigem.GetValue('idempresaprodutopreco').Value,0)
           else
              ParamByName('xidempresaprodutopreco').AsInteger := 0;
           if XOrigem.TryGetValue('idempresacategoria',wval) then
              ParamByName('xidempresacategoria').AsInteger := strtointdef(XOrigem.GetValue('idempresacategoria').Value,0)
           else
              ParamByName('xidempresacategoria').AsInteger := 0;
           if XOrigem.TryGetValue('idempresatabelapreco',wval) then
              ParamByName('xidempresatabelapreco').AsInteger := strtointdef(XOrigem.GetValue('idempresatabelapreco').Value,0)
           else
              ParamByName('xidempresatabelapreco').AsInteger := 0;
           if XOrigem.TryGetValue('idempresafamilia',wval) then
              ParamByName('xidempresafamilia').AsInteger := strtointdef(XOrigem.GetValue('idempresafamilia').Value,0)
           else
              ParamByName('xidempresafamilia').AsInteger := 0;
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
                SQL.Add('select  "CodigoInternoOrigem"        as id,');
                SQL.Add('        "EmpresaAtividadeOrigem"     as idempresaatividade,');
                SQL.Add('        "EmpresaLocalidadeOrigem"    as idempresalocalidade,');
                SQL.Add('        "EmpresaPessoaOrigem"        as idempresapessoa,');
                SQL.Add('        "EmpresaSetorOrigem"         as idempresasetor,');
                SQL.Add('        "EmpresaPlanoEstoqueOrigem"  as idempresaplanoestoque,');
                SQL.Add('        "EmpresaNumerarioOrigem"     as idempresanumerario,');
                SQL.Add('        "EmpresaClassificacaoOrigem" as idempresaclassificacao,');
                SQL.Add('        "EmpresaOcorrenciaOrigem"    as idempresaocorrencia,');
                SQL.Add('        "EmpresaCondicaoOrigem"      as idempresacondicao,');
                SQL.Add('        "EmpresaProdutoOrigem"       as idempresaproduto,');
                SQL.Add('        "EmpresaFabricanteOrigem"    as idempresafabricante,');
                SQL.Add('        "EmpresaSituacaoTributariaOrigem" as idempresasituacaotributaria,');
                SQL.Add('        "EmpresaAliquotaOrigem"      as idempresaaliquota,');
                SQL.Add('        "EmpresaFormulaOrigem"       as idempresaformula,');
                SQL.Add('        "EmpresaGradeOrigem"         as idempresagrade,');
                SQL.Add('        "EmpresaCorOrigem"           as idempresacor,');
                SQL.Add('        "EmpresaCodigoFiscalOrigem"  as idempresacodigofiscal,');
                SQL.Add('        "EmpresaCobrancaOrigem"      as idempresacobranca,');
                SQL.Add('        "EmpresaOperacaoOrigem"      as idempresaoperacao,');
                SQL.Add('        "EmpresaValidacaoOrigem"     as idempresavalidacao,');
                SQL.Add('        "EmpresaIndexadorOrigem"     as idempresaindexador,');
                SQL.Add('        "EmpresaDescontoOrigem"      as idempresadesconto,');
                SQL.Add('        "EmpresaTipoLente"           as idempresatipolente,');
                SQL.Add('        "EmpresaIdentificadorOrigem" as idempresaidentificador,');
                SQL.Add('        "EmpresaHistoricoPadraoOrigem" as idempresahistorico,');
                SQL.Add('        "EmpresaPlanoContasOrigem"   as idempresaplanocontas,');
                SQL.Add('        "EmpresaProdutoPrecoOrigem"  as idempresaprodutopreco,');
                SQL.Add('        "EmpresaCategoriaOrigem"     as idempresacategoria,');
                SQL.Add('        "EmpresaTabelaPrecoOrigem"   as idempresatabelapreco,');
                SQL.Add('        "EmpresaFamiliaOrigem"       as idempresafamilia ');
                SQL.Add('from "Origem" where "CodigoEmpresaOrigem"=:xempresa ');
                ParamByName('xempresa').AsInteger  := XIdEmpresa;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Origem incluída');
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


function AlteraOrigem(XIdOrigem: integer; XOrigem: TJSONObject): TJSONObject;
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
    if XOrigem.TryGetValue('idempresaatividade',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaAtividadeOrigem"=:xidempresaatividade'
         else
            wcampos := wcampos+',"EmpresaAtividadeOrigem"=:xidempresaatividade';
       end;
    if XOrigem.TryGetValue('idempresalocalidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaLocalidadeOrigem"=:xidempresalocalidade'
         else
            wcampos := wcampos+',"EmpresaLocalidadeOrigem"=:xidempresalocalidade';
       end;
    if XOrigem.TryGetValue('idempresapessoa',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaPessoaOrigem"=:xidempresapessoa'
         else
            wcampos := wcampos+',"EmpresaPessoaOrigem"=:xidempresapessoa';
       end;
    if XOrigem.TryGetValue('idempresasetor',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaSetorOrigem"=:xidempresasetor'
         else
            wcampos := wcampos+',"EmpresaSetorOrigem"=:xidempresasetor';
       end;
    if XOrigem.TryGetValue('idempresaplanoestoque',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaPlanoEstoqueOrigem"=:xidempresaplanoestoque'
         else
            wcampos := wcampos+',"EmpresaPlanoEstoqueOrigem"=:xidempresaplanoestoque';
       end;
    if XOrigem.TryGetValue('idempresanumerario',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaNumerarioOrigem"=:xidempresanumerario'
         else
            wcampos := wcampos+',"EmpresaNumerarioOrigem"=:xidempresanumerario';
       end;
    if XOrigem.TryGetValue('idempresaclassificacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaClassificacaoOrigem"=:xidempresaclassificacao'
         else
            wcampos := wcampos+',"EmpresaClassificacaoOrigem"=:xidempresaclassificacao';
       end;
    if XOrigem.TryGetValue('idempresaocorrencia',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaOcorrenciaOrigem"=:xidempresaocorrencia'
         else
            wcampos := wcampos+',"EmpresaOcorrenciaOrigem"=:xidempresaocorrencia';
       end;
    if XOrigem.TryGetValue('idempresacondicao',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaCondicaoOrigem"=:xidempresacondicao'
         else
            wcampos := wcampos+',"EmpresaCondicaoOrigem"=:xidempresacondicao';
       end;
    if XOrigem.TryGetValue('idempresaproduto',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaProdutoOrigem"=:xidempresaproduto'
         else
            wcampos := wcampos+',"EmpresaProdutoOrigem"=:xidempresaproduto';
       end;
    if XOrigem.TryGetValue('idempresafabricante',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaFabricanteOrigem"=:xidempresafabricante'
         else
            wcampos := wcampos+',"EmpresaFabricanteOrigem"=:xidempresafabricante';
       end;
    if XOrigem.TryGetValue('idempresasituacaotributaria',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaSituacaoTributariaOrigem"=:xidempresasituacaotributaria'
         else
            wcampos := wcampos+',"EmpresaSituacaoTributariaOrigem"=:xidempresasituacaotributaria';
       end;
    if XOrigem.TryGetValue('idempresaaliquota',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaAliquotaOrigem"=:xidempresaaliquota'
         else
            wcampos := wcampos+',"EmpresaAliquotaOrigem"=:xidempresaaliquota';
       end;
    if XOrigem.TryGetValue('idempresaformula',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaFormulaOrigem"=:xidempresaformula'
         else
            wcampos := wcampos+',"EmpresaFormulaOrigem"=:xidempresaformula';
       end;
    if XOrigem.TryGetValue('idempresagrade',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaGradeOrigem"=:xidempresagrade'
         else
            wcampos := wcampos+',"EmpresaGradeOrigem"=:xidempresagrade';
       end;
    if XOrigem.TryGetValue('idempresacor',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaCorOrigem"=:xidempresacor'
         else
            wcampos := wcampos+',"EmpresaCorOrigem"=:xidempresacor';
       end;
    if XOrigem.TryGetValue('idempresacodigofiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaCodigoFiscalOrigem"=:xidempresacodigofiscal'
         else
            wcampos := wcampos+',"EmpresaCodigoFiscalOrigem"=:xidempresacodigofiscal';
       end;
    if XOrigem.TryGetValue('idempresacobranca',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaCobrancaOrigem"=:xidempresacobranca'
         else
            wcampos := wcampos+',"EmpresaCobrancaOrigem"=:xidempresacobranca';
       end;
    if XOrigem.TryGetValue('idempresaoperacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaOperacaoOrigem"=:xidempresaoperacao'
         else
            wcampos := wcampos+',"EmpresaOperacaoOrigem"=:xidempresaoperacao';
       end;
    if XOrigem.TryGetValue('idempresavalidacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaValidacaoOrigem"=:xidempresavalidacao'
         else
            wcampos := wcampos+',"EmpresaValidacaoOrigem"=:xidempresavalidacao';
       end;
    if XOrigem.TryGetValue('idempresaindexador',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaIndexadorOrigem"=:xidempresaindexador'
         else
            wcampos := wcampos+',"EmpresaIndexadorOrigem"=:xidempresaindexador';
       end;
    if XOrigem.TryGetValue('idempresadesconto',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaDescontoOrigem"=:xidempresadesconto'
         else
            wcampos := wcampos+',"EmpresaDescontoOrigem"=:xidempresadesconto';
       end;
    if XOrigem.TryGetValue('idempresatipolente',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaTipoLenteOrigem"=:xidempresatipolente'
         else
            wcampos := wcampos+',"EmpresaTipoLenteOrigem"=:xidempresatipolente';
       end;
    if XOrigem.TryGetValue('idempresaidentificador',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaIdentificadorOrigem"=:xidempresaidentificador'
         else
            wcampos := wcampos+',"EmpresaIdentificadorOrigem"=:xidempresaidentificador';
       end;
    if XOrigem.TryGetValue('idempresahistorico',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaHistoricoPadraoOrigem"=:xidempresahistorico'
         else
            wcampos := wcampos+',"EmpresaHistoricoPadraoOrigem"=:xidempresahistorico';
       end;
    if XOrigem.TryGetValue('idempresaplanocontas',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaPlanoContasOrigem"=:xidempresaplanocontas'
         else
            wcampos := wcampos+',"EmpresaPlanoContasOrigem"=:xidempresaplanocontas';
       end;
    if XOrigem.TryGetValue('idempresaprodutopreco',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaProdutoPrecoOrigem"=:xidempresaprodutopreco'
         else
            wcampos := wcampos+',"EmpresaProdutoPrecoOrigem"=:xidempresaprodutopreco';
       end;
    if XOrigem.TryGetValue('idempresacategoria',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaCategoriaOrigem"=:xidempresacategoria'
         else
            wcampos := wcampos+',"EmpresaCategoriaOrigem"=:xidempresacategoria';
       end;
    if XOrigem.TryGetValue('idempresatabelapreco',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaTabelaPrecoOrigem"=:xidempresatabelapreco'
         else
            wcampos := wcampos+',"EmpresaTabelaPrecoOrigem"=:xidempresatabelapreco';
       end;
    if XOrigem.TryGetValue('idempresafamilia',wval) then
       begin
         if wcampos='' then
            wcampos := '"EmpresaFamiliaOrigem"=:xidempresafamilia'
         else
            wcampos := wcampos+',"EmpresaFamiliaOrigem"=:xidempresafamilia';
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
           SQL.Add('Update "Origem" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoOrigem"=:xid ');
           ParamByName('xid').AsInteger       := XIdOrigem;
           if XOrigem.TryGetValue('idempresaatividade',wval) then
              ParamByName('xidempresaatividade').AsInteger    := strtointdef(XOrigem.GetValue('idempresaatividade').Value,0);
           if XOrigem.TryGetValue('idempresalocalidade',wval) then
              ParamByName('xidempresalocalidade').AsInteger   := strtointdef(XOrigem.GetValue('idempresalocalidade').Value,0);
           if XOrigem.TryGetValue('idempresapessoa',wval) then
              ParamByName('xidempresapessoa').AsInteger       := strtointdef(XOrigem.GetValue('idempresapessoa').Value,0);
           if XOrigem.TryGetValue('idempresasetor',wval) then
              ParamByName('xidempresasetor').AsInteger        := strtointdef(XOrigem.GetValue('idempresasetor').Value,0);
           if XOrigem.TryGetValue('idempresaplanoestoque',wval) then
              ParamByName('xidempresaplanoestoque').AsInteger := strtointdef(XOrigem.GetValue('idempresaplanoestoque').Value,0);
           if XOrigem.TryGetValue('idempresanumerario',wval) then
              ParamByName('xidempresanumerario').AsInteger    := strtointdef(XOrigem.GetValue('idempresanumerario').Value,0);
           if XOrigem.TryGetValue('idempresaclassificacao',wval) then
              ParamByName('xidempresaclassificacao').AsInteger := strtointdef(XOrigem.GetValue('idempresaclassificacao').Value,0);
           if XOrigem.TryGetValue('idempresaocorrencia',wval) then
              ParamByName('xidempresaocorrencia').AsInteger    := strtointdef(XOrigem.GetValue('idempresaocorrencia').Value,0);
           if XOrigem.TryGetValue('idempresacondicao',wval) then
              ParamByName('xidempresacondicao').AsInteger      := strtointdef(XOrigem.GetValue('idempresacondicao').Value,0);
           if XOrigem.TryGetValue('idempresaproduto',wval) then
              ParamByName('xidempresaproduto').AsInteger       := strtointdef(XOrigem.GetValue('idempresaproduto').Value,0);
           if XOrigem.TryGetValue('idempresafabricante',wval) then
              ParamByName('xidempresafabricante').AsInteger    := strtointdef(XOrigem.GetValue('idempresafabricante').Value,0);
           if XOrigem.TryGetValue('idempresasituacaotributaria',wval) then
              ParamByName('xidempresasituacaotributaria').AsInteger    := strtointdef(XOrigem.GetValue('idempresasituacaotributaria').Value,0);
           if XOrigem.TryGetValue('idempresaaliquota',wval) then
              ParamByName('xidempresaaliquota').AsInteger      := strtointdef(XOrigem.GetValue('idempresaaliquota').Value,0);
           if XOrigem.TryGetValue('idempresaformula',wval) then
              ParamByName('xidempresaformula').AsInteger       := strtointdef(XOrigem.GetValue('idempresaformula').Value,0);
           if XOrigem.TryGetValue('idempresagrade',wval) then
              ParamByName('xidempresagrade').AsInteger         := strtointdef(XOrigem.GetValue('idempresagrade').Value,0);
           if XOrigem.TryGetValue('idempresacor',wval) then
              ParamByName('xidempresacor').AsInteger           := strtointdef(XOrigem.GetValue('idempresacor').Value,0);
           if XOrigem.TryGetValue('idempresacodigofiscal',wval) then
              ParamByName('xidempresacodigofiscal').AsInteger       := strtointdef(XOrigem.GetValue('idempresacodigofiscal').Value,0);
           if XOrigem.TryGetValue('idempresacobranca',wval) then
              ParamByName('xidempresacobranca').AsInteger           := strtointdef(XOrigem.GetValue('idempresacobranca').Value,0);
           if XOrigem.TryGetValue('idempresaoperacao',wval) then
              ParamByName('xidempresaoperacao').AsInteger           := strtointdef(XOrigem.GetValue('idempresaoperacao').Value,0);
           if XOrigem.TryGetValue('idempresavalidacao',wval) then
              ParamByName('xidempresavalidacao').AsInteger          := strtointdef(XOrigem.GetValue('idempresavalidacao').Value,0);
           if XOrigem.TryGetValue('idempresaindexador',wval) then
              ParamByName('xidempresaindexador').AsInteger          := strtointdef(XOrigem.GetValue('idempresaindexador').Value,0);
           if XOrigem.TryGetValue('idempresadesconto',wval) then
              ParamByName('xidempresadesconto').AsInteger           := strtointdef(XOrigem.GetValue('idempresadesconto').Value,0);
           if XOrigem.TryGetValue('idempresatipolente',wval) then
              ParamByName('xidempresatipolente').AsInteger          := strtointdef(XOrigem.GetValue('idempresatipolente').Value,0);
           if XOrigem.TryGetValue('idempresaidentificador',wval) then
              ParamByName('xidempresaidentificador').AsInteger      := strtointdef(XOrigem.GetValue('idempresaidentificador').Value,0);
           if XOrigem.TryGetValue('idempresahistorico',wval) then
              ParamByName('xidempresahistorico').AsInteger          := strtointdef(XOrigem.GetValue('idempresahistorico').Value,0);
           if XOrigem.TryGetValue('idempresaplanocontas',wval) then
              ParamByName('xidempresaplanocontas').AsInteger        := strtointdef(XOrigem.GetValue('idempresaplanocontas').Value,0);
           if XOrigem.TryGetValue('idempresaprodutopreco',wval) then
              ParamByName('xidempresaprodutopreco').AsInteger       := strtointdef(XOrigem.GetValue('idempresaprodutopreco').Value,0);
           if XOrigem.TryGetValue('idempresacategoria',wval) then
              ParamByName('xidempresacategoria').AsInteger          := strtointdef(XOrigem.GetValue('idempresacategoria').Value,0);
           if XOrigem.TryGetValue('idempresatabelapreco',wval) then
              ParamByName('xidempresatabelapreco').AsInteger        := strtointdef(XOrigem.GetValue('idempresatabelapreco').Value,0);
           if XOrigem.TryGetValue('idempresafamilia',wval) then
              ParamByName('xidempresafamilia').AsInteger            := strtointdef(XOrigem.GetValue('idempresafamilia').Value,0);
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
              SQL.Add('select  "CodigoInternoOrigem"        as id,');
              SQL.Add('        "EmpresaAtividadeOrigem"     as idempresaatividade,');
              SQL.Add('        "EmpresaLocalidadeOrigem"    as idempresalocalidade,');
              SQL.Add('        "EmpresaPessoaOrigem"        as idempresapessoa,');
              SQL.Add('        "EmpresaSetorOrigem"         as idempresasetor,');
              SQL.Add('        "EmpresaPlanoEstoqueOrigem"  as idempresaplanoestoque,');
              SQL.Add('        "EmpresaNumerarioOrigem"     as idempresanumerario,');
              SQL.Add('        "EmpresaClassificacaoOrigem" as idempresaclassificacao,');
              SQL.Add('        "EmpresaOcorrenciaOrigem"    as idempresaocorrencia,');
              SQL.Add('        "EmpresaCondicaoOrigem"      as idempresacondicao,');
              SQL.Add('        "EmpresaProdutoOrigem"       as idempresaproduto,');
              SQL.Add('        "EmpresaFabricanteOrigem"    as idempresafabricante,');
              SQL.Add('        "EmpresaSituacaoTributariaOrigem" as idempresasituacaotributaria,');
              SQL.Add('        "EmpresaAliquotaOrigem"      as idempresaaliquota,');
              SQL.Add('        "EmpresaFormulaOrigem"       as idempresaformula,');
              SQL.Add('        "EmpresaGradeOrigem"         as idempresagrade,');
              SQL.Add('        "EmpresaCorOrigem"           as idempresacor,');
              SQL.Add('        "EmpresaCodigoFiscalOrigem"  as idempresacodigofiscal,');
              SQL.Add('        "EmpresaCobrancaOrigem"      as idempresacobranca,');
              SQL.Add('        "EmpresaOperacaoOrigem"      as idempresaoperacao,');
              SQL.Add('        "EmpresaValidacaoOrigem"     as idempresavalidacao,');
              SQL.Add('        "EmpresaIndexadorOrigem"     as idempresaindexador,');
              SQL.Add('        "EmpresaDescontoOrigem"      as idempresadesconto,');
              SQL.Add('        "EmpresaTipoLente"           as idempresatipolente,');
              SQL.Add('        "EmpresaIdentificadorOrigem" as idempresaidentificador,');
              SQL.Add('        "EmpresaHistoricoPadraoOrigem" as idempresahistorico,');
              SQL.Add('        "EmpresaPlanoContasOrigem"   as idempresaplanocontas,');
              SQL.Add('        "EmpresaProdutoPrecoOrigem"  as idempresaprodutopreco,');
              SQL.Add('        "EmpresaCategoriaOrigem"     as idempresacategoria,');
              SQL.Add('        "EmpresaTabelaPrecoOrigem"   as idempresatabelapreco,');
              SQL.Add('        "EmpresaFamiliaOrigem"       as idempresafamilia ');
              SQL.Add('from "Origem" ');
              SQL.Add('where "CodigoInternoOrigem" =:xid ');
              ParamByName('xid').AsInteger := XIdOrigem;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Origem alterada');
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

function VerificaRequisicao(XOrigem: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XOrigem.TryGetValue('idempresaidentificador',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaOrigem(XIdOrigem: integer): TJSONObject;
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
         SQL.Add('delete from "Origem" where "CodigoInternoOrigem"=:xid ');
         ParamByName('xid').AsInteger := XIdOrigem;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Origem excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Origem excluída');
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

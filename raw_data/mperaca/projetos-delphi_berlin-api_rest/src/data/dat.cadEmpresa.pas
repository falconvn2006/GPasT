unit dat.cadEmpresa;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaEmpresa: TJSONObject;
function RetornaListaEmpresas(const XQuery: TDictionary<string, string>): TJSONArray;

implementation

uses prv.dataModuleConexao;

function RetornaEmpresa: TJSONObject;
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
         SQL.Add('select "CodigoInternoPessoa" as id,');
         SQL.Add('       "CodigoPessoa"        as codigo,');
         SQL.Add('       "NomePessoa"          as razaosocial,');
         SQL.Add('       "CgcPessoa"            as cnpj,');
         SQL.Add('       "InscricaoEstadualPessoa" as inscestadual,');
         SQL.Add('       ts_retornalocalidadedescricao("EntregaCodigoCidadePessoa") as cidade,');
         SQL.Add('       ts_retornalocalidadeuf("EntregaCodigoCidadePessoa")        as uf,');
         SQL.Add('       "EntregaEnderecoPessoa"                                 as endereco,');
         SQL.Add('       "EntregaCepPessoa"                                      as cep,');
         SQL.Add('       "EntregaBairroPessoa"                                   as bairro,');
         SQL.Add('       "EntregaTelefonePessoa"                                 as telefone,');
         SQL.Add('       "EntregaEmailPessoa"                                    as email ');
         SQL.Add('from "PessoaGeral" ');
         SQL.Add('where "CodigoInternoPessoa"=:xid ');
         ParamByName('xid').AsInteger := wconexao.FIdEmpresa;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhuma Empresa encontrada');
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

function RetornaListaEmpresas(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select "CodigoInternoPessoa" as id,');
         SQL.Add('       "CodigoPessoa"        as codigo,');
         SQL.Add('       "NomePessoa"          as razaosocial,');
         SQL.Add('       "CgcPessoa"            as cnpj,');
         SQL.Add('       "InscricaoEstadualPessoa" as inscestadual,');
         SQL.Add('       ts_retornalocalidadedescricao("EntregaCodigoCidadePessoa") as cidade,');
         SQL.Add('       ts_retornalocalidadeuf("EntregaCodigoCidadePessoa")        as uf,');
         SQL.Add('       "EntregaEnderecoPessoa"                                 as endereco,');
         SQL.Add('       "EntregaCepPessoa"                                      as cep,');
         SQL.Add('       "EntregaBairroPessoa"                                   as bairro,');
         SQL.Add('       "EntregaTelefonePessoa"                                 as telefone,');
         SQL.Add('       "EntregaEmailPessoa"                                    as email ');
         SQL.Add('from "PessoaGeral" where "CodigoEmpresaPessoa"=:xempresa and "AtivoPessoa"=''true'' and "EhEmpresaPessoa"=''true'' ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaPessoa;
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomePessoa") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
            end;
         if XQuery.ContainsKey('codigo') then // filtro por uf
            begin
              SQL.Add('and "CodigoPessoa"=:xcodigo ');
              ParamByName('xcodigo').AsInteger := StrToInt(XQuery.Items['codigo']);
            end;
         if XQuery.ContainsKey('cnpj') then // filtro por código ibge
            begin
              SQL.Add('and "CgcPessoa" like :xcnpj ');
              ParamByName('xcnpj').AsString := XQuery.Items['cnpj']+'%';
            end;
         SQL.Add('order by "NomePessoa" ');
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma empresa encontrada');
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
//      messagedlg('Problema ao retorna listas de localidades'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;


end.

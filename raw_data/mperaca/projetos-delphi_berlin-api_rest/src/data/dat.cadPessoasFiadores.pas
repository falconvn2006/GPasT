unit dat.cadPessoasFiadores;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,System.StrUtils,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaFiador(XId: integer): TJSONObject;
function RetornaListaFiadores(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiFiador(XFiador: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraFiador(XIdFiador: integer; XFiador: TJSONObject): TJSONObject;
function ApagaFiador(XIdFiador: integer): TJSONObject;
function VerificaRequisicao(XFiador: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaFiador(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoFiador"      as id,');
         SQL.Add('        "CodigoPessoaFiador"       as idpessoa,');
         SQL.Add('        "NomePessoaFiador"         as nome,');
         SQL.Add('        "RGPessoaFiador"           as rg,');
         SQL.Add('        "CPFPessoaFiador"          as cpf,');
         SQL.Add('        "EnderecoPessoaFiador"     as endereco,');
         SQL.Add('        "BairroPessoaFiador"       as bairro,');
         SQL.Add('        "CEPPessoaFiador"          as cep,');
         SQL.Add('        "CodigoCidadePessoaFiador" as idlocalidade,');
         SQL.Add('        cast("Localidade"."NomeLocalidade" as varchar) as xlocalidade,');
         SQL.Add('        cast(("Localidade"."NomeLocalidade"||'' - ''||"Localidade"."EstadoLocalidade") as varchar) as xnomelocalidade,');
         SQL.Add('        "TelefonePessoaFiador"     as telefone ');
         SQL.Add('from "PessoaFiador" left join "Localidade" on "CodigoCidadePessoaFiador" = "CodigoInternoLocalidade" ');
         SQL.Add('where "CodigoInternoFiador"=:xid ');
         ParamByName('xid').AsInteger := XId;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum Fiador encontrado');
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

function RetornaListaFiadores(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoFiador"      as id,');
         SQL.Add('        "CodigoPessoaFiador"       as idpessoa,');
         SQL.Add('        "NomePessoaFiador"         as nome,');
         SQL.Add('        "RGPessoaFiador"           as rg,');
         SQL.Add('        "CPFPessoaFiador"          as cpf,');
         SQL.Add('        "EnderecoPessoaFiador"     as endereco,');
         SQL.Add('        "BairroPessoaFiador"       as bairro,');
         SQL.Add('        "CEPPessoaFiador"          as cep,');
         SQL.Add('        "CodigoCidadePessoaFiador" as idlocalidade,');
         SQL.Add('        cast("Localidade"."NomeLocalidade" as varchar) as xlocalidade,');
         SQL.Add('        cast(("Localidade"."NomeLocalidade"||'' - ''||"Localidade"."EstadoLocalidade") as varchar) as xnomelocalidade,');
         SQL.Add('        "TelefonePessoaFiador"     as telefone ');
         SQL.Add('from "PessoaFiador" left join "Localidade" on "CodigoCidadePessoaFiador" = "CodigoInternoLocalidade" ');
         SQL.Add('where "CodigoPessoaFiador"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         if XQuery.ContainsKey('nome') then // filtro por nome
            begin
              SQL.Add('and lower("NomePessoaFiador") like lower(:xnome) ');
              ParamByName('xnome').AsString := XQuery.Items['nome']+'%';
              SQL.Add('order by "NomePessoaFiador" ');
            end;
         if XQuery.ContainsKey('rg') then // filtro por rg
            begin
              SQL.Add('and "RGPessoaFiador" =:xrg ');
              ParamByName('xrg').AsString := XQuery.Items['rg'];
              SQL.Add('order by "RGPessoaFiador" ');
            end;
         if XQuery.ContainsKey('cpf') then // filtro por rg
            begin
              SQL.Add('and "CPFPessoaFiador" =:xrg ');
              ParamByName('xrg').AsString := XQuery.Items['cpf'];
              SQL.Add('order by "CPFPessoaFiador" ');
            end;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Fiador encontrado');
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

function IncluiFiador(XFiador: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaFiador" ("CodigoPessoaFiador","NomePessoaFiador","RGPessoaFiador","CPFPessoaFiador",');
           SQL.Add('"EnderecoPessoaFiador","BairroPessoaFiador","CEPPessoaFiador","CodigoCidadePessoaFiador","TelefonePessoaFiador") ');
           SQL.Add('values (:xidpessoa,:xnome,:xrg,:xcpf,');
           SQL.Add(':xendereco,:xbairro,:xcep,(case when :xidlocalidade>0 then :xidlocalidade else null end),:xtelefone) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XFiador.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString := XFiador.GetValue('nome').Value
           else
              ParamByName('xnome').AsString := '';
           if XFiador.TryGetValue('rg',wval) then
              ParamByName('xrg').AsString := XFiador.GetValue('rg').Value
           else
              ParamByName('xrg').AsString := '';
           if XFiador.TryGetValue('cpf',wval) then
              ParamByName('xcpf').AsString := XFiador.GetValue('cpf').Value
           else
              ParamByName('xcpf').AsString := '';
           if XFiador.TryGetValue('endereco',wval) then
              ParamByName('xendereco').AsString := XFiador.GetValue('endereco').Value
           else
              ParamByName('xendereco').AsString := '';
           if XFiador.TryGetValue('bairro',wval) then
              ParamByName('xbairro').AsString := XFiador.GetValue('bairro').Value
           else
              ParamByName('xbairro').AsString := '';
           if XFiador.TryGetValue('cep',wval) then
              ParamByName('xcep').AsString := XFiador.GetValue('cep').Value
           else
              ParamByName('xcep').AsString := '';
           if XFiador.TryGetValue('idlocalidade',wval) then
              ParamByName('xidlocalidade').AsInteger := strtointdef(XFiador.GetValue('idlocalidade').Value,0)
           else
              ParamByName('xidlocalidade').AsInteger := 0;
           if XFiador.TryGetValue('telefone',wval) then
              ParamByName('xtelefone').AsString := XFiador.GetValue('telefone').Value
           else
              ParamByName('xtelefone').AsString := '';
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
                SQL.Add('select  "CodigoInternoFiador"      as id,');
                SQL.Add('        "CodigoPessoaFiador"       as idpessoa,');
                SQL.Add('        "NomePessoaFiador"         as nome,');
                SQL.Add('        "RGPessoaFiador"           as rg,');
                SQL.Add('        "CPFPessoaFiador"          as cpf,');
                SQL.Add('        "EnderecoPessoaFiador"     as endereco,');
                SQL.Add('        "BairroPessoaFiador"       as bairro,');
                SQL.Add('        "CEPPessoaFiador"          as cep,');
                SQL.Add('        "CodigoCidadePessoaFiador" as idlocalidade,');
                SQL.Add('        "TelefonePessoaFiador"     as telefone ');
                SQL.Add('from "PessoaFiador" where "CodigoPessoaFiador"=:xidpessoa and "NomePessoaFiador"=:xnome ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XFiador.TryGetValue('nome',wval) then
                   ParamByName('xnome').AsString := XFiador.GetValue('nome').Value
                else
                   ParamByName('xnome').AsString := '';
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Fiador incluído');
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


function AlteraFiador(XIdFiador: integer; XFiador: TJSONObject): TJSONObject;
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
    if XFiador.TryGetValue('nome',wval) then
       begin
         if wcampos='' then
            wcampos := '"NomePessoaFiador"=:xnome'
         else
            wcampos := wcampos+',"NomePessoaFiador"=:xnome';
       end;
    if XFiador.TryGetValue('rg',wval) then
       begin
         if wcampos='' then
            wcampos := '"RGPessoaFiador"=:xrg'
         else
            wcampos := wcampos+',"RGPessoaFiador"=:xrg';
       end;
    if XFiador.TryGetValue('cpf',wval) then
       begin
         if wcampos='' then
            wcampos := '"CPFPessoaFiador"=:xcpf'
         else
            wcampos := wcampos+',"CPFPessoaFiador"=:xcpf';
       end;
    if XFiador.TryGetValue('endereco',wval) then
       begin
         if wcampos='' then
            wcampos := '"EnderecoPessoaFiador"=:xendereco'
         else
            wcampos := wcampos+',"EnderecoPessoaFiador"=:xendereco';
       end;
    if XFiador.TryGetValue('bairro',wval) then
       begin
         if wcampos='' then
            wcampos := '"BairroPessoaFiador"=:xbairro'
         else
            wcampos := wcampos+',"BairroPessoaFiador"=:xbairro';
       end;
    if XFiador.TryGetValue('cep',wval) then
       begin
         if wcampos='' then
            wcampos := '"CEPPessoaFiador"=:xcep'
         else
            wcampos := wcampos+',"CEPPessoaFiador"=:xcep';
       end;
    if XFiador.TryGetValue('idlocalidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoCidadePessoaFiador"='+ifthen(wval='0','null',':xidlocalidade')
         else
            wcampos := wcampos+',"CodigoCidadePessoaFiador"='+ifthen(wval='0','null',':xidlocalidade');
       end;
    if XFiador.TryGetValue('telefone',wval) then
       begin
         if wcampos='' then
            wcampos := '"TelefonePessoaFiador"=:xtelefone'
         else
            wcampos := wcampos+',"TelefonePessoaFiador"=:xtelefone';
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
           SQL.Add('Update "PessoaFiador" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoFiador"=:xid ');
           ParamByName('xid').AsInteger               := XIdFiador;
           if XFiador.TryGetValue('nome',wval) then
              ParamByName('xnome').AsString           := XFiador.GetValue('nome').Value;
           if XFiador.TryGetValue('rg',wval) then
              ParamByName('xrg').AsString             := XFiador.GetValue('rg').Value;
           if XFiador.TryGetValue('cpf',wval) then
              ParamByName('xcpf').AsString            := XFiador.GetValue('cpf').Value;
           if XFiador.TryGetValue('endereco',wval) then
              ParamByName('xendereco').AsString       := XFiador.GetValue('endereco').Value;
           if XFiador.TryGetValue('bairro',wval) then
              ParamByName('xbairro').AsString         := XFiador.GetValue('bairro').Value;
           if XFiador.TryGetValue('cep',wval) then
              ParamByName('xcep').AsString            := XFiador.GetValue('cep').Value;
           if XFiador.TryGetValue('idlocalidade',wval) and (wval<>'0') then
              ParamByName('xidlocalidade').AsInteger  := strtointdef(XFiador.GetValue('idlocalidade').Value,0);
           if XFiador.TryGetValue('telefone',wval) then
              ParamByName('xtelefone').AsString       := XFiador.GetValue('telefone').Value;
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
              SQL.Add('select  "CodigoInternoFiador"      as id,');
              SQL.Add('        "CodigoPessoaFiador"       as idpessoa,');
              SQL.Add('        "NomePessoaFiador"         as nome,');
              SQL.Add('        "RGPessoaFiador"           as rg,');
              SQL.Add('        "CPFPessoaFiador"          as cpf,');
              SQL.Add('        "EnderecoPessoaFiador"     as endereco,');
              SQL.Add('        "BairroPessoaFiador"       as bairro,');
              SQL.Add('        "CEPPessoaFiador"          as cep,');
              SQL.Add('        "CodigoCidadePessoaFiador" as idlocalidade,');
              SQL.Add('        "TelefonePessoaFiador"     as telefone ');
              SQL.Add('from "PessoaFiador" ');
              SQL.Add('where "CodigoInternoFiador" =:xid ');
              ParamByName('xid').AsInteger := XIdFiador;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Fiador alterado');
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

function VerificaRequisicao(XFiador: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XFiador.TryGetValue('nome',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaFiador(XIdFiador: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaFiador" where "CodigoInternoFiador"=:xid ');
         ParamByName('xid').AsInteger := XIdFiador;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Fiador excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Fiador excluído');
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

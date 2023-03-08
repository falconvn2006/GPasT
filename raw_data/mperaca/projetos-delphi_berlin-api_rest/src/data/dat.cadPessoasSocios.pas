unit dat.cadPessoasSocios;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaSocio(XId: integer): TJSONObject;
function RetornaListaSocios(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiSocio(XSocio: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraSocio(XIdSocio: integer; XSocio: TJSONObject): TJSONObject;
function ApagaSocio(XIdSocio: integer): TJSONObject;
function VerificaRequisicao(XSocio: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaSocio(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoSocio"       as id,');
         SQL.Add('        "CodigoPessoaSocio"        as idpessoa,');
         SQL.Add('        "OrgaoEmitenteSocio"       as orgaoemitente,');
         SQL.Add('        "AponsentadoSocio"         as ehaposentado,');
         SQL.Add('        "PensionistaSocio"         as ehpensionista,');
         SQL.Add('        "DataCadastroSocio"        as datacadastro,');
         SQL.Add('        "DataDemissaoSocio"        as datademissao,');
         SQL.Add('        "DataReadmissaoSocio"      as datareadmissao,');
         SQL.Add('        "DataFalecidoSocio"        as datafalecimento,');
         SQL.Add('        "NumeroBeneficioSocio"     as numerobeneficio,');
         SQL.Add('        "DataInfoFalecimentoSocio" as datainfofalecimento ');
         SQL.Add('from "PessoaSocio" ');
         SQL.Add('where "CodigoInternoSocio"=:xid ');
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
        wret.AddPair('description','Nenhum Sócio encontrado');
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

function RetornaListaSocios(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoSocio"       as id,');
         SQL.Add('        "CodigoPessoaSocio"        as idpessoa,');
         SQL.Add('        "OrgaoEmitenteSocio"       as orgaoemitente,');
         SQL.Add('        "AponsentadoSocio"         as ehaposentado,');
         SQL.Add('        "PensionistaSocio"         as ehpensionista,');
         SQL.Add('        "DataCadastroSocio"        as datacadastro,');
         SQL.Add('        "DataDemissaoSocio"        as datademissao,');
         SQL.Add('        "DataReadmissaoSocio"      as datareadmissao,');
         SQL.Add('        "DataFalecidoSocio"        as datafalecimento,');
         SQL.Add('        "NumeroBeneficioSocio"     as numerobeneficio,');
         SQL.Add('        "DataInfoFalecimentoSocio" as datainfofalecimento ');
         SQL.Add('from "PessoaSocio" where "CodigoPessoaSocio"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Sócio encontrado');
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

function IncluiSocio(XSocio: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaSocio" ("CodigoPessoaSocio","OrgaoEmitenteSocio","AponsentadoSocio","PensionistaSocio",');
           SQL.Add('"DataCadastroSocio","DataDemissaoSocio","DataReadmissaoSocio","DataFalecidoSocio","NumeroBeneficioSocio","DataInfoFalecimentoSocio") ');
           SQL.Add('values (:xidpessoa,:xorgaoemitente,:xehaposentado,:xehpensionista,');
           SQL.Add(':xdatacadastro,:xdatademissao,:xdatareadmissao,:xdatafalecimento,:xnumerobeneficio,:xdatainfofalecimento) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XSocio.TryGetValue('orgaoemitente',wval) then
              ParamByName('xorgaoemitente').AsString := XSocio.GetValue('orgaoemitente').Value
           else
              ParamByName('xorgaoemitente').AsString := '';
           if XSocio.TryGetValue('ehaposentado',wval) then
              ParamByName('xehaposentado').AsBoolean := strtobooldef(XSocio.GetValue('ehaposentado').Value,false)
           else
              ParamByName('xehaposentado').AsBoolean := false;
           if XSocio.TryGetValue('ehpensionista',wval) then
              ParamByName('xehpensionista').AsBoolean := strtobooldef(XSocio.GetValue('ehpensionista').Value,false)
           else
              ParamByName('xehpensionista').AsBoolean := false;
           if XSocio.TryGetValue('datacadastro',wval) then
              ParamByName('xdatacadastro').AsDate     := strtodatedef(XSocio.GetValue('datacadastro').Value,date)
           else
              ParamByName('xdatacadastro').AsDate     := date;
           if XSocio.TryGetValue('datademissao',wval) then
              ParamByName('xdatademissao').AsDate     := strtodatedef(XSocio.GetValue('datademissao').Value,0)
           else
              ParamByName('xdatademissao').AsDate     := 0;
           if XSocio.TryGetValue('datareadmissao',wval) then
              ParamByName('xdatareadmissao').AsDate     := strtodatedef(XSocio.GetValue('datareadmissao').Value,0)
           else
              ParamByName('xdatareadmissao').AsDate     := 0;
           if XSocio.TryGetValue('datafalecimento',wval) then
              ParamByName('xdatafalecimento').AsDate     := strtodatedef(XSocio.GetValue('datafalecimento').Value,0)
           else
              ParamByName('xdatafalecimento').AsDate     := 0;
           if XSocio.TryGetValue('numerobeneficio',wval) then
              ParamByName('xnumerobeneficio').AsString := XSocio.GetValue('numerobeneficio').Value
           else
              ParamByName('xnumerobeneficio').AsString := '';
           if XSocio.TryGetValue('datainfofalecimento',wval) then
              ParamByName('xdatainfofalecimento').AsDate     := strtodatedef(XSocio.GetValue('datainfofalecimento').Value,0)
           else
              ParamByName('xdatainfofalecimento').AsDate     := 0;
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
                SQL.Add('select  "CodigoInternoSocio"       as id,');
                SQL.Add('        "CodigoPessoaSocio"        as idpessoa,');
                SQL.Add('        "OrgaoEmitenteSocio"       as orgaoemitente,');
                SQL.Add('        "AponsentadoSocio"         as ehaposentado,');
                SQL.Add('        "PensionistaSocio"         as ehpensionista,');
                SQL.Add('        "DataCadastroSocio"        as datacadastro,');
                SQL.Add('        "DataDemissaoSocio"        as datademissao,');
                SQL.Add('        "DataReadmissaoSocio"      as datareadmissao,');
                SQL.Add('        "DataFalecidoSocio"        as datafalecimento,');
                SQL.Add('        "NumeroBeneficioSocio"     as numerobeneficio,');
                SQL.Add('        "DataInfoFalecimentoSocio" as datainfofalecimento ');
                SQL.Add('from "PessoaSocio" where "CodigoPessoaSocio"=:xidpessoa and "DataCadastroSocio"=:xdatacadastro ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                if XSocio.TryGetValue('datacadastro',wval) then
                   ParamByName('xdatacadastro').AsDate := strtodatedef(XSocio.GetValue('datacadastro').Value,0)
                else
                   ParamByName('xdatacadastro').AsDate := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Sócio incluído');
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


function AlteraSocio(XIdSocio: integer; XSocio: TJSONObject): TJSONObject;
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
    if XSocio.TryGetValue('orgaoemitente',wval) then
       begin
         if wcampos='' then
            wcampos := '"OrgaoEmitenteSocio"=:xorgaoemitente'
         else
            wcampos := wcampos+',"OrgaoEmitenteSocio"=:xorgaoemitente';
       end;
    if XSocio.TryGetValue('ehaposentado',wval) then
       begin
         if wcampos='' then
            wcampos := '"AponsentadoSocio"=:xehaposentado'
         else
            wcampos := wcampos+',"AponsentadoSocio"=:xehaposentado';
       end;
    if XSocio.TryGetValue('ehpensionista',wval) then
       begin
         if wcampos='' then
            wcampos := '"PensionistaSocio"=:xehpensionista'
         else
            wcampos := wcampos+',"PensionistaSocio"=:xehpensionista';
       end;
    if XSocio.TryGetValue('datacadastro',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataCadastroSocio"=:xdatacadastro'
         else
            wcampos := wcampos+',"DataCadastroSocio"=:xdatacadastro';
       end;
    if XSocio.TryGetValue('datademissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataDemissaoSocio"=:xdatademissao'
         else
            wcampos := wcampos+',"DataDemissaoSocio"=:xdatademissao';
       end;
    if XSocio.TryGetValue('datareadmissao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataReadmissaoSocio"=:xdatareademissao'
         else
            wcampos := wcampos+',"DataReadmissaoSocio"=:xdatareademissao';
       end;
    if XSocio.TryGetValue('datafalecimento',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataFalecimentoSocio"=:xdatafalecimento'
         else
            wcampos := wcampos+',"DataFalecimentoSocio"=:xdatafalecimento';
       end;
    if XSocio.TryGetValue('numerobeneficio',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroBeneficioSocio"=:xnumerobeneficio'
         else
            wcampos := wcampos+',"NumeroBeneficioSocio"=:xnumerobeneficio';
       end;
    if XSocio.TryGetValue('datainfofalecimento',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataInfoFalecimentoSocio"=:xdatainfofalecimento'
         else
            wcampos := wcampos+',"DataInfoFalecimentoSocio"=:xdatainfofalecimento';
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
           SQL.Add('Update "PessoaSocio" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoSocio"=:xid ');
           ParamByName('xid').AsInteger               := XIdSocio;
           if XSocio.TryGetValue('orgaoemitente',wval) then
              ParamByName('xorgaoemitente').AsString     := XSocio.GetValue('orgaoemitente').Value;
           if XSocio.TryGetValue('ehaposentado',wval) then
              ParamByName('xehaposentado').AsBoolean     := strtobooldef(XSocio.GetValue('ehaposentado').Value,false);
           if XSocio.TryGetValue('ehpensionista',wval) then
              ParamByName('xehpensionista').AsBoolean    := strtobooldef(XSocio.GetValue('ehpensionista').Value,false);
           if XSocio.TryGetValue('datacadastro',wval) then
              ParamByName('xdatacadastro').AsDate        := strtodatedef(XSocio.GetValue('datacadastro').Value,0);
           if XSocio.TryGetValue('datademissao',wval) then
              ParamByName('xdatademissao').AsDate        := strtodatedef(XSocio.GetValue('datademissao').Value,0);
           if XSocio.TryGetValue('datareadmissao',wval) then
              ParamByName('xdatareadmissao').AsDate      := strtodatedef(XSocio.GetValue('datareadmissao').Value,0);
           if XSocio.TryGetValue('datafalecimento',wval) then
              ParamByName('xdatafalecimento').AsDate     := strtodatedef(XSocio.GetValue('datafalecimento').Value,0);
           if XSocio.TryGetValue('numerobeneficio',wval) then
              ParamByName('xnumerobeneficio').AsString   := XSocio.GetValue('numerobeneficio').Value;
           if XSocio.TryGetValue('datainfofalecimento',wval) then
              ParamByName('xdatainfofalecimento').AsDate := strtodatedef(XSocio.GetValue('datainfofalecimento').Value,0);
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
              SQL.Add('select  "CodigoInternoSocio"       as id,');
              SQL.Add('        "CodigoPessoaSocio"        as idpessoa,');
              SQL.Add('        "OrgaoEmitenteSocio"       as orgaoemitente,');
              SQL.Add('        "AponsentadoSocio"         as ehaposentado,');
              SQL.Add('        "PensionistaSocio"         as ehpensionista,');
              SQL.Add('        "DataCadastroSocio"        as datacadastro,');
              SQL.Add('        "DataDemissaoSocio"        as datademissao,');
              SQL.Add('        "DataReadmissaoSocio"      as datareadmissao,');
              SQL.Add('        "DataFalecidoSocio"        as datafalecimento,');
              SQL.Add('        "NumeroBeneficioSocio"     as numerobeneficio,');
              SQL.Add('        "DataInfoFalecimentoSocio" as datainfofalecimento ');
              SQL.Add('from "PessoaSocio" ');
              SQL.Add('where "CodigoInternoSocio" =:xid ');
              ParamByName('xid').AsInteger := XIdSocio;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Sócio alterado');
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

function VerificaRequisicao(XSocio: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XSocio.TryGetValue('datacadastro',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaSocio(XIdSocio: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaSocio" where "CodigoInternoSocio"=:xid ');
         ParamByName('xid').AsInteger := XIdSocio;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Sócio excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Sócio excluído');
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

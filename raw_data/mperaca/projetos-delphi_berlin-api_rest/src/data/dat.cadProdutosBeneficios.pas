unit dat.cadProdutosBeneficios;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaBeneficio(XId: integer): TJSONObject;
function RetornaListaBeneficios(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiBeneficio(XBeneficio: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraBeneficio(XIdBeneficio: integer; XBeneficio: TJSONObject): TJSONObject;
function ApagaBeneficio(XIdBeneficio: integer): TJSONObject;
function VerificaRequisicao(XBeneficio: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaBeneficio(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoBeneficio"   as id,');
         SQL.Add('        "CodigoProdutoBeneficio"          as idproduto,');
         SQL.Add('        "CodigoFiscalProdutoBeneficio"    as idcodfiscal,');
         SQL.Add('        "CodigoBeneficioProdutoBeneficio" as codbeneficio ');
         SQL.Add('from "ProdutoBeneficio" ');
         SQL.Add('where "CodigoInternoProdutoBeneficio"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Benefício encontrado');
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

function RetornaListaBeneficios(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoBeneficio"   as id,');
         SQL.Add('        "CodigoProdutoBeneficio"          as idproduto,');
         SQL.Add('        "CodigoFiscalProdutoBeneficio"    as idcodfiscal,');
         SQL.Add('        "CodigoBeneficioProdutoBeneficio" as codbeneficio ');
         SQL.Add('from "ProdutoBeneficio" where "CodigoProdutoBeneficio"=:xidproduto ');
         ParamByName('xidproduto').AsInteger := XIdProduto;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Produto Benefício encontrado');
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

function IncluiBeneficio(XBeneficio: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoBeneficio" ("CodigoProdutoBeneficio","CodigoFiscalProdutoBeneficio","CodigoBeneficioProdutoBeneficio") ');
           SQL.Add('values (:xidproduto,:xidcodfiscal,:xcodbeneficio) ');
           ParamByName('xidproduto').AsInteger   := XIdProduto;
           if XBeneficio.TryGetValue('idcodfiscal',wval) then
              ParamByName('xidcodfiscal').AsInteger := strtointdef(XBeneficio.GetValue('idcodfiscal').Value,0)
           else
              ParamByName('xidcodfiscal').AsInteger := 0;
           if XBeneficio.TryGetValue('codbeneficio',wval) then
              ParamByName('xcodbeneficio').AsString := XBeneficio.GetValue('codbeneficio').Value
           else
              ParamByName('xcodbeneficio').AsString := '';
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
                SQL.Add('select  "CodigoInternoProdutoBeneficio"   as id,');
                SQL.Add('        "CodigoProdutoBeneficio"          as idproduto,');
                SQL.Add('        "CodigoFiscalProdutoBeneficio"    as idcodfiscal,');
                SQL.Add('        "CodigoBeneficioProdutoBeneficio" as codbeneficio ');
                SQL.Add('from "ProdutoBeneficio" where "CodigoProdutoBeneficio"=:xidproduto and "CodigoBeneficioProdutoBeneficio"=:xcodbeneficio ');
                ParamByName('xidproduto').AsInteger  := XIdProduto;
                if XBeneficio.TryGetValue('codbeneficio',wval) then
                   ParamByName('xcodbeneficio').AsString := XBeneficio.GetValue('codbeneficio').Value
                else
                   ParamByName('xcodbeneficio').AsString := '';
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Benefício incluído');
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

function AlteraBeneficio(XIdBeneficio: integer; XBeneficio: TJSONObject): TJSONObject;
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
    if XBeneficio.TryGetValue('idcodfiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoFiscalProdutoBeneficio"=:xidcodfiscal'
         else
            wcampos := wcampos+',"CodigoFiscalProdutoBeneficio"=:xidcodfiscal';
       end;
    if XBeneficio.TryGetValue('codbeneficio',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoBeneficioProdutoBeneficio"=:xcodbeneficio'
         else
            wcampos := wcampos+',"CodigoBeneficioProdutoBeneficio"=:xcodbeneficio';
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
           SQL.Add('Update "ProdutoBeneficio" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoBeneficio"=:xid ');
           ParamByName('xid').AsInteger                := XIdBeneficio;
           if XBeneficio.TryGetValue('idcodfiscal',wval) then
              ParamByName('xidcodfiscal').AsInteger    := strtointdef(XBeneficio.GetValue('idcodfiscal').Value,0);
           if XBeneficio.TryGetValue('codbeneficio',wval) then
              ParamByName('xcodbeneficio').AsString    := XBeneficio.GetValue('codbeneficio').Value;
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
              SQL.Add('select  "CodigoInternoProdutoBeneficio"   as id,');
              SQL.Add('        "CodigoProdutoBeneficio"          as idproduto,');
              SQL.Add('        "CodigoFiscalProdutoBeneficio"    as idcodfiscal,');
              SQL.Add('        "CodigoBeneficioProdutoBeneficio" as codbeneficio ');
              SQL.Add('from "ProdutoBeneficio" ');
              SQL.Add('where "CodigoInternoProdutoBeneficio" =:xid ');
              ParamByName('xid').AsInteger := XIdBeneficio;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Benefício alterado');
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

function VerificaRequisicao(XBeneficio: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XBeneficio.TryGetValue('codbeneficio',wval) then
       wret := false;
    if not XBeneficio.TryGetValue('idcodfiscal',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaBeneficio(XIdBeneficio: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoBeneficio" where "CodigoInternoProdutoBeneficio"=:xid ');
         ParamByName('xid').AsInteger := XIdBeneficio;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Benefício excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Benefício excluído');
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

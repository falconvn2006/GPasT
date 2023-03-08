unit dat.cadProdutosEstoques;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaEstoque(XId: integer): TJSONObject;
function RetornaListaEstoques(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiEstoque(XEstoque: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraEstoque(XIdEstoque: integer; XEstoque: TJSONObject): TJSONObject;
function ApagaEstoque(XIdEstoque: integer): TJSONObject;
function VerificaRequisicao(XEstoque: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaEstoque(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoEstoque" as id,');
         SQL.Add('        "CodigoProdutoEstoque"        as idproduto,');
         SQL.Add('        "SaldoProdutoEstoque"         as saldo,');
         SQL.Add('        "CustoProdutoEstoque"         as custo,');
         SQL.Add('        "CustoContabilProdutoEstoque" as custocontabil,');
         SQL.Add('        "Venda1ProdutoEstoque"        as venda1,');
         SQL.Add('        "Venda2ProdutoEstoque"        as venda2,');
         SQL.Add('        "Venda3ProdutoEstoque"        as venda3,');
         SQL.Add('        "Venda4ProdutoEstoque"        as venda4,');
         SQL.Add('        "Venda5ProdutoEstoque"        as venda5,');
         SQL.Add('        "CodigoEmpresaProdutoEstoque" as idempresa,');
         SQL.Add('        "InventarioProdutoEstoque"    as ehinventario,');
         SQL.Add('        "DataReferenciaProdutoEstoque" as datareferencia ');
         SQL.Add('from "ProdutoEstoque" ');
         SQL.Add('where "CodigoInternoProdutoEstoque"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Estoque encontrado');
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

function RetornaListaEstoques(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoEstoque" as id,');
         SQL.Add('        "CodigoProdutoEstoque"        as idproduto,');
         SQL.Add('        "SaldoProdutoEstoque"         as saldo,');
         SQL.Add('        "CustoProdutoEstoque"         as custo,');
         SQL.Add('        "CustoContabilProdutoEstoque" as custocontabil,');
         SQL.Add('        "Venda1ProdutoEstoque"        as venda1,');
         SQL.Add('        "Venda2ProdutoEstoque"        as venda2,');
         SQL.Add('        "Venda3ProdutoEstoque"        as venda3,');
         SQL.Add('        "Venda4ProdutoEstoque"        as venda4,');
         SQL.Add('        "Venda5ProdutoEstoque"        as venda5,');
         SQL.Add('        "CodigoEmpresaProdutoEstoque" as idempresa,');
         SQL.Add('        "InventarioProdutoEstoque"    as ehinventario,');
         SQL.Add('        "DataReferenciaProdutoEstoque" as datareferencia ');
         SQL.Add('from "ProdutoEstoque" where "CodigoProdutoEstoque"=:xidproduto ');
         ParamByName('xidproduto').AsInteger := XIdProduto;
         if XQuery.ContainsKey('datareferencia') then // filtro por data referência
            begin
              SQL.Add('and "DataReferenciaProdutoEstoque" =:xdatareferencia ');
              ParamByName('xdatareferencia').AsDate := strtodatedef(XQuery.Items['datareferencia'],0);
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
         wobj.AddPair('description','Nenhum Produto Estoque encontrado');
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

function IncluiEstoque(XEstoque: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoEstoque"("CodigoProdutoEstoque","SaldoProdutoEstoque","CustoProdutoEstoque","CustoContabilProdutoEstoque",');
           SQL.Add('"Venda1ProdutoEstoque","Venda2ProdutoEstoque","Venda3ProdutoEstoque","Venda4ProdutoEstoque","Venda5ProdutoEstoque",');
           SQL.Add('"CodigoEmpresaProdutoEstoque","InventarioProdutoEstoque","DataReferenciaProdutoEstoque") ');
           SQL.Add('values (:xidproduto,:xsaldo,:xcusto,:xcustocontabil,');
           SQL.Add(':xvenda1,:xvenda2,:xvenda3,:xvenda4,:xvenda5,');
           SQL.Add(':xidempresa,:xehinventario,:xdatareferencia) ');
           ParamByName('xidempresa').AsInteger    := wconexao.FIdEmpresa;
           ParamByName('xidproduto').AsInteger    := XIdProduto;
           if XEstoque.TryGetValue('saldo',wval) then
              ParamByName('xsaldo').AsFloat := strtofloatdef(XEstoque.GetValue('saldo').Value,0)
           else
              ParamByName('xsaldo').AsFloat := 0;
           if XEstoque.TryGetValue('custo',wval) then
              ParamByName('xcusto').AsFloat := strtofloatdef(XEstoque.GetValue('custo').Value,0)
           else
              ParamByName('xcusto').AsFloat := 0;
           if XEstoque.TryGetValue('custocontabil',wval) then
              ParamByName('xcustocontabil').AsFloat := strtofloatdef(XEstoque.GetValue('custocontabil').Value,0)
           else
              ParamByName('xcustocontabil').AsFloat := 0;
           if XEstoque.TryGetValue('venda1',wval) then
              ParamByName('xvenda1').AsFloat := strtofloatdef(XEstoque.GetValue('venda1').Value,0)
           else
              ParamByName('xvenda1').AsFloat := 0;
           if XEstoque.TryGetValue('venda2',wval) then
              ParamByName('xvenda2').AsFloat := strtofloatdef(XEstoque.GetValue('venda2').Value,0)
           else
              ParamByName('xvenda2').AsFloat := 0;
           if XEstoque.TryGetValue('venda3',wval) then
              ParamByName('xvenda3').AsFloat := strtofloatdef(XEstoque.GetValue('venda3').Value,0)
           else
              ParamByName('xvenda3').AsFloat := 0;
           if XEstoque.TryGetValue('venda4',wval) then
              ParamByName('xvenda4').AsFloat := strtofloatdef(XEstoque.GetValue('venda4').Value,0)
           else
              ParamByName('xvenda4').AsFloat := 0;
           if XEstoque.TryGetValue('venda5',wval) then
              ParamByName('xvenda5').AsFloat := strtofloatdef(XEstoque.GetValue('venda5').Value,0)
           else
              ParamByName('xvenda5').AsFloat := 0;
           if XEstoque.TryGetValue('ehinventario',wval) then
              ParamByName('xehinventario').AsBoolean := strtobooldef(XEstoque.GetValue('ehinventario').Value,false)
           else
              ParamByName('xehinventario').AsBoolean := false;
           if XEstoque.TryGetValue('datareferencia',wval) then
              ParamByName('xdatareferencia').AsDate := strtodatedef(XEstoque.GetValue('datareferencia').Value,date)
           else
              ParamByName('xdatareferencia').AsDate := date;
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
                SQL.Add('select  "CodigoInternoProdutoEstoque" as id,');
                SQL.Add('        "CodigoProdutoEstoque"        as idproduto,');
                SQL.Add('        "SaldoProdutoEstoque"         as saldo,');
                SQL.Add('        "CustoProdutoEstoque"         as custo,');
                SQL.Add('        "CustoContabilProdutoEstoque" as custocontabil,');
                SQL.Add('        "Venda1ProdutoEstoque"        as venda1,');
                SQL.Add('        "Venda2ProdutoEstoque"        as venda2,');
                SQL.Add('        "Venda3ProdutoEstoque"        as venda3,');
                SQL.Add('        "Venda4ProdutoEstoque"        as venda4,');
                SQL.Add('        "Venda5ProdutoEstoque"        as venda5,');
                SQL.Add('        "CodigoEmpresaProdutoEstoque" as idempresa,');
                SQL.Add('        "InventarioProdutoEstoque"    as ehinventario,');
                SQL.Add('        "DataReferenciaProdutoEstoque" as datareferencia ');
                SQL.Add('from "ProdutoEstoque" where "CodigoProdutoEstoque"=:xidproduto and "CodigoEmpresaProdutoEstoque"=:xidempresa and "DataReferenciaProdutoEstoque"=:xdatareferencia ');
                ParamByName('xidproduto').AsInteger     := XIdProduto;
                ParamByName('xidempresa').AsInteger    := wconexao.FIdEmpresa;
                if XEstoque.TryGetValue('datareferencia',wval) then
                   ParamByName('xdatareferencia').AsDate := strtodatedef(XEstoque.GetValue('datareferencia').Value,date)
                else
                   ParamByName('xdatareferencia').AsDate := date;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Estoque incluído');
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

function AlteraEstoque(XIdEstoque: integer; XEstoque: TJSONObject): TJSONObject;
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
    if XEstoque.TryGetValue('saldo',wval) then
       begin
         if wcampos='' then
            wcampos := '"SaldoProdutoEstoque"=:xsaldo'
         else
            wcampos := wcampos+',"SaldoProdutoEstoque"=:xsaldo';
       end;
    if XEstoque.TryGetValue('custo',wval) then
       begin
         if wcampos='' then
            wcampos := '"CustoProdutoEstoque"=:xcusto'
         else
            wcampos := wcampos+',"CustoProdutoEstoque"=:xcusto';
       end;
    if XEstoque.TryGetValue('custocontabil',wval) then
       begin
         if wcampos='' then
            wcampos := '"CustoContabilProdutoEstoque"=:xcustocontabil'
         else
            wcampos := wcampos+',"CustoContabilProdutoEstoque"=:xcustocontabil';
       end;
    if XEstoque.TryGetValue('venda1',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda1ProdutoEstoque"=:xvenda1'
         else
            wcampos := wcampos+',"Venda1ProdutoEstoque"=:xvenda1';
       end;
    if XEstoque.TryGetValue('venda2',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda2ProdutoEstoque"=:xvenda2'
         else
            wcampos := wcampos+',"Venda2ProdutoEstoque"=:xvenda2';
       end;
    if XEstoque.TryGetValue('venda3',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda3ProdutoEstoque"=:xvenda3'
         else
            wcampos := wcampos+',"Venda3ProdutoEstoque"=:xvenda3';
       end;
    if XEstoque.TryGetValue('venda4',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda4ProdutoEstoque"=:xvenda4'
         else
            wcampos := wcampos+',"Venda4ProdutoEstoque"=:xvenda4';
       end;
    if XEstoque.TryGetValue('venda5',wval) then
       begin
         if wcampos='' then
            wcampos := '"Venda5ProdutoEstoque"=:xvenda5'
         else
            wcampos := wcampos+',"Venda5ProdutoEstoque"=:xvenda5';
       end;
    if XEstoque.TryGetValue('ehinventario',wval) then
       begin
         if wcampos='' then
            wcampos := '"InventarioProdutoEstoque"=:xehinventario'
         else
            wcampos := wcampos+',"InventarioProdutoEstoque"=:xehinventario';
       end;
    if XEstoque.TryGetValue('datareferencia',wval) then
       begin
         if wcampos='' then
            wcampos := '"DataReferenciaProdutoEstoque"=:xdatareferencia'
         else
            wcampos := wcampos+',"DataReferenciaProdutoEstoque"=:xdatareferencia';
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
           SQL.Add('Update "ProdutoEstoque" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoEstoque"=:xid ');
           ParamByName('xid').AsInteger              := XIdEstoque;
           if XEstoque.TryGetValue('saldo',wval) then
              ParamByName('xsaldo').AsFloat          := strtofloatdef(XEstoque.GetValue('saldo').Value,0);
           if XEstoque.TryGetValue('custo',wval) then
              ParamByName('xcusto').AsFloat          := strtofloatdef(XEstoque.GetValue('custo').Value,0);
           if XEstoque.TryGetValue('custocontabil',wval) then
              ParamByName('xcustocontabil').AsFloat  := strtofloatdef(XEstoque.GetValue('custocontabil').Value,0);
           if XEstoque.TryGetValue('venda1',wval) then
              ParamByName('xvenda1').AsFloat         := strtofloatdef(XEstoque.GetValue('venda1').Value,0);
           if XEstoque.TryGetValue('venda2',wval) then
              ParamByName('xvenda2').AsFloat         := strtofloatdef(XEstoque.GetValue('venda2').Value,0);
           if XEstoque.TryGetValue('venda3',wval) then
              ParamByName('xvenda3').AsFloat         := strtofloatdef(XEstoque.GetValue('venda3').Value,0);
           if XEstoque.TryGetValue('venda4',wval) then
              ParamByName('xvenda4').AsFloat         := strtofloatdef(XEstoque.GetValue('venda4').Value,0);
           if XEstoque.TryGetValue('venda5',wval) then
              ParamByName('xvenda5').AsFloat         := strtofloatdef(XEstoque.GetValue('venda5').Value,0);
           if XEstoque.TryGetValue('ehinventario',wval) then
              ParamByName('xehinventario').AsBoolean := strtobooldef(XEstoque.GetValue('ehinventario').Value,false);
           if XEstoque.TryGetValue('datareferencia',wval) then
              ParamByName('xdatareferencia').AsDate  := strtodatedef(XEstoque.GetValue('datareferencia').Value,date);
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
              SQL.Add('select  "CodigoInternoProdutoEstoque" as id,');
              SQL.Add('        "CodigoProdutoEstoque"        as idproduto,');
              SQL.Add('        "SaldoProdutoEstoque"         as saldo,');
              SQL.Add('        "CustoProdutoEstoque"         as custo,');
              SQL.Add('        "CustoContabilProdutoEstoque" as custocontabil,');
              SQL.Add('        "Venda1ProdutoEstoque"        as venda1,');
              SQL.Add('        "Venda2ProdutoEstoque"        as venda2,');
              SQL.Add('        "Venda3ProdutoEstoque"        as venda3,');
              SQL.Add('        "Venda4ProdutoEstoque"        as venda4,');
              SQL.Add('        "Venda5ProdutoEstoque"        as venda5,');
              SQL.Add('        "CodigoEmpresaProdutoEstoque" as idempresa,');
              SQL.Add('        "InventarioProdutoEstoque"    as ehinventario,');
              SQL.Add('        "DataReferenciaProdutoEstoque" as datareferencia ');
              SQL.Add('from "ProdutoEstoque" ');
              SQL.Add('where "CodigoInternoProdutoEstoque" =:xid ');
              ParamByName('xid').AsInteger := XIdEstoque;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Estoque alterado');
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

function VerificaRequisicao(XEstoque: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XEstoque.TryGetValue('saldo',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaEstoque(XIdEstoque: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoEstoque" where "CodigoInternoProdutoEstoque"=:xid ');
         ParamByName('xid').AsInteger := XIdEstoque;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Estoque excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Estoque excluído');
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

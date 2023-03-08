unit dat.cadProdutosCombustiveis;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaCombustivel(XId: integer): TJSONObject;
function RetornaListaCombustiveis(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
function IncluiCombustivel(XCombustivel: TJSONObject; XIdProduto: integer): TJSONObject;
function AlteraCombustivel(XIdCombustivel: integer; XCombustivel: TJSONObject): TJSONObject;
function ApagaCombustivel(XIdCombustivel: integer): TJSONObject;
function VerificaRequisicao(XCombustivel: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaCombustivel(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoProdutoCombustivel" as id,');
         SQL.Add('        "CodigoProdutoCombustivel"        as idproduto,');
         SQL.Add('        "CodigoANPProdutoCombustivel"     as codigoanp,');
         SQL.Add('        "DescricaoANPProdutoCombustivel"  as descricaoanp,');
         SQL.Add('        "CFOPProdutoCombustivel"          as idcodigofiscal ');
         SQL.Add('from "ProdutoCombustivel" ');
         SQL.Add('where "CodigoInternoProdutoCombustivel"=:xid ');
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
        wret.AddPair('description','Nenhum Produto Combustível encontrado');
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

function RetornaListaCombustiveis(const XQuery: TDictionary<string, string>; XIdProduto: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoProdutoCombustivel" as id,');
         SQL.Add('        "CodigoProdutoCombustivel"        as idproduto,');
         SQL.Add('        "CodigoANPProdutoCombustivel"     as codigoanp,');
         SQL.Add('        "DescricaoANPProdutoCombustivel"  as descricaoanp,');
         SQL.Add('        "CFOPProdutoCombustivel"          as idcodigofiscal ');
         SQL.Add('from "ProdutoCombustivel" where "CodigoProdutoCombustivel"=:xidproduto ');
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
         wobj.AddPair('description','Nenhum Produto Combustível encontrado');
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

function IncluiCombustivel(XCombustivel: TJSONObject; XIdProduto: integer): TJSONObject;
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
           SQL.Add('Insert into "ProdutoCombustivel"("CodigoProdutoCombustivel","CodigoANPProdutoCombustivel","DescricaoANPProdutoCombustivel","CFOPProdutoCombustivel") ');
           SQL.Add('values (:xidproduto,:xcodigoanp,:xdescricaoanp,:xidcodigofiscal) ');
           ParamByName('xidproduto').AsInteger         := XIdProduto;
           if XCombustivel.TryGetValue('codigoanp',wval) then
              ParamByName('xcodigoanp').AsInteger     := strtointdef(XCombustivel.GetValue('codigoanp').Value,0)
           else
              ParamByName('xcodigoanp').AsInteger     := 0;
           if XCombustivel.TryGetValue('descricaoanp',wval) then
              ParamByName('xdescricaoanp').AsString   := XCombustivel.GetValue('descricaoanp').Value
           else
              ParamByName('xdescricaoanp').AsString   := '';
           if XCombustivel.TryGetValue('idcodigofiscal',wval) then
              ParamByName('xidcodigofiscal').AsInteger := strtointdef(XCombustivel.GetValue('idcodigofiscal').Value,0)
           else
              ParamByName('xidcodigofiscal').AsInteger := 0;
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
                SQL.Add('select  "CodigoInternoProdutoCombustivel" as id,');
                SQL.Add('        "CodigoProdutoCombustivel"        as idproduto,');
                SQL.Add('        "CodigoANPProdutoCombustivel"     as codigoanp,');
                SQL.Add('        "DescricaoANPProdutoCombustivel"  as descricaoanp,');
                SQL.Add('        "CFOPProdutoCombustivel"          as idcodigofiscal ');
                SQL.Add('from "ProdutoCombustivel" where "CodigoProdutoCombustivel"=:xidproduto and "CodigoANPProdutoCombustivel"=:xcodigoanp ');
                ParamByName('xidproduto').AsInteger     := XIdProduto;
                if XCombustivel.TryGetValue('codigoanp',wval) then
                   ParamByName('xcodigoanp').AsInteger     := strtointdef(XCombustivel.GetValue('codigoanp').Value,0)
                else
                   ParamByName('xcodigoanp').AsInteger     := 0;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Combustível incluído');
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

function AlteraCombustivel(XIdCombustivel: integer; XCombustivel: TJSONObject): TJSONObject;
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
    if XCombustivel.TryGetValue('codigoanp',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoANPProdutoCombustivel"=:xcodigoanp'
         else
            wcampos := wcampos+',"CodigoANPProdutoCombustivel"=:xcodigoanp';
       end;
    if XCombustivel.TryGetValue('descricaoanp',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoANPProdutoCombustivel"=:xdescricaoanp'
         else
            wcampos := wcampos+',"DescricaoANPProdutoCombustivel"=:xdescricaoanp';
       end;
    if XCombustivel.TryGetValue('idcodigofiscal',wval) then
       begin
         if wcampos='' then
            wcampos := '"CFOPProdutoCombustivel"=:xidcodigofiscal'
         else
            wcampos := wcampos+',"CFOPProdutoCombustivel"=:xidcodigofiscal';
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
           SQL.Add('Update "ProdutoCombustivel" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoProdutoCombustivel"=:xid ');
           ParamByName('xid').AsInteger                := XIdCombustivel;
           if XCombustivel.TryGetValue('codigoanp',wval) then
              ParamByName('xcodigoanp').AsInteger      := strtointdef(XCombustivel.GetValue('codigoanp').Value,0);
           if XCombustivel.TryGetValue('descricaoanp',wval) then
              ParamByName('xdescricaoanp').AsString    := XCombustivel.GetValue('descricaoanp').Value;
           if XCombustivel.TryGetValue('idcodigofiscal',wval) then
              ParamByName('xidcodigofiscal').AsInteger := strtointdef(XCombustivel.GetValue('idcodigofiscal').Value,0);
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
              SQL.Add('select  "CodigoInternoProdutoCombustivel" as id,');
              SQL.Add('        "CodigoProdutoCombustivel"        as idproduto,');
              SQL.Add('        "CodigoANPProdutoCombustivel"     as codigoanp,');
              SQL.Add('        "DescricaoANPProdutoCombustivel"  as descricaoanp,');
              SQL.Add('        "CFOPProdutoCombustivel"          as idcodigofiscal ');
              SQL.Add('from "ProdutoCombustivel" ');
              SQL.Add('where "CodigoInternoProdutoCombustivel" =:xid ');
              ParamByName('xid').AsInteger := XIdCombustivel;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Produto Combustível alterado');
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

function VerificaRequisicao(XCombustivel: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XCombustivel.TryGetValue('codigoanp',wval) then
       wret := false;
    if not XCombustivel.TryGetValue('descricaoanp',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaCombustivel(XIdCombustivel: integer): TJSONObject;
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
         SQL.Add('delete from "ProdutoCombustivel" where "CodigoInternoProdutoCombustivel"=:xid ');
         ParamByName('xid').AsInteger := XIdCombustivel;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Produto Combustível excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Produto Combustível excluído');
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

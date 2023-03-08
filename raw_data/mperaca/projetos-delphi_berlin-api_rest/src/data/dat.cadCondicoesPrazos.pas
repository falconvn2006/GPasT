unit dat.cadCondicoesPrazos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaCondicaoPrazo(XId: integer): TJSONObject;
function RetornaListaCondicoesPrazos(const XQuery: TDictionary<string, string>; XIdCondicao: integer): TJSONArray;
function IncluiCondicaoPrazo(XCondicaoPrazo: TJSONObject; XIdCondicao: integer): TJSONObject;
function VerificaRequisicao(XCondicaoPrazo: TJSONObject): boolean;
function AlteraCondicaoPrazo(XIdCondicaoPrazo: integer; XCondicaoPrazo: TJSONObject): TJSONObject;
function ApagaCondicaoPrazo(XIdCondicaoPrazo: integer): TJSONObject;

implementation

uses prv.dataModuleConexao;

function RetornaCondicaoPrazo(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoPrazo"  as id,');
         SQL.Add('       "CodigoCondicaoPrazo" as idcondicao,');
         SQL.Add('       "DiasVencimentoPrazo" as diasvencimento,');
         SQL.Add('       "PercentualPrazo"     as percentual,');
         SQL.Add('       "FracaoPrazo"         as fracao,');
         SQL.Add('       "NumeroParcelaPrazo"  as numparcela ');
         SQL.Add('from "CondicaoPrazo" ');
         SQL.Add('where "CodigoInternoPrazo"=:xid ');
         ParamByName('xid').AsInteger := XId;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','404');
        wret.AddPair('description','Nenhum prazo encontrado');
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

function RetornaListaCondicoesPrazos(const XQuery: TDictionary<string, string>; XIdCondicao: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoPrazo"  as id,');
         SQL.Add('       "CodigoCondicaoPrazo" as idcondicao,');
         SQL.Add('       "DiasVencimentoPrazo" as diasvencimento,');
         SQL.Add('       "PercentualPrazo"     as percentual,');
         SQL.Add('       "FracaoPrazo"         as fracao,');
         SQL.Add('       "NumeroParcelaPrazo"  as numparcela ');
         SQL.Add('from "CondicaoPrazo" ');
         SQL.Add('where "CodigoCondicaoPrazo"=:xidcondicao ');
         ParamByName('xidcondicao').AsInteger := XIdCondicao;
         SQL.Add('order by "CodigoInternoPrazo" ');
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','404');
         wobj.AddPair('description','Nenhum prazo encontrado');
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

function IncluiCondicaoPrazo(XCondicaoPrazo: TJSONObject; XIdCondicao: integer): TJSONObject;
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
           SQL.Add('Insert into "CondicaoPrazo" ("CodigoEmpresaPrazo","CodigoCondicaoPrazo","DiasVencimentoPrazo",');
           SQL.Add('"PercentualPrazo","FracaoPrazo","NumeroParcelaPrazo") ');
           SQL.Add('values (:xidempresa,:xidcondicao,:xdiasvencimento,:xpercentual,:xfracao,:xnumparcela) ');

           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaCondicao;
           ParamByName('xidcondicao').AsInteger  := XIdCondicao;
           if XCondicaoPrazo.TryGetValue('diasvencimento',wval) then
              ParamByName('xdiasvencimento').AsInteger  := strtointdef(XCondicaoPrazo.GetValue('diasvencimento').Value,0)
           else
              ParamByName('xdiasvencimento').AsInteger  := 0;
           if XCondicaoPrazo.TryGetValue('percentual',wval) then
              ParamByName('xpercentual').AsFloat        := strtofloatdef(XCondicaoPrazo.GetValue('percentual').Value,0)
           else
              ParamByName('xpercentual').AsFloat        := 0;
           if XCondicaoPrazo.TryGetValue('fracao',wval) then
              ParamByName('xfracao').AsInteger  := strtointdef(XCondicaoPrazo.GetValue('fracao').Value,0)
           else
              ParamByName('xfracao').AsInteger  := 0;
           if XCondicaoPrazo.TryGetValue('numparcela',wval) then
              ParamByName('xnumparcela').AsString  := XCondicaoPrazo.GetValue('numparcela').Value
           else
              ParamByName('xnumparcela').AsString  := '';
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
                SQL.Add('select "CodigoInternoPrazo"  as id,');
                SQL.Add('       "CodigoCondicaoPrazo" as idcondicao,');
                SQL.Add('       "DiasVencimentoPrazo" as diasvencimento,');
                SQL.Add('       "PercentualPrazo"     as percentual,');
                SQL.Add('       "FracaoPrazo"         as fracao,');
                SQL.Add('       "NumeroParcelaPrazo"  as numparcela ');
                SQL.Add('from "CondicaoPrazo" where "CodigoCondicaoPrazo"=:xidcondicao and "DiasVencimentoPrazo"=:xdiasvencimento ');
                ParamByName('xidcondicao').AsInteger     := XIdCondicao;
                ParamByName('xdiasvencimento').AsInteger := strtointdef(XCondicaoPrazo.GetValue('diasvencimento').Value,0);
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Prazo incluído');
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

function VerificaRequisicao(XCondicaoPrazo: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XCondicaoPrazo.TryGetValue('diasvencimento',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function AlteraCondicaoPrazo(XIdCondicaoPrazo: integer; XCondicaoPrazo: TJSONObject): TJSONObject;
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
    if XCondicaoPrazo.TryGetValue('diasvencimento',wval) then
       begin
         if wcampos='' then
            wcampos := '"DiasVencimentoPrazo"=:xdiasvencimento'
         else
            wcampos := wcampos+',"DiasVencimentoPrazo"=:xdiasvencimento';
       end;
    if XCondicaoPrazo.TryGetValue('percentual',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercentualPrazo"=:xpercentual'
         else
            wcampos := wcampos+',"PercentualPrazo"=:xpercentual';
       end;
    if XCondicaoPrazo.TryGetValue('fracao',wval) then
       begin
         if wcampos='' then
            wcampos := '"FracaoPrazo"=:xfracao'
         else
            wcampos := wcampos+',"FracaoPrazo"=:xfracao';
       end;
    if XCondicaoPrazo.TryGetValue('numparcela',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroParcelaPrazo"=:xnumparcela'
         else
            wcampos := wcampos+',"NumeroParcelaPrazo"=:xnumparcela';
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
           SQL.Add('Update "CondicaoPrazo" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoPrazo"=:xid ');
           ParamByName('xid').AsInteger      := XIdCondicaoPrazo;
           if XCondicaoPrazo.TryGetValue('diasvencimento',wval) then
              ParamByName('xdiasvencimento').AsInteger := strtointdef(XCondicaoPrazo.GetValue('diasvencimento').Value,0);
           if XCondicaoPrazo.TryGetValue('percentual',wval) then
              ParamByName('xpercentual').AsFloat       := strtofloatdef(XCondicaoPrazo.GetValue('percentual').Value,0);
           if XCondicaoPrazo.TryGetValue('fracao',wval) then
              ParamByName('xfracao').AsFloat           := strtofloatdef(XCondicaoPrazo.GetValue('fracao').Value,0);
           if XCondicaoPrazo.TryGetValue('numparcela',wval) then
              ParamByName('xnumparcela').AsString      := XCondicaoPrazo.GetValue('numparcela').Value;
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
              SQL.Add('select "CodigoInternoPrazo"  as id,');
              SQL.Add('       "CodigoCondicaoPrazo" as idcondicao,');
              SQL.Add('       "DiasVencimentoPrazo" as diasvencimento,');
              SQL.Add('       "PercentualPrazo"     as percentual,');
              SQL.Add('       "FracaoPrazo"         as fracao,');
              SQL.Add('       "NumeroParcelaPrazo"  as numparcela ');
              SQL.Add('from "CondicaoPrazo" ');
              SQL.Add('where "CodigoInternoPrazo" =:xid ');
              ParamByName('xid').AsInteger := XIdCondicaoPrazo;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Prazo alterado');
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

function ApagaCondicaoPrazo(XIdCondicaoPrazo: integer): TJSONObject;
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
         SQL.Add('delete from "CondicaoPrazo" where "CodigoInternoPrazo"=:xid ');
         ParamByName('xid').AsInteger := XIdCondicaoPrazo;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Prazo excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Prazo excluído');
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

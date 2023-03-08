unit dat.cadGradesTitulos;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaTitulo(XId: integer): TJSONObject;
function RetornaListaTitulos(const XQuery: TDictionary<string, string>; XIdGrade: integer): TJSONArray;
function IncluiTitulo(XTitulo: TJSONObject; XIdGrade: integer): TJSONObject;
function AlteraTitulo(XIdTitulo: integer; XTitulo: TJSONObject): TJSONObject;
function ApagaTitulo(XIdTitulo: integer): TJSONObject;
function VerificaRequisicao(XTitulo: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaTitulo(XId: integer): TJSONObject;
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
         SQL.Add('select  "CodigoInternoGradeTitulo" as id,');
         SQL.Add('        "CodigoGradeTitulo"        as idgrade,');
         SQL.Add('        "NumeroGradeTitulo"        as numero,');
         SQL.Add('        "TituloGradeTitulo"        as titulo ');
         SQL.Add('from "GradeTitulo" ');
         SQL.Add('where "CodigoInternoGradeTitulo"=:xid ');
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
        wret.AddPair('description','Nenhum Título encontrado');
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

function RetornaListaTitulos(const XQuery: TDictionary<string, string>; XIdGrade: integer): TJSONArray;
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
         SQL.Add('select  "CodigoInternoGradeTitulo" as id,');
         SQL.Add('        "CodigoGradeTitulo"        as idgrade,');
         SQL.Add('        "NumeroGradeTitulo"        as numero,');
         SQL.Add('        "TituloGradeTitulo"        as titulo ');
         SQL.Add('from "GradeTitulo" where "CodigoGradeTitulo"=:xidgrade ');
         ParamByName('xidgrade').AsInteger := XIdGrade;
         if XQuery.ContainsKey('titulo') then // filtro por titulo
            begin
              SQL.Add('and lower("TituloGradeTitulo") like lower(:xtitulo) ');
              ParamByName('xtitulo').AsString := XQuery.Items['nome']+'%';
              SQL.Add('order by "TituloGradeTitulo" ');
            end;
         if XQuery.ContainsKey('numero') then // filtro por numero
            begin
              SQL.Add('and "NumeroGradeTitulo" =:xnumero ');
              ParamByName('xnumero').AsInteger := strtointdef(XQuery.Items['numero'],0);
              SQL.Add('order by "NumeroGradeTitulo" ');
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
         wobj.AddPair('description','Nenhum Título encontrado');
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

function IncluiTitulo(XTitulo: TJSONObject; XIdGrade: integer): TJSONObject;
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
           SQL.Add('Insert into "GradeTitulo" ("CodigoGradeTitulo","NumeroGradeTitulo","TituloGradeTitulo") ');
           SQL.Add('values (:xidgrade,:xnumero,:xtitulo) ');
           ParamByName('xidgrade').AsInteger   := XIdGrade;
           ParamByName('xnumero').AsInteger    := strtointdef(XTitulo.GetValue('numero').Value,0);
           ParamByName('xtitulo').AsString     := XTitulo.GetValue('titulo').Value;
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
                SQL.Add('select  "CodigoInternoGradeTitulo" as id,');
                SQL.Add('        "CodigoGradeTitulo"        as idgrade,');
                SQL.Add('        "NumeroGradeTitulo"        as numero,');
                SQL.Add('        "TituloGradeTitulo"        as titulo ');
                SQL.Add('from "GradeTitulo" where "CodigoGradeTitulo"=:xidgrade and "NumeroGradeTitulo"=:xnumero ');
                ParamByName('xidgrade').AsInteger  := XIdGrade;
                ParamByName('xnumero').AsInteger   := strtointdef(XTitulo.GetValue('numero').Value,0);
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Título incluído');
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


function AlteraTitulo(XIdTitulo: integer; XTitulo: TJSONObject): TJSONObject;
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
    if XTitulo.TryGetValue('numero',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroGradeTitulo"=:xnumero'
         else
            wcampos := wcampos+',"NumeroGradeTitulo"=:xnumero';
       end;
    if XTitulo.TryGetValue('titulo',wval) then
       begin
         if wcampos='' then
            wcampos := '"TituloGradeTitulo"=:xtitulo'
         else
            wcampos := wcampos+',"TituloGradeTitulo"=:xtitulo';
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
           SQL.Add('Update "GradeTitulo" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoGradeTitulo"=:xid ');
           ParamByName('xid').AsInteger       := XIdTitulo;
           if XTitulo.TryGetValue('numero',wval) then
              ParamByName('xnumero').AsInteger   := strtointdef(XTitulo.GetValue('numero').Value,0);
           if XTitulo.TryGetValue('titulo',wval) then
              ParamByName('xtitulo').AsString    := XTitulo.GetValue('titulo').Value;
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
              SQL.Add('select  "CodigoInternoGradeTitulo" as id,');
              SQL.Add('        "CodigoGradeTitulo"        as idgrade,');
              SQL.Add('        "NumeroGradeTitulo"        as numero,');
              SQL.Add('        "TituloGradeTitulo"        as titulo ');
              SQL.Add('from "GradeTitulo" ');
              SQL.Add('where "CodigoInternoGradeTitulo" =:xid ');
              ParamByName('xid').AsInteger := XIdTitulo;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Título alterado');
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

function VerificaRequisicao(XTitulo: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XTitulo.TryGetValue('numero',wval) then
       wret := false;
    if not XTitulo.TryGetValue('titulo',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaTitulo(XIdTitulo: integer): TJSONObject;
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
         SQL.Add('delete from "GradeTitulo" where "CodigoInternoGradeTitulo"=:xid ');
         ParamByName('xid').AsInteger := XIdTitulo;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Título excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Título excluído');
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

unit dat.cadFormulas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaFormula(XId: integer): TJSONObject;
function RetornaListaFormulas(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiFormula(XFormula: TJSONObject): TJSONObject;
function AlteraFormula(XIdFormula: integer; XFormula: TJSONObject): TJSONObject;
function ApagaFormula(XIdFormula: integer): TJSONObject;
function VerificaRequisicao(XFormula: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaFormula(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoFormula"  as id,');
         SQL.Add('       "DescricaoFormula"      as descricao,');
         SQL.Add('       "MetodoCustoFormula"    as metodocusto,');
         SQL.Add('       "MetodoPreco1Formula"   as metodopreco1,');
         SQL.Add('       "MetodoPreco2Formula"   as metodopreco2,');
         SQL.Add('       "MetodoPreco3Formula"   as metodopreco3,');
         SQL.Add('       "MetodoPreco4Formula"   as metodopreco4,');
         SQL.Add('       "MetodoPreco5Formula"   as metodopreco5,');
         SQL.Add('       "MetodoPreco6Formula"   as metodopreco6,');
         SQL.Add('       "MetodoPreco7Formula"   as metodopreco7,');
         SQL.Add('       "MetodoPreco8Formula"   as metodopreco8,');
         SQL.Add('       "MetodoPreco9Formula"   as metodopreco9,');
         SQL.Add('       "MetodoPreco10Formula"  as metodopreco10,');
         SQL.Add('       "MetodoContabilFormula" as metodocontabil,');
         SQL.Add('       "FormulaCustoFormula"   as formulacusto,');
         SQL.Add('       "FormulaPreco1Formula"  as formulapreco1,');
         SQL.Add('       "FormulaPreco2Formula"  as formulapreco2,');
         SQL.Add('       "FormulaPreco3Formula"  as formulapreco3,');
         SQL.Add('       "FormulaPreco4Formula"  as formulapreco4,');
         SQL.Add('       "FormulaPreco5Formula"  as formulapreco5,');
         SQL.Add('       "FormulaPreco6Formula"  as formulapreco6,');
         SQL.Add('       "FormulaPreco7Formula"  as formulapreco7,');
         SQL.Add('       "FormulaPreco8Formula"  as formulapreco8,');
         SQL.Add('       "FormulaPreco9Formula"  as formulapreco9,');
         SQL.Add('       "FormulaPreco10Formula" as formulapreco10,');
         SQL.Add('       "FormulaContabilFormula" as formulacontabil,');
         SQL.Add('       "IndiceCustoFormula"    as indicecusto,');
         SQL.Add('       "IndicePreco1Formula"   as indicepreco1,');
         SQL.Add('       "IndicePreco2Formula"   as indicepreco2,');
         SQL.Add('       "IndicePreco3Formula"   as indicepreco3,');
         SQL.Add('       "IndicePreco4Formula"   as indicepreco4,');
         SQL.Add('       "IndicePreco5Formula"   as indicepreco5,');
         SQL.Add('       "IndicePreco6Formula"   as indicepreco6,');
         SQL.Add('       "IndicePreco7Formula"   as indicepreco7,');
         SQL.Add('       "IndicePreco8Formula"   as indicepreco8,');
         SQL.Add('       "IndicePreco9Formula"   as indicepreco9,');
         SQL.Add('       "IndicePreco10Formula"  as indicepreco10,');
         SQL.Add('       "IndiceContabilFormula" as indicecontabil,');
         SQL.Add('       "ValorCustoFormula"     as valorcusto,');
         SQL.Add('       "ValorPreco1Formula"    as valorpreco1,');
         SQL.Add('       "ValorPreco2Formula"    as valorpreco2,');
         SQL.Add('       "ValorPreco3Formula"    as valorpreco3,');
         SQL.Add('       "ValorPreco4Formula"    as valorpreco4,');
         SQL.Add('       "ValorPreco5Formula"    as valorpreco5,');
         SQL.Add('       "ValorPreco6Formula"    as valorpreco6,');
         SQL.Add('       "ValorPreco7Formula"    as valorpreco7,');
         SQL.Add('       "ValorPreco8Formula"    as valorpreco8,');
         SQL.Add('       "ValorPreco9Formula"    as valorpreco9,');
         SQL.Add('       "ValorPreco10Formula"   as valorpreco10,');
         SQL.Add('       "ValorContabilFormula"  as valorcontabil,');
         SQL.Add('       "TipoArredondaTruncaFormula" as tipoarredondatrunca,');
         SQL.Add('       "CasasDecimaisArredondaFormula" as casasdecimais,');
         SQL.Add('       "TipoAntesAposFormula"          as tipoantesapos ');
         SQL.Add('from "Formula" ');
         SQL.Add('where "CodigoInternoFormula"=:xid ');
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
        wret.AddPair('description','Nenhuma Fórmula encontrada');
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

function RetornaListaFormulas(const XQuery: TDictionary<string, string>): TJSONArray;
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
         SQL.Add('select "CodigoInternoFormula"  as id,');
         SQL.Add('       "DescricaoFormula"      as descricao,');
         SQL.Add('       "MetodoCustoFormula"    as metodocusto,');
         SQL.Add('       "MetodoPreco1Formula"   as metodopreco1,');
         SQL.Add('       "MetodoPreco2Formula"   as metodopreco2,');
         SQL.Add('       "MetodoPreco3Formula"   as metodopreco3,');
         SQL.Add('       "MetodoPreco4Formula"   as metodopreco4,');
         SQL.Add('       "MetodoPreco5Formula"   as metodopreco5,');
         SQL.Add('       "MetodoPreco6Formula"   as metodopreco6,');
         SQL.Add('       "MetodoPreco7Formula"   as metodopreco7,');
         SQL.Add('       "MetodoPreco8Formula"   as metodopreco8,');
         SQL.Add('       "MetodoPreco9Formula"   as metodopreco9,');
         SQL.Add('       "MetodoPreco10Formula"  as metodopreco10,');
         SQL.Add('       "MetodoContabilFormula" as metodocontabil,');
         SQL.Add('       "FormulaCustoFormula"   as formulacusto,');
         SQL.Add('       "FormulaPreco1Formula"  as formulapreco1,');
         SQL.Add('       "FormulaPreco2Formula"  as formulapreco2,');
         SQL.Add('       "FormulaPreco3Formula"  as formulapreco3,');
         SQL.Add('       "FormulaPreco4Formula"  as formulapreco4,');
         SQL.Add('       "FormulaPreco5Formula"  as formulapreco5,');
         SQL.Add('       "FormulaPreco6Formula"  as formulapreco6,');
         SQL.Add('       "FormulaPreco7Formula"  as formulapreco7,');
         SQL.Add('       "FormulaPreco8Formula"  as formulapreco8,');
         SQL.Add('       "FormulaPreco9Formula"  as formulapreco9,');
         SQL.Add('       "FormulaPreco10Formula" as formulapreco10,');
         SQL.Add('       "FormulaContabilFormula" as formulacontabil,');
         SQL.Add('       "IndiceCustoFormula"    as indicecusto,');
         SQL.Add('       "IndicePreco1Formula"   as indicepreco1,');
         SQL.Add('       "IndicePreco2Formula"   as indicepreco2,');
         SQL.Add('       "IndicePreco3Formula"   as indicepreco3,');
         SQL.Add('       "IndicePreco4Formula"   as indicepreco4,');
         SQL.Add('       "IndicePreco5Formula"   as indicepreco5,');
         SQL.Add('       "IndicePreco6Formula"   as indicepreco6,');
         SQL.Add('       "IndicePreco7Formula"   as indicepreco7,');
         SQL.Add('       "IndicePreco8Formula"   as indicepreco8,');
         SQL.Add('       "IndicePreco9Formula"   as indicepreco9,');
         SQL.Add('       "IndicePreco10Formula"  as indicepreco10,');
         SQL.Add('       "IndiceContabilFormula" as indicecontabil,');
         SQL.Add('       "ValorCustoFormula"     as valorcusto,');
         SQL.Add('       "ValorPreco1Formula"    as valorpreco1,');
         SQL.Add('       "ValorPreco2Formula"    as valorpreco2,');
         SQL.Add('       "ValorPreco3Formula"    as valorpreco3,');
         SQL.Add('       "ValorPreco4Formula"    as valorpreco4,');
         SQL.Add('       "ValorPreco5Formula"    as valorpreco5,');
         SQL.Add('       "ValorPreco6Formula"    as valorpreco6,');
         SQL.Add('       "ValorPreco7Formula"    as valorpreco7,');
         SQL.Add('       "ValorPreco8Formula"    as valorpreco8,');
         SQL.Add('       "ValorPreco9Formula"    as valorpreco9,');
         SQL.Add('       "ValorPreco10Formula"   as valorpreco10,');
         SQL.Add('       "ValorContabilFormula"  as valorcontabil,');
         SQL.Add('       "TipoArredondaTruncaFormula" as tipoarredondatrunca,');
         SQL.Add('       "CasasDecimaisArredondaFormula" as casasdecimais,');
         SQL.Add('       "TipoAntesAposFormula"          as tipoantesapos ');
         SQL.Add('from "Formula" where "CodigoEmpresaFormula"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaFormula;
         if XQuery.ContainsKey('descricao') then // filtro por descrição
            begin
              SQL.Add('and lower("DescricaoFormula") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
              SQL.Add('order by "DescricaoFormula" ');
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
         wobj.AddPair('description','Nenhuma Fórmula encontrada');
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

function IncluiFormula(XFormula: TJSONObject): TJSONObject;
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
           SQL.Add('Insert into "Formula" ("CodigoEmpresaFormula","DescricaoFormula","MetodoCustoFormula","MetodoPreco1Formula","MetodoPreco2Formula",');
           SQL.Add('"MetodoPreco3Formula","MetodoPreco4Formula","MetodoPreco5Formula","MetodoPreco6Formula","MetodoPreco7Formula","MetodoPreco8Formula",');
           SQL.Add('"MetodoPreco9Formula","MetodoPreco10Formula","MetodoContabilFormula","FormulaCustoFormula","FormulaPreco1Formula","FormulaPreco2Formula","FormulaPreco3Formula",');
           SQL.Add('"FormulaPreco4Formula","FormulaPreco5Formula","FormulaPreco6Formula","FormulaPreco7Formula","FormulaPreco8Formula","FormulaPreco9Formula",');
           SQL.Add('"FormulaPreco10Formula","FormulaContabilFormula","IndiceCustoFormula","IndicePreco1Formula","IndicePreco2Formula","IndicePreco3Formula","IndicePreco4Formula",');
           SQL.Add('"IndicePreco5Formula","IndicePreco6Formula","IndicePreco7Formula","IndicePreco8Formula","IndicePreco9Formula","IndicePreco10Formula","IndiceContabilFormula",');
           SQL.Add('"ValorCustoFormula","ValorPreco1Formula","ValorPreco2Formula","ValorPreco3Formula","ValorPreco4Formula","ValorPreco5Formula",');
           SQL.Add('"ValorPreco6Formula","ValorPreco7Formula","ValorPreco8Formula","ValorPreco9Formula","ValorPreco10Formula","ValorContabilFormula",');
           SQL.Add('"TipoArredondaTruncaFormula","CasasDecimaisArredondaFormula","TipoAntesAposFormula") ');
           SQL.Add('values (:xidempresa,:xdescricao,:xmetodocusto,:xmetodopreco1,:xmetodopreco2,');
           SQL.Add(':xmetodopreco3,:xmetodopreco4,:xmetodopreco5,:xmetodopreco6,:xmetodopreco7,:xmetodopreco8,');
           SQL.Add(':xmetodopreco9,:xmetodopreco10,:xmetodocontabil,:xformulacusto,:xformulapreco1,:xformulapreco2,:xformulapreco3,');
           SQL.Add(':xformulapreco4,:xformulapreco5,:xformulapreco6,:xformulapreco7,:xformulapreco8,:xformulapreco9,');
           SQL.Add(':xformulapreco10,:xformulacontabil,:xindicecusto,:xindicepreco1,:xindicepreco2,:xindicepreco3,:xindicepreco4,');
           SQL.Add(':xindicepreco5,:xindicepreco6,:xindicepreco7,:xindicepreco8,:xindicepreco9,:xindicepreco10,:xindicecontabil,');
           SQL.Add(':xvalorcusto,:xvalorpreco1,:xvalorpreco2,:xvalorpreco3,:xvalorpreco4,:xvalorpreco5,');
           SQL.Add(':xvalorpreco6,:xvalorpreco7,:xvalorpreco8,:xvalorpreco9,:xvalorpreco10,:xvalorcontabil,');
           SQL.Add(':xtipoarredondatrunca,:xcasasdecimais,:xtipoantesapos) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaFormula;
           ParamByName('xdescricao').AsString    := XFormula.GetValue('descricao').Value;
           if XFormula.TryGetValue('metodocusto',wval) then
              ParamByName('xmetodocusto').AsString    := XFormula.GetValue('metodocusto').Value
           else
              ParamByName('xmetodocusto').AsString    := '';
           if XFormula.TryGetValue('metodopreco1',wval) then
              ParamByName('xmetodopreco1').AsString   := XFormula.GetValue('metodopreco1').Value
           else
              ParamByName('xmetodopreco1').AsString   := '';
           if XFormula.TryGetValue('metodopreco2',wval) then
              ParamByName('xmetodopreco2').AsString   := XFormula.GetValue('metodopreco2').Value
           else
              ParamByName('xmetodopreco2').AsString   := '';
           if XFormula.TryGetValue('metodopreco3',wval) then
              ParamByName('xmetodopreco3').AsString   := XFormula.GetValue('metodopreco3').Value
           else
              ParamByName('xmetodopreco3').AsString   := '';
           if XFormula.TryGetValue('metodopreco4',wval) then
              ParamByName('xmetodopreco4').AsString   := XFormula.GetValue('metodopreco4').Value
           else
              ParamByName('xmetodopreco4').AsString   := '';
           if XFormula.TryGetValue('metodopreco5',wval) then
              ParamByName('xmetodopreco5').AsString   := XFormula.GetValue('metodopreco5').Value
           else
              ParamByName('xmetodopreco5').AsString   := '';
           if XFormula.TryGetValue('metodopreco6',wval) then
              ParamByName('xmetodopreco6').AsString   := XFormula.GetValue('metodopreco6').Value
           else
              ParamByName('xmetodopreco6').AsString   := '';
           if XFormula.TryGetValue('metodopreco7',wval) then
              ParamByName('xmetodopreco7').AsString   := XFormula.GetValue('metodopreco7').Value
           else
              ParamByName('xmetodopreco7').AsString   := '';
           if XFormula.TryGetValue('metodopreco8',wval) then
              ParamByName('xmetodopreco8').AsString   := XFormula.GetValue('metodopreco8').Value
           else
              ParamByName('xmetodopreco8').AsString   := '';
           if XFormula.TryGetValue('metodopreco9',wval) then
              ParamByName('xmetodopreco9').AsString   := XFormula.GetValue('metodopreco9').Value
           else
              ParamByName('xmetodopreco9').AsString   := '';
           if XFormula.TryGetValue('metodopreco10',wval) then
              ParamByName('xmetodopreco10').AsString   := XFormula.GetValue('metodopreco10').Value
           else
              ParamByName('xmetodopreco10').AsString   := '';
           if XFormula.TryGetValue('metodocontabil',wval) then
              ParamByName('xmetodocontabil').AsString   := XFormula.GetValue('metodocontabil').Value
           else
              ParamByName('xmetodocontabil').AsString   := '';
           if XFormula.TryGetValue('formulacusto',wval) then
              ParamByName('xformulacusto').AsString   := XFormula.GetValue('formulacusto').Value
           else
              ParamByName('xformulacusto').AsString   := '';
           if XFormula.TryGetValue('formulapreco1',wval) then
              ParamByName('xformulapreco1').AsString   := XFormula.GetValue('formulapreco1').Value
           else
              ParamByName('xformulapreco1').AsString   := '';
           if XFormula.TryGetValue('formulapreco2',wval) then
              ParamByName('xformulapreco2').AsString   := XFormula.GetValue('formulapreco2').Value
           else
              ParamByName('xformulapreco2').AsString   := '';
           if XFormula.TryGetValue('formulapreco3',wval) then
              ParamByName('xformulapreco3').AsString   := XFormula.GetValue('formulapreco3').Value
           else
              ParamByName('xformulapreco3').AsString   := '';
           if XFormula.TryGetValue('formulapreco4',wval) then
              ParamByName('xformulapreco4').AsString   := XFormula.GetValue('formulapreco4').Value
           else
              ParamByName('xformulapreco4').AsString   := '';
           if XFormula.TryGetValue('formulapreco5',wval) then
              ParamByName('xformulapreco5').AsString   := XFormula.GetValue('formulapreco5').Value
           else
              ParamByName('xformulapreco5').AsString   := '';
           if XFormula.TryGetValue('formulapreco6',wval) then
              ParamByName('xformulapreco6').AsString   := XFormula.GetValue('formulapreco6').Value
           else
              ParamByName('xformulapreco6').AsString   := '';
           if XFormula.TryGetValue('formulapreco7',wval) then
              ParamByName('xformulapreco7').AsString   := XFormula.GetValue('formulapreco7').Value
           else
              ParamByName('xformulapreco7').AsString   := '';
           if XFormula.TryGetValue('formulapreco8',wval) then
              ParamByName('xformulapreco8').AsString   := XFormula.GetValue('formulapreco8').Value
           else
              ParamByName('xformulapreco8').AsString   := '';
           if XFormula.TryGetValue('formulapreco9',wval) then
              ParamByName('xformulapreco9').AsString   := XFormula.GetValue('formulapreco9').Value
           else
              ParamByName('xformulapreco9').AsString   := '';
           if XFormula.TryGetValue('formulapreco10',wval) then
              ParamByName('xformulapreco10').AsString   := XFormula.GetValue('formulapreco10').Value
           else
              ParamByName('xformulapreco10').AsString   := '';
           if XFormula.TryGetValue('formulacontabil',wval) then
              ParamByName('xformulacontabil').AsString   := XFormula.GetValue('formulacontabil').Value
           else
              ParamByName('xformulacontabil').AsString   := '';
           if XFormula.TryGetValue('indicecusto',wval) then
              ParamByName('xindicecusto').AsInteger      := strtointdef(XFormula.GetValue('indicecusto').Value,0)
           else
              ParamByName('xindicecusto').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco1',wval) then
              ParamByName('xindicepreco1').AsInteger      := strtointdef(XFormula.GetValue('indicepreco1').Value,0)
           else
              ParamByName('xindicepreco1').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco2',wval) then
              ParamByName('xindicepreco2').AsInteger      := strtointdef(XFormula.GetValue('indicepreco2').Value,0)
           else
              ParamByName('xindicepreco2').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco3',wval) then
              ParamByName('xindicepreco3').AsInteger      := strtointdef(XFormula.GetValue('indicepreco3').Value,0)
           else
              ParamByName('xindicepreco3').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco4',wval) then
              ParamByName('xindicepreco4').AsInteger      := strtointdef(XFormula.GetValue('indicepreco4').Value,0)
           else
              ParamByName('xindicepreco4').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco5',wval) then
              ParamByName('xindicepreco5').AsInteger      := strtointdef(XFormula.GetValue('indicepreco5').Value,0)
           else
              ParamByName('xindicepreco5').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco6',wval) then
              ParamByName('xindicepreco6').AsInteger      := strtointdef(XFormula.GetValue('indicepreco6').Value,0)
           else
              ParamByName('xindicepreco6').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco7',wval) then
              ParamByName('xindicepreco7').AsInteger      := strtointdef(XFormula.GetValue('indicepreco7').Value,0)
           else
              ParamByName('xindicepreco7').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco8',wval) then
              ParamByName('xindicepreco8').AsInteger      := strtointdef(XFormula.GetValue('indicepreco8').Value,0)
           else
              ParamByName('xindicepreco8').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco9',wval) then
              ParamByName('xindicepreco9').AsInteger      := strtointdef(XFormula.GetValue('indicepreco9').Value,0)
           else
              ParamByName('xindicepreco9').AsInteger      := 0;
           if XFormula.TryGetValue('indicepreco10',wval) then
              ParamByName('xindicepreco10').AsInteger      := strtointdef(XFormula.GetValue('indicepreco10').Value,0)
           else
              ParamByName('xindicepreco10').AsInteger      := 0;
           if XFormula.TryGetValue('indicecontabil',wval) then
              ParamByName('xindicecontabil').AsInteger      := strtointdef(XFormula.GetValue('indicecontabil').Value,0)
           else
              ParamByName('xindicecontabil').AsInteger      := 0;
           if XFormula.TryGetValue('valorcusto',wval) then
              ParamByName('xvalorcusto').AsFloat      := strtofloatdef(XFormula.GetValue('valorcusto').Value,0)
           else
              ParamByName('xvalorcusto').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco1',wval) then
              ParamByName('xvalorpreco1').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco1').Value,0)
           else
              ParamByName('xvalorpreco1').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco2',wval) then
              ParamByName('xvalorpreco2').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco2').Value,0)
           else
              ParamByName('xvalorpreco2').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco3',wval) then
              ParamByName('xvalorpreco3').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco3').Value,0)
           else
              ParamByName('xvalorpreco3').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco4',wval) then
              ParamByName('xvalorpreco4').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco4').Value,0)
           else
              ParamByName('xvalorpreco4').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco5',wval) then
              ParamByName('xvalorpreco5').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco5').Value,0)
           else
              ParamByName('xvalorpreco5').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco6',wval) then
              ParamByName('xvalorpreco6').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco6').Value,0)
           else
              ParamByName('xvalorpreco6').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco7',wval) then
              ParamByName('xvalorpreco7').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco7').Value,0)
           else
              ParamByName('xvalorpreco7').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco8',wval) then
              ParamByName('xvalorpreco8').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco8').Value,0)
           else
              ParamByName('xvalorpreco8').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco9',wval) then
              ParamByName('xvalorpreco9').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco9').Value,0)
           else
              ParamByName('xvalorpreco9').AsFloat      := 0;
           if XFormula.TryGetValue('valorpreco10',wval) then
              ParamByName('xvalorpreco10').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco10').Value,0)
           else
              ParamByName('xvalorpreco10').AsFloat      := 0;
           if XFormula.TryGetValue('valorcontabil',wval) then
              ParamByName('xvalorcontabil').AsFloat      := strtofloatdef(XFormula.GetValue('valorcontabil').Value,0)
           else
              ParamByName('xvalorcontabil').AsFloat      := 0;
           if XFormula.TryGetValue('tipoarredondatrunca',wval) then
              ParamByName('xtipoarredondatrunca').AsString    := XFormula.GetValue('tipoarredondatrunca').Value
           else
              ParamByName('xtipoarredondatrunca').AsString    := '';
           if XFormula.TryGetValue('casasdecimais',wval) then
              ParamByName('xcasasdecimais').AsInteger      := strtointdef(XFormula.GetValue('casasdecimais').Value,0)
           else
              ParamByName('xcasasdecimais').AsInteger      := 0;
           if XFormula.TryGetValue('tipoantesapos',wval) then
              ParamByName('xtipoantesapos').AsString    := XFormula.GetValue('tipoantesapos').Value
           else
              ParamByName('xtipoantesapos').AsString    := '';
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
                SQL.Add('select "CodigoInternoFormula"  as id,');
                SQL.Add('       "DescricaoFormula"      as descricao,');
                SQL.Add('       "MetodoCustoFormula"    as metodocusto,');
                SQL.Add('       "MetodoPreco1Formula"   as metodopreco1,');
                SQL.Add('       "MetodoPreco2Formula"   as metodopreco2,');
                SQL.Add('       "MetodoPreco3Formula"   as metodopreco3,');
                SQL.Add('       "MetodoPreco4Formula"   as metodopreco4,');
                SQL.Add('       "MetodoPreco5Formula"   as metodopreco5,');
                SQL.Add('       "MetodoPreco6Formula"   as metodopreco6,');
                SQL.Add('       "MetodoPreco7Formula"   as metodopreco7,');
                SQL.Add('       "MetodoPreco8Formula"   as metodopreco8,');
                SQL.Add('       "MetodoPreco9Formula"   as metodopreco9,');
                SQL.Add('       "MetodoPreco10Formula"  as metodopreco10,');
                SQL.Add('       "MetodoContabilFormula" as metodocontabil,');
                SQL.Add('       "FormulaCustoFormula"   as formulacusto,');
                SQL.Add('       "FormulaPreco1Formula"  as formulapreco1,');
                SQL.Add('       "FormulaPreco2Formula"  as formulapreco2,');
                SQL.Add('       "FormulaPreco3Formula"  as formulapreco3,');
                SQL.Add('       "FormulaPreco4Formula"  as formulapreco4,');
                SQL.Add('       "FormulaPreco5Formula"  as formulapreco5,');
                SQL.Add('       "FormulaPreco6Formula"  as formulapreco6,');
                SQL.Add('       "FormulaPreco7Formula"  as formulapreco7,');
                SQL.Add('       "FormulaPreco8Formula"  as formulapreco8,');
                SQL.Add('       "FormulaPreco9Formula"  as formulapreco9,');
                SQL.Add('       "FormulaPreco10Formula" as formulapreco10,');
                SQL.Add('       "FormulaContabilFormula" as formulacontabil,');
                SQL.Add('       "IndiceCustoFormula"    as indicecusto,');
                SQL.Add('       "IndicePreco1Formula"   as indicepreco1,');
                SQL.Add('       "IndicePreco2Formula"   as indicepreco2,');
                SQL.Add('       "IndicePreco3Formula"   as indicepreco3,');
                SQL.Add('       "IndicePreco4Formula"   as indicepreco4,');
                SQL.Add('       "IndicePreco5Formula"   as indicepreco5,');
                SQL.Add('       "IndicePreco6Formula"   as indicepreco6,');
                SQL.Add('       "IndicePreco7Formula"   as indicepreco7,');
                SQL.Add('       "IndicePreco8Formula"   as indicepreco8,');
                SQL.Add('       "IndicePreco9Formula"   as indicepreco9,');
                SQL.Add('       "IndicePreco10Formula"  as indicepreco10,');
                SQL.Add('       "IndiceContabilFormula" as indicecontabil,');
                SQL.Add('       "ValorCustoFormula"     as valorcusto,');
                SQL.Add('       "ValorPreco1Formula"    as valorpreco1,');
                SQL.Add('       "ValorPreco2Formula"    as valorpreco2,');
                SQL.Add('       "ValorPreco3Formula"    as valorpreco3,');
                SQL.Add('       "ValorPreco4Formula"    as valorpreco4,');
                SQL.Add('       "ValorPreco5Formula"    as valorpreco5,');
                SQL.Add('       "ValorPreco6Formula"    as valorpreco6,');
                SQL.Add('       "ValorPreco7Formula"    as valorpreco7,');
                SQL.Add('       "ValorPreco8Formula"    as valorpreco8,');
                SQL.Add('       "ValorPreco9Formula"    as valorpreco9,');
                SQL.Add('       "ValorPreco10Formula"   as valorpreco10,');
                SQL.Add('       "ValorContabilFormula"  as valorcontabil,');
                SQL.Add('       "TipoArredondaTruncaFormula" as tipoarredondatrunca,');
                SQL.Add('       "CasasDecimaisArredondaFormula" as casasdecimais,');
                SQL.Add('       "TipoAntesAposFormula"          as tipoantesapos ');
                SQL.Add('from "Formula" where "CodigoEmpresaFormula"=:xempresa and "DescricaoFormula"=:xdescricao ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaFormula;
                ParamByName('xdescricao').AsString := XFormula.GetValue('descricao').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Fórmula incluída');
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


function AlteraFormula(XIdFormula: integer; XFormula: TJSONObject): TJSONObject;
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
    if XFormula.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoFormula"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoFormula"=:xdescricao';
       end;
     if XFormula.TryGetValue('metodocusto',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoCustoFormula"=:xmetodocusto'
         else
            wcampos := wcampos+',"MetodoCustoFormula"=:xdmetodocusto';
       end;
     if XFormula.TryGetValue('metodopreco1',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco1Formula"=:xmetodopreco1'
         else
            wcampos := wcampos+',"MetodoPreco1Formula"=:xdmetodopreco1';
       end;
     if XFormula.TryGetValue('metodopreco2',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco2Formula"=:xmetodopreco2'
         else
            wcampos := wcampos+',"MetodoPreco2Formula"=:xdmetodopreco2';
       end;
     if XFormula.TryGetValue('metodopreco3',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco3Formula"=:xmetodopreco3'
         else
            wcampos := wcampos+',"MetodoPreco3Formula"=:xdmetodopreco3';
       end;
     if XFormula.TryGetValue('metodopreco4',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco4Formula"=:xmetodopreco4'
         else
            wcampos := wcampos+',"MetodoPreco4Formula"=:xdmetodopreco4';
       end;
     if XFormula.TryGetValue('metodopreco5',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco5Formula"=:xmetodopreco5'
         else
            wcampos := wcampos+',"MetodoPreco5Formula"=:xdmetodopreco5';
       end;
     if XFormula.TryGetValue('metodopreco6',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco6Formula"=:xmetodopreco6'
         else
            wcampos := wcampos+',"MetodoPreco6ormula"=:xdmetodopreco6';
       end;
     if XFormula.TryGetValue('metodopreco7',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco7Formula"=:xmetodopreco7'
         else
            wcampos := wcampos+',"MetodoPreco7Formula"=:xdmetodopreco7';
       end;
     if XFormula.TryGetValue('metodopreco8',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco8Formula"=:xmetodopreco8'
         else
            wcampos := wcampos+',"MetodoPreco8Formula"=:xdmetodopreco8';
       end;
     if XFormula.TryGetValue('metodopreco9',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco9Formula"=:xmetodopreco9'
         else
            wcampos := wcampos+',"MetodoPreco9Formula"=:xdmetodopreco9';
       end;
     if XFormula.TryGetValue('metodopreco10',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoPreco10Formula"=:xmetodopreco10'
         else
            wcampos := wcampos+',"MetodoPreco10Formula"=:xdmetodopreco10';
       end;
     if XFormula.TryGetValue('metodocontabil',wval) then
       begin
         if wcampos='' then
            wcampos := '"MetodoContabilFormula"=:xmetodocontabil'
         else
            wcampos := wcampos+',"MetodoContabilFormula"=:xdmetodocontabil';
       end;
     if XFormula.TryGetValue('formulacusto',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaCustoFormula"=:xformulacusto'
         else
            wcampos := wcampos+',"FormulaCustoFormula"=:xformulacusto';
       end;
     if XFormula.TryGetValue('formulapreco1',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco1Formula"=:xformulapreco1'
         else
            wcampos := wcampos+',"FormulaPreco1Formula"=:xformulapreco1';
       end;
     if XFormula.TryGetValue('formulapreco2',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco2Formula"=:xformulapreco2'
         else
            wcampos := wcampos+',"FormulaPreco2Formula"=:xformulapreco2';
       end;
     if XFormula.TryGetValue('formulapreco3',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco3Formula"=:xformulapreco3'
         else
            wcampos := wcampos+',"FormulaPreco3Formula"=:xformulapreco3';
       end;
     if XFormula.TryGetValue('formulapreco4',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco4Formula"=:xformulapreco4'
         else
            wcampos := wcampos+',"FormulaPreco4Formula"=:xformulapreco4';
       end;
     if XFormula.TryGetValue('formulapreco5',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco5Formula"=:xformulapreco5'
         else
            wcampos := wcampos+',"FormulaPreco5Formula"=:xformulapreco5';
       end;
     if XFormula.TryGetValue('formulapreco6',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco6Formula"=:xformulapreco6'
         else
            wcampos := wcampos+',"FormulaPreco6Formula"=:xformulapreco6';
       end;
     if XFormula.TryGetValue('formulapreco7',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco7Formula"=:xformulapreco7'
         else
            wcampos := wcampos+',"FormulaPreco7Formula"=:xformulapreco7';
       end;
     if XFormula.TryGetValue('formulapreco8',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco8Formula"=:xformulapreco8'
         else
            wcampos := wcampos+',"FormulaPreco8Formula"=:xformulapreco8';
       end;
     if XFormula.TryGetValue('formulapreco9',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco9Formula"=:xformulapreco9'
         else
            wcampos := wcampos+',"FormulaPreco9Formula"=:xformulapreco9';
       end;
     if XFormula.TryGetValue('formulapreco10',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaPreco10Formula"=:xformulapreco10'
         else
            wcampos := wcampos+',"FormulaPreco10Formula"=:xformulapreco10';
       end;
     if XFormula.TryGetValue('formulacontabil',wval) then
       begin
         if wcampos='' then
            wcampos := '"FormulaContabilFormula"=:xformulacontabil'
         else
            wcampos := wcampos+',"FormulaContabilFormula"=:xformulacontabil';
       end;
     if XFormula.TryGetValue('indicecusto',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncideCustoFormula"=:xindicecusto'
         else
            wcampos := wcampos+',"IndiceCustoFormula"=:xindicecusto';
       end;
     if XFormula.TryGetValue('indicepreco1',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco1Formula"=:xindicepreco1'
         else
            wcampos := wcampos+',"IndicePreco1Formula"=:xindicepreco1';
       end;
     if XFormula.TryGetValue('indicepreco2',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco2Formula"=:xindicepreco2'
         else
            wcampos := wcampos+',"IndicePreco2Formula"=:xindicepreco2';
       end;
     if XFormula.TryGetValue('indicepreco3',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco3Formula"=:xindicepreco3'
         else
            wcampos := wcampos+',"IndicePreco3Formula"=:xindicepreco3';
       end;
     if XFormula.TryGetValue('indicepreco4',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco4Formula"=:xindicepreco4'
         else
            wcampos := wcampos+',"IndicePreco4Formula"=:xindicepreco4';
       end;
     if XFormula.TryGetValue('indicepreco5',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco5Formula"=:xindicepreco5'
         else
            wcampos := wcampos+',"IndicePreco5Formula"=:xindicepreco5';
       end;
     if XFormula.TryGetValue('indicepreco6',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco6Formula"=:xindicepreco6'
         else
            wcampos := wcampos+',"IndicePreco6Formula"=:xindicepreco6';
       end;
     if XFormula.TryGetValue('indicepreco7',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco7Formula"=:xindicepreco7'
         else
            wcampos := wcampos+',"IndicePreco7Formula"=:xindicepreco7';
       end;
     if XFormula.TryGetValue('indicepreco8',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco8Formula"=:xindicepreco8'
         else
            wcampos := wcampos+',"IndicePreco8Formula"=:xindicepreco8';
       end;
     if XFormula.TryGetValue('indicepreco9',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco9Formula"=:xindicepreco9'
         else
            wcampos := wcampos+',"IndicePreco9Formula"=:xindicepreco9';
       end;
     if XFormula.TryGetValue('indicepreco10',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncidePreco10Formula"=:xindicepreco10'
         else
            wcampos := wcampos+',"IndicePreco10Formula"=:xindicepreco10';
       end;
     if XFormula.TryGetValue('indicecontabil',wval) then
       begin
         if wcampos='' then
            wcampos := '"IncideContabilFormula"=:xindicecontabil'
         else
            wcampos := wcampos+',"IndiceContabilFormula"=:xindicecontabil';
       end;
     if XFormula.TryGetValue('valorcusto',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorCustoFormula"=:xvalorcusto'
         else
            wcampos := wcampos+',"ValorCustoFormula"=:xvalorcusto';
       end;
     if XFormula.TryGetValue('valorpreco1',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco1Formula"=:xvalorpreco1'
         else
            wcampos := wcampos+',"ValorPreco1Formula"=:xvalorpreco1';
       end;
     if XFormula.TryGetValue('valorpreco2',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco2Formula"=:xvalorpreco2'
         else
            wcampos := wcampos+',"ValorPreco2Formula"=:xvalorpreco2';
       end;
     if XFormula.TryGetValue('valorpreco3',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco3Formula"=:xvalorpreco3'
         else
            wcampos := wcampos+',"ValorPreco3Formula"=:xvalorpreco3';
       end;
     if XFormula.TryGetValue('valorpreco4',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco4Formula"=:xvalorpreco4'
         else
            wcampos := wcampos+',"ValorPreco4Formula"=:xvalorpreco4';
       end;
     if XFormula.TryGetValue('valorpreco5',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco5Formula"=:xvalorpreco5'
         else
            wcampos := wcampos+',"ValorPreco5Formula"=:xvalorpreco5';
       end;
     if XFormula.TryGetValue('valorpreco6',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco6Formula"=:xvalorpreco6'
         else
            wcampos := wcampos+',"ValorPreco6Formula"=:xvalorpreco6';
       end;
     if XFormula.TryGetValue('valorpreco7',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco7Formula"=:xvalorpreco7'
         else
            wcampos := wcampos+',"ValorPreco7Formula"=:xvalorpreco7';
       end;
     if XFormula.TryGetValue('valorpreco8',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco8Formula"=:xvalorpreco8'
         else
            wcampos := wcampos+',"ValorPreco8Formula"=:xvalorpreco8';
       end;
     if XFormula.TryGetValue('valorpreco9',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco9Formula"=:xvalorpreco9'
         else
            wcampos := wcampos+',"ValorPreco9Formula"=:xvalorpreco9';
       end;
     if XFormula.TryGetValue('valorpreco10',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorPreco10Formula"=:xvalorpreco10'
         else
            wcampos := wcampos+',"ValorPreco10Formula"=:xvalorpreco10';
       end;
     if XFormula.TryGetValue('valorcontabil',wval) then
       begin
         if wcampos='' then
            wcampos := '"ValorContabilFormula"=:xvalorcontabil'
         else
            wcampos := wcampos+',"ValorContabilFormula"=:xvalorcontabil';
       end;
     if XFormula.TryGetValue('tipoarredondatrunca',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoArredondaTruncaFormula"=:xtipoarredondatrunca'
         else
            wcampos := wcampos+',"TipoArredondaTruncaFormula"=:xtipoarredondatrunca';
       end;
     if XFormula.TryGetValue('casasdecimais',wval) then
       begin
         if wcampos='' then
            wcampos := '"CasasDecimaisArredondaFormula"=:xcasasdecimais'
         else
            wcampos := wcampos+',"CasasDecimaisArredondaFormula"=:xcasasdecimais';
       end;
     if XFormula.TryGetValue('tipoantesapos',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoAntesAposFormula"=:xtipoantesapos'
         else
            wcampos := wcampos+',"TipoAntesAposFormula"=:xtipoantesapos';
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
           SQL.Add('Update "Formula" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoFormula"=:xid ');
           ParamByName('xid').AsInteger       := XIdFormula;
           if XFormula.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString   := XFormula.GetValue('descricao').Value;
           if XFormula.TryGetValue('metodocusto',wval) then
              ParamByName('xmetodocusto').AsString   := XFormula.GetValue('metodocusto').Value;
           if XFormula.TryGetValue('metodopreco1',wval) then
              ParamByName('xmetodopreco1').AsString  := XFormula.GetValue('metodopreco1').Value;
           if XFormula.TryGetValue('metodopreco2',wval) then
              ParamByName('xmetodopreco2').AsString  := XFormula.GetValue('metodopreco2').Value;
           if XFormula.TryGetValue('metodopreco3',wval) then
              ParamByName('xmetodopreco3').AsString  := XFormula.GetValue('metodopreco3').Value;
           if XFormula.TryGetValue('metodopreco4',wval) then
              ParamByName('xmetodopreco4').AsString  := XFormula.GetValue('metodopreco4').Value;
           if XFormula.TryGetValue('metodopreco5',wval) then
              ParamByName('xmetodopreco5').AsString  := XFormula.GetValue('metodopreco5').Value;
           if XFormula.TryGetValue('metodopreco6',wval) then
              ParamByName('xmetodopreco6').AsString  := XFormula.GetValue('metodopreco6').Value;
           if XFormula.TryGetValue('metodopreco7',wval) then
              ParamByName('xmetodopreco7').AsString  := XFormula.GetValue('metodopreco7').Value;
           if XFormula.TryGetValue('metodopreco8',wval) then
              ParamByName('xmetodopreco8').AsString  := XFormula.GetValue('metodopreco8').Value;
           if XFormula.TryGetValue('metodopreco9',wval) then
              ParamByName('xmetodopreco9').AsString  := XFormula.GetValue('metodopreco9').Value;
           if XFormula.TryGetValue('metodopreco10',wval) then
              ParamByName('xmetodopreco10').AsString  := XFormula.GetValue('metodopreco10').Value;
           if XFormula.TryGetValue('metodocontabil',wval) then
              ParamByName('xmetodocusto').AsString    := XFormula.GetValue('metodocusto').Value;
           if XFormula.TryGetValue('formulacusto',wval) then
              ParamByName('formulacusto').AsString    := XFormula.GetValue('formulacusto').Value;
           if XFormula.TryGetValue('formulapreco1',wval) then
              ParamByName('xformulapreco1').AsString  := XFormula.GetValue('formulapreco1').Value;
           if XFormula.TryGetValue('formulapreco2',wval) then
              ParamByName('xformulapreco2').AsString  := XFormula.GetValue('formulapreco2').Value;
           if XFormula.TryGetValue('formulapreco3',wval) then
              ParamByName('xformulapreco3').AsString  := XFormula.GetValue('formulapreco3').Value;
           if XFormula.TryGetValue('formulapreco4',wval) then
              ParamByName('xformulapreco4').AsString  := XFormula.GetValue('formulapreco4').Value;
           if XFormula.TryGetValue('formulapreco5',wval) then
              ParamByName('xformulapreco5').AsString  := XFormula.GetValue('formulapreco5').Value;
           if XFormula.TryGetValue('formulapreco6',wval) then
              ParamByName('xformulapreco6').AsString  := XFormula.GetValue('formulapreco6').Value;
           if XFormula.TryGetValue('formulapreco7',wval) then
              ParamByName('xformulapreco7').AsString  := XFormula.GetValue('formulapreco7').Value;
           if XFormula.TryGetValue('formulapreco8',wval) then
              ParamByName('xformulapreco8').AsString  := XFormula.GetValue('formulapreco8').Value;
           if XFormula.TryGetValue('formulapreco9',wval) then
              ParamByName('xformulapreco9').AsString  := XFormula.GetValue('formulapreco9').Value;
           if XFormula.TryGetValue('formulapreco10',wval) then
              ParamByName('xformulapreco10').AsString  := XFormula.GetValue('formulapreco10').Value;
           if XFormula.TryGetValue('formulacontabil',wval) then
              ParamByName('xformulacontabil').AsString := XFormula.GetValue('formulacontabil').Value;
           if XFormula.TryGetValue('indicecusto',wval) then
              ParamByName('xindicecusto').AsInteger    := strtointdef(XFormula.GetValue('indicecusto').Value,0);
           if XFormula.TryGetValue('indicepreco1',wval) then
              ParamByName('xindicepreco1').AsInteger    := strtointdef(XFormula.GetValue('indicepreco1').Value,0);
           if XFormula.TryGetValue('indicepreco2',wval) then
              ParamByName('xindicepreco2').AsInteger    := strtointdef(XFormula.GetValue('indicepreco2').Value,0);
           if XFormula.TryGetValue('indicepreco3',wval) then
              ParamByName('xindicepreco3').AsInteger    := strtointdef(XFormula.GetValue('indicepreco3').Value,0);
           if XFormula.TryGetValue('indicepreco4',wval) then
              ParamByName('xindicepreco4').AsInteger    := strtointdef(XFormula.GetValue('indicepreco4').Value,0);
           if XFormula.TryGetValue('indicepreco5',wval) then
              ParamByName('xindicepreco5').AsInteger    := strtointdef(XFormula.GetValue('indicepreco5').Value,0);
           if XFormula.TryGetValue('indicepreco6',wval) then
              ParamByName('xindicepreco6').AsInteger    := strtointdef(XFormula.GetValue('indicepreco6').Value,0);
           if XFormula.TryGetValue('indicepreco7',wval) then
              ParamByName('xindicepreco7').AsInteger    := strtointdef(XFormula.GetValue('indicepreco7').Value,0);
           if XFormula.TryGetValue('indicepreco8',wval) then
              ParamByName('xindicepreco8').AsInteger    := strtointdef(XFormula.GetValue('indicepreco8').Value,0);
           if XFormula.TryGetValue('indicepreco9',wval) then
              ParamByName('xindicepreco9').AsInteger    := strtointdef(XFormula.GetValue('indicepreco9').Value,0);
           if XFormula.TryGetValue('indicepreco10',wval) then
              ParamByName('xindicepreco10').AsInteger   := strtointdef(XFormula.GetValue('indicepreco10').Value,0);
           if XFormula.TryGetValue('indicecontabil',wval) then
              ParamByName('xindicecontabil').AsInteger  := strtointdef(XFormula.GetValue('indicecontabil').Value,0);
           if XFormula.TryGetValue('valorcusto',wval) then
              ParamByName('xvalorcusto').AsFloat        := strtofloatdef(XFormula.GetValue('valorcusto').Value,0);
           if XFormula.TryGetValue('valorpreco1',wval) then
              ParamByName('xvalorpreco1').AsFloat       := strtofloatdef(XFormula.GetValue('valorpreco1').Value,0);
           if XFormula.TryGetValue('valorpreco2',wval) then
              ParamByName('xvalorpreco2').AsFloat       := strtofloatdef(XFormula.GetValue('valorpreco2').Value,0);
           if XFormula.TryGetValue('valorpreco3',wval) then
              ParamByName('xvalorpreco3').AsFloat       := strtofloatdef(XFormula.GetValue('valorpreco3').Value,0);
           if XFormula.TryGetValue('valorpreco4',wval) then
              ParamByName('xvalorpreco4').AsFloat       := strtofloatdef(XFormula.GetValue('valorpreco4').Value,0);
           if XFormula.TryGetValue('valorpreco5',wval) then
              ParamByName('xvalorpreco5').AsFloat       := strtofloatdef(XFormula.GetValue('valorpreco5').Value,0);
           if XFormula.TryGetValue('valorpreco6',wval) then
              ParamByName('xvalorpreco6').AsFloat       := strtofloatdef(XFormula.GetValue('valorpreco6').Value,0);
           if XFormula.TryGetValue('valorpreco7',wval) then
              ParamByName('xvalorpreco7').AsFloat       := strtofloatdef(XFormula.GetValue('valorpreco7').Value,0);
           if XFormula.TryGetValue('valorpreco8',wval) then
              ParamByName('xvalorpreco8').AsFloat       := strtofloatdef(XFormula.GetValue('valorpreco8').Value,0);
           if XFormula.TryGetValue('valorpreco9',wval) then
              ParamByName('xvalorpreco9').AsFloat       := strtofloatdef(XFormula.GetValue('valorpreco9').Value,0);
           if XFormula.TryGetValue('valorpreco10',wval) then
              ParamByName('xvalorpreco10').AsFloat      := strtofloatdef(XFormula.GetValue('valorpreco10').Value,0);
           if XFormula.TryGetValue('valorcontabil',wval) then
              ParamByName('xvalorcontabil').AsFloat     := strtofloatdef(XFormula.GetValue('valorcontabil').Value,0);
           if XFormula.TryGetValue('tipoarredondatrunca',wval) then
              ParamByName('xtipoarredondatrunca').AsString := XFormula.GetValue('tipoarredondatrunca').Value;
           if XFormula.TryGetValue('casasdecimais',wval) then
              ParamByName('xcasasdecimais').AsInteger     := strtointdef(XFormula.GetValue('casasdecimais').Value,0);
           if XFormula.TryGetValue('tipoantesapos',wval) then
              ParamByName('xtipoantesapos').AsString := XFormula.GetValue('tipoantesapos').Value;
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
              SQL.Add('select "CodigoInternoFormula"  as id,');
              SQL.Add('       "DescricaoFormula"      as descricao,');
              SQL.Add('       "MetodoCustoFormula"    as metodocusto,');
              SQL.Add('       "MetodoPreco1Formula"   as metodopreco1,');
              SQL.Add('       "MetodoPreco2Formula"   as metodopreco2,');
              SQL.Add('       "MetodoPreco3Formula"   as metodopreco3,');
              SQL.Add('       "MetodoPreco4Formula"   as metodopreco4,');
              SQL.Add('       "MetodoPreco5Formula"   as metodopreco5,');
              SQL.Add('       "MetodoPreco6Formula"   as metodopreco6,');
              SQL.Add('       "MetodoPreco7Formula"   as metodopreco7,');
              SQL.Add('       "MetodoPreco8Formula"   as metodopreco8,');
              SQL.Add('       "MetodoPreco9Formula"   as metodopreco9,');
              SQL.Add('       "MetodoPreco10Formula"  as metodopreco10,');
              SQL.Add('       "MetodoContabilFormula" as metodocontabil,');
              SQL.Add('       "FormulaCustoFormula"   as formulacusto,');
              SQL.Add('       "FormulaPreco1Formula"  as formulapreco1,');
              SQL.Add('       "FormulaPreco2Formula"  as formulapreco2,');
              SQL.Add('       "FormulaPreco3Formula"  as formulapreco3,');
              SQL.Add('       "FormulaPreco4Formula"  as formulapreco4,');
              SQL.Add('       "FormulaPreco5Formula"  as formulapreco5,');
              SQL.Add('       "FormulaPreco6Formula"  as formulapreco6,');
              SQL.Add('       "FormulaPreco7Formula"  as formulapreco7,');
              SQL.Add('       "FormulaPreco8Formula"  as formulapreco8,');
              SQL.Add('       "FormulaPreco9Formula"  as formulapreco9,');
              SQL.Add('       "FormulaPreco10Formula" as formulapreco10,');
              SQL.Add('       "FormulaContabilFormula" as formulacontabil,');
              SQL.Add('       "IndiceCustoFormula"    as indicecusto,');
              SQL.Add('       "IndicePreco1Formula"   as indicepreco1,');
              SQL.Add('       "IndicePreco2Formula"   as indicepreco2,');
              SQL.Add('       "IndicePreco3Formula"   as indicepreco3,');
              SQL.Add('       "IndicePreco4Formula"   as indicepreco4,');
              SQL.Add('       "IndicePreco5Formula"   as indicepreco5,');
              SQL.Add('       "IndicePreco6Formula"   as indicepreco6,');
              SQL.Add('       "IndicePreco7Formula"   as indicepreco7,');
              SQL.Add('       "IndicePreco8Formula"   as indicepreco8,');
              SQL.Add('       "IndicePreco9Formula"   as indicepreco9,');
              SQL.Add('       "IndicePreco10Formula"  as indicepreco10,');
              SQL.Add('       "IndiceContabilFormula" as indicecontabil,');
              SQL.Add('       "ValorCustoFormula"     as valorcusto,');
              SQL.Add('       "ValorPreco1Formula"    as valorpreco1,');
              SQL.Add('       "ValorPreco2Formula"    as valorpreco2,');
              SQL.Add('       "ValorPreco3Formula"    as valorpreco3,');
              SQL.Add('       "ValorPreco4Formula"    as valorpreco4,');
              SQL.Add('       "ValorPreco5Formula"    as valorpreco5,');
              SQL.Add('       "ValorPreco6Formula"    as valorpreco6,');
              SQL.Add('       "ValorPreco7Formula"    as valorpreco7,');
              SQL.Add('       "ValorPreco8Formula"    as valorpreco8,');
              SQL.Add('       "ValorPreco9Formula"    as valorpreco9,');
              SQL.Add('       "ValorPreco10Formula"   as valorpreco10,');
              SQL.Add('       "ValorContabilFormula"  as valorcontabil,');
              SQL.Add('       "TipoArredondaTruncaFormula" as tipoarredondatrunca,');
              SQL.Add('       "CasasDecimaisArredondaFormula" as casasdecimais,');
              SQL.Add('       "TipoAntesAposFormula"          as tipoantesapos ');
              SQL.Add('from "Formula" ');
              SQL.Add('where "CodigoInternoFormula" =:xid ');
              ParamByName('xid').AsInteger := XIdFormula;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Fórmula alterada');
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

function VerificaRequisicao(XFormula: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XFormula.TryGetValue('descricao',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaFormula(XIdFormula: integer): TJSONObject;
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
         SQL.Add('delete from "Formula" where "CodigoInternoFormula"=:xid ');
         ParamByName('xid').AsInteger := XIdFormula;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Fórmula excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Fórmula excluída');
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

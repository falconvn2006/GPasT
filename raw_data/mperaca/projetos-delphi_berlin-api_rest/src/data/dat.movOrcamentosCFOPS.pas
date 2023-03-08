unit dat.movOrcamentosCFOPS;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,IdCoderMIME,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections, IniFiles;


function RetornaListaCFOPS(const XQuery: TDictionary<string, string>; XOrcamento: integer): TJSONArray;

implementation

uses prv.dataModuleConexao;

var FNumItem,FIdItem,FCodProduto,FCodAliquota,FCodVendedor,FCodFiscal,FCodSitTrib,FTamanho,FCor: integer;
    FQtde,FUnitario,FTotal: double;
    FIncideST: boolean;
    FDatMov: tdatetime;

function RetornaListaCFOPS(const XQuery: TDictionary<string, string>; XOrcamento: integer): TJSONArray;
var wquery: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
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
         SQL.Add('select "CodigoInternoOrcamentoCFOP"  as id,');
         SQL.Add('       "CodigoOrcamentoCFOP"         as idorcamento,');
         SQL.Add('       "CodigoNaturezaOrcamentoCFOP" as idnatureza,');
         SQL.Add('       ts_retornafiscalcodigo("CodigoNaturezaOrcamentoCFOP") as xcfop,');
         SQL.Add('       "TotalItemOrcamentoCFOP"      as totalitem,');
         SQL.Add('       "BaseICMSItemOrcamentoCFOP"   as baseicms,');
         SQL.Add('       "TotalICMSItemOrcamentoCFOP"  as totalicms,');
         SQL.Add('       "BaseICMSSubstituicaoItemOrcamentoCFOP"   as baseicmsst,');
         SQL.Add('       "TotalICMSSubstituicaoItemOrcamentoCFOP"  as totalicmsst ');
         SQL.Add('from "OrcamentoCFOP" where "CodigoOrcamentoCFOP"=:xorcamento ');
         SQL.Add('order by "CodigoInternoOrcamentoCFOP" ');
         ParamByName('xorcamento').AsInteger := XOrcamento;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONArray()
   else
      begin
        wobj := TJSONObject.Create;
        wobj.AddPair('status','404');
        wobj.AddPair('description','Nenhum cfop encontrado');
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
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

end.

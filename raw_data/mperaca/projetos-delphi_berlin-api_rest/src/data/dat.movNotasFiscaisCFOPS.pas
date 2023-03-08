unit dat.movNotasFiscaisCFOPS;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,IdCoderMIME,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections, IniFiles;


function RetornaListaCFOPS(const XQuery: TDictionary<string, string>; XNota: integer): TJSONArray;

implementation

uses prv.dataModuleConexao;

var FNumItem,FIdItem,FCodProduto,FCodAliquota,FCodVendedor,FCodFiscal,FCodSitTrib,FTamanho,FCor: integer;
    FQtde,FUnitario,FTotal: double;
    FIncideST: boolean;
    FDatMov: tdatetime;

function RetornaListaCFOPS(const XQuery: TDictionary<string, string>; XNota: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoNotaCFOP"  as id,');
         SQL.Add('       "CodigoNotaCFOP"         as idnota,');
         SQL.Add('       "CodigoNaturezaNotaCFOP" as idnatureza,');
         SQL.Add('       ts_retornafiscalcodigo("CodigoNaturezaNotaCFOP") as xcfop,');
         SQL.Add('       "TotalItemNotaCFOP"      as totalitem,');

         SQL.Add('       "NotaFiscalCFOPICMS"."CodigoAliquotaNotaCFOPICMS" as idaliquotaicms,');
         SQL.Add('       "NotaFiscalCFOPICMS"."PercentualAliquotaNotaCFOPICMS" as idaliquotaicms,');
         SQL.Add('       "NotaFiscalCFOPICMS"."TotalItemNotaCFOPICMS" as totalitemicms,');
         SQL.Add('       "NotaFiscalCFOPICMS"."BaseICMSNotaCFOPICMS" as baseicms,');
         SQL.Add('       "NotaFiscalCFOPICMS"."TotalICMSNotaCFOPICMS" as totalicms,');
         SQL.Add('       "NotaFiscalCFOPICMS"."IsentosICMSNotaCFOPICMS" as isentosicms,');
         SQL.Add('       "NotaFiscalCFOPICMS"."OutrosICMSNotaCFOPICMS" as outrosicms,');

         SQL.Add('       "NotaFiscalCFOPST"."BaseCalculoNotaCFOPST" as baseicmsst,');
         SQL.Add('       "NotaFiscalCFOPST"."ImpostoRetidoNotaCFOPST" as impostoretidost,');
         SQL.Add('       "NotaFiscalCFOPST"."DespesasNotaCFOPST" as despesasst ');

         SQL.Add('from "NotaFiscalCFOP" left join "NotaFiscalCFOPICMS" on "CodigoInternoNotaCFOP" = "CodigoNotaCFOPICMS" ');
         SQL.Add('                      left join "NotaFiscalCFOPST"   on "CodigoInternoNotaCFOP" = "CodigoNotaCFOPST" ');
         SQL.Add('where "CodigoNotaCFOP"=:xnota ');
         SQL.Add('order by "CodigoInternoNotaCFOP" ');
         ParamByName('xnota').AsInteger := XNota;
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

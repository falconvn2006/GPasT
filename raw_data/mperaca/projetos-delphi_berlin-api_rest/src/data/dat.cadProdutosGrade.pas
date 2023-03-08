unit dat.cadProdutosGrade;

interface

uses Vcl.Dialogs, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,JPEG,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections, Winapi.Windows, Vcl.Graphics, Soap.EncdDecd, IdCoderMIME,
  ExtCtrls;


function RetornaProdutoGrade(XId: integer): TJSONArray;

//function RetornaFotoBase64(XFoto: string): string;

implementation

uses prv.dataModuleConexao, Vcl.Controls, System.UITypes, System.NetEncoding;

function RetornaProdutoGrade(XId: integer): TJSONArray;
var wquery: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wret: TJSONArray;
    wobj: TJSONObject;
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
         SQL.Add('select "Produto"."CodigoInternoProduto"   as idproduto,');
         SQL.Add('       "Produto"."CodigoGradeProduto"     as idgrade,');
         SQL.Add('       "GradeTitulo"."TituloGradeTitulo"  as tamanho,');
         SQL.Add('       "GradeTitulo"."NumeroGradeTitulo"  as numero,');
         SQL.Add('       "ProdutoCor"."CodigoCorProdutoCor" as idcor,');
         SQL.Add('       "TabelaCor"."CodigoCor"            as codcor,');
         SQL.Add('       "TabelaCor"."NomeCor"              as cor ');
         SQL.Add('from "Produto" inner join "GradeTitulo" on "CodigoGradeTitulo" = "CodigoGradeProduto" ');
         SQL.Add('               inner join "ProdutoCor"  on "CodigoProdutoCor"  = "CodigoInternoProduto" ');
         SQL.Add('               inner join "TabelaCor"   on "ProdutoCor"."CodigoCorProdutoCor" = "TabelaCor"."CodigoInternoCor" ');
         SQL.Add('where "CodigoInternoProduto"=:xid ');
         SQL.Add('order by "CodigoCorProdutoCor","NumeroGradeTitulo" ');
         ParamByName('xid').AsInteger := XId;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      begin
        wret := wquery.ToJSONArray();
      end
   else
      begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','404');
         wobj.AddPair('description','Nenhuma grade encontrada');
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
end;

end.

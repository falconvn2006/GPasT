unit dat.seqUltimoPedidoVenda;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaUltimoPedidoVenda: TJSONObject;

implementation

uses prv.dataModuleConexao;

function RetornaUltimoPedidoVenda: TJSONObject;
var wquery: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wret: TJSONObject;
    wsequence: string;
begin
  try
    wsequence := '"UltimoPedidoTSFature_77222_seq"';
// cria provider de conexão com BD
    wconexao := TProviderDataModuleConexao.Create(nil);
    wquery   := TFDQuery.Create(nil);
    wret     := TJSONObject.Create;
    if wconexao.EstabeleceConexaoDB then
       with wquery do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('Select nextval('+QuotedStr(wsequence)+') as ult');
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      begin
        wret.AddPair('ultped',wquery.FieldByName('ult').AsString);
      end
   else
      begin
        wret.AddPair('status','404');
        wret.AddPair('description','Sequence não encontrada');
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
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

end.

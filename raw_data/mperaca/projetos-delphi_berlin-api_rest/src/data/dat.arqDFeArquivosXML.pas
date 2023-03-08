unit dat.arqDFeArquivosXML;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections, IniFiles;


function RetornaListaArquivosXML(const XQuery: TDictionary<string, string>): TJSONArray;

implementation

uses prv.dataModuleConexao;

function RetornaListaArquivosXML(const XQuery: TDictionary<string, string>): TJSONArray;
var wqueryLista: TFDQuery;
    warqini: TIniFile;
    wcaminhonfe,warquivo: string;
    wobj: TJSONObject;
    wret: TJSONArray;
    wachou: boolean;
    procura: TSearchRec;
begin
  try
// cria provider de conexão com BD
    warqini     := TIniFile.Create(GetCurrentDir+'\Autorizador.ini');
    wcaminhonfe := warqini.ReadString('Arquivos','PathDownload','');
    warquivo    := wcaminhonfe+'\*-nfe.xml';
    wachou      := FindFirst(warquivo,faArchive,procura) = 0;
    wret        := TJSONArray.Create;

    if wachou then
       while wachou do
       begin

         wobj := TJSONObject.Create;
         wobj.AddPair('arquivo',Procura.Name);
         wobj.AddPair('data',FormatDateTime('dd/mm/yyyy hh:nn:ss',Procura.TimeStamp));
         wobj.AddPair('tamanho',formatfloat('#0',(Procura.Size/1000)+1));
         wret.AddElement(wobj);
//         FreeAndNil(wobj);

//         ShowMessage('proximo');
         wachou := (FindNext(Procura)=0);
       end
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum arquivo XML encontrado');
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret := TJSONArray.Create;
         wret.AddElement(wobj);
       end;
  except
    On E: Exception do
    begin
      wobj := TJSONObject.Create;
      wobj.AddPair('status','500');
      wobj.AddPair('description',E.Message);
      wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      wret := TJSONArray.Create;
      wret.AddElement(wobj);
//      messagedlg('Problema ao retorna listas de localidades'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  Result := wret;
//  wquery.Free;
end;

end.

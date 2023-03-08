unit EnderecoController;

interface

uses
  System.Json, REST.Client;

type
  TEnderecoController = class

  private
    procedure EnviarServidor;

  public
    procedure AtualizarEndIntegracao();
  end;

implementation

uses
  System.Classes, System.SysUtils, Vcl.Dialogs;

procedure TEnderecoController.AtualizarEndIntegracao();
begin
  EnviarServidor;
end;

procedure TEnderecoController.EnviarServidor;
var
  jsonObj : TJsonObject;
  json : String;
  request : TRESTRequest;
begin
   TThread.CreateAnonymousThread(procedure
   begin
     try
       request := TRESTRequest.Create(Nil);
       request.Params.Clear;
//       request.AddParameter('nmprimeiro', FPessoa.NmPrimeiro);
//       request.AddParameter('nmsegundo', FPessoa.NmSegundo);
//       request.AddParameter('flnatureza', FPessoa.FlNatureza.ToString);
//       request.AddParameter('dsdocumento', FPessoa.DsDocumento);
//       request.AddParameter('dtregistro', DateToStr(FPessoa.DtRegistro));
       request.Execute;

       if request.Response.JSONValue = nil then
       begin
         TThread.Synchronize(nil, procedure
         begin
           Exit;
         end);
       end
       else
       begin
         json    := request.Response.JSONValue.ToString;
         jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

         if jsonObj.GetValue('sucesso').Value <> 'S' then
         begin
           ShowMessage('Erro ao atualizar senha!');

           TThread.Synchronize(nil, procedure
           begin
           end);

           Exit;
         end;

         TThread.Synchronize(nil, procedure
         begin
           ShowMessage('Senha atualizada com sucesso!');
         end);
       end;

       jsonObj.DisposeOf;
     except on e : exception do
      begin
        ShowMessage('Erro ao salvar nova senha: ' + e.Message);
        Exit;
      end;
     end;
   end).Start;
end;

end.

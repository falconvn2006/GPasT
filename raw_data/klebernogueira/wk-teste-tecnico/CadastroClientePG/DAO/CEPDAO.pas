unit CEPDAO;

interface
uses
   System.SysUtils, System.Classes, System.Types,
   System.Generics.Collections,
   uDM, Data.DB, CEPModel;

type
   TCEPDAO = class
   private
      FMensagem: string;

   public
      property Mensagem: string read FMensagem write FMensagem;

      function Get(var oCEPModel: TObjectList<TCEPModel>): boolean;
      function Insert(oCEPModel: TCEPModel): boolean;

end;

implementation

function TCEPDAO.Get(var oCEPModel: TObjectList<TCEPModel>): boolean;
var
   oDados : TDataSet;
   oDataModuleBD : TDataModuleBD;
   iTally: integer;
begin
   Result := false;
   FMensagem := '';
   oCEPModel := nil;

   oDataModuleBD := TDataModuleBD.Create(nil);
   try try
      if (oDataModuleBD.Conectar()) then begin
         oDataModuleBD.FDConexao.ExecSQL(
            'select ' +
            'ender.idendereco, ' +
            'ender.idpessoa, ' +
            'ender.dscep ' +
            'from endereco ender ' +
            'left outer join endereco_integracao enderi on ' +
            'ender.idendereco = enderi.idendereco ' +
            'where ' +
            'enderi.idendereco is null ',
            oDados);
         if (not oDados.IsEmpty) then begin
            oCEPModel := TObjectList<TCEPModel>.Create();
            while not oDados.Eof do begin
               oCEPModel.Add(TCEPModel.Create());
               iTally := oCEPModel.Count - 1;
               oCEPModel[iTally].idEndereco :=
                  oDados.FieldByName('idendereco').AsInteger;
               oCEPModel[iTally].idPessoa :=
                  oDados.FieldByName('idpessoa').AsInteger;
               oCEPModel[iTally].cep :=
                  oDados.FieldByName('dscep').AsString;

               oDados.Next;

            end;
            Result := true;

         end;

      end
      else
         FMensagem := oDataModuleBD.Mensagem;


   except
      on Ex:Exception do
         FMensagem := Ex.Message;

   end;
   finally
      oDataModuleBD.DesConectar();

   end;

end;

function TCEPDAO.Insert(oCEPModel: TCEPModel): boolean;
var
   oDataModuleBD : TDataModuleBD;
begin
   Result := false;
   FMensagem := '';
   oDataModuleBD := TDataModuleBD.Create(nil);
   try try
      if (oDataModuleBD.Conectar()) then begin
         oDataModuleBD.FDConexao.ExecSQL(
            'insert ' +
            'into ' +
            'endereco_integracao ' +
            'values ' +
            '( ' +
            ' ' + IntToStr(oCEPModel.idEndereco) + ', ' +
            ' ''' + oCEPModel.uf + ''', ' +
            ' ''' + oCEPModel.localidade + ''', ' +
            ' ''' + oCEPModel.bairro + ''', ' +
            ' ''' + oCEPModel.logradouro + ''', ' +
            ' ''' + oCEPModel.complemento + ''' ' +
            ') ');

      end
      else
         FMensagem := oDataModuleBD.Mensagem;


   except
      on Ex:Exception do
         FMensagem := Ex.Message;

   end;
   finally
      oDataModuleBD.DesConectar();

   end;

end;

end.

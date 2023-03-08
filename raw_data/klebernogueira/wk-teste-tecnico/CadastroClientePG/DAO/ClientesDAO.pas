unit ClientesDAO;

interface
uses
   System.SysUtils, System.Classes, System.Generics.Collections,
   uDM, ClientesModel;

type
   TClientesDAO = class
   private
      FMensagem: string;

   public
      property Mensagem: string read FMensagem write FMensagem;

      function Delete(oClientesModel: TClientesModel): boolean;
      function Insert(oClientesModel: TClientesModel): boolean;
      function InsertLote(oClientesModel: TObjectList<TClientesModel>): boolean;
      function UpDate(oClientesModel: TClientesModel): boolean;

end;

implementation

function TClientesDAO.Insert(oClientesModel: TClientesModel): boolean;
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
            'pessoa ' +
            'values ' +
            '( ' +
            ' ' + IntToStr(oClientesModel.Id) + ', ' +
            ' ' + IntToStr(oClientesModel.Natureza) + ', ' +
            ' ''' + oClientesModel.Documento + ''', ' +
            ' ''' + oClientesModel.PrimeiroNome + ''', ' +
            ' ''' + oClientesModel.SobreNome + ''', ' +
            ' current_date ' +
            '); ' +
            'insert ' +
            'into ' +
            'endereco ' +
            'values ' +
            '( ' +
            ' (select  coalesce(max(idendereco),0)+1 from endereco), ' +
            ' ' + IntToStr(oClientesModel.Id) + ', ' +
            ' ''' + oClientesModel.CEP + ''' ' +
            '); '
         );

         Result := true;

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

function TClientesDAO.InsertLote(oClientesModel: TObjectList<TClientesModel>): boolean;
var
   oDataModuleBD : TDataModuleBD;
   sSQL: string;
   iItem: Integer;
begin
   Result := false;
   FMensagem := '';
   oDataModuleBD := TDataModuleBD.Create(nil);
   try try
      if (oDataModuleBD.Conectar()) then begin
         sSQL := '';
         for iItem := 0 to oClientesModel.Count - 1 do begin
            sSQL := sSQL +
               'insert ' +
               'into ' +
               'pessoa ' +
               'values ' +
               '( ' +
               ' ' + IntToStr(oClientesModel[iItem].Id) + ', ' +
               ' ' + IntToStr(oClientesModel[iItem].Natureza) + ', ' +
               ' ''' + oClientesModel[iItem].Documento + ''', ' +
               ' ''' + oClientesModel[iItem].PrimeiroNome + ''', ' +
               ' ''' + oClientesModel[iItem].SobreNome + ''', ' +
               ' current_date ' +
               '); ' +
               'insert ' +
               'into ' +
               'endereco ' +
               'values ' +
               '( ' +
               ' (select  coalesce(max(idendereco),0)+1 from endereco), ' +
               ' ' + IntToStr(oClientesModel[iItem].Id) + ', ' +
               ' ''' + oClientesModel[iItem].CEP + ''' ' +
               '); ';

         end;
         oDataModuleBD.FDConexao.ExecSQL(sSql);
         Result := true;

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

function TClientesDAO.Delete(oClientesModel: TClientesModel): boolean;
var
   oDataModuleBD : TDataModuleBD;
begin
   Result := false;
   FMensagem := '';
   oDataModuleBD := TDataModuleBD.Create(nil);
   try try
      if (oDataModuleBD.Conectar()) then begin
         oDataModuleBD.FDConexao.ExecSQL(
            'delete from ' +
            'pessoa ' +
            'where ' +
            'idpessoa = ' +
            ' ' + IntToStr(oClientesModel.Id) + '; '
         );

         Result := true;

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

function TClientesDAO.UpDate(oClientesModel: TClientesModel): boolean;
var
   oDataModuleBD : TDataModuleBD;
begin
   Result := false;
   FMensagem := '';
   oDataModuleBD := TDataModuleBD.Create(nil);
   try try
      if (oDataModuleBD.Conectar()) then begin
         oDataModuleBD.FDConexao.ExecSQL(
            'update ' +
            'pessoa set ' +
            ' flnatureza = ' + IntToStr(oClientesModel.Natureza) + ', ' +
            ' dsdocumento = ''' + oClientesModel.Documento + ''', ' +
            ' nmprimeiro = ''' + oClientesModel.PrimeiroNome + ''', ' +
            ' nmsegundo = ''' + oClientesModel.SobreNome + ''', ' +
            ' dtregistro = current_date ' +
            'where ' +
            'idpessoa = ' +
            ' ' + IntToStr(oClientesModel.Id) + '; ' +
            'update ' +
            'endereco set ' +
            'dscep = ''' + oClientesModel.CEP + ''' ' +
            'where ' +
            'idpessoa = ' +
            ' ' + IntToStr(oClientesModel.Id) + '; '
         );

         Result := true;

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

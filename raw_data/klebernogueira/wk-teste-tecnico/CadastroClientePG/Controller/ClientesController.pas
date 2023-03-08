unit ClientesController;

interface
uses
   Classes, System.Generics.Collections, SysUtils,
   System.Character, ClientesModel, ClientesDAO;

type
   TClientesController = class
      private
         FTClientesDadosInvalidos: TObjectList<TClientesModel>;
         FMensagemErro: string;

         function IsLetrasNumeros(sTexto: string): boolean;
         function LetrasNumeros(const sTexto: string): string;
         function ValidarClienteInsert(oClientesModel: TClientesModel): boolean;
      public
         // atributos
         property TClientesDadosInvalidos: TObjectList<TClientesModel>
            read FTClientesDadosInvalidos;
         property MensagemErro: string
            read FMensagemErro
            write FMensagemErro;

         // metodos
         function Delete(
               const oClientesModel: TClientesModel):
            boolean;
         function Insert(
               const oClientesModel: TClientesModel):
            boolean;
         function InsertLote(
               olstClientesModel: TObjectList<TClientesModel>):
            boolean;
         function UpDate(
               const oClientesModel: TClientesModel):
            boolean;
   end;

implementation

function TClientesController.IsLetrasNumeros(sTexto: string): boolean;
begin
   Result := false;

   sTexto := sTexto.Trim();
   if (sTexto <> '') then begin
      Result :=
         sTexto = LetrasNumeros(sTexto);

   end;

end;

function TClientesController.LetrasNumeros(const sTexto: string): string;
var
  iLetter: Integer;
begin
   Result := sTexto.Trim();
   if (Result <> '') then begin
      for iLetter := 1 to sTexto.Length do begin
         if (not sTexto[iLetter].IsLetterOrDigit()) then begin
            Result := Result.Replace(sTexto[iLetter], '');

         end;

      end;

   end;

end;

function TClientesController.ValidarClienteInsert(
      oClientesModel: TClientesModel):
   boolean;
var
   oListErros : TStringList;
begin
   Result := false;
   if (oClientesModel = nil) then
      FMensagemErro :=
         'Não Informado o Cliente para Cadastro'

   else begin
      oListErros := TStringList.Create();

      oClientesModel.Documento :=
         oClientesModel.Documento.Trim();
      oClientesModel.PrimeiroNome :=
         oClientesModel.PrimeiroNome.Trim();
      oClientesModel.SobreNome :=
         oClientesModel.SobreNome.Trim();

      if (oClientesModel.Id < 1) then begin
         oListErros.Add(
            'Código deve ser MAIOR que 1'
         );

      end;
      if (not (oClientesModel.Natureza in [1..99])) then begin
         oListErros.Add(
            'Natureza deve Conter um Número de 1 a 99'
         );

      end;
      if (
            (not (IsLetrasNumeros(oClientesModel.Documento))) or
            (Length(oClientesModel.Documento) > 20)
         ) then begin
         oListErros.Add(
            'Documento Tamanho Máximo 20 Caracteres (Letras e Números)'
         );

      end;
      if (not (Length(oClientesModel.PrimeiroNome) in [5..100])) then begin
         oListErros.Add(
            'Primeiro Nome Tamanho de 5 a 100 Caracteres'
         );

      end;
      if (not (Length(oClientesModel.SobreNome) in [5..100])) then begin
         oListErros.Add(
            'SobreNome Tamanho de 5 a 100 Caracteres'
         );

      end;
      if (
            (not (IsLetrasNumeros(oClientesModel.CEP))) or
            (Length(oClientesModel.CEP) <> 8)
         ) then begin
         oListErros.Add(
            'CEP Tamanho de 8 Caracteres Numéricos'
         );

      end;

      if ((oListErros <> nil) and (oListErros.Count > 0)) then begin
         oClientesModel.MensagemErro := oListErros;
         if (FTClientesDadosInvalidos = nil) then
            FTClientesDadosInvalidos := TObjectList<TClientesModel>.Create();
         FTClientesDadosInvalidos.Add(oClientesModel); // lista de clientes nao validados corretamente

      end
      else
            Result := true;

   end;

end;

function TClientesController.Delete(
      const oClientesModel: TClientesModel):
   boolean;
var
   oClientesDAO : TClientesDAO;
begin
   Result := false;
   FMensagemErro := '';
   FTClientesDadosInvalidos := nil;
   if (oClientesModel.Id < 1) then begin
      FMensagemErro := 'Código deve ser MAIOR que 1';

   end
   else begin
       oClientesDAO := TClientesDAO.Create();
       Result :=
          oClientesDAO.Delete(oClientesModel);
       if (not Result) then
          FMensagemErro := oClientesDAO.Mensagem;

   end;

end;

function TClientesController.Insert(const oClientesModel: TClientesModel): boolean;
var
   oClientesDAO : TClientesDAO;
begin
   Result := false;

   FMensagemErro := '';
   FTClientesDadosInvalidos := nil;
   if (ValidarClienteInsert(oClientesModel)) then begin
       oClientesDAO := TClientesDAO.Create();
       if (not oClientesDAO.Insert(oClientesModel)) then
          FMensagemErro := oClientesDAO.Mensagem;

   end;

end;

function TClientesController.InsertLote(
      olstClientesModel: TObjectList<TClientesModel>):
   boolean;
var
   oClientesDAO : TClientesDAO;
   oListClientes: TObjectList<TClientesModel>;
   iItem: Integer;
begin
   Result := false;

   FMensagemErro := '';
   FTClientesDadosInvalidos := nil;
   if (
         (olstClientesModel = nil) or
         (olstClientesModel.Count < 1)
      ) then begin
      FMensagemErro :=
         'Cadastro em Lote deve conter no Mínimo 1 ' +
         'Cliente para Cadastrar';

   end
   else begin
      oClientesDAO := TClientesDAO.Create();
      oListClientes := TObjectList<TClientesModel>.Create();
      for iItem := 0 to Pred(olstClientesModel.Count) do begin
         if (ValidarClienteInsert(olstClientesModel[iItem])) then begin
            oListClientes.Add(olstClientesModel[iItem]); // lista de envio em pacotes

         end;
         if (oListClientes.Count > 0) and
            (
               ((iItem > 0) and (iItem mod 20 = 0)) or
               (iItem = Pred(olstClientesModel.Count))
            ) then begin
            Result :=
               oClientesDAO.InsertLote(olstClientesModel);
            FreeAndNil(oListClientes);
            oListClientes := TObjectList<TClientesModel>.Create();

         end;

      end;

   end;

end;

function TClientesController.Update(
      const oClientesModel: TClientesModel):
   boolean;
var
   oClientesDAO : TClientesDAO;
begin
   Result := false;
   FMensagemErro := '';
   FTClientesDadosInvalidos := nil;
   if (ValidarClienteInsert(oClientesModel)) then begin
       oClientesDAO := TClientesDAO.Create();
       Result :=
          oClientesDAO.UpDate(oClientesModel);
       if (not Result) then
          FMensagemErro := oClientesDAO.Mensagem;

   end;

end;

end.

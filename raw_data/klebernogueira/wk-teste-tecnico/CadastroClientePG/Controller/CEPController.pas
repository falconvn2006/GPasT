unit CEPController;

interface
uses
   System.Generics.Collections,
   CEPModel,
   CEPDAO;

type
   TCEPController = class
   private
      FMensagem: string;

   public
      property Mensagem: string read FMensagem write FMensagem;

      function Get(var oCEPModel: TObjectList<TCEPModel>): boolean;
      function Insert(oCEPModel: TCEPModel): boolean;

end;

implementation

function TCEPController.Get(var oCEPModel: TObjectList<TCEPModel>): boolean;
var
   oCEPDAO : TCEPDAO;
begin
   oCEPDAO := TCEPDAO.Create();
   Result := oCEPDAO.Get(oCEPModel);

end;

function TCEPController.Insert(oCEPModel: TCEPModel): boolean;
var
   oCEPDAO : TCEPDAO;
begin
   oCEPDAO := TCEPDAO.Create();
   Result := oCEPDAO.Insert(oCEPModel);

end;

end.

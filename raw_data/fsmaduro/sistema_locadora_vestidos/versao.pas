unit versao;

interface

uses untControleVersao, funcao, sysutils;

   Procedure InicializarControleVersao();
   Procedure Versionar();

   procedure VR_1_0_0_2();

var
   ControleVersao: TControleVersao;

implementation


Procedure InicializarControleVersao();
begin
  ControleVersao := TControleVersao.Create(nil);
end;

Procedure Versionar();
begin
   VR_1_0_0_2(); //Válido até 01/2018
end;

procedure VR_1_0_0_2();
const cVersao = '1.0.0.2';
      cDataHora = '08/05/2017 21:08:00';
begin
   ControleVersao.AddControle(cVersao,StrToDateTime(cDataHora));
   ControleVersao.AddAlteracao(cVersao,'cadastro_Avaliacao','VR_1_0_0_2_0001','Teste de alteração na versão');
end;

end.

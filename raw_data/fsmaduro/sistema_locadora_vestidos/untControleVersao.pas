unit untControleVersao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes;

Type
   TRecControle = record
     Versao: String;
     Data: TDateTime;
   end;

   TRecAlteracoes = record
     Versao: String;
     FormName: String;
     ID: String;
     Alteracoes: String;
   end;

   TControleVersao = class(TComponent)
   Private
      ArrAlteracoes : Array of TRecAlteracoes;
      ArrControle : Array of TRecControle;
   Public
     constructor Create(AOwner: TComponent);
     procedure AddAlteracao(iVersao, iFormName, iID, iAlteracao: String);
     procedure AddControle(iVersao: String; iData: TDateTime);
     procedure ShowAlteracoes(iFormName: String);
     function HtmlAlteracoes(iFormName: String): String;
     function HtmlVersao(iVersao,iFormName: String): String;
   end;

implementation

uses untInfVersao;

constructor TControleVersao.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TControleVersao.AddAlteracao(iVersao, iFormName, iID, iAlteracao: String);
var
  lPosArr: integer;
begin
  SetLength(ArrAlteracoes, length(ArrAlteracoes) + 1);
  lPosArr := length(ArrAlteracoes) - 1;
  ArrAlteracoes[lPosArr].Versao := iVersao;
  ArrAlteracoes[lPosArr].FormName := iFormName;
  ArrAlteracoes[lPosArr].ID := iID;
  ArrAlteracoes[lPosArr].Alteracoes := iAlteracao;
end;

procedure TControleVersao.AddControle(iVersao: String; iData: TDateTime);
var
  lPosArr: integer;
begin
  SetLength(ArrControle, length(ArrControle) + 1);
  lPosArr := length(ArrControle) - 1;
  ArrControle[lPosArr].Versao := iVersao;
  ArrControle[lPosArr].Data := iData;
end;

function TControleVersao.HtmlAlteracoes(iFormName: String): String;
var
  i: integer;
  lHTML: String;
begin
   lHTML := '<html><body><table WIDTH="500" HEIGHT="20">';
   For i := 0 to length(ArrControle) - 1 do
   begin
     lHTML := lHTML + #13#10 + '<tr BGCOLOR="#D2D2D2" ALIGN="center" style="font-family: arial, verdana; font-size: 12px;font-weight: bold; color: #801919;">'+
       '<td>Versão '+ArrControle[i].Versao+'</td><td>'+FormatDateTime('dd/MM/yyyy hh:mm:ss',ArrControle[i].Data)+'</td></tr>';

     lHTML := lHTML + #13#10 + HtmlVersao(ArrControle[i].Versao,iFormName);
   end;

   lHTML := lHTML + #13#10 + '</table></body></Html>';

   result := lHTML;
end;

function TControleVersao.HtmlVersao(iVersao,iFormName: String): String;
var
  i: integer;
  lHTML: String;
begin
  lHTML := '';
  for i := 0 to length(ArrAlteracoes) - 1 do
  begin
    if (ArrAlteracoes[i].Versao = iVersao) and (ArrAlteracoes[i].FormName = iFormName) then
    begin
       lHTML := lHTML + #13#10 + '<tr BGCOLOR="#CCFFFF" style="font-family: arial, verdana; font-size: 12px; font-weight: bold; color: black;">'+
           '<td COLSPAN="2">('+ArrAlteracoes[i].ID+') '+ArrAlteracoes[i].Alteracoes+'</td></tr>';
    end;
  end;

  if lHTML <> '' then
    result := lHTML
  else
    result := '<tr BGCOLOR="#CCFFFF" style="font-family: arial, verdana; font-size: 12px; color: black;">'+
              '<td COLSPAN="2">Nenhuma alteração nessa versão.</td></tr>';
end;

procedure TControleVersao.ShowAlteracoes(iFormName: String);
begin
  with TfrmInfVersao.Create(self) do
  begin
    CarregarHtml(HtmlAlteracoes(iFormName));
    ShowModal;
    Free;
  end;
end;

end.

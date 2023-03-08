
unit uFuncoes;

interface
  uses System.Classes, Vcl.Forms, Vcl.ExtCtrls, System.SysUtils, System.Math, uTransacao, Data.SqlExpr, vcl.Graphics, Vcl.Imaging.jpeg,
  Vcl.Buttons;


  procedure CentralizarPainelTela(Componente: TComponent; Tela : TForm);
  procedure CentralizarPainel(Componente: TComponent; Tela : TForm; painel:TPanel);
  function Parametro(sParametro: String): Variant;
  function Replacestr(text, oldstring, newstring: string): string;
  function GetCodigoCaixa: String;
  function Arredondar(Value: Extended; Decimals: Integer): Extended;
  function Trocavirgula(valor: variant) : string;
  function RetirarCaracter(const texto : String) : String;
  procedure Deleta_Fechamento_Comanda(pComanda : String; pTrans : TTransacao = nil);
  procedure CarregarImagemCliente(pImagem: TImage);
  function ConverterImagemJpgParaBMP(const pImagem: String): string;
  procedure Centralizarbotao(Componente: TComponent; Tela : TForm; pBotao: TBitBtn);
  procedure CarregarImagemEmpresa(pImagem: TImage);
  function GravaMsgErro(sTexto : string; iLinha: Integer) : string;
  procedure SetParametro(sParametro, sValorParametro: String);
  function Strftocurr(valor : string) : currency;
  function AddSpace(S: String; Qtd: Integer; Aling: String = 'D'): String;
  function Lers(campo : variant) : string;
  function StrZero(Value: Variant; Tam: Integer; Alinhado: String = 'E'): String;
  function Verificacpf(scpf : string) : boolean;
  function Verificacnpj(num : string) : boolean;
  function TruncVal(Value: Double; Casas: Integer): Double;
  function ArredondarEcf(Value: Extended; Decimals: integer = 2): Extended;
  function ValidaEMail(const EMailIn: PChar):Boolean;
  function VerificaDescSetor( pTabela, pTabelaSetor, pSetor, pCodigoItem : String; pConexao : TSQLConnection) : String;

implementation

uses uModulo;

function VerificaDescSetor( pTabela, pTabelaSetor, pSetor, pCodigoItem : String; pConexao : TSQLConnection) : String;
//TSQLConnection  TSQLQuery
var qrySelect : TSQLQuery;
begin
     qrySelect := TSQLQuery.Create(nil);
     qrySelect.SQLConnection := pConexao;

     if pTabelaSetor = 'tbsubgrupo_descricoes' then
     begin
          qrySelect.SQL.Text := 'select h.descricao from '+ pTabelaSetor +
          ' h inner join tbtipo_descricoes i on i.codigo = h.cod_tipo_desc where i.tipo = '+ QuotedStr( pSetor ) +
          ' and h.cod_subgrupo = '+ QuotedStr( pCodigoItem );
          qrySelect.Open;
     end
     else if pTabelaSetor = 'tbprod_descricoes' then
     begin
          qrySelect.SQL.Text := 'select h.descricao from '+ pTabelaSetor +
          ' h inner join tbtipo_descricoes i on i.codigo = h.cod_tipo_desc where i.tipo = '+ QuotedStr( pSetor ) +
          ' and h.cod_produto = '+ QuotedStr( pCodigoItem );
          qrySelect.Open;
     end
     else
     begin
          qrySelect.SQL.Text := 'select h.descricao from '+ pTabelaSetor +
          ' h inner join tbtipo_descricoes i on i.codigo = h.cod_tipo_desc where i.tipo = '+ QuotedStr( pSetor ) +
          ' and h.cod_item = '+ QuotedStr( pCodigoItem );
          qrySelect.Open;
     end;

     if qrySelect.IsEmpty then
     begin
          qrySelect.Close;
          qrySelect.SQL.Text := 'select descricao from '+ pTabela +' where codigo = '+ QuotedStr( pCodigoItem );
          qrySelect.Open;
     end;

     Result := qrySelect.FieldByName('descricao').AsString;

     qrySelect.Close;
     FreeAndNil( qrySelect );
end;

procedure CentralizarPainelTela(Componente: TComponent; Tela : TForm);
var
    AlturaTela, LarguraTela, AlturaComp, LarguraComp,i : Integer;
    vIndexPainelGeral, vTopOld, vLeftOld: Integer;
begin
  if assigned(Tela.FindComponent(Componente.name)) then
  begin
    LarguraTela := TPanel(Tela.Components[Componente.ComponentIndex]).Width;//Tela.Width;
    AlturaTela  := TPanel(Tela.Components[Componente.ComponentIndex]).Height; ;//Tela.Height;
    vIndexPainelGeral := Componente.ComponentIndex;
  end;

  vTopOld := 0;
  vLeftOld := 0;

  for I := 1 to  (Tela.ComponentCount - 1)  do
  begin
    if (Tela.Components[i] is TPanel)   then
    begin
      if (vIndexPainelGeral <> i) then
      begin
        LarguraComp := TPanel(Tela.Components[i]).Width;
        AlturaComp  := TPanel(Tela.Components[i]).Height;

        if vLeftOld > 0 then
        begin
          TPanel(Tela.Components[i]).Top := vTopOld + TPanel(Tela.Components[i]).Height;
          TPanel(Tela.Components[i]).Left := vLeftOld ;
        end
        else
        begin
          TPanel(Tela.Components[i]).Top := AlturaTela  div 2 - ( AlturaComp div 2);
          TPanel(Tela.Components[i]).Left := LarguraTela div 2 - (LarguraComp div 2);
        end;
        vLeftOld := TPanel(Tela.Components[i]).Left;
        vTopOld  := TPanel(Tela.Components[i]).Top;
      end;
    end;
  end;
end;


procedure CentralizarPainel(Componente: TComponent; Tela : TForm; painel:TPanel);
var
    AlturaTela, LarguraTela, AlturaComp, LarguraComp : Integer;
begin
  LarguraTela := TPanel(Tela.Components[Componente.ComponentIndex]).Width;
  AlturaTela  := TPanel(Tela.Components[Componente.ComponentIndex]).Height;
  if Tela.Components[Componente.ComponentIndex] is TPanel then
  begin
    if assigned(Tela.FindComponent(painel.name)) then
    begin
      LarguraComp := painel.Width;
      AlturaComp  := painel.Height;
      painel.Top := AlturaTela  div 2 - ( AlturaComp div 2);
      painel.Left := LarguraTela div 2 - (LarguraComp div 2);
    end;

  end;
end;

procedure Centralizarbotao(Componente: TComponent; Tela : TForm; pBotao: TBitBtn);
var
    AlturaTela, LarguraTela, AlturaComp, LarguraComp : Integer;
begin
  LarguraTela := TPanel(Tela.Components[Componente.ComponentIndex]).Width;
  AlturaTela  := TPanel(Tela.Components[Componente.ComponentIndex]).Height;
  LarguraComp := pBotao.Width;
  AlturaComp  := pBotao.Height;
  pBotao.Top := AlturaTela  div 2 - ( AlturaComp div 2);
  pBotao.Left := LarguraTela div 2 - (LarguraComp div 2);
end;


function Parametro(sParametro: String) : Variant;
begin
  try
    dm.SqlConsulta.Close;
    dm.SqlConsulta.Close;
    dm.SqlConsulta.SQL.Text := 'select valor from tbparametro where upper(parametro) = ' + QuotedStr(AnsiUpperCase(sParametro));
    dm.SqlConsulta.Open;
    Result := dm.SqlConsulta.FieldByName('valor').Value;
  except
  end;
end;


function Replacestr(text, oldstring, newstring: string): string;
var atual,strtofind,originalstr : pchar;
     newtext : string;
     lenoldstring,lennewstring,m,index : integer;
begin
  newtext := text;
  originalstr := pchar(text);
  strtofind := pchar(oldstring);
  lenoldstring := length(oldstring);
  lennewstring := length(newstring);
  atual := strpos(originalstr,strtofind);
  index := 0;
  while atual <> nil do
  begin
     m := atual - originalstr - index + 1;
     delete(newtext,m,lenoldstring);
     insert(newstring,newtext,m);
     index := index + (lenoldstring - lennewstring);
     atual := strpos(atual+lenoldstring,strtofind);
  end;
  Result := newtext;
end;

function GetCodigoCaixa: String;
begin
  //Verifica se o caixa é por funcionario ou por micro
  if Parametro('CAIXA_POR_FUNCIONARIO') <> 'S' then
    Result := dm.FiniParam.ReadString('Caixa','CodCaixa','')
  else
    Result := '';
end;

function Arredondar(Value: Extended; Decimals: Integer): Extended;
var
     Factor, Fraction: Extended;
begin
     Factor := IntPower(10, Decimals);
     { A conversão para string e depois para float evita
     erros de arredondamentos indesejáveis. }
     Value := StrToFloat(FloatToStr(Value * Factor));
     Result := Int(Value);
     Fraction := Frac(Value);
     if Fraction >= 0.5 then
          Result := Result + 1
     else if Fraction <= -0.5 then
          Result := Result - 1;
     Result := Result / Factor;
end;

function Trocavirgula(valor: variant) : string;
var
     x : integer;
     y : string;
begin
     for x := 1 to length(valor) do
     begin
          if copy(valor, x, 1) = ',' then
               y := y + '.'
          else
               y := y + copy(valor, x, 1);
     end;
     result := y;
end;

function RetirarCaracter(const texto : String) : String;
var
  i, tamanho : Integer;
begin
     result := '';
     tamanho := Length(texto);
     for i := 1 to tamanho do
          if (texto[i] <> '/') and (texto[i] <> '-') and (texto[i] <> '.') then
               Result := Result + texto[i];
end;


procedure Deleta_Fechamento_Comanda(pComanda : String; pTrans : TTransacao = nil);
var
     qrySelect : TSQLQuery;
     trans : TTransacao;
begin
     //Verifica se a comanda foi informada
     if pComanda = '' then
          Exit;

     try
          //Verifica se já existe uma transação em andamento
          if pTrans = nil then
               trans := TTransacao.Create(dm.conexao) //Inicia uma nova transação
          else
               trans := pTrans; //Utiliza a transação em andamento

          //Cria conexão com BD
          qrySelect := TSQLQuery.Create(nil);
          qrySelect.SQLConnection := dm.conexao;
          //Seleciona o valor de SEQ da comanda informada
          qrySelect.SQL.Text := 'select seq from tbcomanda_fechamento where cast(comanda as integer) = '+ pComanda;
          qrySelect.Open;
          qrySelect.First;
          //Lista todos os valor de SEQ encontrados
          while not qrySelect.Eof do
          begin
               //Deleta da tbcomanda_fechamento todas as comandas com o mesmo valor de SEQ selecionado
               trans.Adicionar('delete from tbcomanda_fechamento where seq = '+ qrySelect.FieldByName('seq').AsString);
               qrySelect.Next;
          end;
          qrySelect.Close;

          //Verifica se já existe uma transação em andamento, se for uma transação nova, então executa
          if pTrans = nil then
               trans.Executar; //Se iniciou nova transação, então executa
     finally
          if pTrans = nil then
               FreeAndNil(trans);

          FreeAndNil(qrySelect);
     end;
end;

procedure CarregarImagemCliente(pImagem: TImage);
begin
     try
          pImagem.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\imagens\autoatendimento.jpg');
     except;
          try
               pImagem.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\imagens\autoatendimento.bmp');
          except;

          end;
     end;
end;

function ConverterImagemJpgParaBMP(const pImagem: String): String;
var
  BMP: TBitmap;
  JPG: TJPegImage;
begin
  if (ExtractFileExt(pImagem) <> '.jpg') and
     (ExtractFileExt(pImagem) <> '.jpeg')then
  begin
    Exit;
  end;


  JPG := TJPegImage.Create;

  try
    JPG.LoadFromFile(pImagem);

    BMP := TBitmap.Create;

   try
      BMP.Assign(JPG);
      BMP.SaveToFile(ChangeFileExt(pImagem, '.bmp'));
      Result := ChangeFileExt(pImagem, '.bmp');
   finally
      FreeAndNil(BMP);
   end;

  finally
    FreeAndNil(JPG);
  end;
end;

procedure CarregarImagemEmpresa(pImagem: TImage);
begin
     try
          pImagem.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\imagens\Empresa.jpg');
     except;
          try
               pImagem.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\imagens\Empresa.bmp');
          except;

          end;
     end;
end;

function GravaMsgErro(sTexto : string; iLinha: Integer) : string;
var sArquivo,sDiretorio   : String;
     arq        : TextFile;
begin
     sDiretorio := 'C:\CANCELAMENTO_TEF';

     if not DirectoryExists(sDiretorio) then
     ForceDirectories(sDiretorio);

     sArquivo := sDiretorio + '\CANCELAMENTO.txt';

     AssignFile(arq, sArquivo);

     if not FileExists(sArquivo) then
          Rewrite(arq)
     else
          Append(arq);

     WriteLn(arq, FormatDateTime('yyyy-mm-dd',Date) +' ' +
                  FormatDateTime('hh:mm:ss',Time) + ' - Linha: '+ IntToStr(iLinha));

     WriteLn(arq,sTexto );
     WriteLn(arq, '');
     WriteLn(arq, '');

     CloseFile(arq);
end;

procedure SetParametro(sParametro, sValorParametro: String);
var trans: TTransacao;
    sql : String;
begin
     trans := TTransacao.Create(dm.conexao);

     sql := 'update tbparametro set valor = ' + QuotedStr(sValorParametro) +
          ' where parametro = ' + QuotedStr(AnsiUpperCase(sParametro));

     trans.Limpar;
     trans.Adicionar(sql);
     trans.Executar;

     FreeAndNil(trans);
end;

function Strftocurr(valor : string) : currency;
var
    ct : integer;
    texto : string;
    negativo,zero : boolean;
begin
    zero := true;
    texto := '';
    negativo := false;
    for ct := 1 to length(valor) do
    begin
        try
          if valor[ct] = '-' then
               negativo := true;
          if not (valor[ct] = ',') then
               strtoint(valor[ct]);
          texto := texto + valor[ct];
          zero := false;
         except
            ;
        end;
    end;
    if negativo then
        texto := '-'+texto;
    if zero then
        texto := '0';
    result := strtocurr(texto);
end;

function AddSpace(S: String; Qtd: Integer; Aling: String = 'D'): String;
var
     Pos: Integer;
     Ret: String;
begin
     Ret := '';
     if Aling = 'E' then
     begin
          for Pos := 1 to (Qtd - Length(S)) do
               Ret := Ret + ' ';
          Result := Ret + s;
     end
     else
     begin
          for Pos := Length(S) to Qtd -1 do
               Ret := Ret + ' ';
          Result := s + Ret;
     end;
end;

function Lers(campo : variant) : string;
begin
     try
          result := campo;
     except
          result := '';
     end;
end;

function StrZero(Value: Variant; Tam: Integer; Alinhado: String = 'E'): String;
var
     i, x : Integer;
     Res: String;
begin
     x := Length(Value);
     for i:= x to Tam -1 do
     begin
        Res := Res + '0';
     end;

     if Alinhado = 'E' then
          Result := Res + Value
     else
          Result := Value + Res;
end;

function Verificacpf(scpf : string) : boolean;
const
     ignorelist : array[0..10] of string = ('00000000000','01234567890',
          '11111111111','22222222222','33333333333','44444444444','55555555555',
          '66666666666','77777777777','88888888888','99999999999');
var
     i,d1,d2,r1,r2 : integer;
     cpf : string;
begin
     d1 := 0;
     d2 := 0;
     r1 := 0;
     r2 := 0;
     for i := 1 to length(scpf) do
          if scpf[i] in ['0'..'9'] then
               cpf := cpf + scpf[i];
     if length(cpf) <> 11 then
     begin
          result := false;
          exit;
     end;
     for i := low(ignoreList) to high(ignorelist) do
          if cpf = ignorelist[i] then
          begin
               result := false;
               exit;
          end;
     for i := 1 to 9 do
          d1 := d1 + (strtoint(cpf[i]) * (11 - i));
     r1 := d1 mod 11;
     if r1 > 1 then
          d1 := 11 - r1
     else
          d1 := 0;
     for i := 1 to 9 do
          d2 := d2 + (strtoint(cpf[i]) * (12 - i));
     r2 := (d2 + (d1 * 2)) mod 11;
     if r2 > 1 then
          d2 := 11 - r2
     else
          d2 := 0;
     if (cpf[10] + cpf[11]) = (inttostr(d1) + inttostr(d2)) then
          result := true
     else
          result := false;
end;

function Verificacnpj(num : string) : boolean;
var
     n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,d1,d2 : integer;
     digitado,calculado: string;
begin
     if num = '00000000000000' then
     begin
          result := false;
          exit;
     end;
     n1 := strtoint(num[1]);
     n2 := strtoint(num[2]);
     n3 := strtoint(num[3]);
     n4 := strtoint(num[4]);
     n5 := strtoint(num[5]);
     n6 := strtoint(num[6]);
     n7 := strtoint(num[7]);
     n8 := strtoint(num[8]);
     n9 := strtoint(num[9]);
     n10 := strtoint(num[10]);
     n11 := strtoint(num[11]);
     n12 := strtoint(num[12]);
     d1 := n12*2 + n11*3 + n10*4 + n9*5 + n8*6 + n7*7 + n6*8 + n5*9 + n4*2 + n3*3 + n2*4 + n1*5;
     d1 := 11 - (d1 mod 11);
     if d1 >= 10 then
          d1 := 0;
     d2 := d1*2 + n12*3 + n11*4 + n10*5 + n9*6 + n8*7 + n7*8 + n6*9 + n5*2 + n4*3 + n3*4 + n2*5 + n1*6;
     d2 := 11 - (d2 mod 11);
     if d2 >= 10 then
          d2 := 0;
     calculado := inttostr(d1) + inttostr(d2);
     digitado := num[13] + num[14];
     if calculado = digitado then
          result := true
     else
          result := false;
end;

function TruncVal(Value: Double; Casas: Integer): Double;
var
     sValor: String;
begin
     sValor := FloatToStr(Value);

     if Pos(',', sValor) > 0 then
          sValor := Copy(sValor, 1, Pos(',', sValor) + Casas);

     Result := StrToFloat(sValor);
end;

function ArredondarEcf(Value: Extended; Decimals: integer): Extended;
var
     Factor, Fraction: Extended;
begin
     Factor := IntPower(10, Decimals);
     { A conversão para string e depois para float evita
     erros de arredondamentos indesejáveis. }
     Value := StrToFloat(FloatToStr(Value * Factor));
     Result := Int(Value);
     Fraction := Frac(Value);
     if Fraction >= 0.5 then
          Result := Result + 1
     else if Fraction <= -0.5 then
          Result := Result - 1;
     Result := Result / Factor;
end;

function ValidaEMail(const EMailIn: PChar):Boolean;
const
     CaraEsp: array[1..39] of string[1] =
          ( '!','#','$','%','¨','&','*',
            '(',')','+','=','§','¬','¢','¹','²',
            '³','£','´','`','ç','Ç',',',';',':',
            '<','>','~','^','?','','|','[',']','{','}',
            'º','ª','°');
var
     i,cont : integer;
     EMail  : string;
begin
     EMail  := EMailIn;
     Result := True;
     cont   := 0;

     if EMail <> '' then
          if (Pos('@', EMail) <> 0) and (Pos('.', EMail) <> 0) then    // existe @ .
          begin
               if (Pos('@', EMail) = 1) or (Pos('@', EMail) = Length(EMail))
               or (Pos('.', EMail) = 1) or (Pos('.', EMail) = Length(EMail))
               or (Pos(' ', EMail) <> 0) then
                    Result := False
               else                                   // @ seguido de . e vice-versa
               if (abs(Pos('@', EMail) - Pos('.', EMail)) = 1) then
                    Result := False
               else
               begin
                    for i := 1 to 40 do            // se existe Caracter Especial
                         if Pos(CaraEsp[i], EMail) <> 0 then
                              Result := False;

                    for i := 1 to length(EMail) do
                    begin                                 // se existe apenas 1 @
                         if EMail[i] = '@' then
                              cont := cont + 1;                    // . seguidos de .

                         if (EMail[i] = '.') and (EMail[i+1] = '.') then
                              Result := false;
                    end;

                    // . no f, 2ou+ @, . no i, - no i, _ no i
                    if (cont >= 2) or (EMail[length(EMail)] = '.')
                    or (EMail[1]= '.') or (EMail[1]= '_')
                    or (EMail[1]= '-')  then
                         Result := false;

                    // @ seguido de COM e vice-versa
                    if (abs(Pos('@', EMail) - Pos('com', EMail)) = 1) then
                         Result := False;

                    // @ seguido de - e vice-versa
                    if (abs(Pos('@', EMail) - Pos('-', EMail)) = 1) then
                         Result := False;

                    // @ seguido de _ e vice-versa
                    if (abs(Pos('@', EMail) - Pos('_', EMail)) = 1) then
                         Result := False;
               end;
          end
          else
               Result := False;
end;

end.

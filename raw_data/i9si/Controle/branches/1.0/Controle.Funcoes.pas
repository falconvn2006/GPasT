unit Controle.Funcoes;

interface

uses
  Vcl.Forms, Vcl.Dialogs, System.SysUtils, System.Classes, Winapi.Windows,
  Xml.XmlIntf, Xml.XMLDoc, Winapi.TlHelp32, uniImage, ACBrValidador, uniDBEdit;

type
  TControleFuncoes = class
  private
    { Private declarations }
    function FindXMLElemento(No: IXMLNode; Tag: String): IXMLNode;
  public
    { Public declarations }
    IndicadorAT: String;
    TipoFormularioChamada : String;
    MemoCarregaNCM : TStringList;
    MemoCarregaCEST: TStringList;
    // Funções
    function CalculaIdade(DataIni, DataFim: TDateTime): string;
    procedure CarregaImagemGeral(URL: String; ImageComponente: TUniImage);
    function PrimeiraLetraMaiscula(Str: string): string;
    procedure HookResourceString(rs: PResStringRec; newStr: PChar);
    function VerificarTamanhoArquivo(Arquivo: String): Double;
    function XMLLerElemento(No: IXMLNode; Caminho: String): IXMLNode;
    function XMLLerTexto(No: IXMLNode; Caminho: String): String;
    function XMLLerNumero(No: IXMLNode; Caminho: String): Real;
    function XMLLerData(No: IXMLNode; Caminho: String): TDateTime;
    function FormataCpfCnpj(CpfCnpj: String): String;
    function Encrypt(Src: String): String;
    function Decrypt(Src: String): String;
    function VerificaEAN13(EAN: String): Boolean;
    function RemoveAcento(Texto: String): string;
    function ProgramaEmExecucao(ExeFileName: string): boolean;
    function CalculaAT(Valor: Real; Decimais: Integer): Real;
    function Arredonda(Valor: Real; Decimais: Integer): Real;
    function Trunca(Valor: Real; Decimais: Integer): Real;
    function RemoveMascara(Texto: String): String;
    Function ValidaCPF(num: string): boolean;
    Function ValidaCNPJ(num: string): boolean;
    function ValidCelular(aCelNumber: string): boolean;
    function validarDocumentoACBr(valor: string;
                                  tipoDocumento: TACBrValTipoDocto): Boolean;
    function MesExtenso(Mês: Word): string;
    function GeraCNPJ(const Ponto: Boolean): String;
    function GeraCPF(const Ponto: Boolean): string;
    function RetiraAspaSimples(Texto: String): String;
    function DoubleAutomatico(Texto: String): String;
    function CopyReverse(S: String; Index, Count: Integer): String;
    function RemoveMascaraMaiorQ_MenorQ(Texto: String): String;
    function ConsultaNCM(NCM: String): Boolean;
    function ConsultaCest(NCM: String): Boolean;
    function RetiraEnterFinalFrase(Texto: string): String;
  end;

const
  // Chave de autenticação
  ControlKey =
    '1'+'1'+'B'+'4'+'F'+'5'+'F'+'F'+'A'+'B'+'A'+'D'+'5'+'6'+'7'+'4'+
    '7'+'5'+'6'+'0'+'B'+'D'+'9'+'1'+'8'+'0'+'D'+'E'+'8'+'0'+'2'+'0';

var
  ControleFuncoes: TControleFuncoes;


implementation

uses
  System.RegularExpressions, System.StrUtils;

// -------------------------------------------------------------------------- //
function TControleFuncoes.FindXMLElemento(No: IXMLNode; Tag: String): IXMLNode;
var
  NoAx1: IXMLNode;
  I: Integer;
begin
  Result := Nil;

  if not No.HasChildNodes then
    Exit;

  for I := 0 to No.ChildNodes.Count -1 do
  begin
    // Verifica o nome do elemento
    if No.ChildNodes.Get(I).NodeName = Tag then
    begin
      // Elemento encontrado
      Result := No.ChildNodes.Get(I);
      Break;
    end
    else if No.ChildNodes.Get(I).HasChildNodes then
    begin
      // Pesquisa recursiva nos filhos do elemento
      NoAx1 := FindXMLElemento(No.ChildNodes.Get(I), Tag);

      // Verifica se o nome do elemento retornado
      if Assigned(NoAx1) and (NoAx1.NodeName = Tag) then
      begin
        // Elemento encontrado
        Result := NoAx1;
        Break;
      end;
    end;
  end;
end;

function TControleFuncoes.GeraCPF(const Ponto: Boolean): string;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, d1, d2: LongInt;
begin
  n1 := Trunc(Random(10));
  n2 := Trunc(Random(10));
  n3 := Trunc(Random(10));
  n4 := Trunc(Random(10));
  n5 := Trunc(Random(10));
  n6 := Trunc(Random(10));
  n7 := Trunc(Random(10));
  n8 := Trunc(Random(10));
  n9 := Trunc(Random(10));
  d1 := (n9 * 2) + (n8 * 3) + (n7 * 4) + (n6 *  5) + (n5 * 6) +
  (n4 * 7) + (n3 * 8) + (n2 * 9) + (n1 * 10);
  d1 := 11 - (d1 mod 11);
  if (d1 >= 10) then d1 := 0;
    d2 := (d1 * 2) + (n9 * 3) + (n8 * 4) + (n7 *  5) + (n6 *  6) +
   (n5 * 7) + (n4 * 8) + (n3 * 9) + (n2 * 10) + (n1 * 11);
    d2 := 11 - (d2 mod 11);
  if (d2>=10) then d2 := 0;
    Result := IntToStr(n1) + IntToStr(n2) + IntToStr(n3) + IntToStr(n4) + IntToStr(n5) + IntToStr(n6) +
              IntToStr(n7) + IntToStr(n8) + IntToStr(n9) + IntToStr(d1) + IntToStr(d2);
  if Ponto then
     Result := Copy(Result, 1, 3) + '.' + Copy(Result, 4, 3) + '.' + Copy(Result, 7, 3) + '-' + Copy(Result, 10, 2);
 end;


function TControleFuncoes.GeraCNPJ(const Ponto: Boolean): String;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, d1, d2: LongInt;
begin
  n1  := Trunc(Random(10));
  n2  := Trunc(Random(10));
  n3  := Trunc(Random(10));
  n4  := Trunc(Random(10));
  n5  := Trunc(Random(10));
  n6  := Trunc(Random(10));
  n7  := Trunc(Random(10));
  n8  := Trunc(Random(10));
  n9  := 0;
  n10 := 0;
  n11 := 0;
  n12 := 1;
  d1  := (n12 * 2) + (n11 * 3) + (n10 * 4) + (n9 * 5) + (n8 * 6) + (n7 * 7) +
 (n6  * 8) + (n5  * 9) + (n4  * 2) + (n3 * 3) + (n2 * 4) + (n1 * 5);
  d1 := 11 - (d1 mod 11);
  if (d1 >= 10) then d1 := 0;
    d2 := (d1 * 2) + (n12 * 3) + (n11 * 4) + (n10 * 5) + (n9 * 6) + (n8 * 7) +
 (n7 * 8) + (n6  * 9) + (n5  * 2) + (n4  * 3) + (n3 * 4) + (n2 * 5) + (n1 * 6);
  d2 := 11 - (d2 mod 11);
  if (d2 >= 10) then d2 := 0;

  Result := IntToStr(n1) + IntToStr(n2) + IntToStr(n3) + IntToStr(n4 ) + IntToStr(n5 ) + IntToStr(n6 ) +
            IntToStr(n7) + IntToStr(n8) + IntToStr(n9) + IntToStr(n10) + IntToStr(n11) + IntToStr(n12) +
            IntToStr(d1) + IntToStr(d2);

  if Ponto then
    Result := Copy(Result, 1, 2) + '.' + Copy(Result, 3, 3) + '.' + Copy(Result, 6, 3) + '/' +
  Copy(Result, 9, 4) + '-' + Copy(Result, 13, 2);
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.XMLLerElemento(No: IXMLNode; Caminho: String): IXMLNode;
var
  Tags: TStrings;
  NoAx1: IXMLNode;
  I: Integer;
begin
  Result := Nil;

  if (not Assigned(No)) or (not No.HasChildNodes) or (Trim(Caminho) = '') then
    Exit;

  // Separa as tags passadas no parametro Caminho
  Tags      := TStringList.Create;
  Tags.Text := Trim(StringReplace(Caminho, '/', #13, [rfReplaceAll]));

  // Verifica se o caminho aponta para as tags a partir da raiz
  if Copy(Caminho, 1, 1) = '/' then
  begin
    // Tenta carrega a primeira tag no elemento raiz
    if No.NodeName = Tags[0] then
      NoAx1 := No
    else
      NoAx1 := No.ChildNodes.FindNode(Tags[0]);
  end
  else
    // Tenta carrega a primeira tag em qualquer elemento
    NoAx1 := FindXMLElemento(No, Tags[0]);

  I := 1;
  while Assigned(NoAx1) and (I < Tags.Count) do
  begin
    // Tenta carrega as tags subsequentes em qualquer elemento a partir do
    // elemento onde foi encontrada a tag anterior.
    NoAx1 := FindXMLElemento(NoAx1, Tags[I]);
    Inc(I);
  end;

  // Descarta o StringList
  Tags.Free;

  // Retorna o elemento solicitado
  Result := NoAx1;
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.XMLLerTexto(No: IXMLNode; Caminho: String): String;
var
  NoAx1: IXMLNode;
begin
  Result := '';
  NoAx1  := XMLLerElemento(No, Caminho);

  // Retorna o valor solicitado
  if Assigned(NoAx1) and NoAx1.IsTextElement then
    Result := NoAx1.Text;
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.XMLLerNumero(No: IXMLNode; Caminho: String): Real;
var
  NoAx1: IXMLNode;
  Numero: String;
begin
  Result := 0;
  NoAx1  := XMLLerElemento(No, Caminho);

  // Retorna o valor solicitado
  if Assigned(NoAx1) and NoAx1.IsTextElement and (Trim(NoAx1.Text) <> '') then
  begin
    // Substitui '.' por ',' para fazar a conversão
    Numero := StringReplace(NoAx1.Text, '.', ',', [rfReplaceAll]);

    try
      Result := StrtoFloat(Numero);
    except
      Result := 0;
    end;
  end
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.XMLLerData(No: IXMLNode; Caminho: String): TDateTime;
var
  NoAx1: IXMLNode;
  Data: String;
begin
  Result := 0;
  NoAx1  := XMLLerElemento(No, Caminho);

  // Retorna o valor solicitado
  if Assigned(NoAx1) and NoAx1.IsTextElement and (Trim(NoAx1.Text) <> '') then
  begin
    // Altera o formato da data para DD/MM/YYYY (para ser reconhecido na
    // conversão).
    Data :=
      Copy(NoAx1.Text, 9, 2) + '/' +
      Copy(NoAx1.Text, 6, 2) + '/' +
      Copy(NoAx1.Text, 1, 4);

    // Acrescenta a hora se tiver.
    if Length(NoAx1.Text) > 10 then
      Data := Data + ' ' + Copy(NoAx1.Text, 12, 8);

    try
      Result := StrtoDateTime(Data);
    except
      Result := 0;
    end;
  end
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.FormataCpfCnpj(CpfCnpj: String): String;
begin
  if Length(CpfCnpj) < 11 then
    Result := CpfCnpj
  else if Length(CpfCnpj) = 11 then
  begin
    // CPF
    Result :=
      Copy(CpfCnpj, 1, 3) + '.' +
      Copy(CpfCnpj, 4, 3) + '.' +
      Copy(CpfCnpj, 7, 3) + '-' +
      Copy(CpfCnpj, 10, 2);
  end
  else
  begin
    // CNPJ
    Result :=
      Copy(CpfCnpj, 1, 2) + '.' +
      Copy(CpfCnpj, 3, 3) + '.' +
      Copy(CpfCnpj, 6, 3) + '/' +
      Copy(CpfCnpj, 9, 4) + '-' +
      Copy(CpfCnpj, 13, 2);
  end;
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.Encrypt(Src: String): String;
var
  Range, OffSet: Integer;
  KeyLen, KeyPos: Integer;
  SrcAsc, SrcPos: Integer;
  Dest: String;
begin
  Dest := '';

  if (Src <> '') Then
  begin
    KeyLen := Length(ControlKey);
    KeyPos := 0;
    SrcAsc := 0;
    SrcPos := 0;
    Range  := 256;

    Randomize;
    OffSet := Random(Range);
    Dest   := Format('%1.2x', [OffSet]);

    for SrcPos := 1 to Length(Src) do
    begin
      SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;

      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;

      SrcAsc := SrcAsc Xor Ord(ControlKey[KeyPos]);
      Dest   := Dest + Format('%1.2x', [SrcAsc]);
      OffSet := SrcAsc;
    end;
  end;

  Result := Dest;
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.Decrypt(Src: String): String;
var
  Range, OffSet: Integer;
  KeyLen, KeyPos: Integer;
  SrcAsc, SrcPos, TmpSrcAsc: Integer;
  Dest: String;
begin
  Dest := '';

  if (Src <> '') Then
  begin
    KeyLen := Length(ControlKey);
    KeyPos := 0;
    SrcAsc := 0;
    SrcPos := 3;
    Range  := 256;
    OffSet := StrToInt('$' + Copy(Src, 1, 2));

    repeat
      SrcAsc := StrToInt('$' + Copy(Src, SrcPos, 2));

      if (KeyPos < KeyLen) Then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;

      TmpSrcAsc := SrcAsc Xor Ord(ControlKey[KeyPos]);

      if TmpSrcAsc <= OffSet then
        TmpSrcAsc := 255 + TmpSrcAsc - OffSet
      else
        TmpSrcAsc := TmpSrcAsc - OffSet;

      Dest   := Dest + Chr(TmpSrcAsc);
      OffSet := SrcAsc;
      SrcPos := SrcPos + 2;
    until (SrcPos >= Length(Src));
  end;

  Result := Dest;
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.VerificaEAN13(EAN: String): Boolean;
var
  I, Par, Impar: Integer;
begin
  if Length(EAN) <> 13 then
    Result := False
  else
  begin
    try
      Par   := 0;
      Impar := 0;

      for I := 1 to 12 do
      begin
        if (I mod 2) = 0 then
          Par := Par + StrtoInt(EAN[I])
        else
          Impar := Impar + StrtoInt(EAN[I]);
      end;

      Par := Par * 3;

      I := 0;
      while I < (Par + Impar) do
        Inc(I, 10);

      Result := InttoStr(I - (Par + Impar)) = EAN[13];
    except
      Result := False;
    end;
  end;
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.RemoveAcento(Texto: String): string;
const
  ComAcento = 'àâãáêéíôõóûúüçñÀÂÃÁÊÉÍÔÕÓÛÚÜÇÑ';
  SemAcento = 'aaaaeeiooouuucnAAAAEEIOOOUUUCN';
var
  I: Integer;
begin;
  for I := 1 to Length(Texto) do
  begin
    if Pos(Texto[I], ComAcento) <> 0 then
      Texto[I] := SemAcento[Pos(Texto[I], ComAcento)];
  end;

  Result := Texto;
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.ProgramaEmExecucao(ExeFileName: string): boolean;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := false;

  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
      or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
    begin
      Result := true;
      exit;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32);
  end;
    CloseHandle(FSnapshotHandle);
end;

// ---------------------------------------------------------------------------//
function TControleFuncoes.CalculaAT(Valor: Real; Decimais: Integer): Real;
begin
  if IndicadorAT = 'T' then
    Result := Trunca(Valor, Decimais)
  else
    Result := Arredonda(Valor, Decimais)
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.Arredonda(Valor: Real; Decimais: Integer): Real;
var
  Multiplo: Integer;
  ValorBase: Real;
begin
  // Define o multiplo necessário para gerar a quantidade de decimais
  // solicitada (10 = 1 decimal, 100 = 2 decimal, 1000 = 3 decimais, ...)
  Multiplo  := StrtoInt('1' + StringOFChar('0', Decimais));
  ValorBase := Valor * Multiplo;

  // Arredonda o valor.
  ValorBase := Round(ValorBase);

  Result := ValorBase / Multiplo
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.Trunca(Valor: Real; Decimais: Integer): Real;
var
  Multiplo: Integer;
  ValorBase: Real;
  ValorTexto: String;
begin
  // Define o multiplo necessário para gerar a quantidade de decimais
  // solicitada (10 = 1 decimal, 100 = 2 decimal, 1000 = 3 decimais, ...)
  Multiplo  := StrtoInt('1' + StringOFChar('0', Decimais));
  ValorBase := Valor * Multiplo;

  // Trunca o valor.
  // BUGFIX: As funções do Delphi 'Int' e 'Trunc' estão subtraindo 0,01 em
  //         alguns calculos, por isso o truncamento foi feito utilizando
  //         FormatFloat + Copy.
  ValorTexto := FormatFloat('0.00000000', ValorBase);
  ValorTexto := Copy(ValorTexto, 1, Length(ValorTexto) - 9);
  ValorBase  := StrToFloat(ValorTexto);

  Result := ValorBase / Multiplo
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.RemoveMascara(Texto: String): String;
begin
  Result := StringReplace(Texto,  '.', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ',', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ':', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ';', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '/', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '\', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '|', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '+', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '_', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '[', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ']', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '{', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '(', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ')', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '<', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '>', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '@', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '#', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '$', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '&', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '*', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll, rfIgnoreCase]);
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.RemoveMascaraMaiorQ_MenorQ(Texto: String): String;
begin
  Result := StringReplace(Texto, '<', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '>', '', [rfReplaceAll, rfIgnoreCase]);
end;

Function TControleFuncoes.RetiraAspaSimples(Texto:String):String;
var
  n : Integer;
  NovoTexto : String;
begin
  NovoTexto := '';
  for n := 1 to length(texto) do
  begin
    if copy(texto, n,1) <> Chr(39) then
      NovoTexto := NovoTexto + copy(Texto, n,1)
    else
      NovoTexto := NovoTexto + ' ';
  end;
  Result:=NovoTexto;
end;

// -------------------------------------------------------------------------- //
function TControleFuncoes.ValidaCPF(num: string): boolean;
var
  Temp: Integer;
  Numero: String;
  n: array [1..9] of Integer;
  d: array [1..2] of Integer;
  num_teste: string;
begin
  num_teste := num;
  Numero:='';
  for Temp:=1 to 14 do
    if Num[Temp] in ['0'..'9'] then
      Numero:=Numero+Num[Temp];
  for Temp:=1 to 9 do
    n[Temp]:=StrToInt(Numero[Temp]);
  d[1]:=n[9]*2+n[8]*3+n[7]*4+n[6]*5+n[5]*6+n[4]*7+n[3]*8+n[2]*9+n[1]*10;
  d[1]:=11-(d[1] mod 11);
  if d[1]>=10 then
    d[1]:=0;
  d[2]:=d[1]*2+n[9]*3+n[8]*4+n[7]*5+n[6]*6+n[5]*7+n[4]*8+n[3]*9+n[2]*10+n[1]*11;
  d[2]:=11-(d[2] mod 11);
  if d[2]>=10 then
    d[2]:=0;
  if IntToStr(d[1])+IntToStr(d[2])=Numero[10]+Numero[11] then
    ValidaCPF:=True
  else
    ValidaCPF:=False;
end;

// -------------------------------------------------------------------------- //
Function TControleFuncoes.ValidaCNPJ(num: string): boolean;
var
  Temp: Integer;
  Numero: String;
  n: array [1..12] of Integer;
  d: array [1..2] of Integer;
begin
  Numero:='';
  for Temp:=1 to 18 do
    if Num[Temp] in ['0'..'9'] then
    Numero:=Numero+Num[Temp];
  for Temp:=1 to 12 do
    n[Temp]:=StrToInt(Numero[Temp]);
  d[1]:=n[12]*2+n[11]*3+n[10]*4+n[9]*5+n[8]*6+n[7]*7+n[6]*8+n[5]*9+n[4]*2+n[3]*3+n[2]*4+n[1]*5;
  d[1]:=11-(d[1] mod 11);
  if d[1]>=10 then
    d[1]:=0;
  d[2]:=d[1]*2+n[12]*3+n[11]*4+n[10]*5+n[9]*6+n[8]*7+n[7]*8+n[6]*9+n[5]*2+n[4]*3+n[3]*4+n[2]*5+n[1]*6;
  d[2]:=11-(d[2] mod 11);
  if d[2]>=10 then
    d[2]:=0;
  if IntToStr(d[1])+IntToStr(d[2])=Numero[13]+Numero[14] then
    ValidaCNPJ:=True
  else
    ValidaCNPJ:=False;
end;

function TControleFuncoes.ValidCelular(aCelNumber: string): boolean;
var
  ipRegExp, vFone: string;
begin
  { Recuperando somente os numeros }
  vFone := ControleFuncoes.RemoveMascara(aCelNumber);
  try
    ipRegExp := '^[1-9]{2}(?:[6-9]|9[1-9])[0-9]{3}[0-9]{4}$';
    if TRegEx.IsMatch(vFone, ipRegExp) then
      Result := True;
  except
    Result := False;
  end;
end;

function TControleFuncoes.validarDocumentoACBr(valor: string; tipoDocumento: TACBrValTipoDocto): Boolean;
var
  validador: tacbrvalidador;
begin
  validador := TACBrValidador.Create(nil);
  try
    validador.Documento := valor;
    validador.TipoDocto := tipoDocumento;
    result := validador.Validar;
  finally
    FreeAndNil(validador);
  end;
end;

function TControleFuncoes.MesExtenso( Mês:Word ) : string;
const
  meses : array[0..11] of PChar = ('Janeiro',
                                   'Fevereiro',
                                   'Março',
                                   'Abril',
                                   'Maio',
                                   'Junho',
                                   'Julho',
                                   'Agosto',
                                   'Setembro',
                                   'Outubro',
                                   'Novembro',
                                   'Dezembro');
begin
  result := meses[Mês-1];
end;

function TControleFuncoes.VerificarTamanhoArquivo(Arquivo: String): Double;
begin
  with TFileStream.Create(Arquivo, fmOpenRead or fmShareExclusive) do
  begin
    Try
      try
        // Retornando o tamanho em MB
        Result := Size / 1000000;
      finally
        Free;
      end;
    Except
      on e:Exception do
      begin
        Result := 0;
      end;
    End;
  end;
end;

procedure TControleFuncoes.HookResourceString(rs: PResStringRec; newStr: PChar);
var
  oldprotect: DWORD;
begin
  VirtualProtect(rs, SizeOf(rs^), PAGE_EXECUTE_READWRITE, @oldProtect);
  rs^.Identifier := Integer(newStr);
  VirtualProtect(rs, SizeOf(rs^), oldProtect, @oldProtect);
end;

function TControleFuncoes.PrimeiraLetraMaiscula(Str: string): string;
var
  PrimeiraLetra: String;
begin
  PrimeiraLetra := AnsiUpperCase(Copy(Str,1,1));
  Result := PrimeiraLetra + AnsiLowerCase(Copy(Str,2,Length(Str)-1));
end;

procedure TControleFuncoes.CarregaImagemGeral(URL: String;
                                       ImageComponente: TUniImage);
Var
  Erro: string;
begin
  if URL <> '' then
  begin
    Try
      ImageComponente.Picture.LoadFromFile(URL);
    except
      on E: Exception do
      begin
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
      end;
    End;
  end
  else
  begin
    ImageComponente.Picture := nil;
  end;
end;

Function TControleFuncoes.CalculaIdade(DataIni, DataFim : TDateTime) : string;
var 
    iDia, iMes, iAno, fDia, fMes, fAno : Word;
    nDia, nMes, nAno : Double;
begin
   DecodeDate(DataIni,iAno,iMes,iDia);
   DecodeDate(DataFim,fAno,fMes,fDia);
   nAno := fAno - iAno;
   if nAno > 0 then
    if fMes < iMes then
      nAno := nAno - 1
    else if(fMes = iMes)and(fDia < iDia)then
      nAno := nAno - 1;

   if fMes < iMes then
   begin
     nMes := 12 - (iMes-fMes);
     if fDia < iDia then
      nMes := nMes - 1;
   end
   else  if fMes = iMes then
   begin
     nMes := 0;
     if fDia < iDia then
      nMes := 11;
   end
   else if fMes > iMes then
   begin
     nMes := fMes - iMes;
     if fDia < iDia then
      nMes := nMes - 1;
   end;
   nDia := 0;

   if fDia > iDia then
     nDia := fDia - iDia;
   if fDia < iDia then
     nDia := (DataFim-IncMonth(DataFim,-1))-(iDia-fDia);
   Result := '';
   if nAno = 1 then
     Result := FloatToStr(nAno)+ ' Ano '
   else if nAno > 1 then
     Result := FloatToStr(nAno)+ ' Anos ';

   if nMes = 1 then
     Result := Result + FloatToStr(nMes)+ ' Mês '
   else if nMes > 1 then
     Result := Result + FloatToStr(nMes)+ ' Meses ';

   if nDia = 1 then
     Result := Result + FloatToStr(nDia)+ ' Dia '
   else if nDia > 1 then
     Result := Result + FloatToStr(nDia)+ ' Dias ';
end;


function TControleFuncoes.DoubleAutomatico(Texto: String): String;
var
  count, posi : integer; // contadores gerais
  s1, s2, sTexto : string; // string inicial e reformatadas
  tam :integer; // medir o lenght
begin
  inherited;

  tam := Length(Texto);

  // inicializa strings
  sTexto := Texto;
  s1 := Texto;
  s2 :='';

  // remove pontos
  if tam > 6 then
  begin
    Delete(sTexto, Pos('.',sTexto), 1);
    sTexto := sTexto;
  end;

  // retira pontos e reformata a string
  Posi:=0;
  for count := Length(s1) downto 1 do
  begin
    if (copy(s1,count,1)>='0') and (copy(s1,count,1)<='9') then begin
    posi:=posi+1;
      if posi= 3 then s2:= copy(s1,count,1)+','+s2
      else if posi= 6 then s2:= copy(s1,count,1)+'.'+s2
      else if posi= 9 then s2:= copy(s1,count,1)+'.'+s2
      else s2:=copy(s1,count,1)+s2;
    end;
  end;

  Texto := s2;

  // ajusta os zeros
  if tam = 2 then
    Texto := '0' + Texto;
  if Texto = '' then
    Texto := '000';

  if tam <= 6 then
    Texto := FormatFloat('#,##0.00', StrToCurr(Texto));

  Result := Texto;
end;

function TControleFuncoes.CopyReverse(S: String; Index, Count : Integer) : String;
begin
  Result := ReverseString(S);
  Result := Copy(Result, Index, Count);
  Result := ReverseString(Result);
end;

function TControleFuncoes.ConsultaNCM(NCM: String): Boolean;
var
 i:integer;
 coluna:Integer;
 linha:integer;
begin
  Result := False;
  if not Assigned(MemoCarregaNCM) then
  begin
    MemoCarregaNCM := TStringList.Create;
    Try
      MemoCarregaNCM.LoadFromFile('ncm.txt');
    except
      on e:exception do
      begin
        raise Exception.Create(e.Message);
        Exit;
      end;
    End;
  end;

  Linha := MemoCarregaNCM.Count;
  for i:=0 To Linha-1 do
  begin
    Coluna := PosEx(NCM, MemoCarregaNCM.Strings[i],1);
    while Coluna > 0 do
    begin
      Result := True;
      break;
    end;
  end;
end;

function TControleFuncoes.ConsultaCest(NCM: String): Boolean;
var
 i:integer;
 coluna:Integer;
 linha:integer;
begin
  Result := False;
  if not Assigned(MemoCarregaNCM) then
  begin
    MemoCarregaNCM := TStringList.Create;
    Try
      MemoCarregaNCM.LoadFromFile('cest.txt');
    except
      on e:exception do
      begin
        raise Exception.Create(e.Message);
        Exit;
      end;
    End;
  end;

  Linha := MemoCarregaNCM.Count;
  for i:=0 To Linha-1 do
  begin
    Coluna := PosEx(NCM, MemoCarregaNCM.Strings[i],1);
    while Coluna > 0 do
    begin
      Result := True;
      break;
    end;
  end;
end;

function TControleFuncoes.RetiraEnterFinalFrase(Texto: string): String;
var
  stringListLinha : TStringList;
  novaLinha: string;
  i: Integer;
begin
  // Retirando os ENTERs do final das linhas
  Try
    stringListLinha := TStringList.Create;

    // Carrega o arquivo em um stringlist
    stringListLinha.Text := Texto;

    // Varrendo todo o stringlist para retirar as quebras de linhas
    for i := 0 to (stringListLinha.Count -1) do
      novaLinha := novaLinha + stringListLinha.Strings[i];
  finally
    Result := novaLinha;
    stringListLinha.Free;
  end;
end;

end.

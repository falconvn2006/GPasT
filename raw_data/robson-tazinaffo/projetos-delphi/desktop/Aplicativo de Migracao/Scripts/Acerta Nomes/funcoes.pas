unit funcoes;

interface

uses
  {$IFDEF VER150}
      Variants,
  {$ENDIF}
    ADODB, StdCtrls, Dialogs,controls, SysUtils, IniFiles, Windows,
     ShellApi, ShlObj,CurrEdit,Math, Forms, db, Messages, Classes,
     Graphics, ExtCtrls, ComCtrls, Grids, DBCtrls, DBGrids, ToolWin,
     Registry, Mask, rxlookup, ExtDlgs, ToolEdit, Buttons, comObj, printers, winsock, scktcomp,
     ActnList,  RXCtrls,   SqlExpr,   DBxpress,   Menus,   QRExtra,    QRCtrls,
     Types,            FMTBcd,           Provider,         DBLocal,
     ImgList,          DBClient,         RXDBCtrl,         RxDBComb,         RXSpin,
     RxCombos,         AppEvnts,         IdAntiFreezeBase, IdAntiFreeze,     IdMessage,
     IdBaseComponent,  IdComponent,      IdTCPConnection,  IdTCPClient,      IdMessageClient,
     IdSMTP,           WinInet,          TlHelp32,         BDE,              SQLTimST;


function AnsiToAscii ( str: String ): String;
Function SelectFolder(wnd: HWND; Title: String) : String;
Function Space(n: Integer) : String;
Function Replicate(s: String; n: Integer) : String;
Function EspLeft(s: String; n: Integer) : String;
Function EspRight(s: String; n: Integer) : String;
Function SubStr(s: String; n,n2: Integer) : String;
Function Conf(pergunta : String; Default : Integer = 0) : Boolean; 
Function ConfAtencao(pergunta : String; Default : Integer = 0) : Boolean;
Function ConfErro(pergunta : String; Default : Integer = 0) : Boolean;
Procedure Mens(s: String);
Procedure MensErro(s: String);
Procedure MensAtencao(s: String);
Function CompData(s: String) : string;
Function Strzero(n,n1: Integer) : String;
Function SemPonto(n: Real; p: Integer) : string;
Function Padr(s:string;t:integer) : string;
Function PadrX(s: String; t: Integer; carac: string ) : String;
Function Padl(s:string;t:integer) : string;
Function PadC(s:string;t:integer) : string;
Function SepDataD(dt : TDateTime) : string;
Function SepDataS(dtS : string) : string;
function Formatstring(fmt,s:string) : string;
Function Cpf(num: string): boolean;
Function Cgc(num: string): boolean;
Function validapis(Dado : String) : boolean;
Function MaiorIdad(dn : TdateTime; dt : TdateTime) : Boolean;
Function Tirapnto(hora : TDateTime) : string;
Function digEAN(Cod : Real) : string;
Function checkEAN(EAN : string) : boolean;
Function iif(logic : boolean; r1 : string; r2 : string) : string;
Function ChrTrans(s1:string;c1 : char;c2 :char) : string;
Function DiaSemana(data : TDateTime) : String;
Function Day(data : TDateTime) : integer;
Function Month(data : TDateTime) : integer;
Function Year(data : TDateTime) : integer;
function DataExtenso(Data : TdateTime) : String;
function DataCrystal(Data : TdateTime) : String;
function MesExtenso(mes : Integer) : String;

Function AbreviaNome(Nome: String): String;
Function QdeCores : integer;var h : HDC;
Function GetCPUSpeed: Double;
Function SystemDateTime(tDate: TDateTime; tTime: TDateTime): Boolean;
Function DiskInDrive(const Drive: char): Boolean;
function Modulo11(Numero: string; De,Ate: integer;SuperDigito:Boolean):String;
Function Prest(valor : real;dtadest : TDateTime; dtaori : TDateTime; txa : Real;DiasEntrada : Integer) : real;
Procedure SendEmail(endereco : String);
Procedure JumpTo(const aAdress: String);
function NetSend(dest, source, msg: string): longint; overload;
function myComputerName : String;
function AjusteMoney(Valor : Real) : Real;
function Extenso3em3( Numero : Word ) : String;
function Extenso( Numero : Extended ) : String;
function QuebraLinhaExtenso(TextoExtenso : String;  tamanhoLinha : Integer; MinimoLinhas : Integer; IntervaloLinhas : Integer) : String;
function QuebraLinhaExtenso2(TextoExtenso : String;  tamanhoLinha : Integer; IntervaloLinhas : Integer) : String;

Function Cabec80(Empresa, Titulo, DataInicial, DataFinal, Pesquisando, TitPesquisa: String; Pagina: Integer) : Integer; // Resulta o número de linhas impressas
Function Cabec80C(Empresa, Titulo, DataInicial, DataFinal, Pesquisando, TitPesquisa: String; Pagina: Integer) : Integer; // Resulta o número de linhas impressas

procedure CallDial(DialEntry:string);
Function IsConnected : Boolean;
function LocalIP: string;

function CodBarras(cCodigo : String) : String;
function Encripty(Texto : string; chave : string) : String;
function EncriptaSimples(Texto : string; encripta : boolean) : String;
function EncriptaSimples2(Texto : string; encripta : boolean) : String;

function UltDiaMes(Mes, Ano : String) : TDateTime;
procedure LimpaCabec;
function QtdeColunas : Integer;
function TiraPonto(Valor : String) : Real;
function ChecaCEP(cCep:String ; cEstado:String): Boolean;
function GetFileVersion(const FileName : string; Sep : Char) : string;
function CaptureScreen:TBitmap;
function GetOrCreateObject(Aplicacao: String; Visible: Boolean): OleVariant;

// Funcoes Gerais para Cadastros
Function Gather(vdataSet : Tdataset; vForm : TForm) : Boolean;
Function Scatter(vdataSet : Tdataset; vForm : TForm) : Boolean;
Procedure ExecProg(dllname : string; rotina : string);
Procedure ExecProgf(dllname : string; rotina : string; vUserLoged : String);
function dataDP(data : TDateTime): String;

Function ConvSaida(UnidEst : String; UnidVnd : String; ValorEst : Real) : Real;
Procedure Posicao(MyAgent : OleVariant;Objeto : Tcontrol; Agente : String);
function SetScreenResolution(Width, Height: integer): Longint;
function TestPrinterStatus(LPTPort: word): byte;
Function StringFloat(Texto: String) : Real;
Function aScan( Texto : String; conj : array of string) :Integer;
Procedure CallDllForm(DllName,FName, Ul: PChar;  frm: Tform; ModalSN : Integer; captionform: String);
procedure TraduzErroBanco(mens :String; tabela : String);
procedure SetDefaultPrinter(PrinterName: String);
function HexToDec(Str: string): Integer;

Function SerialHexToSerialDec(SerialHex :String) : String;
Function SerialDecToSerialHex(SerialDec :String) : String;
Function ImeiOk(Imei : String) : Boolean;
function ESN8OK(esn : String) : Boolean;
function ESN11OK(esn : String) : Boolean;
procedure PassaUsuario2CentralLCK(usuario : String);

Function Pascoa(Ano : Integer) : TDateTime;
Function Paixao(Ano : Integer) : TDateTime;
Function QuartaFeiraDeCinzas(Ano : Integer) : TDateTime;
Function Carnaval(Ano : Integer) : TDateTime;
Function CorpusCristis(Ano : Integer) : TDateTime;
function getwindir:string;
function contem(palavra : string; texto : string) : boolean;
Function MinutosParaHora(Minutos : Real) : String;
Function HoraParaMinutos(Hora : String) : Integer;
Function SomenteNumeros(s : String) : Real;

function CodificaPrecoCusto(valor : real; palavracodigo : string) : String;
Function NomeDoArquivoPortariaCat52(MarcaImpressora : string; ModeloImpressora :  String; CincoUltimoDigitosNroSerie : String) : String;
procedure espera(sec: integer);
function FormataValor(valor:Real):String;
function GetId():integer;
Function Rat(OQue: String; Onde: String) : Integer;


  {InicioFunção para Leitura Registro Windons}
  FUNCTION FUNC_REGEDIT(V_KEY, V_CHAVE, V_VALOR, VS_TP : STRING) : STRING;

  {Função para Criptografar/descriptografar}
  FUNCTION FUNC_DESCRIPTOGRAFAR(S : String) : String;
  FUNCTION FUNC_CRIPTOGRAFAR(S : String) : String;

  {Função que retorna o IP Local}
  FUNCTION  FUNC_IP_LOCAL : STRING;

  {Function que cria arquivo TXT}
  FUNCTION FUNC_ARQUIVO_TXT(V_TEXTO, V_CAMINHO : STRING; V_SUBSTITUE : BOOLEAN) : boolean;

  {Função que se esta ou não conectado na NET}
  FUNCTION FUNC_VALIDA_CONEXAO_INTERNET :BOOLEAN;

 {Função que enviar e-mail sem usar WIN}
  FUNCTION FUNC_ENVIAR_EMAIL(V_DEST,
                             V_DEST_COPIA,
                             V_DEST_COPIA_OCULTA,
                             V_ASSUNTO,
                             V_MSG,
                             V_DS_ORIGEM,
                             V_WEB_SMTP,
                             V_WEB_EMAIL_SUPORTE,
                             V_WEB_EMAIL_SUPORTE_SENHA : STRING;
                             V_PRIORIDADE,
                             V_WEB_PORTA : INTEGER;
                             V_ANEXO_1,
                             V_ANEXO_2,
                             V_ANEXO_3,
                             V_ANEXO_4,
                             V_ANEXO_5 : STRING ): Boolean;

  {Procedure que abre um SITE}
  PROCEDURE PROC_WEB(V_ENDERECO : STRING);

  {Função que retorna a versão do sistema}
  function FUNC_VERSAO_SISTEMA: string;

  {Fecha aplicativo se estiver aberto}
  FUNCTION FUNC_EXE(VS_ARQ, VS_FL_ACAO : string) : Boolean;

  {Função que retorna a data por extenso em um datatime V_TP=1 "Domingo 29 de janeiro de 2006"  V_TP=2 99-JAN-9999}
  function FUNC_DATA_EXTENSO(V_DATATIME: TDateTime; V_TP :INTEGER): String;

  {Função que retorna a data por extenso em um datatime}
  function FUNC_MESANO_EXTENSO(VF_MES,VF_ANO: INTEGER): String;

  {Procedure para mudar o cursor do mouse}
  procedure PROC_MUDA_MOUSE(V_MUDA: Boolean);

  {Procedure para ordenar o dbgrid click no título}
  function FUNC_DBGRID_ORDENA(V_DataSource: TDataSource;
                               V_DBGrid    : TDBGrid;
                               V_Campo     : Integer) : Boolean;

  {Função retorna nome computador}
  function FUNC_NOME_COMPUTADOR: string;

  {Função retorna versao sistema operacional}
  function FUNC_VERSAO_SISTEMA_OPERACIONAL: string;

  {Função retorna nome usuário do sistema operacional}
  function FUNC_NOME_USUARIO_SISTEMA_OPEARACIONAL: string;

  {Função retorna o nome do usuário na rede}
  function FUNC_NOME_USUARIO_REDE : string;

  {Função utilizada para formatação de ARQUIVOS TXT}
  FUNCTION FUNC_FORMATA_TEXTO(V_TXT_ORIGINAL,V_CARACTER,V_LADO : STRING; V_TAMANHO : INTEGER) : STRING;

  {Função nome do arquivo em caminho ex: c:\xx\xxx.txt}
  function FUNC_NOME_ARQUIVO_CAMINHO(VS_CAMINHO: string): string;

  {Função retira zero a esquerda}
  FUNCTION FUNC_RETIRA_ZERO_ESQUERDA(VS_VALOR:string) : string;

  { Deslisa o ponteiro do mouse até um controle }
  function FUNC_MOVER_MOUSE_OBJETO(const Control: TControl): boolean;

 {Função que retorna numero Inteiro por extenso}
  function FUNC_NUMERO_INTEIRO_EXTENSO(V_NRO_INTEIRO: Integer): String;

 {Função que retorna numero Monetário por extenso}
  function FUNC_NUMERO_MONETARIO_EXTENSO(V_NRO_MONETARIO: Currency; v_moeda : boolean): String;

 {Procedure que formata celula excel  em execução}
  PROCEDURE PROC_FORMATAR_PLANILHA(V_PLANILHA     : VARIANT;
                                   V_PLANILHA_LIN,
                                   V_PLANILHA_COL : INTEGER;
                                   V_TM_FONTE  : INTEGER;
                                   V_COR_FUNDO : TColor;
                                   V_NEGRITO   : Boolean;
                                   V_REPLACE_1,
                                   V_REPLACE_2,
                                   V_VALOR_CEL : STRING);
  {Função que cria mapeamento de rede}
  FUNCTION FUNC_MAPEAMENTO_REDE(  V_provedor, V_Senha : PChar; V_Letra, V_CAMINHO : STRING; V_MSG, V_CONECTAR : BOOLEAN) : BOOLEAN;

  {Função que retorna o tipo de do valor - decimal, inteiro, texto, data}
  FUNCTION FUNC_VALIDA(  V_VALOR , V_TP : STRING) : BOOLEAN;

  {Função para arredondar números}
  FUNCTION FUNC_ROUND(V_VR: Double; V_CASAS: Integer): Double;

  {Função executa exe  esprea ele terminar}
  function FUNC_EXE_FIM(const FileName, Params: string; const WindowState: Word): boolean;


  {Procedure  para gravação e leitura dos arquivos}
  PROCEDURE PROC_INI_GRAVACAO   (V_CAMINHO, V_PARAM_MESTRE, V_PARAM_FILHO, V_VALOR: STRING);
  PROCEDURE PROC_INI_SUB_LEITURA(V_CAMINHO, V_PARAM_MESTRE, V_PARAM_FILHO : STRING; VAR V_VR :STRING);
  FUNCTION  FUNC_INI_LEITURA    (V_CAMINHO, V_PARAM_MESTRE, V_PARAM_FILHO : STRING) : STRING;

  {Função para importação de TXT}
  FUNCTION FUNC_IMPORTA_TXT(V_TP, V_CAMINHO, V_DELIMITADOR,V_TP_CAMINHO : STRING; V_QTD_CAMPOS :INTEGER;V_TM_CAMPO : array of string) : BOOLEAN;

  {Função a quantidade de um caracter em uma string}
  FUNCTION FUNC_QTD_TXT(V_TXT,V_CARC : STRING) : INTEGER;

  {Procedure que executa programas com parametros}
  procedure PROC_EXE_EXECUTAR(janela: HWND; Nome, Parametros: String);

  {Função que retorna a data do fim do mês}
  Function FUNC_DATA_FIM_MES (Data : TDateTime) : TDateTime;
  Function FUNC_DATA_INI_MES (Data : TDateTime) : TDateTime;
  Function FUNC_DATA_ADICIONA_MES (Data : TDateTime; v_qtd_mes : integer) : TDateTime;
  Function FUNC_DATA_MENOR_VALIDA (Ano, Mes, Dia : Word) : TDateTime;

  {Função que retorna um entter na linha}
  function QL : STRING;

  {Cria processo no windows apartir de um comando}
  function FUNC_WINEXEC(cmd: string; V_ESPERAR : BOOLEAN): boolean;

  {Função de exception}
  FUNCTION FUNC_EXECPTION(E: Exception) : STRING;

  {Função verifica exe esta aberto evitando re-abertura}
  function FUNC_VERIFICA_EXE_ABERTO(V_TITULO : STRING; ActivateIt:boolean ) : Boolean;

  {Função botões para navegação}
  function FUNC_CDS_NEVEGACAO(V_nbFirst,V_nbPrior,V_nbNext,V_nbLast : TSpeedButton; V_ACAO : STRING; V_CDS : TClientDataSet) : Boolean;

  {Força a digitação apenas de números}
  procedure PROC_KeyPress_NUMERO(Sender: TObject;
  var Key: Char);

    //Retorna se é numero ou não
    function Func_enumero(s : String) : boolean;

Procedure TrataRetornoECFBematech(iRetorno : integer);
Procedure RetornoECFBematech(iACK , iST1 , iST2 : integer);
Procedure ChamaBrowser(Buffer : String);
function Tempo(data1, data2: TDateTime): string;
Function At(S:String; C:char) : Integer;


//procedure OutputWinPrn(FileName: String); // Imprime para USB

const
        ID_BIT=$200000; // EFLAGS ID bit
        _NaoModal = 0; // Funcao callDLLForm
        _Modal    = 1; // Funcao CallDLLForm
        _ENTER    = #10+#13;


var
   ImpRel : textfile;
   Cabecalho : Array[1..50] of String;
   nrocapture : Integer;
   VG_ARQ_TXT  : array of array of string;

implementation




Function Rat(OQue: String; Onde: String) : Integer;
//
//  Procura uma string dentro de outra, da direita para esquerda
//
//  Retorna a posição onde foi encontrada ou 0 caso não seja encontrada
//
var
Pos   : Integer;
Tam1  : Integer;
Tam2  : Integer;
Achou : Boolean;
begin
Tam1   := Length(OQue);
Tam2   := Length(Onde);
Pos    := Tam2-Tam1+1;
Achou  := False;
while (Pos >= 1) and not Achou do
      begin
      if Copy(Onde, Pos, Tam1) = OQue then
         begin
         Achou := True
         end
      else
         begin
         Pos := Pos - 1;
         end;
      end;
Result := Pos;
end;

//Evitando Caracteres com Acento
function AnsiToAscii ( str: String ): String;
var
   i: Integer;
begin
for i := 1 to Length ( str ) do
    case str[i] of
         'á': str[i] := 'a';
         'é': str[i] := 'e';
         'í': str[i] := 'i';
         'ó': str[i] := 'o';
         'ú': str[i] := 'u';
         'à': str[i] := 'a';
         'è': str[i] := 'e';
         'ì': str[i] := 'i';
         'ò': str[i] := 'o';
         'ù': str[i] := 'u';
         'â': str[i] := 'a';
         'ê': str[i] := 'e';
         'î': str[i] := 'i';
         'ô': str[i] := 'o';
         'û': str[i] := 'u';
         'ä': str[i] := 'a';
         'ë': str[i] := 'e';
         'ï': str[i] := 'i';
         'ö': str[i] := 'o';
         'ü': str[i] := 'u';
         'ã': str[i] := 'a';
         'õ': str[i] := 'o';
         'ñ': str[i] := 'n';
         'ç': str[i] := 'c';
         'Á': str[i] := 'A';
         'É': str[i] := 'E';
         'Í': str[i] := 'I';
         'Ó': str[i] := 'O';
         'Ú': str[i] := 'U';
         'À': str[i] := 'A';
         'È': str[i] := 'E';
         'Ì': str[i] := 'I';
         'Ò': str[i] := 'O';
         'Ù': str[i] := 'U';
         'Â': str[i] := 'A';
         'Ê': str[i] := 'E';
         'Î': str[i] := 'I';
         'Ô': str[i] := 'O';
         'Û': str[i] := 'U';
         'Ä': str[i] := 'A';
         'Ë': str[i] := 'E';
         'Ï': str[i] := 'I';
         'Ö': str[i] := 'O';
         'Ü': str[i] := 'U';
         'Ã': str[i] := 'A';
         'Õ': str[i] := 'O';
         'Ñ': str[i] := 'N';
         'Ç': str[i] := 'C';
end;
Result := str;
end;

//Seleciona o Caminho da Pasta
Function SelectFolder(wnd: HWND; Title: String) : String;
var
   lpItemID: PItemIDList;
   BrowseInfo: TBrowseInfo;
   DisplayName: array[0..MAX_PATH] of Char;
   TempPath: array[0..MAX_PATH] of Char;
begin
FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
BrowseInfo.hwndOwner      := wnd;
BrowseInfo.pszDisplayName := @DisplayName;
BrowseInfo.lpszTitle      := PChar(Title);
BrowseInfo.ulFlags        := BIF_RETURNONLYFSDIRS;
lpItemID                  := SHBrowseForFolder(BrowseInfo);
if lpItemID <> nil then begin
   SHGetPathFromIDList(lpItemID, TempPath);
   Result := TempPath;
   GlobalFreePtr(lpItemID);
end else
   Result := '';
end;

//Retorna Espaços em Branco
Function Space(n : Integer) : String;
var a : String;
    x : Integer;
begin
a:= '';
for x := 1 to n do a:= a +' ';
    Result := a;
end;

//Duplica N Vezes uma String
Function Replicate(s: String; n: Integer) : String;
var a : string;
    x : integer;
begin
a:= '';
for x := 1 to n do a:= a +s;
    Result := a;
end;

//Retorna Caracteres da Esq. p/ Direita
Function EspLeft(s: String; n: Integer) : String;
begin
Result := copy(s,1,n);
end;

//Retorna Caracteres da Dir. p/ Esquerda
function EspRight(s: String; n: Integer) : String;
begin
Result := copy(s,(length(s)-n)+1,n);
end;

//Retorna Caracteres da Posiçao N a N2
Function SubStr(s: String; n,n2: Integer) : String;
begin
Result := copy(s,n,n2);
end;

function FormataValor(Valor:Real):String;
begin
result:=StringReplace(FormatFloat('###.00',valor),',','.',[rfReplaceAll]);
end;


//Mensagem Padrão para Confirmar
Function Conf(pergunta : String; Default : Integer =0) : Boolean;
begin
        if Default = 0 then begin
                Result := (MessageDlg(Pergunta,mtConfirmation, [mbYes, mbNo],0) = mrYes)
        end else begin
                Result := (MessageDlg(Pergunta,mtConfirmation, [mbNo, mbYes],0) = mrYes)
        end;
end;

//Mensagem Padrão para Confirmar Atencao
Function ConfAtencao(pergunta : String; Default : Integer =0) : Boolean;
begin
        if Default = 0 then begin
                Result := (MessageDlg(Pergunta,mtWarning, [mbYes, mbNo],0) = mrYes)
        end else begin
                Result := (MessageDlg(Pergunta,mtWarning, [mbNo, mbYes],0) = mrYes)
        end;
end;

//Mensagem Padrão para Confirmar Erro
Function ConfErro(pergunta : String; Default : Integer =0) : Boolean;
begin
        if Default = 0 then begin
                Result := (MessageDlg(Pergunta,mtError, [mbYes, mbNo],0) = mrYes)
        end else begin
                Result := (MessageDlg(Pergunta,mtError, [mbNo, mbYes],0) = mrYes)
        end;
end;

// Mensagem de Informação Padrão
Procedure Mens(s: String);
begin
        MessageDlg(s,mtInformation, [mbOk],0);
end;

// Mensagem de Erro Padrão
Procedure MensErro(s: String);
begin
        MessageDlg(s,mtError, [mbOk],0);
end;

// Mensagem de Atenção Padrão
Procedure MensAtencao(s: String);
begin
        MessageDlg(s,mtWarning, [mbOk],0);
end;

//Permide digitar 17/11/71 e ele completa p/ 17/11/1971
Function CompData(s: String) : String;
var ano, mes, dia : word;
begin
strtodate(s); // Força o teste da data
if strtoint(trim(Copy(s,7,4))) < 100 then begin
   decodedate(date,ano,mes,dia);
   Result := Copy(s,1,6)+Copy(IntToStr(ano),1,2)+trim(Copy(s,7,4));
end;
end;

//Preenche com Zeros a Esquerda de um Número
Function Strzero(n,n1: Integer) : String;
var s : string;
    t : integer;
begin
s := trim(inttostr(n));
t := length(s);
s := replicate('0',n1)+s;
s := copy(s,t+1,length(s));
Result := s;
end;

//Retira o Ponto decimal de um nro retornando este no formato string
Function SemPonto(n: Real; p:Integer) : String;
var vlr,vlr2:string;
    i : integer;
begin
str(n:15:2,vlr);
vlr2 := '';
for i := 1 to length(vlr) do begin
    if vlr[i] <> '.' then
       vlr2 := vlr2+vlr[i];
end;
if P > 0 then
   Result := StrZero(strtoint(vlr2),p)
else
   Result := FormatFloat('###00', StrToFloat(vlr2));
end;

//Padroniza Tamanho de String a Direita
Function Padr(s: String; t: Integer) : String;
begin
Result := copy(s+space(t),1,t);
end;

//Padroniza Tamanho de String a Esquerda
Function PadL(s: String; t: Integer) : String;
begin
Result := copy(space(t)+s,length(s)+1,t);
end;

//Padroniza Tamanho de String ao Centro
Function PadC(s: String; t: Integer) : String;
begin
Result := space((t div 2)-(length(s) div 2))+s+space((t div 2)-(length(s) div 2));
end;

//RETIRA AS BARRAS DA DATA
Function SepDataD(dt : TDateTime) : String;
var
   dts : string;
begin
dts := datetostr(dt);
Result := copy(dts,1,2)+copy(dts,4,2)+copy(dts,7,4);
end;

//RETIRA AS BARRAS DE UMA DATA JA CONVERTIDA PARA STR
Function SepDataS(dts : string) : string;
begin
Result := copy(dts,1,2)+copy(dts,4,2)+copy(dts,7,4);
end;

//CHECAR CPF
Function Cpf(num: string): Boolean;
var
n1,n2,n3,n4,n5,n6,n7,n8,n9: integer;
d1,d2, x: integer;
digitado, calculado, num2: string;
begin
try
     num2 := '';
     for x := 1 to length(num) do begin
         if (num[x] >= '0') and (num[x] <= '9') then
            num2 := num2+num[x];
     end;
     num := num2;
     if num='' then begin
        cpf := True;
        exit;
     end;

     n1:=StrToInt(num[1]);
     n2:=StrToInt(num[2]);
     n3:=StrToInt(num[3]);
     n4:=StrToInt(num[4]);
     n5:=StrToInt(num[5]);
     n6:=StrToInt(num[6]);
     n7:=StrToInt(num[7]);
     n8:=StrToInt(num[8]);
     n9:=StrToInt(num[9]);
     d1:=n9*2+n8*3+n7*4+n6*5+n5*6+n4*7+n3*8+n2*9+n1*10;
     d1:=11-(d1 mod 11);

     if d1>=10 then d1:=0;
     d2:=d1*2+n9*3+n8*4+n7*5+n6*6+n5*7+n4*8+n3*9+n2*10+n1*11;
     d2:=11-(d2 mod 11);

     if d2>=10 then d2:=0;

     calculado:=inttostr(d1)+inttostr(d2);

     digitado:=num[10]+num[11];

     if calculado=digitado then
        cpf:=true
     else
        cpf:=false;
except
        Cpf := False;
end;
end;

//CHECAR CGC
Function Cgc(num: string): boolean;
var
n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12: integer;
d1,d2,x: integer;
digitado, calculado,num2 : string;
begin
try
     num2 := '';
     for x := 1 to length(num) do begin
         if (num[x] >= '0') and (num[x] <= '9') then
            num2 := num2+num[x];
     end;
     num := num2;
     if num='' then begin
        cgc := True;
        exit;
     end;
     n1:=StrToInt(num[1]);
     n2:=StrToInt(num[2]);
     n3:=StrToInt(num[3]);
     n4:=StrToInt(num[4]);
     n5:=StrToInt(num[5]);
     n6:=StrToInt(num[6]);
     n7:=StrToInt(num[7]);
     n8:=StrToInt(num[8]);
     n9:=StrToInt(num[9]);
     n10:=StrToInt(num[10]);
     n11:=StrToInt(num[11]);
     n12:=StrToInt(num[12]);
     d1:=n12*2+n11*3+n10*4+n9*5+n8*6+n7*7+n6*8+n5*9+n4*2+n3*3+n2*4+n1*5;
     d1:=11-(d1 mod 11);
     if d1>=10 then d1:=0;
     d2:=d1*2+n12*3+n11*4+n10*5+n9*6+n8*7+n7*8+n6*9+n5*2+n4*3+n3*4+n2*5+n1*6;
     d2:=11-(d2 mod 11);
     if d2>=10 then d2:=0;
     calculado:=inttostr(d1)+inttostr(d2);
     digitado:=num[13]+num[14];
     if calculado=digitado then
        cgc:=true
     else
        cgc:=false;
except
        Cgc := False;
end;
end;

//Checa se a Idade ara Ver se é maior ou menor que 18
Function MaiorIdad(dn : TdateTime; dt : TdateTime) : Boolean;
var
   dNas, data : String;
begin
dNas := datetostr(dn);
data := datetostr(dt);
if (strtoint(copy(data,7,4)) - strtoint(copy(dnas,7,4))) > 18 then begin
   result := True;
   exit;
end;

if (strtoint(copy(data,7,4)) - strtoint(copy(dNas,7,4))) < 18 then begin
   result := False;
   exit;
end;
if (strtoint(copy(data,7,4)) - strtoint(copy(dnas,7,4))) = 18 then begin
   if strtoint(copy(data,4,2)+copy(data,1,2)) < strtoint(copy(dnas,4,2)+copy(dnas,1,2)) then
      result := False
   else
      result := True;
      exit;
end;
result := True;
end;

// Transforma a hora 9:53.25  em 095325 para comparacoes
Function Tirapnto(hora : TDateTime) : string;
var c,sp : string;
    n : integer;
begin
     c := timetostr(hora);
     sp := '';
     for n := 1 to length(c) do begin
         if (copy(c,n,1) =':') or (copy(c,n,1) ='.') then begin
            continue;
         end;
         sp := sp+copy(c,n,1);
     end;
     result := copy(strzero(strtoint(sp),6),1,4);
end;

//Cria Digito EAN
function digEAN(Cod : real) : string;
var dig,m,x,somatot : integer;
    nro : String;
begin
     nro     := formatfloat('000000000000',cod);
     m       := 1;
     somatot :=  0;
     for x := 1 to 12 do begin
         somatot := somatot + (strtoint(copy(nro,x,1))*m);
         if m = 1 then
            m := 3
         else
            m := 1;
     end;

     if ((somatot div 10)*10) =  somatot then
         dig := 0
     else
         dig := (((somatot div 10)+1)*10)  - somatot;

     result := nro+strzero(dig,1);
end;

//Valida Digito EAN
Function checkEAN(EAN : string) : boolean;
var dig,m,x,somatot : integer;
    nro : String;
begin
     if ean = '' then begin
        result := false;
        exit;
     end;
     ean := formatfloat('0000000000000',strtofloat(trim(ean)));

     nro := copy(EAN,1,12);
     m   := 1;
     somatot :=  0;
     for x := 1 to 12 do begin
         somatot := somatot + (strtoint(copy(nro,x,1))*m);
         if m = 1 then
            m := 3
         else
            m := 1;
     end;

     if ((somatot div 10)*10) =  somatot then
         dig := 0
     else
         dig := (((somatot div 10)+1)*10)  - somatot;

     result := (copy(EAN,13,1) = strzero(dig,1));
end;

//Verificar para que serve
Function iif(logic : boolean; r1 : string; r2 : string) : string;
begin
   if logic then
        result := r1
   else
        result := r2;
end;

//Verificar para que serve
Function ChrTrans(s1:string;c1 : char;c2 :char) : string;
var x : integer;
    s2 : string;
    c : string;
begin
    s2 := '';
    for x := 1 to length(s1) do begin
        c := copy(s1,x,1);
        if c = c1 then
            c := c2;
        s2 := s2+c;
    end;
    result := s2;
end;

//Retorna o Dia da Semana
Function DiaSemana(Data : TDateTime) : String;
var
  Days: array[1..7] of string;
begin
  days[1] := 'Domingo';
  days[2] := 'Segunda';
  days[3] := 'Terça';
  days[4] := 'Quarta';
  days[5] := 'Quinta';
  days[6] := 'Sexta';
  days[7] := 'Sábado';
  Result := days[DayOfWeek(data)]
end;

//Retorna o Dia de uma Data
Function Day(data : TDateTime) : Integer;
var
   ano, mes, dia : word;
begin
decodedate(data,ano,mes,dia);
Result := dia;
end;

//Retorna o Mes de uma Data
Function Month(data : TDateTime) : integer;
var
   ano, mes, dia : word;
begin
decodedate(data,ano,mes,dia);
result := mes;
end;

//Retorna o Ano de uma Data
Function Year(data : TDateTime) : integer;
var
   ano, mes, dia : word;
begin
decodedate(data,ano,mes,dia);
Result := ano;
end;

//Abrevia um Nome
Function AbreviaNome(Nome: String): String;
var
    Nomes: array[1..20] of string;
    i, TotalNomes: Integer;
begin
Nome := Trim(Nome);
Result := Nome;

{Insere um espaço para garantir que todas as letras sejam testadas}
Nome := Nome + #32;

{Pega a posição do primeiro espaço}
i := Pos(#32, Nome);

if i > 0 then begin
   TotalNomes := 0;
   {Separa todos os nomes}
   while i > 0 do begin
         Inc(TotalNomes);
         Nomes[TotalNomes] := Copy(Nome, 1, i - 1);
         Delete(Nome, 1, i);
         i := Pos(#32, Nome);
   end;
   if TotalNomes > 2 then begin
      {Abreviar a partir do segundo nome, exceto o último.}
      for i := 2 to TotalNomes - 1 do begin
          {Contém mais de 3 letras? (ignorar de, da, das, do, dos, etc.)}
          if Length(Nomes[i]) > 3 then
             {Pega apenas a primeira letra do nome e coloca um ponto após.}
             Nomes[i] := Nomes[i][1] + '.';
      end;
      Result := '';
      for i := 1 to TotalNomes do
          Result := Result + Trim(Nomes[i]) + #32;
          Result := Trim(Result);
   end;
end;
end;

//Retorna a Quantidade de Cores que suporta o Monitor
Function QdeCores : integer;var h : HDC;
begin
h := 0;
try h := GetDC( 0 );
  Result :=1 shl ( GetDeviceCaps( h, PLANES ) * GetDeviceCaps( h, BITSPIXEL ));
finally
  ReleaseDC( 0, h );
end;
end;

//Retorna a Velocidade do Processador
Function GetCPUSpeed: Double;
const
DelayTime = 500;
var
TimerHi, TimerLo: DWORD;
PriorityClass, Priority: Integer;
begin
try
PriorityClass := GetPriorityClass(GetCurrentProcess);
Priority := GetThreadPriority(GetCurrentThread);

SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL);

Sleep(10);
asm
dw 310Fh // rdtsc
mov TimerLo, eax
mov TimerHi, edx
end;
Sleep(DelayTime);
asm 
dw 310Fh // rdtsc
sub eax, TimerLo 
sbb edx, TimerHi 
mov TimerLo, eax
mov TimerHi, edx
end;

SetThreadPriority(GetCurrentThread, Priority);
SetPriorityClass(GetCurrentProcess, PriorityClass);

Result := TimerLo / (1000.0 * DelayTime);
except
        result := 0;
end;
end;

Function SystemDateTime(tDate: TDateTime; tTime: TDateTime): Boolean;
{Permite que você altere a data e a hora do sistema}
var
   tSetDate: TDateTime;
   vDateBias: Variant;
   tSetTime: TDateTime;
   vTimeBias: Variant;
   tTZI: TTimeZoneInformation;
   tST: TSystemTime;
begin
GetTimeZoneInformation(tTZI);
vDateBias := tTZI.Bias / 1440;
tSetDate := tDate + vDateBias;
vTimeBias := tTZI.Bias / 1440;
tSetTime := tTime + vTimeBias;
with tST do
     begin
     wYear := StrToInt(FormatDateTime('yyyy', tSetDate));
     wMonth := StrToInt(FormatDateTime('mm', tSetDate));
     wDay := StrToInt(FormatDateTime('dd', tSetDate));
     wHour := StrToInt(FormatDateTime('hh', tSettime));
     wMinute := StrToInt(FormatDateTime('nn', tSettime));
     wSecond := StrToInt(FormatDateTime('ss', tSettime));
     wMilliseconds := 0;
     end;
SystemDateTime := SetSystemTime(tST);
end;

//Função para Saber se o Disq. está no Drive
Function DiskInDrive(const Drive: char): Boolean;
var DrvNum: byte;
    EMode: Word;
begin
Result := False;
DrvNum := ord(Drive);
if DrvNum >= ord('a') then dec(DrvNum,$20);
   EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
Try
   if DiskSize(DrvNum-$40) <> -1 then
      Result := True
   else
      MessageBeep(0);
Finally
       SetErrorMode(EMode);
end;
end;




{Calcula o Modulo 11 de um numero
Uso :
    }
function Modulo11(Numero: string; De,Ate: integer;SuperDigito:Boolean):String;
var i,peso,soma: integer;

begin
peso:= De;
soma:= 0;
for i:= Length(Numero) downto 1 do
begin
    soma:= soma + strtoint64(Numero[i])*peso;
    if peso >= Ate then
       peso:= De else
       inc(Peso);
end;

soma:= soma * 10;
if SuperDigito then
   if ((soma MOD 11) = 0) or
      ((soma MOD 11) = 10) then
      Result:= '0'
   else
      Result:=IntToStr(soma MOD 11)
else
   if ((soma MOD 11) = 0) or
      ((soma MOD 11) = 1) or
      ((soma MOD 11) = 10) then
      Result:= '1'
   else
      Result:=IntToStr(soma MOD 11)
end;

Function Prest(valor : real;dtadest : TDateTime; dtaori : TDateTime; txa : Real;DiasEntrada : Integer) : real;
Var Dias : Integer;
    fator : Real;
begin
     dias := 0;
     While dtadest <> dtaori do begin
           if dtadest > dtaori then begin
	      dtadest := dtadest -1;
              dias    := dias -1;
           end else begin
               dtadest := dtadest +1;
               dias    := dias +1;
           End;
     End;
     txa   := (txa/100)+1;
     if abs(dias) > DiasEntrada then begin
        fator := (1/(power(txa,(dias/30))));
        fator := 1/fator;
     end else
        Fator := 1;
     result := (valor*fator);
end;



// Chama o OutLook já com o endereco setado
procedure SendEmail(endereco : String);
var
  buffer: String;
begin
  buffer := 'Mailto:'+trim(Endereco);
  ShellExecute(Application.Handle, nil, PChar(buffer), nil, nil, SW_SHOWNORMAL);
end;


// Chama o Navegador padrao já na pagina setada
procedure JumpTo(const aAdress: String);
var
  buffer: String;
begin
  Buffer := stringReplace(aAdress,'http://','',[rfReplaceAll]);
  buffer := 'http://' + aAdress;
  ShellExecute(Application.Handle, nil, PChar(buffer), nil, nil, SW_SHOWNORMAL);
end;




function AjusteMoney(Valor : Real) : Real;
begin
     result := StrtoFloat(FormatFloat('#########0.00',Valor));
end;


function MesExtenso(mes : Integer) : String;
Var Meses : Array[1..12] of string;
begin
     Meses[01] := 'Janeiro';
     Meses[02] := 'Fevereiro';
     Meses[03] := 'Marco';
     Meses[04] := 'Abril';
     Meses[05] := 'Maio';
     Meses[06] := 'Junho';
     Meses[07] := 'Julho';
     Meses[08] := 'Agosto';
     Meses[09] := 'Setembro';
     Meses[10] := 'Outubro';
     Meses[11] := 'Novembro';
     Meses[12] := 'Dezembro';
     result := meses[mes]
end;

function DataExtenso(Data : TdateTime) : String;
begin
     result := strzero(Day(Data),2)+ ' de '+mesExtenso(Month(data)) + ' de '+strzero(year(Data),4);

end;

function Extenso3em3( Numero : Word ) : String;
const Valores : Array[1..36] of LongInt = ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                     13, 14, 15, 16, 17, 18, 19, 20, 30, 40, 50, 60, 70, 80, 90,
                     100, 200, 300, 400, 500, 600, 700, 800, 900 );
      Nomes : Array[0..36] of String[12] = ( '', 'um', 'dois', 'três', 'quatro',
                     'cinco', 'seis', 'sete', 'oito', 'nove', 'dez', 'onze',
                     'doze', 'treze', 'quatorze', 'quinze', 'dezesseis',
                     'dezessete', 'dezoito', 'dezenove', 'vinte', 'trinta',
                     'quarenta', 'cinqüenta', 'sessenta', 'setenta', 'oitenta',
                     'noventa', 'cento', 'duzentos', 'trezentos', 'quatrocentos',
                     'quinhentos', 'seiscentos', 'setecentos', 'oitocentos',
                     'novecentos' );
var i         : byte;
    resposta  : String;
    inteiro   : Word;
    resto     : LongInt;
begin
  Inteiro := Numero;
  Resposta := '';
  for i := 36 downto 1 do begin
      Resto := ( Inteiro div valores[i] ) * valores[i];
      if ( Resto = valores[i] ) and ( Inteiro >= Resto ) then begin
         Resposta := Resposta + Nomes[i] + ' e ';
         Inteiro := Inteiro - Valores[i];
      end;
  end;
  Extenso3em3 := Copy( Resposta, 1, Length( Resposta ) - 3 );

end;

{ A função extenso divide os números em grupos de tres e chama a função
  extenso3em3 para o extenso de cada parte. }
function Extenso( Numero : Extended ) : String;
Const NoSingular : Array[1..5] of String = ( 'bilhão', 'milhão', 'mil',
                                           'real', 'centavo' );
      NoPlural   : Array[1..5] of String = ( 'bilhões', 'milhões', 'mil',
                                           'reais', 'centavos' );
var i         : byte;
    resposta  : Array[1..5] of String; { de centavos a bilhões }
    plural    : Array[1..5] of Boolean;
    inteiro   : LongInt;
    NumStr    : String;
    Trio      : Word;
    SomaTrio  : Word;

begin
// Inteiro  := Trunc( Numero * 100 );
 Inteiro := StrtoInt(FormatFloat('#########0', Numero * 100));


 { Inicializa os vetores }
 for i := 1 to 5 do begin
     resposta[i] := '';
     plural[i]   := False;
 end;

 { O número é partido em partes distintas, agrupadas de três em três casas:
   centenas, milhares, milhões e bilhões. A última parte (a quinta)
   contém apenas os centavos, com duas casas }
 Str( Inteiro : 14, NumStr );
 i        := 1;
 SomaTrio := 0;
 Inteiro  := Inteiro div 100; { remove os centavos }

 while NumStr[i] = ' ' do begin
   NumStr[i] := '0';
   i         := i + 1;
 end;

 for i := 1 to 5 do begin
      Trio := StrToInt( Copy( NumStr, 3 * i - 2, 3 ) );
      if trio <> 0 then begin
         resposta[i] := resposta[i] + extenso3em3( trio );
         if Trio > 1 then Plural[i] := True;
         if i <> 5 then SomaTrio := SomaTrio + Trio; {Não somar os centavos}
      end;
 end;

 { Gerar a resposta propriamente dita }
 NumStr := '';
 { se não atribuir um valor à resposta 5, a palavra "real" poderá não ser
   impressa em algumas situações. Entretanto, a palavra "real" não poderá ser
   impressa se o valor contiver apenas centavos
 }
 if (resposta[4]='') and ( SomaTrio <> 0 ) then begin
    resposta[4] := ' ';
    plural[4]   := True;
 end;

 { Basta ser maior que um para que a palavra "real" seja escrita no plural }
 if SomaTrio > 1 then plural[4] := True;

 for i := 1 to 5 do begin
     { se for apenas cem, não escrever 'cento' }
     if resposta[i] = 'cento' then resposta[i] := 'cem';
     if resposta[i] <> '' then begin
        NumStr := NumStr + resposta[i] + ' ';
        if plural[i] then
           NumStr := NumStr + NoPlural[i] + ' '
        else
           NumStr := NumStr + NoSingular[i] + ' ';

        { Verifica a necessidade da particula 'e' para os números }
        if (i < 4) and (resposta[i] <> '') and (resposta[i+1] <> '')
           and (resposta[i+1] <> ' ') then
           NumStr := NumStr + 'e ';
     end;

     { se for apenas bilhões ou milhões, acrescenta o 'de' }
     if ( i=3 ) and ( SomaTrio <> 0 ) and ( ( Inteiro mod 1000000 = 0 )
        or ( Inteiro mod 1000000000 = 0 ) ) then
        NumStr := NumStr + 'de';

     { se tiver centavos, acrescenta a partícula 'e', mas somente se houver
       qualquer valor na parte inteira }
     if ( i = 4 ) and ( resposta[5] <> '' ) and ( inteiro > 0 ) then
        NumStr := NumStr + ' e ';
 end;

 { Eliminar algumas situações em que o extenso gera 2 ou 3 espaços dentro
   da resposta.}
 i := pos( '   ', NumStr );
 if i <> 0 then
    delete( NumStr, i, 2 );
 i := pos( '  ', NumStr );
 if i <> 0 then
    delete( NumStr, i, 1 );
 Extenso := NumStr;
end;


{ Envioa mensagem a outra estacao }
// netsend('Giga_server','servidor','Teste de mensaaksjdkfl');
function NetSend(dest, source, msg: string): longint; overload;
type
  TNetMessageBufferSendFunction = function(servername, msgname, fromname:
PWideChar; buf: PWideChar; buflen: Cardinal): longint; stdcall;
var
  NetMessageBufferSend: TNetMessageBufferSendFunction;

  SourceWideChar    : PWideChar;
  DestWideChar      : PWideChar;
  MessagetextWideChar: PWideChar;

  Handle            : THandle;
begin

  Handle := LoadLibrary('NETAPI32.DLL');
  if Handle = 0 then
  begin
    Result := GetLastError;
    exit;
  end;

  @NetMessageBufferSend := GetProcAddress(Handle, 'NetMessageBufferSend');
  if @NetMessageBufferSend = nil then
  begin
    Result := GetLastError;
    exit;
  end;

  MessagetextWideChar := nil;
  SourceWideChar := nil;
  DestWideChar := nil;

  try
    GetMem(MessagetextWideChar, Length(msg) * SizeOf(WideChar) + 1);
    GetMem(DestWideChar, 20 * SizeOf(WideChar) + 1);
    StringToWideChar(msg, MessagetextWideChar, Length(msg) *
SizeOf(WideChar) + 1);
    StringToWideChar(Dest, DestWideChar, 20 * SizeOf(WideChar) + 1);
    if source = '' then
      result := NetMessageBufferSend(nil, DestWideChar, nil,
MessagetextWideChar, Length(msg) * SizeOf(WideChar) + 1)
    else
    begin
      GetMem(SourceWideChar, 20 * SizeOf(WideChar) + 1);
      StringToWideChar(source, SourceWideChar, 20 * SizeOf(WideChar) + 1);
      result := NetMessageBufferSend(nil, DestWideChar, SourceWideChar,
MessagetextWideChar, Length(msg) * SizeOf(WideChar) + 1);
      freemem(SourceWideChar);
    end;
  finally
    FreeMem(MessagetextWideChar);
    FreeLibrary(Handle);
  end;
end;

function NetSend(Dest, msg: string): longint; overload;
begin
  Result := NetSend(Dest, '', msg);
end;

function NetSend(msg: string): longint; overload;
begin
  Result := NetSend('', '', msg);
end;


// Nome do Computador
function myComputerName : String;
var
   pcComputer: PChar;
   dwCSize: DWORD;
begin
   dwCSize := MAX_COMPUTERNAME_LENGTH + 1;
   pcComputer := '';
   try
      GetMem(pcComputer, dwCSize);
      if Windows.GetComputerName(pcComputer, dwCSize) then
         Result := pcComputer;
   finally
      FreeMem(pcComputer);
   end;
end;


{Encripta um Texto utilizando para isso uma chave na qual se faz um Xor}
function Encripty(Texto,Chave : String) : String;
var
   I, CH  : Integer;
   Texto2 : String;
begin
     Texto2 := '';
     CH     := 1;
     For I := 1 to Length(Texto) do begin
         Texto2 := Texto2 + chr(ord(texto[i]) xor ord(chave[ch])) ;
         ch := ch+1;
         if ch > length(chave) then
            ch := 1;
     end;
     result := texto2;
end;


{chama a conexao dial up
 ex. calldial('com4server');  }
procedure CallDial(DialEntry:string);
begin
  WinExec(PChar('rundll32.exe rnaui.dll,RnaDial '+DialEntry), sw_show);
end;


{Checa se esta conectado na internet
Exemplo :
        if not IsConnected then begin
           CallDial('NetSiteServer');
        end;
}
Function IsConnected : Boolean;
var
  reg  : TRegistry;
  buff : dword;
begin
  reg:= tregistry.Create ;
  Reg.RootKey:=HKey_local_machine;
  if reg.OpenKey('\System\CurrentControlSet\Services\RemoteAccess',false)
then
  begin
    reg.ReadBinaryData('Remote Connection',buff,sizeof(buff));
    result := buff = 1;
    reg.CloseKey ;
    reg.Free ;
  end;
end;


function LocalIP: string;
type
   TaPInAddr = array [0..10] of PInAddr;
   PaPInAddr = ^TaPInAddr;
var
    phe: PHostEnt;
    pptr: PaPInAddr;
    Buffer: array [0..63] of char;
    i: Integer;
    GInitData: TWSADATA;
begin
    WSAStartup($101, GInitData);
    Result := '';
    GetHostName(Buffer, SizeOf(Buffer));
    phe :=GetHostByName(buffer);
    if phe = nil then Exit;
    pptr := PaPInAddr(Phe^.h_addr_list);
    i := 0;
    while pptr^[i] <> nil do
    begin
      result:=StrPas(inet_ntoa(pptr^[i]^));
      Inc(i);
    end;
    WSACleanup;
end;



{Testa se o número do pis é válido ou não}
function validapis(Dado : String) : boolean;
var
i, wsoma, Wm11, Wdv,wdigito : Integer;
begin
if Trim(Dado) <> '' Then
   begin
   wdv := strtoint(copy(Dado, 11, 1));
   wsoma := 0;
   wm11 := 2;
   for i := 1 to 10 do
       begin
       wsoma := wsoma + (wm11 *strtoint(copy(Dado,11 - I, 1)));
       if wm11 < 9 then
          begin
          wm11 := wm11+1
          end
       else
          begin
          wm11 := 2;
          end;
       end;
   wdigito := 11 - (wsoma MOD 11);
   if wdigito > 9 then
      begin
      wdigito := 0;
      end;
   if wdv = wdigito then
      begin
      validapis := true;
      end
   else
      begin
      validapis := false;
      end;
   end;
end;

procedure LimpaCabec;
var
   N : Integer;
begin
For N := 1 to 50 do begin
    Cabecalho[N] := '';
end;
end;

function QtdeColunas : Integer;
var
   N, Colunas : Integer;
begin
Colunas := 0;
For N := 1 to 50 do begin
    if Cabecalho[N] <> '' then
       Colunas := Colunas + 1
    else
       Break;
end;
Result := Colunas;
end;

Function Cabec80(Empresa, Titulo, DataInicial, DataFinal, Pesquisando, TitPesquisa: String; Pagina: Integer) : Integer; // Resulta o número de linhas impressas
var
   N, Linha, Colunas : Integer;
begin
Linha := 1;
writeln(ImpRel,#18+'--------------------------------------------------------------------------------');
writeln(ImpRel,#27+'E'+Empresa+#27+'F');
writeln(ImpRel,padc(Titulo,80));
writeln(ImpRel,'Data....: '+FormatDateTime('dd/mm/yyyy', Date)+'  Hora:....: '+FormatDateTime('hh:mm', now));
writeln(ImpRel,'Pagina..: '+StrZero(Pagina,5));
writeln(ImpRel,'--------------------------------------------------------------------------------');
Linha := Linha + 7;
if (Trim(DataInicial) <> '') and (Trim(DataFinal) <> '') then begin
   writeln(ImpRel,#27+'E'+'Pesquisando por.: '+Padr(Pesquisando,20)+' - '+TitPesquisa);
   Linha := Linha + 1;
   writeln(ImpRel,'Periodo.........: '+DataInicial+' Ate '+DataFinal+#27+'F');
   Linha := Linha + 1;
   writeln(ImpRel,'--------------------------------------------------------------------------------');
   Linha := Linha + 1;
end else
   if TitPesquisa <> '' then begin
      writeln(ImpRel,#27+'E'+TitPesquisa+#27+'F');
      Linha := Linha + 1;
      writeln(ImpRel,'--------------------------------------------------------------------------------');
      Linha := Linha + 1;
   end;
N := 1;
Colunas := QtdeColunas;
While Cabecalho[N] <> '' do begin
      if N < Colunas then
         write(ImpRel,Cabecalho[N]+' | ')
      else
         write(ImpRel,Cabecalho[N]);
      N := N + 1;
end;
Linha := Linha + 1;
if Trim(Cabecalho[1]) <> '' then begin
   writeln(ImpRel,'');
   writeln(ImpRel,'--------------------------------------------------------------------------------');
   Linha := Linha + 1;
end;
Result := Linha;
end;

Function Cabec80C(Empresa, Titulo, DataInicial, DataFinal, Pesquisando, TitPesquisa: String; Pagina: Integer) : Integer; // Resulta o número de linhas impressas
var
   N, Linha, Colunas : Integer;
begin
Linha := 1;
writeln(ImpRel,#15+'--------------------------------------------------------------------------------------------------------------------------');
writeln(ImpRel,#27+'E'+Empresa+#27+'F');
writeln(ImpRel,padc(Titulo,122));
writeln(ImpRel,'Data....: '+FormatDateTime('dd/mm/yyyy', Date)+'  Hora:....: '+FormatDateTime('hh:mm', now));
writeln(ImpRel,'Pagina..: '+StrZero(Pagina,5));
writeln(ImpRel,'--------------------------------------------------------------------------------------------------------------------------');
Linha := Linha + 7;
if (Trim(DataInicial) <> '') and (Trim(DataFinal) <> '') then begin
   writeln(ImpRel,#27+'E'+'Pesquisando por.: '+Padr(Pesquisando,20)+' - '+TitPesquisa);
   Linha := Linha + 1;
   writeln(ImpRel,'Periodo.........: '+DataInicial+' Ate '+DataFinal+#27+'F');
   Linha := Linha + 1;
   writeln(ImpRel,'--------------------------------------------------------------------------------------------------------------------------');
   Linha := Linha + 1;
end else
   if TitPesquisa <> '' then begin
      writeln(ImpRel,#27+'E'+TitPesquisa+#27+'F');
      Linha := Linha + 1;
      writeln(ImpRel,'--------------------------------------------------------------------------------------------------------------------------');
      Linha := Linha + 1;
   end;
N := 1;
Colunas := QtdeColunas;
While Cabecalho[N] <> '' do begin
      if N < Colunas then
         write(ImpRel,Cabecalho[N]+' | ')
      else
         write(ImpRel,Cabecalho[N]);
      N := N + 1;
end;
Linha := Linha + 1;
if Trim(Cabecalho[1]) <> '' then begin
   writeln(ImpRel,'');
   writeln(ImpRel,'--------------------------------------------------------------------------------------------------------------------------');
   Linha := Linha + 1;
end;
Result := Linha;
end;


{Retorna o Ultimo dia do Mes}
function UltDiaMes(Mes, Ano : String) : TDateTime;
var
   Dia : TDateTime;
   N, MesOrig : Integer;
begin
Dia := StrToDate('27/'+Mes+'/'+Ano);
MesOrig := Month(Dia);
For N := 1 to 6 do begin
    if Month(Dia+1) <> MesOrig then
       Break;
    Dia := Dia + 1;
end;
Result := Dia;
end;

function CodBarras(cCodigo : String) : String;
const
     cGuarda = '101';
     cCentro = '01010';
     UNIDIR_ON = CHR(27) + CHR(85) + CHR(1);
     DBL_STRIKE_ON = CHR(27) + CHR(71);
     LINE_SPACING = CHR(27) + CHR(51);
     DOUBLE_DENS = CHR(27) + CHR(76);
var
   acTableA,acTableB,acTableC,acTableLast : Array [1..10] of String;
   cTableUse,
   cCodeBar,
   cTB : String;
   nLength, nCount, nPos : Integer;
begin
acTableA[01] := '0001101';
acTableA[02] := '0011001';
acTableA[03] := '0010011';
acTableA[04] := '0111101';
acTableA[05] := '0100011';
acTableA[06] := '0110001';
acTableA[07] := '0101111';
acTableA[08] := '0111011';
acTableA[09] := '0110111';
acTableA[10] := '0001011';

acTableB[01] := '0100111';
acTableB[02] := '0110011';
acTableB[03] := '0011011';
acTableB[04] := '0100001';
acTableB[05] := '0011101';
acTableB[06] := '0111001';
acTableB[07] := '0000101';
acTableB[08] := '0010001';
acTableB[09] := '0001001';
acTableB[10] := '0010111';

acTableC[01] := '1110010';
acTableC[02] := '1100110';
acTableC[03] := '1101100';
acTableC[04] := '1000010';
acTableC[05] := '1011100';
acTableC[06] := '1001110';
acTableC[07] := '1010000';
acTableC[08] := '1000100';
acTableC[09] := '1001000';
acTableC[10] := '1110100';

acTableLast[01] := 'AAAAAA';
acTableLast[02] := 'AABABB';
acTableLast[03] := 'AABBAB';
acTableLast[04] := 'AABBBA';
acTableLast[05] := 'ABAABB';
acTableLast[06] := 'ABBAAB';
acTableLast[07] := 'ABBBAA';
acTableLast[08] := 'ABABAB';
acTableLast[09] := 'ABABBA';
acTableLast[10] := 'ABBABA';

//Primeiro Digito indica qual a sequencia de Tabelas a ser usada
cTableUse := acTableLast[STRTOINT(ESPLEFT(cCodigo,1))+1];

//Codificar primeira parte do Codigo
cCodeBar := cGuarda;
FOR nCount := 1 TO 6 do begin
    cTB  := COPY(cTableUse,nCount,1);
    nPos := StrToInt(Copy(cCodigo,nCount+1,1))+1;
    if cTB = 'A' then
       cCodeBar := cCodeBar + acTableA[nPos]
    else
       cCodeBar := cCodeBar + acTableB[nPos];
end;

//Codificar a segunda parte do Codigo
cCodebar := cCodeBar + cCentro;
FOR nCount := 7 TO 12 do begin
    nPos := StrToInt(Copy(cCodigo,nCount+1,1))+1;
    cCodeBar := cCodeBar + acTableC[nPos];
END;

//Introduzir Caracter de Guarda Final
cCodeBar := cCodeBar + cGuarda;

//Codigo de Barras Pronto! - Transformar p/ Padrao de Bits da Impressora
//e duplicar as Barras p/ melhor definicao
cCodeBar := StringReplace(cCodeBar,'1',chr(255)+chr(255),[rfReplaceAll]);
cCodeBar := StringReplace(cCodeBar,'0',chr(0)+chr(0),[rfReplaceAll]);

//Introduzir Caracteres de Comando da impressora
nLength  := LENGTH(cCodeBar);
cCodeBar := DOUBLE_DENS + CHR(nLength Mod 216) + CHR(StrToInt(FormatFloat('000',INT(nLength / 216)))) + cCodeBar;
Result   := cCodeBar;
end;

function TiraPonto(Valor : String) : Real;
var
   Resultado : String;
   N         : Integer;
begin
Resultado :='';
For N := 1 to Length(Valor) do begin
    if Copy(Valor,N,1) <> '.' then
       Resultado := Resultado+Copy(Valor,N,1);
end;
if Trim(Resultado) = '' then
   Result := 0
else
   Result := StrToFloat(Trim(Resultado));
end;




function ChecaCEP(cCep:String ; cEstado:String): Boolean;
var
 cCEP1 : Integer;
begin
 cCep := copy(cCep,1,5) + copy(cCep,7,3);
 cCEP1 := StrToInt(copy(cCep,1,3));
 if Length(trim(cCep)) > 0 then
 begin
  if (StrToInt(cCep) <= 1000000.0) then
   begin
    MessageDlg('CEP tem que ser maior que [01000-000]',mtError,[mbOk],0);
    Result := False
   end
  else
  begin
    if Length(trim(copy(cCep,6,3))) < 3 then Result := False else
    if (cEstado = 'SP') and (cCEP1 >= 10 ) and (cCEP1 <= 199) then Result := True else
    if (cEstado = 'RJ') and (cCEP1 >= 200) and (cCEP1 <= 289) then Result := True else
    if (cEstado = 'ES') and (cCEP1 >= 290) and (cCEP1 <= 299) then Result := True else
    if (cEstado = 'MG') and (cCEP1 >= 300) and (cCEP1 <= 399) then Result := True else
    if (cEstado = 'BA') and (cCEP1 >= 400) and (cCEP1 <= 489) then Result := True else
    if (cEstado = 'SE') and (cCEP1 >= 490) and (cCEP1 <= 499) then Result := True else
    if (cEstado = 'PE') and (cCEP1 >= 500) and (cCEP1 <= 569) then Result := True else
    if (cEstado = 'AL') and (cCEP1 >= 570) and (cCEP1 <= 579) then Result := True else
    if (cEstado = 'PB') and (cCEP1 >= 580) and (cCEP1 <= 589) then Result := True else
    if (cEstado = 'RN') and (cCEP1 >= 590) and (cCEP1 <= 599) then Result := True else
    if (cEstado = 'CE') and (cCEP1 >= 600) and (cCEP1 <= 639) then Result := True else
    if (cEstado = 'PI') and (cCEP1 >= 640) and (cCEP1 <= 649) then Result := True else
    if (cEstado = 'MA') and (cCEP1 >= 650) and (cCEP1 <= 659) then Result := True else
    if (cEstado = 'PA') and (cCEP1 >= 660) and (cCEP1 <= 688) then Result := True else
    if (cEstado = 'AM') and ((cCEP1 >= 690) and (cCEP1 <= 692) or (cCEP1 >= 694) and

    (cCEP1 <= 698)) then Result := True else
    if (cEstado = 'AP') and (cCEP1 = 689) then Result := True else
    if (cEstado = 'RR') and (cCEP1 = 693) then Result := True else
    if (cEstado = 'AC') and (cCEP1 = 699) then Result := True else
    if ((cEstado = 'DF') or (cEstado = 'GO')) and (cCEP1 >= 700)and(cCEP1 <= 769)then

    Result := True else
    if (cEstado = 'TO') and (cCEP1 >= 770) and (cCEP1 <= 779) then Result := True else
    if (cEstado = 'MT') and (cCEP1 >= 780) and (cCEP1 <= 788) then Result := True else
    if (cEstado = 'MS') and (cCEP1 >= 790) and (cCEP1 <= 799) then Result := True else
    if (cEstado = 'RO') and (cCEP1 = 789) then Result := True else
    if (cEstado = 'PR') and (cCEP1 >= 800) and (cCEP1 <= 879) then Result := True else
    if (cEstado = 'SC') and (cCEP1 >= 880) and (cCEP1 <= 899) then Result := True else
    if (cEstado = 'RS') and (cCEP1 >= 900) and (cCEP1 <= 999) then Result := True else

    Result := False
  end;
 end
 else
 begin
  Result := True;
 end
end;


{Funcao para formatação de Telefone e
        CPF/CGC no caso de migração dos dados de clientes

        exemplo :
        ed_fone.text := formatstring('(cxxcc)cccc-cccc',FIELDBYNAME('FONE1_CLI').ASSTRING);
}
function formatstring(fmt,s:string) : string;
var x,n : integer;
    s2: string;
    s3:string;
begin

        s2 := '';
        for x := 1 to length(s) do begin
                if (s[x] >= '0') and (s[x] <= '9') then
                        s2 := s2 + s[x];
        end;
        if trim(s2) = '' then
                s2 := space(length(fmt));

        x := 0;
        for n := 1 to length(fmt) do
                if fmt[n] = 'c' then x:=x+1;
        if length(s2) < x then
                s2 := space(x-length(s2))+s2;    

        n := 1;
        s3 := '';
        for x := 1 to length(fmt) do begin
                if fmt[x] = 'c' then begin
                        s3 := s3 + s2[n];
                        n:=n+1;
                end else
                        s3 := s3 + fmt[x];
        end;
        result:= s3;
end;


function GetFileVersion(const FileName : string; Sep : Char) : string;
var
  InfoSize, Dummy: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := '';
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Dummy, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
        begin
          Result := Format('%d%s%d%s%d%s%d', [HiWord(FI.dwFileVersionMS), Sep, LoWord(FI.dwFileVersionMS), Sep,
            HiWord(FI.dwFileVersionLS), Sep, LoWord(FI.dwFileVersionLS)]);
        end;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;


// Captura a tela e salva em um BMP
Function CaptureScreen:TBitmap;
var
  DC : HDC;
  ABitmap:TBitmap;
begin
  DC := GetDC (GetDesktopWindow);
  ABitmap:=TBitmap.Create;
  try
    ABitmap.Width  := GetDeviceCaps (DC, HORZRES);
    ABitmap.Height := GetDeviceCaps (DC, VERTRES);
    BitBlt(ABitmap.Canvas.Handle, 0, 0, ABitmap.Width,
           ABitmap.Height,DC, 0, 0, SRCCOPY);
  finally
    ReleaseDC (GetDesktopWindow, DC);
  end;
Result:=ABitmap;
end;

Function  Scatter(vdataSet : Tdataset;Vform : TForm) : Boolean;
var
   I,n : Integer;
   
begin
     Try
//        vdataset.Next;
//        vdataset.Prior;
        for i := 0 to vForm.ComponentCount-1 do begin
                // Campos de tela ....
                if UpperCase(copy(vForm.Components[i].Name,1,3)) = 'ED_' then
                        continue;

                If vForm.Components[i].ClassType = TComboEdit then begin
                        TComboEdit(vForm.Components[i]).Text := Trim(vdataSet.FieldByName(vForm.Components[i].Name).AsString);
                end;

                If vForm.Components[i].ClassType = TEdit then
                        TEdit(vForm.Components[i]).Text := Trim(vdataSet.FieldByName(vForm.Components[i].Name).AsString);

                If vForm.Components[i].ClassType = TMemo then
                        TMemo(vForm.Components[i]).Text := Trim(vdataSet.FieldByName(vForm.Components[i].Name).AsString);

                If vForm.Components[i].ClassType = TDateEdit then
                        TDateEdit(vForm.Components[i]).Date := vdataSet.FieldByName(vForm.Components[i].Name).AsDateTime;

                If vForm.Components[i].ClassType = TMaskEdit then
                        TMaskEdit(vForm.Components[i]).Text := vdataSet.FieldByName(vForm.Components[i].Name).AsString;

                If vForm.Components[i].ClassType = TComboBox then begin
                        if Trim(vdataSet.FieldByName(vForm.Components[i].Name).AsString) <> '' then begin
                                For n := 0 to TComboBox(vForm.Components[i]).Items.Count -1 do begin
                                        TComboBox(vForm.Components[i]).ItemIndex := N;
                                        if TComboBox(vForm.Components[i]).Text = Trim(vdataSet.FieldByName(vForm.Components[i].Name).AsString) then
                                                Break;
                                end;
                        end;
                end;

                If vForm.Components[i].ClassType = TRXdbLookupCombo then
                        Trxdblookupcombo(vForm.Components[i]).Value := vdataSet.FieldByName(vForm.Components[i].Name).AsString;

                If vForm.Components[i].ClassType = TCurrencyEdit then
                        TCurrencyEdit(vForm.Components[i]).Value := vdataSet.FieldByName(vForm.Components[i].Name).AsFloat;

                If vForm.Components[i].ClassType = TRadioGroup then
                        TRadioGroup(vForm.Components[i]).ItemIndex := vdataSet.FieldByName(vForm.Components[i].Name).AsInteger;

                If vForm.Components[i].ClassType = TCheckBox then
                        TCheckBox(vForm.Components[i]).Checked := vdataSet.FieldByName(vForm.Components[i].Name).AsBoolean;

                If vForm.Components[i].ClassType = TImage then begin
                        // Se a fig. do banco estiver em branco
                        if (vdataSet.FieldByName(vForm.Components[i].Name).AsString = '') or
                           (vdataSet.FieldByName(vForm.Components[i].Name).AsString = chr(0)) then
                                TImage(vForm.Components[i]).Picture.Graphic := Nil
                        else
                                TImage(vForm.Components[i]).Picture.Assign(vdataSet.FieldByName(vForm.Components[i].Name));
                end;
        end;
        Result := True;
     except
          
         Result := False;
     end;
end;

Function  Gather(vdataSet : Tdataset; vForm : TForm) : Boolean;
var
   I : Integer;

var // Conversao de JPG para BMP
         aFormat  : Word;
         aData    : THandle;
         aPalette : HPALETTE;
         tmpBitMap : TBitMap;
begin
    try
          for i := 0 to vForm.ComponentCount-1 do begin
                // Campos de tela ....
                if UpperCase(copy(vForm.Components[i].Name,1,3)) = 'ED_' then
                        continue;

                if UpperCase(copy(vForm.Components[i].Name,1,3)) = 'TM_' then
                        continue;

                If vForm.Components[i].ClassType = TEdit then begin
                        // Se for auto-Increment ignorar
                        if vdataSet.FieldByName(vForm.Components[i].Name).DataType = ftAutoInc then
                                continue;
                        vdataSet.FieldByName(vForm.Components[i].Name).AsString := TEdit(vForm.Components[i]).Text;
                end;

                If vForm.Components[i].ClassType = TMemo then begin
                        vdataSet.FieldByName(vForm.Components[i].Name).AsString := TMemo(vForm.Components[i]).Text;
                end;

                If vForm.Components[i].ClassType = TComboEdit then begin
                        vdataSet.FieldByName(vForm.Components[i].Name).AsString := TComboEdit(vForm.Components[i]).Text;
                end;

                If vForm.Components[i].ClassType = TDateEdit then
                        vdataSet.FieldByName(vForm.Components[i].Name).AsDateTime := TDateEdit(vForm.Components[i]).Date;

                If vForm.Components[i].ClassType = TMaskEdit then begin
                        // Se for auto-Increment ignorar
                        if vdataSet.FieldByName(vForm.Components[i].Name).DataType = ftAutoInc then
                                continue;
                        vdataSet.FieldByName(vForm.Components[i].Name).AsString := TMaskEdit(vForm.Components[i]).Text;
                end;

                If vForm.Components[i].ClassType = TCurrencyEdit then begin
                        // Se for auto-Increment ignorar
                        if vdataSet.FieldByName(vForm.Components[i].Name).DataType = ftAutoInc then
                                continue;
                        vdataSet.FieldByName(vForm.Components[i].Name).AsFloat := TCurrencyEdit(vForm.Components[i]).Value;
                end;

                If vForm.Components[i].ClassType = TComboBox then
                        vdataSet.FieldByName(vForm.Components[i].Name).AsString := TComboBox(vForm.Components[i]).Text;

                If vForm.Components[i].ClassType = Trxdblookupcombo then
                        vdataSet.FieldByName(vForm.Components[i].Name).AsString := Trxdblookupcombo(vForm.Components[i]).Value;

                If vForm.Components[i].ClassType = TRadioGroup then
                        vdataSet.FieldByName(vForm.Components[i].Name).AsInteger := TRadioGroup(vForm.Components[i]).ItemIndex;

                If vForm.Components[i].ClassType = TCheckBox then
                         vdataSet.FieldByName(vForm.Components[i].Name).AsBoolean := TCheckBox(vForm.Components[i]).Checked;

                If vForm.Components[i].ClassType = TImage then begin
                        if TImage(vForm.Components[i]).Picture.Graphic = nil then
                                vdataSet.FieldByName(vForm.Components[i].Name).Setdata(Nil)
                        else begin
                                tmpBitMap := TBitMap.Create;
                                TImage(vForm.Components[i]).Picture.SaveToClipboardFormat(aFormat,aData,aPalette);
                                tmpBitMap.LoadFromClipboardFormat(aFormat,aData,aPalette);
                                vdataSet.FieldByName(vForm.Components[i].Name).Assign(tmpBitMap);
                                tmpBitMap.Free;
                        end;
                end;

        end;
        // Verificar os Campos do tipo Boolean
        if vdataSet.State = dsInsert then begin
                for i := 0 to vDataset.FieldCount-1 do begin
                        if (vDataSet.Fields[i].DataType = ftBoolean) and
                           (vForm.FindComponent(vDataSet.Fields[i].Name) = nil) then
                                vdataSet.FieldByName(vDataSet.Fields[i].FieldName).AsBoolean := False;
                end;
        end;
        Result := True;
    except
        result := False;
    end;
end;


Procedure ExecProg(dllname : string; rotina : string);
type TintFunction = procedure; StdCall;
Var
        HInst           : Thandle;
        FPointer        : TFarProc;
        MyFunc          : TintFunction;
begin
        Hinst := LoadLibrary(Pchar(dllname));
        if Hinst > 0 then begin
                try
                        Fpointer := GetProcAddress(Hinst,Pchar(Rotina));
                        if Fpointer <> nil then begin
                                myfunc := FPointer;
                                MyFunc;
                        end else
                                mens('Rotina "'+Rotina+'" não existe na DLL "'+DllName+'"');
                finally
                        freelibrary(Hinst);
                end;
        end else
                mens('"'+DllName + '" não encontrada...');

end;


Procedure ExecProgf(dllname : string; rotina : string; vUserLoged : String);
type TintFunction = procedure(xuserloged : Pchar) ; StdCall;
Var
        HInst           : Thandle;
        FPointer        : TFarProc;
        MyFunc          : TintFunction;
var
  Val  : String;
  pVal : PChar;
begin
        Hinst := LoadLibrary(Pchar(dllname));
        if Hinst > 0 then begin
                try
                        Fpointer := GetProcAddress(Hinst,Pchar(Rotina));
                        if Assigned(Fpointer) then begin
                                myfunc := FPointer;
                                Val := vUserLoged;
                                GetMem(pVal, Length(Val));
                                pVal := StrPCopy(pVal, Val);
                                MyFunc(pVal);
                        end else
                                mens('Rotina "'+Rotina+'" não existe na DLL "'+DllName+'"');
                finally
                        FreeMem(pVal, Length(Val));
                        freelibrary(Hinst);

                end;
        end else
                mens('"'+DllName + '" não encontrada...');

end;



Function ConvSaida(UnidEst : String; UnidVnd : String; ValorEst : Real) : Real;
begin
        UnidEst := trim(UnidEst);
        UnidVnd := trim(UnidVnd);
        if UpperCase(UnidEst) = 'KG' then begin
                if  UpperCase(UnidVnd) = 'KG' then begin
                        result := ValorEst;
                end;

                if  UpperCase(UnidVnd) = 'GR' then begin
                        result := ValorEst/1000;
                end;

                if  UpperCase(UnidVnd) = 'MG' then begin
                        result := (ValorEst/1000)/1000;
                end;
        end;

        if UpperCase(UnidEst) = 'GR' then begin
                if  UpperCase(UnidVnd) = 'KG' then begin
                        result := ValorEst*1000;
                end;

                if  UpperCase(UnidVnd) = 'GR' then begin
                        result := ValorEst;
                end;

                if  UpperCase(UnidVnd) = 'MG' then begin
                        result := (ValorEst/1000);
                end;
        end;

        if UpperCase(UnidEst) = 'MG' then begin
                if  UpperCase(UnidVnd) = 'KG' then begin
                        result := ValorEst*1000*1000;
                end;

                if  UpperCase(UnidVnd) = 'GR' then begin
                        result := ValorEst*1000;
                end;

                if  UpperCase(UnidVnd) = 'MG' then begin
                        result := ValorEst;
                end;
        end;

        if UpperCase(UnidEst) = 'LT' then begin
                if  UpperCase(UnidVnd) = 'LT' then begin
                        result := ValorEst;
                end;

                if  UpperCase(UnidVnd) = 'ML' then begin
                        result := (ValorEst/1000);
                end;
        end;

        if UpperCase(UnidEst) = 'ML' then begin
                if  UpperCase(UnidVnd) = 'LT' then begin
                        result := ValorEst*1000;
                end;

                if  UpperCase(UnidVnd) = 'ML' then begin
                        result := ValorEst;
                end;
        end;
end;


function dataDP(data : TDateTime): String;
Var ANO : String;
begin
        ANO := ' do ano de DOIS MIL E DOIS';

        if Year(Data) =1999 then
                ANO := ' do ano de UM MIL NOVECENTOS E NOVENTA E NOVE';

        if Year(Data) =2000 then
                ANO := ' do ano de DOIS MIL';

        if Year(Data) =2001 then
                ANO := '  do ano de DOIS MIL E UM';

        if Year(Data) =2002 then
                ANO := ' do ano de DOIS MIL E DOIS';

        if Year(Data) =2003 then
                ANO := ' do ano de DOIS MIL E TRES';

        if Year(Data) =2004 then
                ANO := ' do ano de DOIS MIL E QUATRO';

        if Year(Data) =2005 then
                ANO := ' do ano de DOIS MIL E CINCO';

        if Year(Data) =2006 then
                ANO := ' do ano de DOIS MIL E SEIS';

        if Year(Data) =2007 then
                ANO := ' do ano de DOIS MIL E SETE';

        if Year(Data) =2008 then
                ANO := ' do ano de DOIS MIL E OITO';

        if Year(Data) =2009 then
                ANO := ' do ano de DOIS MIL E NOVE';

        if Year(Data) =2010 then
                ANO := ' do ano de DOIS MIL E DEZ';

        if Year(Data) =2011 then
                ANO := ' do ano de DOIS MIL E ONZE';

        if Year(Data) =2012 then
                ANO := ' do ano de DOIS MIL E DOZE';

        Result := FormatFloat('00',Day(Data))+' dias de '+MesExtenso(MONTH(Data))+ANO;
end;

function DataCrystal(Data : TdateTime) : String;
begin
        result := 'Date('+formatdatetime('yyyy,mm,dd',Data)+')'
end;


Procedure Posicao(MyAgent : OleVariant;Objeto : Tcontrol; Agente : String);
begin
        MyAgent.moveto(objeto.ClientOrigin.x,objeto.ClientOrigin.y,10)
end;
        
(*
  Muda a resolucao do video
  exemplo :
var
  OldWidth, OldHeight: integer;

procedure TForm1.Button1Click(Sender: TObject);
begin
  OldWidth := GetSystemMetrics(SM_CXSCREEN);
  OldHeight := GetSystemMetrics(SM_CYSCREEN);
  SetScreenResolution(800, 600);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  SetScreenResolution(OldWidth, OldHeight);
end;


*)
function SetScreenResolution(Width, Height: integer): Longint;
var
  DeviceMode: TDeviceMode;
begin
  with DeviceMode do begin
    dmSize := SizeOf(TDeviceMode);
    dmPelsWidth := Width;
    dmPelsHeight := Height;
    dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
  end;
  Result := ChangeDisplaySettings(DeviceMode, CDS_UPDATEREGISTRY);
end;



(*
Pass in the LPT port number you want to check & get the following back: 
01h - Timeout
08h - I/O Error 
10h - Printer selected 
20h - Out of paper 
40h - Printer acknowledgement 
80h - Printer not busy (0 if busy)
*)
function TestPrinterStatus(LPTPort: word): byte;
var
  Status: byte;
  CheckLPT: word; 
begin 
  Status := 0; 
  if (LPTPort >= 1) and (LPTPort <= 3) then
    begin 
      CheckLPT := LPTPort -1; 
      asm 
        mov dx, CheckLPT; 
        mov al, 0;
        mov ah, 2; 
        int 17h;
        mov &Status, ah; 
      end; 
    end; 
  Result := Status; 
end; 

Function StringFloat(Texto: String) : Real;
var
   N : Integer;
   Resultado : String;
begin
Resultado := '';
For N := 1 to Length(Texto) do begin
    if Copy(Texto,N,1) <> '.' then
       Resultado := Resultado + Copy(Texto,N,1);
end;
Result := StrToFloat(Trim(Resultado));
end;


Function aScan( Texto : String; conj : array of string) :Integer;
Var i : Integer;
begin

        for i := 0 to High(conj) do begin
                if trim(conj[i]) = texto then begin
                        result := i;
                        exit;
                end;
        end;
        result := -1;
end;

Procedure CallDllForm(DllName,FName, Ul: PChar;  frm: Tform; ModalSN : Integer; captionform: String);
type
        tformproc = procedure (ParentApplication : TApplication; ParentForm : TForm; UL: string; ModalSN : Integer); Stdcall;
Var
        DllHandle : THandle;
        ProcAddr : FarProc;
        formulario : tformproc;
        hform : Integer;
begin
        hForm := FindWindow(nil,Pchar(captionform));
        if hForm <= 0 then begin
                DllHandle := LoadLibrary(Pchar(DllName));
                if DllHandle > 0 then begin
                        ProcAddr := GetProcAddress(DllHandle, Pchar(FName));
                        if ProcAddr <> nil then begin
                                formulario := ProcAddr;
                                formulario(Application,frm, Ul, modalsn);
                        end else begin
                                Mens('Função '+Fname+' não existente no modulo '+  DllName);
                        end;
                end else begin
                        mens('Módulo '+ DllName+' não existente...'); 
                end;
        end else begin
                ShowWindow(hform,sw_restore);
                windows.SetForegroundWindow(hForm);
        end;

End;


procedure TraduzErroBanco(mens :String; tabela : String);
Var
        Mensagem : String;
begin
        // Verificar a necessidade de ao inves de '_' usar #39
        mensagem := '';
        if pos('DELETE statement conflicted with COLUMN REFERENCE constraint',mens) > 0 then begin
                Mens := copy(mens,pos(', table ',Mens)+9,200);
                Mens := Copy(Mens,1,pos('_',Mens)-1);
                Mensagem := 'Não foi possivel apagar '+Tabela+#10+#13+ ' pois existe lançamento na tabela '+Mens;
                MensAtencao(Mensagem);
                Exit;
        end else if pos('DELETE statement conflicted with the REFERENCE constraint',mens) > 0 then begin
                Mens := copy(mens,pos(', table ',Mens)+13,200);
                Mens := Copy(Mens,1,pos('_',Mens)-1);
                Mensagem := 'Não foi possivel apagar '+Tabela+#10+#13+ ' pois existe lançamento na tabela '+Mens;
                MensAtencao(Mensagem);
                Exit;
        end else if pos('UPDATE statement conflicted with COLUMN REFERENCE constraint',mens) > 0 then begin
                Mens := copy(mens,pos(', table ',Mens)+9,200);
                Mens := Copy(Mens,1,pos('_',Mens)-1);
                Mensagem := 'Não foi possivel regravar '+Tabela+#10+#13+ ' pois código não existe na tabela '+Mens;
                MensAtencao(Mensagem);
                Exit;
        end else begin
                MensAtencao(Mens);
                Exit;
        end;
end;

// Cria ou abre nova instância de objeto
function GetOrCreateObject(Aplicacao: String; Visible: Boolean): OleVariant;
var
  Objeto: OleVariant;
begin
   try
      try
         Objeto := GetActiveOleObject(Aplicacao);
      except
         Objeto := CreateOleObject(Aplicacao);
      end;
      Objeto.Visible := Visible;
      Result := Objeto;
   except
      Result := null;
   end;

end;


procedure SetDefaultPrinter(PrinterName: String) ;
var
    j: Integer;
    Device : PChar;
    Driver : Pchar;
    Port : Pchar;
    HdeviceMode: Thandle;
    aPrinter : TPrinter;
begin
   Printer.PrinterIndex := -1;
   getmem(Device, 255) ;
   getmem(Driver, 255) ;
   getmem(Port, 255) ;
   aPrinter := TPrinter.create;
   for j := 0 to Printer.printers.Count-1 do
   begin
     if Printer.printers[j] = PrinterName then
     begin
       aprinter.printerindex := j;
       aPrinter.getprinter
(device, driver, port, HdeviceMode) ;
       StrCat(Device, ',') ;
       StrCat(Device, Driver ) ;
       StrCat(Device, Port ) ;
       WriteProfileString('windows', 'device', Device) ;
       StrCopy( Device, 'windows' ) ;
       SendMessage(HWND_BROADCAST, WM_WININICHANGE,
0, Longint(@Device)) ;
    end;
   end;
   Freemem(Device, 255) ;
   Freemem(Driver, 255) ;
   Freemem(Port, 255) ;
   aPrinter.Free;
end;




(*procedure OutputWinPrn(FileName: String); // Imprime para USB
var
FIn,
FOut : File;
Buffer : array [0..1024] of Byte;
RealByte : integer;

ADevice,
ADriver,
APort : string;
PrinterHandle: THandle;
DocInfo1: TDocInfo1;
DS : string;
OutByte: DWORD;

begin
try
AssignFile(FIn,FileName);
Reset(FIn,1);
except
MsgOk('Impressora nao pode ser aberta !','Alerta');
exit;
end;
setlength(ADevice,80);
setlength(ADriver,80);
SetLength(APort,80);
Printer.GetPrinter(PChar(ADevice),
PChar(ADriver),
PChar(APort),PrinterHandle);
if not OpenPrinter(PChar(ADevice),PrinterHandle, nil) then
begin
StringMsgOk('Erro ' + IntToStr(GetLastError),caption);
Exit;
end;
with DocInfo1 do
begin
pDocName := PChar(FileName);
pOutputFile := nil;
pDataType := 'RAW';
end;
screen.Cursor:=crHourglass;
StartDocPrinter(PrinterHandle, 1, @DocInfo1);
try
try
if length(InitWin)>0 then

WritePrinter(PrinterHandle,PChar(InitWin),length(InitWin),OutByte);
while not eof(Fin) do
begin
Blockread(Fin,Buffer[0],sizeof(Buffer),RealByte);
setlength(DS,RealByte);
move(buffer[0],DS[1],RealByte);
if not WritePrinter(PrinterHandle,PChar(DS),RealByte,OutByte) then
begin
exit;
end;
end;
if length(ExitWin)>0 then
WritePrinter(PrinterHandle,PChar(ExitWin),length(ExitWin),OutByte);
except
MsgOk('Não pode imprimir na impressora ','Alerta');
end;
finally
EndDocPrinter(PrinterHandle);
ClosePrinter(PrinterHandle);
CloseFile(FIn);
screen.Cursor:=crDefault;
end;
end;
*)



function HexToDec(Str: string): Integer;
var
  i, M: Integer;
begin
  Result:=0;
  M:=1;
  Str:=AnsiUpperCase(Str);
  for i:=Length(Str) downto 1 do
  begin
    case Str[i] of
      '1'..'9': Result:=Result+(Ord(Str[i])-Ord('0'))*M;
      'A'..'F': Result:=Result+(Ord(Str[i])-Ord('A')+10)*M;
    end;
    M:=M shl 4;
  end;
end;


Function SerialHexToSerialDec(SerialHex :String) : String;
var
        p1, p2 : Integer;
begin
        p1 := hextodec( copy(SerialHex,1,2) );
        p2 := hextodec(copy(SerialHex,3,10));
        Result := Formatfloat('000',p1)+FormatFloat('00000000',p2);
end;

Function SerialDecToSerialHex(SerialDec :String) : String;
begin
        Result := Format('%x',[strtoint(copy(SerialDec,1,3))]) +
        Format('%x',[strtoint(copy(SerialDec,4,8))]);
End;


function ImeiOk(Imei : String) : Boolean;
var
         i, ii : Integer;
        n, S : String;
        soma : Integer;
        Digito : String;
        OK : Boolean;

begin
        S := trim(imei);
        if length(imei) <> 15 then begin
                result := false;
                exit;
        end;

        Ok := true;
        for i := 1 to 15 do begin
                if not ((s[i] >= '0') and (s[i] <= '9')) then begin
                        Ok := false;
                        break;
                end;
        end;

        if not ok then begin
                result := false;
                exit;
        end;


        S := copy(imei,1,14);
        Soma := 0;
        for i := 1 to 14 do begin
                if (i mod 2) <> 0 then
                        n := FormatFloat('00',strtoint(s[i]))
                else
                        n := FormatFloat('00',strtoint(s[i])*2);
                Soma := Soma+strtoint(copy(n,1,1)) + strtoint(copy(n,2,1));
        end;
        Digito := Inttostr( ((10- (soma mod 10) ) mod 10) );
        if Digito <> copy(imei,15,1) then
                result := false
        else
                result := true;
end;



function ESN8OK(esn : String) : Boolean;
var
         i : Integer;
         ok : boolean;
         S : String;
begin
        S := trim(esn);
        if length(esn) <> 8 then begin
                result := false;
                exit;
        end;

        Ok := true;
        for i := 1 to 8 do begin
                if (not ((s[i] >= '0') and (s[i] <= '9'))) and
                        (not ((s[i] >= 'A') and (s[i] <= 'F'))) then begin
                        Ok := false;
                        break;
                end;
        end;

        Result := OK;

end;

function ESN11OK(esn : String) : Boolean;
var
         i : Integer;
         ok : boolean;
         S : String;
begin
        S := trim(esn);
        if length(esn) <> 11 then begin
                result := false;
                exit;
        end;

        Ok := true;
        for i := 1 to 11 do begin
                if (not ((s[i] >= '0') and (s[i] <= '9')))  then begin
                        Ok := false;
                        break;
                end;
        end;
        Result := OK;
end;



procedure PassaUsuario2CentralLCK(usuario : String);
var
        h : HWND;
        cs : Tclientsocket;
begin
        try
                cs := Tclientsocket.create(nil);
                h := findwindow(nil,'Central Lucro Sis');
                if h > 0 then begin
                      cs.ClientType := ctBlocking;
                      cs.Address := localIP;
                      cs.Port := 1234;
                      cs.open;
                      cs.Socket.SendText('USR'+usuario);
                      cs.Close;
                end;
        finally
                FreeAndNil(cs);
        end;


end;


Function Pascoa(Ano : Integer) : TDateTime;
Var
        NumeroDourado : array[1..19] of TDateTime;
        Dia : integer;
        DataPascoa : TDateTime;
begin
        Dia := (Ano - ((Ano div 19) * 19) ) +1;

        NumeroDourado[01] := strtodate('14/04/'+inttostr(ano));
        NumeroDourado[02] := strtodate('03/04/'+inttostr(ano));
        NumeroDourado[03] := strtodate('03/03/'+inttostr(ano));
        NumeroDourado[04] := strtodate('11/04/'+inttostr(ano));
        NumeroDourado[05] := strtodate('31/03/'+inttostr(ano));
        NumeroDourado[06] := strtodate('18/04/'+inttostr(ano));
        NumeroDourado[07] := strtodate('08/04/'+inttostr(ano));
        NumeroDourado[08] := strtodate('28/03/'+inttostr(ano));
        NumeroDourado[09] := strtodate('16/04/'+inttostr(ano));
        NumeroDourado[10] := strtodate('05/04/'+inttostr(ano));
        NumeroDourado[11] := strtodate('25/03/'+inttostr(ano));
        NumeroDourado[12] := strtodate('13/04/'+inttostr(ano));
        NumeroDourado[13] := strtodate('02/04/'+inttostr(ano));
        NumeroDourado[14] := strtodate('22/03/'+inttostr(ano));
        NumeroDourado[15] := strtodate('10/04/'+inttostr(ano));
        NumeroDourado[16] := strtodate('30/03/'+inttostr(ano));
        NumeroDourado[17] := strtodate('17/04/'+inttostr(ano));
        NumeroDourado[18] := strtodate('07/04/'+inttostr(ano));
        NumeroDourado[19] := strtodate('27/03/'+inttostr(ano));

        DataPascoa := NumeroDourado[Dia];

        if DayOfWeek(DataPascoa) = 1 then // se caiu no domingo soma mais um que é sempre na proxima semana.
          DataPascoa := DataPascoa +1;
        while DayOfWeek(DataPascoa) <> 1 do
                DataPascoa := DataPascoa+1;

        Result := DataPascoa;
end;


Function QuartaFeiraDeCinzas(Ano : Integer) : TDateTime;
begin
        result := Pascoa(Ano) - 46;
end;

Function Carnaval(Ano : Integer) : TDateTime;
begin
        result := QuartaFeiraDeCinzas(Ano) - 1;
end;

Function CorpusCristis(Ano : Integer) : TDateTime;
begin
        result := Pascoa(Ano) + 60;
end;

Function Paixao(Ano : Integer) : TDateTime;
begin
        result := Pascoa(Ano) - 2;
end;


function getwindir:string;
var
  Buf: array[0..255] of Char;
  BufLen: DWord;
begin
  BufLen := SizeOf(Buf);
  getwindowsdirectory(buf,buflen);
  result:=buf;
end;

Function PadrX(s: String; t: Integer; carac: string ) : String;
begin
        Result := copy(s+replicate(carac,t),1,t);
end;


function QuebraLinhaExtenso(TextoExtenso : String;  tamanhoLinha : Integer; MinimoLinhas : Integer; IntervaloLinhas : Integer) : String;
var
        ExtensoQuebrado : string;
        i, Linhas : Integer;
begin
        if tamanholinha < 12 then begin
                mens('Não é possivel utilizar essa função para este tamanho de linha ...');
                result := '';
                exit;
        end;
        Linhas := 0;
        while trim(TextoExtenso) <> '' do begin
                  if Copy(TextoExtenso,TamanhoLinha,1) = ' ' then begin
                         if trim(extensoQuebrado) <> '' then
                                extensoQuebrado := extensoQuebrado + replicate(#13,IntervaloLinhas) ;
                         ExtensoQuebrado := ExtensoQuebrado + padrX(trim(Copy(TextoExtenso,1,TamanhoLinha)),TamanhoLinha,'*') ;
                         Linhas := Linhas +1;
                         TextoExtenso := copy(TextoExtenso,TamanhoLinha,350)+space(350);
                  end else begin
                          if pos(space(1), trim(TextoExtenso)) >0 then begin
                                    for i := TamanhoLinha downto 0 do begin
                                        if (TextoExtenso[i] = ' ') then begin
                                           TextoExtenso := trim(TextoExtenso);
                                           if trim(extensoQuebrado) <> '' then
                                                  extensoQuebrado := extensoQuebrado + replicate(#13,IntervaloLinhas);
                                           ExtensoQuebrado := ExtensoQuebrado + padrX(trim(Copy(TextoExtenso,1,i-1)),TamanhoLinha,'*');
                                           Linhas := Linhas +1;
                                           break;
                                        end;
                                    end;
                                    TextoExtenso := copy(TextoExtenso,i, 350);
                          end else begin
                                     if trim(extensoQuebrado) <> '' then
                                            ExtensoQuebrado := ExtensoQuebrado + replicate(#13,IntervaloLinhas);
                                     ExtensoQuebrado := ExtensoQuebrado + padrX(Trim(TextoExtenso),TamanhoLinha,'*');
                                     TextoExtenso := '';
                                     Linhas := Linhas +1;
                          end;
                  end;
        end;

        if linhas < MinimoLinhas then begin
                while linhas < MinimoLinhas do begin
                     if trim(extensoQuebrado) <> '' then
                            extensoQuebrado := extensoQuebrado + replicate(#13,IntervaloLinhas);
                     ExtensoQuebrado := ExtensoQuebrado + replicate('*', TamanhoLinha);
                     Linhas := Linhas +1;
                end;
        end;
        result := ExtensoQuebrado;
end;

function contem(palavra : string; texto : string) : boolean;
var
        v : string;
        x : integer;
begin
        if pos(palavra, texto) = 0 then begin
                result := false;
                exit;
        end;

        v := '';
        for x := 1 to length(texto) do begin
                if texto[x] = ',' then begin
                        if v = palavra then begin
                              result := true;
                              exit;
                        end else begin
                                v := '';
                        end;
                        continue;
                end;
                v := v + texto[x];
        end;
        if v = palavra then begin
                result := true;
                exit;
        end else begin
                result := false;
                exit;
        end;
end;


function EncriptaSimples(Texto : string; encripta : boolean) : String;
const
          uncode = '0123456789ABCDEF';
Const      code  = '837@5RAJHXMQZL19';
var
    N, i  :integer;
    newmac : string;
    s : string;
begin
    newmac := '';
    for i := 1 to length(Texto) do begin
            n := (i);
            if encripta then begin
                  s :=  copy(code,pos(Texto[i],uncode),1);
                  newmac := newmac + chr(ord(s[1])+n) ;
            end else begin
                  s :=  chr(ord(Texto[i])-n);
                  newmac := newmac +  copy(uncode,pos(s,code),1);
            end;
    end;
    result := newmac
end;

function EncriptaSimples2(Texto : string; encripta : boolean) : String;
const
          uncode = '0123456789ABCDEF';
Const      code  = 'ABCDEFGHIJKLMNOP';
var
    i  :integer;
    newmac : string;
begin
    newmac := '';
    for i := 1 to length(Texto) do begin
            if encripta then begin
                  newmac := newmac + copy(code,pos(Texto[i],uncode),1);
            end else begin
                  newmac := newmac +  copy(uncode,pos(Texto[i],code),1);
            end;
    end;
    result := newmac
end;

function CodificaPrecoCusto(valor : real; palavracodigo : string) : String;
const
    codigo = '0123456789';
var
    s, novo, valorstr : string;
    i : integer;
begin
    if trim(palavracodigo) = '' then
        palavracodigo := 'ABCDEFGHIJ';

    valorstr := stringreplace(stringreplace(trim(formatfloat('#########0.00',valor)),'.','',[rfReplaceAll]),',','',[rfReplaceAll]);
    for i := 1 to length(valorstr) do begin
            s :=  copy(palavracodigo,pos(valorstr[i],codigo),1);
            novo := novo + s;
    end;
    result := novo;
end;



Function NomeDoArquivoPortariaCat52(MarcaImpressora : string; ModeloImpressora :  String; CincoUltimoDigitosNroSerie : String) : String;
var
  Arquivo, Data : String;
  Dia, Mes, Ano : Integer;
begin
  Dia := Day(date);
  Mes := Month(date);
  Ano := strtoint(copy(FormatDateTime('yyyy', Year(date)) ,3,2));
  Data := '';

  case Dia of
      10: Data := Data + 'A';
      11: Data := Data + 'B';
      12: Data := Data + 'C';
      13: Data := Data + 'D';
      14: Data := Data + 'E';
      15: Data := Data + 'F';
      16: Data := Data + 'G';
      17: Data := Data + 'H';
      18: Data := Data + 'I';
      19: Data := Data + 'J';
      20: Data := Data + 'K';
      21: Data := Data + 'L';
      22: Data := Data + 'M';
      23: Data := Data + 'N';
      24: Data := Data + 'O';
      25: Data := Data + 'P';
      26: Data := Data + 'Q';
      27: Data := Data + 'R';
      28: Data := Data + 'S';
      29: Data := Data + 'T';
      30: Data := Data + 'U';
      31: Data := Data + 'V';
  else
      Data := Data + inttostr(dia);
  end;

  case Mes of
      10: Data := Data + 'A';
      11: Data := Data + 'B';
      12: Data := Data + 'C';
  else
      Data := Data + inttostr(mes);
  end;

  case Ano of
      10: Data := Data + 'A';
      11: Data := Data + 'B';
      12: Data := Data + 'C';
      13: Data := Data + 'D';
      14: Data := Data + 'E';
      15: Data := Data + 'F';
      16: Data := Data + 'G';
  else
      data := data + inttostr(ano);
  end;

  Arquivo := copy(MarcaImpressora,1,2) + copy(modeloImpressora,1,1) + Copy(CincoUltimoDigitosNroSerie,1,5)+'.'+ Data +'.rfd';
  result := Arquivo;
end;


Function MinutosParaHora(Minutos : Real) : String;
begin
    result :=
    FormatFloat('00',int(minutos/60))+':'+
    formatFloat('00',minutos - (int(minutos/60) * 60));
end;


Function HoraParaMinutos(Hora : String) : Integer;
begin
    result := (strtoint(copy(hora,1,2)) * 60) + strtoint(copy(hora,4,2));
end;


Function SomenteNumeros(s : String) : Real;
Var
  i : integer;
  r : string;
begin
      s := trim(s);

      if s = '' then begin
          result := 0;
          exit;
      end;


      if length(trim(s)) > 15 then begin
            mens('Numero nao pode ter mais que 15 caracteres - SomenteNumeros :'+s);
            result := 0;
            exit;
      end;

      r := '';
      for i := 0  to length(s) do begin
            if (s[i] >= '0') and (s[i] <= '9') then
                r := r + s[i];
      end;
      if trim(r) = '' then
          result := 0
      else
          result := strtoFloat(r);
end;

procedure espera(sec: integer);
Var
        NumSec : SmallInt;
        StartTime: TDateTime;
begin
        StartTime := now;
        NumSec:= sec;
        repeat
        Application.ProcessMessages;
        until Now > StartTime + NumSec * (1/24/60/60);

end;

{InicioFunção para Leitura Registro Windons}
FUNCTION FUNC_REGEDIT(V_KEY, V_CHAVE, V_VALOR, VS_TP : STRING) : STRING;
VAR
  reg: TRegistry;
BEGIN
   reg         := TRegistry.Create;
   reg.RootKey := HKEY_LOCAL_MACHINE;
   RESULT      := '';
   IF VS_TP = 'L' THEN
    BEGIN
       TRY
         if reg.OpenKey(V_KEY, false) then
           RESULT :=   FUNC_DESCRIPTOGRAFAR(reg.ReadString(V_CHAVE));
       finally
         reg.CloseKey;
         reg.Free;
       END;
    END
   ELSE
   IF VS_TP = 'G' THEN
     BEGIN
       TRY
         if reg.OpenKey(V_KEY, TRUE) then
           reg.WriteString(V_CHAVE,FUNC_CRIPTOGRAFAR(V_VALOR));
       finally
         reg.CloseKey;
         reg.Free;
       END;
     END;
END;

//================================================================================================

{Função que retorna o IP Local}
FUNCTION  FUNC_IP_LOCAL : STRING;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe : PHostEnt;
  pptr : PaPInAddr;
  Buffer : array [0..63] of char;
  I : Integer;
  GInitData : TWSADATA;
begin
  result := '';
  TRY
    WSAStartup($101, GInitData);
    GetHostName(Buffer, SizeOf(Buffer));
    phe :=GetHostByName(buffer);
    if phe = nil then Exit;
      pptr := PaPInAddr(Phe^.h_addr_list);
      I := 0;
      while pptr^[I] <> nil do begin
        Result  :=StrPas(inet_ntoa(pptr^[I]^));
        Result  :=StrPas(inet_ntoa(pptr^[I]^));
        Inc(I);
      end;
      WSACleanup;
  EXCEPT
    result := '';
  END;
END;

//================================================================================================

{Função para Criptografar/descriptografar}
FUNCTION FUNC_DESCRIPTOGRAFAR(S : String) : String;
type
  PWORD = ^WORD;
var
  Buffer : String;
  PW : String[255];
  P : PWORD;
  I : Integer;
  V : Integer;
begin
  PW := ' ';
  P := PWORD(@PW[0]);
  I := 1;
while I <= Length(S) do begin
  Buffer := Copy(S, I, 5);
  I := I + 5;
  V := StrToInt(Buffer) - 34567;
  P^ := V;
  Inc(P);
end;
  Result := PW;
end;

//================================================================================================
{Função para Criptografar/descriptografar}
function FUNC_CRIPTOGRAFAR(S : String) : String;
type
  PWORD = ^WORD;
var
  Len : Integer;
  I : Integer;
  V : DWORD;
  P : PChar;
  Buffer : String[255];
begin

  Buffer := S;
  Len := Length(Buffer) + 1;
if (Len mod 2) <> 0 then
  Inc(Len);

if Len < 10 then
  Len := 10;

  I := Length(Buffer);
if I = 0 then
  Buffer := IntToStr(GetTickCount)
else
while Length(Buffer) < 10 do
  Buffer := Buffer + Buffer;
  SetLength(Buffer, I);

  Result := '';
  P := PChar(@Buffer[0]);
for I := 1 to Len div 2 do begin
  V := 34567 + PWORD(P)^;
  P := P + 2;
  Result := Result + Format('%5.5d', [V]);
end;
end;

//================================================================================================

{Function que cria arquivo TXT}
FUNCTION FUNC_ARQUIVO_TXT(V_TEXTO, V_CAMINHO : STRING; V_SUBSTITUE : BOOLEAN) : BOOLEAN;
var
  VMemory      : TMemoryStatus;
  V_ARQ_TXT     : TextFile;
  V_ARQ_TXTName, V_LINHA : string;
BEGIN
     RESULT := TRUE;

      VMemory.dwLength := SizeOf(TMemoryStatus);
      GlobalMemoryStatus(VMemory);
      V_ARQ_TXTName     := V_CAMINHO;
      try
        IF COPY(V_CAMINHO,1,2) <> 'LP' THEN
          BEGIN
            AssignFile(V_ARQ_TXT,V_ARQ_TXTName);
            if FileExists(V_ARQ_TXTName) then
              IF V_SUBSTITUE THEN
                BEGIN
                  DeleteFile(pchar(V_CAMINHO));
                  Rewrite(V_ARQ_TXT);
                END
              ELSE
                Append(V_ARQ_TXT)
            ELSE
              Rewrite(V_ARQ_TXT);
              Writeln(V_ARQ_TXT,V_TEXTO);
              CloseFile(V_ARQ_TXT);
          END;
    except
      RESULT := FALSE;
    end;
      try
        IF COPY(V_CAMINHO,1,2) = 'LP' THEN
          BEGIN
            AssignFile(V_ARQ_TXT,V_CAMINHO);
            Rewrite(V_ARQ_TXT);
            Writeln(V_ARQ_TXT,V_TEXTO);
            CloseFile(V_ARQ_TXT);
          END;

    except
      RESULT := FALSE;
    end;

end;

//================================================================================================

{Função que se esta ou não conectado na NET}
FUNCTION FUNC_VALIDA_CONEXAO_INTERNET : boolean;
var
  flags: dword;
begin
  Result := InternetGetConnectedState(@flags, 0);
  if Result then
  begin
    if ((flags and INTERNET_CONNECTION_MODEM)     = INTERNET_CONNECTION_MODEM)     then
      result := true
    else
    if ((flags and INTERNET_CONNECTION_LAN)       = INTERNET_CONNECTION_LAN)       then
      result := true
    else
    if ((flags and INTERNET_CONNECTION_PROXY)     = INTERNET_CONNECTION_PROXY)     then
      result := true
    else
    if ((flags and INTERNET_CONNECTION_MODEM_BUSY)=INTERNET_CONNECTION_MODEM_BUSY) then
      result := true
    else
      result := false;
  end;
end;

//================================================================================================

{Função que enviar e-mail sem usar WIN}
FUNCTION FUNC_ENVIAR_EMAIL(V_DEST,
                           V_DEST_COPIA,
                           V_DEST_COPIA_OCULTA,
                           V_ASSUNTO,
                           V_MSG,
                           V_DS_ORIGEM,
                           V_WEB_SMTP,
                           V_WEB_EMAIL_SUPORTE,
                           V_WEB_EMAIL_SUPORTE_SENHA : STRING;
                           V_PRIORIDADE,
                           V_WEB_PORTA : INTEGER;
                           V_ANEXO_1,
                           V_ANEXO_2,
                           V_ANEXO_3,
                           V_ANEXO_4,
                           V_ANEXO_5 : STRING ): Boolean;

VAR
  IdMessage_PRINCIPAL     : TIdMessage;
  IdSMTP_PRINCIPAL        : TIdSMTP;
  IdAntiFreeze_PRINCIPAL  : TIdAntiFreeze;
BEGIN

  IdMessage_PRINCIPAL     := TIdMessage.Create(nil);
  IdSMTP_PRINCIPAL        := TIdSMTP.Create(nil);
  IdAntiFreeze_PRINCIPAL  := TIdAntiFreeze.Create(nil);
  IdSMTP_PRINCIPAL.AuthenticationType := atLogin;

  result := true;

  IF FUNC_VALIDA_CONEXAO_INTERNET THEN
    BEGIN
      TRY

          //Configura dados da Mensagem
          IdMessage_PRINCIPAL.Recipients.EMailAddresses := V_DEST;
          IdMessage_PRINCIPAL.CCList.EMailAddresses     := V_DEST_COPIA;
          IdMessage_PRINCIPAL.BccList.EMailAddresses    := V_DEST_COPIA_OCULTA;
          IdMessage_PRINCIPAL.FROM.Text                 := V_DS_ORIGEM;
          IdMessage_PRINCIPAL.FROM.Name                 := V_DS_ORIGEM;
          IdMessage_PRINCIPAL.Subject     := V_ASSUNTO;
          IdMessage_PRINCIPAL.body.Append(V_MSG);
          IF TRIM(V_ANEXO_1) <> '' THEN
            TIdAttachment.create(IdMessage_PRINCIPAL.MessageParts, TFileName(V_ANEXO_1));
          IF TRIM(V_ANEXO_2) <> '' THEN
            TIdAttachment.create(IdMessage_PRINCIPAL.MessageParts, TFileName(V_ANEXO_2));
          IF TRIM(V_ANEXO_3) <> '' THEN
            TIdAttachment.create(IdMessage_PRINCIPAL.MessageParts, TFileName(V_ANEXO_3));
          IF TRIM(V_ANEXO_4) <> '' THEN
            TIdAttachment.create(IdMessage_PRINCIPAL.MessageParts, TFileName(V_ANEXO_4));
          IF TRIM(V_ANEXO_5) <> '' THEN
            TIdAttachment.create(IdMessage_PRINCIPAL.MessageParts, TFileName(V_ANEXO_5));

          //Configura dados do Servidor
          IdSMTP_PRINCIPAL.Host                := V_WEB_SMTP;
          IdSMTP_PRINCIPAL.Port                := V_WEB_PORTA;
          IdSMTP_PRINCIPAL.Username            := V_WEB_EMAIL_SUPORTE;
          IdSMTP_PRINCIPAL.Password            := V_WEB_EMAIL_SUPORTE_SENHA;

          //Trata a Prioridade da mensagem
          Case V_PRIORIDADE Of
            0 : IdMessage_PRINCIPAL.Priority := mpLow;
            1 : IdMessage_PRINCIPAL.Priority := mpNormal;
            2 : IdMessage_PRINCIPAL.Priority := mpHigh;
          End;

          Try
            IdSMTP_PRINCIPAL.Connect;
            IdSMTP_PRINCIPAL.Send(IdMessage_PRINCIPAL);
          Finally
            IdSMTP_PRINCIPAL.Disconnect;
          End;
      EXCEPT
        Result := FALSE;
      END;
    END
  ELSE
    result := false;

  IdMessage_PRINCIPAL.Free;
  IdSMTP_PRINCIPAL.Free;
  IdAntiFreeze_PRINCIPAL.Free;

END;

//================================================================================================

{Procedure que abre um SITE}
PROCEDURE PROC_WEB(V_ENDERECO : STRING);
const
  csOLEObjName = 'InternetExplorer.Application';
var
  IE : Variant;WinHanlde : HWnd;
begin
  IF TRIM(V_ENDERECO) <> '' THEN
    begin
    if( VarIsEmpty( IE ) )then
      begin
        IE := CreateOleObject( csOLEObjName );
        IE.Visible := true;
        IE.Navigate( V_ENDERECO );
      end
     else
      begin
        WinHanlde := FindWIndow( 'IEFrame', nil );
        if( 0 <> WinHanlde )then
          begin
            IE.Navigate( V_ENDERECO );
            SetForegroundWindow( WinHanlde );
          end
        else
        begin
          Showmessage('Erro ao abrir URL informada');
        end;
      end;
  end;
END;

//================================================================================================

{Função que retorna a versão do sistema}
function FUNC_VERSAO_SISTEMA: string;
var
  Dummy: THandle;
  BufferSize, Len: Integer;
  Buffer: PChar;
  LoCharSet, HiCharSet: Word;
  Translate, Return: Pointer;
  StrFileInfo: string;
begin
  BufferSize := GetFileVersionInfoSize(PChar(Application.ExeName), Dummy);
  if BufferSize <> 0 then
    begin
      GetMem(Buffer, Succ(BufferSize));
    try
      if GetFileVersionInfo(PChar(Application.ExeName), 0, BufferSize, Buffer) then
        if VerQueryValue(Buffer, '\VarFileInfo\Translation', Translate, UINT(Len)) then
          begin
            LoCharSet := LoWord(Longint(Translate^));
            HiCharSet := HiWord(Longint(Translate^));
            StrFileInfo := Format('\StringFileInfo\0%x0%x\%s', [LoCharSet, HiCharSet, 'FileVersion']);
              if VerQueryValue(Buffer, PChar(StrFileInfo), Return, UINT(Len)) then
                    Result:= strpas(PChar(Return));
          end;
    except
      Result := 'Erro';
    end;
  end;
end;

//================================================================================================


{Fecha aplicativo se estiver aberto}
FUNCTION FUNC_EXE(VS_ARQ, VS_FL_ACAO : string) : Boolean;
const
  PROCESS_TERMINATE = $0001;
var
  {Handle para um conjunto de informações sobre os processos da memória}
  hdSnapshot : THandle;
  {Informações sobre um determinado processo em memória}
  fProcessEntry32 : TProcessEntry32;
  {Controle de looping}
  bContinueLoop : BOOL;
begin
RESULT := TRUE;
TRY
  IF VS_FL_ACAO = 'F' THEN
    BEGIN
        {Cria um Handle para as informações dos processos em memória}
        hdSnapshot:=CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        {Define o tamanho da estrutura tProcessEntry32}
        fProcessEntry32.dwSize:=SizeOf(fProcessEntry32);
        {Captura o primeiro processo na fila da memória}
        bContinueLoop:=Process32First(hdSnapshot, fProcessEntry32);
        {Enquanto não se acabarem os processos em memória}
        while not(Integer(bContinueLoop) = 0) do
          begin
            {Se o processo atual contiver o nome definido no parametro ExeFileName}
              if (UpperCase(ExtractFileName(fProcessEntry32.szExeFile)) = UpperCase(VS_ARQ)) OR
                 (UpperCase(fProcessEntry32.szExeFile) = UpperCase(VS_ARQ))
              then
                begin
                  {Então este processo será finalizado}
                  TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), fProcessEntry32.th32ProcessID), 0);
                end;
            {Captura o próximo processo em memória}
            bContinueLoop:=Process32Next(hdSnapshot, fProcessEntry32);
          end;
        {Fecha o Handle da memória}
        CloseHandle(hdSnapshot);
    END
ELSE
  IF VS_FL_ACAO = 'A' THEN
    BEGIN
      if ShellExecute(Application.Handle, nil, PChar(VS_ARQ), nil, nil, SW_SHOW) = 2 then
       RESULT := false;
    END;
except
RESULT := FALSE;
END;

end;

//================================================================================================

{Função que retorna a data por extenso em um datatime V_TP=1 "Domingo 29 de janeiro de 2006"  V_TP=2 99-JAN-9999}
function FUNC_DATA_EXTENSO(V_DATATIME: TDateTime;V_TP : INTEGER): String;
{Retorna uma data por extenso}
var
  V_NODIA         : Integer;
  V_DIADASEMANA   : array [1..7] of String;
  V_MESES         : array [1..12] of String;
  V_DIA, V_MES,V_ANO : Word;
  V_ANO_TXT : STRING;
begin

if V_TP = 1 THEN
  BEGIN
      { Dias da Semana }
        V_DIADASEMANA [1]:= 'Domingo';
        V_DIADASEMANA [2]:= 'Segunda-feira';
        V_DIADASEMANA [3]:= 'Terça-feira';
        V_DIADASEMANA [4]:= 'Quarta-feira';
        V_DIADASEMANA [5]:= 'Quinta-feira';
        V_DIADASEMANA [6]:= 'Sexta-feira';
        V_DIADASEMANA [7]:= 'Sábado';
      { V_MESES do ano }
        V_MESES [1] := 'Janeiro';
        V_MESES [2] := 'Fevereiro';
        V_MESES [3] := 'Março';
        V_MESES [4] := 'Abril';
        V_MESES [5] := 'Maio';
        V_MESES [6] := 'Junho';
        V_MESES [7] := 'Julho';
        V_MESES [8] := 'Agosto';
        V_MESES [9] := 'Setembro';
        V_MESES [10]:= 'Outubro';
        V_MESES [11]:= 'Novembro';
        V_MESES [12]:= 'Dezembro';
        DecodeDate (V_DATATIME, V_ANO, V_MES, V_DIA);
        V_NODIA := DayOfWeek (V_DATATIME);
        Result := V_DIADASEMANA[V_NODIA] + ', ' + IntToStr(V_DIA) + ' de ' + V_MESES[V_MES]+ ' de ' + IntToStr(V_ANO);

        //Segunda, 20, de Janeiro de  2009
  END
ELSE
  IF V_TP = 2 THEN
    BEGIN
        V_MESES [1] := 'JAN';
        V_MESES [2] := 'FEB';
        V_MESES [3] := 'MAR';
        V_MESES [4] := 'APR';
        V_MESES [5] := 'MAY';
        V_MESES [6] := 'JUN';
        V_MESES [7] := 'JUL';
        V_MESES [8] := 'AUG';
        V_MESES [9] := 'SEP';
        V_MESES [10]:= 'OCT';
        V_MESES [11]:= 'NOV';
        V_MESES [12]:= 'DEC';
        DecodeDate (V_DATATIME, V_ANO, V_MES, V_DIA);

      V_ANO_TXT := IntToStr(V_ANO);
      if (V_DIA = 1)    and
         (V_MES = 1)    and
         (V_ANO = 2001) then
      begin
        V_ANO_TXT := '0001';
      end;

        RESULT := INTTOSTR(V_DIA) +'-'+ V_MESES[V_MES] +'-'+V_ANO_TXT;
        //1-JAN-2007
    END
ELSE
  IF V_TP = 3 THEN
    BEGIN
        V_MESES [1] := 'JAN';
        V_MESES [2] := 'FEB';
        V_MESES [3] := 'MAR';
        V_MESES [4] := 'APR';
        V_MESES [5] := 'MAY';
        V_MESES [6] := 'JUN';
        V_MESES [7] := 'JUL';
        V_MESES [8] := 'AUG';
        V_MESES [9] := 'SEP';
        V_MESES [10]:= 'OCT';
        V_MESES [11]:= 'NOV';
        V_MESES [12]:= 'DEC';
        DecodeDate (V_DATATIME, V_ANO, V_MES, V_DIA);
        RESULT := INTTOSTR(V_DIA) +'-'+ V_MESES[V_MES] +'-'+INTTOSTR(V_ANO)+ ' '+FormatDateTime('hh:mm:ss',now) ;

        //1-JAN-2007 00:00:00
    END
ELSE
  IF V_TP = 4 THEN
    BEGIN
        DecodeDate (V_DATATIME, V_ANO, V_MES, V_DIA);
        RESULT := FormatFloat('00',V_DIA) +'/'+ FormatFloat('00',V_MES) +'/'+FormatFloat('0000',V_ANO);

        //DD/MM/YYYY
    END
ELSE
  IF V_TP = 5 THEN
    BEGIN
        DecodeDate (V_DATATIME, V_ANO, V_MES, V_DIA);
        RESULT := INTTOSTR(V_DIA) +'/'+INTTOSTR(V_MES) +'/'+INTTOSTR(V_ANO);

        //D/M/Y
    END
ELSE
  IF V_TP = 6 THEN
    BEGIN
        DecodeDate (V_DATATIME, V_ANO, V_MES, V_DIA);
        RESULT := INTTOSTR(V_DIA) +'/'+INTTOSTR(V_MES) +'/'+INTTOSTR(V_ANO)+ ' '+FormatDateTime('hh:mm:ss',now) ;

        //D/M/Y 00:00:00
    END
ELSE
  IF V_TP = 7 THEN
    BEGIN
        DecodeDate (V_DATATIME, V_ANO, V_MES, V_DIA);
        RESULT := FormatFloat('00',V_MES)  +'/'+INTTOSTR(V_ANO);

        //MM/YYYY 00:00:00
    END
ELSE
  IF V_TP = 8 THEN
    BEGIN
        V_MESES [1] := 'JAN';
        V_MESES [2] := 'FEB';
        V_MESES [3] := 'MAR';
        V_MESES [4] := 'APR';
        V_MESES [5] := 'MAY';
        V_MESES [6] := 'JUN';
        V_MESES [7] := 'JUL';
        V_MESES [8] := 'AUG';
        V_MESES [9] := 'SEP';
        V_MESES [10]:= 'OCT';
        V_MESES [11]:= 'NOV';
        V_MESES [12]:= 'DEC';
        DecodeDate (V_DATATIME, V_ANO, V_MES, V_DIA);
        RESULT := ' TO_DATE('+QuotedStr(INTTOSTR(V_DIA) +'-'+ V_MESES[V_MES] +'-'+INTTOSTR(V_ANO)+ ' '+FormatDateTime('hh:mm:ss',now))+','+QuotedStr('DD/MM/YYYY HH24:MI:SS')+')';
        //16-OCT-2007 09:09:25
    END
  ELSE
  IF V_TP = 9 THEN
    BEGIN
        DecodeDate (V_DATATIME, V_ANO, V_MES, V_DIA);
        RESULT := INTTOSTR(V_ANO)+'-'+INTTOSTR(V_MES)+'-'+INTTOSTR(V_DIA);

        //Y/M/D
    END;
end;

//================================================================================================

{Função que retorna a data por extenso em um datatime}
function FUNC_MESANO_EXTENSO(VF_MES,VF_ANO: INTEGER): String;
VAR
  V_MESES         : array [1..12] of String;
  V_MES, V_ANO : Word;
BEGIN
  V_MESES[1]  := 'Jan';
  V_MESES[2]  := 'Fev';
  V_MESES[3]  := 'Mar';
  V_MESES[4]  := 'Abr';
  V_MESES[5]  := 'Mai';
  V_MESES[6]  := 'Jun';
  V_MESES[7]  := 'Jul';
  V_MESES[8]  := 'Ago';
  V_MESES[9]  := 'Set';
  V_MESES[10] := 'Out';
  V_MESES[11] := 'Nov';
  V_MESES[12] := 'Dez';
  V_MES       := VF_MES;
  V_ANO       := VF_ANO;
  IF (VF_MES = 0)  OR (VF_ANO = 0)
  THEN Result := ''
  ELSE Result := V_MESES[V_MES]+ ' de ' + IntToStr(V_ANO);

END;

//================================================================================================
{Procedure para mudar o cursor do mouse}
procedure PROC_MUDA_MOUSE(V_Muda: Boolean);
begin
  Application.ProcessMessages;
  if V_Muda then
    Screen.Cursor := crHourGlass
  else
    Screen.Cursor := crDefault;
end;

//================================================================================================


FUNCTION FUNC_DBGRID_ORDENA(V_DataSource: TDataSource; V_DBGrid: TDBGrid; V_Campo: Integer) : Boolean;
var
  V_MOUSE        : TCursor;
  v_x            : Integer;
begin

try

  for v_x := 0 to V_DBGrid.Columns.Count -1 do
    BEGIN
        V_DBGrid.Columns[v_x].Title.Font.Style  := [];
        V_DBGrid.Columns[v_x].Title.Font.Color  := clBlack;
    END;

  if V_DataSource.DataSet.Active then
    begin
      try
        V_MOUSE   := Screen.Cursor;
        Screen.Cursor := crHourGlass;

        try
          TClientDataset(V_DataSource.DataSet).IndexDefs.Find('IDXC_' + V_DBGrid.Columns[V_Campo].Field.FieldName);
        except
          TClientDataset(V_DataSource.DataSet).AddIndex('IDXC_' + V_DBGrid.Columns[V_Campo].Field.FieldName, V_DBGrid.Columns[V_Campo].Field.FieldName, []);
        end;

        try

          TClientDataset(V_DataSource.DataSet).IndexDefs.Find('IDXD_' + V_DBGrid.Columns[V_Campo].Field.FieldName);
        except
          TClientDataset(V_DataSource.DataSet).AddIndex('IDXD_' + V_DBGrid.Columns[V_Campo].Field.FieldName, V_DBGrid.Columns[V_Campo].Field.FieldName, [ixDescending]);
        end;

        TClientDataset(V_DataSource.DataSet).IndexDefs.Update;


        if copy(TClientDataset(V_DataSource.DataSet).IndexName, 1, 5) = 'IDXC_' then
          begin
            TClientDataset(V_DataSource.DataSet).IndexName := 'IDXD_' + V_DBGrid.Columns[V_Campo].Field.FieldName;
            V_DBGrid.Columns[V_Campo].Title.Font.Style := [fsBold,fsItalic];
            V_DBGrid.Columns[V_Campo].Title.Font.Color := clRed;
          end
        else
          begin
            TClientDataset(V_DataSource.DataSet).IndexName := 'IDXC_' + V_DBGrid.Columns[V_Campo].Field.FieldName;
            V_DBGrid.Columns[V_Campo].Title.Font.Style := [];
            V_DBGrid.Columns[V_Campo].Title.Font.Color := clBlack;
          end;

           V_DBGrid.SetFocus;
        Screen.Cursor := V_MOUSE;
      except
        Screen.Cursor := crDefault;
      end;
    end;
   except
   end;
end;

//================================================================================================


{Função retorna nome computador}
function FUNC_NOME_COMPUTADOR: string;
var
  I: DWord;
begin
  I := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, I);
  Windows.GetComputerName(PChar(Result), I);
  Result := string(PChar(Result));
end;

//================================================================================================


{Função retorna versao sistema operacional}
function FUNC_VERSAO_SISTEMA_OPERACIONAL: string;
var
  Ver: _OSVERSIONINFOA;
  VB_SYS : BOOLEAN;
begin
  Ver.dwOSVersionInfoSize := SizeOf(Ver);
  VB_SYS := GetVersionEx(Ver);
  if VB_SYS then
  Result := IntToStr(Ver.dwMajorVersion) + '.' +
  IntToStr(Ver.dwMinorVersion)
  else
  Result := '';
end;

//================================================================================================


{Função retorna nome usuário do sistema operacional}
function FUNC_NOME_USUARIO_SISTEMA_OPEARACIONAL: string;
var
  I: DWord;
begin
  I := 255;
  SetLength(Result, I);
  Windows.GetUserName(PChar(Result), I);
  Result := string(PChar(Result));
end;

//================================================================================================


function FUNC_NOME_USUARIO_REDE : string;
var
  LPUSERNAME : PAnsiChar;
  LPPNLENGTH : DWORD;
begin
  TRY
    LPPNLENGTH := 0;
    WNetGetUser(nil,nil,LPPNLENGTH);
    IF LPPNLENGTH > 0 THEN
    BEGIN
      GETMEM(LPUSERNAME,LPPNLENGTH);
      if WNetGetUser(nil,LPUSERNAME,LPPNLENGTH) = NO_ERROR
      THEN Result := AnsiUpperCase(LPUSERNAME)
      ELSE Result := '';
      FREEMEM(LPUSERNAME,LPPNLENGTH);
    END
    ELSE
      result := '';

  EXCEPT ON E:EXCEPTION DO
    BEGIN
        MessageDlg('Erro na Ação: Retornar usuário de rede'+#13+
                   'Mensagem Original: '+e.Message, mtError, [mbOK], 0);
    END;
  END;
end;

//================================================================================================


{Função utilizada para formatação de ARQUIVOS TXT}
FUNCTION FUNC_FORMATA_TEXTO(V_TXT_ORIGINAL,V_CARACTER,V_LADO : STRING; V_TAMANHO : INTEGER) : STRING;
VAR
X : INTEGER;
VF_CARACTER     : STRING;
VF_TXT_ORIGINAL : STRING;
BEGIN
  VF_TXT_ORIGINAL := V_TXT_ORIGINAL;
  IF V_TAMANHO > 0 THEN
    BEGIN
      IF length(V_TXT_ORIGINAL) < V_TAMANHO THEN
        BEGIN
          VF_CARACTER := '';
          FOR X := 1 TO V_TAMANHO-length(V_TXT_ORIGINAL) DO
            VF_CARACTER := VF_CARACTER + V_CARACTER;

          IF V_LADO = 'D' THEN
            VF_TXT_ORIGINAL := VF_TXT_ORIGINAL+VF_CARACTER;
          IF V_LADO = 'E' THEN
            VF_TXT_ORIGINAL := VF_CARACTER+VF_TXT_ORIGINAL

        END
      ELSE
        IF length(V_TXT_ORIGINAL) > V_TAMANHO THEN
          VF_TXT_ORIGINAL := COPY(V_TXT_ORIGINAL,1,V_TAMANHO)
      ELSE
        IF length(V_TXT_ORIGINAL) = V_TAMANHO THEN
          VF_TXT_ORIGINAL := V_TXT_ORIGINAL;
     END;
      Result := VF_TXT_ORIGINAL;
END;

//================================================================================================


{Função nome do arquivo em caminho ex: c:\xx\xxx.txt}
function FUNC_NOME_ARQUIVO_CAMINHO(VS_CAMINHO: string): string;
var
  VI_X,VI_Y: Integer;
begin
FOR VI_X := 0 TO LENGTH(VS_CAMINHO) DO
  BEGIN
    VI_Y:=Pos('\',VS_CAMINHO);
    Delete(VS_CAMINHO,1,VI_Y);
  END;
 Result := VS_CAMINHO;
end;

//================================================================================================


{Função retira zero a esquerda}
FUNCTION FUNC_RETIRA_ZERO_ESQUERDA(VS_VALOR:string) : string;
Var
   VI_X : INTEGER;
Begin
RESULT := '';
     VS_VALOR := TRIM(VS_VALOR);
     IF VS_VALOR <> '0' THEN
       BEGIN
         IF COPY(VS_VALOR,0,1) = '0' THEN
           BEGIN
             FOR VI_X:= 1 TO LENGTH(VS_VALOR) DO
               IF (COPY(VS_VALOR,VI_X,1) = '0') THEN
               ELSE
                 BEGIN
                   RESULT := COPY(VS_VALOR,VI_X,LENGTH(VS_VALOR)-VI_X+1);
                   EXIT;
                 END;
           END
         ELSE
          BEGIN
            RESULT := VS_VALOR;
            EXIT;
          END;
      END
     ELSE
        RESULT := VS_VALOR;
End;

//================================================================================================


{ Deslisa o ponteiro do mouse até um controle }
function FUNC_MOVER_MOUSE_OBJETO(const Control: TControl): boolean;
var
  Pt: TPoint;
begin
  Pt.x := Control.Width div 2;
  Pt.y := Control.Height div 2;
  Pt := Control.ClientToScreen(Pt);
  Result := SetCursorPos(Pt.X, Pt.Y);
end;

//================================================================================================


{Função que retorna numero Inteiro por extenso}
function FUNC_NUMERO_INTEIRO_EXTENSO(V_NRO_INTEIRO: Integer): String;
var
   V_Texto: String;
begin

//Números inteiros
       V_Texto := '';
       case V_NRO_INTEIRO of
          100     : V_Texto := 'cem';
          101..199: V_Texto := 'cento';
          200..299: V_Texto := 'duzentos';
          300..399: V_Texto := 'trezentos';
          400..499: V_Texto := 'quatrocentos';
          500..599: V_Texto := 'quinhentos';
          600..699: V_Texto := 'seiscentos';
          700..799: V_Texto := 'setecentos';
          800..899: V_Texto := 'oitocentos';
          900..999: V_Texto := 'novecentos';
       end;

       V_NRO_INTEIRO := V_NRO_INTEIRO mod 100;
       if (V_NRO_INTEIRO > 9) and (V_Texto <> '') then
          V_Texto := V_Texto + ' e ';

       case V_NRO_INTEIRO of
          10    : V_Texto := V_Texto + 'dez';
          11    : V_Texto := V_Texto + 'onze';
          12    : V_Texto := V_Texto + 'doze';
          13    : V_Texto := V_Texto + 'treze';
          14    : V_Texto := V_Texto + 'quatorze';
          15    : V_Texto := V_Texto + 'quinze';
          16    : V_Texto := V_Texto + 'dezesseis';
          17    : V_Texto := V_Texto + 'dezesete';
          18    : V_Texto := V_Texto + 'dezoito';
          19    : V_Texto := V_Texto + 'dezenove';
          20..29: V_Texto := V_Texto + 'vinte';
          30..39: V_Texto := V_Texto + 'trinta';
          40..49: V_Texto := V_Texto + 'quarenta';
          50..59: V_Texto := V_Texto + 'cinquenta';
          60..69: V_Texto := V_Texto + 'sessenta';
          70..79: V_Texto := V_Texto + 'setenta';
          80..89: V_Texto := V_Texto + 'oitenta';
          90..99: V_Texto := V_Texto + 'noventa';
       end;

       if (V_NRO_INTEIRO > 10) and (V_NRO_INTEIRO < 20) then
          V_NRO_INTEIRO := 0;

       V_NRO_INTEIRO := V_NRO_INTEIRO mod 10;
       if (V_NRO_INTEIRO > 0) and (V_Texto <> '') then
          V_Texto := V_Texto + ' e ';

       case V_NRO_INTEIRO of
          1: V_Texto := V_Texto + 'um';
          2: V_Texto := V_Texto + 'dois';
          3: V_Texto := V_Texto + 'três';
          4: V_Texto := V_Texto + 'quatro';
          5: V_Texto := V_Texto + 'cinco';
          6: V_Texto := V_Texto + 'seis';
          7: V_Texto := V_Texto + 'sete';
          8: V_Texto := V_Texto + 'oito';
          9: V_Texto := V_Texto + 'nove';
       end;
       Result := V_Texto;
END;

//================================================================================================


{Função que retorna numero Monetário por extenso}
function FUNC_NUMERO_MONETARIO_EXTENSO(V_NRO_MONETARIO: Currency; v_moeda : boolean): String;
var
   V_Texto: String;
   V_Tx_Bao, V_Tx_Mao, V_Tx_Mil, V_Tx_Uni, V_Tx_Cen: String;
   V_Dv_Bao, V_Dv_Mao, V_Dv_Mil, V_Dv_Uni: String;

   function Divisao(V_Tx_Div: String): String;
   begin
      if (V_Tx_Div = ' de ') or (V_Tx_Div = ' ') then
         Result := ' e '
      else if V_Tx_Div = ' e ' then
         Result := ', '
      else
         Result := V_Tx_Div;
   end;

begin
   IF V_NRO_MONETARIO < 0 THEN
   V_NRO_MONETARIO := V_NRO_MONETARIO*-1;

   V_Texto  := '';
   V_Tx_Bao := FUNC_NUMERO_INTEIRO_EXTENSO(Trunc(V_NRO_MONETARIO / 1000000000));
   V_NRO_MONETARIO  := Frac(V_NRO_MONETARIO / 1000000000) * 1000000000;
   V_Tx_Mao := FUNC_NUMERO_INTEIRO_EXTENSO(Trunc(V_NRO_MONETARIO / 1000000));
   V_NRO_MONETARIO  := Frac(V_NRO_MONETARIO / 1000000) * 1000000;
   V_Tx_Mil := FUNC_NUMERO_INTEIRO_EXTENSO(Trunc(V_NRO_MONETARIO / 1000));
   V_NRO_MONETARIO  := Frac(V_NRO_MONETARIO / 1000) * 1000;
   V_Tx_Uni := FUNC_NUMERO_INTEIRO_EXTENSO(Trunc(V_NRO_MONETARIO));
   V_NRO_MONETARIO  := Frac(V_NRO_MONETARIO / 1) * 1;
   V_Tx_Cen := FUNC_NUMERO_INTEIRO_EXTENSO(Trunc(V_NRO_MONETARIO / 0.01));

   if V_Tx_Bao <> '' then
   begin
      if V_Tx_Bao = 'um' then
         V_Tx_Bao := V_Tx_Bao + ' bilhão'
      else
         V_Tx_Bao := V_Tx_Bao + ' bilhões';
      V_Dv_Bao := ' de ';
   end;

   if V_Tx_Mao <> '' then
   begin
      if V_Tx_Mao = 'um' then
         V_Tx_Mao := V_Tx_Mao + ' milhão'
      else
         V_Tx_Mao := V_Tx_Mao + ' milhões';
      V_Dv_Bao := Divisao(V_Dv_Bao);
      V_Dv_Mao := ' de ';
   end;

   if V_Tx_Mil <> '' then
   begin
      V_Tx_Mil := V_Tx_Mil + ' mil';
      V_Dv_Bao := Divisao(V_Dv_Bao);
      V_Dv_Mao := Divisao(V_Dv_Mao);
      V_Dv_Mil := ' ';
   end;

   if V_Tx_Uni <> '' then
   begin
      V_Dv_Bao := Divisao(V_Dv_Bao);
      V_Dv_Mao := Divisao(V_Dv_Mao);
      V_Dv_Mil := Divisao(V_Dv_Mil);
   end;

   if V_Tx_Cen <> '' then
   begin
      V_Dv_Bao := Divisao(V_Dv_Bao);
      V_Dv_Mao := Divisao(V_Dv_Mao);
      V_Dv_Mil := Divisao(V_Dv_Mil);
      if (V_NRO_MONETARIO > 0.99)  then
      V_Dv_Uni := ' e ';
   end;

   V_Texto := V_Tx_Bao + V_Dv_Bao + V_Tx_Mao + V_Dv_Mao + V_Tx_Mil + V_Dv_Mil + V_Tx_Uni;

   if (v_moeda) AND (V_NRO_MONETARIO > 0.99) then
    begin
       if V_Texto = 'um' then
          V_Texto := V_Texto + ' real'
       else
          V_Texto := V_Texto + ' reais';
    end;

    
       if V_Tx_Cen <> '' then
       begin
          V_Texto := V_Texto + V_Dv_Uni + V_Tx_Cen;

          if v_moeda then
            begin
              if V_Tx_Cen = 'um' then
                 V_Texto := V_Texto + ' centavo'
              else
                 V_Texto := V_Texto + ' centavos';
            end;
       end;

   Result := V_Texto;

end;

//================================================================================================


{Procedure que formata celula excel  em execução}
PROCEDURE PROC_FORMATAR_PLANILHA(V_PLANILHA     : VARIANT;
                                 V_PLANILHA_LIN,
                                 V_PLANILHA_COL : INTEGER;
                                 V_TM_FONTE  : INTEGER;
                                 V_COR_FUNDO : TColor;
                                 V_NEGRITO   : Boolean;
                                 V_REPLACE_1,
                                 V_REPLACE_2,
                                 V_VALOR_CEL : STRING);
VAR
V_AUX : STRING;
BEGIN
  V_AUX  := TRIM(V_VALOR_CEL);
  V_AUX  := StringReplace(V_AUX,#39,'',[rfReplaceAll]);
  V_AUX  := StringReplace(V_AUX,'"','',[rfReplaceAll]);

//  IF NOT FUNC_VALIDA_VALOR(V_AUX,'VR') THEN
//      V_AUX  := TRIM(V_VALOR_CEL);

  V_PLANILHA.Cells[V_PLANILHA_LIN,V_PLANILHA_COL]                   := TRIM(V_AUX);
  V_PLANILHA.Cells[V_PLANILHA_LIN,V_PLANILHA_COL].font.size         := V_TM_FONTE;
  V_PLANILHA.Cells[V_PLANILHA_LIN,V_PLANILHA_COL].font.Bold         := V_NEGRITO;
  V_PLANILHA.Cells[V_PLANILHA_LIN,V_PLANILHA_COL].Interior.Color    := V_COR_FUNDO;

  //V_PLANILHA.Cells[V_PLANILHA_LIN,V_PLANILHA_COL].REPLACE(V_REPLACE_1,V_REPLACE_2);
END;

//================================================================================================



{Função que cria mapeamento de rede}
FUNCTION FUNC_MAPEAMENTO_REDE(  V_provedor, V_Senha : PChar; V_Letra, V_CAMINHO : STRING; V_MSG, V_CONECTAR : BOOLEAN) : BOOLEAN;
VAR
  V_ERRO : DWord;
  V_MENSAGEM : STRING;
  V_Tamanho : Cardinal;
  NRW : TNetResource;
BEGIN

    V_MENSAGEM := 'Letra: '+V_LETRA+#13+'Caminho: '+V_CAMINHO+#13+'Provedor: '+V_provedor+#13+#13+'Mensagem: '+#13;

    IF NOT V_CONECTAR THEN
      BEGIN
        V_CAMINHO := V_CAMINHO;
        SetLength(V_CAMINHO,255);
        V_Tamanho :=255;
        IF WNetGetConnection(PChar(V_Letra), PChar(V_Caminho), V_Tamanho) = NO_ERROR THEN
          BEGIN
            WNetCancelConnection(PCHAR(V_Letra),TRUE);
          END;

        IF V_MSG THEN
          BEGIN
            Case GetLastError() of
              1205: ShowMessage(V_MENSAGEM+'Não foi possível abrir o perfil');
              1206: ShowMessage(V_MENSAGEM+'Perfil do usuário não encontrado ou inválido');
              1208: ShowMessage(V_MENSAGEM+'Ocorreu um Erro específico na rede');
              2138: ShowMessage(V_MENSAGEM+'Rede não encontrada ou fora do ar');
              2250: ShowMessage(V_MENSAGEM+'Mapeamento inválido ou não encontrado');
              2401: ShowMessage(V_MENSAGEM+'Existem muitos arquivos abertos');
            else
              ShowMessage(V_MENSAGEM+'Unidade disconectada com sucesso');
            end;
        END;

      END
    ELSE
    IF V_CONECTAR THEN
      BEGIN
        V_CAMINHO := V_CAMINHO+#0;
        SetLength(V_CAMINHO,255);
        V_Tamanho :=255;
        IF WNetGetConnection(PChar(V_Letra), PChar(V_Caminho), V_Tamanho) <> NO_ERROR THEN
          BEGIN
           {with NRW do
                begin
                  dwType       := RESOURCETYPE_ANY;
                  lpLocalName  := PCHAR(V_Letra);
                  lpRemoteName := PCHAR(V_CAMINHO);
                  lpProvider   := V_provedor;
                end;
           WNetAddConnection2(NRW, ' ', ' ', CONNECT_UPDATE_PROFILE);}

            WNetAddConnection ( PCHAR(V_CAMINHO), V_Senha , PCHAR(V_Letra));
            IF V_MSG THEN
              BEGIN
                Case GetLastError() of
                5    : ShowMessage(V_MENSAGEM+'Acesso Negado');
                66   : ShowMessage(V_MENSAGEM+'Tipo de dispositivo local ou recurso inválido');
                67   : ShowMessage(V_MENSAGEM+'Caminho não encontrado ou inválido');
                85   : ShowMessage(V_MENSAGEM+'Este mapeamento já existe');
                86   : ShowMessage(V_MENSAGEM+'Senha não encontrada ou inválida');
                1200 : ShowMessage(V_MENSAGEM+'Letra atribuída a unidade já é reservada ou inválida');
                1202 : ShowMessage(V_MENSAGEM+'Um mapeamento com esta letra já existe');
                1203 : ShowMessage(V_MENSAGEM+'Rede ou caminho não encontrado ou inválido');
                1204 : ShowMessage(V_MENSAGEM+'Provedor não encontrado ou inválido');
                1205 : ShowMessage(V_MENSAGEM+'Não foi possível abrir o perfil');
                1206 : ShowMessage(V_MENSAGEM+'Perfil do usuário não encontrado ou inválido');
                1208 : ShowMessage(V_MENSAGEM+'Ocorreu um Erro específico na rede');
                170  : ShowMessage(V_MENSAGEM+'Rede congestionada');
                2138 : ShowMessage(V_MENSAGEM+'Rede não encontrada ou fora do ar');
                else
                  ShowMessage(V_MENSAGEM+'Unidade mapeada com sucesso');
                end;
              END;
          END;
      END;
END;

//================================================================================================

{Função que retorna o tipo de do valor - decimal, inteiro, texto, data}
FUNCTION FUNC_VALIDA(  V_VALOR, V_TP : STRING) : BOOLEAN;
BEGIN
  RESULT := TRUE;

  IF V_TP = 'DT' THEN
  BEGIN
    TRY
        STRToDateTime(V_VALOR);
    EXCEPT
      RESULT := FALSE;
    END;
  END
  ELSE
  IF V_TP = 'PER' THEN
  BEGIN
    TRY
        STRToDateTime('01/'+V_VALOR);
    EXCEPT
      RESULT := FALSE;
    END;
  END;

END;

//================================================================================================

{Função para arredondar números}
FUNCTION FUNC_ROUND(V_VR: Double; V_CASAS: Integer): Double;
var
  Factor, Fraction, Arred : Extended;
  i : integer;
  vFraction : string;
  vlrFrac : Variant;
  negativo : boolean;
  v_result, v_valor : Double;

begin
      Factor := IntPower(10, V_CASAS);

      if V_VR < 0
      then v_valor := abs(V_VR)
      else v_valor := V_VR;

      v_valor := StrToFloat(FloatToStr(v_valor * Factor));
      v_Result := Int(v_valor);
      Fraction := Frac(v_valor);
      vFraction := floattostr(Fraction);
      if vFraction = '0' then
         vFraction := '0,0';
      for i := 0 to Length(vFraction) do begin
          vlrFrac := Copy(vFraction,(Length(vFraction)-i),1);
          if vlrFrac = ',' then begin
             if Arred > 0 then
             v_Result := v_Result + 1;

              if V_VR < 0
              then Result := -1*(v_result / Factor)
              else Result :=     v_result / Factor;

             exit;
          end;
          vlrFrac := vlrFrac + Arred;
          Arred  := 0;
          if vlrFrac > 5 then
             Arred := 1;
      end;
end;

{Função executa exe  esprea ele terminar}
function FUNC_EXE_FIM(const FileName, Params: string; const WindowState: Word): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
begin
  { Coloca o nome do arquivo entre aspas. Isto é necessário devido aos espaços contidos em nomes longos }
  CmdLine := Filename  + Params;
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do begin
  cb := SizeOf(SUInfo);
  dwFlags := STARTF_USESHOWWINDOW;
  wShowWindow := WindowState;
  end;
  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, false,
  CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
  PChar(ExtractFilePath(Filename)), SUInfo, ProcInfo);
  { Aguarda até ser finalizado }
  if Result then begin
  WaitForSingleObject(ProcInfo.hProcess, INFINITE);
  { Libera os Handles }
  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
  end;
end;

//================================================================================================

{Procedure  para gravação e leitura dos arquivos}
PROCEDURE PROC_INI_GRAVACAO(V_CAMINHO, V_PARAM_MESTRE, V_PARAM_FILHO, V_VALOR: STRING);
var
ArqIni : TIniFile;
begin
ArqIni := tIniFile.Create(PCHAR(V_CAMINHO));
Try
ArqIni.WriteString(V_PARAM_MESTRE, V_PARAM_FILHO, V_VALOR);
Finally
ArqIni.Free;
end;
end;

//================================================================================================
{Procedure  para gravação e leitura dos arquivos}
PROCEDURE PROC_INI_SUB_LEITURA(V_CAMINHO, V_PARAM_MESTRE, V_PARAM_FILHO : STRING; VAR V_VR :STRING);
var
ArqIni : TIniFile;
begin
ArqIni := tIniFile.Create(PCHAR(V_CAMINHO));
Try
V_VR := ArqIni.ReadString(V_PARAM_MESTRE, V_PARAM_FILHO, V_VR );
Finally
ArqIni.Free;
end;
end;

//================================================================================================

{Procedure  para gravação e leitura dos arquivos}
FUNCTION  FUNC_INI_LEITURA    (V_CAMINHO, V_PARAM_MESTRE, V_PARAM_FILHO : STRING) : STRING;
VAR
V_RESULT : STRING;
BEGIN
 PROC_INI_SUB_LEITURA(V_CAMINHO, V_PARAM_MESTRE, V_PARAM_FILHO, V_RESULT);
 RESULT := V_RESULT;
END;

//================================================================================================


{Função para importação de TXT}
FUNCTION FUNC_IMPORTA_TXT(V_TP,V_CAMINHO,V_DELIMITADOR,V_TP_CAMINHO : STRING;V_QTD_CAMPOS :INTEGER;V_TM_CAMPO : array of string): BOOLEAN;
VAR
  V_ARQ: TStringList;
  V_X, V_Y, V_POS,V_TM: Integer;
  V_LINHA: String;
BEGIN
  RESULT := true;


  IF (NOT FileExists(PCHAR(V_CAMINHO))) AND (V_TP_CAMINHO = 'C') THEN
    BEGIN
      MessageDlg('Caminho do Arquivo inváido', mtWarning, [mbOK], 0);
      result := false;
      exit;
    END;
  TRY

  PROC_MUDA_MOUSE(TRUE);

  SetLength(VG_ARQ_TXT,0,0);
  V_ARQ  := TStringList.Create;
  IF V_TP_CAMINHO = 'C' THEN
    BEGIN
      V_ARQ.LoadFromFile(PCHAR(V_CAMINHO));
    END
  ELSE
  IF V_TP_CAMINHO = 'T' THEN
    BEGIN
      V_ARQ.Text := V_CAMINHO;
      V_QTD_CAMPOS := FUNC_QTD_TXT(V_ARQ.Text,V_DELIMITADOR);
    END;



  IF V_TP = 'D' THEN
    BEGIN
        SetLength(VG_ARQ_TXT,V_ARQ.Count+1,V_QTD_CAMPOS+1);
        FOR V_X := 0 to V_ARQ.Count -1 DO
        BEGIN
          V_LINHA := V_ARQ.Strings[V_X];
          FOR V_Y := 0 to V_QTD_CAMPOS DO
            BEGIN
              V_POS := Pos(V_DELIMITADOR,V_LINHA);
              IF V_Y <  V_QTD_CAMPOS THEN
                BEGIN
                  VG_ARQ_TXT[V_X][V_Y] := Copy(V_LINHA,1,V_POS-1);
                  Delete(V_LINHA,1,V_POS);
                END
              ELSE
                  VG_ARQ_TXT[V_X][V_Y] := V_LINHA;
            END;
        END;
    END
  ELSE
  IF V_TP = 'F' THEN
    BEGIN
        SetLength(VG_ARQ_TXT,V_ARQ.Count+1,V_QTD_CAMPOS+1);
        FOR V_X := 0 to V_ARQ.Count -1 DO
        BEGIN
          V_LINHA := V_ARQ.Strings[V_X];
          FOR V_Y := 0 to V_QTD_CAMPOS DO
            BEGIN
              V_POS :=  STRTOINT(COPY(V_TM_CAMPO[V_Y] , 0                          , POS(';',V_TM_CAMPO[V_Y])-1                       ));
              V_TM  :=  STRTOINT(COPY(V_TM_CAMPO[V_Y] , POS(';',V_TM_CAMPO[V_Y])+1 , LENGTH(V_TM_CAMPO[V_Y])-POS(';',V_TM_CAMPO[V_Y]) ));
              VG_ARQ_TXT[V_X][V_Y]  := COPY(V_LINHA,V_POS,V_TM);
            END;
        END;
    END;
        V_ARQ.Free;
  EXCEPT
    PROC_MUDA_MOUSE(FALSE);
  END;
  PROC_MUDA_MOUSE(FALSE);
END;

//================================================================================================


{Função a quantidade de um caracter em uma string}
FUNCTION FUNC_QTD_TXT(V_TXT,V_CARC : STRING) : INTEGER;
VAR
  V_P,V_TM,V_QTD : INTEGER;
BEGIN
    V_TM  := LENGTH(V_TXT);
    V_QTD := 0;

    FOR V_P := 0 TO V_TM DO
      BEGIN
        IF (COPY(V_TXT,V_P,1) = V_CARC) THEN
            V_QTD := V_QTD+1;

      END;
    Result := V_QTD;
END;

//================================================================================================

{Procedure que executa programas com parametros}
procedure PROC_EXE_EXECUTAR(janela: HWND; Nome, Parametros: String);
Var
Comando: Array[0..1024] of Char;
Parms: Array[0..1024] of Char;
begin
StrPCopy (Comando, Nome);
StrPCopy (Parms, Parametros);
ShellExecute (janela, 'Open', Comando, Parms, Nil, SW_SHOW);
end;

//================================================================================================


  {Função que retorna a data do fim do mês}
Function FUNC_DATA_FIM_MES (Data : TDateTime) : TDateTime;
begin
result := INCMONTH(Data,1) - 1;
end;

//================================================================================================

{Função que retorna mês adicionado}
Function FUNC_DATA_ADICIONA_MES (Data : TDateTime; v_qtd_mes : integer) : TDateTime;
begin
  result := INCMONTH(Data,v_qtd_mes);
end;

//================================================================================================

{Função que retorna inicio do mês}
Function FUNC_DATA_INI_MES (Data : TDateTime) : TDateTime;
var
Year, Month, Day : word;
begin
DecodeDate(Data,Year, Month, Day);
result := EncodeDate (Year, Month, 1);
end;

//================================================================================================
{Função que retorna menor data}
Function FUNC_DATA_MENOR_VALIDA (Ano, Mes, Dia : Word) : TDateTime;
Var 
Continua : Boolean;
DataAux : TDateTime;
begin
Continua := True; 
DataAux := date;
while Continua do 
Try
DataAux := EncodeDate (Ano, Mes, Dia);
Continua := False;
Except 
Dec (Dia);
End; 
FUNC_DATA_MENOR_VALIDA := DataAux;
end;

//================================================================================================
{Função que retorna um entter na linha}
function QL : STRING;
begin
  Result :=  #13+#10;
end;

//================================================================================================

{Cria processo no windows apartir de um comando}
function FUNC_WINEXEC(cmd: string; V_ESPERAR : BOOLEAN): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  SUInfo.cb      := SizeOf(SUInfo);
  SUInfo.dwFlags := STARTF_USESHOWWINDOW;
  SUInfo.wShowWindow := SW_HIDE;

  Result := CreateProcess(nil,
                          PChar(cmd),
                          nil,
                          nil,
                          false,
                          CREATE_NEW_CONSOLE or
                          NORMAL_PRIORITY_CLASS,
                          nil,
                          nil,
                          SUInfo,
                          ProcInfo);

  IF V_ESPERAR THEN
  BEGIN
    if (Result) then
    begin
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
      CloseHandle(ProcInfo.hProcess);
      CloseHandle(ProcInfo.hThread);
    END;
 end;
end;

//================================================================================================

{Função de exception}
FUNCTION FUNC_EXECPTION(E: Exception) : STRING;
var mensagem: string;
  Pos1, Pos2: integer;
begin
   Result := 'Sem erro';
   If Pos(UpperCase('is not a valid date'), UpperCase(E.Message)) <> 0 THEN
   BEGIN
    Result := 'Data inválida. Proceda  correção';
   END
   ELSE
   IF Pos(UpperCase('must have a value'), UpperCase(E.Message)) <> 0 THEN
   BEGIN
    Pos1:=Pos('''', E.Message);
    mensagem:=E.Message;
    Delete(mensagem, Pos1, 1);
    Pos2:=Pos('''', mensagem);
    mensagem:=copy(E.Message, Pos1 + 1, Pos2 - Pos1);
    Result := 'É obrigatório o preenchimento do campo ['+ mensagem + '].';
   END
   ELSE
   IF Pos(UpperCase('key violation'), UpperCase(E.Message)) <> 0 THEN
   BEGIN
      Result := 'Houve violação de Chave.  Registro já incluido.';
   END
   ELSE
   IF Pos(UpperCase('Input value'), UpperCase(E.Message)) <> 0 THEN
   BEGIN
     Result := 'Campo preenchido com valor não válido. Proceda correção.';
   END
   ELSE
   IF Pos(UpperCase('is not a valid time'), UpperCase(E.Message)) <> 0 THEN
   BEGIN
      Result := 'Hora inválida, proceda a correção.';
   END
   ELSE
   IF Pos(UpperCase('ORA-12560'), UpperCase(E.Message)) <> 0 THEN
   BEGIN
      Result := 'Problemas com a conexão da rede com Banco de dados - ORACLE'+#13+#13+
                'Ocorreu o seguinte erro: '+UpperCase(E.Message);
   END
   ELSE
   IF Pos(UpperCase('unavailable datDbase'), UpperCase(E.Message)) <> 0 THEN
   BEGIN
      Result := 'Problemas com a conexão da rede com Banco de dados - FireBird'+#13+#13+
                'Ocorreu o seguinte erro: '+UpperCase(E.Message);
   END
   ELSE
   Result := '==============================================================='+#13+#10+
             'E R R O                                                        '+#13+#10+
             '==============================================================='+#13+#10+#13+#10+#13+#10+
             'Este erro é uma situação não esperada'+#13+#10+#13+#10+
             'Caso ocorra novamente, entre em contato com o suporte'+#13+#10+#13+#10+
             'Mensagem de erro original: '+#13+#13+#13+UpperCase(E.Message);

END;


//================================================================================================

{Função verifica exe esta aberto evitando re-abertura}
function FUNC_VERIFICA_EXE_ABERTO(V_TITULO : STRING; ActivateIt:boolean ) : Boolean;
var
  hSem : THandle;
  hWndMe : HWnd;
  AppTitle: string;
begin
  Result := False;
  AppTitle := V_TITULO;
  hSem := CreateSemaphore(nil, 0, 1, pChar(AppTitle) );
  if ((hSem <> 0) AND (GetLastError() = ERROR_ALREADY_EXISTS)) then
     begin
       CloseHandle(hSem);
       Result := True;
     end;
  if Result and ActivateIt then
     begin
       V_TITULO :=  'zzzzzzz';
       hWndMe := FindWindow(nil, pChar(AppTitle));
       if (hWndMe <> 0) then
          begin
            if IsIconic(hWndMe) then
               ShowWindow(hWndMe, SW_SHOWNORMAL)
            else
               SetForegroundWindow(hWndMe);
          end;
     end;
end;

//================================================================================================
  {Força a digitação apenas de números}
procedure PROC_KeyPress_NUMERO(Sender: TObject;
  var Key: Char);
begin
 IF (KEY <> CHAR(VK_BACK)) AND
    (KEY <> #13)           AND
    (KEY <> CHAR(VK_DELETE))     THEN
 if key  IN ['0'..'9'] then else
    KEY := #0;
end;

//================================================================================================

{Função botões para navegação}
function FUNC_CDS_NEVEGACAO(V_nbFirst,V_nbPrior,V_nbNext,V_nbLast : TSpeedButton; V_ACAO : STRING; V_CDS : TClientDataSet) : Boolean;
BEGIN
  IF V_ACAO = 'F' THEN BEGIN
    TClientDataSet(V_CDS).First;
  END ELSE
  IF V_ACAO = 'P' THEN BEGIN
    TClientDataSet(V_CDS).Prior;
  END ELSE
  IF V_ACAO = 'N' THEN BEGIN
    TClientDataSet(V_CDS).Next;
  END ELSE
  IF V_ACAO = 'L' THEN BEGIN
    TClientDataSet(V_CDS).Last;
  END ELSE
  IF V_ACAO = 'DS' THEN BEGIN
    TSpeedButton(V_nbFirst).Enabled := FALSE;
    TSpeedButton(V_nbPrior).Enabled := FALSE;
    TSpeedButton(V_nbNext).Enabled  := FALSE;
    TSpeedButton(V_nbLast).Enabled  := FALSE;
    EXIT;
  END ELSE
  IF V_ACAO = 'ES' THEN BEGIN
    TSpeedButton(V_nbFirst).Enabled := TRUE;
    TSpeedButton(V_nbPrior).Enabled := TRUE;
    TSpeedButton(V_nbNext).Enabled  := TRUE;
    TSpeedButton(V_nbLast).Enabled  := TRUE;
    EXIT;
  END;

  IF TClientDataSet(V_CDS).Bof THEN BEGIN
    TSpeedButton(V_nbFirst).Enabled := FALSE;
    TSpeedButton(V_nbPrior).Enabled := FALSE;
    TSpeedButton(V_nbNext).Enabled  := TRUE;
    TSpeedButton(V_nbLast).Enabled  := TRUE;
  END ELSE
  IF TClientDataSet(V_CDS).EOF THEN BEGIN
    TSpeedButton(V_nbFirst).Enabled := TRUE;
    TSpeedButton(V_nbPrior).Enabled := TRUE;
    TSpeedButton(V_nbNext).Enabled  := FALSE;
    TSpeedButton(V_nbLast).Enabled  := FALSE;
  END;

END;


Function Func_enumero(s : String) : boolean;
Var
  i : integer;
  v_result : boolean;
begin
      v_result := false;

      s := trim(s);

      if s = '' then begin
          result := false;
          exit;
      end;

      if length(trim(s)) > 15 then begin
            //mens('Numero nao pode ter mais que 15 caracteres :'+s);
            result := false;
            exit;
      end;

      for i := 0  to length(s)-1 do begin
          if (copy(s,i,1) >= '0') and (copy(s,i,1) <= '9') then begin
            v_result := true
          end else begin
            v_result := false;
            break;
          end;
      end;
      result := v_result;
end;

function GetId():integer;
begin
  Randomize;
  result:=Random(65535);
end;

Procedure TrataRetornoECFBematech(iRetorno : integer);
begin
  //Esse trata retorno só funciona para as impressoras que utilizam a BEMAFI32.dll
  
  if iRetorno = 0 then
    Raise Exception.Create('Erro de Comunicação !');

  If iRetorno = -1 Then
    Raise Exception.Create('Erro de Execução na Função. Verifique!');

  if iRetorno = -2  then
    Raise Exception.Create('Parâmetro Inválido !');

  if iRetorno = -3  then
    Raise Exception.Create('Alíquota não programada !');

  If iRetorno = -4 Then
    Raise Exception.Create('Arquivo BemaFI32.INI não encontrado. Verifique!');

  If iRetorno = -5 Then
    Raise Exception.Create('Erro ao Abrir a Porta de Comunicação');

  If iRetorno = -6 Then
    Raise Exception.Create('Impressora Desligada ou Desconectada');

  If iRetorno = -7 Then
    Raise Exception.Create('Banco Não Cadastrado no Arquivo BemaFI32.ini');

  If iRetorno = -8 Then
    Raise Exception.Create('Erro ao Criar ou Gravar no Arquivo Retorno.txt ou Status.txt');

  if iRetorno = -18 then
    Raise Exception.Create('Não foi possível abrir arquivo INTPOS.001 !');

  if iRetorno = -19 then
    Raise Exception.Create('Parâmetro diferentes !');

  if iRetorno = -20 then
    Raise Exception.Create('Transação cancelada pelo Operador !');

  if iRetorno = -21 then
    Raise Exception.Create('A Transação não foi aprovada !');

  if iRetorno = -22 then
    Raise Exception.Create('Não foi possível terminal a Impressão !');

  if iRetorno = -23 then
    Raise Exception.Create('Não foi possível terminal a Operação !');

  if iRetorno = -24 then
    Raise Exception.Create('Forma de pagamento não programada.');

  if iRetorno = -25 then
    Raise Exception.Create('Totalizador não fiscal não programado.');

  if iRetorno = -26 then
    Raise Exception.Create('Transação já Efetuada !');

  if iRetorno = -28 then
    Raise Exception.Create('Não há Informações para serem Impressas !');
end;

Procedure RetornoECFBematech(iACK , iST1 , iST2 : integer);
var
    mensagem1, mensagem2 : string;
begin
  If iACK = 21 Then begin
       raise Exception.Create('A Impressora retornou NAK. O programa será abortado!');
       exit;
  end;

  If ( iACK = 6 ) then begin
      mensagem1 := '';

      // Verifica ST1
      IF iST1 >= 128 Then BEGIN iST1 := iST1 - 128; mensagem1 := mensagem1 + 'BIT 7 - Fim de Papel'+#13; END;
      IF iST1 >= 64  Then BEGIN iST1 := iST1 - 64;  mensagem1 := mensagem1 + 'BIT 6 - Pouco Papel'+#13; END;
      IF iST1 >= 32  Then BEGIN iST1 := iST1 - 32;  mensagem1 := mensagem1 + 'BIT 5 - Erro no Relógio'+#13; END;
      IF iST1 >= 16  Then BEGIN iST1 := iST1 - 16;  mensagem1 := mensagem1 + 'BIT 4 - Impressora em ERRO'+#13; END;
      IF iST1 >= 8   Then BEGIN iST1 := iST1 - 8;   mensagem1 := mensagem1 + 'BIT 3 - CMD não iniciado com ESC'+#13; END;
      IF iST1 >= 4   Then BEGIN iST1 := iST1 - 4;   mensagem1 := mensagem1 + 'BIT 2 - Comando Inexistente'+#13; END;
      IF iST1 >= 2   Then BEGIN iST1 := iST1 - 2;   mensagem1 := mensagem1 + 'BIT 1 - Cupom Aberto'+#13; END;
      IF iST1 >= 1   Then BEGIN iST1 := iST1 - 1;   mensagem1 := mensagem1 + 'BIT 0 - Nº de Parâmetros Inválidos'+#13; END;

      if trim(Mensagem1) <> '' then
          raise Exception.Create('ST1'+#13+mensagem1);

      mensagem2 := '';
      // Verifica ST2
      IF iST2 >= 128 Then BEGIN iST2 := iST2 - 128; mensagem2 := mensagem2 + 'BIT 7 - Tipo de Parâmetro Inválido'+#13; END;
      IF iST2 >= 64  Then BEGIN iST2 := iST2 - 64;  mensagem2 := mensagem2 + 'BIT 6 - Memória Fiscal Lotada'+#13; END;
      IF iST2 >= 32  Then BEGIN iST2 := iST2 - 32;  mensagem2 := mensagem2 + 'BIT 5 - CMOS não Volátil'+#13; END;
      IF iST2 >= 16  Then BEGIN iST2 := iST2 - 16;  mensagem2 := mensagem2 + 'BIT 4 - Alíquota Não Programada'+#13; END;
      IF iST2 >= 8   Then BEGIN iST2 := iST2 - 8;   mensagem2 := mensagem2 + 'BIT 3 - Alíquotas lotadas'+#13; END;
      IF iST2 >= 4   Then BEGIN iST2 := iST2 - 4;   mensagem2 := mensagem2 + 'BIT 2 - Cancelamento ñ Permitido'+#13; END;
      IF iST2 >= 2   Then BEGIN iST2 := iST2 - 2;   mensagem2 := mensagem2 + 'BIT 1 - CGC/IE não Programados'+#13; END;
      IF iST2 >= 1   Then BEGIN iST2 := iST2 - 1;   mensagem2 := mensagem2 + 'BIT 0 - Comando não Executado'+#13; END;

      if trim(Mensagem2) <> '' then
          raise Exception.Create('ST2'+#13+mensagem2);
  End;

end;

function QuebraLinhaExtenso2(TextoExtenso : String;  tamanhoLinha : Integer; IntervaloLinhas : Integer) : String;
var
    TotalCaracter, i, j : integer;
    Palavra, Letra, TextoRetorno, Frase : string;
    FraseOK : Boolean;
begin
    TextoExtenso := trim(TextoExtenso);
    TotalCaracter := length(TextoExtenso);

    Palavra := '';
    TextoRetorno :='';
    Letra := '';
    Frase := '';

    for i := 1 to (TotalCaracter) do begin

        Letra := TextoExtenso[i];
        if trim(Letra) <> '' then
            Palavra := Palavra + Letra;

        if (trim(letra) = '') or (i = TotalCaracter) then begin
            FraseOK := false;
            while (Fraseok = false) do begin
                  if Length(Frase + Palavra) + 1 > tamanhoLinha then begin
                      while length(frase) < tamanhoLinha do begin
                          Frase := Frase + '*';
                      end;
                      if trim(TextoRetorno) = '' then
                          TextoRetorno := frase
                      else
                          TextoRetorno := TextoRetorno + replicate(#13,IntervaloLinhas)+ frase;
                      Frase := '';
                      Frase := trim(Frase +' '+Palavra);
                      Palavra := '';
                      if (i = TotalCaracter) and (trim(frase) <> '') then
                          FraseOK := false
                      else
                          FraseOK := true;
                  end else if (i = TotalCaracter) then begin
                      Frase := Frase +' '+Palavra;
                      while length(frase) < tamanhoLinha do begin
                          Frase := Frase + '*';
                      end;
                      if trim(TextoRetorno) = '' then
                          TextoRetorno := frase
                      else
                          TextoRetorno := TextoRetorno + replicate(#13,IntervaloLinhas)+ frase;
                      Frase := '';
                      Frase := trim(Frase +' '+Palavra);
                      Palavra := '';
                      FraseOK := true;
                  end else begin
                      Frase := trim(Frase +' '+Palavra);
                      Palavra := '';
                      FraseOK := true;
                  end;
            end;
        end;
    end;
    Result := TextoRetorno;
end;

procedure ChamaBrowser(Buffer : String);
begin
    ShellExecute(Application.Handle, nil, PChar(buffer), nil, nil, SW_SHOWNORMAL);
end;


function Tempo(data1, data2: TDateTime): string;
var
    hora, minuto, segundo: integer;
    ret: string;
begin
if data1 < data2 then
    segundo:=Round(86400 * (data2 - data1))
  else
    segundo:=Round(86400 * (data1 - data2));
hora:=segundo div 3600;
segundo:=segundo - (hora * 3600);
minuto:=segundo div 60;
segundo:=segundo - (minuto * 60);
if hora > 0 then
    begin
    if Length(IntToStr(hora)) > 2 then
        ret:=IntToStr(hora)
    else
        ret:=FormatFloat('00',hora);
    end
else
    ret:=FormatFloat('00',0);
ret:=ret + ':' + FormatFloat('00',minuto) + ':' + FormatFloat('00',segundo);
Tempo:=ret;
end;



Function At(S:String; C:char) : Integer;
Var
  x:Integer;
  r : Integer;
begin
  r:= 1;
  for x := 1 to length(s) do begin
      if s[x] = C then begin
        r:= x;
        break;
      end;
  end;
  Result := r;
End;

end.


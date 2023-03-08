unit funcao;

interface

Uses
  DBGrids, Mask, Classes, Controls, ExtCtrls, ComCtrls, CheckLst, Buttons,
  WinTypes, SysUtils, Forms, Dialogs, StdCtrls, IniFiles, Messages,
  Variants, cxGrid, dxPSCore, dxPrnPg,
  dxPScxCommon, dxPScxGrid6Lnk, cxGridLevel,
  cxClasses, cxControls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, cxDBData, dxPSGlbl,  dxPSEngn,
  dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  dxBase, cxDrawTextUtils, cxGridExportLink, ShellAPI,Graphics,

  IdBaseComponent, IdMessage, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP, IdAttachmentFile, IdSASL,
  IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, IdIOHandlerStack, IdSSL, IdText,
  IdSASLUserPass, IdSASLLogin,

  IdReplySMTP,  IdEMailAddress, IdSASL_CRAM_MD5, IdUserPassProvider, IdSASLSKey,
  IdAntiFreezeBase, IdAntiFreeze, IdSASLPlain, IdSASLOTP, IdSASLExternal,
  IdSASLAnonymous, IdFtpCommon, IdCustomTransparentProxy, IdSocks;

  type
    StringArray = Array of String;

  Function iif(Comparacao:Boolean;Verdadeiro:Variant; Falso:Variant):Variant;
  function TrocaAcentos(Texto: string): string;
  Function DataValida(Data:String): TDate;
  Function E_Ano_Bissexto(Data : TDateTime): Boolean;
  Function Data_Ultimo_Dia_Mes(Data : TDateTime): TDateTime;
  function RemoveCaracter(Texto: string; Caracter: string): string;
  Function SerialNumHD(FDrive:String) :String;
  Function TRANSCREVER(serial_hd: String): String;
  Function ApenasAlgarismos(Texto: string): string;
  function ParametroLinhaComando(pParam: string): boolean;
  procedure ImprimirGrid(iGrid: TcxGrid; Titulo: String; ExpandirGrupos: Boolean = True; ExpandirDetalhes: Boolean = False; RecolherApos: Boolean = False);
  procedure ExportarGrid(iGrid: TcxGrid; RecolherApos: Boolean = False);
  Procedure ExpandirGrid(iGrid: TcxGrid; Recolher: Boolean = False);
  function AddZero(Variavel: string; Tamanho: integer): string;
	function NomeDiaSemana(Dia:string):string;
  function Split(Texto, TextoCoringa: String; IncluirVazios: Boolean = False): StringArray;
	function NomeMes(Mes:integer):string;
  procedure ExpandViewGroups(AView: TcxGridTableView; ALevel: Integer = 1000);
	function UltimoDiaMes(Data:string):string; overload;

  function EnviarEmailAutomatico( De: String;
                                Para: String;
                                ParaBcc: String;
                                Assunto: String;
                                Texto: String;
                                TextoHtml: TStringList;
                                Arquivo: String;
                                SMTP: String;
                                UsuarioID: String;
                                Senha: String;
                                ResponderPara: String = '';
                                Porta: String = '587';
                                RequerAutenticacao: Boolean = True;
                                UsarSSL: Boolean = False;
                                MetodoSSL: integer = 4;
                                ModoSSL: integer = 1;
                                UsarTipoTLS: integer = 1;
                                Host_Proxy: String = '';
                                Porta_Proxy: String = '';
                                User_Proxy: String = '';
                                Senha_Proxy: String = '';
                                ManterConectado: Boolean = False;
                                MsgLog: TStringList = nil): Boolean;

  function GetVersao(iLabel: TLabel = nil): String;
  procedure CarregarImagem(iImage: TImage; iArquivo: String);
  function CaptionTela(iCaption: String): String;

implementation

const
  _Versao = '1.0.0.2';

var
  _dxCompPrinterGrid: TdxComponentPrinter;
  _dxCompPrinterCntLinkCnt: TdxGridReportLink;
  _SaveDialog: TSaveDialog;

  gIdSmtp: TIdSmtp; // conexao global de smtp, usada para mais de uma conexao simultanea e continua
  gAutenticado: Boolean; // usada para saber se o usuario ja esta conectado e autenticado u nao no servidor


function CaptionTela(iCaption: String): String;
begin
  result := Application.Title+' | '+iCaption+' | '+_Versao;
end;

procedure CarregarImagem(iImage: TImage; iArquivo: String);
begin
  iImage.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\'+iArquivo);
end;

function GetVersao(iLabel: TLabel = nil): String;
begin
  if Assigned(iLabel) then
     iLabel.Caption := 'Versão: '+_Versao;

  result := _Versao;
end;

Procedure ExportarGrid(iGrid: TcxGrid; RecolherApos: Boolean = False);
var
  sPath : string;
begin
  try
    sPath := '';

    if not Assigned(iGrid) then
      Exit;

    if not Assigned(_SaveDialog) then
      _SaveDialog:= TSaveDialog.Create(nil);

    with _SaveDialog do
    begin
      DefaultExt := 'txt';
      FileName := '*.txt';
      Filter :=
         'Arquivo de Texto|*.txt|Microsoft Excel|*.xls|Arquivo XML|*.xml|A' +
         'rquivo HTML|*.html|Todos os Arquivos (*.*)|*.*';
      Title := 'Exportar Dados';
      if Execute then
        sPath := FileName;
    end;

    if sPath <> '' then
    begin
      if pos('.xls', sPath) > 0 then
        ExportGridToExcel(sPath, iGrid, True, True, True)
      else if pos('.xml', sPath) > 0 then
        ExportGridToXML(sPath, iGrid, True, True)
      else if pos('.html', sPath) > 0 then
        ExportGridToHTML(sPath, iGrid, True, True)
      else if pos('.txt', sPath) > 0 then
        ExportGridToText(sPath, iGrid, True, True);

      ShellExecute(0, 'open', PChar(sPath), nil, nil, SW_SHOW);
    end;

    if RecolherApos then
      ExpandirGrid(iGrid,True);
  Except
    on e:exception do
      ShowMessage('Erro 2688e777: '+E.Message);
  end;


end;

Procedure ExpandirGrid(iGrid: TcxGrid; Recolher: Boolean = False);
var
  i, x: integer;
begin

  if not Assigned(iGrid) then
      Exit;

  for i := 0 to iGrid.Levels.Count - 1 do
  begin
    if Recolher then
    begin
      iGrid.Levels.Items[i].GridView.DataController.Groups.FullCollapse;
      iGrid.Levels.Items[i].GridView.DataController.CollapseDetails;
    end
    else
      iGrid.Levels.Items[i].GridView.DataController.Groups.FullExpand;
  end;

end;

procedure ImprimirGrid(iGrid: TcxGrid; Titulo: String; ExpandirGrupos: Boolean = True; ExpandirDetalhes: Boolean = False; RecolherApos: Boolean = False);
var
  xBool: Boolean;
begin
  try
    xBool := False;

    if not Assigned(iGrid) then
      Exit;

    if not Assigned(_dxCompPrinterGrid) then
    begin
      xBool := True;
      _dxCompPrinterGrid := TdxComponentPrinter.Create(nil);
    end;

    if not Assigned(_dxCompPrinterCntLinkCnt) then
      _dxCompPrinterCntLinkCnt := TdxGridReportLink.Create(_dxCompPrinterGrid);

    try
      with _dxCompPrinterCntLinkCnt do
      begin
        if xBool then
        begin
          ComponentPrinter := _dxCompPrinterGrid;

          PrinterPage.PageHeader.CenterTextAlignY := taTop;
          PrinterPage.PageHeader.Font.Charset := DEFAULT_CHARSET;
          PrinterPage.PageHeader.Font.Color := clBlack;
          PrinterPage.PageHeader.Font.Name := 'Tahoma';
          PrinterPage.PageHeader.LeftTextAlignY := taTop;
          PrinterPage.PageHeader.RightTextAlignY := taTop;
          PrinterPage.PageHeader.Font.Size := 9;
          PrinterPage.PageHeader.Font.Style := [fsBold];

          PrinterPage.DMPaper := 9;
          PrinterPage.Footer := 6500;
          PrinterPage.Header := 6500;
          PrinterPage.Margins.Bottom := 7000;
          PrinterPage.Margins.Left := 14000;
          PrinterPage.Margins.Right := 10000;
          PrinterPage.Margins.Top := 24300;
          PrinterPage.Orientation := poLandscape;
          PrinterPage.PageFooter.CenterTextAlignY := taBottom;
          PrinterPage.PageFooter.LeftTextAlignY := taBottom;
          PrinterPage.PageFooter.RightTextAlignY := taBottom;
          PrinterPage.PageSize.X := 210000;
          PrinterPage.PageSize.Y := 297000;
          PrinterPage.ScaleMode := smFit;
          ReportDocument.CreationDate := 40974.358674918980000000 ;
          ShrinkToPageWidth := True;
          OptionsFormatting.UseNativeStyles := True;
          OptionsOnEveryPage.Footers := False;
          OptionsOnEveryPage.FilterBar := False;
          OptionsView.FilterBar := False;
          BuiltIn := True;
        end;

        OptionsExpanding.ExpandGroupRows := ExpandirGrupos;
        OptionsExpanding.ExpandMasterRows := ExpandirDetalhes;

        PrinterPage.PageHeader.CenterTitle.Clear;
        PrinterPage.PageHeader.CenterTitle.Add('ACHEI MEU VESTIDO');
        PrinterPage.PageHeader.CenterTitle.Add(Titulo);

        PrinterPage.PageFooter.leftTitle.Text := FormatDateTime('dd/MM/yyyy - hh:mm:ss', now);
        PrinterPage.PageFooter.CenterTitle.Text := 'AMVSystem 1.0';
        PrinterPage.PageFooter.RightTitle.Text := 'Página [Page #] de [Total Pages]';

        Component := iGrid;
      end;

      with _dxCompPrinterGrid do
      begin
        if xBool then
        begin
          CurrentLink := _dxCompPrinterCntLinkCnt;
          PreviewOptions.Caption := 'Visualizar Impress'#227'o';
          PreviewOptions.WindowState := wsMaximized;
          TimeFormat := 2;
        end;
        
        Preview(True,_dxCompPrinterCntLinkCnt);
      end;

      if RecolherApos then
        ExpandirGrid(iGrid,True);

    finally
    end;
  Except
    on e:exception do
      ShowMessage('Erro 2377e887: '+E.Message);
  end;
end;

function ParametroLinhaComando(pParam: string): boolean;
var
  i: integer;
  vresult: boolean;
begin
  vresult := false;
  if ParamCount > 0 then
  begin
    for i := 0 to ParamCount do
    begin
      if UPPERCASE(ParamStr(i)) = UpperCase(pParam) then
      begin
        vresult := true;
        Break;
      end;
    end;
  end;
  result := vResult;
end;

Function TRANSCREVER(serial_hd: String): String;
var
  no, no2 : integer;
begin
  result := '';
  no := 1;
  no2 := Length(serial_hd);
  while not (no = no2 + 1) do
  begin
    if Copy(serial_hd,no,1) = 'A' then
      result := result + '1';
    if Copy(serial_hd,no,1) = 'B' then
      result := result + '2';
    if Copy(serial_hd,no,1) = 'C' then
      result := result + '3';

    if Copy(serial_hd,no,1) = 'D' then
      result := result + '3';
    if Copy(serial_hd,no,1) = 'E' then
      result := result + '6';
    if Copy(serial_hd,no,1) = 'F' then
      result := result + '1';

    if Copy(serial_hd,no,1) = 'G' then
      result := result + '4';
    if Copy(serial_hd,no,1) = 'H' then
      result := result + '5';
    if Copy(serial_hd,no,1) = 'I' then
      result := result + '4';

    if Copy(serial_hd,no,1) = 'J' then
      result := result + '6';
    if Copy(serial_hd,no,1) = 'K' then
      result := result + '8';
    if Copy(serial_hd,no,1) = 'L' then
      result := result + '4';

    if Copy(serial_hd,no,1) = 'M' then
      result := result + '7';
    if Copy(serial_hd,no,1) = 'N' then
      result := result + '5';
    if Copy(serial_hd,no,1) = 'O' then
      result := result + '9';

    if Copy(serial_hd,no,1) = 'P' then
      result := result + '4';
    if Copy(serial_hd,no,1) = 'Q' then
      result := result + '8';
    if Copy(serial_hd,no,1) = 'R' then
      result := result + '7';

    if Copy(serial_hd,no,1) = 'S' then
      result := result + '5';
    if Copy(serial_hd,no,1) = 'T' then
      result := result + '0';
    if Copy(serial_hd,no,1) = 'U' then
      result := result + '3';

    if Copy(serial_hd,no,1) = 'V' then
      result := result + '2';
    if Copy(serial_hd,no,1) = 'W' then
      result := result + '0';
    if Copy(serial_hd,no,1) = 'X' then
      result := result + '6';

    if Copy(serial_hd,no,1) = 'Y' then
      result := result + '0';
    if Copy(serial_hd,no,1) = 'Z' then
      result := result + '7';

    if (Copy(serial_hd,no,1) = '1') or (Copy(serial_hd,no,1) = '2') or
    (Copy(serial_hd,no,1) = '3') or (Copy(serial_hd,no,1) = '4') or
    (Copy(serial_hd,no,1) = '5') or (Copy(serial_hd,no,1) = '6') or
    (Copy(serial_hd,no,1) = '7') or (Copy(serial_hd,no,1) = '8') or
    (Copy(serial_hd,no,1) = '9') or (Copy(serial_hd,no,1) = '0') then
       result := result + Copy(serial_hd,no,1);

    no := no + 1;
  end;
end;

Function SerialNumHD(FDrive:String) :String;
var
  Serial:DWord;
  DirLen,Flags: DWord;
  DLabel : Array[0..11] of Char;
begin
  try
    GetVolumeInformation(PChar(FDrive+':\'),dLabel,12,@Serial,DirLen,Flags,nil,0);
    Result := IntToHex(Serial,8);
  except
    Result :='';
  end;
end;

function RemoveCaracter(Texto: string; Caracter: string): string;
var
  x: integer;
  letra: string;
begin
  result := '';
  for x := 1 to length(texto) do
  begin
    letra := copy(texto, x, 1);
    if (letra <> Caracter) then
      Result := result + letra;
  end;

end;

Function E_Ano_Bissexto(Data : TDateTime): Boolean;
Var Ano, Mes, Dia : Word;
Begin
  DecodeDate(Data, Ano, Mes, Dia);
  Result := (Ano mod 4 = 0) and ((Ano mod 100 <> 0) or (Ano mod 400 = 0));
end;


Function DataValida(Data:String): TDate;
var
  Dia: String;
  Mes: String;
  Ano: String;
  StringCorrente: String;
  AnoBissexto: boolean;
  UltimoDiaMes: Integer;
begin
  StringCorrente := Data;
  Dia := copy(StringCorrente, 1, pos('/', StringCorrente) - 1);
  StringCorrente := copy(StringCorrente, pos('/', StringCorrente) + 1, length(StringCorrente));
  Mes := copy(StringCorrente, 1, pos('/', StringCorrente) - 1);
  Ano := copy(StringCorrente, pos('/', StringCorrente) + 1, length(StringCorrente));

  AnoBissexto := E_Ano_Bissexto(StrToDate('01/01/'+Ano));

  case StrToInt(Mes) of
    1: UltimoDiaMes := 31;
    2: begin
         if AnoBissexto then
           UltimoDiaMes := 29
         else
           UltimoDiaMes := 28;
       end;
    3: UltimoDiaMes := 31;
    4: UltimoDiaMes := 30;
    5: UltimoDiaMes := 31;
    6: UltimoDiaMes := 30;
    7: UltimoDiaMes := 31;
    8: UltimoDiaMes := 31;
    9: UltimoDiaMes := 30;
    10: UltimoDiaMes := 31;
    11: UltimoDiaMes := 30;
    12: UltimoDiaMes := 31;
  end;

  if StrToInt(Dia) > UltimoDiaMes then
    Dia := IntTostr(UltimoDiaMes);

  Result := StrToDate(Dia+'/'+Mes+'/'+Ano);

end;

Function Data_Ultimo_Dia_Mes(Data : TDateTime): TDateTime;
Var
  Mes : Array [1..12] of Byte;
  Dia : Integer;
Begin
  Mes[1] := 31;
  Mes[2] := 0;
  Mes[3] := 31;
  Mes[4] := 30;
  Mes[5] := 31;
  Mes[6] := 30;
  Mes[7] := 31;
  Mes[8] := 31;
  Mes[9] := 30;
  Mes[10] := 31;
  Mes[11] := 30;
  Mes[12] := 31;
  Dia := Mes[StrToInt(FormatDateTime('m', data))];
  If (Dia = 0) Then
    If E_Ano_Bissexto(Data) Then
      Dia := 29
    Else
      Dia := 28;
  Result := StrToDate(IntToStr(Dia)+ '/' + FormatDateTime('mm/yyyy', data));
End;

function iif(Comparacao:Boolean;Verdadeiro:Variant; Falso:Variant):Variant;
begin
  if Comparacao = true then
    result := Verdadeiro
  else
    result := Falso;
end;

function TrocaAcentos(Texto: string): string;
var
  x: integer;
  letra: string;
begin
  result := '';
  for x := 1 to length(texto) do
  begin
    letra := copy(texto, x, 1);

    if (letra = 'ã') or (letra = 'à') or (letra = 'á') or (letra = 'â') then
      letra := 'a'
    else
      if (letra = 'Ã') or (letra = 'À') or (letra = 'Á') or (letra = 'Â') then
        letra := 'A'
      else
        if (letra = 'é') or (letra = 'ê') then
          letra := 'e'
        else
          if (letra = 'É') or (letra = 'Ê') then
            letra := 'E'
          else
            if (letra = 'Í') then
              letra := 'I'
            else
              if (letra = 'í') then
                letra := 'i'
              else
                if (letra = 'õ') or (letra = 'ó') or (letra = 'ô') then
                  letra := 'o'
                else
                  if (letra = 'Õ') or (letra = 'Ó') or (letra = 'Ô') then
                    letra := 'O'
                  else
                    if (letra = 'Ú') then
                      letra := 'U'
                    else
                      if (letra = 'ú') then
                        letra := 'u'
                      else
                        if ((letra = 'ç')) then
                          letra := 'c'
                        else
                          if (letra = 'Ç') then
                            letra := 'C'
                          else
                            if (letra = 'º') then
                              letra := 'o.'
                            else
                              if (letra = 'ª') then
                                letra := 'a.'
                              else
                                if (letra = 'º') then
                                  letra := 'o.';

    Result := result + letra;
  end;

end;

function ApenasAlgarismos(Texto: string): string;
var
  x: integer;
  Letra: char;
begin
  result := '';
  for x := 1 to length(Texto) do
  begin
    Letra := Texto[x];
    if Letra in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then
      Result := result + letra;
  end;
end;

function AddZero(Variavel: string; Tamanho: integer): string;
begin
  Result := '';
  while Length(Variavel) < Tamanho do
    Variavel := '0' + Variavel;

  Result := Variavel;
end;

function NomeDiaSemana(Dia:string):string;
var
	NumeroDia:integer;
begin
	try
		if  Length(trim(dia)) > 1 then
			NumeroDia := DayOfWeek(StrtoDate(dia))
		else
			Numerodia := StrtoInt(Dia);

		case numerodia of
      1 : Result := 'Domingo';
      2 : Result := 'Segunda';
      3 : Result := 'Terça';
      4 : Result := 'Quarta';
      5 : Result := 'Quinta';
      6 : Result := 'Sexta';
      7 : Result := 'Sábado';
		end;
	except
		Result  := '';
	end;
end;

function EnviarEmailAutomatico( De: String;
                                Para: String;
                                ParaBcc: String;
                                Assunto: String;
                                Texto: String;
                                TextoHtml: TStringList;
                                Arquivo: String;
                                SMTP: String;
                                UsuarioID: String;
                                Senha: String;
                                ResponderPara: String = '';
                                Porta: String = '587';
                                RequerAutenticacao: Boolean = True;
                                UsarSSL: Boolean = False;
                                MetodoSSL: integer = 4;
                                ModoSSL: integer = 1;
                                UsarTipoTLS: integer = 1;
                                Host_Proxy: String = '';
                                Porta_Proxy: String = '';
                                User_Proxy: String = '';
                                Senha_Proxy: String = '';
                                ManterConectado: Boolean = False;
                                MsgLog: TStringList = nil): Boolean;
var
  arq: TextFile;
  i: integer;
  sNome, sEmail: string;
  ListaArquivo: Array of String;
  vIdMessage: TIdMessage;
  TextoMsg: TIdText;
  // enviar e-mail seguro
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  IdSASLLog: TIdSASLLogin;
  IdSASLMD5: TIdSASLCRAMMD5;
  IdSASLKey: TIdSASLSKey;
  IdSASLAnn: TIdSASLAnonymous;
  IdSASLExt: TIdSASLExternal;
  IdSASLOtp: TIdSASLOTP;
  IdSASLPla: TIdSASLPlain;
  IdUserPvd: TIdUserPassProvider;
  IdIOHandlerSocket1 : TIdIOHandlerSocket;
  IdSocksInfo1 : TIdSocksInfo;
  // gravar log
  viTentativasLogin: integer;
  vsPara, vsParaBcc: string; // [RPB] 10/10/2013
begin

  if Assigned(MsgLog) then
    MsgLog.Add('Iniciando configurações do servidor de e-mail: ' + Smtp);

  Result := False;

  if (UsuarioID = '') or
     (Senha = '') or
     (SMTP = '') or
     (De = '') or
     ((Para = '') and (ParaBcc = '')) then
  begin
    Exit;
  end;

  sNome  := ''; sEmail := '';

  if (Pos('<', De) > 0) and (Pos('>', De) > 0) then
  begin
    sNome  := Trim(Copy(De, 1, Pos('<', De)-1));
    sEmail := Trim(Copy(De, Pos('<', De)+1, Length(Copy(De, Pos('<', De)+1, Length(De)))-1));
  end;

  if Assigned(MsgLog) then
    MsgLog.Add('Conferindo parâmetros (01) do servidor de e-mail: ' + Smtp);

  // o componente so sera criado se nao existir
  if gIdSmtp = nil then
    gIdSmtp := TIdSMTP.Create(nil)
  ;

  if Assigned(MsgLog) then
    MsgLog.Add('Conferindo parâmetros (02) do servidor de e-mail: ' + Smtp);

  //gIdSmtp.OnStatus := DoStatusSmtp;
  //gIdSmtp.OnFailedRecipient := OnStatusFalhaSmtp;

  if Assigned(MsgLog) then
    MsgLog.Add('Conferindo parâmetros (03) do servidor de e-mail: ' + Smtp);

  vIdMessage := TIdMessage.Create(nil);
  IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  if Assigned(MsgLog) then
    MsgLog.Add('Conferindo parâmetros (04) do servidor de e-mail: ' + Smtp);

  // mecanismos de seguranca usados no SSL
  IdSASLLog := TIdSASLLogin.Create(nil);;
  IdSASLMD5 := TIdSASLCRAMMD5.Create(nil);;
  IdSASLKey := TIdSASLSKey.Create(nil);;
  IdSASLAnn := TIdSASLAnonymous.Create(nil);;
  IdSASLExt := TIdSASLExternal.Create(nil);;
  IdSASLOtp := TIdSASLOTP.Create(nil);;
  IdSASLPla := TIdSASLPlain.Create(nil);;

  IdUserPvd := TIdUserPassProvider.Create(nil);

  IdSocksInfo1 := TIdSocksInfo.create(nil);

//  IdIOHandlerSocket1 := TIdIOHandlerSocket.Create(nil);

  if Host_Proxy <> '' then
  begin
    IdIOHandlerSocket1.TransparentProxy:=IdSocksInfo1;
    gIdSmtp.IOHandler := IdIOHandlerSocket1;
    IdSocksInfo1.Host:= Host_Proxy; //the ip of the proxy
    IdSocksInfo1.Port:= StrToIntDef(Porta_Proxy,80);
    IdSocksInfo1.Username := User_Proxy;
    IdSocksInfo1.Password := Senha_Proxy;
  end;

  try
    if Assigned(MsgLog) then
    MsgLog.Add('Conferindo parâmetros (05) do servidor de e-mail: ' + Smtp);

    // [RPB] 10/10/2013
    Para := StringReplace(Para,',',';',[rfReplaceAll]);
    ParaBcc := StringReplace(ParaBcc,',',';',[rfReplaceAll]);

    vIdMessage.Recipients.Clear;
    vIdMessage.CCList.Clear;
    vIdMessage.FromList.Clear;

    // se existir ";" na lista, o sistema registra todos os e-mails individualmente
    // e nao todos na mesma linha como estava.
    // Fazendo todos em uma linha quando ocorre o erro em um deles, o restante fica
    // sem enviar.

    if Assigned(MsgLog) then
    MsgLog.Add('Conferindo parâmetros (06) do servidor de e-mail: ' + Smtp);

    if (Copy(Para,1,1) = ';') then
      Delete(Para,1,1);

    if (Pos(';',Para)>0) then
    begin
      repeat
        vsPara := Copy(Para,1,Pos(';',Para)-1);
        if vsPara <> '' then
        begin
          vIdMessage.CCList.Add;
          vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Address := vsPara; // Para quem vai
          vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Name    := Copy(vsPara,1,Pos('@',vsPara)-1);
          Delete(Para,1,Pos(';',Para)); // apaga o email anterior
        end;
      until Pos(';',Para) = 0;
      // registra o ultimo e-mail, nao pego no bloco acima
      if ((vsPara <> '') and (vsPara <> Para)) then
      begin
        vsPara := Para;
        vIdMessage.CCList.Add;
        vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Address := vsPara; // Para quem vai
        vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Name    := Copy(vsPara,1,Pos('@',vsPara)-1);
      end;
    end
    else
      vIdMessage.Recipients.EMailAddresses := Para;

    // [RPB] 10/10/2013
    // monta lista de copias do e-mail

    // se existir ";" na lista, o sistema registra todos os e-mails individualmente
    // e nao todos na mesma linha como estava.
    // Fazendo todos em uma linha quando ocorre o erro em um deles, o restante fica
    // sem enviar.
    if (Pos(';',ParaBcc)>0) then
    begin
      repeat
        vsParaBcc := Copy(ParaBcc,1,Pos(';',ParaBcc)-1);
        if vsParaBcc <> '' then
        begin
          vIdMessage.CCList.Add;
          vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Address := vsParaBcc; // Para quem vai
          vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Name    := Copy(vsParaBcc,1,Pos('@',vsParaBcc)-1);
          Delete(ParaBcc,1,Pos(';',ParaBcc)); // apaga o email anterior
        end;
      until Pos(';',ParaBcc) = 0;
      // registra o ultimo e-mail, nao pego no bloco acima
      if ((vsParaBcc <> '') and (vsParaBcc <> ParaBcc)) then
      begin
        vsParaBcc := ParaBcc;
        vIdMessage.CCList.Add;
        vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Address := vsParaBcc; // Para quem vai
        vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Name    := Copy(vsParaBcc,1,Pos('@',vsParaBcc)-1);
      end;
    end
    else if (ParaBcc <> '') then
      begin
        vsParaBcc := ParaBcc;
        vIdMessage.CCList.Add;
        vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Address := vsParaBcc; // Para quem vai
        vIdMessage.CCList.Items[vIdMessage.CCList.Count-1].Name    := Copy(vsParaBcc,1,Pos('@',vsParaBcc)-1);
      end;

    if (vIdMessage.Recipients.Count = 0) then
    begin
      vIdMessage.Recipients.EMailAddresses := vIdMessage.CCList.Items[0].Address;
      vIdMessage.CCList.Delete(0);
    end;

    if Assigned(MsgLog) then
      MsgLog.Add('Conferindo parâmetros (07) do servidor de e-mail: ' + Smtp);

    vIdMessage.FromList.Add;
    vIdMessage.FromList.Items[0].Address := De;
    if Trim(sNome) <> '' then
      vIdMessage.FromList.Items[0].Name := sNome;

    vIdMessage.From.Address := vIdMessage.From.Address;

    vIdMessage.ReplyTo.Clear;
    vIdMessage.ReplyTo.Add;
    if ResponderPara <> '' then
      vIdMessage.ReplyTo.Items[0].Address := ResponderPara
    else
      vIdMessage.ReplyTo.Items[0].Address := De;
//    vIdMessage.ReplyTo.Items[0].Address := De; // quem recebe a mensagem de resposta
    if Trim(sNome) <> '' then
      vIdMessage.ReplyTo.Items[0].Name := vIdMessage.Recipients.Items[0].Name; // quem recebe a mensagem de resposta

    vIdMessage.ReplyTo.EMailAddresses := vIdMessage.ReplyTo.EMailAddresses;

    vIdMessage.Priority                  := mpHighest;
    vIdMessage.Subject                   := Assunto;
    vIdMessage.CharSet                   := 'iso-8859-1';
    vIdMessage.Encoding                  := meMIME;
    vIdMessage.ContentType               := 'multipart/mixed';

    if Assigned(MsgLog) then
      MsgLog.Add('Conferindo parâmetros (08) do servidor de e-mail: ' + Smtp);

    if (Assigned(TextoHtml)) and (TextoHtml.Text <> '') then
    begin
      vIdMessage.Body.Assign(TextoHtml);
      TextoMsg  := TidText.Create(vIdMessage.MessageParts, TextoHtml);
      TextoMsg.ContentType := 'text/html';
      TextoMsg.Body.Text   := TextoHtml.Text;
    end
    else
      vIdMessage.Body.Text := Texto;

    if Arquivo <> '' then
    begin
//      ListaArquivo:= TextoSplit(Arquivo, ';');
      for i:= Low(ListaArquivo) to High(ListaArquivo) do
      begin
        TIdAttachmentFile.Create(vIdMessage.MessageParts, TFileName(ListaArquivo[i]));
        //TIdAttachment.Create (vIdMessage.MessageParts,'c:\temp\arq.doc'); // Exemplo
      end;
    end;

    if Assigned(MsgLog) then
      MsgLog.Add('Conferindo parâmetros (09) do servidor de e-mail: ' + Smtp);

    gIdSmtp.Host     := SMTP;
    gIdSmtp.Username := UsuarioID;
    gIdSmtp.Password := Senha;
    gIdSmtp.Port     := StrToIntDef(iif(Porta = '', '587', Porta), 587);
    gIdSmtp.ConnectTimeout := 20000;
    gIdSmtp.ReadTimeout := 20000;

    IdUserPvd.Username := gIdSmtp.Username;
    IdUserPvd.Password := gIdSmtp.Password;

    if Assigned(MsgLog) then
      MsgLog.Add('Conferindo parâmetros (10) do servidor de e-mail: ' + Smtp);

    // [RPB] 23/05/2013
    // requer autenticacao
    if RequerAutenticacao then
      gIdSmtp.AuthType := atDefault
    else
      gIdSmtp.AuthType := atNone;

    // [RPB] 27/05/2013
    if UsarSSL then
    begin
      gIdSmtp.AuthType := atDefault;
      gIdSmtp.IOHandler := IdSSL;
      IdSASLLog.UserPassProvider := IdUserPvd;
      IdSASLMD5.UserPassProvider := IdUserPvd;
      IdSASLKey.UserPassProvider := IdUserPvd;
      IdSASLOtp.UserPassProvider := IdUserPvd;
      IdSASLPla.UserPassProvider := IdUserPvd;

      gIdSmtp.SASLMechanisms.Clear;
      gIdSmtp.SASLMechanisms.Add.SASL := IdSASLMD5;
      gIdSmtp.SASLMechanisms.Add.SASL := IdSASLLog;
      gIdSmtp.SASLMechanisms.Add.SASL := IdSASLKey;
      gIdSmtp.SASLMechanisms.Add.SASL := IdSASLAnn;
      gIdSmtp.SASLMechanisms.Add.SASL := IdSASLExt;
      gIdSmtp.SASLMechanisms.Add.SASL := IdSASLOtp;
      gIdSmtp.SASLMechanisms.Add.SASL := IdSASLPla;

      // tipos de acesso a seguranca
      // 1=utNoTLSSupport  2=utUseImplicitTLS  3=utUseRequireTLS  4=utUseExplicitTLS;
      case UsarTipoTLS of
        1: gIdSmtp.UseTLS := utNoTLSSupport;
        2: gIdSmtp.UseTLS := utUseImplicitTLS;
        3: gIdSmtp.UseTLS := utUseRequireTLS;
        4: gIdSmtp.UseTLS := utUseExplicitTLS;
      end;

      IdSSL.Destination := gIdSmtp.Host+':'+IntToStr(gIdSmtp.Port);
      IdSSL.Host := gIdSmtp.Host;
      IdSSL.Port := gIdSmtp.Port;

      // MetodoSSL: 1=sslvSSLv2  2=sslvSSLv23  3=sslvSSLv3  4=sslvTLSv1
      case MetodoSSL of
        1: IdSSL.SSLOptions.Method := sslvSSLv2;
        2: IdSSL.SSLOptions.Method := sslvSSLv23;
        3: IdSSL.SSLOptions.Method := sslvSSLv3;
        4: IdSSL.SSLOptions.Method := sslvTLSv1;
      end;

      // ModoSSL: 1=sslmUnassigned  2=sslmClient  3=sslmServer  4=sslmBoth
      case ModoSSL of
        1: IdSSL.SSLOptions.Mode := sslmUnassigned;
        2: IdSSL.SSLOptions.Mode := sslmClient;
        3: IdSSL.SSLOptions.Mode := sslmServer;
        4: IdSSL.SSLOptions.Mode := sslmBoth;
      end;

      IdSSL.SSLOptions.VerifyMode := [];
      IdSSL.SSLOptions.VerifyDepth := 0;
    end;

    try
      if Assigned(MsgLog) then
        MsgLog.Add('Conectando servidor de e-mail: ' + Smtp);

      try
        if not gIdSmtp.Connected then
        begin
          viTentativasLogin := 1;
          while not gIdSmtp.Connected do
          begin
            gIdSmtp.Connect;
            if gIdSmtp.Connected then Continue;
            if Assigned(MsgLog) then
              MsgLog.Add('Não foi possível se conectar ao servidor. Tentando novamente: [ ' + IntToStr(viTentativasLogin) + '/3 ] ');
            viTentativasLogin := viTentativasLogin + 1;
            if viTentativasLogin > 3 then
            begin
              Result := False;
              Exit;
            end;
          end;
        end
        else
          Sleep(200); // tempo de espera para atualizar a conexao com o servidor
      except
        on E: Exception do
        begin
          if Assigned(MsgLog) then
            MsgLog.Add('Erro de conexão ao servidor de e-mail: ' + Smtp);
          if Assigned(MsgLog) then
            MsgLog.Add( E.Message );
          Result := False;
          Exit;
        end;
      end;

      // [RPB] 23/05/2013
      if RequerAutenticacao then
      begin
        if Assigned(MsgLog) then
        begin
          MsgLog.Add('Autenticando usuário: ' + UsuarioId + ' no servidor de e-mail: ' + Smtp);
          gAutenticado := gIdSmtp.Authenticate;
        end;
      end;

      if gIdSmtp.Connected then
        try
          if Assigned(MsgLog) then
            MsgLog.Add('Enviando e-mail, por favor aguarde um instante...');
          gIdSmtp.Send(vIdMessage);
          Result := True;
          if Assigned(MsgLog) then
            MsgLog.Add('E-Mail enviado com sucesso!');
          Sleep(200);
        except
          on e:Exception do
          begin
            if Assigned(MsgLog) then
            begin
              MsgLog.Add('Falha ao tentar enviar E-Mail.');
              MsgLog.Add( E.Message );
            end;
            Result := False;
          end;
        end
      else
      begin
        Result := False;
        if Assigned(MsgLog) then
          MsgLog.Add('Não foi possível se conectar ao servidor de e-mail com as informações configuradas.');
        Sleep(200);
      end;

    except
      on E: Exception do
      begin
        if Assigned(MsgLog) then
        begin
          MsgLog.Add('Falha ao tentar enviar E-Mail.');
          MsgLog.Add( E.Message );
        end;
        Result := False;
      end;
    end;
  finally
    // se for para manter conectado nao desconecta e nao libera
    if not ManterConectado then
    begin
      if gIdSmtp.Connected then
      begin
        if Assigned(MsgLog) then
          MsgLog.Add('Desconectando servidor: ' + Smtp);
        gIdSmtp.Disconnect; // se conectado, desconecta
      end;
      FreeAndNil( gIdSmtp );
    end
    else
    begin
      if Assigned(MsgLog) then
        MsgLog.Add('Conexao mantida no servidor: ' + Smtp);
      Sleep(200);
    end;

    FreeAndNil( vIdMessage );
    FreeAndNil( IdSSL );
    FreeAndNil( IdSASLLog );
    FreeAndNil( IdSASLMD5 );
    FreeAndNil( IdSASLKey );
    FreeAndNil( IdSASLAnn );
    FreeAndNil( IdSASLExt );
    FreeAndNil( IdSASLOtp );
    FreeAndNil( IdSASLPla );
    FreeAndNil( IdUserPvd );
  end;
end;

function Split(Texto, TextoCoringa: String; IncluirVazios: Boolean = False): StringArray;
var
  Indice, Tamanho, OffSet: Integer;
  Aux: String;
begin
  try
    try
      Tamanho := 0;

      OffSet := Length(TextoCoringa);

      Indice := Pos(TextoCoringa, Texto);

      while Indice > 0 do
      begin
        Aux := Copy(Texto, 1, Indice - 1);

        if (Trim(Aux) <> '') or IncluirVazios then
        begin
          Tamanho := Tamanho + 1;

          SetLength(Result, Tamanho);

          Result[Tamanho - 1] := Aux;
        end;

        Texto := Copy(Texto, Indice + Offset, Length(Texto));

        Indice := Pos(TextoCoringa, Texto);
      end;

      if (Trim(Texto) <> '') and (Trim(Texto) <> TextoCoringa)
          or ((Length(Texto) > 0) and IncluirVazios) then
      begin
        SetLength(Result, Tamanho + 1);
        Result[Tamanho] := Texto;
      end;
    except
      on E: Exception do
        ShowMessage('Erro 01214: '+E.Message);
    end;
  finally

  end;
end;

function NomeMes(Mes:integer):string;
var
	ambMeses : array [0..12] of string;
begin
	try
		ambMeses[1] := 'Janeiro';
		ambMeses[2] := 'Fevereiro';
		ambMeses[3] := 'Marco';
		ambMeses[4] := 'Abril';
		ambMeses[5] := 'Maio';
		ambMeses[6] := 'Junho';
		ambMeses[7] := 'Julho';
		ambMeses[8] := 'Agosto';
		ambMeses[9] := 'Setembro';
		ambMeses[10] := 'Outubro';
		ambMeses[11] := 'Novembro';
		ambMeses[12] := 'Dezembro';
		Result := AmbMeses[mes];
	except
		on e:Exception do
      ShowMessage('Erro 1524: '+E.Message);
	end;
end;

procedure ExpandViewGroups(AView: TcxGridTableView; ALevel: Integer = 1000);

var

  I: Integer;

begin

  AView.BeginUpdate;

  try

    ALevel := AView.DataController.Groups.GroupingItemCount-1 ;

    AView.DataController.Groups.FullExpand;

    for I := AView.DataController.RowCount - 1 downto 0 do
    begin

      if AView.DataController.GetRowInfo(I).Level >= ALevel then
      begin
        AView.DataController.Groups.ChangeExpanding (i, True, True);
        AView.DataController.Groups.ChangeExpanding (i, False, False);
      end;

    end;
  finally

    AView.EndUpdate;

  end;

end;

function UltimoDiaMes(Data:string):string;
var nDia, nMes, nAno:Word;
		dDataAux:TDate;
begin
	DecodeDate( StrToDate(Data), nAno, nMes, nDia);
	nAno				:= iif( nmes=12, nAno + 1, nAno);
	nmes 				:= iif( nmes=12, 1, nmes + 1);
	dDataAux 		:= EncodeDate(nAno, nMes, 1) - 1;
	Result 			:= DateToStr(dDataAux);
end;


end.

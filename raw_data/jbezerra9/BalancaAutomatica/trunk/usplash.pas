unit usplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls,IniFiles, FMTBcd, DB,
  SqlExpr, Utransacao,IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, AppEvnts,ACBrBase, ACBrMail, IdIPWatch, IdBaseComponent;

type
  TFSplash = class(TForm)
    sqlcon2: TSQLQuery;
    Sqlterminal: TSQLQuery;
    pnlemail: TPanel;
    Image1: TImage;
    Label1: TLabel;
    edusu: TEdit;
    Label2: TLabel;
    edsen: TEdit;
    Btcancela: TSpeedButton;
    btok: TSpeedButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure BtcancelaClick(Sender: TObject);
    procedure btokClick(Sender: TObject);
    procedure edusuKeyPress(Sender: TObject; var Key: Char);
    procedure edsenKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    trans : TTransacao;
    sLogErro_Empresa : String;
    sLogErro_CNPJ : String;
    sLogErro_Endereco : String;
    sLogErro_RazaoSocial  : String;
    sLogErro_INSC  : String;
    sLogErro_FONE  : String;
    sLogErro_FONE2 : String;
    bEnviandoEmail : Boolean;
    bErroEmail : Boolean;
    INI : TIniFile;
    
    function LiberaSistema : Boolean;
    procedure AbreSistema;
  public
    { Public declarations }
    ArqINI : string;
    function NomeDoComputador : String;
  end;

var
  FSplash: TFSplash;
  senha , nome : string;
  function Tirabarras(valor : string) : string;
  function Criptografar(valor: string) : string;
  function Descriptografar(valor : string): string;

implementation

uses uprinc, umodulo, StrUtils, uFuncoes, ulibsis, uMensagem, uselecionaprod;

{$R *.dfm}

function Tirabarras(valor : string) : string;
var letras : string;
    x : integer;
begin
     letras:= '';
     for x:=1 to length(valor) do
     begin
          if copy(valor,x,1) <> '/' then
               letras := letras + copy(valor,x,1);
          copy(valor,x,1);
     end;
     result := letras;
end;

function Criptografar(valor: string) : string;
var letras : string;
    x: integer;
begin
     letras := '';
     for x:=1 to length(valor) do
     begin
          if copy(valor,x,1) = '1' then
               letras := letras +'Z'
          else if copy(valor,x,1) = '2' then
               letras := letras +'C'
          else if copy(valor,x,1) = '3' then
               letras := letras + 'K'
          else if copy(valor,x,1) = '4' then
               letras := letras + 'M'
          else if copy(valor,x,1) = '5' then
               letras := letras + 'L'
          else if copy(valor,x,1) = '6' then
               letras := letras + 'J'
          else if copy(valor,x,1) = '7' then
               letras := letras + 'V'
          else if copy(valor,x,1) = '8' then
               letras := letras + 'Y'
          else if copy(valor,x,1) = '9' then
               letras := letras + 'W'
          else if copy(valor,x,1) = '0' then
               letras := letras + '*'
          else if copy(valor,x,1) = '/' then
               letras := letras + '#';
     end;
     result := letras;
end;

function Descriptografar(valor : string): string;
var letras : string;
    x : integer;
begin
     letras := '';
     for x := 1 to length(valor) do
     begin
          if copy(valor,x,1) = 'Z' then
               letras := letras + '1'
          else if copy(valor,x,1) = 'C' then
               letras := letras + '2'
          else if copy(valor,x,1) = 'K' then
               letras := letras + '3'
          else if copy(valor,x,1) = 'M' then
               letras := letras + '4'
          else if copy(valor,x,1) = 'L' then
               letras := letras + '5'
          else if copy(valor,x,1) = 'J' then
               letras := letras + '6'
          else if copy(valor,x,1) = 'V' then
               letras := letras + '7'
          else if copy(valor,x,1) = 'Y' then
               letras := letras + '8'
          else if copy(valor,x,1) = 'W' then
               letras := letras + '9'
          else if copy(valor,x,1) = '*' then
               letras := letras + '0'
          else if copy(valor,x,1) = '#' then
               letras := letras + '/';
     end;
     result := letras;
end;

procedure TFSplash.FormKeyPress(Sender: TObject; var Key: Char);
begin

     if Key = #27 then
          Close;
end;

procedure TFSplash.FormShow(Sender: TObject);
begin
     LiberaSistema;
end;

procedure TFSplash.BtcancelaClick(Sender: TObject);
begin
     close;
end;

procedure TFSplash.btokClick(Sender: TObject);
begin
     sqlcon2.Close;
     sqlcon2.SQL.Text := 'SELECT * FROM TBUSUARIO'+
          ' WHERE USU_NOME = '+ QuotedStr(edusu.Text) +
          ' AND USU_SENHA = '+ QuotedStr(edsen.Text);
     sqlcon2.Open;

     if sqlcon2.IsEmpty then
     begin
          try
               Application.CreateForm(tFrMensagem,FrMensagem);
               FrMensagem.sMensagem := 'Usuário ou senha inválidos !';
               FrMensagem.pnlMensagem.Font.Size := 30;
               FrMensagem.ShowModal();
          finally
               FreeAndNil(FrMensagem);
          end;

          edusu.SetFocus;
          Exit;
     end;

     AbreSistema;
end;

procedure TFSplash.edusuKeyPress(Sender: TObject; var Key: Char);
begin
     if key = #13 then
     begin
          key := #0;
          Edsen.setfocus;
     end;
end;

procedure TFSplash.edsenKeyPress(Sender: TObject; var Key: Char);
begin
     if key = #13 then
     begin
          key := #0;
          btokClick(Self);
     end;
end;

procedure TFSplash.AbreSistema;
label FinalizaSistema;
var
     sPerfilAberto : String;
begin
     codUsuario:= sqlcon2.FieldByName('usu_codigo').AsInteger;
     nomUsuario:= sqlcon2.FieldByName('USU_NOME').AsString;

     sAcessoUsuario := sqlcon2.FieldByName('USU_NOME').AsString;
     sAcessoSenha   := sqlcon2.FieldByName('USU_SENHA').AsString;
     sUserFunc      := sqlcon2.FieldByName('FUNCIONARIO').AsString;

     if (Parametro('CAIXA_POR_FUNCIONARIO') = 'S')
     and (sqlcon2.FieldByName('NCAIXA').AsString <> '') then
     begin
          codCaixa := sqlcon2.FieldByName('NCAIXA').AsString;

          sqlcon2.Close;
          sqlcon2.SQL.Text := 'select id, micro_abertura'+
                              ' from tbcaixa where aberto = ''S''' +
                              ' and cod_caixa = ' + QuotedStr(codCaixa);
          sqlcon2.Open;

          if (sqlcon2.FieldByName('micro_abertura').AsString <> '')
          and (sqlcon2.FieldByName('micro_abertura').AsString <> NomeDoComputador) then
          begin
               try
                    Application.CreateForm(tFrMensagem,FrMensagem);
                    FrMensagem.sMensagem := 'O caixa desse usuário já está aberto no computador: ' + sqlcon2.FieldByName('micro_abertura').AsString;
                    FrMensagem.pnlMensagem.Font.Size := 23;
                    FrMensagem.ShowModal();
               finally
                    FreeAndNil(FrMensagem);
               end;

               goto FinalizaSistema;
          end;

          sqlcon2.Close;
     end
     else
     begin
          codCaixa := INI.ReadString('Caixa','CodCaixa','');
     end;

     try
          Application.CreateForm(TfSelecionaProd, fSelecionaProd);
          fSelecionaProd.ShowModal;
     finally

          try FreeAndNil(fSelecionaProd); except; end;
     end;

     FinalizaSistema :

     Close;
end;

procedure TFSplash.FormCreate(Sender: TObject);
var
    sql : String;
begin
     ArqINI := 'c:\ParamBBi\ParamBBi.ini';

     if FileExists(ArqINI) then
     begin
          INI  := TIniFile.Create(ArqINI);
     end;

     sqlcon2.Close;
     sqlcon2.SQL.Text := 'SELECT * FROM TBUSUARIO'+
          ' WHERE USU_NOME = '+ QuotedStr(edusu.Text) +
          ' AND USU_SENHA = '+ QuotedStr(edsen.Text);
     sqlcon2.Open;
     //if (not dm.tbusuario.Locate('USU_NOME;USU_SENHA', VarArrayOf([edusu.Text, edsen.Text]), [])) then
     if sqlcon2.IsEmpty then
     begin
          edusu.Text := '';
          edsen.Text := '';
     end
     else
     if LiberaSistema then
     begin
          FSplash.tag := 1;
          AbreSistema;
     end;
end;

function TFSplash.LiberaSistema: Boolean;
label Link_Senha, Link_Tentativa;
var
     config : TIniFile;
     dataultb, dataprob, mes : string;
     pSenha : String;
     Nav : TIdHTTP;
     iTentativa : Integer;
     sLink : String;
     sLinkParametro : String;
     sRetorno : String;
     sDataVenc : String;
     sDataWind : String;
     iAtualizaConfig : Integer;
     bSistema : Boolean;
begin
     bSistema := True;
     //Verifica se existe o arquivo de testes para não fazer a atualização do config online
     if FileExists('c:\ParamBBi\BBITestes') then
          iAtualizaConfig := 0
     else
          iAtualizaConfig := Parametro('ATUALIZA_CONFIG_ONLINE');

     if iAtualizaConfig > 0 then
     begin
          iTentativa := 1; //Inicia como 1ª tentativa, volta usando GoTo e vai até 3 tentativas

          Link_Tentativa:

          try
               Link_Senha:

               //sLink := 'http://bbisenhas.ddns.net:4040/ws_senha/rest/bitbyte/cliente/datavenc/get/'+ RetirarCaracter(Parametro('CNPJ'));
               case iTentativa of
                    1 : sLinkParametro := Parametro('LINK_ATUALIZACAO_CONFIG'); //Link no-ip
                    2 : sLinkParametro := Parametro('LINK_2_ATUALIZACAO_CONFIG'); //Link Winco DDNS
                    3 : sLinkParametro := Parametro('LINK_RESERVA_ATUALIZACAO_CONFIG'); //Link Winco DDNS (ip externo)
               end;
               sLink := sLinkParametro + RetirarCaracter(Parametro('CNPJ'));
               Nav := TIdHTTP.Create(nil);
               Nav.Request.Host := sLink;
               Nav.Request.CacheControl := 'no-cache';
               Nav.ReadTimeout := iAtualizaConfig; //Tempo máximo de espera por resposta (padrão 1 segundo)

               //Retorno da consulta
               Try
                    sRetorno := Nav.Get(sLink);
               except
                    on e:Exception do
                    begin
                         bSistema := False;
                     //    Application.MessageBox(PChar(e.Message),'Erro ao atualizar.',MB_ICONERROR);

                    end;
               End;

               if sRetorno <> 'Cliente nao encontrado!' then
               begin
                    {Separa o conteúdo retornado, ex: 30/08/2018-27/08/2018
                    - a primeira data é o vencimento
                    - a segunda data é a data atual do windows no servidor de senha}
                    sDataVenc := Copy(sRetorno, 1,10);
                    StrToDate(sDataVenc); //Valida data

                    sDataWind := Copy(sRetorno, 12,10);
                    {Verifica se recebeu da data do servidor de senha
                    e se o Link esta desatualizado}
                    if (sDataWind = '') and (RightStr(sLinkParametro,2) <> '1/') then
                    begin
                         //Altera o Link para obter a data de vencimento + a data do servidor de senha
                         case iTentativa of
                              1 : SetParametro('LINK_ATUALIZACAO_CONFIG', sLinkParametro + '1/');
                              2 : SetParametro('LINK_2_ATUALIZACAO_CONFIG', sLinkParametro + '1/');
                              3 : SetParametro('LINK_RESERVA_ATUALIZACAO_CONFIG', sLinkParametro + '1/');
                         end;
                         goto Link_Senha; //Retorna para acessar o Link atualizado
                    end;
               end
               else
               begin
                         sDataVenc := '';
                         iTentativa := 4; //Como não encontrou o cliente no banco de dados da Bitbyte, encerra as tentativas
               end;
          except
               sDataVenc := '';
          end;

          //Se Data for vazia e o nº de tentativas for menor que 3, volta para consulta outro Link
          if (sDataVenc = '') and (iTentativa < 3) then
          begin
               Inc(iTentativa); //Incrementa a tentativa (limite de 3 tentativas)
               goto Link_Tentativa; //Retorna para realizar uma nova tentativa com o próximo Link
          end;

          if Nav <> nil then
               FreeAndNil(Nav);
     end
     else
          sDataVenc := '';

    { if bSistema = False then
     begin
           try
               Application.CreateForm(tFrMensagem,FrMensagem);
               FrMensagem.sMensagem := 'Erro ao logar com o Servidor "senha" , entre em contato com a Bitbyte.';
               FrMensagem.pnlMensagem.Font.Size := 20;
               FrMensagem.ShowModal();
           finally
               FreeAndNil(FrMensagem);
           end;

          PostMessage(self.Handle, WM_CLOSE, 0, 0);
          Exit;
     end;   }

     pSenha := Parametro('Senha');
     if (pSenha = '1') or (pSenha = '') then
     begin
          Result := False;

          if not(fileexists(extractfilepath(application.exename) + 'config.ini')) then
          begin
               try
                    Application.CreateForm(tFrMensagem,FrMensagem);
                    FrMensagem.sMensagem := 'Para utilizar o sistema entrar em contato com bitbyte !';
                    FrMensagem.pnlMensagem.Font.Size := 30;
                    FrMensagem.ShowModal();
               finally
                    FreeAndNil(FrMensagem);
               end;

               Close;
          end;
          config  := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
          dataultb:= Descriptografar(config.ReadString('config','b',dataultb));
          dataprob:= Descriptografar(config.ReadString('config','p',dataprob));
          senha   := Descriptografar(config.ReadString('config','s',senha));

          //Verifica se pegou a senha do servidor da Bitbyte, e atualiza o arquivo Config.ini
          if (sDataVenc <> '') then // and (StrToDate(sDataVenc) <> StrToDate(dataprob)) then
          begin
               try
                    //Valida data recebida do servidor de senha
                    StrToDate(sDataWind);
                    dataultb := FormatDateTime('dd/mm/yy', StrToDate(sDataWind));
               except
                    //Em caso de erro, usa a própria data do Windows
                    dataultb := FormatDateTime('dd/mm/yy', Date);
               end;
               dataprob := FormatDateTime('dd/mm/yy', StrToDate(sDataVenc));
               senha    := IntToStr(StrToInt(Tirabarras(dataprob)) * 11);
               config.WriteString('config','b',Criptografar(dataultb));
               config.WriteString('config','p',Criptografar(dataprob));
               config.WriteString('config','s',Criptografar(senha));
          end;

          datasenha := dataprob;

          //Se a data do Windows for menor que a data da atualização (linha B) do Config.ini
          if StrToDate(FormatDateTime('dd/mm/yy',Date)) < StrToDate(dataultb) then
          begin
               try
                    Application.CreateForm(tFrMensagem,FrMensagem);
                    FrMensagem.sMensagem := 'Data do Windows deve estar incorreta !';
                    FrMensagem.pnlMensagem.Font.Size := 30;
                    FrMensagem.ShowModal();
               finally
                    FreeAndNil(FrMensagem);
               end;

               Application.Terminate;
          end;

          //Se a data da senha for menor ou igual a data do Windows
          if StrToDate(dataprob) <= StrToDate(FormatDateTime('dd/mm/yy',Date))then
          begin
              config.WriteString('config','b',Criptografar(dataprob));
              Application.CreateForm(TFLibsis,FLibsis);
              FLibsis.ShowModal;

              if FLibsis.Tag = 0 then
              begin
                  Application.Terminate;
                  Exit;
              end;
              dataprob := FormatDateTime('dd/mm/yy',IncMonth(StrToDate(dataprob),1));
              senha    := IntToStr(StrToInt(Tirabarras(dataprob))*11);
              config.WriteString('config','p',Criptografar(dataprob));
              config.WriteString('config','s',Criptografar(senha));
          end;
          Result := True;
     end
     else
     if pSenha = '2' then
     begin
          Result := False;
          if not(fileexists(extractfilepath(application.exename) + 'config.ini')) then
          begin
               try
                    Application.CreateForm(tFrMensagem,FrMensagem);
                    FrMensagem.sMensagem := 'Para utilizar o sistema entrar em contato com a bitbyte !';
                    FrMensagem.pnlMensagem.Font.Size := 30;
                    FrMensagem.ShowModal();
               finally
                    FreeAndNil(FrMensagem);
               end;

               close;
          end;
          config  := tinifile.create(extractfilepath(application.exename)+'config.ini');
          dataultb:= descriptografar(config.readstring('config','b',dataultb));
          dataprob:= descriptografar(config.readstring('config','p',dataprob));
          senha   := descriptografar(config.readstring('config','s',senha));
          mes     := config.readstring('config','m',mes);

          //Verifica se pegou a senha do servidor da Bitbyte, e atualiza o arquivo Config.ini
          if (sDataVenc <> '') then // and (StrToDate(sDataVenc) <> StrToDate(dataprob)) then
          begin
               try
                    //Valida data recebida do servidor de senha
                    StrToDate(sDataWind);
                    dataultb := FormatDateTime('dd/mm/yy', StrToDate(sDataWind));
               except
                    //Em caso de erro, usa a própria data do Windows
                    dataultb := FormatDateTime('dd/mm/yy', Date);
               end;
               dataprob := FormatDateTime('dd/mm/yy', StrToDate(sDataVenc));
               senha    := IntToStr(StrToInt(Tirabarras(dataprob)) * strtoint(mes));
               config.WriteString('config','b',Criptografar(dataultb));
               config.WriteString('config','p',Criptografar(dataprob));
               config.WriteString('config','s',Criptografar(senha));
          end;

          datasenha := dataprob;

          //Se a data do Windows for menor que a data da atualização (linha B) do Config.ini
          if strtodate(formatdatetime('dd/mm/yy',date)) < strtodate(dataultb) then
          begin
               try
                    Application.CreateForm(tFrMensagem,FrMensagem);
                    FrMensagem.sMensagem := 'Data do Windows deve estar incorreta !';
                    FrMensagem.pnlMensagem.Font.Size := 30;
                    FrMensagem.ShowModal();
               finally
                    FreeAndNil(FrMensagem);
               end;

               application.terminate;
          end;

          //Se a data da senha for menor ou igual a data do Windows
          if strtodate(dataprob) <= strtodate(formatdatetime('dd/mm/yy',date))then
          begin
              config.writestring('config','b',criptografar(dataprob));
              application.createform(tflibsis,flibsis);
              flibsis.showmodal;
              if flibsis.tag = 0 then
              begin
                  application.terminate;
                  exit;
              end;

              dataprob := formatdatetime('dd/mm/yy',incmonth(strtodate(dataprob),1));
              senha := inttostr(strtoint(tirabarras(dataprob))* strtoint(mes));
              config.writestring('config','p',criptografar(dataprob));
              config.writestring('config','s',criptografar(senha));
              Result := True;
          end;
     end;
end;

function TFSplash.NomeDoComputador : String;
var
     buffer: Array[0..255] of char;
     size: DWord;
begin
     size := 256;
     if GetComputerName (buffer,size) then
          Result := Buffer
     else
          Result := '';
end;

end.

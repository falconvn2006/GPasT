unit Controle.Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniButton, uniLabel, uniEdit,
  uniMultiItem, uniComboBox, uniDBComboBox, uniDBLookupComboBox,
  IdHashMessageDigest, uniScreenMask, uniBasicGrid, uniDBGrid,
  Vcl.Imaging.pngimage, uniImage, Data.FireDACJSONReflect, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, uniPanel, MidasLib,   uniGUIVars, uniTimer, unimTimer, uniBitBtn, 
   uniSpeedButton, uniSweetAlert;

type
  TControleLogin = class(TUniLoginForm)
    LoginBotaoEntrar: TUniButton;
    EditUsuario: TUniEdit;
    EditSenha: TUniEdit;
    UniLabel3: TUniLabel;
    UniScreenMask1: TUniScreenMask;
    UniLabel1: TUniLabel;
    UniImage1: TUniImage;
    procedure LoginBotaoEntrarClick(Sender: TObject);
    procedure UniLoginFormCreate(Sender: TObject);
    procedure EditSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure UniLabel1Click(Sender: TObject);
    procedure UniImage1Click(Sender: TObject);

  private
    { Private declarations }
    procedure ConfirmaLogin;
    procedure DCallback1(Sender: TComponent; res: Integer);
    procedure DCallback2(Sender: TComponent; res: Integer);
    procedure MensageiroSweetAlertaLogin(Titulo, Texto: string;
      tipoAlerta: tAlertType= atError);
    procedure LerINI;
  public
    MensageiroSweetAlert : TUniSweetAlert;
    { Public declarations }
  end;

function ControleLogin: TControleLogin;

implementation

{$R *.dfm}

uses
  Controle.Main.Module,Controle.Main,  uniGUIApplication, System.IniFiles, Controle.Server.Module;

function ControleLogin: TControleLogin;
begin
  Result := TControleLogin(ControleMainModule.GetFormInstance(TControleLogin));
end;

procedure TControleLogin.LoginBotaoEntrarClick(Sender: TObject);
var
  TipoBrowser: string;
begin
  if EditUsuario.Text = '' then
  begin
    EditUsuario.SetFocus;
    MensageiroSweetAlertaLogin('Atenção', 'Informe seu nome de usuário');
    Exit;
  end;

  if EditSenha.Text = '' then
  begin
    MensageiroSweetAlertaLogin('Atenção', 'Informe sua senha');
    EditSenha.SetFocus;
    Exit;
  end;

  TipoBrowser :=  UniApplication.ClientInfoRec.BrowserType;
  if TipoBrowser = '' then
  begin
    MensageiroSweetAlertaLogin('Atenção', 'Para uma melhor fluidez, utilize o Google Chrome ou firefox!');
  end;

  ConfirmaLogin;
end;

procedure TControleLogin.DCallback1(Sender: TComponent; res :Integer);
begin
  UniSession.UrlRedirect('https://controle.i9sisistemas.com.br')
end;

procedure TControleLogin.DCallback2(Sender: TComponent; res :Integer);
begin
  UniSession.UrlRedirect('https://clinica.i9sisistemas.com.br')
end;

procedure TControleLogin.ConfirmaLogin;
var
  MD5: TIdHashMessageDigest5;
  Senha : String;
  NCaixa, verificaCaixaFechadoDeHojeParaUsuario : integer;
  SchemaUsuario : string;
  UrlLogin, UrlControle, UrlClinica : string;
begin
  // Encripta a senha em Hash MD5
  MD5 := TIdHashMessageDigest5.Create;
  try
    Senha := MD5.HashStringAsHex(EditSenha.Text);
  finally
    MD5.Free;
  end;

  // Verifica o usuário
  if ControleMainModule.ValidandoUsuario(Trim(EditUsuario.Text),
                                         Trim(Senha)) = True then
  begin
    //verifica em qual link o usuario tem permissão de acesso e redireciona se preciso.
    UrlClinica  := 'https://clinica.i9sisistemas.com.br/clinica.dll';
    UrlControle := 'https://controle.i9sisistemas.com.br/controle.dll';
    UrlLogin := UniApplication.UniSession.URL;
    SchemaUsuario := Copy(ControleMainModule.CdsUsuario.FieldByName('schema').AsString,1,7);

    if UrlLogin <> 'http://localhost:8777/' then
    begin
      if UrlLogin = UrlClinica then
      begin
        if SchemaUsuario <> 'CLINICA' then
        begin
              MessageDlg('TENTATIVA INVÁLIDA!' + #13+
                      'Você tentou logar no sistema I9G(GESTOR)' + #13+
                      'porem acessou o link do sistema I9C(CLINICA)' + #13+
                      'estamos redirecionando você para o link correto aguarde!',
                      mtinformation,
                      [mbOK],
                      DCallback1);
              exit;
        end;
      end
      else if UrlLogin =  UrlControle then
      begin
       if SchemaUsuario <> 'CONTROL' then
        begin
              MessageDlg('TENTATIVA INVÁLIDA!' + #13+
                      'Você tentou logar no sistema I9C(CLINICA)' + #13+
                      'porem acessou o link do sistema I9G(GESTOR)' + #13+
                      'estamos redirecionando você para o link correto aguarde!',
                      mtinformation,
                      [mbOK],
                      DCallback2);
               exit;
        end;
      end;
    end;

    ModalResult := mrOK; // Fecha o formulario de login e inicializa o main

    // Tentando conectar no banco selecionado
    Try
      if ControleMainModule.CdsUsuario.FieldByName('ativo').AsString = 'S' then
      begin
        if not ControleMainModule.Conectar(ControleMainModule.CdsUsuario.FieldByName('schema').AsString) then
        begin
         MensageiroSweetAlertaLogin('Atenção', 'Não é possível conectar com a base de dados');
        end
        else
        begin
          //carrega os parametros no sistema
          ControleMainModule.CdsParametros.Params.ParamByName('schema_usuario').Value := ControleMainModule.CdsUsuario.FieldByName('schema').AsString;
          ControleMainModule.CdsParametros.Open;

          if ControleMainModule.SelecionaFilial(ControleMainModule.FFilial) then
          begin
            ControleMain.LbUsuario.Caption := 'Bem vindo(a) ' + ControleMainModule.FNomeUsuario;
            ControleMain.LbNomeEmpresa.Caption := copy(ControleMainModule.FNomeFantasia,1,30);
//            ControleMain.LbPlano.Caption := 'Plano: ' + ControleMainModule.FPlano;
          end
          else
          begin
            MensageiroSweetAlertaLogin('Atenção', 'Filial não encontrada');
            Abort;
          end;

          // Verifica se o usuario tem algum caixa para o dia de hoje que esta fechado
          verificaCaixaFechadoDeHojeParaUsuario := ControleMainModule.VerificaCaixaFechadoDoDia(ControleMainModule.FUsuarioId,
                                                                                                Date());

          // Verifica se o usuario tem algum caixa para o dia de hoje que esta fechado
          if verificaCaixaFechadoDeHojeParaUsuario > 0 then
          begin
            NCaixa := ControleMainModule.VerificaNumeroCaixaAberto(ControleMainModule.FUsuarioId);
            // Reabrindo o caixa fechado
            ControleMainModule.ReabreCaixa(verificaCaixaFechadoDeHojeParaUsuario);
          end
          else
          begin
            NCaixa := ControleMainModule.VerificaNumeroCaixaAberto(ControleMainModule.FUsuarioId);

            // Verifica se o usuario tem algum caixa aberto
            if NCaixa <> 0 then
            begin
              // Fecha qualquer de dias anteriores aberto para o usuaio e abre um novo caixa
              ControleMainModule.FechaCaixaDiasAnteriores(ControleMainModule.FUsuarioId);

              // Abre o caixa caso esteja fechado para hoje
              if StrToDate(FormatDateTime('dd/mm/yyyy', ControleMainModule.FDataAbertura)) < Date() then
              begin
                if ControleMainModule.VerificaCaixaAberto(ControleMainModule.FUsuarioId) = true then
                begin
                  ControleMainModule.FechaCaixa(ControleMainModule.FUsuarioId);
                  ControleMainModule.CriaCaixa;
                end;
              end;

              ControleMainModule.FNumeroCaixaLogado :=  NCaixa;
            end
            else
            begin
              ControleMainModule.CriaCaixa;
            end;
          end;

          ControleMain.CarregandoMenu;
          ControleMain.CarregandoOpcoesInicio;
          ControleMainModule.UltimoLogin(ControleMainModule.FUsuarioId); //coloca horario que foi realizado o login no banco usuario

          // Verificando parametros do sistema
          //////////////////////////////////////////////////////////////////////////////
          with  ControleMainModule do
          begin
            // Juros
            if CdsParametros.Locate('campo','VALOR_JUROS',[])= True then
              percentual_juros := StrToFloatDef(CdsParametros.FieldByName('valor').AsString,0)
            else
              percentual_juros := 0;

            // Multa
            if CdsParametros.Locate('campo','VALOR_MULTA',[])= True then
              percentual_multa := StrToFloatDef(CdsParametros.FieldByName('valor').AsString,0)
            else
              percentual_multa := 0;

            // Se gera cada parcela dos titulos como o valor total (repete o valor entre parcelas , tag = 0), ou rateia o valor entre as
            // parcelas (tag = 1)
            if CdsParametros.Locate('campo','TIPO_GERACAO_TITULOS',[])= True then
              tipo_geracao_titulos := CdsParametros.FieldByName('valor').AsString
            else
              tipo_geracao_titulos := 'N';

            if CdsParametros.Locate('campo','NEGOCIAR_TITULO_VARIOS_CLIENTES',[])= True then
              negociar_titulo_varios_clientes := CdsParametros.FieldByName('valor').AsString
            else
              negociar_titulo_varios_clientes := 'N';

            // Liquida multiplos titulos no contas a receber
            if CdsParametros.Locate('campo','LIQUIDA_MULTIPLOS_TRECEBER',[])= True then
              PLiquidaMultiploReceber := CdsParametros.FieldByName('valor').AsString
            else
              PLiquidaMultiploReceber := 'N';

            // Liquida multiplos titulos no contas a pagar
            if CdsParametros.Locate('campo','LIQUIDA_MULTIPLOS_TPAGAR',[])= True then
              PLiquidaMultiploPagar := CdsParametros.FieldByName('valor').AsString
            else
              PLiquidaMultiploPagar := 'N';
          end;
          //////////////////////////////////////////////////////////////////////////////

          ///LEITURA DE ARQUIVO .INI
          if FileExists(ControleServerModule.StartPath + 'config.ini') then
            LerINI;
        end;
      end
      else
      begin
        MensageiroSweetAlertaLogin('Atenção', 'Usuário inativo');
        Exit;
      end;
    except
      on e:exception do
      begin
       MensageiroSweetAlertaLogin('Atenção', 'Não é possível conectar com a base de dados');
       Exit;
      end;
    End;
  end
  else
  begin
   MensageiroSweetAlertaLogin('Atenção', 'Usuário não encontrado para o módulo' + ControleMainModule.FSchema);
   Exit;
  end;
end;

procedure TControleLogin.EditSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    LoginBotaoEntrar.Click;
  end;
end;

procedure TControleLogin.UniImage1Click(Sender: TObject);
begin
  ShowMessage(UniApplication.UniSession.URL);
end;

procedure TControleLogin.UniLabel1Click(Sender: TObject);
var
  URL_WhatsApp,URL_Email: String;
begin
 { AlertaLogin.saMessage('Alterar senha', 'WhatsApp',' E-mail ', 0, atWarning,
    procedure(const ButtonClicked: TAButton)
              begin
                if ButtonClicked = abConfirm then
                begin
                   URL_WhatsApp := 'https://wa.me/55' + '81 991425896' + '?text='  + 'Preciso de suporte para a empresa ' + ControleMainModule.FNomeFantasia;
                   UniSession.AddJS('window.open('+'"'+ URL_WhatsApp + '"'+')');
                   Exit;
                end
                else
                begin
                  UniSession.AddJS('window.location.href = "mailto:sistemas@i9si.com.br?subject=Alterar Senha&body=ESCREVA%20SEU%20NOME%20COMPLETO%20É:"');
                  Exit;
                end;
              end,
              'Para alterar a senha entre em contato conosco pelo telefone (81)99142-7832 ou utilize uma das opções abaixo'
              );}
end;

procedure TControleLogin.UniLoginFormCreate(Sender: TObject);
begin
  UniSession.AddJS('document.body.style.background = ''url("./files/fundo_login.jpg") no-repeat center center fixed''');
  UniSession.AddJS('document.body.style.backgroundSize = "cover";');
end;

procedure TControleLogin.MensageiroSweetAlertaLogin(Titulo, Texto: string; tipoAlerta: tAlertType = atError);
begin
  // Essa função pode ser usada em qualquer tela
  try
    MensageiroSweetAlert := TUniSweetAlert.Create(UniApplication);
    With MensageiroSweetAlert do
    begin
      Text                := Texto;
      Title               := Titulo;
      AlertType           := tipoAlerta;
      ConfirmButtonText   := 'OK';
      Show;
    end;
  finally
    MensageiroSweetAlert.Free;
  end;
end;

procedure TControleLogin.LerINI;
var arquivoINI : TIniFile;
begin
  try
    arquivoINI := TIniFile.Create(ControleServerModule.StartPath + 'config.ini');
    ControleMainModule.FSchemaPdve := arquivoINI.ReadString('CONFIGURACAO','SchemaPdve','');

    arquivoINI.Free;
  except
    on E: Exception do
    begin
      Exit;
    end;
  end;
end;

initialization
  RegisterAppFormClass(TControleLogin);

end.

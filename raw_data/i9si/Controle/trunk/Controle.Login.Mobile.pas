unit Controle.Login.Mobile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUImClasses, uniGUIRegClasses, uniGUIForm, uniGUImForm, uniGUImJSForm,
  uniGUIBaseClasses, uniLabel, unimLabel, uniButton, unimButton, 
   uniScreenMask, Vcl.Imaging.pngimage, uniImage, uniEdit, unimImage,
  unimPanel, unimEdit, uniTimer, unimTimer;

type
  TControleLoginMobile = class(TUnimLoginForm)
    UniScreenMask1: TUniScreenMask;
    UniSFHold_Aguarde: TUniSFHold;
    AlertaLogin: TUniSFSweetAlert;
    UnimPanelLogin: TUnimPanel;
    UnimImageLogin: TUnimImage;
    UnimLabelIniciaSessao: TUnimLabel;
    EditUsuario: TUnimEdit;
    EditSenha: TUnimEdit;
    LoginBotaoEntrar: TUnimButton;
    UnimTimer1: TUnimTimer;
    procedure UnimTimer1Timer(Sender: TObject);
    procedure LoginBotaoEntrarClick(Sender: TObject);

  private
    procedure ConfirmaLogin;
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleLoginMobile: TControleLoginMobile;

implementation

{$R *.dfm}

uses
  uniGUIVars, Controle.Main, Controle.Main.Module, uniGUIApplication, IdHashMessageDigest;

function ControleLoginMobile: TControleLoginMobile;
begin
  Result := TControleLoginMobile(ControleMainModule.GetFormInstance(TControleLoginMobile));
end;



procedure TControleLoginMobile.LoginBotaoEntrarClick(Sender: TObject);
begin
  if EditUsuario.Text = '' then
  begin
    EditUsuario.SetFocus;
   ControleMainModule.MensageiroSweetAlerta('Atenção', 'Informe seu nome de usuário');
    Exit;
  end;

  if EditSenha.Text = '' then
  begin
   ControleMainModule.MensageiroSweetAlerta('Atenção', 'Informe sua senha');
    EditSenha.SetFocus;
    Exit;
  end;

  UniSFHold_Aguarde.MaskShow('Aguarde...',
                              procedure(const Mask:Boolean)
                              begin
                                ConfirmaLogin;
                              end
  );
end;

procedure TControleLoginMobile.UnimTimer1Timer(Sender: TObject);
begin
  UnimPanelLogin.left := trunc((self.width - UnimPanelLogin.width) / 2);
  UnimTimer1.interval := 100000;
 // UnimLabelIniciaSessao.left := 145;

 // alterando cor e tamanho da fonte
 {function beforeInit(sender, config)
{
  config.style="color: gray; font-size: 10px;"
}
end;

procedure TControleLoginMobile.ConfirmaLogin;
var
  MD5: TIdHashMessageDigest5;
  Senha: String;
//  NCaixa: integer;
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
    ModalResult := mrOK; // Fecha o formulario de login e inicializa o main

    // Tentando conectar no banco selecionado
    Try
      if ControleMainModule.CdsUsuario.FieldByName('ativo').AsString = 'S' then
      begin
        if not ControleMainModule.Conectar(ControleMainModule.CdsUsuario.FieldByName('schema').AsString) then
        begin
         ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não é possível conectar com a base de dados');
        end
        else
        begin
          ControleMainModule.SelecionaFilial(ControleMainModule.FFilial);
     //     ControleMain.LbUsuario.Caption := 'Bem vindo(a) ' + ControleMainModule.FNomeUsuario + ' ao I9 Controle';

       //   NCaixa := ControleMainModule.VerificaNumeroCaixaAberto(ControleMainModule.FUsuarioId);
         {
          // Verifica se o usuario tem algum caixa aberto
          if NCaixa <> 0 then
          begin
            // Verifica se o caixa é de hoje
            if StrToDate(FormatDateTime('dd/mm/yyyy', ControleMainModule.FDataAbertura)) < Date() then
            begin
              if ControleMainModule.VerificaCaixaAberto(NCaixa) = true then
              begin
                ControleMainModule.FechaCaixa(NCaixa);
                ControleMainModule.CriaCaixa;
              end;
            end;

            ControleMainModule.FNumeroCaixaLogado :=  NCaixa;
          end
          else
          begin
            ControleMainModule.CriaCaixa;
          end;

          ControleMain.CarregandoMenu;
          ControleMain.CarregandoOpcoesInicio;  }
        end;
      end
      else
      begin
       ControleMainModule.MensageiroSweetAlerta('Atenção', 'Usuário inativo');
      end;
    except
      on e:exception do
      begin
       ControleMainModule.MensageiroSweetAlerta('Atenção', 'Não é possível conectar com a base de dados');
      end;
    End;
  end
  else
  begin
   ControleMainModule.MensageiroSweetAlerta('Atenção', 'Usuário não encontrado para o módulo' + ControleMainModule.FSchema);
  end;
  UniSFHold_Aguarde.MaskHide;
end;

initialization
  RegisterAppFormClass(TControleLoginMobile);

end.

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniBasicGrid,
  uniDBGrid, uniDBNavigator, unimDBNavigator, uniButton, uniBitBtn,
  uniColorButton, uniMenuButton, uniEdit, uniDBEdit,
  uniSpeedButton, uniPanel, uniToolBar, uniImage, Vcl.Imaging.pngimage,
  uniPageControl, uniGUIFrame, uniStatusBar, System.ImageList, Vcl.ImgList,
  uniLabel, uniSplitter, uniScreenMask, uniChart, Vcl.Imaging.jpeg, uniURLFrame,
  uniSyntaxEditorBase, uniSyntaxEditor, uniCalendarPanel, uniCalendar, uniTimer,
  uniDateTimePicker, Data.Win.ADODB, Datasnap.Provider, Data.DB,
  Datasnap.DBClient, uniCanvas, uniRadioGroup, uniCheckBox, uniRadioButton,
  uniScrollBox, UniSFiGrowl, uniHTMLFrame, uniDBText,
  Vcl.ExtCtrls, uniMultiItem, uniComboBox, uniDBComboBox, uniDBLookupComboBox,
  UniSFHold,  ACBrValidador, IdHashMessageDigest, uniImageList, MidasLib;

type
  TMainForm = class(TUniForm)
    ImagemFundo: TUniImage;
    EditRazaoSocial: TUniEdit;
    EditUsuario: TUniEdit;
    EditCelular: TUniEdit;
    EditEmail: TUniEdit;
    EditSenha: TUniEdit;
    UniLabel1: TUniLabel;
    UniLabel3: TUniLabel;
    UniLabel6: TUniLabel;
    BotaoNovo: TUniButton;
    UniLabel7: TUniLabel;
    UniLabel8: TUniLabel;
    UniLabel9: TUniLabel;
    UniButton1: TUniButton;
    UniImage1: TUniImage;
    UniImage2: TUniImage;
    UniImage3: TUniImage;
    UniLabel10: TUniLabel;
    UniLabel11: TUniLabel;
    UniLabel12: TUniLabel;
    UniImage4: TUniImage;
    UniSFHold_Aguarde: TUniSFHold;
    UniSFiGrowl1: TUniSFiGrowl;
    UniSFiGrowl2: TUniSFiGrowl;
    EditSenhaRepete: TUniEdit;
    UniImageList1: TUniImageList;
    procedure UniFormScreenResize(Sender: TObject; AWidth, AHeight: Integer);
    procedure BotaoNovoClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniButton1Click(Sender: TObject);

  private
    function validarDocumentoACBr(valor: string;
      tipoDocumento: TACBrValTipoDocto): Boolean;
    function SenhaSegura(const cSenha: String): Boolean;
    procedure DCallback1(Sender: TComponent; res: Integer);
    procedure SalvarMask;
   // function SenhaSegura(const cSenha:String):Boolean;
    { Private declarations }
  public
   Mensagens : TUniSFiGrowl;
   type
    TMensageiroCor      = (Azul, Verde, Amarelo, Branco, Vermelho, Transparente);
    TMensageiroTamanho  = (Pequeno, Medio);
    TMensageiroPosicaoX = (Direita, Esquerda, Centro);
    TMensageiroPosicaoY = (Superior, Inferior);
    procedure Mensageiro(Texto: string;
                         Titulo: String;
                         Tempo: integer = 5000;
                         Cor: TMensageiroCor = Verde;
                         Tamanho: TMensageiroTamanho = Medio;
                         PosicaoX: TMensageiroPosicaoX = Centro;
                         PosicaoY: TMensageiroPosicaoY = Superior);
    { Public declarations }
  end;


function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, uniGUIMainModule, Controle.Funcoes;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.BotaoNovoClick(Sender: TObject);
begin
  UniSFHold_Aguarde.MaskShow('Aguarde...',
                              procedure(const Mask:Boolean)
                              begin
                                SalvarMask;
                              end
      );
end;

procedure TMainForm.SalvarMask;							   
var
  CampoVazio: Boolean;
  MD5: TIdHashMessageDigest5;
  Senha: String;
  Scriado : integer;
  UniMainModuleInstacia : TUniMainModule;
  i: integer;
begin
  UniSFHold_Aguarde.MaskShow('Aguarde...');
  CampoVazio := False;

  if EditRazaoSocial.Text = '' then
    CampoVazio := True;

  if EditCelular.Text = '' then
    CampoVazio := True;

  if EditEmail.Text = '' then
    CampoVazio := True;

  if EditUsuario.Text = '' then
    CampoVazio := True;

  if EditSenha.Text = '' then
    CampoVazio := True;

  if EditSenhaRepete.Text = '' then
    CampoVazio := True;

  if CampoVazio = True then
  begin
    UniSFHold_Aguarde.MaskHide;
    Main.MainForm.Mensageiro('É necessário o preenchimento de todos os campos!',
                             'ATENÇÃO!',
                             4000,
                             Azul);
    Exit;
  end;

  if (Length(EditUsuario.Text) < 5) then
  begin
    UniSFHold_Aguarde.MaskHide;
    Main.MainForm.Mensageiro('É necessário informar o usuário igual ou maior que 5 digitos!',
                             'ATENÇÃO!',
                             4000,
                             Azul);
    EditUsuario.SetFocus;
    Exit;
  end;

  if (Length(EditRazaoSocial.Text) < 10) then
  begin
    UniSFHold_Aguarde.MaskHide;
    Main.MainForm.Mensageiro('É necessário informar a razão social completa e não apenas parte dela!',
                             'ATENÇÃO!',
                             4000,
                             Azul);
    EditUsuario.SetFocus;
    Exit;
  end;

  if not validarDocumentoACBr(EditEmail.Text,
                              docEmail) then
  begin
    Main.MainForm.Mensageiro('Para continuar o cadastro e utilizar o sistema<br>' +
                             'é necessário informar um email válido,',
                             'Informe um email',
                             5000,
                             Vermelho);
    EditEmail.Clear;
  end;

  // Validando senha
  If EditSenha.Text <> EditSenhaRepete.Text then
  begin
    UniSFHold_Aguarde.MaskHide;
    Main.MainForm.Mensageiro('As senhas não coincidem!',
                             'ATENÇÃO!',
                             4000,
                             Azul);
    EditSenha.Clear;
    EditSenhaRepete.Clear;
    Exit;
  end
  else
  begin
    // Verifica a senha
    if (Length(EditSenha.Text) < 4) then
    begin
      UniSFHold_Aguarde.MaskHide;
      Main.MainForm.Mensageiro('É necessário informar a senha igual ou maior que 4 digitos!',
                               'ATENÇÃO!',
                               4000,
                               Azul);
      EditSenha.Clear;
      EditSenhaRepete.Clear;
      EditSenha.SetFocus;
      Exit;
    end;

    // Verifica se a senha contem algum caracterer especial
    if SenhaSegura(EditSenha.Text) = False then
    begin
      UniSFHold_Aguarde.MaskHide;
      Main.MainForm.Mensageiro('A senha deve conter letras e números, que não sejam sequenciais!',
                               'ATENÇÃO!',
                               4000,
                               Azul);
      EditSenha.SetFocus;
      Exit;
    end;

    // Encripta a senha em Hash MD5
    MD5 := TIdHashMessageDigest5.Create;
    try
      Senha := MD5.HashStringAsHex(EditSenha.Text);
    finally
      MD5.Free;
    end;

    if UniMainModule.UsuarioExiste(EditUsuario.Text)= true then
    begin
      UniSFHold_Aguarde.MaskHide;
      Main.MainForm.Mensageiro('Este nome de usuário já existe, por favor, altere para continuar!',
                               'ATENÇÃO!',
                               4000,
                               Azul);
      EditUsuario.SetFocus;
      Exit;
    end;

     //desabilita o botão para que não fique tentando realizar o cadastro várias vezes
    BotaoNovo.Enabled := false;

    //Passando pela validação se o usuário existe o cadastro é realizado
    if  UniMainModule.NovoUsuario(EditUsuario.Text,
                                  EditSenha.Text) then
    begin

      UniMainModule.ADOConnectionUsuario.CommitTrans;

      for Scriado := 1 to 3 do
      begin
        sleep(1000);
        if UniMainModule.SchemaCriado = true then
        begin

          for I := 1 to 5 do
          begin
            Sleep(1000);
            //volta conexão com banco usuario para atualizar tabela
            With UniMainModule do
            begin
              if ConectarNovoSchema('localhost:1521/xe',
                                    'CONTROLE_'+ IntToStr(CadastroIdUsuario),
                                    'Ralios3105') =  true then
              begin

                if UniMainModule.TabelaExiste then
                begin
                  Try
                    ADOConnectionControle.BeginTrans;
                    QryAx3.SQL.Clear;
                    QryAx3.SQL.Add('UPDATE pessoa SET');
                    QryAx3.SQL.Add('       razao_social  = ''' + EditRazaoSocial.Text + ''',');
                    QryAx3.SQL.Add('       nome_fantasia = ''' + EditRazaoSocial.Text + '''');
                    QryAx3.SQL.Add(' WHERE id = 1');
                    QryAx3.ExecSQL;

                    QryAx4.SQL.Clear;
                    QryAx4.SQL.Add('UPDATE pessoa_endereco SET');
                    QryAx4.SQL.Add('       celular  = ''' + EditCelular.Text + ''',');
                    QryAx4.SQL.Add('       email = ''' + EditEmail.Text + '''');
                    QryAx4.SQL.Add(' WHERE id = 1');
                    QryAx4.ExecSQL;


                    ADOConnectionControle.CommitTrans;

                    MessageDlg('Cadastro realizado com sucesso!' + #13+
                    'Você será redirecionado para tela de login' + #13+
                    'utilize o nome de usuário e senha cadastrados!',
                    mtinformation,
                    [mbOK],
                    DCallback1);

                    break;
                  Except
                    on e:exception do
                    begin
                      ADOConnectionControle.RollbackTrans;
                      Main.MainForm.Mensageiro(ControleFuncoes.RetiraAspaSimples(e.message),
                                               'ATENÇÃO!',
                                               8000,
                                               vermelho);
                      break;
                    end;
                  End;
                end;
              end;
            end;
          end;
        end;
      end;
    end
    else //Se mesmo passando pelas validaçõe apresentar algum erro
    begin
      Main.MainForm.Mensageiro('Algum deu errado no seu cadastro, por favor entrem em contato: (81) 3721-4578!',
                               'ERRO!',
                               4000,
                               Azul)
    end;
  end;
end;



procedure TMainForm.DCallback1(Sender: TComponent; res :Integer);
begin
  UniSession.UrlRedirect('https://controle.i9sisistemas.com.br')
end;

procedure TMainForm.UniButton1Click(Sender: TObject);
begin
   UniSession.AddJS('window.open("https://wa.me/558191427832")');
end;

procedure TMainForm.UniFormScreenResize(Sender: TObject; AWidth,
  AHeight: Integer);
begin
  ImagemFundo.Align := alClient;
  ImagemFundo.Visible := True;
  EditRazaoSocial.Visible := True;
  EditUsuario.Visible := True;
  EditCelular.Visible := True;
  EditEmail.Visible := True;
  EditSenha.Visible := True;
  EditSenhaRepete.Visible := True;
  UniSFHold_Aguarde.MaskHide;
end;

procedure TMainForm.UniFormShow(Sender: TObject);
begin
  UniSFHold_Aguarde.MaskShow('Aguarde...');
  EditRazaoSocial.SetFocus;
end;

procedure TMainForm.Mensageiro(Texto: string;
                               Titulo: String;
                               Tempo: integer = 5000;
                               Cor: TMensageiroCor = Verde;
                               Tamanho: TMensageiroTamanho = Medio;
                               PosicaoX: TMensageiroPosicaoX = Centro;
                               PosicaoY: TMensageiroPosicaoY = Superior);
begin
  // Utiliza o componente TUniSFiGrowl para exibir mensagens na tela,
  // Essa função pode ser usada em qualquer tela
  try
    Mensagens := TUniSFiGrowl.Create(nil);
    With Mensagens do
    begin
      Text          := Texto;
      Title         := Titulo;
      Timer         := Tempo;
      if Cor = Azul then
        iType         := it_info
      else if Cor = Verde then
        iType         := it_Success_sat
      else if Cor = Amarelo then
        iType         := it_Notice_sat
      else if Cor = Branco then
        iType         := it_Simple
      else if Cor = Vermelho then
        iType         := it_Error_sat
      else if Cor = Transparente then
        iType         := it_info_stat;
      if Tamanho = Pequeno then
        AlertSize     := as_small
      else if Tamanho = Medio then
        AlertSize     := as_regular;
      if PosicaoX = Direita then
        PlacementX    := px_right
      else if PosicaoX = Esquerda then
        PlacementX    := px_left
      else if PosicaoX = Centro then
        PlacementX    := px_center;
      if PosicaoY = Superior then
        PlacementY    := py_top
      else if PosicaoY = Inferior then
        PlacementY    := py_bottom;
   //   icon.icon     := TFontAwesome(fa_child);
      AnimationShow := TAnimationShow(as_wobble);
      Show;
    end;
  finally
    Mensagens.Free;
  end;
end;

function TMainForm.validarDocumentoACBr(valor: string; tipoDocumento: TACBrValTipoDocto): Boolean;
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

function TMainForm.SenhaSegura(const cSenha:String):Boolean;
function SoLetras(s:string):boolean;
const
  c :Array [1..10]  of char  = ('0','1','2','3','4','5','6','7','8','9');
var
  idx:integer;
begin    //tem letras
  result:=true;
  for idx:=1 to length(c) do
    if pos(c[idx],s)>0 then
    begin
      result:=false;
      Break;
    end;
end;
Const
  cCharMin=3;
var
  n:Int64;
begin
  result:=(length(cSenha) > cCharMin)and(not TryStrToInt64(cSenha,n))and(not SoLetras(cSenha));
end;



initialization
  RegisterAppFormClass(TMainForm);

end.

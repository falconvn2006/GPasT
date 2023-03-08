unit untAbertura;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Gauges, TLHelp32, dxGDIPlusClasses;

type
  TfrmAbertura = class(TForm)
    gauProcesso: TGauge;
    Image1: TImage;
    lblProgresso: TLabel;
    Label1: TLabel;
    Gauge1: TGauge;
    Image2: TImage;
    Label2: TLabel;
  private
    { Private declarations }
  public
    procedure AbrirSistema;
    { Public declarations }
  end;

var
  frmAbertura: TfrmAbertura;

implementation

uses form_principal, form_acesso_sistema, untDados,
  form_cadastro_usuarios, funcao, untDtmRelatorios,
  versao;

{$R *.dfm}

function scGetProcess(ExeName: string): Boolean;
var
  ProcEntry: TProcessEntry32;
  Hnd: THandle;
  Fnd: Boolean;
begin
// Verify an executable was already open

  Result := False;
  Hnd := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  {$WARNINGS OFF}
  if Hnd <> - 1 then
  {$WARNINGS ON}
    begin
      ProcEntry.dwSize := SizeOf(TProcessEntry32);
      Fnd := Process32First(Hnd, ProcEntry);
      while Fnd do
        begin
          if (LowerCase(ProcEntry.szExeFile) =
            LowerCase(ExeName)) then
            begin
              Result := True;
              Break;
            end;
          Fnd := Process32Next(Hnd, ProcEntry);
        end;
      CloseHandle(Hnd);
    end;
end;


procedure TfrmAbertura.AbrirSistema;
begin
  GetVersao(Label2);
  gauProcesso.MaxValue := 6;
//  gauProcesso.Progress := 1;
//  Application.ProcessMessages;
//  try
//    lbProcesso.Items.Add('Verificando Serviço do Firebird.');
//    Application.ProcessMessages;
//    if not scGetProcess('fbguard.exe') THEN
//    begin
//      if Application.MessageBox('O Serviço do Gerenciado de Bando de Dados Firedird não está Ativo em seu Computador!'#13+
//                                ' Deseja Instalalar o Firebird Agora?', 'Firebird',MB_YESNO+MB_ICONQUESTION) = idyes then
//        WinExec(Pchar(ExtractFilePath(Application.ExeName)+'Firebird-2.exe'), sw_show);
//
//      Application.Terminate;
//    end
//    else
//    begin
//      lbProcesso.Items.Add('Serviço Firebird Ativo!');
//      Application.ProcessMessages;
//    end;
//
//  Except
//    on E: Exception do
//    begin
//      Application.MessageBox('Erro ao Verificar Estrutura de Bando de Dados!', 'ERRO', MB_OK + MB_ICONERROR);
//      lbProcesso.Items.Add('erro:'+E.message);
//      Abort;
//    end;
//  end;

  gauProcesso.Progress := 1;
  Application.ProcessMessages;
  try
    lblProgresso.Caption := 'Carregando dados da versão.';
    Application.ProcessMessages;
    InicializarControleVersao();
    Versionar();
  Except
    on E: Exception do
    begin
      Application.MessageBox('Erro ao Carregar dados da versão.!', 'ERRO', MB_OK + MB_ICONERROR);
      lblProgresso.Caption := 'erro:'+E.message;
      Abort;
    end;
  end;

  gauProcesso.Progress := 2;
  try
    lblProgresso.Caption := 'Criando Formulários Principais.';
    Application.ProcessMessages;
    Application.CreateForm(TDados, Dados);
    Application.CreateForm(Tprincipal, principal);
    Application.CreateForm(Tacesso_sistema, acesso_sistema);
    Application.CreateForm(TfrmDtmRelatorios, frmDtmRelatorios);
  Except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erro ao Criar Formulários Principais! '+E.Message), 'ERRO', MB_OK + MB_ICONERROR);
      lblProgresso.Caption := 'erro:'+E.message;
      Abort;
    end;
  end;
  lblProgresso.Caption := 'Sucesso!';
  Application.ProcessMessages;

  gauProcesso.Progress := 3;
  Application.ProcessMessages;
  try
    lblProgresso.Caption := 'Abrindo Banco de Dados.';
    Application.ProcessMessages;
    Dados.Apontamento;
    Dados.qryLog.Open;
//    Dados.tblConfig.open;
  Except
    on E: Exception do
    begin
      Application.MessageBox('Erro ao Abrir Banco de Dados!', 'ERRO', MB_OK + MB_ICONERROR);
      lblProgresso.Caption := 'erro:'+E.message;
      Abort;
    end;
  end;
  lblProgresso.Caption := 'Sucesso!';
  Application.ProcessMessages;

  if ParametroLinhaComando('/SCR') then
  begin
    lblProgresso.Caption := 'Executando Script.';
    Application.ProcessMessages;
    Dados.ExecutarScript(Gauge1,lblProgresso);
  end;

  gauProcesso.Progress := 4;
  Application.ProcessMessages;
  try
    lblProgresso.Caption := 'Criando Relatórios.';
    Application.ProcessMessages;
//    Application.CreateForm(Tqr_etiq, qr_etiq);
//    Application.CreateForm(Tqr_etiq_conj, qr_etiq_conj);
//    Application.CreateForm(Ttiras, tiras);
  Except
    on E: Exception do
    begin
      Application.MessageBox('Erro ao Criar Relatórios!', 'ERRO', MB_OK + MB_ICONERROR);
      lblProgresso.Caption := 'erro:'+E.message;
      Application.ProcessMessages;
      Abort;
    end;
  end;

  gauProcesso.Progress := 5;
  Application.ProcessMessages;
  try
    lblProgresso.Caption := 'Iniciando Raquel.';
    Application.ProcessMessages;
    {if Dados.tblConfigUSARFALA.Value = 1 then
      dados.Fala('a',0); }
  Except
    on E: Exception do
    begin
      Application.MessageBox('Erro ao Iniciar Raquel!', 'ERRO', MB_OK + MB_ICONERROR);
      lblProgresso.Caption := 'erro:'+E.message;
      Application.ProcessMessages;
      Abort;
    end;
  end;

  lblProgresso.Caption := 'Sucesso!';
  Application.ProcessMessages;

  gauProcesso.Progress := 6;
  Application.ProcessMessages;
  try
    lblProgresso.Caption := 'Iniciando...';
    Application.ProcessMessages;

    Application.ProcessMessages;

    Sleep(1000);

    frmAbertura.Visible := False;

    dados.geral.sql.text := 'Select codigo from TABUSUARIOS';
    dados.geral.open;

    if dados.geral.FieldByName('codigo').text = '' then
    begin
      Application.MessageBox('Nenhum Usuário Cadastrado!'#13'Cadastre um Usuário!', 'INFORMAÇÃO', MB_OK + MB_ICONEXCLAMATION);
      If Application.FindComponent('cadastro_usuarios') = Nil then
         Application.CreateForm(Tcadastro_usuarios, cadastro_usuarios);

      cadastro_usuarios.PrimeiroUsuario := True;
      cadastro_usuarios.ShowModal;
      cadastro_usuarios.PrimeiroUsuario := False;

      dados.geral.sql.text := 'Select codigo from TABUSUARIOS';
      dados.geral.open;

      if dados.geral.FieldByName('codigo').text = '' then
      begin
        Application.MessageBox('Não é Possível Iniciar o Sistema sem Cadastrar um Usuário!', 'ERRO', MB_OK + MB_ICONERROR);
        Application.Terminate;
      end;
    end;

    acesso_sistema.ShowModal;

// VERIFICAR ISSO DEPOIS DO CADASTRO DA LOJA PRONTO
//    dados.geral.sql.text := 'Select codigo from TABLOJAS';
//    dados.geral.open;
//    dados.geral.last;
//    dados.geral.first;
//      if dados.geral.RecordCount > 1 then
//        dados.CodigoComunidadeCorrente := dados.DigitarValorBD('Selecione a Comunidade',
//                                                          'TABLOJAS',
//                                                          1,
//                                                          'NOME',
//                                                          'CODIGO',
//                                                          'NOME')
//      else
//        dados.CodigoComunidadeCorrente := dados.geral.fieldbyname('codigo').AsInteger;
//    dados.geral.Close;
//
//    dados.qryComunidade.Close;
//    dados.qryComunidade.Open;

  Except
    on E: Exception do
    begin
      Application.MessageBox('Erro ao Iniciar Sistema!', 'ERRO', MB_OK + MB_ICONERROR);
      lblProgresso.Caption := 'erro:'+E.message;
      Abort;
    end;
  end;
end;

end.

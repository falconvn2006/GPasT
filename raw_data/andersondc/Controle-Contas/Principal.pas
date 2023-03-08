unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg, StrUtils,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, System.Notification;

type
  TFPrincipal = class(TForm)
    Panel1: TPanel;
    imBase: TImage;
    imFundo: TImage;
    icoBanco: TImage;
    icoCartao: TImage;
    icoConta: TImage;
    icoBancoSel: TImage;
    icoCartaoSel: TImage;
    icoContaSel: TImage;
    PBancos: TPanel;
    Image1: TImage;
    Image2: TImage;
    PagBanco: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Image3: TImage;
    Image4: TImage;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    cBancoSaldo: TEdit;
    Panel6: TPanel;
    Label3: TLabel;
    cBancoNome: TEdit;
    Panel7: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    Label2: TLabel;
    cBancoConta: TEdit;
    Panel9: TPanel;
    Label4: TLabel;
    cBancoAgencia: TEdit;
    Button1: TButton;
    Button2: TButton;
    Panel10: TPanel;
    Panel13: TPanel;
    DBGrid1: TDBGrid;
    Panel12: TPanel;
    Panel14: TPanel;
    Label5: TLabel;
    lBancoSaldo: TEdit;
    Panel15: TPanel;
    Label6: TLabel;
    lBancoNome: TEdit;
    Panel16: TPanel;
    Panel17: TPanel;
    Label7: TLabel;
    lBancoConta: TEdit;
    Panel18: TPanel;
    Label8: TLabel;
    lBancoAgencia: TEdit;
    Panel11: TPanel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    PCartao: TPanel;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    PagCartao: TPageControl;
    TabSheet3: TTabSheet;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Label11: TLabel;
    cCartaoJurosAtraso: TEdit;
    Panel26: TPanel;
    Label12: TLabel;
    cCartaoJurosAno: TEdit;
    Panel27: TPanel;
    Button6: TButton;
    Button7: TButton;
    TabSheet4: TTabSheet;
    Panel28: TPanel;
    Panel29: TPanel;
    DBGrid2: TDBGrid;
    Panel36: TPanel;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Panel37: TPanel;
    Panel38: TPanel;
    Label18: TLabel;
    Panel39: TPanel;
    Label19: TLabel;
    cCartaoLimite: TEdit;
    cCartaoVencimento: TDateTimePicker;
    Panel23: TPanel;
    Label9: TLabel;
    vCartaoBanco: TComboBox;
    Panel19: TPanel;
    Panel22: TPanel;
    Panel40: TPanel;
    Label10: TLabel;
    cCartaoNumero: TEdit;
    Panel41: TPanel;
    Label17: TLabel;
    cCartaoNome: TEdit;
    Panel42: TPanel;
    imCartaoImg: TImage;
    PNotificacao: TPanel;
    Image10: TImage;
    imgNotifica: TImage;
    TextoNotificacao: TLabel;
    cCartaoImagem: TEdit;
    AbrirImagem: TOpenDialog;
    imBaseCartao: TImage;
    imBanco1: TImage;
    imCartao1: TImage;
    imConta1: TImage;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Label13: TLabel;
    lCartaoJurosAtraso: TEdit;
    Panel33: TPanel;
    Label14: TLabel;
    lCartaoJurosAno: TEdit;
    Panel44: TPanel;
    Label20: TLabel;
    lCartaoBanco: TComboBox;
    Panel45: TPanel;
    Panel46: TPanel;
    Panel47: TPanel;
    Label21: TLabel;
    Panel48: TPanel;
    Label22: TLabel;
    Panel49: TPanel;
    Panel50: TPanel;
    Label23: TLabel;
    lCartaoNumero: TEdit;
    Panel51: TPanel;
    Label24: TLabel;
    lCartaoNome: TEdit;
    lCartaoLimite: TEdit;
    lCartaoVencimento: TDateTimePicker;
    TabSheet5: TTabSheet;
    lCartaoImagemVer: TImage;
    lCartaoImagem: TEdit;
    Panel34: TPanel;
    Button11: TButton;
    Button13: TButton;
    Button12: TButton;
    icoSaldo: TImage;
    lSaldoTit: TLabel;
    lResumoBancos: TLabel;
    PContas: TPanel;
    Image9: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    PageControl1: TPageControl;
    TabSheet6: TTabSheet;
    Panel43: TPanel;
    Panel52: TPanel;
    Panel54: TPanel;
    Label16: TLabel;
    cContasDescricao: TEdit;
    Panel55: TPanel;
    Panel56: TPanel;
    Label25: TLabel;
    Panel57: TPanel;
    Label26: TLabel;
    Panel58: TPanel;
    Button14: TButton;
    Button15: TButton;
    TabSheet7: TTabSheet;
    Panel59: TPanel;
    Panel60: TPanel;
    DBGrid3: TDBGrid;
    Panel61: TPanel;
    Panel62: TPanel;
    Label27: TLabel;
    Edit5: TEdit;
    Panel63: TPanel;
    Label28: TLabel;
    Edit6: TEdit;
    Panel64: TPanel;
    Panel65: TPanel;
    Label29: TLabel;
    Edit7: TEdit;
    Panel66: TPanel;
    Label30: TLabel;
    Edit8: TEdit;
    Panel67: TPanel;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Panel35: TPanel;
    Panel53: TPanel;
    Label15: TLabel;
    cContasTipoPagamento: TComboBox;
    Panel68: TPanel;
    Label31: TLabel;
    cContasValor: TEdit;
    cContasParcelas: TComboBox;
    cContasValorParcelas: TEdit;
    Panel69: TPanel;
    Label32: TLabel;
    cContasCartao: TComboBox;
    Panel70: TPanel;
    Panel71: TPanel;
    Panel72: TPanel;
    Label34: TLabel;
    cContasPaga: TCheckBox;
    cContasDataPagamento: TDateTimePicker;
    procedure FormResize(Sender: TObject);
    procedure SelecionaMenu(opcao: integer);
    procedure Menu(opcao: integer);
    procedure RedOpcoes;
    procedure icoBancoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure icoCartaoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure icoContaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imBaseMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure icoBancoSelClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure imFundoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image6Click(Sender: TObject);
    procedure icoCartaoSelClick(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure imBaseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Button5Click(Sender: TObject);
    procedure cBancoSaldoKeyPress(Sender: TObject; var Key: Char);

    procedure CadastrarBanco;
    procedure LimpaCadastroBanco;
    procedure AtualizarComboBancos;

    procedure CadastrarCartao;
    procedure LimpaCadastroCartao;
    procedure AbrirBancoCartao(zid: string);

    procedure CadastrarConta;
    procedure LimpaCadastroConta;

    procedure CarregarSaldoTotal;
    procedure CriaParcelas(Combo: TComboBox);
    procedure CriaTipoPagamento(Combo: TComboBox);
    function CalcularParcela(valor: string; parcelas: integer): string;
    procedure CarregarCartoes(Combo: TComboBox);

    function FormatarValor(valor: string): string;
    procedure Notificacao(texto: string; opcao: integer);
    procedure Button1Click(Sender: TObject);
    procedure imCartaoImgClick(Sender: TObject);
    function CopiaImagemDiretorio(arquivo: string): string;
    procedure Button7Click(Sender: TObject);
    procedure cCartaoNumeroChange(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure icoSaldoClick(Sender: TObject);
    procedure icoContaSelClick(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure cContasTipoPagamentoChange(Sender: TObject);
    procedure cContasParcelasChange(Sender: TObject);
    procedure cContasValorChange(Sender: TObject);
    procedure Button15Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;
  vId: integer;
  vDiretorio: string;

implementation

{$R *.dfm}

uses Dados;

procedure TFPrincipal.Button10Click(Sender: TObject);
begin
  if Application.MessageBox('Confirma a Exclusão do Cartão?',
                              'Cartões',
                              MB_ICONQUESTION + MB_YESNO) = idYes  then
  begin
    Dados.FDados.Excluir(vId,'cartoes');
    Notificacao('Cartão Excluído!',2);
  end;
end;

procedure TFPrincipal.Button11Click(Sender: TObject);
begin
  if Application.MessageBox('Confirma a Alteração dos Dados do Cartão?',
                              'Cartões',
                              MB_ICONQUESTION + MB_YESNO) = idYes  then
  begin
    Dados.FDados.AtualizaCartao(vId,
                                lCartaoNome.Text,
                                FormatarValor(lCartaoLimite.Text),
                                lCartaoNumero.Text,
                                lCartaoBanco.Text,
                                DateToStr(lCartaoVencimento.Date),
                                lCartaoJurosANo.Text,
                                lCartaoJurosAtraso.Text,
                                CopiaImagemDiretorio(lCartaoImagem.Text));

    Notificacao('Informações do Cartão '+lCartaoNome.Text+' Atualizados!',2);
  end;
end;

procedure TFPrincipal.Button12Click(Sender: TObject);
begin
  PagCartao.ActivePageIndex:=2;
end;

procedure TFPrincipal.Button13Click(Sender: TObject);
begin
  if AbrirImagem.Execute then
  begin
    lCartaoImagemVer.Picture.LoadFromFile(AbrirImagem.FileName);
    lCartaoImagem.Text:=AbrirImagem.FileName;
    lCartaoImagemVer.Repaint;
  end;
end;

procedure TFPrincipal.Button15Click(Sender: TObject);
begin
  CadastrarConta;
end;

procedure TFPrincipal.Button1Click(Sender: TObject);
begin
  LimpaCadastroBanco;
end;

procedure TFPrincipal.Button2Click(Sender: TObject);
begin
  cadastrarBanco;
end;

procedure TFPrincipal.Button3Click(Sender: TObject);
begin
  if Application.MessageBox('Confirma a Alteração dos Dados do Banco?',
                              'Bancos',
                              MB_ICONQUESTION + MB_YESNO) = idYes  then
  begin
    Dados.FDados.AtualizaBanco(vId,
                               lBancoNome.Text,
                               lBancoAgencia.Text,
                               lBancoConta.Text,
                               FormatarValor(lBancoSaldo.Text));
    Notificacao('Informações do Banco '+lBancoNome.Text+' Atualizados!',1);
  end;
end;

procedure TFPrincipal.Button5Click(Sender: TObject);
begin
  if Application.MessageBox('Confirma a Exclusão do Banco?',
                              'Bancos',
                              MB_ICONQUESTION + MB_YESNO) = idYes  then
  begin
    Dados.FDados.Excluir(vId,'bancos');
    Notificacao('Banco Excluído!',1);
  end;
end;

procedure TFPrincipal.Button7Click(Sender: TObject);
begin
  CadastrarCartao;
end;

procedure TFPrincipal.Button8Click(Sender: TObject);
begin
  if Application.MessageBox('Confirma a Alteração dos Dados do Cartão?',
                              'Cartões',
                              MB_ICONQUESTION + MB_YESNO) = idYes  then
  begin
    Dados.FDados.AtualizaCartao(vId,
                                lCartaoNome.Text,
                                FormatarValor(lCartaoLimite.Text),
                                lCartaoNumero.Text,
                                lCartaoBanco.Text,
                                DateToStr(lCartaoVencimento.Date),
                                lCartaoJurosANo.Text,
                                lCartaoJurosAtraso.Text,
                                CopiaImagemDiretorio(lCartaoImagem.Text));

    Notificacao('Informações do Cartão '+lCartaoNome.Text+' Atualizados!',2);
  end;
end;

procedure TFPrincipal.Button9Click(Sender: TObject);
begin
  AbrirBancoCartao(leftStr(lCartaoBanco.Text,2));
end;

procedure TFPrincipal.FormResize(Sender: TObject);
begin
  imBase.Top:=0;
  imBase.Left:=0;

  icoBancoSel.Top:=icoBanco.Top-8;
  icoBancoSel.Left:=icoBanco.Left-8;

  icoCartaoSel.Top:=icoCartao.Top-8;
  icoCartaoSel.Left:=icoCartao.Left-8;

  icoContaSel.Top:=icoConta.Top-8;
  icoContaSel.Left:=icoConta.Left-8;

  icoSaldo.Top:=8;
  icoSaldo.Left:=imFUndo.Width-icoSaldo.Width-8;

  RedOpcoes;
end;

procedure TFPrincipal.FormShow(Sender: TObject);
begin
  vDiretorio := ParamStr(0);
  vDiretorio := LeftStr(vDiretorio,length(vDiretorio)-
                length(ExtractFileName(vDiretorio)));

  Dados.FDados.ConfigurarDados(vDiretorio);

  AtualizarComboBancos;

  CriaParcelas(cContasParcelas);
  CriaTipoPagamento(cContasTipoPagamento);
  CarregarCartoes(cContasCartao);
end;

procedure TFPrincipal.icoBancoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SelecionaMenu(1);
end;

procedure TFPrincipal.icoBancoSelClick(Sender: TObject);
begin
  Menu(1);
end;

procedure TFPrincipal.icoCartaoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SelecionaMenu(2);
end;

procedure TFPrincipal.icoCartaoSelClick(Sender: TObject);
begin
  Menu(2);
end;

procedure TFPrincipal.icoContaMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SelecionaMenu(3);
end;

procedure TFPrincipal.icoContaSelClick(Sender: TObject);
begin
  Menu(3);
end;

procedure TFPrincipal.icoSaldoClick(Sender: TObject);
begin
  if lSaldoTit.Visible=false then
    CarregarSaldoTotal
  else
  begin
    lSaldoTit.Visible:=false;
    lResumoBancos.Visible:=false;
  end;
end;

procedure TFPrincipal.Image11Click(Sender: TObject);
begin
  PContas.Visible:=false;
end;

procedure TFPrincipal.Image2Click(Sender: TObject);
begin
  PBancos.Visible:=false;
end;

procedure TFPrincipal.Image3Click(Sender: TObject);
begin
  PagBanco.ActivePageIndex:=0;
  cBancoNome.SetFocus;
end;

procedure TFPrincipal.Image4Click(Sender: TObject);
begin
  PagBanco.ActivePageIndex:=1;
  Dados.FDados.AtualizaTabela('bancos');
end;

procedure TFPrincipal.Image6Click(Sender: TObject);
begin
  PCartao.Visible:=false;
end;

procedure TFPrincipal.Image7Click(Sender: TObject);
begin
  PagCartao.ActivePageIndex:=0;
  AtualizarComboBancos;
end;

procedure TFPrincipal.Image8Click(Sender: TObject);
begin
  PagCartao.ActivePageIndex:=1;
  Dados.FDados.AtualizaTabela('cartoes');
end;

procedure TFPrincipal.imBaseClick(Sender: TObject);
begin
  Menu(0);
end;

procedure TFPrincipal.imBaseMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SelecionaMenu(0);
end;

procedure TFPrincipal.imCartaoImgClick(Sender: TObject);
begin
  if AbrirImagem.Execute then
  begin
    imCartaoImg.Picture.LoadFromFile(AbrirImagem.FileName);
    cCartaoImagem.Text:=AbrirImagem.FileName;
    imCartaoImg.Repaint;
  end;
end;

procedure TFPrincipal.imFundoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SelecionaMenu(0);
end;

procedure TFPrincipal.SelecionaMenu(opcao: integer);
begin
  icoBancoSel.Visible:=false;
  icoCartaoSel.Visible:=false;
  icoContaSel.Visible:=false;

  case opcao of
    1:
    begin
      icoBancoSel.Visible:=true;
    end;
    2:
    begin
      icoCartaoSel.Visible:=true;
    end;
    3:
    begin
      icoContaSel.Visible:=true;
    end;
  end;

  Application.ProcessMessages;
end;

procedure TFPrincipal.Menu(opcao: integer);
begin
  RedOpcoes;
  pBancos.Visible:=false;
  pCartao.Visible:=false;
  pContas.Visible:=false;

  case opcao of
    1:
    begin
      pBancos.Visible:=true;
      PagBanco.ActivePageIndex:=0;
      cBancoNome.SetFocus;
    end;
    2:
    begin
      pCartao.Visible:=true;
      PagCartao.ActivePageIndex:=0;
      cCartaoNome.SetFocus;
    end;
    3:
    begin
      pContas.Visible:=true;
//      PagCartao.ActivePageIndex:=0;
//      cCartaoNome.SetFocus;
    end;
  end;
end;

procedure TFPrincipal.RedOpcoes;
begin
  pbancos.Top:=trunc(imFundo.Height/2)-trunc(pbancos.Height/2);
  pbancos.Left:=trunc(imFundo.Width/2)-trunc(pbancos.Width/2);

  pCartao.Top:=trunc(imFundo.Height/2)-trunc(pCartao.Height/2);
  pCartao.Left:=trunc(imFundo.Width/2)-trunc(pCartao.Width/2);

  pContas.Top:=trunc(imFundo.Height/2)-trunc(pContas.Height/2);
  pContas.Left:=trunc(imFundo.Width/2)-trunc(pContas.Width/2);

  PNotificacao.Top:=imFundo.Height-PNotificacao.Height-5;
  PNotificacao.Left:=imFundo.Width-PNotificacao.Width-5;
end;

procedure TFPrincipal.CadastrarBanco;
begin
  Dados.FDados.CadastraBanco(cBancoNome.Text,
                             cBancoAgencia.Text,
                             cBancoConta.Text,
                             FormatarValor(cBancoSaldo.Text));
  Notificacao('Banco '+cBancoNome.Text+' Cadastrado!',1);
  AtualizarComboBancos;
  LimpaCadastroBanco;
end;

procedure TFPrincipal.CadastrarCartao;
begin
  Dados.FDados.CadastraCartao(cCartaoNome.Text,
                              cCartaoNumero.Text,
                              FormatarValor(cCartaoLimite.Text),
                              vCartaoBanco.Text,
                              DateToStr(cCartaoVencimento.Date),
                              cCartaoJurosAno.Text,
                              cCartaoJurosAtraso.Text,
                              CopiaImagemDiretorio(cCartaoImagem.Text));

  Notificacao('Cartão '+cCartaoNome.Text+' Cadastrado!',2);
  LimpaCadastroCartao;
end;

procedure TFPrincipal.CadastrarConta;
begin
  Dados.FDados.CadastraConta(cContasDescricao.Text,
                              cContasTipoPagamento.ItemIndex.ToString,
                              DateToStr(cContasDataPagamento.Date),
                              FormatarValor(cContasValor.Text),
                              FormatarValor(cContasValorParcelas.Text),
                              cContasParcelas.ItemIndex.ToString,
                              ifthen(cContasCartao.Enabled, cContasCartao.Text, ''),
                              ifthen(cContasPaga.Checked, '1', '0'));

  Notificacao('Conta '+cContasDescricao.Text+' Cadastrada!',3);
  LimpaCadastroConta;
end;

function TFPrincipal.CopiaImagemDiretorio(arquivo: string): string;
var
  Dir: string;
  extensao: string;
  novoarquivo: string;
begin
  Dir:=vDiretorio+'\Imagens';
  extensao:=rightStr(arquivo, 3);

  if extensao='peg' then
    extensao:='jpg';

  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);

  novoarquivo:=dir+'\'+cCartaoNome.Text+'.'+extensao;

  CopyFile(PChar(arquivo), PChar(novoarquivo), false);

  result:=novoarquivo;
end;

procedure TFPrincipal.Notificacao(texto: string; opcao: integer);
begin
  case opcao of
    1: imgNotifica.Picture:=icoBanco.Picture;
    2: imgNotifica.Picture:=icoCartao.Picture;
    3: imgNotifica.Picture:=icoConta.Picture;
  end;

  TextoNotificacao.Caption:=texto;
  PNotificacao.Visible:=true;
  PNotificacao.Repaint;

  sleep(3000);

  PNotificacao.Visible:=false;
end;

procedure TFPrincipal.cBancoSaldoKeyPress(Sender: TObject; var Key: Char);
var
   Texto, Texto2: string;
   i: byte;
begin
  if (Key in ['0'..'9',chr(vk_back)]) then
  begin
     if (key in ['0'..'9']) and (Length(Trim(TEdit(Sender).Text))>23) then
        key := #0;

     Texto2 := '0';
     Texto := Trim(TEdit(Sender).Text)+Key;
     for i := 1 to Length(Texto) do
        if Texto[i] in ['0'..'9'] then
           Texto2 := Texto2 + Texto[i];

     if key = chr(vk_back) then
        Delete(Texto2,Length(Texto2),1);
     Texto2 := FormatFloat('#,0.00',StrToInt64(Texto2)/100);

     repeat
        Texto2 := ' '+Texto2
     until Canvas.TextWidth(Texto2) >= TEdit(Sender).Width;

     TEdit(Sender).Text := Texto2;
     TEdit(Sender).SelStart := Length(Texto2);
  end;
  Key := #0;


end;

procedure TFPrincipal.cCartaoNumeroChange(Sender: TObject);
var
  tam: integer;
begin
  tam:=Length(cCartaoNumero.Text);
  if (tam=5) or (tam=10) or (tam=15) then
    cCartaoNumero.Text:=LeftStr(cCartaoNumero.Text, tam-1)+' '+RightStr(cCartaoNumero.Text, 1);

  cCartaoNumero.SelStart:=Length(cCartaoNumero.Text);
end;

procedure TFPrincipal.cContasParcelasChange(Sender: TObject);
begin
  if Length(cContasValor.Text)=0 then cContasValor.Text:='0';

  cContasValorParcelas.Text:=FormatFloat('#,##0.00',
        StrTOFloat(CalcularParcela(StringReplace(cContasValor.Text, '.', '',
                                  [rfReplaceAll, rfIgnoreCase]),
                                  cContasParcelas.ItemIndex)));
end;

procedure TFPrincipal.cContasTipoPagamentoChange(Sender: TObject);
begin
  if trim(cContasTipoPagamento.Text)='Cartão' then
    cContasCartao.Enabled:=true
  else
    cContasCartao.Enabled:=false;
end;

procedure TFPrincipal.cContasValorChange(Sender: TObject);
begin
  if cContasParcelas.ItemIndex<0 then cContasParcelas.ItemIndex:=0;

  cContasValorParcelas.Text:=FormatFloat('#,##0.00',
        StrTOFloat(CalcularParcela(StringReplace(cContasValor.Text, '.', '',
                                  [rfReplaceAll, rfIgnoreCase]),
                                  cContasParcelas.ItemIndex)));
end;

procedure TFPrincipal.DBGrid1CellClick(Column: TColumn);
begin
  with dados.FDados do
  begin
    lBancoNome.Text:=Bancos.FieldByName('nome').AsString;
    lBancoAgencia.Text:=Bancos.FieldByName('agencia').AsString;
    lBancoConta.Text:=Bancos.FieldByName('conta').AsString;
    lBancoSaldo.Text:=
        FormatFloat('#,##0.00',
        Bancos.FieldByName('saldo').AsCurrency);
    vId:=Bancos.FieldByName('id').AsInteger;
  end;
end;

procedure TFPrincipal.DBGrid2CellClick(Column: TColumn);
begin
  with dados.FDados do
  begin
    lCartaoNome.Text:=Cartoes.FieldByName('nome').AsString;
    lCartaoNumero.Text:=Cartoes.FieldByName('ncartao').AsString;
    lCartaoLimite.Text:=FormatFloat('#,##0.00',Cartoes.FieldByName('limite').AsCurrency);
    lCartaoVencimento.Date:=Cartoes.FieldByName('vencimento').AsDateTime;
    lCartaoBanco.Text:=Cartoes.FieldByName('banco').AsString;
    lCartaoJurosAno.Text:=Cartoes.FieldByName('jurosano').AsString;
    lCartaoJurosAtraso.Text:=Cartoes.FieldByName('jurosatraso').AsString;
    lCartaoImagem.Text:=Cartoes.FieldByName('imagem').AsString;
    vId:=Cartoes.FieldByName('id').AsInteger;

    if RightStr(lCartaoImagem.Text,3)='peg' then
      lCartaoImagem.Text:=leftStr(lCartaoImagem.Text, length(lCartaoImagem.Text)-3)+'jpg';

    lCartaoImagemVer.Picture.LoadFromFile(lCartaoImagem.Text);
  end;
end;

function TFPrincipal.FormatarValor(valor: string): string;
var
  vResp: string;
begin
  vResp:=valor;
  vResp:=StringReplace(vResp, '.', '@',[rfReplaceAll, rfIgnoreCase]);
  vResp:=StringReplace(vResp, ',', '.',[rfReplaceAll, rfIgnoreCase]);
  vResp:=StringReplace(vResp, '@', '',[rfReplaceAll, rfIgnoreCase]);

  result:=vResp;
end;

procedure TFPrincipal.LimpaCadastroBanco;
begin
  cBancoNome.Clear;
  cBancoAgencia.Clear;
  cBancoConta.Clear;
  cBancoSaldo.Text:='0,00';

  cBancoNome.SetFocus;
end;

procedure TFPrincipal.LimpaCadastroCartao;
begin
  cCartaoNome.Clear;
  cCartaoNumero.Clear;
  cCartaoLimite.Text:='0,00';
  cCartaoVencimento.Date:=date;
  cCartaoJurosAno.Text:='0';
  cCartaoJurosAtraso.Text:='0';
  cCartaoImagem.Clear;
  AtualizarComboBancos;
  cCartaoNome.SetFocus;
  imCartaoImg.Picture:=imBaseCartao.Picture;
end;

procedure TFPrincipal.LimpaCadastroConta;
begin
  cContasDescricao.Clear;
  cContasTipoPagamento.ItemIndex:=0;
  cContasDataPagamento.Date:=date;
  cContasValor.Text:='0,00';
  cContasValorParcelas.Text:='0,00';
  cContasParcelas.ItemIndex:=0;
  cContasCartao.Clear;
  cContasPaga.Checked:=false;

  cContasDescricao.SetFocus;
end;

procedure TFPrincipal.AtualizarComboBancos;
begin
  with Dados.FDados do
  begin
    QryAux.Close;
    QryAux.SQL.Text:='select id, nome from bancos';
    QryAux.Open;

    vCartaoBanco.Clear;
    lCartaobanco.Clear;
    QryAux.First;

    while not QryAux.Eof do
    begin
      vCartaoBanco.Items.Add(QryAux.FieldByName('id').AsString+' - '+QryAux.FieldByName('nome').AsString);
      lCartaoBanco.Items.Add(QryAux.FieldByName('id').AsString+' - '+QryAux.FieldByName('nome').AsString);
      QryAux.Next;
    end;

    QryAux.Close;
  end;
end;

procedure TFPrincipal.AbrirBancoCartao(zid: string);
begin
  Menu(1);

  zId:=trim(LefTstr(StringReplace(zId, '-', '',[rfReplaceAll, rfIgnoreCase]),3));
  PagBanco.ActivePageIndex:=1;
  Dados.FDados.LocalizarID(zId,'bancos');

  with dados.FDados do
  begin
    lBancoNome.Text:=Bancos.FieldByName('nome').AsString;
    lBancoAgencia.Text:=Bancos.FieldByName('agencia').AsString;
    lBancoConta.Text:=Bancos.FieldByName('conta').AsString;
    lBancoSaldo.Text:=
        FormatFloat('#,##0.00',
        Bancos.FieldByName('saldo').AsCurrency);
    vId:=Bancos.FieldByName('id').AsInteger;
  end;
end;

procedure TFPrincipal.CarregarSaldoTotal;
begin
  lSaldoTit.Visible:=true;
  lResumoBancos.Visible:=true;

  lResumoBancos.Caption:=Dados.FDados.SaldoBancos;
  lResumoBancos.Top:=imFundo.Height-lResumoBancos.Height-8;
  lResumoBancos.Left:=imFundo.Width-lResumoBancos.Width-8;
  lResumoBancos.Repaint;

  lsaldoTit.Caption:='Saldo Total: R$ '+Dados.FDados.SaldoTotal;
  lSaldoTit.Top:=lResumoBancos.Top-LSaldoTit.Height-5;
  lSaldoTit.Left:=imFundo.Width-lSaldoTit.Width-8;
  lSaldoTit.Repaint;
end;

procedure TFPrincipal.CriaParcelas(Combo: TComboBox);
var
  vMaxParcelas: integer;
  vTexto: string;
  i: integer;
begin
  Combo.Items.Clear;

  vMaxParcelas:=60;

  for i:=0 to vMaxParcelas do
  begin
    if i=0 then
      vTexto:='À Vista'
    else if i=1 then
      vTexto:='1x (à vencer)'
    else
      vTexto:=IntToStr(i)+'x';

    Combo.Items.Add(vTexto);
  end;

end;

procedure TFPrincipal.CriaTipoPagamento(Combo: TComboBox);
var
  vMaxParcelas: integer;
  vTexto: string;
  i: integer;
begin
  Combo.Items.Clear;
  Combo.Items.Add('Cartão');
  Combo.Items.Add('Boleto');
  Combo.Items.Add('PIX');
  Combo.Items.Add('Transferência');
  Combo.Items.Add('Dinheiro');
end;

function TFPrincipal.CalcularParcela(valor: string; parcelas: integer): string;
var
  vValorTotal: extended;
begin
  if parcelas=0 then parcelas:=1;

  vValorTotal:=StrToFloat(valor);
  result:=FloatToStr(vValorTotal/parcelas);
end;

procedure TFPrincipal.CarregarCartoes(Combo: TComboBox);
begin
  Combo.Clear;

  with Dados.FDados do
  begin
    Cartoes.Close;
    Cartoes.SQL.Text:='select nome from cartoes';
    Cartoes.Open;

    Cartoes.First;
    while not Cartoes.Eof do
    begin
      Combo.Items.Add(Cartoes.FieldByName('nome').AsString);
      Cartoes.Next;
    end;
  end;
end;

end.

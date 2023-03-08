unit FormIntegracaoEasyChopp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UnitIntegracaoEasyChopp, ExtCtrls, ComCtrls, Buttons,
  TFlatMemoUnit, XPStyleActnCtrls, ActnList, ActnMan, CustomizeDlg,
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket,
  IdSSLOpenSSL, IdServerIOHandler;

type

  TFintegracaoEasyChopp = class(Tform)
    Button1: TButton;
    MemoRespostaJsonLogin: TMemo;
    Shape1: TShape;
    MemoToken: TMemo;
    Label1: TLabel;
    MemoMsgLogin: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    Label4: TLabel;
    MemoMsgGetCliente: TMemo;
    Label5: TLabel;
    MemoRespostaJsonGetCliente: TMemo;
    edCpf: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edTag: TEdit;
    ScrollBox1: TScrollBox;
    Label9: TLabel;
    MemoHeaderGetCliente: TMemo;
    Shape2: TShape;
    edLogin: TEdit;
    Label10: TLabel;
    Label12: TLabel;
    edSenha: TEdit;
    Label11: TLabel;
    edFilial: TEdit;
    Button3: TButton;
    Shape3: TShape;
    Label13: TLabel;
    edNome: TEdit;
    Label14: TLabel;
    edEmail: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    edCpfAddCliente: TEdit;
    Label17: TLabel;
    edTelefone: TEdit;
    Label18: TLabel;
    edDtnasc: TEdit;
    Label19: TLabel;
    MemoMsgAddCliente: TMemo;
    MemoRespostaJsonAddCliente: TMemo;
    Label20: TLabel;
    edSexo: TComboBox;
    Button4: TButton;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    edTagGetCredito: TEdit;
    edCpfGetCredito: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    MemoMsgGetCredito: TMemo;
    MemoRespostaJsonGetCredito: TMemo;
    edCredito: TEdit;
    Label26: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ScrollBox2: TScrollBox;
    Label27: TLabel;
    Shape4: TShape;
    edTagAddTag: TEdit;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    MemoMsgAddTag: TMemo;
    MemoRespostaJsonAddTag: TMemo;
    edCpfAddTag: TEdit;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    edEmailAddTag: TEdit;
    Label35: TLabel;
    Button5: TButton;
    Button6: TButton;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    edTagRemoveTag: TEdit;
    edcpfRemoveTag: TEdit;
    Label39: TLabel;
    Label40: TLabel;
    MemoMsgRemoveTag: TMemo;
    MemoRespostaJsonRemoveTag: TMemo;
    Shape5: TShape;
    bt7: TButton;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    edTagAddCredito: TEdit;
    edCpfAddCredito: TEdit;
    Label44: TLabel;
    edVlCreditoAddCredito: TEdit;
    Label45: TLabel;
    edCodAutorizacaoAddCredito: TEdit;
    Label46: TLabel;
    edEmailUsuarioAddCredito: TEdit;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    edNumCumpoAddCredito: TEdit;
    Label50: TLabel;
    edObsAddCredito: TEdit;
    Label51: TLabel;
    Label52: TLabel;
    MemoRespostaJsonAddCredito: TMemo;
    MemoMsgAddCredito: TMemo;
    Shape6: TShape;
    edSituacaoPagAddCredito: TComboBox;
    edFormaPagAddCredito: TComboBox;
    Label53: TLabel;
    FlatMemo1: TFlatMemo;
    Label54: TLabel;
    FlatMemo2: TFlatMemo;
    Button7: TButton;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    edTagAddDebito: TEdit;
    edCpfAddDebito: TEdit;
    FlatMemo3: TFlatMemo;
    Label58: TLabel;
    vlDebitoAddDebito: TEdit;
    Label59: TLabel;
    Label60: TLabel;
    edCodAutorizacaoAddDebito: TEdit;
    Label61: TLabel;
    edEmailUsuarioAddDebito: TEdit;
    Label62: TLabel;
    Label63: TLabel;
    edObsAddDebito: TEdit;
    Label64: TLabel;
    Label65: TLabel;
    MemoMsgAddDebito: TMemo;
    MemoRespostaJsonAddDebito: TMemo;
    TabSheet3: TTabSheet;
    edTipoTransacaoAddDebito: TComboBox;
    edSaldoNegativoAddDebito: TComboBox;
    ScrollBox3: TScrollBox;
    Button8: TButton;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    edTagTab3: TEdit;
    edCpfTab3: TEdit;
    Label69: TLabel;
    edValorTransacaoTab3: TEdit;
    Label70: TLabel;
    edQtdeTransacaoTAb3: TEdit;
    Label71: TLabel;
    edIdProdutoTab3: TEdit;
    Label72: TLabel;
    Label73: TLabel;
    edIdProdutoErpTAb3: TEdit;
    Label74: TLabel;
    edDataInicTab3: TDateTimePicker;
    FlatMemo4: TFlatMemo;
    edNumDocTransacao: TEdit;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    edSaldoNegativoTab3: TComboBox;
    Label78: TLabel;
    edFormaPagamentoTab3: TComboBox;
    Label79: TLabel;
    edEmailUsuarioTab3: TEdit;
    Label80: TLabel;
    edCodAutorizacaoTab3: TEdit;
    Label81: TLabel;
    edObsTab3: TEdit;
    Button9: TButton;
    FlatMemo5: TFlatMemo;
    Label82: TLabel;
    edDataFimTab3: TDateTimePicker;
    BitBtn1: TBitBtn;
    FlatMemo6: TFlatMemo;
    Label83: TLabel;
    edNrCupomTab3: TEdit;
    BitBtn2: TBitBtn;
    FlatMemo7: TFlatMemo;
    Label84: TLabel;
    edIdFilialTab3: TEdit;
    Label85: TLabel;
    Label86: TLabel;
    MemoMsgTab3: TMemo;
    MemoRespostaJsonTab3: TMemo;
    edSituacaoPagamentoTab3: TComboBox;
    edTipoCartaoAddTag: TComboBox;
    edCobrancaTarifaAddTag: TComboBox;
    BitBtn3: TBitBtn;
    FlatMemo8: TFlatMemo;
    BitBtn5: TBitBtn;
    FlatMemo9: TFlatMemo;
    BitBtn4: TBitBtn;
    BitBtn6: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure bt7Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
  private
    // JSON : myJSONItem;
    IntegracaoEasyChopp: TUnitIntegracaoEasyChopp;
     Registros : TEasyClienteTransacoes;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FintegracaoEasyChopp: TFintegracaoEasyChopp;

  
implementation

{$R *.dfm}

procedure TFintegracaoEasyChopp.Button1Click(Sender: TObject);
begin
  IntegracaoEasyChopp.login(edFilial.text, edLogin.text, edSenha.text);

  MemoMsgLogin.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonLogin.lines.add(IntegracaoEasyChopp.RespostaWebService);
  MemoToken.lines.add(IntegracaoEasyChopp.TokenAcesso);

end;

procedure TFintegracaoEasyChopp.FormCreate(Sender: TObject);
begin

  IntegracaoEasyChopp := TUnitIntegracaoEasyChopp.Create();

end;

procedure TFintegracaoEasyChopp.Button2Click(Sender: TObject);
begin
  IntegracaoEasyChopp.GetCliente(edCpf.text, edTag.text);

  MemoHeaderGetCliente.lines.add(IntegracaoEasyChopp.header);
  MemoMsgGetCliente.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonGetCliente.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.Button3Click(Sender: TObject);
begin
  IntegracaoEasyChopp.AddCliente(edNome.text, edEmail.text, edSexo.text,
    edCpfAddCliente.text, edTelefone.text, edDtnasc.text);

  // MemoHeaderGetCliente.Lines.Add(IntegracaoEasyChopp.header);
  MemoMsgAddCliente.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonAddCliente.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.Button4Click(Sender: TObject);
begin
  MemoMsgGetCredito.clear;
  MemoRespostaJsonGetCredito.clear;
  IntegracaoEasyChopp.GetCredito(edCpfGetCredito.text, edTagGetCredito.text);

  MemoMsgGetCredito.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonGetCredito.lines.add(IntegracaoEasyChopp.RespostaWebService);
  edCredito.text := floattostr(IntegracaoEasyChopp.credito);
end;

procedure TFintegracaoEasyChopp.Button5Click(Sender: TObject);
begin

  IntegracaoEasyChopp.AddTag(edCpfAddTag.text, edTagAddTag.text,
    strtoint(copy(edTipoCartaoAddTag.text,1,1)), strtoint(edCobrancaTarifaAddTag.text),
    edEmailAddTag.text);

  MemoMsgAddTag.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonAddTag.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.FormShow(Sender: TObject);
begin
//  Button1.Click;
end;

procedure TFintegracaoEasyChopp.Button6Click(Sender: TObject);
begin
  IntegracaoEasyChopp.RemoveTag(edcpfRemoveTag.text, edTagRemoveTag.text);

  MemoMsgRemoveTag.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonRemoveTag.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.bt7Click(Sender: TObject);
begin
  IntegracaoEasyChopp.addCredito(edCpfAddCredito.text, edTagAddCredito.text,
    strtofloat(edVlCreditoAddCredito.text), edCodAutorizacaoAddCredito.text,
    edEmailUsuarioAddCredito.text, strtobool(edSituacaoPagAddCredito.text),
    strtoint(copy(edFormaPagAddCredito.text, 1, 1)), edNumCumpoAddCredito.text,
    edObsAddCredito.text);

  MemoMsgAddCredito.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonAddCredito.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.Button7Click(Sender: TObject);
begin
  IntegracaoEasyChopp.addDebito(edCpfAddDebito.text, edTagAddDebito.text,
    strtofloat(vlDebitoAddDebito.text),
    strtoint(copy(edTipoTransacaoAddDebito.text, 1, 1)),
    edCodAutorizacaoAddDebito.text, edEmailUsuarioAddCredito.text,
    strtobool(edSaldoNegativoAddDebito.text), edObsAddCredito.text);

  MemoMsgAddDebito.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonAddDebito.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.Button8Click(Sender: TObject);
begin

  MemoMsgTab3.clear;
  MemoRespostaJsonTab3.clear;

 IntegracaoEasyChopp.addVenda(edCpfTab3.text,
  	edTagTab3.text,
    	datetimetostr(now),
    	strtofloat(edValorTransacaoTab3.text),
    	strtofloat(edQtdeTransacaoTAb3.text),
    	edIdProdutoTab3.text,
    	edIdProdutoErpTAb3.text,
    	edNumDocTransacao.text,
    	strtoint(copy(edSituacaoPagamentoTab3.text, 1, 1)),
    	strtobool(edSaldoNegativoTab3.text),
    	strtoint(copy(edFormaPagamentoTab3.text, 1, 1)),
    	edCodAutorizacaoTab3.text,
    	edEmailUsuarioTab3.text,
     edObsTab3.text);

  MemoMsgTab3.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonTab3.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.Button9Click(Sender: TObject);
var
transacoes : tTransacoesArray;
i,j:integer;
begin
  MemoMsgTab3.clear;
  MemoRespostaJsonTab3.clear;
    transacoes :=  IntegracaoEasyChopp.GetTransacoesPendentes(edCpfTab3.text, edTagTab3.text,
    datetimetostr(edDataInicTab3.datetime), datetimetostr(edDatafimTab3.datetime) );

    
       for i:=0 to  length(transacoes) -1 do
        for  j:=0 to length(transacoes[i]) -1  do
        begin
          showmessage(transacoes[i][j]);

        end;



  MemoMsgTab3.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonTab3.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.BitBtn1Click(Sender: TObject);
begin
    MemoMsgTab3.clear;
    MemoRespostaJsonTab3.clear;

    IntegracaoEasyChopp.addPagamentoTransacoes(edCpfTab3.text,
    	edTagTab3.text,
    	datetimetostr(edDataInicTab3.datetime),
    	strtofloat(edValorTransacaoTab3.text),
    	strtoint(copy(edFormaPagamentoTab3.text, 1, 1)),
    	edNrCupomTab3.text,
    	edCodAutorizacaoTab3.text,
    	edEmailUsuarioTab3.text,
    	edObsTab3.text,
    	strtoint(edNumDocTransacao.text),
    	datetimetostr(edDataInicTab3.datetime),
    	strtofloat(edValorTransacaoTab3.text),
    	strtoint(edIdProdutoTab3.text));

  MemoMsgTab3.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonTab3.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.BitBtn2Click(Sender: TObject);

begin
  MemoMsgTab3.clear;
  MemoRespostaJsonTab3.clear;

  Registros := IntegracaoEasyChopp.getTransacoesPendentesPagamentoFilial(edIdFilialtab3.text );

//  showmessage(inttostr(registros.lstClientes[0].idCliente));

  MemoMsgTab3.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonTab3.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;



procedure TFintegracaoEasyChopp.BitBtn3Click(Sender: TObject);
var
transacoes : tTransacoesArray;
i,j:integer;
begin

  MemoMsgTab3.clear;
  MemoRespostaJsonTab3.clear;

 //showmessage(inttostr(IntegracaoEasyChopp.UNIXTimeInMilliseconds));

transacoes := IntegracaoEasyChopp.getTransacoesClienteCPF(edCpftab3.text,
  formatdatetime('YYYY-MM-DD',edDataInicTab3.datetime),
   formatdatetime('YYYY-MM-DD',edDataFimTab3.datetime)) ;

       for i:=0 to  length(transacoes) -1 do
        for  j:=0 to length(transacoes[i]) -1  do
        begin
//          showmessage(transacoes[i][j]);

        end;





// IntegracaoEasyChopp.getTransacoesClienteCPF(edCpf.text,
// formatdatetime('YYYY-MM-DD',now),
// formatdatetime('YYYY-MM-DD',now) );

  MemoMsgTab3.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonTab3.lines.add(IntegracaoEasyChopp.RespostaWebService);


end;

procedure TFintegracaoEasyChopp.BitBtn4Click(Sender: TObject);
begin
  MemoMsgTab3.clear;
  MemoRespostaJsonTab3.clear;

 IntegracaoEasyChopp.estornarCupomVenda(edNumDocTransacao.text, edEmailUsuarioTab3.text, edObsTab3.text );

  MemoMsgTab3.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonTab3.lines.add(IntegracaoEasyChopp.RespostaWebService);


end;

procedure TFintegracaoEasyChopp.BitBtn5Click(Sender: TObject);
begin
  MemoMsgTab3.clear;
  MemoRespostaJsonTab3.clear;

 IntegracaoEasyChopp.addVendaLote(edCpfTab3.text,
 	edTagTab3.text,
 	strtobool(edSaldoNegativoTab3.text),
 	edEmailUsuarioTab3.text,
 	datetimetostr(edDataInicTab3.datetime),
 	strtofloat(edValorTransacaoTab3.text),
 	strtofloat(edQtdeTransacaoTAb3.text),
 	edIdProdutoTab3.text,
 	edIdProdutoErpTAb3.text,
 	edNumDocTransacao.text,
 	copy(edSituacaoPagamentoTab3.text, 1, 1),
 	strtoint(copy(edFormaPagamentoTab3.text, 1, 1)),
 	edCodAutorizacaoTab3.text,
 	edObsTab3.text);


  

  MemoMsgTab3.lines.add(IntegracaoEasyChopp.burl);
  MemoRespostaJsonTab3.lines.add(IntegracaoEasyChopp.RespostaWebService);

end;

procedure TFintegracaoEasyChopp.BitBtn6Click(Sender: TObject);
begin

     MemoMsgTab3.clear;
     MemoRespostaJsonTab3.clear;

     IntegracaoEasyChopp.getTodosClientes('19/01/2023 00:00:00');

     MemoMsgTab3.lines.add(IntegracaoEasyChopp.burl);
     MemoRespostaJsonTab3.lines.add(IntegracaoEasyChopp.RespostaWebService);



end;

end.

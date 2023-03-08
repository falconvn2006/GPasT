unit uNovoPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.UIConsts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.JSON, FMX.Platform, FMX.VirtualKeyboard,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,IdCoderMIME,  System.math, System.NetEncoding,
  System.Math.Vectors, Soap.EncdDecd, System.Rtti,
  System.Actions,
  System.Threading,
  System.Permissions,
  FMX.MultiView,
  FMX.ActnList,
  FMX.ListBox,
  FMX.Controls3D,
  {$IFDEF ANDROID}
    ZXing.BarcodeFormat,
    ZXing.ReadResult,
    ZXing.ScanManager,
    Androidapi.JNI.JavaTypes,
    Androidapi.JNI.GraphicsContentViewText,
    FMX.Helpers.Android,
    Androidapi.Helpers,
    Androidapi.NativeActivity,
    Androidapi.JNIBridge,
    IdURI,
    Androidapi.Jni.Net,
    Androidapi.JNI.Os,
  {$ELSE}
//     Winapi.Windows,
  {$ENDIF}
  FMX.Media, FMX.EditBox, FMX.SpinBox, DataPak.Android.BarcodeScanner;


type
  TF_NovoPedido = class(TForm)
    LayoutTopo: TLayout;
    RectangleTopo: TRectangle;
    ImageVoltar: TImage;
    LabelTitulo: TLabel;
    ImageCesta: TImage;
    LayoutBottom: TLayout;
    RectangleBottom: TRectangle;
    ImageExclui: TImage;
    LayoutTotais: TLayout;
    LabelValor: TLabel;
    LayoutCliente: TLayout;
    Layout1: TLayout;
    RoundRectPesquisa: TRoundRect;
    LabelSeleciona: TLabel;
    EditPesquisa: TEdit;
    LabelNumero: TLabel;
    TabControl1: TTabControl;
    TabItemIncluiItem: TTabItem;
    TabItemFinalizaPedido: TTabItem;
    Layout2: TLayout;
    ListViewPesquisa: TListView;
    ImageDetalhe: TImage;
    ImageFoto: TImage;
    ImagePesquisa: TImage;
    StyleBook1: TStyleBook;
    ImagePesquisaCodigo: TImage;
    ImagePesquisaDescricao: TImage;
    ImagePesquisaCEAN: TImage;
    Layout3: TLayout;
    LabelTotalPesquisa: TLabel;
    LinePesquisa: TLine;
    ImageLimpa: TImage;
    ImagePesquisaCodigo2: TImage;
    ImagePesquisaDescricao2: TImage;
    ImagePesquisaCEAN2: TImage;
    LayoutCEAN: TLayout;
    LayoutDescricao: TLayout;
    LayoutCodigo: TLayout;
    ImageNumeroItens: TImage;
    LabelNumeroItens: TLabel;
    LayoutClienteFinaliza: TLayout;
    LabelDadosPedido: TLabel;
    Line1: TLine;
    RoundRectCliente: TRoundRect;
    EditCliente: TEdit;
    Image3: TImage;
    ImageLimpaCliente: TImage;
    LabelTituloCliente: TLabel;
    LayoutCondicaoFinaliza: TLayout;
    RoundRectCondicao: TRoundRect;
    EditCondicao: TEdit;
    Image5: TImage;
    ImageLimpaCondicao: TImage;
    LabelCondicao: TLabel;
    LayoutItens: TLayout;
    ListViewItens: TListView;
    Image1: TImage;
    Image2: TImage;
    LabelTotalItens: TLabel;
    Line3: TLine;
    Layout4: TLayout;
    TabItemPesquisaCliente: TTabItem;
    LayoutCliente1: TLayout;
    ListViewCliente: TListView;
    Image9: TImage;
    Label1: TLabel;
    Line2: TLine;
    TabItemPesquisaCondicao: TTabItem;
    LayoutCliente21: TLayout;
    ListViewCondicao: TListView;
    Image4: TImage;
    Label6: TLabel;
    Line5: TLine;
    ImageSoma: TImage;
    ImageSubtrai: TImage;
    ImageFinalizaPedido: TImage;
    LayoutProdutoDetalhe: TLayout;
    RectangleFundo: TRectangle;
    RectangleDetalhe: TRectangle;
    LayoutFoto: TLayout;
    Image6: TImage;
    LabelDescricaoProduto: TLabel;
    Image7: TImage;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Layout5: TLayout;
    Label7: TLabel;
    Rectangle4: TRectangle;
    Layout6: TLayout;
    Rectangle5: TRectangle;
    Label4: TLabel;
    Rectangle6: TRectangle;
    LabelUnitarioProduto: TLabel;
    Layout7: TLayout;
    Rectangle7: TRectangle;
    Label8: TLabel;
    Rectangle8: TRectangle;
    LabelMarcaProduto: TLabel;
    Layout8: TLayout;
    Rectangle9: TRectangle;
    Label10: TLabel;
    Rectangle10: TRectangle;
    LabelFabricanteProduto: TLabel;
    Layout9: TLayout;
    Rectangle11: TRectangle;
    Label12: TLabel;
    Rectangle12: TRectangle;
    LabelUnidadeProduto: TLabel;
    Layout10: TLayout;
    Rectangle13: TRectangle;
    Label14: TLabel;
    Rectangle14: TRectangle;
    LabelCEANProduto: TLabel;
    Layout11: TLayout;
    Rectangle15: TRectangle;
    Label16: TLabel;
    Rectangle16: TRectangle;
    LabelCodigoProduto: TLabel;
    Rectangle17: TRectangle;
    LayoutCamera: TLayout;
    RectangleFundoCamera: TRectangle;
    CameraComponent1: TCameraComponent;
    RectangleCamera: TRectangle;
    Button1: TButton;
    Layout12: TLayout;
    Memo1: TMemo;
    imgCamera: TImage;
    ImageImprime: TImage;
    Image8: TImage;
    LayoutGrade: TLayout;
    RectangleFundoGrade: TRectangle;
    RectangleGrade: TRectangle;
    LayoutTituloTamanho: TLayout;
    RectangleTitulo: TRectangle;
    LabelTituloGradeNumeracao: TLabel;
    Label5: TLabel;
    Line6: TLine;
    LayoutTamanho1: TLayout;
    RoundRectTamanho1: TRoundRect;
    LabelTamanho1: TLabel;
    RoundRectTamanho2: TRoundRect;
    LabelTamanho2: TLabel;
    RoundRectTamanho3: TRoundRect;
    LabelTamanho3: TLabel;
    RoundRectTamanho4: TRoundRect;
    LabelTamanho4: TLabel;
    RoundRectTamanho5: TRoundRect;
    LabelTamanho5: TLabel;
    LayoutTamanho2: TLayout;
    RoundRectTamanho6: TRoundRect;
    LabelTamanho6: TLabel;
    RoundRectTamanho7: TRoundRect;
    LabelTamanho7: TLabel;
    RoundRectTamanho8: TRoundRect;
    LabelTamanho8: TLabel;
    RoundRectTamanho9: TRoundRect;
    LabelTamanho9: TLabel;
    RoundRectTamanho10: TRoundRect;
    LabelTamanho10: TLabel;
    LayoutTituloCor: TLayout;
    Label9: TLabel;
    Line4: TLine;
    LayoutCor1: TLayout;
    RoundRectCor1: TRoundRect;
    LabelCor1: TLabel;
    RoundRectCor2: TRoundRect;
    LabelCor2: TLabel;
    RoundRectCor3: TRoundRect;
    LabelCor3: TLabel;
    RoundRectCor4: TRoundRect;
    LabelCor4: TLabel;
    LayoutCor2: TLayout;
    RoundRectCor5: TRoundRect;
    LabelCor5: TLabel;
    RoundRectCor6: TRoundRect;
    LabelCor6: TLabel;
    RoundRectCor7: TRoundRect;
    LabelCor7: TLabel;
    RoundRectCor8: TRoundRect;
    LabelCor8: TLabel;
    LayoutGradeBottom: TLayout;
    RoundRectConfirma: TRoundRect;
    Label11: TLabel;
    RoundRectCancela: TRoundRect;
    Label13: TLabel;
    RoundRectIncluiItem: TRoundRect;
    Label3: TLabel;
    LayoutTituloQtde: TLayout;
    LabelQuantidade: TLabel;
    Line7: TLine;
    LayoutQuantidade: TLayout;
    RoundRect2: TRoundRect;
    EditQtde: TEdit;
    Image10: TImage;
    Image11: TImage;
    LayoutProduto: TLayout;
    LabelProduto: TLabel;
    TabItemTeste: TTabItem;
    Memo2: TMemo;
    Button2: TButton;
    Image12: TImage;
    Image13: TImage;
    Button3: TButton;
    Image14: TImage;
    Timer1: TTimer;
    RoundRectFinalizaPedido: TRoundRect;
    Label15: TLabel;
    LabelEmpresa: TLabel;
    Image15: TImage;
    LabelPreco: TLabel;
    BarcodeScanner1: TBarcodeScanner;
    procedure ImageVoltarClick(Sender: TObject);
    procedure ImagePesquisaClick(Sender: TObject);
    procedure ImagePesquisaCodigoClick(Sender: TObject);
    procedure ImagePesquisaDescricaoClick(Sender: TObject);
    procedure ImagePesquisaCEANClick(Sender: TObject);
    procedure ImageLimpaClick(Sender: TObject);
    procedure ImagePesquisaDescricao2Click(Sender: TObject);
    procedure ImagePesquisaCEAN2Click(Sender: TObject);
    procedure ImagePesquisaCodigo2Click(Sender: TObject);
    procedure ListViewPesquisaItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure ImageExcluiClick(Sender: TObject);
    procedure ImageCestaClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListViewClienteItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure ImageLimpaClienteClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure ListViewCondicaoItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure ImageLimpaCondicaoClick(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure ListViewItensItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure ImageFinalizaPedidoClick(Sender: TObject);
    procedure EditClienteKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure EditCondicaoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure Image7Click(Sender: TObject);
    procedure EditPesquisaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure CameraComponent1SampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ImageImprimeClick(Sender: TObject);
    procedure RoundRectConfirmaClick(Sender: TObject);
    procedure RoundRectCancelaClick(Sender: TObject);
    procedure RoundRectTamanho1Click(Sender: TObject);
    procedure RoundRectCor1Click(Sender: TObject);
    procedure RoundRectIncluiItemClick(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image13Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ListViewPesquisaPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure BarcodeScanner1ScanResult(Sender: TObject; AResult: string);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
// Camera
    fPermissionCamera: String;
    fScanInProgress: Boolean;
    fFrameTake,FIdCor,FPagina,FPrecoCondicao: Integer;
    fScanBitmap: TBitmap;
    FTamanho,FCor: string;
    procedure ParseImage();
//
    procedure AcionaPesquisaProduto(XProduto,XPrompt: string);
    procedure IncluiNovoItem(XIdPedido, XIdProduto: integer; XPreco: string);
    procedure FinalizaPedido(XPedido: integer);
    procedure ReabrePedido(XIdPedido: integer);
    procedure AcionaPesquisaCliente(XCliente: string);
    procedure AcionaPesquisaCondicao(XCondicao: string);
    function RetornaTipoCondicao(XTipo: string): string;
    function  AlteraItem(XIdOrcamento, XIdItem: integer; XQtde,XTotal: double): boolean;
    procedure AlteraPedido(XTipo, XId, XIdPedido: string);
    procedure AlteraQuantidade(Xidorcamento, Xid: integer; Xqtde,Xtotal: double);
    procedure ExcluiQuantidade(xidorcamento, xid: integer);
    procedure DeletaPedido;
    procedure FechaTecladoVirtual;
    procedure AbreTecladoVirtual(XEdit: TEdit);
    procedure AbreCamera;
    procedure FechaCamera;
    procedure CameraPermissionRequestResult(Sender: TObject;
      const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>);
    procedure ExplainReason(Sender: TObject; const APermissions: TArray<string>;
      const APostRationaleProc: TProc);
    function AppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    procedure IniciaScanner;
    procedure CarregaGradeProduto(XIdProduto,XCor: integer; XTamanho: string);
    function RetornaTamanho(XTamanho: string): boolean;
    function RetornaCor(XCor: string): boolean;
    procedure IncluiNovoItemGrade(XIdPedido, XIdProduto, XTamanho,
      XCor,XQtde: integer; XPreco: string);
    function BitmapFromBase64(const base64: string): TBitmap;
    function BitmapFromBase64x(const base64: string): TBitmap;
    procedure CreateJpg(Data: string);
    function RetiraBarra(XBase64: string): string;
    procedure AcionaPesquisaProdutoEtiqueta(XPesquisa: string);
    procedure EfetivaPesquisaProduto(XProduto, XTipo: string; XPagina: integer);
    function RecuperaLeitura: string;
    procedure AtualizaUnitarioItem(XIdPedido: string);
    function AlteraUnitarioItem(XIdOrcamento, XIdItem: integer;
      XUnitario,XTotal: double): boolean;
    { Private declarations }
  public
    FPesquisaCliente,FPesquisaCondicao: boolean;
    procedure AtualizaNumeroItens(XIdPedido: integer);
    procedure CarregaListaItens;
    function AppBarcodeScanInstalado: Boolean;
    { Public declarations }
  end;

var
  F_NovoPedido: TF_NovoPedido;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses uMeusPedidos, pComuns, Loading, uCamera, FMX.DialogService, IdGlobal,
  uDemoCodeReader;

var wtamanho,wcor: array[1..30] of string;


procedure TF_NovoPedido.EditClienteKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (FPesquisaCliente) and (Key=vkReturn) and (length(trim(EditCliente.Text))>0) then
     AcionaPesquisaCliente(EditCliente.Text);
end;

procedure TF_NovoPedido.EditCondicaoKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (FPesquisaCondicao) and (Key=vkReturn) and (length(trim(EditCondicao.Text))>0) then
     AcionaPesquisaCondicao(EditCondicao.Text);
end;

procedure TF_NovoPedido.AcionaPesquisaCondicao(XCondicao: string);
var wimgmore: TMemoryStream;
    wbmp: TBitmap;
begin
  try
      ListViewCondicao.BeginUpdate;
      ListViewCondicao.items.Clear;

      wimgmore          := TMemoryStream.Create;
      Image4.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp   := TBitmap.Create;
      wbmp.LoadFromStream(wimgmore);


      TLoading.Show(F_NovoPedido,'Aguarde...Carregando lista de condições');

      TThread.CreateAnonymousThread(procedure
                                    begin
                                      if F_MeusPedidos.Fprovider.CarregaCondicoes(XCondicao) then
                                         begin
                                           TThread.Synchronize(nil, procedure
                                                               begin
                                                                 while not F_MeusPedidos.Fprovider.FDMemTableCondicoes.Eof do
                                                                 begin
                                                                   with ListViewCondicao.Items.Add do
                                                                   begin
                                                                      TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap    := wbmp;
                                                                      TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString;

                                                                      TListItemText(Objects.FindDrawable('TextDescricao')).Text := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('descricao').AsString;
                                                                      TListItemText(Objects.FindDrawable('TextNumero')).Text    := 'Pagamentos: '+F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('numpag').AsString;
                                                                      TListItemText(Objects.FindDrawable('TextTipo')).Text      := RetornaTipoCondicao(F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('tipo').AsString);
                                                                   end;
                                                                   F_MeusPedidos.Fprovider.FDMemTableCondicoes.Next;
                                                                 end;
                                                                 ListViewCondicao.EndUpdate;
                                                                 if F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount=1 then
                                                                    begin
                                                                      EditCondicao.Text      := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('descricao').AsString;
                                                                      EditCondicao.TagString := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString;
                                                                      AlteraPedido('condicao',F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString,LabelNumero.TagString);
                                                                    end
                                                                 else if F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount>0 then
                                                                    TabControl1.ActiveTab := TabItemPesquisaCondicao;
                                                                 TLoading.Hide;
                                                               end);
                                         end
                                       else
                                         begin
                                           TThread.Synchronize(nil, procedure
                                                               begin
                                                                 TLoading.Hide;
                                                               end);
                                         end;
                                    end).Start;

{      if F_MeusPedidos.Fprovider.CarregaCondicoes(XCondicao) then
         while not F_MeusPedidos.Fprovider.FDMemTableCondicoes.Eof do
         begin
           with ListViewCondicao.Items.Add do
           begin
              TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap    := wbmp;
              TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString;

              TListItemText(Objects.FindDrawable('TextDescricao')).Text := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('descricao').AsString;
              TListItemText(Objects.FindDrawable('TextNumero')).Text    := 'Pagamentos: '+F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('numpag').AsString;
              TListItemText(Objects.FindDrawable('TextTipo')).Text      := RetornaTipoCondicao(F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('tipo').AsString);
           end;
           F_MeusPedidos.Fprovider.FDMemTableCondicoes.Next;
         end;}
  finally
    TLoading.Hide;
{    ListViewCondicao.EndUpdate;
    if F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount=1 then
       begin
         EditCondicao.Text      := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('descricao').AsString;
         EditCondicao.TagString := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString;
         AlteraPedido('condicao',F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString,LabelNumero.TagString);
       end
    else if F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount>0 then
       TabControl1.ActiveTab := TabItemPesquisaCondicao;}

  end;
end;

function TF_NovoPedido.RetornaTipoCondicao(XTipo: string): string;
var wret: string;
begin
  if XTipo='N' then
     wret := 'Normal'
  else if XTipo='X' then
     wret := 'Prazo Médio Fixo'
  else if XTipo='Z' then
     wret := 'Prazo Médio Normal'
  else
     wret := XTipo;
  Result := wret;
end;


procedure TF_NovoPedido.RoundRectIncluiItemClick(Sender: TObject);
begin
   TabControl1.ActiveTab := TabItemIncluiItem;
   LabelTitulo.Text      := 'Inclui Ítem';
   ImageFinalizaPedido.Visible := false;
   ImageCesta.Visible    := true;
   ImageExclui.Visible   := true;
end;

procedure TF_NovoPedido.RoundRectCancelaClick(Sender: TObject);
begin
  LayoutGrade.Visible := false;
end;

procedure TF_NovoPedido.RoundRectConfirmaClick(Sender: TObject);
var widpedido,widproduto: integer;
    wpreco: string;
begin
  widpedido  := strtoint(LabelNumero.TagString);
  widproduto := strtoint(LabelTituloGradeNumeracao.TagString);
  wpreco     := LabelQuantidade.TagString;
  IncluiNovoItemGrade(widpedido,widproduto,strtointdef(FTamanho,0),FIdCor,strtointdef(EditQtde.Text,1),wpreco);
  LayoutGrade.Visible := false;
end;

procedure TF_NovoPedido.RoundRectCor1Click(Sender: TObject);
var wrect: TRoundRect;
begin
  wrect := Sender as TRoundRect;
  RoundRectCor1.Fill.Color := $FFE0E0E0;
  RoundRectCor2.Fill.Color := $FFE0E0E0;
  RoundRectCor3.Fill.Color := $FFE0E0E0;
  RoundRectCor4.Fill.Color := $FFE0E0E0;
  RoundRectCor5.Fill.Color := $FFE0E0E0;
  RoundRectCor6.Fill.Color := $FFE0E0E0;
  RoundRectCor7.Fill.Color := $FFE0E0E0;
  RoundRectCor8.Fill.Color := $FFE0E0E0;
  FCor                    := wrect.TagString;
  FIdCor                  := strtointdef(wrect.Hint,0);

  RoundRectConfirma.Enabled := (FTamanho<>'') and (FCor<>'');

  wrect.Fill.Color := TAlphaColorRec.Lime;
end;

procedure TF_NovoPedido.RoundRectTamanho1Click(Sender: TObject);
var wrect: TRoundRect;
begin
  wrect := Sender as TRoundRect;
  RoundRectTamanho1.Fill.Color  := $FFE0E0E0;
  RoundRectTamanho2.Fill.Color  := $FFE0E0E0;
  RoundRectTamanho3.Fill.Color  := $FFE0E0E0;
  RoundRectTamanho4.Fill.Color  := $FFE0E0E0;
  RoundRectTamanho5.Fill.Color  := $FFE0E0E0;
  RoundRectTamanho6.Fill.Color  := $FFE0E0E0;
  RoundRectTamanho7.Fill.Color  := $FFE0E0E0;
  RoundRectTamanho8.Fill.Color  := $FFE0E0E0;
  RoundRectTamanho9.Fill.Color  := $FFE0E0E0;
  RoundRectTamanho10.Fill.Color := $FFE0E0E0;
  FTamanho                      := wrect.TagString;
  RoundRectConfirma.Enabled := (FTamanho<>'') and (FCor<>'');

  wrect.Fill.Color := TAlphaColorRec.Lime;
end;

procedure TF_NovoPedido.AcionaPesquisaCliente(XCliente: string);
var wimgmore: TMemoryStream;
    wbmp: TBitmap;
begin
  try
      ListViewCliente.BeginUpdate;
      ListViewCliente.items.Clear;

      wimgmore          := TMemoryStream.Create;
      Image9.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp   := TBitmap.Create;
      wbmp.LoadFromStream(wimgmore);

      TLoading.Show(F_NovoPedido,'Aguarde...Carregando lista de clientes');

      TThread.CreateAnonymousThread(procedure
                                    begin
                                      if F_MeusPedidos.Fprovider.CarregaClientes(XCliente) then
                                         begin
                                           TThread.Synchronize(nil, procedure
                                                               begin
                                                                 while not F_MeusPedidos.Fprovider.FDMemTableClientes.Eof do
                                                                 begin
                                                                   with ListViewCliente.Items.Add do
                                                                   begin
                                                                      TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap    := wbmp;
                                                                      TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('id').AsString;

                                                                      TListItemText(Objects.FindDrawable('TextNome')).Text      := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('nome').AsString;
                                                                      TListItemText(Objects.FindDrawable('TextCodigo')).Text    := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('codigo').AsString;
                                                                      TListItemText(Objects.FindDrawable('TextDocumento')).Text := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('cpf').AsString;
                                                                   end;
                                                                   F_MeusPedidos.Fprovider.FDMemTableClientes.Next;
                                                                 end;
                                                                 ListViewCliente.EndUpdate;
                                                                 if F_MeusPedidos.Fprovider.FDMemTableClientes.RecordCount=1 then
                                                                    begin
                                                                      EditCliente.Text      := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('nome').AsString;
                                                                      EditCliente.TagString := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('id').AsString;
                                                                      AlteraPedido('cliente',F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('id').AsString,LabelNumero.TagString);
                                                                    end
                                                                 else if F_MeusPedidos.Fprovider.FDMemTableClientes.RecordCount>0 then
                                                                    TabControl1.ActiveTab := TabItemPesquisaCliente;
                                                                 TLoading.Hide;
                                                               end);
                                         end
                                       else
                                         begin
                                           TThread.Synchronize(nil, procedure
                                                               begin
                                                                 TLoading.Hide;
                                                               end);
                                         end;
                                    end).Start;

{      if F_MeusPedidos.Fprovider.CarregaClientes(XCliente) then
         while not F_MeusPedidos.Fprovider.FDMemTableClientes.Eof do
         begin
           with ListViewCliente.Items.Add do
           begin
              TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap    := wbmp;
              TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('id').AsString;

              TListItemText(Objects.FindDrawable('TextNome')).Text      := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('nome').AsString;
              TListItemText(Objects.FindDrawable('TextCodigo')).Text    := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('codigo').AsString;
              TListItemText(Objects.FindDrawable('TextDocumento')).Text := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('cpf').AsString;
           end;
           F_MeusPedidos.Fprovider.FDMemTableClientes.Next;
         end;}

  finally
  end;
end;

procedure TF_NovoPedido.EditPesquisaKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (key = vkReturn) and (length(trim(EditPesquisa.Text))>0) then
     begin
       if (EditPesquisa.TextPrompt = 'Digite o código de barras do produto') and
          (prvComuns.RetornaTipoLeituraCEAN) then // pesquisa por código de barras c/leitura de etiquetas
          begin
             AcionaPesquisaProdutoEtiqueta(EditPesquisa.Text);
          end
      else
           AcionaPesquisaProduto(EditPesquisa.Text,EditPesquisa.TextPrompt);
     end;
end;

procedure TF_NovoPedido.AcionaPesquisaProdutoEtiqueta(XPesquisa: string);
var wcodigo,wtam,wcor,wpreco: string;
    widproduto: integer;
begin
  wcodigo := copy(XPesquisa,1,6);
  wtam    := copy(XPesquisa,7,3);
  wcor    := copy(XPesquisa,10,4);
  if F_MeusPedidos.Fprovider.PesquisaProdutos(wcodigo,'código',-1) then
     begin
       LabelTituloGradeNumeracao.TagString := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('id').AsString;
       CarregaGradeProduto(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('id').AsInteger,strtointdef(wcor,0),trim(wtam));
       EditQtde.Text       := '1';

       case F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xprecocondicao').AsInteger of
         1: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsString;
         2: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco2').AsString;
         3: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco3').AsString;
         4: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco4').AsString;
         5: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco5').AsString;
         6: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco6').AsString;
         7: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco7').AsString;
         8: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco8').AsString;
         9: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco9').AsString;
         10: wpreco := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco10').AsString;
       end;

       LabelQuantidade.TagString := wpreco;
       LabelProduto.Text         := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('codigo').AsString+' - '+
                                    F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('descricao').AsString;
       LabelPreco.Text           := formatfloat('R$ #,0.00',strtofloat(wpreco));
       LayoutGrade.Visible       := true;
       EditPesquisa.Text         := '';
     end;
end;


procedure TF_NovoPedido.BarcodeScanner1ScanResult(Sender: TObject;
  AResult: string);
var wobject: TObject;
    wkeyword: word;
    wkeychar: char;
    wshift: TShiftState;
begin
 try
//  showmessage('scan');
 if length(trim(AResult))>0 then
     begin
//        showmessage(AResult);
        wobject  := F_NovoPedido.EditPesquisa;
        wkeyword := vkReturn;
        wkeychar := #13;
        wshift   := [];
        EditPesquisa.Text := AResult;
        EditPesquisa.OnKeyDown(wobject,wkeyword,wkeychar,wshift);
     end;
  except
    On E: Exception do
    begin
      showmessage('Erro de leitura '+E.Message);
    end;
  end;
end;

function TF_NovoPedido.BitmapFromBase64(const base64: string): TBitmap;
var wbmp: TBitmap;
    Input: TStringStream;
    Output: TBytesStream;
    s: string;
begin
//  FechaCamera;
  try
//    s := Memo2.Text;
    s := base64;
    Input := TStringStream.Create(s, TEncoding.UTF8);
    Input.Position := 0;
    Output := TBytesStream.Create;
    Soap.EncdDecd.DecodeStream(Input, Output);
    Output.Position := 0;
    wbmp := TBitmap.Create;
    wbmp.LoadFromStream(Output);
  finally

  end;
end;

procedure TF_NovoPedido.Image10Click(Sender: TObject);
var wqtde: integer;
begin
  wqtde         := strtointdef(EditQtde.Text,0);
  if wqtde>1 then
     EditQtde.Text := formatfloat('#0',wqtde-1);
end;

procedure TF_NovoPedido.Image11Click(Sender: TObject);
var wqtde: integer;
begin
  wqtde         := strtointdef(EditQtde.Text,0);
  EditQtde.Text := formatfloat('#0',wqtde+1);
end;

procedure TF_NovoPedido.Image13Click(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItemTeste;
end;

procedure TF_NovoPedido.Image3Click(Sender: TObject);
begin
  AcionaPesquisaCliente(EditCliente.Text);
end;

procedure TF_NovoPedido.Image5Click(Sender: TObject);
begin
  AcionaPesquisaCondicao(EditCondicao.Text);
end;

procedure TF_NovoPedido.Image7Click(Sender: TObject);
begin
  LayoutProdutoDetalhe.Visible := false;
end;

procedure TF_NovoPedido.ImageCestaClick(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItemFinalizaPedido;
  LabelTitulo.Text      := 'Finaliza Pedido';
  //ImageFinaliza.Visible := true;
  ImageFinalizaPedido.Visible := true;
  ImageCesta.Visible    := false;

  FPesquisaCliente       := false;
  FPesquisaCondicao      := false;
  EditCliente.Text       := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xcliente').AsString;
  EditCliente.TagString  := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('idcliente').AsString;
  EditCondicao.Text      := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xcondicao').AsString;
  EditCondicao.TagString := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('idcondicao').AsString;
  FPesquisaCliente       := true;
  FPesquisaCondicao      := true;

end;

procedure TF_NovoPedido.ImageFinalizaPedidoClick(Sender: TObject);
begin
  if ListViewItens.Items.Count>0 then
     FinalizaPedido(strtoint(LabelNumero.TagString))
  else
     showmessage('Atenção! Pedido sem ítens');
end;

procedure TF_NovoPedido.ImageImprimeClick(Sender: TObject);
begin
  if F_MeusPedidos.Fprovider.DownloadPedidoPDF(strtoint(LabelNumero.TagString)) then
     begin
       F_MeusPedidos.Fprovider.AbreArquivoPedidoPDF;
//       showmessage('Download do arquivo gerado com sucesso!')
     end
  else
     showmessage('Arquivo não baixado');
end;

procedure TF_NovoPedido.FinalizaPedido(XPedido: integer);
var wpedido: TJSONObject;
begin
  wpedido := TJSONObject.Create;
  wpedido.AddPair('finalizado','true');
  wpedido.AddPair('idcliente',EditCliente.TagString);
  wpedido.AddPair('idcondicao',EditCondicao.TagString);

  TLoading.Show(F_NovoPedido,'Aguarde...Finalizando pedido');
  TThread.CreateAnonymousThread(procedure
                                begin
                                  if F_MeusPedidos.Fprovider.AlteraPedido(XPedido,wpedido) then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             EditPesquisa.Text := '';
                                                             TLoading.Hide;
                                                             F_MeusPedidos.CarregaMeusPedidos(F_MeusPedidos.DateEditPeriodo.Date);
                                                             F_MeusPedidos.Show;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Problema ao alterar pedido');
                                                           end);
                                     end;
                                end).Start;
end;

procedure TF_NovoPedido.FormActivate(Sender: TObject);
begin
//  if not F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.Locate('id',LabelNumero.TagString,[]) then
//     showmessage('pedido não localizado');


  ImageFinalizaPedido.Visible := not (TabControl1.ActiveTab = TabItemIncluiItem);
  ImageCesta.Visible          := TabControl1.ActiveTab = TabItemIncluiItem;
  
  FPesquisaCliente  := true;
  FPesquisaCondicao := true;
  if ListViewPesquisa.Items.Count > 0 then
     begin
       LabelTotalPesquisa.Visible := true;
       LabelTotalPesquisa.Text    := inttostr(ListViewPesquisa.Items.Count)+' - ÚLTIMOS PRODUTOS PESQUISADOS';
       LinePesquisa.Visible       := true;
     end
  else
     begin
       LabelTotalPesquisa.Visible := false;
       LabelTotalPesquisa.Text    := inttostr(F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount)+' - PRODUTOS ENCONTRADOS';
       LinePesquisa.Visible       := false;
     end
end;

procedure TF_NovoPedido.FormCreate(Sender: TObject);
var  AppEventSvc: IFMXApplicationEventService;
begin
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXApplicationEventService, IInterface(AppEventSvc)) then
  begin
    AppEventSvc.SetApplicationEventHandler(AppEvent);
  end;
  fFrameTake := 0;
  fScanBitmap := nil;
{$IFDEF ANDROID}
  fPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
{$ENDIF}
end;

procedure TF_NovoPedido.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key = vkHardwareBack then
     begin
       ImageVoltar.OnClick(ImageVoltar);
       key := 0;
     end;
end;

procedure TF_NovoPedido.FormShow(Sender: TObject);
begin
  if prvComuns.PesquisaEmpresa(0) then
     LabelEmpresa.text := prvComuns.FDMemTableEmpresa.FieldByName('razaosocial').AsString;
end;

procedure TF_NovoPedido.ImageLimpaClick(Sender: TObject);
begin
  EditPesquisa.Text := '';
  EditPesquisa.SetFocus;
end;

procedure TF_NovoPedido.ImageLimpaClienteClick(Sender: TObject);
begin
  EditCliente.Text      := '';
  EditCliente.TagString := '';
  EditCliente.SetFocus;
end;

procedure TF_NovoPedido.ImageLimpaCondicaoClick(Sender: TObject);
begin
  EditCondicao.Text      := '';
  EditCondicao.TagString := '';
  EditCondicao.SetFocus;
end;

procedure TF_NovoPedido.ImageExcluiClick(Sender: TObject);
begin
  try
     MessageDlg('Deseja excluir pedido?', System.UITypes.TMsgDlgType.mtInformation,
                         [System.UITypes.TMsgDlgBtn.mbYes,
                          System.UITypes.TMsgDlgBtn.mbNo], 0,
                          procedure(const AResult: System.UITypes.TModalResult)
                          begin
                            case AResult of
                              mrYES: begin
                                       DeletaPedido;
                                     end;
                              mrNo:;
                            end;
                          end)
  finally
  end;
end;

procedure TF_NovoPedido.DeletaPedido;
var widpedido: integer;
begin
  widpedido := strtoint(LabelNumero.TagString);
  TLoading.Show(F_MeusPedidos,'Aguarde...Excluindo pedido');
  TThread.CreateAnonymousThread(procedure
                                begin
                                   if prvComuns.ExcluiPedido(widpedido) then
                                       begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             F_MeusPedidos.CarregaMeusPedidos(F_MeusPedidos.DateEditPeriodo.Date);
                                                             F_MeusPedidos.Show;
                                                             TLoading.Hide;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Problema ao excluir pedido');
                                                           end);
                                     end;
                                end).Start;
end;

procedure TF_NovoPedido.ImagePesquisaCEAN2Click(Sender: TObject);
begin
  EditPesquisa.KeyboardType       := TVirtualKeyboardType.NumberPad;
  EditPesquisa.TextPrompt         := 'Digite o código de barras do produto';
  EditPesquisa.Text               := '';
//  EditPesquisa.SetFocus;
  ImagePesquisaDescricao.Visible  := false;
  ImagePesquisaDescricao2.Visible := true;
  ImagePesquisaCodigo.Visible     := false;
  ImagePesquisaCodigo2.Visible    := true;
  ImagePesquisaCEAN.Visible       := true;
  ImagePesquisaCEAN2.Visible      := false;

  if prvComuns.FTipoLeitor='CodeReader' then
     begin
       if Form1 = nil then
          Form1 := TForm1.Create(nil);
       Form1.Show;
     end
  else
     begin
       {$IFDEF ANDROID}
         Timer1.Enabled := true;
         if AppBarcodeScanInstalado then
            try
              BarcodeScanner1.Scan;
            except
              On E: Exception do
              begin
                showmessage('Erro ao scanear código '+E.Message);
              end;
            end;
       {$ENDIF}
     end;
end;

function TF_NovoPedido.AppBarcodeScanInstalado: Boolean;
  {$IFDEF ANDROID}
    var Intent : JIntent;
        Info: JApplicationInfo;
  {$ENDIF}
begin
   Try
      Result := False;
  {$IFDEF ANDROID}
      Info := SharedActivityContext.getPackageManager.getApplicationInfo(
            StringToJString('com.google.zxing.client.android'),0);

      if Info.packageName.equals(StringToJString('com.google.zxing.client.android')) then
      Begin
        Result := True;
      End;
  {$ENDIF}

    Except on E: Exception do
    begin
     Try
       {$IFDEF ANDROID}
         Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
         Intent.setData(TJnet_Uri.JavaClass.parse(StringToJString(
        'https://play.google.com/store/apps/details?id=com.google.zxing.client.android')));
         Intent.setPackage(StringToJString('com.android.vending'));
         SharedActivity.startActivity(intent);
         SharedActivity.finishActivity(0);
         {$ENDIF}
      Except
          ShowMessage('Erro ao abrir o Google Play !');
        End;
    End;
  end;
end;

function TF_NovoPedido.RecuperaLeitura: string;
var wClipBoard: IFMXClipboardService;
    wValue: TValue;
    wText: string;
begin
  try
//  showmessage('flag2');
    if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, wClipBoard) then
       begin
         wValue := wClipBoard.GetClipboard;
         if (not wValue.IsEmpty) and (wValue.TryAsType(wText)) then
            begin
              Result := wValue.ToString;
            end
         else
            begin
              Result := '';
            end;
       end
    else
       Result := '';
  except
    On E: Exception do
    begin
      showmessage('Erro ao recuperar leitura '+E.Message);
    end;
  end;
end;

procedure TF_NovoPedido.ImagePesquisaCEANClick(Sender: TObject);
begin
  EditPesquisa.KeyboardType := TVirtualKeyboardType.NumberPad;
  EditPesquisa.TextPrompt := 'Digite o código de barras do produto';
  EditPesquisa.Text       := '';
  if prvComuns.FTipoLeitor='CodeReader' then
     begin
       if Form1 = nil then
          Form1 := TForm1.Create(nil);
       Form1.Show;
     end
  else
     begin
       {$IFDEF ANDROID}
         Timer1.Enabled := true;
         if AppBarcodeScanInstalado then
            try
              BarcodeScanner1.Scan;
            except
              On E: Exception do
              begin
                showmessage('Erro ao scanear código '+E.Message);
              end;
            end;
       {$ENDIF}
     end;
//  {$IFDEF ANDROID}
//     Timer1.Enabled := true;
//     if AppBarcodeScanInstalado then
//        BarcodeScanner1.Scan;
//  {$ENDIF}
end;

procedure TF_NovoPedido.ImagePesquisaClick(Sender: TObject);
begin
  AcionaPesquisaProduto(EditPesquisa.Text,EditPesquisa.TextPrompt);
end;

procedure TF_NovoPedido.ImagePesquisaCodigo2Click(Sender: TObject);
begin
  EditPesquisa.KeyboardType       := TVirtualKeyboardType.NumberPad;
  EditPesquisa.TextPrompt         := 'Digite o código do produto';
  EditPesquisa.Text               := '';
  EditPesquisa.SetFocus;
  ImagePesquisaDescricao.Visible  := false;
  ImagePesquisaDescricao2.Visible := true;
  ImagePesquisaCodigo.Visible     := true;
  ImagePesquisaCodigo2.Visible    := false;
  ImagePesquisaCEAN.Visible       := false;
  ImagePesquisaCEAN2.Visible      := true;
end;

procedure TF_NovoPedido.ImagePesquisaCodigoClick(Sender: TObject);
begin
  EditPesquisa.KeyboardType := TVirtualKeyboardType.NumberPad;
  EditPesquisa.TextPrompt   := 'Digite o código do produto';
  EditPesquisa.Text         := '';
  EditPesquisa.SetFocus;
end;

procedure TF_NovoPedido.ImagePesquisaDescricao2Click(Sender: TObject);
begin
  EditPesquisa.KeyboardType       := TVirtualKeyboardType.Default;
  EditPesquisa.TextPrompt         := 'Digite a descrição do produto';
  EditPesquisa.Text               := '';
  EditPesquisa.SetFocus;
  ImagePesquisaDescricao.Visible  := true;
  ImagePesquisaDescricao2.Visible := false;
  ImagePesquisaCodigo.Visible     := false;
  ImagePesquisaCodigo2.Visible    := true;
  ImagePesquisaCEAN.Visible       := false;
  ImagePesquisaCEAN2.Visible      := true;
end;

procedure TF_NovoPedido.ImagePesquisaDescricaoClick(Sender: TObject);
begin
  EditPesquisa.KeyboardType := TVirtualKeyboardType.Default;
  EditPesquisa.TextPrompt   := 'Digite a descrição do produto';
  EditPesquisa.Text         := '';
  EditPesquisa.SetFocus;
end;

procedure TF_NovoPedido.ImageVoltarClick(Sender: TObject);
var widpedido: string;
begin
//  if (TabControl1.TabIndex=0) then
//     exit;
//showmessage('voltar');
  if (TabControl1.TabIndex=0) or (LabelValor.TagString='Finalizado') then
     begin
       widpedido := LabelNumero.TagString;
       F_MeusPedidos.CarregaMeusPedidos(F_MeusPedidos.DateEditPeriodo.Date);
       F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.Locate('id',widpedido,[]);
       if (F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('total').IsNull) or
          (F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('total').AsFloat=0) then
          begin
            DeletaPedido;
{            F_MeusPedidos.Fprovider.ExcluiPedido(strtoint(LabelNumero.TagString));
            if Assigned(F_MeusPedidos) then
              begin
                F_MeusPedidos.CarregaMeusPedidos(F_MeusPedidos.DateEditPeriodo.Date);
                F_MeusPedidos.Show;
              end;}
          end
       else if not F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('finalizado').AsBoolean then
             MessageDlg('Atenção! Pedido não finalizado. Deseja retornar?', System.UITypes.TMsgDlgType.mtInformation,
                                 [System.UITypes.TMsgDlgBtn.mbYes,
                                  System.UITypes.TMsgDlgBtn.mbNo], 0,
                                  procedure(const AResult: System.UITypes.TModalResult)
                                  begin
                                    case AResult of
                                      mrYES: begin
                                               if Assigned(F_MeusPedidos) then
                                                  begin
                                                    F_MeusPedidos.CarregaMeusPedidos(F_MeusPedidos.DateEditPeriodo.Date);
                                                    F_MeusPedidos.Show;
                                                  end;
                                             end;
                                      mrNo:;
                                    end;
                                  end)
       else
          begin
            if Assigned(F_MeusPedidos) then
               begin
                 F_MeusPedidos.CarregaMeusPedidos(F_MeusPedidos.DateEditPeriodo.Date);
                 F_MeusPedidos.Show;
               end;
          end;

     end
  else
     begin
       ImageFinalizaPedido.Visible := false;
       ImageCesta.Visible          := true;
       TabControl1.ActiveTab := TabItemIncluiItem;
       LabelTitulo.Text      := 'Inclui Ítem';
       //ImageFinaliza.Visible := false;
       ImageExclui.Visible     := true;
     end;
end;

procedure TF_NovoPedido.ListViewClienteItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
     exit;
  if TListView(Sender).Selected <> nil then
     begin
       if ItemObject.Name = 'ImageDetalhe' then
          begin
            if F_MeusPedidos.Fprovider.FDMemTableClientes.Locate('id',ItemObject.TagString,[]) then
               begin
                 FPesquisaCliente       := false;
                 EditCliente.Text       := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('nome').AsString;
                 EditCliente.TagString  := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('id').AsString;
                 FPesquisaCliente       := true;
                 AlteraPedido('cliente',F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('id').AsString,LabelNumero.TagString);
               end;
            TabControl1.ActiveTab  := TabItemFinalizaPedido;
          end;
     end;
end;

procedure TF_NovoPedido.AlteraPedido(XTipo,XId,XIdPedido: string);
var wpedido: TJSONObject;
    widpedido: integer;
begin
  try
    widpedido := strtoint(XIdPedido);
    wpedido   := TJSONObject.Create;
    if XTipo='cliente' then
       wpedido.AddPair('idcliente',XId)
    else if XTipo='condicao' then
       begin
         if F_MeusPedidos.Fprovider.FDMemTableItens.RecordCount>0 then
            begin
              AtualizaUnitarioItem(XIdPedido);
//              ReabrePedido(Xidorcamento);
              CarregaListaItens;
            end;
         wpedido.AddPair('idcondicao',XId);
       end;
    wpedido.AddPair('finalizado','false');
    prvComuns.AlteraPedido(widpedido,wpedido);

//  TLoading.Show(F_NovoPedido,'Aguarde...Atualizando pedido');

//  TThread.CreateAnonymousThread(procedure
//                                begin
//                                  if prvComuns.AlteraPedido(widpedido,wpedido) then
//                                     begin
//                                       TThread.Synchronize(nil, procedure
//                                                           begin
//                                                             TLoading.Hide;
//                                                           end);
//                                     end
//                                   else
//                                     begin
//                                       TThread.Synchronize(nil, procedure
//                                                           begin
////                                                             TLoading.Hide;
//                                                             showmessage('Pedido não alterado');
//                                                           end);
//                                     end;
//                                end).Start;
  except
    On E: Exception do
    begin
      if XTipo='cliente' then
         showmessage('Problema ao alterar cliente '+slinebreak+E.Message)
      else if XTipo='condicao' then
         showmessage('Problema ao alterar condição '+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_NovoPedido.AtualizaUnitarioItem(XIdPedido: string);
var widpedido,widitem,widproduto: integer;
    wpreco,wqtde,wtotal: double;
begin
  widpedido := StrToInt(XIdPedido);
  F_MeusPedidos.Fprovider.FDMemTableItens.First;
  while not F_MeusPedidos.Fprovider.FDMemTableItens.Eof do
  begin
    widitem    := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('id').AsInteger;
    widproduto := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('idproduto').AsInteger;
    wqtde      := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('quantidade').AsFloat;
    if F_MeusPedidos.Fprovider.PesquisaProduto(widproduto) then
         case F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('preco').AsInteger of
           1: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsFloat;
           2: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco2').AsFloat;
           3: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco3').AsFloat;
           4: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco4').AsFloat;
           5: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco5').AsFloat;
           6: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco6').AsFloat;
           7: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco7').AsFloat;
           8: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco8').AsFloat;
           9: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco9').AsFloat;
           10: wpreco := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco10').AsFloat;
         end;
    wtotal := wqtde * wpreco;
    AlteraUnitarioItem(widpedido,widitem,wpreco,wtotal);
    F_MeusPedidos.Fprovider.FDMemTableItens.Next;
  end;
  F_MeusPedidos.Fprovider.FDMemTableItens.First;
end;

procedure TF_NovoPedido.ListViewCondicaoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
     exit;
  if TListView(Sender).Selected <> nil then
     begin
       if ItemObject.Name = 'ImageDetalhe' then
          begin
            if F_MeusPedidos.Fprovider.FDMemTableCondicoes.Locate('id',ItemObject.TagString,[]) then
               begin
                 FPesquisaCondicao       := false;
                 EditCondicao.Text       := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('descricao').AsString;
                 EditCondicao.TagString  := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString;
                 FPesquisaCondicao       := true;
                 AlteraPedido('condicao',F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString,LabelNumero.TagString);
               end;
            TabControl1.ActiveTab  := TabItemFinalizaPedido;
          end;
     end;
end;

procedure TF_NovoPedido.ListViewItensItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var wqtde,wunitario,wtotal: double;
    wid,widorcamento,widproduto: integer;
    s: widestring;
    wbmp: TBitmap;
    decoder : TIdDecoderMIME;
    stream  : TMemoryStream;
    wpreco: string;
begin
  if ItemObject = nil then
     begin
//       showmessage('fora');
       exit;
     end;
  if TListView(Sender).Selected <> nil then
     begin
       if ItemObject.Name = 'ImageFundo' then
          begin
            widproduto := strtointdef(TListItemImage(ListViewItens.Items.AppearanceItem[ItemIndex].Objects.FindDrawable('ImageDetalhe')).TagString,0);
            if F_MeusPedidos.Fprovider.PesquisaProduto(widproduto) then
               begin
                 case F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xprecocondicao').AsInteger of
                   1: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsString));
                   2: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco2').AsString));
                   3: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco3').AsString));
                   4: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco4').AsString));
                   5: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco5').AsString));
                   6: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco6').AsString));
                   7: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco7').AsString));
                   8: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco8').AsString));
                   9: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco9').AsString));
                   10: wpreco := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco10').AsString));
                 end;
                 LabelDescricaoProduto.Text   := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('descricao').AsString;
                 LabelCodigoProduto.Text      := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('codigo').AsString;
                 LabelCEANProduto.Text        := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('cean').AsString;
                 LabelFabricanteProduto.Text  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('fabricante').AsString;
                 LabelMarcaProduto.Text       := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('marca').AsString;
                 LabelUnitarioProduto.Text    := wpreco;
//                 LabelUnitarioProduto.Text    := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsString));
                 LabelUnidadeProduto.Text     := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('unidade').AsString;
                 if F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsString<>'' then
                   try
                     s       := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsWideString;
                     decoder := TIdDecoderMIME.Create(nil);
                     stream  := TMemoryStream.Create;
                     decoder.DecodeStream(s, stream);
                     stream.Position := 0;
                     wbmp   := TBitmap.Create;
                     wbmp.LoadFromStream(stream);
                     image6.Bitmap  := wbmp;
                   finally
                     stream.Free;
                     decoder.Free;
                   end;
                 LayoutProdutoDetalhe.Visible := true;
               end;
          end
       else if ItemObject.Name = 'ImageSoma' then
          begin
            if length(trim(ImageExclui.TagString))=0 then // caso pedido já importado não soma
               begin
                 wid          := strtoint(ItemObject.TagString);
                 widorcamento := strtoint(TListItemImage( ListViewItens.Items.AppearanceItem[ItemIndex].Objects.FindDrawable('ImageFundo')).TagString);
                 wqtde := strtofloat(TListItemText( ListViewItens.Items.AppearanceItem[ItemIndex].Objects.FindDrawable('TextQuantidade')).Text);
                 wqtde := wqtde + 1;
                 wunitario := strtofloat(TListItemText( ListViewItens.Items.AppearanceItem[ItemIndex].Objects.FindDrawable('TextSubTotal')).TagString);
                 wtotal := wqtde * wunitario;
                 AlteraQuantidade(widorcamento,wid,wqtde,wtotal);
               end;
          end
       else if ItemObject.Name = 'ImageSubtrai' then
          begin
            if length(trim(ImageExclui.TagString))=0 then // caso pedido já importado não subtrai
               begin
                 wid          := strtoint(ItemObject.TagString);
                 widorcamento := strtoint(TListItemImage( ListViewItens.Items.AppearanceItem[ItemIndex].Objects.FindDrawable('ImageFundo')).TagString);
                 wqtde := strtofloat(TListItemText( ListViewItens.Items.AppearanceItem[ItemIndex].Objects.FindDrawable('TextQuantidade')).Text);
                 wunitario := strtofloat(TListItemText( ListViewItens.Items.AppearanceItem[ItemIndex].Objects.FindDrawable('TextSubTotal')).TagString);
                 if wqtde>1 then
                    begin
                      wqtde  := wqtde - 1;
                      wtotal := wqtde * wunitario;
                      AlteraQuantidade(widorcamento,wid,wqtde,wtotal);
                    end
                 else
                    MessageDlg('Deseja excluir ítem?', System.UITypes.TMsgDlgType.mtInformation,
                                [System.UITypes.TMsgDlgBtn.mbYes,
                                System.UITypes.TMsgDlgBtn.mbNo], 0,
                                procedure(const AResult: System.UITypes.TModalResult)
                                begin
                                  case AResult of
                                    mrYES: begin
                                             ExcluiQuantidade(widorcamento,wid);
                                           end;
                                    mrNo:;
                                  end;
                                end);
               end;
          end;
     end;
end;

procedure TF_NovoPedido.AlteraQuantidade(Xidorcamento,Xid: integer; Xqtde,Xtotal: double);
begin
  TLoading.Show(F_NovoPedido,'Aguarde...Atualizando pedido');

  TThread.CreateAnonymousThread(procedure
                                begin
                                  if AlteraItem(Xidorcamento,Xid,Xqtde,Xtotal) then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             ReabrePedido(Xidorcamento);
                                                             CarregaListaItens;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Problema ao alterar ítem');
                                                           end);
                                     end;
                                end).Start;

end;

procedure TF_NovoPedido.ExcluiQuantidade(xidorcamento,xid: integer);
begin
  TLoading.Show(F_NovoPedido,'Aguarde...Atualizando pedido');

  TThread.CreateAnonymousThread(procedure
                                begin
                                  if prvComuns.ExcluiItem(Xidorcamento,Xid) then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             ImageNumeroItens.Visible := F_MeusPedidos.Fprovider.FDMemTableItens.RecordCount>1;
                                                             LabelNumeroItens.Text    := inttostr(F_MeusPedidos.Fprovider.FDMemTableItens.RecordCount-1);
                                                             ReabrePedido(xidorcamento);
                                                             CarregaListaItens;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Problema ao excluir ítem');
                                                           end);
                                     end;
                                end).Start;
end;

function TF_NovoPedido.AlteraItem(XIdOrcamento,XIdItem: integer; XQtde,XTotal: double): boolean;
var witem: TJSONObject;
    wret: boolean;
begin
  try
    witem := TJSONObject.Create;
    witem.AddPair('quantidade',formatfloat('#,0.00',XQtde));
    witem.AddPair('valortotal',formatfloat('#,0.00',XTotal));
    wret := F_MeusPedidos.Fprovider.AlteraPedidoItem(XIdOrcamento,XIdItem,witem);
  Except
    On E: Exception do
    begin
      wret := false;
      showmessage('Problema ao alterar ítem '+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;


function TF_NovoPedido.AlteraUnitarioItem(XIdOrcamento,XIdItem: integer; XUnitario,XTotal: double): boolean;
var witem: TJSONObject;
    wret: boolean;
begin
  try
    witem := TJSONObject.Create;
    witem.AddPair('valorunitario',formatfloat('#,0.00',XUnitario));
    witem.AddPair('valortotal',formatfloat('#,0.00',XTotal));
    wret := F_MeusPedidos.Fprovider.AlteraPedidoItem(XIdOrcamento,XIdItem,witem);
  Except
    On E: Exception do
    begin
      wret := false;
      showmessage('Problema ao alterar ítem '+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;


procedure TF_NovoPedido.ListViewPesquisaItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var widpedido,widproduto: integer;
    wpreco: string;
begin
//  showmessage(F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xprecocondicao').AsString);

  if ItemObject = nil then
     exit;
  if TListView(Sender).Selected <> nil then
     begin
       if ItemObject.Name = 'ImageFundo' then
          begin
            widproduto := strtointdef(TListItemImage(ListViewPesquisa.Items.AppearanceItem[ItemIndex].Objects.FindDrawable('ImageDetalhe')).TagString,0);
            if F_MeusPedidos.Fprovider.PesquisaProduto(widproduto) then
               begin
                 case F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xprecocondicao').AsInteger of
                   1: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsString));
                   2: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco2').AsString));
                   3: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco3').AsString));
                   4: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco4').AsString));
                   5: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco5').AsString));
                   6: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco6').AsString));
                   7: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco7').AsString));
                   8: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco8').AsString));
                   9: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco9').AsString));
                   10: wpreco := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco10').AsString));
                 end;
                 LabelDescricaoProduto.Text   := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('descricao').AsString;
                 LabelCodigoProduto.Text      := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('codigo').AsString;
                 LabelCEANProduto.Text        := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('cean').AsString;
                 LabelFabricanteProduto.Text  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('fabricante').AsString;
                 LabelMarcaProduto.Text       := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('marca').AsString;
                 LabelUnitarioProduto.Text    := wpreco;
//                 LabelUnitarioProduto.Text    := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsString));
                 LabelUnidadeProduto.Text     := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('unidade').AsString;
                 LayoutProdutoDetalhe.Visible := true;
               end;
          end;
       if ItemObject.Name = 'ImageDetalhe' then
          begin
            widpedido  := strtoint(LabelNumero.TagString);
            widproduto := strtoint(ItemObject.TagString);
            FTamanho   := '';
            FCor       := '';
{            if F_MeusPedidos.Fprovider.FDMemTableProdutos.Active then
               begin
                 F_MeusPedidos.Fprovider.FDMemTableProdutos.Locate('id',ItemObject.TagString,[]);
                 if F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('grade').AsInteger>0 then
                    begin
                      LabelTituloGradeNumeracao.TagString := ItemObject.TagString;
                      CarregaGradeProduto(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('id').AsInteger);
                      EditQtde.Text       := '1';
                      LabelProduto.Text   := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('descricao').AsString;
                      LayoutGrade.Visible := true;
                    end
                 else
                    IncluiNovoItem(widpedido,widproduto);
               end
            else}
               begin
                 if F_MeusPedidos.Fprovider.PesquisaProduto(widproduto) then
                    begin
                      case F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xprecocondicao').AsInteger of
                         1: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsString;
                         2: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco2').AsString;
                         3: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco3').AsString;
                         4: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco4').AsString;
                         5: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco5').AsString;
                         6: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco6').AsString;
                         7: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco7').AsString;
                         8: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco8').AsString;
                         9: wpreco  := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco9').AsString;
                         10: wpreco := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco10').AsString;
                      end;
                      if F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('grade').AsInteger>0 then
                         begin
                           LabelTituloGradeNumeracao.TagString := ItemObject.TagString;
                           CarregaGradeProduto(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('id').AsInteger,0,'');
                           EditQtde.Text       := '1';
                           LabelQuantidade.TagString := wpreco;
                           LabelProduto.Text   := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('codigo').AsString+' - '+
                                                  F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('descricao').AsString;
                           LabelPreco.Text     := formatfloat('R$ #,0.00',strtofloat(wpreco));
                           LayoutGrade.Visible := true;
                         end
                      else
                         IncluiNovoItem(widpedido,widproduto,wpreco);
                    end;
               end;
//            Fprovider.FDMemTableMeusPedidos.Locate('id',ItemObject.TagString,[]);
          end;
     end;
end;

procedure TF_NovoPedido.ListViewPesquisaPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
var wproduto,wtipo: string;
    wpagina: integer;
begin
  if EditPesquisa.Text='' then
     exit;
  wpagina := ListViewPesquisa.Tag;
  if (ListViewPesquisa.items.Count>=20) and (ListViewPesquisa.Tag>=0) and (FPagina<>wpagina) then
     begin
//       if ListViewPesquisa.GetItemRect(ListViewPesquisa.Items.Count-3).Bottom <= ListViewPesquisa.Height then
       if ListViewPesquisa.GetItemRect((wpagina*20)-3).Bottom <= ListViewPesquisa.Height then
          begin
            wproduto := EditPesquisa.Text;
            if EditPesquisa.TextPrompt = 'Digite o código do produto' then
               wtipo := 'código'
            else if EditPesquisa.TextPrompt = 'Digite a descrição do produto' then
               wtipo := 'descrição'
            else
               wtipo := 'cean';
            EfetivaPesquisaProduto(wproduto,wtipo,wpagina);
            FPagina := wpagina;
          end;
     end;
end;

procedure TF_NovoPedido.TabControl1Change(Sender: TObject);
begin
  if TabControl1.ActiveTab = TabItemFinalizaPedido then
     begin
       TLoading.Show(F_NovoPedido,'Aguarde...Preparando finalização');

       TThread.CreateAnonymousThread(procedure
                                    begin
                                      TThread.Synchronize(nil, procedure
                                                         begin
                                                           CarregaListaItens;
                                                           TLoading.Hide;
                                                         end);
                                    end).Start;
     end;
end;

procedure TF_NovoPedido.Timer1Timer(Sender: TObject);
var wrecupera: string;
    wobject: TObject;
    wkeyword: word;
    wkeychar: char;
    wshift: TShiftState;
begin
//  showmessage('flag1');
  wrecupera := RecuperaLeitura;
  if wrecupera<>'' then
     begin
//     ShowMessage('recuperou: '+wrecupera);
       Timer1.Enabled := false;
       wobject  := F_NovoPedido.EditPesquisa;
       wkeyword := vkReturn;
       wkeychar := #13;
       wshift   := [];
       EditPesquisa.Text := wrecupera;
       EditPesquisa.OnKeyDown(wobject,wkeyword,wkeychar,wshift);
//       showmessage(wrecupera);
     end;
end;

procedure TF_NovoPedido.CameraComponent1SampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
//  showmessage('flag2');
  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
//    showmessage('flag2.1');
    CameraComponent1.SampleBufferToBitmap(imgCamera.Bitmap, True);
//    showmessage('flag3');
    if (fScanInProgress) then
    begin
      exit;
    end;
//    showmessage('flag4');
    // This code will take every 4 frame.
    inc(fFrameTake);
    if (fFrameTake mod 4 <> 0) then
    begin
      exit;
    end;
//    showmessage('flag5');
    if Assigned(fScanBitmap) then
      FreeAndNil(fScanBitmap);
    fScanBitmap := TBitmap.Create();
    fScanBitmap.Assign(imgCamera.Bitmap);
//    showmessage('flag6');
    ParseImage();
  end);
end;

procedure TF_NovoPedido.CarregaListaItens;
var wid,ix: integer;
    wimgfoto,wimgmore,wimgsoma,wimgsubtrai: TStream;
    wbmp,wbmp2,wbmp3,wbmp4: TBitmap;
    wqtde: integer;
    s: widestring;
    decoder : TIdDecoderMIME;
    stream  : TMemoryStream;
begin
  wid := strtoint(LabelNumero.TagString);
  try
      FPesquisaCliente       := false;
{      EditCliente.Text       := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xcliente').AsString;
      EditCliente.TagString  := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('idcliente').AsString;
      EditCondicao.Text      := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xcondicao').AsString;
      EditCondicao.TagString := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('idcondicao').AsString;}

      wqtde := 0;
      ListViewItens.BeginUpdate;
      ListViewItens.items.Clear;

      wimgfoto          := TMemoryStream.Create;
      ImageFoto.Bitmap.SaveToStream(wimgfoto);
      wimgfoto.Position := 0;


      wimgmore          := TMemoryStream.Create;
      Image2.Bitmap.SaveToStream(wimgmore);
 //     Image15.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;
      wimgsoma          := TMemoryStream.Create;
      ImageSoma.Bitmap.SaveToStream(wimgsoma);
      wimgsoma.Position := 0;
      wimgsubtrai       := TMemoryStream.Create;
      ImageSubtrai.Bitmap.SaveToStream(wimgsubtrai);
      wimgsubtrai.Position := 0;

//      wbmp   := TBitmap.Create;
//      wbmp.LoadFromStream(wimgfoto);


      wbmp2  := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);
      wbmp3  := TBitmap.Create;
      wbmp3.LoadFromStream(wimgsoma);
      wbmp4  := TBitmap.Create;
      wbmp4.LoadFromStream(wimgsubtrai);

      if F_MeusPedidos.Fprovider.FDMemTableItens.Fields.Count=3 then
         F_MeusPedidos.CarregaMeusPedidos(F_MeusPedidos.DateEditPeriodo.Date);

      if F_MeusPedidos.Fprovider.CarregaItensPedido(wid) then
         begin
{           showmessage(inttostr(wid)+' '+
                       inttostr(F_MeusPedidos.Fprovider.FDMemTableItens.RecordCount)+' '+
                       inttostr(F_MeusPedidos.Fprovider.FDMemTableItens.Fields.Count));}
         while not F_MeusPedidos.Fprovider.FDMemTableItens.Eof do
         begin
           inc(wqtde);

           with ListViewItens.Items.Add do
           begin
             if F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('foto').AsString<>'' then
                try
                  s       := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('foto').AsWideString;
                  decoder := TIdDecoderMIME.Create(nil);
                  stream  := TMemoryStream.Create;
                  decoder.DecodeStream(s, stream);
                  stream.Position := 0;
                  wbmp   := TBitmap.Create;
                  wbmp.LoadFromStream(stream);
                finally
                  stream.Free;
                  decoder.Free;
                end
             else
                begin
                  wbmp   := TBitmap.Create;
                  wbmp.LoadFromStream(wimgfoto);
                end;


              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap      := wbmp;
              TListItemImage(Objects.FindDrawable('ImageFundo')).TagString   := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('idorcamento').AsString;

              TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap    := wbmp2;
              TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('idproduto').AsString;
              TListItemImage(Objects.FindDrawable('ImageSoma')).Bitmap       := wbmp3;
              TListItemImage(Objects.FindDrawable('ImageSoma')).TagString    := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('id').AsString;
              TListItemImage(Objects.FindDrawable('ImageSubtrai')).Bitmap    := wbmp4;
              TListItemImage(Objects.FindDrawable('ImageSubtrai')).TagString := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('id').AsString;

              if length(trim(F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('xtamanho').AsString))>0 then
                 TListItemText(Objects.FindDrawable('TextCodigo')).Text      := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('xcodproduto').AsString+'  -  '+
                                                                                F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('xtamanho').AsString+'  /  '+F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('xcor').AsString
              else
                 TListItemText(Objects.FindDrawable('TextCodigo')).Text      := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('xcodproduto').AsString;

              TListItemText(Objects.FindDrawable('TextSubTotal')).Text    := formatfloat('#,0.000',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('quantidade').AsFloat)+' x '+
                                                                             formatfloat('R$ #,0.00',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('valorunitario').AsFloat);
              TListItemText(Objects.FindDrawable('TextSubTotal')).TagString  := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('valorunitario').AsString;
              TListItemText(Objects.FindDrawable('TextDescricao')).Text   := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('xdescproduto').AsString;
//              TListItemText(Objects.FindDrawable('TextQuantidade')).Text  := formatfloat('#,0.000',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('quantidade').AsFloat)+' x '+
//                                                                             formatfloat('#,0.00',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('valorunitario').AsFloat);
              TListItemText(Objects.FindDrawable('TextQuantidade')).Text       := formatfloat('#,0.00',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('quantidade').AsFloat);
              TListItemText(Objects.FindDrawable('TextValor')).Text       := formatfloat('R$ #,0.00',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('valortotal').AsFloat);
           end;
           F_MeusPedidos.Fprovider.FDMemTableItens.Next;
         end;
         end;

  finally
      FPesquisaCliente := true;
      ListViewItens.EndUpdate;
      if wqtde>1 then
         LabelTotalItens.Text := formatfloat('#0 ÍTENS',wqtde)
      else
         LabelTotalItens.Text := formatfloat('#0 ITEM',wqtde);
  end;
end;

procedure TF_NovoPedido.IncluiNovoItem(XIdPedido,XIdProduto: integer; XPreco: string);
var witem: TJSONObject;
    wqtde,wtotal: double;
    widitem: integer;
begin
  try
    TLoading.Show(F_NovoPedido,'Aguarde...Incluindo ítem');

    TThread.CreateAnonymousThread(procedure
                                begin
                                  if F_MeusPedidos.Fprovider.PesquisaProdutoItem(XIdPedido,XIdProduto) then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             wqtde   := F_MeusPedidos.Fprovider.FDMemTableProdutoItem.FieldByName('qtde').AsFloat+1;
                                                             widitem := F_MeusPedidos.Fprovider.FDMemTableProdutoItem.FieldByName('item').AsInteger;
                                                             wtotal  := wqtde * strtofloat(XPreco);

                                                             witem := TJSONObject.Create;
                                                             witem.AddPair('idproduto',inttostr(XIdProduto));
                                                             witem.addpair('valorunitario',XPreco);
//                                                             witem.addpair('valorunitario',F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsString);
//                                                             witem.AddPair('tamanho',FTamanho);
//                                                             witem.AddPair('cor',FCor);
                                                             witem.AddPair('quantidade',floattostr(wqtde));
                                                             witem.addpair('valortotal',floattostr(wtotal));


                                                             if (wqtde>1) and (AlteraItem(XIdPedido,widitem,wqtde,wtotal)) then
                                                               begin
                                                                 ImageCesta.Visible := true;
//                                                                 EditPesquisa.Text := '';
                                                                 AtualizaNumeroItens(XIdPedido);
                                                                 ReabrePedido(XIdPedido);
                                                               end
                                                             else if F_MeusPedidos.Fprovider.NovoItem(XIdPedido,witem) then
                                                               begin
                                                                 ImageCesta.Visible := true;
//                                                                 EditPesquisa.Text := '';
                                                                 AtualizaNumeroItens(XIdPedido);
                                                                 ReabrePedido(XIdPedido);
                                                               end;

                                                             TLoading.Hide;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Problema ao incluir ítem');
                                                           end);
                                     end;
                                end).Start;
  except
    On E: Exception do
    begin
      TThread.Synchronize(nil, procedure
                         begin
                           TLoading.Hide;
                         end);
      showmessage('Problema ao incluir ítem no pedido'+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_NovoPedido.IncluiNovoItemGrade(XIdPedido,XIdProduto,XTamanho,XCor,XQtde: integer; XPreco: string);
var witem: TJSONObject;
    wqtde,wtotal: double;
    widitem: integer;
    waltera: boolean;
begin
  try
    TLoading.Show(F_NovoPedido,'Aguarde...Incluindo ítem de grade');

    TThread.CreateAnonymousThread(procedure
                                begin
                                  if F_MeusPedidos.Fprovider.PesquisaProdutoItemGrade(XIdPedido,XIdProduto,XTamanho,XCor) then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             waltera := F_MeusPedidos.Fprovider.FDMemTableProdutoItem.FieldByName('qtde').AsFloat>0;
                                                             wqtde   := F_MeusPedidos.Fprovider.FDMemTableProdutoItem.FieldByName('qtde').AsFloat+XQtde;
                                                             widitem := F_MeusPedidos.Fprovider.FDMemTableProdutoItem.FieldByName('item').AsInteger;
                                                             wtotal  := wqtde * strtofloat(XPreco);

                                                             witem := TJSONObject.Create;
                                                             witem.AddPair('idproduto',inttostr(XIdProduto));
                                                             witem.addpair('valorunitario',XPreco);
//                                                             witem.addpair('valorunitario',F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsString);
                                                             witem.AddPair('numerocalcado',inttostr(XTamanho));
                                                             witem.AddPair('idcorcalcado',inttostr(XCor));
                                                             witem.AddPair('quantidade',floattostr(wqtde));
                                                             witem.AddPair('valortotal',floattostr(wtotal));

                                                             if (waltera) and (AlteraItem(XIdPedido,widitem,wqtde,wtotal)) then
                                                               begin
                                                                 ImageCesta.Visible := true;
//                                                                 EditPesquisa.Text := '';
                                                                 AtualizaNumeroItens(XIdPedido);
                                                                 ReabrePedido(XIdPedido);
                                                               end
                                                             else if F_MeusPedidos.Fprovider.NovoItem(XIdPedido,witem) then
                                                               begin
                                                                 ImageCesta.Visible := true;
//                                                                 EditPesquisa.Text := '';
                                                                 AtualizaNumeroItens(XIdPedido);
                                                                 ReabrePedido(XIdPedido);
                                                               end;

                                                             TLoading.Hide;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Problema ao incluir ítem');
                                                           end);
                                     end;
                                end).Start;
  except
    On E: Exception do
    begin
      TThread.Synchronize(nil, procedure
                         begin
                           TLoading.Hide;
                         end);
      showmessage('Problema ao incluir ítem no pedido'+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_NovoPedido.ReabrePedido(XIdPedido: integer);
var wpedido: TJSONObject;
begin
  try
    wpedido := TJSONObject.Create;
    wpedido.AddPair('finalizado','false');
    if F_MeusPedidos.Fprovider.AlteraPedido(XIdPedido,wpedido) then
       begin
         if F_MeusPedidos.Fprovider.FDMemTablePedido.FieldByName('total').IsNull then
            LabelValor.Text := 'R$ 0,00'
         else
            LabelValor.Text := formatfloat('R$ #,0.00', F_MeusPedidos.Fprovider.FDMemTablePedido.FieldByName('total').AsFloat);
       end;
  finally

  end;
end;

procedure TF_NovoPedido.AtualizaNumeroItens(XIdPedido: integer);
begin
  try
//    CarregaListaItens;
    if F_MeusPedidos.Fprovider.CarregaItensPedido(XIdPedido) then
       begin
         ImageNumeroItens.Visible := true;
         LabelNumeroItens.Text    := inttostr(F_MeusPedidos.Fprovider.FDMemTableItens.RecordCount);
       end;
  except
  end;
end;

procedure TF_NovoPedido.Button1Click(Sender: TObject);
begin
  PermissionsService.RequestPermissions([fPermissionCamera],
    CameraPermissionRequestResult, ExplainReason);
end;

procedure TF_NovoPedido.Button2Click(Sender: TObject);
var wbmp: TBitmap;
    Input: TStringStream;
    Output: TBytesStream;
    s: WideString;
begin
//  FechaCamera;
  try

    if F_MeusPedidos.Fprovider.PesquisaProdutos('114001','código',-1) then
       input := TStringStream.Create(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsString,TEncoding.ASCII);

//    s := Memo2.Text;
{    Input := TStringStream.Create(s, TEncoding.ANSI);
    Input.Position := 0;
    Output := TBytesStream.Create;
    Soap.EncdDecd.DecodeStream(Input, Output);
    Output.Position := 0;
    wbmp := TBitmap.Create;
    wbmp.LoadFromStream(Output);
    Image12.Bitmap := wbmp;}
  finally

  end;
end;

procedure TF_NovoPedido.CreateJpg(Data: string);
var
  JpegStream: TMemoryStream;
  Jpeg, Bitmap: TBitmap;
  tmpPos, tmpLen: integer;
  pp: string;
begin
  try
{    tmpPos := Pos('B]>', Data);
    pp := Copy(Data, 5, tmpPos - 5);
    tmpLen := StrToInt(pp);
    Data := Copy(Data, tmpPos + 3, tmpLen);}

    Bitmap := TBitmap.Create;
    try
      Jpeg := TBitmap.Create;
      try
        JpegStream := TMemoryStream.Create;
        try
          TIdDecoderMIME.DecodeStream(Data, JpegStream);
          JpegStream.Position := 0;
          Jpeg.LoadFromStream(JpegStream);
        finally
          JpegStream.Free;
        end;

        with Bitmap do
        begin
          SetSize(Jpeg.Width, Jpeg.Height);

          if Canvas.BeginScene then
          try
            Canvas.DrawBitmap(Jpeg,
                {$IF RTLVersion >= 31} // 10.1 Berlin or higher
                Jpeg.BoundsF,
                {$ELSE}
                TRectF.Create(0, 0, Jpeg.Width, Jpeg.Height),
                {$IFEND}
                TRectF.Create(0, 0, 200, 160), 1.0);
          finally
            Canvas.EndScene;
          end;
        end;
      finally
        Jpeg.Free;
      end;

      Image12.Bitmap.Assign(Bitmap);
    finally
      Bitmap.Free;
    end;
  except
    on E: Exception do
      //
  end;
end;


procedure TF_NovoPedido.Button3Click(Sender: TObject);
var stream: TMemoryStream;
    decoder: TIdDecoderMIME;
    s,s1: string;
    bmp: TBitmap;
    ss: TStringStream;
    fs: TFileStream;
    wfile: TStringList;
begin
  wfile  := TStringList.Create;
  if F_MeusPedidos.Fprovider.PesquisaProdutos('5622','código',-1) then
     begin
       wfile.Add(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsWideString);
       Memo2.Lines.Text := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsWideString;
//       wfile.SaveToFile(GetCurrentDir+'\arquivo.txt');
     end;
  stream := TMemoryStream.Create;
//  ss := TStringStream.Create;
//  Image12.Bitmap.SaveToStream(ss);
  fs := TFileStream.Create ('D:\VirtualBox\5622.jpg', fmOpenRead);
  s := TIdEncoderMIME.EncodeStream(fs);


//  s := Memo2.Lines.Text;

//  Memo2.Lines.Text := ss.DataString;
//  Memo2.Lines.Text := s;
  s1 := Memo2.Lines.Text;
  TIdDecoderMIME.DecodeStream(s1, stream);
  stream.Position := 0;
  Image14.Bitmap.LoadFromStream(stream);

//  wbase64 := TIdEncoderMIME.Create(nil);
//  SetLength (s, MaxLen );
//  fs := TFileStream.Create ('D:\VirtualBox\5622.jpg', fmOpenRead);
//     Try
//      SetLength(s, fs.Size);
//      fs.ReadBuffer(Pointer(s)^, Length(s)); // or fs.Read(str[1], fs.Size);
//     Finally
//      fs.Free;
//     End;
//  Memo2.Lines.Text := s;
//  fs := TFileStream.Create('D:\VirtualBox\5622.jpg',fmOpenRead);
//  Image14.Bitmap.LoadFromStream(fs);
  stream.Free;
  fs.Free;

//    wvalor  := TIdEncoderMIME.EncodeStream(wstream);

//  Memo2.Lines.LoadFromStream(ss);

{  s       := ss.DataString;
  decoder := TIdDecoderMIME.Create(nil);
  stream  := TMemoryStream.Create;
  decoder.DecodeStream(s, stream);
  stream.Position := 0;}



//  if F_MeusPedidos.Fprovider.PesquisaProdutos('114001','código') then
{  if F_MeusPedidos.Fprovider.PesquisaProdutos('5622','código') then
     begin
       s       := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsString;
       decoder := TIdDecoderMIME.Create(nil);
       stream  := TMemoryStream.Create;
       decoder.DecodeStream(s, stream);
       stream.Position := 0;
       bmp     := TBitmap.Create;
        bmp.LoadFromStream(stream);
       Image14.Bitmap := bmp;
//       jpeg     := TJPEGImage.Create;
//       jpeg.LoadFromStream(stream);
     end;}
end;

function TF_NovoPedido.RetiraBarra(XBase64: string): string;
var wret: string;
begin
  wret :=  StringReplace(XBase64,'\/','/',[rfReplaceAll]);
  showmessage(wret);
end;

procedure TF_NovoPedido.AcionaPesquisaProduto(XProduto,XPrompt: string);
var wtipo: string;
begin
  try
      if XPrompt = 'Digite o código do produto' then
         wtipo := 'código'
      else if XPrompt = 'Digite a descrição do produto' then
         wtipo := 'descrição'
      else
         wtipo := 'cean';

      ListViewPesquisa.ScrollTo(0);
      ListViewPesquisa.items.Clear;
      ListViewPesquisa.Tag := 0;
      FPagina              := 0;

      EfetivaPesquisaProduto(XProduto,wtipo,ListViewPesquisa.Tag);

{      TLoading.Show(F_NovoPedido,'Aguarde...Carregando lista de produtos');

      TThread.CreateAnonymousThread(procedure
                                    begin
                                      if F_MeusPedidos.Fprovider.PesquisaProdutos(XProduto,wtipo) then
                                         begin
                                           TThread.Synchronize(nil, procedure
                                                               begin
                                                                 while not F_MeusPedidos.Fprovider.FDMemTableProdutos.Eof do
                                                                 begin
                                                                   with ListViewPesquisa.Items.Add do
                                                                   begin
                                                                      if F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsString<>'' then
                                                                         try
                                                                           s       := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsWideString;
                                                                           decoder := TIdDecoderMIME.Create(nil);
                                                                           stream  := TMemoryStream.Create;
                                                                           decoder.DecodeStream(s, stream);
                                                                           stream.Position := 0;
                                                                           wbmp   := TBitmap.Create;
                                                                           wbmp.LoadFromStream(stream);
//                                                                           TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap := wbmp;
                                                                         finally
//                                                                           wbmp.Free;
                                                                           stream.Free;
                                                                           decoder.Free;
                                                                         end
                                                                      else
                                                                         begin
                                                                           wbmp   := TBitmap.Create;
                                                                           wbmp.LoadFromStream(wimgfoto);
//                                                                           TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap := wbmp;
                                                                         end;

//                                                                      TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap      := wbmp;

                                                                      TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap := wbmp;
                                                                      TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap    := wbmp2;
                                                                      TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('id').AsString;

                                                                      TListItemText(Objects.FindDrawable('TextCodigo')).Text      := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('codigo').AsString;
                                                                      TListItemText(Objects.FindDrawable('TextDescricao')).Text   := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('descricao').AsString;
                                                                      TListItemText(Objects.FindDrawable('TextValor')).Text       := formatfloat('R$ #,0.00',F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsFloat);
                                                                   end;
                                                                   F_MeusPedidos.Fprovider.FDMemTableProdutos.Next;
                                                                 end;
                                                                 EditPesquisa.Text          := '';
                                                                 LabelTotalPesquisa.Visible := F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount > 0;
                                                                 LabelTotalPesquisa.Text    := inttostr(F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount)+' - PRODUTOS ENCONTRADOS';
                                                                 LinePesquisa.Visible       := F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount > 0;
                                                                 ListViewPesquisa.EndUpdate;
                                                                 TLoading.Hide;
                                                               end);
                                         end
                                       else
                                         begin
                                           TThread.Synchronize(nil, procedure
                                                               begin
                                                                 TLoading.Hide;
                                                                 LabelTotalPesquisa.Visible := false;
                                                                 LabelTotalPesquisa.Text    := inttostr(F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount)+' - PRODUTOS ENCONTRADOS';
                                                                 LinePesquisa.Visible       := false;
                                                                 showmessage('Nenhum produto encontrado');
                                                               end);
                                         end;
                                    end).Start;}
  finally
  end;
end;

procedure TF_NovoPedido.EfetivaPesquisaProduto(XProduto,XTipo: string; XPagina: integer);
var stream: TMemoryStream;
    decoder: TIdDecoderMIME;
    s: widestring;
    wimgfoto,wimgmore: TMemoryStream;
    wbmp,wbmp2: TBitmap;
    img: TListItemImage;
    wpreco: string;
begin

  wimgfoto          := TMemoryStream.Create;
  ImageFoto.Bitmap.SaveToStream(wimgfoto);
  wimgfoto.Position := 0;


  wimgmore          := TMemoryStream.Create;
  ImageDetalhe.Bitmap.SaveToStream(wimgmore);
  wimgmore.Position := 0;


  wbmp2  := TBitmap.Create;
  wbmp2.LoadFromStream(wimgmore);

  ListViewPesquisa.BeginUpdate;

  TLoading.Show(F_NovoPedido,'Aguarde...Carregando lista de produtos');

  TThread.CreateAnonymousThread(procedure
                                begin
                                  if F_MeusPedidos.Fprovider.PesquisaProdutos(XProduto,XTipo,XPagina) then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             if F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount>=20 then
                                                                ListViewPesquisa.Tag := ListViewPesquisa.Tag + 1
                                                             else
                                                                ListViewPesquisa.Tag := -1;
                                                             while not F_MeusPedidos.Fprovider.FDMemTableProdutos.Eof do
                                                             begin
                                                               case F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xprecocondicao').AsInteger of
                                                                 1: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsString));
                                                                 2: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco2').AsString));
                                                                 3: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco3').AsString));
                                                                 4: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco4').AsString));
                                                                 5: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco5').AsString));
                                                                 6: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco6').AsString));
                                                                 7: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco7').AsString));
                                                                 8: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco8').AsString));
                                                                 9: wpreco  := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco9').AsString));
                                                                 10: wpreco := formatfloat('R$ #,0.00',strtofloat(F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco10').AsString));
                                                               end;
                                                               with ListViewPesquisa.Items.Add do
                                                               begin
                                                                  if F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsString<>'' then
                                                                     try
                                                                       s       := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('foto').AsWideString;
                                                                       decoder := TIdDecoderMIME.Create(nil);
                                                                       stream  := TMemoryStream.Create;
                                                                       decoder.DecodeStream(s, stream);
                                                                       stream.Position := 0;
                                                                       wbmp   := TBitmap.Create;
                                                                       wbmp.LoadFromStream(stream);
                                                                     finally
                                                                       stream.Free;
                                                                       decoder.Free;
                                                                     end
                                                                  else
                                                                     begin
                                                                       wbmp   := TBitmap.Create;
                                                                       wbmp.LoadFromStream(wimgfoto);
                                                                     end;

                                                                  TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap := wbmp;
                                                                  TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap    := wbmp2;
                                                                  TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('id').AsString;

                                                                  TListItemText(Objects.FindDrawable('TextCodigo')).Text      := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('codigo').AsString;
                                                                  TListItemText(Objects.FindDrawable('TextDescricao')).Text   := F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('descricao').AsString;
//                                                                  TListItemText(Objects.FindDrawable('TextValor')).Text       := formatfloat('R$ #,0.00',F_MeusPedidos.Fprovider.FDMemTableProdutos.FieldByName('preco1').AsFloat);
                                                                  TListItemText(Objects.FindDrawable('TextValor')).Text       := wpreco;
                                                               end;
                                                               F_MeusPedidos.Fprovider.FDMemTableProdutos.Next;
                                                             end;
//                                                             EditPesquisa.Text          := '';
                                                             LabelTotalPesquisa.Visible := F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount > 0;
//                                                             LabelTotalPesquisa.Text    := inttostr(F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount)+' - PRODUTOS ENCONTRADOS';
                                                             LabelTotalPesquisa.Text    := inttostr(ListViewPesquisa.Items.Count)+' - PRODUTOS ENCONTRADOS';
                                                             LinePesquisa.Visible       := F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount > 0;
//                                                             ListViewPesquisa.EndUpdate;
                                                             TLoading.Hide;
                                                           end);
                                     end
                                   else
                                     begin
                                       ListViewPesquisa.Tag := -1;
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             LabelTotalPesquisa.Visible := false;
                                                             LabelTotalPesquisa.Text    := inttostr(F_MeusPedidos.Fprovider.FDMemTableProdutos.RecordCount)+' - PRODUTOS ENCONTRADOS';
                                                             LinePesquisa.Visible       := false;
                                                             showmessage('Nenhum produto encontrado');
                                                           end);
                                     end;
                                end).Start;

  FreeAndNil(wbmp);
  ListViewPesquisa.EndUpdate;
  EditPesquisa.Text := '';
end;



procedure TF_NovoPedido.FechaTecladoVirtual;
var KeyboardService: IFMXVirtualKeyboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(KeyboardService)) then
     KeyboardService.HideVirtualKeyboard;
end;

procedure TF_NovoPedido.AbreTecladoVirtual(XEdit: TEdit);
var KeyboardService: IFMXVirtualKeyboardService;

begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(KeyboardService)) then
     KeyboardService.ShowVirtualKeyboard(XEdit);

end;

// Camera
procedure TF_NovoPedido.ParseImage();
begin
  {$IFDEF ANDROID}
  TThread.CreateAnonymousThread(
    procedure
    var
      ReadResult: TReadResult;
      ScanManager: TScanManager;
    begin
      try
        fScanInProgress := True;
        ScanManager := TScanManager.Create(TBarcodeFormat.Auto, nil);
        try
          ReadResult := ScanManager.Scan(fScanBitmap);
        except
          on E: Exception do
          begin
            TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
              end);
            exit;
          end;
        end;
        TThread.Synchronize(TThread.CurrentThread,
          procedure
          begin
            if (ReadResult <> nil) then
            begin
              Memo1.Lines.Insert(0, ReadResult.Text);
            end;
          end);
      finally
        if ReadResult <> nil then
          FreeAndNil(ReadResult);
        ScanManager.Free;
        fScanInProgress := false;
      end;
    end).Start();
  {$ENDIF}
end;

procedure TF_NovoPedido.AbreCamera();
begin
  PermissionsService.RequestPermissions([fPermissionCamera],
    CameraPermissionRequestResult, ExplainReason);
end;
procedure TF_NovoPedido.FechaCamera();
begin
  CameraComponent1.Active := false;
end;
procedure TF_NovoPedido.CameraPermissionRequestResult(Sender: TObject;
  const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 1) and
    (AGrantResults[0] = TPermissionStatus.Granted) then
  begin
    CameraComponent1.Active    := false;
    CameraComponent1.Quality   := FMX.Media.TVideoCaptureQuality.MediumQuality;
    CameraComponent1.Kind      := FMX.Media.TCameraKind.BackCamera;
    CameraComponent1.FocusMode := FMX.Media.TFocusMode.ContinuousAutoFocus;
    CameraComponent1.Active    := True;
    Memo1.Lines.Clear;
  end
  else
    ShowMessage('Requerida permissão para leitura do código de barras');
end;

procedure TF_NovoPedido.ExplainReason(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
begin
  ShowMessage('O app necessita acesso a câmera para scanear o código de barras...');
//    procedure(const AResult: TModalResult)
//    begin
//      APostRationaleProc;
//    end)
end;
{ Make sure the camera is released if you're going away. }
function TF_NovoPedido.AppEvent(AAppEvent: TApplicationEvent;
AContext: TObject): Boolean;
begin
  case AAppEvent of
    TApplicationEvent.WillBecomeInactive, TApplicationEvent.EnteredBackground,
      TApplicationEvent.WillTerminate:
      CameraComponent1.Active := false;
  end;
end;

procedure TF_NovoPedido.IniciaScanner;
var
  AppEventSvc: IFMXApplicationEventService;
begin
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXApplicationEventService, IInterface(AppEventSvc)) then
  begin
    showmessage('appevent');
    AppEventSvc.SetApplicationEventHandler(AppEvent);
  end;
//  lblScanStatus.Text := '';
  fFrameTake := 0;
  fScanBitmap := nil;
{$IFDEF ANDROID}
  fPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
{$ENDIF}
end;


function TF_NovoPedido.BitmapFromBase64x(const base64: string): TBitmap;
var
  Input: TStringStream;
  Output: TBytesStream;
  s: TMemoryStream;
  bb: Tbytes;
  wbitmap: TBitmap;
begin
  s:=TMemoryStream.Create;
  bb:=DecodeBase64(base64);
  if Length(bb)>0 then
  begin
    s.WriteData(bb,Length(bb));
    s.position:=0;
    if s.Size>0 then
       begin
         wbitmap := TBitmap.CreateFromStream(s);
         Result := wbitmap;
       end;
  end;
  s.free;
end;

procedure TF_NovoPedido.CarregaGradeProduto(XIdProduto,XCor: integer; XTamanho: string);
var ix,iy: integer;
begin
  try
    for ix := 1 to 30 do
    begin
      wtamanho[ix]:='';
    end;
    for ix := 1 to 30 do
    begin
      wcor[ix]:='';
    end;
    ix := 0;
    iy := 0;

    RoundRectConfirma.Enabled     := false;
    RoundRectCor1.Fill.Color      := $FFE0E0E0;
    RoundRectCor1.Visible         := false;
    RoundRectCor2.Fill.Color      := $FFE0E0E0;
    RoundRectCor2.Visible         := false;
    RoundRectCor3.Fill.Color      := $FFE0E0E0;
    RoundRectCor3.Visible         := false;
    RoundRectCor4.Fill.Color      := $FFE0E0E0;
    RoundRectCor4.Visible         := false;
    RoundRectCor5.Fill.Color      := $FFE0E0E0;
    RoundRectCor5.Visible         := false;
    RoundRectCor6.Fill.Color      := $FFE0E0E0;
    RoundRectCor6.Visible         := false;
    RoundRectCor7.Fill.Color      := $FFE0E0E0;
    RoundRectCor7.Visible         := false;
    RoundRectCor8.Fill.Color      := $FFE0E0E0;
    RoundRectCor8.Visible         := false;
    RoundRectTamanho1.Fill.Color  := $FFE0E0E0;
    RoundRectTamanho1.Visible     := false;
    RoundRectTamanho2.Fill.Color  := $FFE0E0E0;
    RoundRectTamanho2.Visible     := false;
    RoundRectTamanho3.Fill.Color  := $FFE0E0E0;
    RoundRectTamanho3.Visible     := false;
    RoundRectTamanho4.Fill.Color  := $FFE0E0E0;
    RoundRectTamanho4.Visible     := false;
    RoundRectTamanho5.Fill.Color  := $FFE0E0E0;
    RoundRectTamanho5.Visible     := false;
    RoundRectTamanho6.Fill.Color  := $FFE0E0E0;
    RoundRectTamanho6.Visible     := false;
    RoundRectTamanho7.Fill.Color  := $FFE0E0E0;
    RoundRectTamanho7.Visible     := false;
    RoundRectTamanho8.Fill.Color  := $FFE0E0E0;
    RoundRectTamanho8.Visible     := false;
    RoundRectTamanho9.Fill.Color  := $FFE0E0E0;
    RoundRectTamanho9.Visible     := false;
    RoundRectTamanho10.Fill.Color := $FFE0E0E0;
    RoundRectTamanho10.Visible     := false;

    if F_MeusPedidos.Fprovider.PesquisaProdutoGrade(XIdProduto) then
       begin
         F_MeusPedidos.Fprovider.FDMemTableGrade.First;
         LayoutTamanho1.Visible := true;
         LayoutCor1.Visible     := true;
         LayoutTamanho2.Visible := false;
         LayoutCor2.Visible     := false;
         while not F_MeusPedidos.Fprovider.FDMemTableGrade.Eof do
         begin
           // Tamanho
           if not RetornaTamanho(F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString) then
              begin
                inc(ix);
                wtamanho[ix] := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                case ix of
                  1: begin
                       RoundRectTamanho1.Visible   := true;
                       LabelTamanho1.Text          := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho1.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho1.OnClick(RoundRectTamanho1);
                     end;
                  2: begin
                       RoundRectTamanho2.Visible   := true;
                       LabelTamanho2.Text          := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho2.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho2.OnClick(RoundRectTamanho2);
                     end;
                  3: begin
                       RoundRectTamanho3.Visible   := true;
                       LabelTamanho3.Text          := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho3.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho3.OnClick(RoundRectTamanho3);
                     end;
                  4: begin
                       RoundRectTamanho4.Visible   := true;
                       LabelTamanho4.Text          := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho4.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho4.OnClick(RoundRectTamanho4);
                     end;
                  5: begin
                       RoundRectTamanho5.Visible   := true;
                       LabelTamanho5.Text          := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho5.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho5.OnClick(RoundRectTamanho5);
                     end;
                  6: begin
                       LayoutTamanho2.Visible      := true;
                       RoundRectTamanho6.Visible   := true;
                       LabelTamanho6.Text          := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho6.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho6.OnClick(RoundRectTamanho6);
                     end;
                  7: begin
                       RoundRectTamanho7.Visible := true;
                       LabelTamanho7.Text        := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho7.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho7.OnClick(RoundRectTamanho7);
                     end;
                  8: begin
                       RoundRectTamanho8.Visible := true;
                       LabelTamanho8.Text        := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho8.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho8.OnClick(RoundRectTamanho8);
                     end;
                  9: begin
                       RoundRectTamanho9.Visible   := true;
                       LabelTamanho9.Text          := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho9.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho9.OnClick(RoundRectTamanho9);
                     end;
                 10: begin
                       RoundRectTamanho10.Visible   := true;
                       LabelTamanho10.Text          := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString;
                       RoundRectTamanho10.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('numero').AsString;
                       if XTamanho=F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('tamanho').AsString then
                          RoundRectTamanho10.OnClick(RoundRectTamanho10);
                     end;
                end;
              end;
           // Cor
           if not RetornaCor(F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString) then
              begin
                inc(iy);
                wcor[iy] := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                case iy of
                  1: begin
                       RoundRectCor1.Visible   := true;
                       LabelCor1.Text          := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor1.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor1.Hint      := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('idcor').AsString;
                       if XCor = F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('codcor').AsInteger then
                          RoundRectCor1.OnClick(RoundRectCor1);
                     end;
                  2: begin
                       RoundRectCor2.Visible := true;
                       LabelCor2.Text        := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor2.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor2.Hint      := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('idcor').AsString;
                       if XCor = F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('codcor').AsInteger then
                           RoundRectCor2.OnClick(RoundRectCor2);
                    end;
                  3: begin
                       RoundRectCor3.Visible := true;
                       LabelCor3.Text        := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor3.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor3.Hint      := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('idcor').AsString;
                       if XCor = F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('codcor').AsInteger then
                          RoundRectCor3.OnClick(RoundRectCor3);
                     end;
                  4: begin
                       RoundRectCor4.Visible := true;
                       LabelCor4.Text        := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor4.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor4.Hint      := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('idcor').AsString;
                       if XCor = F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('codcor').AsInteger then
                          RoundRectCor4.OnClick(RoundRectCor4);
                     end;
                  5: begin
                       LayoutCor2.Visible    := true;
                       RoundRectCor5.Visible := true;
                       LabelCor5.Text        := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor5.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor5.Hint      := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('idcor').AsString;
                       if XCor = F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('codcor').AsInteger then
                          RoundRectCor5.OnClick(RoundRectCor5);
                     end;
                  6: begin
                       RoundRectCor6.Visible := true;
                       LabelCor6.Text        := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor6.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor6.Hint      := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('idcor').AsString;
                       if XCor = F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('codcor').AsInteger then
                          RoundRectCor6.OnClick(RoundRectCor6);
                     end;
                  7: begin
                       RoundRectCor7.Visible := true;
                       LabelCor7.Text        := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor7.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor7.Hint      := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('idcor').AsString;
                       if XCor = F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('codcor').AsInteger then
                          RoundRectCor7.OnClick(RoundRectCor7);
                     end;
                  8: begin
                       RoundRectCor8.Visible := true;
                       LabelCor8.Text        := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor8.TagString := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('cor').AsString;
                       RoundRectCor8.Hint      := F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('idcor').AsString;
                       if XCor = F_MeusPedidos.Fprovider.FDMemTableGrade.FieldByName('codcor').AsInteger then
                          RoundRectCor8.OnClick(RoundRectCor8);
                     end;
                end;
              end;
           F_MeusPedidos.Fprovider.FDMemTableGrade.Next;
         end;
       end;

// verifica somente um tamanho
    if ix=1 then
       RoundRectTamanho1.OnClick(RoundRectTamanho1);
// verifica somente uma cor
    if iy=1 then
       RoundRectCor1.OnClick(RoundRectCor1);

  except

  end;
end;


function TF_NovoPedido.RetornaTamanho(XTamanho: string): boolean;
var ix: integer;
    wret: boolean;
begin
  wret := false;
  for ix := 1 to 30 do
  begin
    if wtamanho[ix]=XTamanho then
       wret := true;
  end;
  result := wret;
end;

function TF_NovoPedido.RetornaCor(XCor: string): boolean;
var ix: integer;
    wret: boolean;
begin
  wret := false;
  for ix := 1 to 30 do
  begin
    if wcor[ix]=XCor then
       wret := true;
  end;
  result := wret;
end;

end.

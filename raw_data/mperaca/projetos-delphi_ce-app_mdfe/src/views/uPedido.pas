unit uPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TF_Pedido = class(TForm)
    LayoutTopo: TLayout;
    RectangleTopo: TRectangle;
    ImageVoltar: TImage;
    LabelTitulo: TLabel;
    LabelStatus: TLabel;
    ImageDown: TImage;
    LayoutBottom: TLayout;
    RectangleBottom: TRectangle;
    ImageNovo: TImage;
    LayoutTotais: TLayout;
    LabelQtde: TLabel;
    LabelValor: TLabel;
    LayoutCliente: TLayout;
    TabControlPedido: TTabControl;
    TabItemItens: TTabItem;
    TabItemTotais: TTabItem;
    TabItemParcelas: TTabItem;
    LabelCliente: TLabel;
    LabelCondicao: TLabel;
    LabelCobranca: TLabel;
    ListViewItens: TListView;
    ImageDetalhe: TImage;
    ImageFoto: TImage;
    ImageUP: TImage;
    Line1: TLine;
    LabelNomeCliente: TLabel;
    LabelNomeCondicao: TLabel;
    LabelNomeCobranca: TLabel;
    LayoutTotal1: TLayout;
    LabelTituloIPI: TLabel;
    LabelIPI: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    LabelFrete: TLabel;
    LabelTituloFrete: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    LabelBaseICMSST: TLabel;
    LabelTituloBaseICMSST: TLabel;
    Layout5: TLayout;
    LabelICMSST: TLabel;
    LabelTituloICMSST: TLabel;
    Layout6: TLayout;
    Layout7: TLayout;
    LabelBaseICMS: TLabel;
    LabelTituloBaseICMS: TLabel;
    Layout8: TLayout;
    LabelICMS: TLabel;
    LabelTituloICMS: TLabel;
    Layout9: TLayout;
    Layout10: TLayout;
    LabelSubtotal: TLabel;
    LabelTituloSubtotal: TLabel;
    Layout11: TLayout;
    LabelDesconto: TLabel;
    LabelTituloDesconto: TLabel;
    Layout12: TLayout;
    Layout13: TLayout;
    LabelAcrescimo: TLabel;
    LabelTituloAcrescimo: TLabel;
    Layout14: TLayout;
    LabelTotal: TLabel;
    LabelTituloTotal: TLabel;
    ListViewParcelas: TListView;
    ImageParcelaMore: TImage;
    ImageParcela: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageVoltarClick(Sender: TObject);
    procedure ImageDownClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AjustaTopo;
    { Private declarations }
  public
    procedure CarregaListaItens(XPedido: integer);
    procedure CarregaListaParcelas(XPedido: integer);
    { Public declarations }
  end;

var
  F_Pedido: TF_Pedido;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses uMeusPedidos, pComuns;

procedure TF_Pedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  F_Pedido := nil;
  Action   := TCloseAction.caFree;
end;

procedure TF_Pedido.FormShow(Sender: TObject);
begin
  AjustaTopo;
end;

procedure TF_Pedido.ImageDownClick(Sender: TObject);
begin
  AjustaTopo;
end;

procedure TF_Pedido.ImageVoltarClick(Sender: TObject);
begin
  if Assigned(F_MeusPedidos) then
    F_MeusPedidos.Show;
end;

procedure TF_Pedido.CarregaListaItens(XPedido: integer);
var wimgfoto,wimgmore: TStream;
    wbmp,wbmp2: TBitmap;
    wqtde: integer;
begin
  try
      wqtde := 0;
      ListViewItens.BeginUpdate;
      ListViewItens.items.Clear;

      wimgfoto          := TMemoryStream.Create;
      ImageFoto.Bitmap.SaveToStream(wimgfoto);
      wimgfoto.Position := 0;
      wimgmore          := TMemoryStream.Create;
      ImageDetalhe.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp   := TBitmap.Create;
      wbmp.LoadFromStream(wimgfoto);
      wbmp2  := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      if F_MeusPedidos.Fprovider.CarregaItensPedido(XPedido) then
         while not F_MeusPedidos.Fprovider.FDMemTableItens.Eof do
         begin
           inc(wqtde);
           with ListViewItens.Items.Add do
           begin
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap   := wbmp;
              TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap := wbmp2;

              TListItemText(Objects.FindDrawable('TextCodigo')).Text      := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('xcodproduto').AsString+'  /  '+
                                                                             formatfloat('#,0.000',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('quantidade').AsFloat)+' x '+
                                                                             formatfloat('R$ #,0.00',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('valorunitario').AsFloat);
              TListItemText(Objects.FindDrawable('TextDescricao')).Text   := F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('xdescproduto').AsString;
//              TListItemText(Objects.FindDrawable('TextQuantidade')).Text  := formatfloat('#,0.000',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('quantidade').AsFloat)+' x '+
//                                                                             formatfloat('R$ #,0.00',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('valorunitario').AsFloat);
              TListItemText(Objects.FindDrawable('TextValor')).Text       := formatfloat('R$ #,0.00',F_MeusPedidos.Fprovider.FDMemTableItens.FieldByName('valortotal').AsFloat);
           end;
           F_MeusPedidos.Fprovider.FDMemTableItens.Next;
         end;

  finally
      ListViewItens.EndUpdate;
      if wqtde>1 then
         LabelQtde.Text := formatfloat('#0 Ítens',wqtde)
      else
         LabelQtde.Text := formatfloat('#0 Item',wqtde);
  end;
end;

procedure TF_Pedido.CarregaListaParcelas(XPedido: integer);
var wimgparcela,wimgmore: TStream;
    wbmp,wbmp2: TBitmap;
    wqtde: integer;
begin
  try
      wqtde := 0;
      ListViewParcelas.BeginUpdate;
      ListViewParcelas.items.Clear;

      wimgparcela       := TMemoryStream.Create;
      ImageParcela.Bitmap.SaveToStream(wimgparcela);
      wimgparcela.Position := 0;
      wimgmore          := TMemoryStream.Create;
      ImageDetalhe.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp   := TBitmap.Create;
      wbmp.LoadFromStream(wimgparcela);
      wbmp2  := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      if F_MeusPedidos.Fprovider.CarregaParcelasPedido(XPedido) then
         while not F_MeusPedidos.Fprovider.FDMemTableParcelas.Eof do
         begin
           inc(wqtde);
           with ListViewParcelas.Items.Add do
           begin
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap   := wbmp;
              TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap := wbmp2;

              TListItemText(Objects.FindDrawable('TextNumero')).Text      := F_MeusPedidos.Fprovider.FDMemTableParcelas.FieldByName('numero').AsString+' / '+
                                                                             F_MeusPedidos.Fprovider.FDMemTableParcelas.FieldByName('numeropagamentos').AsString;
              TListItemText(Objects.FindDrawable('TextVencimento')).Text  := copy(F_MeusPedidos.Fprovider.FDMemTableParcelas.FieldByName('vencimento').asString,1,10);
              TListItemText(Objects.FindDrawable('TextValor')).Text       := formatfloat('R$ #,0.00',F_MeusPedidos.Fprovider.FDMemTableParcelas.FieldByName('valorfinal').AsFloat);
           end;
           F_MeusPedidos.Fprovider.FDMemTableParcelas.Next;
         end;

  finally
      ListViewParcelas.EndUpdate;
  end;
end;

procedure TF_Pedido.AjustaTopo;
begin
  if LayoutTopo.Height<200 then
     begin
       LayoutTopo.Height              := 200;
       LabelCliente.Visible           := true;
       LabelCondicao.Visible          := true;
       LabelCobranca.Visible          := true;
       LabelNomeCliente.Visible       := true;
       LabelNomeCondicao.Visible      := true;
       LabelNomeCobranca.Visible      := true;

       LabelTitulo.Margins.Bottom     := 150;
       LabelStatus.Margins.Top        := -90;
       ImageUP.Visible                := true;
       ImageDown.Visible              := false;
       ImageUP.Margins.Bottom         := 160;
       ImageUP.Margins.Top            := -120;
       ImageDown.Margins.Bottom       := 160;
       ImageDown.Margins.Top          := -120;
       ImageVoltar.Margins.Bottom     := 160;
       ImageVoltar.Margins.Top        := -120;
     end
  else
     begin
       LayoutTopo.Height              := 80;
       LabelCliente.Visible           := false;
       LabelCondicao.Visible          := false;
       LabelCobranca.Visible          := false;
       LabelNomeCliente.Visible       := false;
       LabelNomeCondicao.Visible      := false;
       LabelNomeCobranca.Visible      := false;
       LabelTitulo.Margins.Bottom     := 30;
       LabelStatus.Margins.Top        := 30;
       ImageUP.Visible                := false;
       ImageDown.Visible              := true;
       ImageUP.Margins.Bottom         := 40;
       ImageUP.Margins.Top            := -120;
       ImageDown.Margins.Bottom       := 40;
       ImageDown.Margins.Top          := -120;
       ImageVoltar.Margins.Bottom     := 40;
       ImageVoltar.Margins.Top        := -120;
     end;
end;

end.

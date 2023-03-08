unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, System.Math, System.StrUtils,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,System.UIConsts,
  FMX.ListView, pComuns, System.JSON, FMX.Ani;

type
  TF_Principal = class(TForm)
    TabControlPrincipal: TTabControl;
    TabItemMenu: TTabItem;
    TabItemManutencao: TTabItem;
    TabItemArquivo: TTabItem;
    LayoutTopo: TLayout;
    ImageLogo: TImage;
    LayoutCentro: TLayout;
    LayoutManutencao: TLayout;
    RoundRectAcessar: TRoundRect;
    LabelManutencao: TLabel;
    LayoutArquivo: TLayout;
    RoundRect1: TRoundRect;
    LabelArquivos: TLabel;
    RectangleFundo: TRectangle;
    LayoutTopoManutencao: TLayout;
    RectangleTopo: TRectangle;
    ImageMenu: TImage;
    LabelTitulo: TLabel;
    ImageReload: TImage;
    LabelEmpresa: TLabel;
    TabControlManutencao: TTabControl;
    TabItemConsultado: TTabItem;
    TabItemCiencia: TTabItem;
    TabItemConfirmados: TTabItem;
    ListViewConsultados: TListView;
    Image1: TImage;
    Image2: TImage;
    ListViewCiencia: TListView;
    Image3: TImage;
    Image4: TImage;
    StyleBook1: TStyleBook;
    Rectangle1: TRectangle;
    procedure RoundRectAcessarClick(Sender: TObject);
    procedure TabControlManutencaoChange(Sender: TObject);
  private
    procedure CarregaConsultados;
    procedure CarregaDocumentosCiencias;
    procedure CarregaCiencias;
    { Private declarations }
  public
    Fprovider: TprvComuns;
    procedure CarregaDocumentosConsultados;
    { Public declarations }
  end;

var
  F_Principal: TF_Principal;

implementation

{$R *.fmx}

uses Loading;

procedure TF_Principal.RoundRectAcessarClick(Sender: TObject);
begin
  TabControlPrincipal.TabIndex := 1;
  CarregaDocumentosConsultados;
end;

procedure TF_Principal.TabControlManutencaoChange(Sender: TObject);
begin
  case TabControlManutencao.TabIndex of
    0:;
    1: CarregaDocumentosCiencias;
  end;
end;

procedure TF_Principal.CarregaDocumentosCiencias;
begin
  TLoading.Show(F_Principal,'Aguarde...Carregando documentos dados ciência');

  TThread.CreateAnonymousThread(procedure
                                begin
                                  TThread.Synchronize(nil, procedure
                                                           begin
                                                              CarregaCiencias;
                                                              TLoading.Hide;
                                                           end);
                                end).Start;
end;


procedure TF_Principal.CarregaDocumentosConsultados;
begin
  TLoading.Show(F_Principal,'Aguarde...Carregando documentos consultados');

  TThread.CreateAnonymousThread(procedure
                                begin
                                  TThread.Synchronize(nil, procedure
                                                           begin
                                                              CarregaConsultados;
                                                              TLoading.Hide;
                                                           end);
                                end).Start;
end;

procedure TF_Principal.CarregaConsultados;
var ix,wqtdetotal: integer;
    wvalortotal: double;
    wimgfundo,wimgmore,wimgpendente,wimgbloqueado,wimgliberado,wimgimportado: TStream;
    wbmp,wbmp2,wbmppendente,wbmpbloqueado,wbmpliberado,wbmpimportado: TBitmap;
    wvendedor: string;
begin
  try
    try
      wqtdetotal         := 0;
      wvalortotal        := 0;
      Fprovider          := TprvComuns.Create(nil);
      wimgfundo          := TMemoryStream.Create;
      Image3.Bitmap.SaveToStream(wimgfundo);
      wimgfundo.Position := 0;

      wimgmore           := TMemoryStream.Create;
      Image4.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp  := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      wbmp2 := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      ListViewCiencia.BeginUpdate;
      ListViewCiencia.Items.Clear;

      if Fprovider.CarregaDFeDocumentosCiencias then
         begin
           Fprovider.FDMemTableDocumentosCiencias.Last;
           while not Fprovider.FDMemTableDocumentosCiencias.Bof do
           begin
             with ListViewCiencia.Items.Add do
             begin
                TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap       := wbmp;
                TListItemImage(Objects.FindDrawable('ImageFundo')).TagString    := Fprovider.FDMemTableDocumentosCiencias.FieldByName('id').AsString;

                TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap     := wbmp2;
                TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString  := Fprovider.FDMemTableDocumentosCiencias.FieldByName('id').AsString;

                TListItemText(Objects.FindDrawable('TextNSU')).Text             := formatfloat('0000',Fprovider.FDMemTableDocumentosCiencias.FieldByName('nsu').AsInteger);
                TListItemText(Objects.FindDrawable('TextNSU')).TextColor        := StringToAlphaColor('black');
                TListItemText(Objects.FindDrawable('TextEmitente')).Text        := Fprovider.FDMemTableDocumentosCiencias.FieldByName('nomeemitente').AsString;
                TListItemText(Objects.FindDrawable('TextDocumento')).Text       := Fprovider.FDMemTableDocumentosCiencias.FieldByName('protocolo').AsString;
                TListItemText(Objects.FindDrawable('TextChaveNFe')).Text        := Fprovider.FDMemTableDocumentosCiencias.FieldByName('chavenfe').AsString;


                if Fprovider.FDMemTableDocumentosCiencias.FieldByName('valornfe').IsNull then
                   TListItemText(Objects.FindDrawable('TextValor')).Text         := 'R$ 0,00'
                else
                   TListItemText(Objects.FindDrawable('TextValor')).Text         := formatfloat('R$ #,0.00',Fprovider.FDMemTableDocumentosCiencias.FieldByName('valornfe').AsFloat);
             end;
             inc(wqtdetotal);
             if not Fprovider.FDMemTableDocumentosCiencias.FieldByName('valornfe').IsNull then
                wvalortotal := wvalortotal + Fprovider.FDMemTableDocumentosCiencias.FieldByName('valornfe').AsFloat;
             Fprovider.FDMemTableDocumentosCiencias.Prior;
           end;
         end;
    finally
      ListViewCiencia.EndUpdate;
//      if wqtdetotal > 1 then
//         LabelQtde.Text  := formatfloat('#0 Pedidos',wqtdetotal)
//      else
//         LabelQtde.Text  := formatfloat('#0 Pedido',wqtdetotal);
//      LabelValor.Text := FormatFloat('R$ #,0.00',wvalortotal);
      Fprovider.FDMemTableDocumentosCiencias.First;
    end;
  except
    On E: Exception do
    begin
      showmessage(E.Message);
    end;
  end;
end;

procedure TF_Principal.CarregaCiencias;
var ix,wqtdetotal: integer;
    wvalortotal: double;
    wimgfundo,wimgmore,wimgpendente,wimgbloqueado,wimgliberado,wimgimportado: TStream;
    wbmp,wbmp2,wbmppendente,wbmpbloqueado,wbmpliberado,wbmpimportado: TBitmap;
    wvendedor: string;
begin
  try
    try
      wqtdetotal         := 0;
      wvalortotal        := 0;
      Fprovider          := TprvComuns.Create(nil);
      wimgfundo          := TMemoryStream.Create;
      Image1.Bitmap.SaveToStream(wimgfundo);
      wimgfundo.Position := 0;

      wimgmore           := TMemoryStream.Create;
      Image2.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp  := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      wbmp2 := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      ListViewConsultados.BeginUpdate;
      ListViewConsultados.Items.Clear;

      if Fprovider.CarregaDFeDocumentosConsultados then
         begin
           Fprovider.FDMemTableDocumentosConsultados.Last;
           while not Fprovider.FDMemTableDocumentosConsultados.Bof do
           begin
             with ListViewConsultados.Items.Add do
             begin
                TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap       := wbmp;
                TListItemImage(Objects.FindDrawable('ImageFundo')).TagString    := Fprovider.FDMemTableDocumentosConsultados.FieldByName('id').AsString;

                TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap     := wbmp2;
                TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString  := Fprovider.FDMemTableDocumentosConsultados.FieldByName('id').AsString;

                TListItemText(Objects.FindDrawable('TextNSU')).Text             := formatfloat('0000',Fprovider.FDMemTableDocumentosConsultados.FieldByName('nsu').AsInteger);
                TListItemText(Objects.FindDrawable('TextNSU')).TextColor        := StringToAlphaColor('black');
                TListItemText(Objects.FindDrawable('TextEmitente')).Text        := Fprovider.FDMemTableDocumentosConsultados.FieldByName('nomeemitente').AsString;
                TListItemText(Objects.FindDrawable('TextDocumento')).Text       := Fprovider.FDMemTableDocumentosConsultados.FieldByName('protocolo').AsString;
                TListItemText(Objects.FindDrawable('TextChaveNFe')).Text        := Fprovider.FDMemTableDocumentosConsultados.FieldByName('chavenfe').AsString;


                if Fprovider.FDMemTableDocumentosConsultados.FieldByName('valornfe').IsNull then
                   TListItemText(Objects.FindDrawable('TextValor')).Text         := 'R$ 0,00'
                else
                   TListItemText(Objects.FindDrawable('TextValor')).Text         := formatfloat('R$ #,0.00',Fprovider.FDMemTableDocumentosConsultados.FieldByName('valornfe').AsFloat);
             end;
             inc(wqtdetotal);
             if not Fprovider.FDMemTableDocumentosConsultados.FieldByName('valornfe').IsNull then
                wvalortotal := wvalortotal + Fprovider.FDMemTableDocumentosConsultados.FieldByName('valornfe').AsFloat;
             Fprovider.FDMemTableDocumentosConsultados.Prior;
           end;
         end;
    finally
      ListViewConsultados.EndUpdate;
//      if wqtdetotal > 1 then
//         LabelQtde.Text  := formatfloat('#0 Pedidos',wqtdetotal)
//      else
//         LabelQtde.Text  := formatfloat('#0 Pedido',wqtdetotal);
//      LabelValor.Text := FormatFloat('R$ #,0.00',wvalortotal);
      Fprovider.FDMemTableDocumentosConsultados.First;
    end;
  except
    On E: Exception do
    begin
      showmessage(E.Message);
    end;
  end;
end;

end.

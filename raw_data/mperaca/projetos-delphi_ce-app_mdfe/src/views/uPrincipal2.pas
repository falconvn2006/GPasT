unit uPrincipal2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.MaskUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls,
  FMX.TabControl,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, pComuns, FMX.Ani, IdBaseComponent, IdThreadComponent;

type
  TF_Principal2 = class(TForm)
    RectangleFundo: TRectangle;
    LayoutTopo: TLayout;
    StyleBook1: TStyleBook;
    TabControlPrincipal: TTabControl;
    TabItemLogin: TTabItem;
    TabItemVendedores: TTabItem;
    LayoutTopo1: TLayout;
    Rectangle1: TRectangle;
    Image5: TImage;
    Label2: TLabel;
    Rectangle2: TRectangle;
    Rectangle4: TRectangle;
    Layout1: TLayout;
    Arc1: TArc;
    FloatAnimation2: TFloatAnimation;
    TabControlManutencao: TTabControl;
    TabItemConsultado: TTabItem;
    ListViewConsultados: TListView;
    Image4: TImage;
    Image6: TImage;
    TabItemCiencia: TTabItem;
    ListViewCiencia: TListView;
    Image7: TImage;
    Image8: TImage;
    TabItemConfirmados: TTabItem;
    LabelNSU: TLabel;
    LayoutRodape: TLayout;
    RectangleRodape: TRectangle;
    LabelQuantidade: TLabel;
    ImageConsultar: TImage;
    LayoutMenuConsultado: TLayout;
    RectangleFundoMenu: TRectangle;
    aniFundoMenuConsultado: TFloatAnimation;
    RectangleMenuConsultado: TRectangle;
    RectangleExcluiPedido: TRectangle;
    Label5: TLabel;
    aniMenuConsultado: TFloatAnimation;
    Rectangle7: TRectangle;
    Layout8: TLayout;
    Label7: TLabel;
    Label8: TLabel;
    Layout10: TLayout;
    Rectangle5: TRectangle;
    LabelNSUConsultado: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image9: TImage;
    Image10: TImage;
    TabItemArquivados: TTabItem;
    LayoutMenuCiencia: TLayout;
    RectangleFundoMenuCiencia: TRectangle;
    aniFundoMenuCiencia: TFloatAnimation;
    RectangleMenuCiencia: TRectangle;
    Rectangle9: TRectangle;
    Label1: TLabel;
    aniMenuCiencia: TFloatAnimation;
    Rectangle10: TRectangle;
    Layout4: TLayout;
    Label3: TLabel;
    Label4: TLabel;
    Layout5: TLayout;
    Rectangle11: TRectangle;
    LabelNSUCiencia: TLabel;
    HorzScrollBox1: THorzScrollBox;
    ImageConsultado: TImage;
    ImageCiencia: TImage;
    ImageConfirmado: TImage;
    ImageCancelado: TImage;
    ImageArquivado: TImage;
    TabItemCancelados: TTabItem;
    LayoutConsultado: TLayout;
    Label6: TLabel;
    LayoutCiencia: TLayout;
    Label9: TLabel;
    LayoutConfirmado: TLayout;
    Label10: TLabel;
    LayoutCancelado: TLayout;
    Label11: TLabel;
    LayoutArquivado: TLayout;
    Label12: TLabel;
    ListViewArquivados: TListView;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    ListViewCancelados: TListView;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    ListViewConfirmados: TListView;
    Image19: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    ImageArquivar: TImage;
    ImageDarCiencia: TImage;
    TabItemArquivosXML: TTabItem;
    Rectangle3: TRectangle;
    Layout2: TLayout;
    Rectangle6: TRectangle;
    Image23: TImage;
    Label13: TLabel;
    Label14: TLabel;
    ListViewArquivosXML: TListView;
    Layout3: TLayout;
    Rectangle8: TRectangle;
    LabelQuantidadeArquivosXML: TLabel;
    ImageTransfere: TImage;
    Layout6: TLayout;
    LayoutMensagemToast: TLayout;
    RectangleMensagemToast: TRectangle;
    LabelMensagemToast: TLabel;
    RectangleFundoMensagemToast: TRectangle;
    Rectangle12: TRectangle;
    Label15: TLabel;
    Image1: TImage;
    Label16: TLabel;
    Rectangle13: TRectangle;
    Label17: TLabel;
    Image24: TImage;
    Label18: TLabel;
    Rectangle14: TRectangle;
    Label19: TLabel;
    Image25: TImage;
    Label20: TLabel;
    LayoutTopo2: TLayout;
    Rectangle15: TRectangle;
    Label21: TLabel;
    Image26: TImage;
    Label22: TLabel;
    Rectangle16: TRectangle;
    Label23: TLabel;
    Image27: TImage;
    Label24: TLabel;
    Rectangle17: TRectangle;
    Label25: TLabel;
    Image28: TImage;
    Label26: TLabel;
    LayoutTopo3: TLayout;
    Rectangle18: TRectangle;
    Label27: TLabel;
    Image29: TImage;
    Label28: TLabel;
    Rectangle19: TRectangle;
    Label29: TLabel;
    Image30: TImage;
    Label30: TLabel;
    Rectangle20: TRectangle;
    Label31: TLabel;
    Image31: TImage;
    Label32: TLabel;
    Label33: TLabel;
    LayoutBottom2: TLayout;
    ImageBtnConsultaStatus: TImage;
    ImageBtnManutencaoDocumentos: TImage;
    ImageBtnArquivoXML: TImage;
    ImageBtnConfiguracao: TImage;
    RectangleFundoBottom: TRectangle;
    Image32: TImage;
    Image33: TImage;
    TabItemForaPrazo: TTabItem;
    ListViewForaPrazo: TListView;
    Image37: TImage;
    LayoutForaPrazo: TLayout;
    ImageForaPrazo: TImage;
    LabelForaPrazo: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure RoundRect1Click(Sender: TObject);
    procedure TabControlManutencaoChange(Sender: TObject);
    procedure ImageConsultarClick(Sender: TObject);
    procedure ListViewConsultadosItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure FormShow(Sender: TObject);
    procedure aniFundoMenuConsultadoFinish(Sender: TObject);
    procedure Rectangle5Click(Sender: TObject);
    procedure RectangleExcluiPedidoClick(Sender: TObject);
    procedure ListViewCienciaItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure aniFundoMenuCienciaFinish(Sender: TObject);
    procedure Rectangle11Click(Sender: TObject);
    procedure Rectangle9Click(Sender: TObject);
    procedure ImageConsultadoClick(Sender: TObject);
    procedure ImageCienciaClick(Sender: TObject);
    procedure ImageConfirmadoClick(Sender: TObject);
    procedure ImageArquivadoClick(Sender: TObject);
    procedure ImageCanceladoClick(Sender: TObject);
    procedure ImageArquivarClick(Sender: TObject);
    procedure ImageDarCienciaClick(Sender: TObject);
    procedure Image23Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure ImageBtnConsultaStatusClick(Sender: TObject);
    procedure ImageBtnManutencaoDocumentosClick(Sender: TObject);
    procedure ImageBtnArquivoXMLClick(Sender: TObject);
    procedure TabControlPrincipalChange(Sender: TObject);
    procedure ImageBtnConfiguracaoClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ImageTransfereClick(Sender: TObject);
    procedure ImageForaPrazoClick(Sender: TObject);
  private
    // Fprovider: TprvComuns;
    FAbre: boolean;
    Fundo: TRectangle;
    Layout: TLayout;
    Arco: TArc;
    Animacao: TFloatAnimation;
    procedure AcionaPesquisaVendedor(XVendedor: string);
    procedure CarregaConsultados(XFlag: Integer);
    procedure CarregaCiencias;
    procedure ConsultarDocumentos;
    procedure CarregaUltimoNSU;
    function RetornaData(XData: string): tdate;
    procedure MostraMenuConsultado;
    procedure EscondeMenuConsultado;
    procedure DarCiencia(XChave: string);
    procedure MostraMenuCiencia;
    procedure EscondeMenuCiencia;
    procedure Arquivar(XChave: String);
    procedure CarregaArquivados;
    procedure CarregaCancelados;
    procedure CarregaConfirmados;
    procedure TerminaTrigger;
    function RetiraAcento(XTexto: string): string;
    procedure FimThreadDarCiencia(Sender: TObject);
    procedure FimThreadConsultado(Sender: TObject);
    procedure FimThreadCiencia(Sender: TObject);
    procedure FimThreadConfirmado(Sender: TObject);
    procedure FimThreadCancelado(Sender: TObject);
    procedure FimThreadArquivado(Sender: TObject);
    procedure FimThreadConsultar(Sender: TObject);
    procedure FimThreadArquivar(Sender: TObject);
    procedure ArquivarTodos;
    procedure DarCienciaTodos;
    procedure FimThreadArquivosXML(Sender: TObject);
    procedure CarregaArquivosXML;
    procedure FimThreadStatus(Sender: TObject);
    procedure ConsultaStatusWebService;
    procedure AtualizaDashboard;
    procedure TransfereArquivosXML;
    procedure FimThreadTransfereArquivosXML(Sender: TObject);
    procedure CarregaForaPrazo;
    procedure FimThreadForaPrazo(Sender: TObject);

    { Private declarations }
  public
    FErro, FMensagem: string;
    { Public declarations }
  end;

var
  F_Principal2: TF_Principal2;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
// {$R *.LgXhdpiPh.fmx ANDROID}

uses Loading, uConfiguracao, uPrincipal;

procedure TF_Principal2.FormActivate(Sender: TObject);
begin
  FAbre := true;
end;

procedure TF_Principal2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  F_Principal2 := nil;
  Action := TCloseAction.caFree;
end;

procedure TF_Principal2.FormResize(Sender: TObject);
begin
  Rectangle12.Width := (F_Principal2.Width / 3) - 15;
  Rectangle13.Width := (F_Principal2.Width / 3) - 15;
  Rectangle16.Width := (F_Principal2.Width / 3) - 15;

  Rectangle14.Width := (F_Principal2.Width / 3) - 15;
  Rectangle15.Width := (F_Principal2.Width / 3) - 15;
  Rectangle17.Width := (F_Principal2.Width / 3) - 15;

  Rectangle18.Width := (F_Principal2.Width / 3) - 15;
  Rectangle19.Width := (F_Principal2.Width / 3) - 15;
  Rectangle20.Width := (F_Principal2.Width / 3) - 15;
end;

procedure TF_Principal2.FormShow(Sender: TObject);
begin
  LayoutMenuConsultado.Visible := false;
  ImageConsultar.Visible := true;
  ImageArquivar.Visible := false;
  ImageDarCiencia.Visible := true;
  AtualizaDashboard;
end;

procedure TF_Principal2.AtualizaDashboard;
var
  wtotconsultado, wtotciencia, wtotcancelado, wtotarquivado, wtotconfirmado,
    wultnsu, wmaxnsu: Integer;
  wultconsulta, wcnpjinteressado: string;
begin
  try
    if prvComuns.RetornaTotalConsultados then
      wtotconsultado := prvComuns.FDMemTableTotalConsultados.FieldByName
        ('registros').AsInteger
    else
      wtotconsultado := 0;
    if prvComuns.RetornaTotalCiencias then
      wtotciencia := prvComuns.FDMemTableTotalCiencias.FieldByName('registros')
        .AsInteger
    else
      wtotciencia := 0;
    if prvComuns.RetornaTotalCancelados then
      wtotcancelado := prvComuns.FDMemTableTotalCancelados.FieldByName
        ('registros').AsInteger
    else
      wtotcancelado := 0;
    if prvComuns.RetornaTotalArquivados then
      wtotarquivado := prvComuns.FDMemTableTotalArquivados.FieldByName
        ('registros').AsInteger
    else
      wtotarquivado := 0;
    if prvComuns.RetornaTotalConfirmados then
      wtotconfirmado := prvComuns.FDMemTableTotalConfirmados.FieldByName
        ('registros').AsInteger
    else
      wtotconfirmado := 0;
    if prvComuns.CarregaDFeArquivoIni then
      wcnpjinteressado := prvComuns.FDMemTableArquivoIni.FieldByName
        ('cnpjinteressado').AsString
    else
      wcnpjinteressado := '';

    if prvComuns.RetornaDFeUltimoNSU then
    begin
      wultconsulta := prvComuns.FDMemTableUltimoNSU.FieldByName
        ('ultconsulta').AsString;
      wultnsu := prvComuns.FDMemTableUltimoNSU.FieldByName('ultnsu').AsInteger;
      wmaxnsu := prvComuns.FDMemTableUltimoNSU.FieldByName('maxnsu').AsInteger;
    end
    else
    begin
      wultconsulta := '';
      wultnsu := 0;
      wmaxnsu := 0;
    end;
    F_Principal2.Label18.Text := formatfloat('#0', wtotconsultado);
    F_Principal2.Label20.Text := formatfloat('#0', wtotciencia);
    F_Principal2.Label22.Text := formatfloat('#0', wtotconfirmado);
    F_Principal2.Label24.Text := FormatMaskText('99\.999\.999\/9999\-00;0; ',
      wcnpjinteressado);
    F_Principal2.Label26.Text := formatfloat('#0', wtotcancelado);
    F_Principal2.Label28.Text := copy(wultconsulta, 9, 2) + '/' +
      copy(wultconsulta, 6, 2) + '/' + copy(wultconsulta, 1, 4);
    F_Principal2.Label33.Text := copy(wultconsulta, 12, 8);
    F_Principal2.Label32.Text := formatfloat('#0', wultnsu);
    F_Principal2.Label30.Text := formatfloat('#0', wmaxnsu);
  finally
  end;
end;

procedure TF_Principal2.CarregaUltimoNSU;
var
  wdata, whora, wdatahora, wultnsu: string;
  wano, wmes, wdia: word;
  wprovider: TprvComuns;
begin
  try
    // if not Assigned(Fprovider) then
    wprovider := TprvComuns.Create(nil);
    if wprovider.RetornaDFeUltimoNSU then
    begin
      wdatahora := copy(wprovider.FDMemTableUltimoNSU.FieldByName('ultconsulta')
        .AsString, 1, 19);
      wultnsu := wprovider.FDMemTableUltimoNSU.FieldByName('ultnsu').AsString;
      wano := strtoint(copy(wdatahora, 1, 4));
      wmes := strtoint(copy(wdatahora, 6, 2));
      wdia := strtoint(copy(wdatahora, 9, 2));
      whora := copy(wdatahora, 12, 5);

      wdata := formatdatetime('dd/mm/yy', EncodeDate(wano, wmes, wdia));
      // wdatahora     := StringReplace(wdatahora,'T',' ',[rfReplaceAll]);
      // wdatahora     := StringReplace(wdatahora,'-','/',[rfReplaceAll]);
      // wdatahora     := formatfloat('dd/mm/yy hh:nn:ss',wd);
      LabelNSU.Text := 'Última Consulta/NSU - ' + wdata + ' ' + whora + ' - '
        + wultnsu;
      LabelNSU.Tag := wprovider.FDMemTableUltimoNSU.FieldByName('ultnsu')
        .AsInteger;
    end
    else
    begin
      LabelNSU.Text := '';
      LabelNSU.Tag := 0;
    end;
  except
    On E: Exception do
    begin
      showmessage(E.Message);
    end;
  end;
end;

procedure TF_Principal2.CarregaConsultados(XFlag: Integer);
var
  ix, wqtdetotal: Integer;
  wvalortotal: double;
  wimgfundo, wimgmore, wimgxml, wimgcomxml: TStream;
  wbmp, wbmp2, wbmpxml, wbmpcomxml: TBitmap;
  wvendedor: string;
  wprovider: TprvComuns;
begin
  try
    try
      ListViewConsultados.BeginUpdate;
      ListViewConsultados.Items.Clear;
      ListViewConsultados.EndUpdate;

      wqtdetotal := 0;
      wvalortotal := 0;
      wprovider := TprvComuns.Create(nil);

      wimgxml := TMemoryStream.Create;
      Image2.Bitmap.SaveToStream(wimgxml);
      wimgxml.Position := 0;

      wimgcomxml := TMemoryStream.Create;
      Image10.Bitmap.SaveToStream(wimgcomxml);
      wimgcomxml.Position := 0;

      wimgfundo := TMemoryStream.Create;
      Image4.Bitmap.SaveToStream(wimgfundo);
      wimgfundo.Position := 0;

      wimgmore := TMemoryStream.Create;
      Image6.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      wbmp2 := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      wbmpxml := TBitmap.Create;
      wbmpxml.LoadFromStream(wimgxml);

      wbmpcomxml := TBitmap.Create;
      wbmpcomxml.LoadFromStream(wimgcomxml);

      // ListViewConsultados.Items.Clear;
      ListViewConsultados.BeginUpdate;
      if wprovider.CarregaDFeDocumentosConsultados then
      begin
        wprovider.FDMemTableDocumentosConsultados.Last;

        // if XFlag=1 then
        while not wprovider.FDMemTableDocumentosConsultados.Bof do
        begin
          with ListViewConsultados.Items.Add do
          begin
            if wprovider.FDMemTableDocumentosConsultados.FieldByName
              ('arquivosalvo').AsBoolean then
            begin
              TListItemImage(Objects.FindDrawable('ImageXML')).Bitmap
                := wbmpxml;
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap :=
                wbmpcomxml;
            end
            else
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap := wbmp;
            TListItemImage(Objects.FindDrawable('ImageFundo')).TagString :=
              wprovider.FDMemTableDocumentosConsultados.FieldByName
              ('nsu').AsString;

            TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap
              := wbmp2;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=
              wprovider.FDMemTableDocumentosConsultados.FieldByName
              ('chavenfe').AsString;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagFloat :=
              wprovider.FDMemTableDocumentosConsultados.FieldByName('nsu')
              .AsInteger;

            TListItemText(Objects.FindDrawable('TextNSU')).Text :=
              formatfloat('0000',
              wprovider.FDMemTableDocumentosConsultados.FieldByName('nsu')
              .AsInteger);
            // TListItemText(Objects.FindDrawable('TextNSU')).TextColor        := StringToAlphaColor('black');
            TListItemText(Objects.FindDrawable('TextEmitente')).Text :=
              wprovider.FDMemTableDocumentosConsultados.FieldByName
              ('nomeemitente').AsString;
            TListItemText(Objects.FindDrawable('TextCNPJ')).Text :=
              wprovider.FDMemTableDocumentosConsultados.FieldByName
              ('cnpjemitente').AsString + ' (' +
              wprovider.FDMemTableDocumentosConsultados.FieldByName('ator')
              .AsString + ')';
            TListItemText(Objects.FindDrawable('TextDocumento')).Text :=
              formatdatetime('dd/mm/yyyy',
              RetornaData(wprovider.FDMemTableDocumentosConsultados.FieldByName
              ('dataemissao').AsString));
            TListItemText(Objects.FindDrawable('TextChaveNFe')).Text :=
              wprovider.FDMemTableDocumentosConsultados.FieldByName
              ('chavenfe').AsString;

            if wprovider.FDMemTableDocumentosConsultados.FieldByName('valornfe')
              .IsNull then
              TListItemText(Objects.FindDrawable('TextValor')).Text := 'R$ 0,00'
            else
              TListItemText(Objects.FindDrawable('TextValor')).Text :=
                formatfloat('R$ #,0.00',
                wprovider.FDMemTableDocumentosConsultados.FieldByName
                ('valornfe').AsFloat);
          end;
          inc(wqtdetotal);
          if not wprovider.FDMemTableDocumentosConsultados.FieldByName
            ('valornfe').IsNull then
            wvalortotal := wvalortotal +
              wprovider.FDMemTableDocumentosConsultados.FieldByName
              ('valornfe').AsFloat;

          wprovider.FDMemTableDocumentosConsultados.Prior;
        end;
      end;
    finally
      ListViewConsultados.EndUpdate;
      if wqtdetotal > 1 then
        LabelQuantidade.Text := formatfloat('#0 Documentos', wqtdetotal)
      else
        LabelQuantidade.Text := formatfloat('#0 Documento', wqtdetotal);
      wprovider.FDMemTableDocumentosConsultados.First;
    end;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao carregar documentos consultados.' +
        RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.aniFundoMenuCienciaFinish(Sender: TObject);
begin
  if aniFundoMenuCiencia.Inverse then
    LayoutMenuCiencia.Visible := false;
end;

procedure TF_Principal2.aniFundoMenuConsultadoFinish(Sender: TObject);
begin
  if aniFundoMenuConsultado.Inverse then
    LayoutMenuConsultado.Visible := false;
end;

procedure TF_Principal2.CarregaCiencias;
var
  ix, wqtdetotal: Integer;
  wvalortotal: double;
  wimgfundo, wimgmore, wimgxml, wimgnoxml: TStream;
  wbmp, wbmp2, wbmpxml, wbmpnoxml: TBitmap;
  wvendedor: string;
  wprovider: TprvComuns;
begin
  try
    try
      ListViewCiencia.BeginUpdate;
      ListViewCiencia.Items.Clear;
      ListViewCiencia.EndUpdate;

      wqtdetotal := 0;
      wvalortotal := 0;
      wprovider := TprvComuns.Create(nil);

      wimgfundo := TMemoryStream.Create;
      Image7.Bitmap.SaveToStream(wimgfundo);
      wimgfundo.Position := 0;

      wimgxml := TMemoryStream.Create;
      Image3.Bitmap.SaveToStream(wimgxml);
      wimgxml.Position := 0;

      wimgnoxml := TMemoryStream.Create;
      Image9.Bitmap.SaveToStream(wimgnoxml);
      wimgnoxml.Position := 0;

      wimgmore := TMemoryStream.Create;
      Image8.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      wbmp2 := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      wbmpxml := TBitmap.Create;
      wbmpxml.LoadFromStream(wimgxml);

      wbmpnoxml := TBitmap.Create;
      wbmpnoxml.LoadFromStream(wimgnoxml);

      ListViewCiencia.BeginUpdate;
      // FErro := 'begin update';

      if wprovider.CarregaDFeDocumentosCiencias then
      begin
        wprovider.FDMemTableDocumentosCiencias.Last;
        // FErro := FErro+slinebreak+inttostr(wprovider.FDMemTableDocumentosCiencias.RecordCount);
        while not wprovider.FDMemTableDocumentosCiencias.Bof do
        begin
          with ListViewCiencia.Items.Add do
          begin
            if wprovider.FDMemTableDocumentosCiencias.FieldByName
              ('arquivosalvo').AsBoolean then
            begin
              TListItemImage(Objects.FindDrawable('ImageXML')).Bitmap
                := wbmpxml;
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap := wbmp;
            end
            else
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap :=
                wbmpnoxml;
            TListItemImage(Objects.FindDrawable('ImageFundo')).TagString :=
              wprovider.FDMemTableDocumentosCiencias.FieldByName('id').AsString;

            TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap
              := wbmp2;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=
              wprovider.FDMemTableDocumentosCiencias.FieldByName
              ('chavenfe').AsString;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagFloat :=
              wprovider.FDMemTableDocumentosCiencias.FieldByName('nsu')
              .AsInteger;

            TListItemText(Objects.FindDrawable('TextNSU')).Text :=
              formatfloat('0000',
              wprovider.FDMemTableDocumentosCiencias.FieldByName('nsu')
              .AsInteger);
            // TListItemText(Objects.FindDrawable('TextNSU')).TextColor        := StringToAlphaColor('black');
            TListItemText(Objects.FindDrawable('TextEmitente')).Text :=
              wprovider.FDMemTableDocumentosCiencias.FieldByName
              ('nomeemitente').AsString;
            TListItemText(Objects.FindDrawable('TextCNPJ')).Text :=
              wprovider.FDMemTableDocumentosCiencias.FieldByName('cnpjemitente')
              .AsString + ' (' + wprovider.FDMemTableDocumentosCiencias.
              FieldByName('ator').AsString + ')';
            TListItemText(Objects.FindDrawable('TextDocumento')).Text :=
              formatdatetime('dd/mm/yyyy',
              RetornaData(wprovider.FDMemTableDocumentosCiencias.FieldByName
              ('dataemissao').AsString));
            TListItemText(Objects.FindDrawable('TextChaveNFe')).Text :=
              wprovider.FDMemTableDocumentosCiencias.FieldByName
              ('chavenfe').AsString;

            if wprovider.FDMemTableDocumentosCiencias.FieldByName('valornfe').IsNull
            then
              TListItemText(Objects.FindDrawable('TextValor')).Text := 'R$ 0,00'
            else
              TListItemText(Objects.FindDrawable('TextValor')).Text :=
                formatfloat('R$ #,0.00',
                wprovider.FDMemTableDocumentosCiencias.FieldByName
                ('valornfe').AsFloat);
          end;
          inc(wqtdetotal);
          if not wprovider.FDMemTableDocumentosCiencias.FieldByName('valornfe').IsNull
          then
            wvalortotal := wvalortotal + wprovider.FDMemTableDocumentosCiencias.
              FieldByName('valornfe').AsFloat;
          wprovider.FDMemTableDocumentosCiencias.Prior;
        end;
      end;
    finally
      ListViewCiencia.EndUpdate;
      if wqtdetotal > 1 then
        LabelQuantidade.Text := formatfloat('#0 Documentos', wqtdetotal)
      else
        LabelQuantidade.Text := formatfloat('#0 Documento', wqtdetotal);
      // LabelValor.Text := FormatFloat('R$ #,0.00',wvalortotal);
      wprovider.FDMemTableDocumentosCiencias.First;
    end;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao carregar documentos dados ciência.' +
        RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.ListViewCienciaItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;
  if TListView(Sender).Selected <> nil then
    try
      if ItemObject.Name = 'ImageDetalhe' then
      begin
        MostraMenuCiencia;
        LabelNSUCiencia.Text := 'NSU ' + FloatToStr(ItemObject.TagFloat);
        LabelNSUCiencia.TagFloat := ItemObject.TagFloat;
        LabelNSUCiencia.TagString := ItemObject.TagString;
      end;
    except
      On E: Exception do
      begin
        showmessage('Erro ao carregar ' + E.Message);
      end;
    end;

end;

procedure TF_Principal2.ListViewConsultadosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;
  if TListView(Sender).Selected <> nil then
    try
      if ItemObject.Name = 'ImageDetalhe' then
      begin
        MostraMenuConsultado;
        LabelNSUConsultado.Text := 'NSU ' + FloatToStr(ItemObject.TagFloat);
        LabelNSUConsultado.TagFloat := ItemObject.TagFloat;
        LabelNSUConsultado.TagString := ItemObject.TagString;
      end;
    except
      On E: Exception do
      begin
        showmessage('Erro ao carregar ' + E.Message);
      end;
    end;

end;

procedure TF_Principal2.MostraMenuConsultado;
begin
  RectangleMenuConsultado.Height := F_Principal2.Height;

  LayoutMenuConsultado.Visible := true;
  aniFundoMenuConsultado.Inverse := false;
  aniFundoMenuConsultado.Start;

  aniMenuConsultado.Inverse := false;
  aniMenuConsultado.StartValue := F_Principal2.Width +
    RectangleMenuConsultado.Width;
  aniMenuConsultado.StopValue := F_Principal2.Width -
    RectangleMenuConsultado.Width;
  aniMenuConsultado.Start;
end;

procedure TF_Principal2.MostraMenuCiencia;
begin
  RectangleMenuCiencia.Height := F_Principal2.Height;

  LayoutMenuCiencia.Visible := true;
  aniFundoMenuCiencia.Inverse := false;
  aniFundoMenuCiencia.Start;

  aniMenuCiencia.Inverse := false;
  aniMenuCiencia.StartValue := F_Principal2.Width + RectangleMenuCiencia.Width;
  aniMenuCiencia.StopValue := F_Principal2.Width - RectangleMenuCiencia.Width;
  aniMenuCiencia.Start;
end;

procedure TF_Principal2.ImageConsultadoClick(Sender: TObject);
begin
  TabControlManutencao.TabIndex := 0;
  ImageConsultado.Opacity := 0.8;
  ImageCiencia.Opacity := 0.2;
  ImageConfirmado.Opacity := 0.2;
  ImageCancelado.Opacity := 0.2;
  ImageArquivado.Opacity := 0.2;
  ImageForaPrazo.Opacity := 0.2;
  ImageConsultado.Margins.Top := 0;
  ImageCiencia.Margins.Top := 6;
  ImageConfirmado.Margins.Top := 6;
  ImageCancelado.Margins.Top := 6;
  ImageArquivado.Margins.Top := 6;
  ImageForaPrazo.Margins.Top := 6;
end;

procedure TF_Principal2.ImageCienciaClick(Sender: TObject);
begin
  TabControlManutencao.TabIndex := 1;
  ImageConsultado.Opacity := 0.2;
  ImageCiencia.Opacity := 1;
  ImageConfirmado.Opacity := 0.2;
  ImageCancelado.Opacity := 0.2;
  ImageArquivado.Opacity := 0.2;
  ImageForaPrazo.Opacity := 0.2;
  ImageConsultado.Margins.Top := 6;
  ImageCiencia.Margins.Top := 0;
  ImageConfirmado.Margins.Top := 6;
  ImageCancelado.Margins.Top := 6;
  ImageArquivado.Margins.Top := 6;
  ImageForaPrazo.Margins.Top := 6;
end;

procedure TF_Principal2.ImageConfirmadoClick(Sender: TObject);
begin
  TabControlManutencao.TabIndex := 2;
  ImageConsultado.Opacity := 0.2;
  ImageCiencia.Opacity := 0.2;
  ImageConfirmado.Opacity := 1;
  ImageCancelado.Opacity := 0.2;
  ImageArquivado.Opacity := 0.2;
  ImageForaPrazo.Opacity := 0.2;
  ImageConsultado.Margins.Top := 6;
  ImageCiencia.Margins.Top := 6;
  ImageConfirmado.Margins.Top := 0;
  ImageCancelado.Margins.Top := 6;
  ImageArquivado.Margins.Top := 6;
  ImageForaPrazo.Margins.Top := 6;
end;

procedure TF_Principal2.ImageCanceladoClick(Sender: TObject);
begin
  TabControlManutencao.TabIndex := 3;
  ImageConsultado.Opacity := 0.2;
  ImageCiencia.Opacity := 0.2;
  ImageConfirmado.Opacity := 0.2;
  ImageCancelado.Opacity := 1;
  ImageArquivado.Opacity := 0.2;
  ImageForaPrazo.Opacity := 0.2;
  ImageConsultado.Margins.Top := 6;
  ImageCiencia.Margins.Top := 6;
  ImageConfirmado.Margins.Top := 6;
  ImageCancelado.Margins.Top := 0;
  ImageArquivado.Margins.Top := 6;
  ImageForaPrazo.Margins.Top := 6;
end;

procedure TF_Principal2.Image23Click(Sender: TObject);
begin
  TabControlPrincipal.TabIndex := 0;
end;

procedure TF_Principal2.Image5Click(Sender: TObject);
begin
  TabControlPrincipal.TabIndex := 0;
end;

procedure TF_Principal2.ImageArquivadoClick(Sender: TObject);
begin
  TabControlManutencao.TabIndex := 4;
  ImageConsultado.Opacity := 0.2;
  ImageCiencia.Opacity := 0.2;
  ImageConfirmado.Opacity := 0.2;
  ImageCancelado.Opacity := 0.2;
  ImageForaPrazo.Opacity := 0.2;
  ImageArquivado.Opacity := 1;
  ImageConsultado.Margins.Top := 6;
  ImageCiencia.Margins.Top := 6;
  ImageConfirmado.Margins.Top := 6;
  ImageCancelado.Margins.Top := 6;
  ImageForaPrazo.Margins.Top := 6;
  ImageArquivado.Margins.Top := 0;
end;

procedure TF_Principal2.ImageArquivarClick(Sender: TObject);
var
  wthread: TThread;
begin
  MessageDlg('Deseja arquivar documentos?',
    System.UITypes.TMsgDlgType.mtInformation, [System.UITypes.TMsgDlgBtn.mbYes,
    System.UITypes.TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
          begin
            TLoading.Show(F_Principal2, 'Aguarde...Arquivando documentos');

            wthread := TThread.CreateAnonymousThread(
              procedure
              begin
                FErro := '';
                ArquivarTodos;
                TThread.Synchronize(wthread,
                  procedure
                  begin
                  end);
              end);
            wthread.Start;
            wthread.OnTerminate := FimThreadArquivar;
          end;
        mrNo:
          ;
      end;
    end);
end;

procedure TF_Principal2.ImageBtnArquivoXMLClick(Sender: TObject);
var
  wthread: TThread;
begin
  try
    TLoading.Show(F_Principal2, 'Aguarde...Carregando arquivos XML');

    wthread := TThread.CreateAnonymousThread(
      procedure
      begin
        FErro := '';
        CarregaArquivosXML;
        TThread.Synchronize(wthread,
          procedure
          begin
          end);
      end);
    wthread.Start;
    wthread.OnTerminate := FimThreadArquivosXML;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao listar arquivos XML.' + slinebreak + E.Message;
    end;
  end;
end;

procedure TF_Principal2.ImageBtnConfiguracaoClick(Sender: TObject);
// var wprovider: TprvComuns;
begin
  try
    if not Assigned(F_Configuracao) then
      F_Configuracao := TF_Configuracao.Create(nil);

    prvComuns.AbreConexaoLocal;
    with prvComuns.FDQueryConfigura do
    begin
      DisableControls;
      Close;
      Open;
      EnableControls;
    end;

    F_Configuracao.LabelTitulo.Text := 'Configuração';
    F_Configuracao.ImageVoltar.Visible := true;
    F_Configuracao.FAbre := false;
    F_Configuracao.EditIP.Text := prvComuns.FDQueryConfigura.FieldByName
      ('ipAPI').AsString;
    F_Configuracao.EditPorta.Text := prvComuns.FDQueryConfigura.FieldByName
      ('portaAPI').AsString;
    F_Configuracao.DateEditDataInicial.Date :=
      prvComuns.FDQueryConfigura.FieldByName('dataInicial').AsDateTime;
    F_Configuracao.Show;
  finally
    prvComuns.FechaConexaoLocal;
  end;
end;

procedure TF_Principal2.ImageBtnConsultaStatusClick(Sender: TObject);
var
  wthread: TThread;
begin
  try
    TLoading.Show(F_Principal2, 'Aguarde...Consultando status webservice');

    wthread := TThread.CreateAnonymousThread(
      procedure
      begin
        FErro := '';
        FMensagem := '';
        ConsultaStatusWebService;
        TThread.Synchronize(wthread,
          procedure
          begin
          end);
      end);
    wthread.Start;
    wthread.OnTerminate := FimThreadStatus;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao consultar status webservice.' + slinebreak + E.Message;
    end;
  end;
end;

procedure TF_Principal2.ImageBtnManutencaoDocumentosClick(Sender: TObject);
var
  wthread: TThread;
begin
  try
    TLoading.Show(F_Principal2, 'Aguarde...Carregando documentos consultados');

    wthread := TThread.CreateAnonymousThread(
      procedure
      begin
        FErro := '';
        CarregaConsultados(1);
        CarregaUltimoNSU;
        TThread.Synchronize(wthread,
          procedure
          begin
          end);
      end);
    wthread.Start;
    wthread.OnTerminate := FimThreadConsultado;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao listar documentos consultados.' + slinebreak +
        E.Message;
    end;
  end;
end;

procedure TF_Principal2.ImageConsultarClick(Sender: TObject);
var
  wthread: TThread;
begin
  MessageDlg('Deseja consultar novos documentos?',
    System.UITypes.TMsgDlgType.mtInformation, [System.UITypes.TMsgDlgBtn.mbYes,
    System.UITypes.TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
          begin
            TLoading.Show(F_Principal2, 'Aguarde...Consultando documentos');

            wthread := TThread.CreateAnonymousThread(
              procedure
              begin
                FErro := '';
                ConsultarDocumentos;
                TThread.Synchronize(wthread,
                  procedure
                  begin
                  end);
              end);
            wthread.Start;
            wthread.OnTerminate := FimThreadConsultar;
          end;
        mrNo:
          ;
      end;
    end);
end;

procedure TF_Principal2.ImageDarCienciaClick(Sender: TObject);
var
  wthread: TThread;
begin
  MessageDlg('Deseja dar ciência nos documentos?',
    System.UITypes.TMsgDlgType.mtInformation, [System.UITypes.TMsgDlgBtn.mbYes,
    System.UITypes.TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
          begin
            TLoading.Show(F_Principal2,
              'Aguarde...Dando ciência nos documentos');

            wthread := TThread.CreateAnonymousThread(
              procedure
              begin
                FErro := '';
                DarCienciaTodos;
                TThread.Synchronize(wthread,
                  procedure
                  begin
                  end);
              end);
            wthread.Start;
            wthread.OnTerminate := FimThreadDarCiencia;
          end;
        mrNo:
          ;
      end;
    end);
end;

procedure TF_Principal2.ImageForaPrazoClick(Sender: TObject);
begin
  TabControlManutencao.TabIndex := 5;
  ImageConsultado.Opacity := 0.2;
  ImageCiencia.Opacity := 0.2;
  ImageConfirmado.Opacity := 0.2;
  ImageCancelado.Opacity := 0.2;
  ImageForaPrazo.Opacity := 1;
  ImageArquivado.Opacity := 0.2;
  ImageConsultado.Margins.Top := 6;
  ImageCiencia.Margins.Top := 6;
  ImageConfirmado.Margins.Top := 6;
  ImageCancelado.Margins.Top := 6;
  ImageForaPrazo.Margins.Top := 0;
  ImageArquivado.Margins.Top := 6;
end;

procedure TF_Principal2.ImageTransfereClick(Sender: TObject);
var
  wthread: TThread;
begin
  MessageDlg('Deseja transferir arquivos XML?',
    System.UITypes.TMsgDlgType.mtInformation, [System.UITypes.TMsgDlgBtn.mbYes,
    System.UITypes.TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
          begin
            TLoading.Show(F_Principal2, 'Aguarde...Transferindo arquivos');

            wthread := TThread.CreateAnonymousThread(
              procedure
              begin
                FErro := '';
                TransfereArquivosXML;
                TThread.Synchronize(wthread,
                  procedure
                  begin
                  end);
              end);
            wthread.Start;
            wthread.OnTerminate := FimThreadTransfereArquivosXML;
          end;
        mrNo:
          ;
      end;
    end);
end;

procedure TF_Principal2.TransfereArquivosXML;
var
  wprovider: TprvComuns;
begin
  try
    wprovider := TprvComuns.Create(nil);
    wprovider.TransfereArquivosXML;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao tranferir arquivos XML.' + slinebreak + RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.DarCiencia(XChave: string);
var
  wprovider: TprvComuns;
begin
  try
    wprovider := TprvComuns.Create(nil);
    wprovider.DarCienciaDFe(XChave)
  except
    On E: Exception do
    begin
      FErro := 'Erro ao dar ciência.' + slinebreak + RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.Arquivar(XChave: String);
var
  wprovider: TprvComuns;
begin
  try
    wprovider := TprvComuns.Create(nil);
    if wprovider.CarregaDFeDocumentosCiencias then
    begin
      wprovider.FDMemTableDocumentosCiencias.Locate('chavenfe', XChave, []);
      if wprovider.FDMemTableDocumentosCiencias.FieldByName('arquivosalvo').AsBoolean
      then
        wprovider.ArquivarDFe(XChave)
      else
        FErro := 'Problema ao arquivar documento. Arquivo XML não baixado';
    end;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao arquivar documento.' + slinebreak +
        RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.ArquivarTodos;
var
  wprovider: TprvComuns;
begin
  try
    wprovider := TprvComuns.Create(nil);
    if wprovider.CarregaDFeDocumentosCiencias then
    begin
      wprovider.FDMemTableDocumentosCiencias.First;
      while not wprovider.FDMemTableDocumentosCiencias.Eof do
      begin
        if wprovider.FDMemTableDocumentosCiencias.FieldByName('arquivosalvo').AsBoolean
        then
          // Arquivar(wprovider.FDMemTableDocumentosCiencias.FieldByName('nsu').AsInteger);
          Arquivar(wprovider.FDMemTableDocumentosCiencias.FieldByName
            ('chavenfe').AsString);
        wprovider.FDMemTableDocumentosCiencias.Next;
      end;
    end;
  except
    on E: Exception do
    begin
      FErro := 'Erro ao arquivar documento.' + slinebreak +
        RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.DarCienciaTodos;
var
  wprovider: TprvComuns;
  ix: Integer;
begin
  try
    ix := 0;
    wprovider := TprvComuns.Create(nil);
    if wprovider.CarregaDFeDocumentosConsultados then
    begin
      wprovider.FDMemTableDocumentosConsultados.Last;
      while not wprovider.FDMemTableDocumentosConsultados.Bof do
      begin
        inc(ix);
        wprovider.DarCienciaDFe
          (wprovider.FDMemTableDocumentosConsultados.FieldByName('chavenfe')
          .AsString);
        wprovider.FDMemTableDocumentosConsultados.Prior;
        if ix >= 10 then
          break;
      end;
    end;
  except
    on E: Exception do
    begin
      FErro := 'Erro ao dar ciência nos documentos.' + slinebreak +
        RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.ConsultarDocumentos;
var
  wprovider: TprvComuns;
begin
  try
    wprovider := TprvComuns.Create(nil);
    wprovider.ConsultarDocumentosDFe(inttostr(LabelNSU.Tag));
  except
    On E: Exception do
    begin
      FErro := 'Erro ao consultar documentos.' + RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.RoundRect1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TF_Principal2.ConsultaStatusWebService;
var
  wprovider: TprvComuns;
begin
  try
    wprovider := TprvComuns.Create(nil);
    wprovider.ConsultarStatusWebService;
    FMensagem := wprovider.FDMemTableStatus.FieldByName('description').AsString;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao consultar webservice.' + RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.FimThreadArquivosXML(Sender: TObject);
begin
  TLoading.Hide;
  TabControlPrincipal.TabIndex := 2;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

procedure TF_Principal2.FimThreadStatus(Sender: TObject);
begin
  TLoading.Hide;
  TabControlPrincipal.TabIndex := 0;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
  if Length(trim(FMensagem)) > 0 then
  begin
    showmessage(RetiraAcento(FMensagem));
    FErro := '';
  end;
  // LayoutMensagemToast.Visible := true;
end;

procedure TF_Principal2.FimThreadConsultado(Sender: TObject);
begin
  CarregaUltimoNSU;
  TLoading.Hide;
  TabControlPrincipal.TabIndex := 1;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

procedure TF_Principal2.TabControlManutencaoChange(Sender: TObject);
var
  wthread: TThread;
begin
  try
    case TabControlManutencao.TabIndex of
      0:
        begin
          ImageConsultar.Visible := true;
          ImageArquivar.Visible := false;
          ImageDarCiencia.Visible := true;
          TLoading.Show(F_Principal2,
            'Aguarde...Carregando documentos consultados');

          wthread := TThread.CreateAnonymousThread(
            procedure
            begin
              FErro := '';
              CarregaConsultados(1);
              TThread.Synchronize(wthread,
                procedure
                begin
                end);
            end);
          wthread.Start;
          wthread.OnTerminate := FimThreadConsultado;
        end;
      1:
        begin
          ImageConsultar.Visible := true;
          ImageArquivar.Visible := true;
          ImageDarCiencia.Visible := false;
          TLoading.Show(F_Principal2,
            'Aguarde...Carregando documentos dados ciência');

          wthread := TThread.CreateAnonymousThread(
            procedure
            begin
              FErro := '';
              CarregaCiencias;
              TThread.Synchronize(wthread,
                procedure
                begin
                end);
            end);
          wthread.Start;
          wthread.OnTerminate := FimThreadCiencia;
        end;
      2:
        begin
          ImageConsultar.Visible := true;
          ImageArquivar.Visible := false;
          ImageDarCiencia.Visible := false;
          TLoading.Show(F_Principal2,
            'Aguarde...Carregando documentos confirmados');

          wthread := TThread.CreateAnonymousThread(
            procedure
            begin
              FErro := '';
              CarregaConfirmados;
              TThread.Synchronize(wthread,
                procedure
                begin
                end);
            end);
          wthread.Start;
          wthread.OnTerminate := FimThreadConfirmado;
        end;
      3:
        begin
          ImageConsultar.Visible := true;
          ImageArquivar.Visible := false;
          ImageDarCiencia.Visible := false;
          TLoading.Show(F_Principal2,
            'Aguarde...Carregando documentos cancelados');

          wthread := TThread.CreateAnonymousThread(
            procedure
            begin
              FErro := '';
              CarregaCancelados;
              TThread.Synchronize(wthread,
                procedure
                begin
                end);
            end);
          wthread.Start;
          wthread.OnTerminate := FimThreadCancelado;
        end;
      4:
        begin
          ImageConsultar.Visible := true;
          ImageArquivar.Visible := false;
          ImageDarCiencia.Visible := false;
          TLoading.Show(F_Principal2,
            'Aguarde...Carregando documentos arquivados');

          wthread := TThread.CreateAnonymousThread(
            procedure
            begin
              FErro := '';
              CarregaArquivados;
              TThread.Synchronize(wthread,
                procedure
                begin
                end);
            end);
          wthread.Start;
          wthread.OnTerminate := FimThreadArquivado;
        end;
      5:
        begin
          ImageConsultar.Visible := false;
          ImageArquivar.Visible := false;
          ImageDarCiencia.Visible := false;
          TLoading.Show(F_Principal2,
            'Aguarde...Carregando documentos fora do prazo');

          wthread := TThread.CreateAnonymousThread(
            procedure
            begin
              FErro := '';
              CarregaForaPrazo;
              TThread.Synchronize(wthread,
                procedure
                begin
                end);
            end);
          wthread.Start;
          wthread.OnTerminate := FimThreadForaPrazo;
        end;
    end;
  finally
  end;
end;

procedure TF_Principal2.TabControlPrincipalChange(Sender: TObject);
begin
  case TabControlPrincipal.TabIndex of
    0:
      AtualizaDashboard;
  end;
end;

procedure TF_Principal2.AcionaPesquisaVendedor(XVendedor: string);
begin
end;

procedure TF_Principal2.Rectangle11Click(Sender: TObject);
begin
  EscondeMenuCiencia;
end;

procedure TF_Principal2.Rectangle5Click(Sender: TObject);
begin
  EscondeMenuConsultado;
end;

procedure TF_Principal2.Rectangle9Click(Sender: TObject);
var
  wthread: TThread;
begin
  MessageDlg('Deseja arquivar documento?',
    System.UITypes.TMsgDlgType.mtInformation, [System.UITypes.TMsgDlgBtn.mbYes,
    System.UITypes.TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
          begin
            TLoading.Show(F_Principal2, 'Aguarde...Arquivando documento');
            wthread := TThread.CreateAnonymousThread(
              procedure
              begin
                FErro := '';
                Arquivar(LabelNSUCiencia.TagString);
                wthread.Synchronize(wthread,
                  procedure
                  begin
                  end);
              end);
            wthread.Start;
            wthread.OnTerminate := FimThreadArquivar;
          end;
        mrNo:
          ;
      end;
    end);
end;

procedure TF_Principal2.RectangleExcluiPedidoClick(Sender: TObject);
var
  wthread: TThread;
begin
  MessageDlg('Deseja dar ciência no documento?',
    System.UITypes.TMsgDlgType.mtInformation, [System.UITypes.TMsgDlgBtn.mbYes,
    System.UITypes.TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
          begin
            TLoading.Show(F_Principal2, 'Aguarde...Dando ciência');
            wthread := TThread.CreateAnonymousThread(
              procedure
              begin
                FErro := '';
                DarCiencia(LabelNSUConsultado.TagString);
                wthread.Synchronize(wthread,
                  procedure
                  begin
                  end);
              end);
            wthread.Start;
            wthread.OnTerminate := FimThreadDarCiencia;
          end;
        mrNo:
          ;
      end;
    end);
end;

procedure TF_Principal2.FimThreadDarCiencia(Sender: TObject);
begin
  CarregaConsultados(1);
  TLoading.Hide;
  EscondeMenuConsultado;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

procedure TF_Principal2.FimThreadTransfereArquivosXML(Sender: TObject);
begin
  CarregaArquivosXML;
  TLoading.Hide;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

procedure TF_Principal2.FimThreadArquivar(Sender: TObject);
begin
  CarregaCiencias;
  TLoading.Hide;
  EscondeMenuCiencia;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

procedure TF_Principal2.FimThreadCiencia(Sender: TObject);
begin
  CarregaUltimoNSU;
  TLoading.Hide;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

procedure TF_Principal2.FimThreadConfirmado(Sender: TObject);
begin
  CarregaUltimoNSU;
  TLoading.Hide;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

procedure TF_Principal2.FimThreadArquivado(Sender: TObject);
begin
  CarregaUltimoNSU;
  TLoading.Hide;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

procedure TF_Principal2.FimThreadForaPrazo(Sender: TObject);
begin
//  CarregaForaPrazo;
  TLoading.Hide;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;


procedure TF_Principal2.FimThreadConsultar(Sender: TObject);
begin
  CarregaConsultados(1);
  CarregaUltimoNSU;
  TLoading.Hide;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

procedure TF_Principal2.FimThreadCancelado(Sender: TObject);
begin
  TLoading.Hide;
  if Length(trim(FErro)) > 0 then
  begin
    showmessage(RetiraAcento(FErro));
    FErro := '';
  end;
end;

function TF_Principal2.RetornaData(XData: string): tdate;
var
  wret: tdate;
  wdia, wmes, wano: word;
begin
  try
    wano := strtoint(copy(XData, 1, 4));
    wmes := strtoint(copy(XData, 6, 2));
    wdia := strtoint(copy(XData, 9, 2));
    wret := EncodeDate(wano, wmes, wdia);
  except
    wret := Date;
  end;
  Result := wret;
end;

procedure TF_Principal2.EscondeMenuConsultado;
begin
  aniMenuConsultado.Inverse := true;
  aniMenuConsultado.Start;
  aniFundoMenuConsultado.Inverse := true;
  aniFundoMenuConsultado.Start;
end;

procedure TF_Principal2.EscondeMenuCiencia;
begin
  aniMenuCiencia.Inverse := true;
  aniMenuCiencia.Start;
  aniFundoMenuCiencia.Inverse := true;
  aniFundoMenuCiencia.Start;
end;

procedure TF_Principal2.CarregaArquivados;
var
  ix, wqtdetotal: Integer;
  wvalortotal: double;
  wimgfundo, wimgmore, wimgxml, wimgcomxml: TStream;
  wbmp, wbmp2, wbmpxml, wbmpcomxml: TBitmap;
  wvendedor: string;
  wprovider: TprvComuns;
begin
  try
    try
      ListViewArquivados.BeginUpdate;
      ListViewArquivados.Items.Clear;
      ListViewArquivados.EndUpdate;

      wqtdetotal := 0;
      wvalortotal := 0;
      wprovider := TprvComuns.Create(nil);

      wimgxml := TMemoryStream.Create;
      Image13.Bitmap.SaveToStream(wimgxml);
      wimgxml.Position := 0;

      wimgcomxml := TMemoryStream.Create;
      Image14.Bitmap.SaveToStream(wimgcomxml);
      wimgcomxml.Position := 0;

      wimgfundo := TMemoryStream.Create;
      Image11.Bitmap.SaveToStream(wimgfundo);
      wimgfundo.Position := 0;

      wimgmore := TMemoryStream.Create;
      Image12.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      wbmp2 := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      wbmpxml := TBitmap.Create;
      wbmpxml.LoadFromStream(wimgxml);

      wbmpcomxml := TBitmap.Create;
      wbmpcomxml.LoadFromStream(wimgcomxml);

      ListViewArquivados.BeginUpdate;
      // ListViewConsultados.Items.Clear;

      if wprovider.CarregaDFeDocumentosArquivados then
      begin
        wprovider.FDMemTableDocumentosArquivados.Last;
        while not wprovider.FDMemTableDocumentosArquivados.Bof do
        begin
          with ListViewArquivados.Items.Add do
          begin
            if wprovider.FDMemTableDocumentosArquivados.FieldByName
              ('arquivosalvo').AsBoolean then
            begin
              TListItemImage(Objects.FindDrawable('ImageXML')).Bitmap
                := wbmpxml;
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap :=
                wbmpcomxml;
            end
            else
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap := wbmp;
            TListItemImage(Objects.FindDrawable('ImageFundo')).TagString :=
              wprovider.FDMemTableDocumentosArquivados.FieldByName
              ('nsu').AsString;

            TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap
              := wbmp2;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=
              wprovider.FDMemTableDocumentosArquivados.FieldByName
              ('chavenfe').AsString;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagFloat :=
              wprovider.FDMemTableDocumentosArquivados.FieldByName('nsu')
              .AsInteger;

            TListItemText(Objects.FindDrawable('TextNSU')).Text :=
              formatfloat('0000',
              wprovider.FDMemTableDocumentosArquivados.FieldByName('nsu')
              .AsInteger);
            // TListItemText(Objects.FindDrawable('TextNSU')).TextColor        := StringToAlphaColor('black');
            TListItemText(Objects.FindDrawable('TextEmitente')).Text :=
              wprovider.FDMemTableDocumentosArquivados.FieldByName
              ('nomeemitente').AsString;
            TListItemText(Objects.FindDrawable('TextCNPJ')).Text :=
              wprovider.FDMemTableDocumentosArquivados.FieldByName
              ('cnpjemitente').AsString + ' (' +
              wprovider.FDMemTableDocumentosArquivados.FieldByName('ator')
              .AsString + ')';
            TListItemText(Objects.FindDrawable('TextDocumento')).Text :=
              formatdatetime('dd/mm/yyyy',
              RetornaData(wprovider.FDMemTableDocumentosArquivados.FieldByName
              ('dataemissao').AsString));
            TListItemText(Objects.FindDrawable('TextChaveNFe')).Text :=
              wprovider.FDMemTableDocumentosArquivados.FieldByName
              ('chavenfe').AsString;

            if wprovider.FDMemTableDocumentosArquivados.FieldByName('valornfe').IsNull
            then
              TListItemText(Objects.FindDrawable('TextValor')).Text := 'R$ 0,00'
            else
              TListItemText(Objects.FindDrawable('TextValor')).Text :=
                formatfloat('R$ #,0.00',
                wprovider.FDMemTableDocumentosArquivados.FieldByName
                ('valornfe').AsFloat);
          end;
          inc(wqtdetotal);
          if not wprovider.FDMemTableDocumentosArquivados.FieldByName
            ('valornfe').IsNull then
            wvalortotal := wvalortotal +
              wprovider.FDMemTableDocumentosArquivados.FieldByName
              ('valornfe').AsFloat;
          wprovider.FDMemTableDocumentosArquivados.Prior;
        end;
      end;
    finally
      ListViewArquivados.EndUpdate;
      if wqtdetotal > 1 then
        LabelQuantidade.Text := formatfloat('#0 Documentos', wqtdetotal)
      else
        LabelQuantidade.Text := formatfloat('#0 Documento', wqtdetotal);
      // LabelValor.Text := FormatFloat('R$ #,0.00',wvalortotal);
      wprovider.FDMemTableDocumentosArquivados.First;
    end;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao carregar documentos arquivados.' +
        RetiraAcento(E.Message);
      // showmessage(E.Message);
    end;
  end;
end;

procedure TF_Principal2.CarregaCancelados;
var
  ix, wqtdetotal: Integer;
  wvalortotal: double;
  wimgfundo, wimgmore, wimgxml, wimgcomxml: TStream;
  wbmp, wbmp2, wbmpxml, wbmpcomxml: TBitmap;
  wvendedor: string;
  wprovider: TprvComuns;
begin
  try
    try
      ListViewCancelados.BeginUpdate;
      ListViewCancelados.Items.Clear;
      ListViewCancelados.EndUpdate;

      wqtdetotal := 0;
      wvalortotal := 0;
      wprovider := TprvComuns.Create(nil);

      wimgxml := TMemoryStream.Create;
      Image17.Bitmap.SaveToStream(wimgxml);
      wimgxml.Position := 0;

      wimgcomxml := TMemoryStream.Create;
      Image18.Bitmap.SaveToStream(wimgcomxml);
      wimgcomxml.Position := 0;

      wimgfundo := TMemoryStream.Create;
      Image15.Bitmap.SaveToStream(wimgfundo);
      wimgfundo.Position := 0;

      wimgmore := TMemoryStream.Create;
      Image16.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      wbmp2 := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      wbmpxml := TBitmap.Create;
      wbmpxml.LoadFromStream(wimgxml);

      wbmpcomxml := TBitmap.Create;
      wbmpcomxml.LoadFromStream(wimgcomxml);

      ListViewCancelados.BeginUpdate;
      // ListViewConsultados.Items.Clear;

      if wprovider.CarregaDFeDocumentosCancelados then
      begin
        wprovider.FDMemTableDocumentosCancelados.Last;
        while not wprovider.FDMemTableDocumentosCancelados.Bof do
        begin
          with ListViewCancelados.Items.Add do
          begin
            if wprovider.FDMemTableDocumentosCancelados.FieldByName
              ('arquivosalvo').AsBoolean then
            begin
              TListItemImage(Objects.FindDrawable('ImageXML')).Bitmap
                := wbmpxml;
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap :=
                wbmpcomxml;
            end
            else
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap := wbmp;
            TListItemImage(Objects.FindDrawable('ImageFundo')).TagString :=
              wprovider.FDMemTableDocumentosCancelados.FieldByName
              ('nsu').AsString;

            TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap
              := wbmp2;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=
              wprovider.FDMemTableDocumentosCancelados.FieldByName
              ('chavenfe').AsString;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagFloat :=
              wprovider.FDMemTableDocumentosCancelados.FieldByName('nsu')
              .AsInteger;

            TListItemText(Objects.FindDrawable('TextNSU')).Text :=
              formatfloat('0000',
              wprovider.FDMemTableDocumentosCancelados.FieldByName('nsu')
              .AsInteger);
            // TListItemText(Objects.FindDrawable('TextNSU')).TextColor        := StringToAlphaColor('black');
            TListItemText(Objects.FindDrawable('TextEmitente')).Text :=
              wprovider.FDMemTableDocumentosCancelados.FieldByName
              ('nomeemitente').AsString;
            TListItemText(Objects.FindDrawable('TextCNPJ')).Text :=
              wprovider.FDMemTableDocumentosCancelados.FieldByName
              ('cnpjemitente').AsString + ' (' +
              wprovider.FDMemTableDocumentosCancelados.FieldByName('ator')
              .AsString + ')';
            TListItemText(Objects.FindDrawable('TextDocumento')).Text :=
              formatdatetime('dd/mm/yyyy',
              RetornaData(wprovider.FDMemTableDocumentosCancelados.FieldByName
              ('dataemissao').AsString));
            TListItemText(Objects.FindDrawable('TextChaveNFe')).Text :=
              wprovider.FDMemTableDocumentosCancelados.FieldByName
              ('chavenfe').AsString;

            if wprovider.FDMemTableDocumentosCancelados.FieldByName('valornfe').IsNull
            then
              TListItemText(Objects.FindDrawable('TextValor')).Text := 'R$ 0,00'
            else
              TListItemText(Objects.FindDrawable('TextValor')).Text :=
                formatfloat('R$ #,0.00',
                wprovider.FDMemTableDocumentosCancelados.FieldByName
                ('valornfe').AsFloat);
          end;
          inc(wqtdetotal);
          if not wprovider.FDMemTableDocumentosCancelados.FieldByName
            ('valornfe').IsNull then
            wvalortotal := wvalortotal +
              wprovider.FDMemTableDocumentosCancelados.FieldByName
              ('valornfe').AsFloat;
          wprovider.FDMemTableDocumentosCancelados.Prior;
        end;
      end;
    finally
      ListViewCancelados.EndUpdate;
      if wqtdetotal > 1 then
        LabelQuantidade.Text := formatfloat('#0 Documentos', wqtdetotal)
      else
        LabelQuantidade.Text := formatfloat('#0 Documento', wqtdetotal);
      // LabelValor.Text := FormatFloat('R$ #,0.00',wvalortotal);
      wprovider.FDMemTableDocumentosCancelados.First;
    end;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao carregar documentos cancelados.' +
        RetiraAcento(E.Message);
      // showmessage(E.Message);
    end;
  end;
end;

procedure TF_Principal2.CarregaForaPrazo;
var
  ix, wqtdetotal: Integer;
  wvalortotal: double;
  wimgfundo, wimgmore, wimgxml, wimgcomxml: TStream;
  wbmp, wbmp2, wbmpxml, wbmpcomxml: TBitmap;
  wvendedor: string;
  wprovider: TprvComuns;
begin
  try
    try
      ListViewForaPrazo.BeginUpdate;
      ListViewForaPrazo.Items.Clear;
      ListViewForaPrazo.EndUpdate;

      wqtdetotal := 0;
      wvalortotal := 0;
      wprovider := TprvComuns.Create(nil);

      wimgfundo := TMemoryStream.Create;
      Image37.Bitmap.SaveToStream(wimgfundo);
      wimgfundo.Position := 0;

      wbmp := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      ListViewForaPrazo.BeginUpdate;
      // ListViewConsultados.Items.Clear;

      if wprovider.CarregaDFeDocumentosForaPrazo then
      begin
        wprovider.FDMemTableDocumentosForaPrazo.Last;
        while not wprovider.FDMemTableDocumentosForaPrazo.Bof do
        begin
          with ListViewForaPrazo.Items.Add do
          begin
            TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap    := wbmp;
            TListItemImage(Objects.FindDrawable('ImageFundo')).TagString := wprovider.FDMemTableDocumentosForaPrazo.FieldByName('nsu').AsString;
            TListItemText(Objects.FindDrawable('TextNSU')).Text          := formatfloat('0000',wprovider.FDMemTableDocumentosForaPrazo.FieldByName('nsu').AsInteger);
            TListItemText(Objects.FindDrawable('TextEmitente')).Text     := wprovider.FDMemTableDocumentosForaPrazo.FieldByName('nomeemitente').AsString;
            TListItemText(Objects.FindDrawable('TextCNPJ')).Text         := wprovider.FDMemTableDocumentosForaPrazo.FieldByName('cnpjemitente').AsString + ' (' +
                                                                            wprovider.FDMemTableDocumentosForaPrazo.FieldByName('ator').AsString + ')';
            TListItemText(Objects.FindDrawable('TextDocumento')).Text    := formatdatetime('dd/mm/yyyy',RetornaData(wprovider.FDMemTableDocumentosForaPrazo.FieldByName('dataemissao').AsString));
            TListItemText(Objects.FindDrawable('TextChaveNFe')).Text     := wprovider.FDMemTableDocumentosForaPrazo.FieldByName('chavenfe').AsString;

            if wprovider.FDMemTableDocumentosForaPrazo.FieldByName('valornfe').IsNull then
              TListItemText(Objects.FindDrawable('TextValor')).Text := 'R$ 0,00'
            else
              TListItemText(Objects.FindDrawable('TextValor')).Text := formatfloat('R$ #,0.00',wprovider.FDMemTableDocumentosForaPrazo.FieldByName('valornfe').AsFloat);
          end;
          inc(wqtdetotal);
          if not wprovider.FDMemTableDocumentosForaPrazo.FieldByName('valornfe').IsNull then
            wvalortotal := wvalortotal + wprovider.FDMemTableDocumentosForaPrazo.FieldByName('valornfe').AsFloat;
          wprovider.FDMemTableDocumentosForaPrazo.Prior;
        end;
      end;
    finally
      ListViewForaPrazo.EndUpdate;
      if wqtdetotal > 1 then
        LabelQuantidade.Text := formatfloat('#0 Documentos', wqtdetotal)
      else
        LabelQuantidade.Text := formatfloat('#0 Documento', wqtdetotal);
      // LabelValor.Text := FormatFloat('R$ #,0.00',wvalortotal);
      wprovider.FDMemTableDocumentosForaPrazo.First;
    end;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao carregar documentos fora do prazo.' +
        RetiraAcento(E.Message);
      // showmessage(E.Message);
    end;
  end;
end;


procedure TF_Principal2.CarregaConfirmados;
var
  ix, wqtdetotal: Integer;
  wvalortotal: double;
  wimgfundo, wimgmore, wimgxml, wimgcomxml: TStream;
  wbmp, wbmp2, wbmpxml, wbmpcomxml: TBitmap;
  wvendedor: string;
  wprovider: TprvComuns;
begin
  try
    try
      ListViewConfirmados.BeginUpdate;
      ListViewConfirmados.Items.Clear;
      ListViewConfirmados.EndUpdate;

      wqtdetotal := 0;
      wvalortotal := 0;
      wprovider := TprvComuns.Create(nil);

      wimgxml := TMemoryStream.Create;
      Image21.Bitmap.SaveToStream(wimgxml);
      wimgxml.Position := 0;

      wimgcomxml := TMemoryStream.Create;
      Image22.Bitmap.SaveToStream(wimgcomxml);
      wimgcomxml.Position := 0;

      wimgfundo := TMemoryStream.Create;
      Image19.Bitmap.SaveToStream(wimgfundo);
      wimgfundo.Position := 0;

      wimgmore := TMemoryStream.Create;
      Image20.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      wbmp2 := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      wbmpxml := TBitmap.Create;
      wbmpxml.LoadFromStream(wimgxml);

      wbmpcomxml := TBitmap.Create;
      wbmpcomxml.LoadFromStream(wimgcomxml);

      ListViewConfirmados.BeginUpdate;
      // ListViewConsultados.Items.Clear;

      if wprovider.CarregaDFeDocumentosConfirmados then
      begin
        wprovider.FDMemTableDocumentosConfirmados.Last;
        while not wprovider.FDMemTableDocumentosConfirmados.Bof do
        begin
          with ListViewConfirmados.Items.Add do
          begin
            if wprovider.FDMemTableDocumentosConfirmados.FieldByName
              ('arquivosalvo').AsBoolean then
            begin
              TListItemImage(Objects.FindDrawable('ImageXML')).Bitmap
                := wbmpxml;
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap :=
                wbmpcomxml;
            end
            else
              TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap := wbmp;
            TListItemImage(Objects.FindDrawable('ImageFundo')).TagString :=
              wprovider.FDMemTableDocumentosConfirmados.FieldByName
              ('nsu').AsString;

            TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap
              := wbmp2;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString :=
              wprovider.FDMemTableDocumentosConfirmados.FieldByName
              ('chavenfe').AsString;
            TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagFloat :=
              wprovider.FDMemTableDocumentosConfirmados.FieldByName('nsu')
              .AsInteger;

            TListItemText(Objects.FindDrawable('TextNSU')).Text :=
              formatfloat('0000',
              wprovider.FDMemTableDocumentosConfirmados.FieldByName('nsu')
              .AsInteger);
            // TListItemText(Objects.FindDrawable('TextNSU')).TextColor        := StringToAlphaColor('black');
            TListItemText(Objects.FindDrawable('TextEmitente')).Text :=
              wprovider.FDMemTableDocumentosConfirmados.FieldByName
              ('nomeemitente').AsString;
            TListItemText(Objects.FindDrawable('TextCNPJ')).Text :=
              wprovider.FDMemTableDocumentosConfirmados.FieldByName
              ('cnpjemitente').AsString + ' (' +
              wprovider.FDMemTableDocumentosConfirmados.FieldByName('ator')
              .AsString + ')';
            TListItemText(Objects.FindDrawable('TextDocumento')).Text :=
              formatdatetime('dd/mm/yyyy',
              RetornaData(wprovider.FDMemTableDocumentosConfirmados.FieldByName
              ('dataemissao').AsString));
            TListItemText(Objects.FindDrawable('TextChaveNFe')).Text :=
              wprovider.FDMemTableDocumentosConfirmados.FieldByName
              ('chavenfe').AsString;

            if wprovider.FDMemTableDocumentosConfirmados.FieldByName('valornfe')
              .IsNull then
              TListItemText(Objects.FindDrawable('TextValor')).Text := 'R$ 0,00'
            else
              TListItemText(Objects.FindDrawable('TextValor')).Text :=
                formatfloat('R$ #,0.00',
                wprovider.FDMemTableDocumentosConfirmados.FieldByName
                ('valornfe').AsFloat);
          end;
          inc(wqtdetotal);
          if not wprovider.FDMemTableDocumentosConfirmados.FieldByName
            ('valornfe').IsNull then
            wvalortotal := wvalortotal +
              wprovider.FDMemTableDocumentosConfirmados.FieldByName
              ('valornfe').AsFloat;
          wprovider.FDMemTableDocumentosConfirmados.Prior;
        end;
      end;
    finally
      ListViewConfirmados.EndUpdate;
      if wqtdetotal > 1 then
        LabelQuantidade.Text := formatfloat('#0 Documentos', wqtdetotal)
      else
        LabelQuantidade.Text := formatfloat('#0 Documento', wqtdetotal);
      // LabelValor.Text := FormatFloat('R$ #,0.00',wvalortotal);
      wprovider.FDMemTableDocumentosConfirmados.First;
    end;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao carregar documentos confirmados.' +
        RetiraAcento(E.Message);
    end;
  end;
end;

procedure TF_Principal2.TerminaTrigger;
begin
end;

function TF_Principal2.RetiraAcento(XTexto: string): string;
var
  wret: string;
begin
  try
    wret := StringReplace(XTexto, 'á', 'a', [rfReplaceAll]);
    wret := StringReplace(wret, 'ã', 'a', [rfReplaceAll]);
    wret := StringReplace(wret, 'à', 'a', [rfReplaceAll]);
    wret := StringReplace(wret, 'â', 'a', [rfReplaceAll]);
    wret := StringReplace(wret, 'é', 'e', [rfReplaceAll]);
    wret := StringReplace(wret, 'ê', 'e', [rfReplaceAll]);
    wret := StringReplace(wret, 'í', 'i', [rfReplaceAll]);
    wret := StringReplace(wret, 'ó', 'o', [rfReplaceAll]);
    wret := StringReplace(wret, 'ú', 'u', [rfReplaceAll]);

    wret := StringReplace(wret, 'Á', 'A', [rfReplaceAll]);
    wret := StringReplace(wret, 'Ã', 'A', [rfReplaceAll]);
    wret := StringReplace(wret, 'À', 'A', [rfReplaceAll]);
    wret := StringReplace(wret, 'Â', 'A', [rfReplaceAll]);
    wret := StringReplace(wret, 'É', 'E', [rfReplaceAll]);
    wret := StringReplace(wret, 'Ê', 'E', [rfReplaceAll]);
    wret := StringReplace(wret, 'Í', 'I', [rfReplaceAll]);
    wret := StringReplace(wret, 'Ó', 'O', [rfReplaceAll]);
    wret := StringReplace(wret, 'Ú', 'U', [rfReplaceAll]);

    wret := StringReplace(wret, 'ç', 'c', [rfReplaceAll]);
    wret := StringReplace(wret, 'Ç', 'C', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00E1', 'á', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00E0', 'à', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00E2', 'â', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00E3', 'ã', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00C1', 'Á', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00C0', 'À', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00C2', 'Â', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00C3', 'Ã', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00E9', 'é', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00E8', 'è', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00EA', 'ê', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00C9', 'É', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00C8', 'È', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00CA', 'Ê', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00ED', 'í', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00EC', 'ì', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00CD', 'Í', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00CC', 'Ì', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00F3', 'ó', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00F2', 'ò', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00F4', 'ô', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00F5', 'õ', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00D3', 'Ó', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00D2', 'Ò', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00D4', 'Ô', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00D5', 'Õ', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00FA', 'ú', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00F9', 'ù', [rfReplaceAll]);

    wret := StringReplace(wret, '\u00DA', 'Ú', [rfReplaceAll]);
    wret := StringReplace(wret, '\u00D9', 'Ù', [rfReplaceAll]);

    wret := StringReplace(wret, '\r\n', '', [rfReplaceAll]);
  finally

  end;
  Result := wret;
end;

procedure TF_Principal2.CarregaArquivosXML;
var
  ix, wqtdetotal: Integer;
  wvalortotal: double;
  wprovider: TprvComuns;
  wbmp, wbmp2: TBitmap;
  wimgfundo, wimgmenu: TMemoryStream;
begin
  try
    try
      ListViewArquivosXML.BeginUpdate;
      ListViewArquivosXML.Items.Clear;
      ListViewArquivosXML.EndUpdate;

      wimgfundo := TMemoryStream.Create;
      Image32.Bitmap.SaveToStream(wimgfundo);
      wimgfundo.Position := 0;

      wbmp := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      wimgmenu := TMemoryStream.Create;
      Image33.Bitmap.SaveToStream(wimgmenu);
      wimgmenu.Position := 0;

      wbmp2 := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmenu);

      wqtdetotal := 0;
      wvalortotal := 0;
      wprovider := TprvComuns.Create(nil);

      // ListViewConsultados.Items.Clear;
      ListViewArquivosXML.BeginUpdate;

      if wprovider.CarregaDFeArquivosXML then
      begin
        wprovider.FDMemTableArquivosXML.First;

        // if XFlag=1 then
        while not wprovider.FDMemTableArquivosXML.Eof do
        begin
          with ListViewArquivosXML.Items.Add do
          begin
            TListItemImage(Objects.FindDrawable('ImageArquivoXML'))
              .Bitmap := wbmp;
            TListItemImage(Objects.FindDrawable('ImageMenu')).Bitmap := wbmp2;
            TListItemText(Objects.FindDrawable('TextArquivo')).Text :=
              wprovider.FDMemTableArquivosXML.FieldByName('arquivo').AsString;
            TListItemText(Objects.FindDrawable('TextPropriedades')).Text :=
              wprovider.FDMemTableArquivosXML.FieldByName('data').AsString +
              '  -  ' + wprovider.FDMemTableArquivosXML.FieldByName('tamanho')
              .AsString + ' Kb';
          end;
          inc(wqtdetotal);
          wprovider.FDMemTableArquivosXML.Next;
        end;
      end;
    finally
      ListViewArquivosXML.EndUpdate;
      if wqtdetotal > 1 then
        LabelQuantidadeArquivosXML.Text := formatfloat('#0 Arquivos',
          wqtdetotal)
      else
        LabelQuantidadeArquivosXML.Text := formatfloat('#0 Arquivo',
          wqtdetotal);
      // wprovider.FDMemTableDocumentosConsultados.First;
    end;
  except
    On E: Exception do
    begin
      FErro := 'Erro ao carregar arquivos XML.' + RetiraAcento(E.Message);
    end;
  end;
end;

end.

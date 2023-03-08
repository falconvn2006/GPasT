unit uConfiguracao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Math, System.StrUtils,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TF_Configuracao = class(TForm)
    LayoutTopo: TLayout;
    RectangleTopo: TRectangle;
    ImageVoltar: TImage;
    LabelTitulo: TLabel;
    LayoutBottom: TLayout;
    RectangleBottom: TRectangle;
    LayoutCliente: TLayout;
    LayoutClientePadrao: TLayout;
    LabelClientePadrao: TLabel;
    EditClientePadrao: TEdit;
    ImageLimpaCliente: TImage;
    ImagePesquisa: TImage;
    ImageSalva: TImage;
    Label1: TLabel;
    EditCondicaoPadrao: TEdit;
    ImageLimpaCondicao: TImage;
    Image2: TImage;
    TabControlConfiguracao: TTabControl;
    TabItemConfiguracao: TTabItem;
    TabItemPesquisaCliente: TTabItem;
    TabItemPesquisaCondicao: TTabItem;
    LayoutTopo1: TLayout;
    Rectangle1: TRectangle;
    Image3: TImage;
    Label2: TLabel;
    LayoutTopo2: TLayout;
    Rectangle2: TRectangle;
    Image4: TImage;
    Label3: TLabel;
    LayoutBottom3: TLayout;
    Rectangle3: TRectangle;
    LabelTotalClientes: TLabel;
    LayoutBottom11: TLayout;
    Rectangle4: TRectangle;
    LabelTotalCondicoes: TLabel;
    LayoutCliente1: TLayout;
    ListViewCliente: TListView;
    ImageDetalhe: TImage;
    LabelTotalPesquisa: TLabel;
    LinePesquisa: TLine;
    LayoutCliente21: TLayout;
    ListViewCondicao: TListView;
    Image1: TImage;
    Label6: TLabel;
    Line5: TLine;
    RoundRectCliente: TRoundRect;
    RoundRectCondicao: TRoundRect;
    LayoutClienteAPI: TLayout;
    LabelDadosPedido: TLabel;
    Line6: TLine;
    RoundRect1: TRoundRect;
    EditIP: TEdit;
    Image5: TImage;
    Label7: TLabel;
    Label8: TLabel;
    RoundRect2: TRoundRect;
    EditPorta: TEdit;
    Image6: TImage;
    Label9: TLabel;
    Line1: TLine;
    LayoutClienteGeral: TLayout;
    Label4: TLabel;
    Label5: TLabel;
    Line2: TLine;
    SwitchCodBarra: TSwitch;
    Label10: TLabel;
    SwitchPedVendedor: TSwitch;
    LayoutClienteLeitor: TLayout;
    Label11: TLabel;
    Line3: TLine;
    RadioButtonBarcodeScanner: TRadioButton;
    RadioButtonCodeReader: TRadioButton;
    procedure ImageVoltarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ImageLimpaClienteClick(Sender: TObject);
    procedure ImageLimpaCondicaoClick(Sender: TObject);
    procedure ImageSalvaClick(Sender: TObject);
    procedure ListViewClienteItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure ImagePesquisaClick(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure ListViewCondicaoItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure EditClientePadraoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure EditCondicaoPadraoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    procedure AcionaPesquisaCliente(XCliente: string);
    procedure AcionaPesquisaCondicao(XCondicao: string);
    function SalvaConfiguracao: boolean;
    function RetornaTipoCondicao(XTipo: string): string;
    { Private declarations }
  public
    FAbre: boolean;
    { Public declarations }
  end;

var
  F_Configuracao: TF_Configuracao;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses uMeusPedidos, pComuns, Loading;

procedure TF_Configuracao.EditClientePadraoKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (FAbre) and (key = vkReturn) and (length(trim(EditClientePadrao.Text))>0) then
     AcionaPesquisaCliente(EditClientePadrao.Text);
end;

procedure TF_Configuracao.EditCondicaoPadraoKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (FAbre) and (key = vkReturn) and (length(trim(EditCondicaoPadrao.Text))>0) then
     AcionaPesquisaCondicao(EditCondicaoPadrao.Text);
end;

procedure TF_Configuracao.FormActivate(Sender: TObject);
begin
  FAbre := true;
end;

procedure TF_Configuracao.Image2Click(Sender: TObject);
begin
  AcionaPesquisaCondicao(EditCondicaoPadrao.Text);
end;

procedure TF_Configuracao.Image4Click(Sender: TObject);
begin
  TabControlConfiguracao.ActiveTab := TabItemConfiguracao;
end;

procedure TF_Configuracao.Image5Click(Sender: TObject);
begin
  EditIP.Text := '';
  EditIP.SetFocus;
end;

procedure TF_Configuracao.Image6Click(Sender: TObject);
begin
  EditPorta.Text := '';
  EditPorta.SetFocus;
end;

procedure TF_Configuracao.ImageLimpaClienteClick(Sender: TObject);
begin
  EditClientePadrao.Text      := '';
  EditClientePadrao.TagString := '';
end;

procedure TF_Configuracao.ImageLimpaCondicaoClick(Sender: TObject);
begin
  EditCondicaoPadrao.Text      := '';
  EditCondicaoPadrao.TagString := '';
end;

procedure TF_Configuracao.ImagePesquisaClick(Sender: TObject);
begin
  AcionaPesquisaCliente(EditClientePadrao.Text);
end;

procedure TF_Configuracao.ImageSalvaClick(Sender: TObject);
begin
  TLoading.Show(F_Configuracao,'Aguarde...Salvando Configuracao');

  TThread.CreateAnonymousThread(procedure
                                begin
                                  if SalvaConfiguracao then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             if Assigned(F_MeusPedidos) then
                                                                begin
                                                                  F_MeusPedidos.Show;
                                                                  F_MeusPedidos.OnShow(F_MeusPedidos);
                                                                end;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Problema ao salvar configuração');
                                                           end);
                                     end;
                                end).Start;

  if not ImageVoltar.Visible then
    Application.Terminate;
//  SalvaConfiguracao;
end;

procedure TF_Configuracao.ImageVoltarClick(Sender: TObject);
begin
  if TabControlConfiguracao.TabIndex=0 then
     begin
       if Assigned(F_MeusPedidos) then
          F_MeusPedidos.Show;
     end
  else
    TabControlConfiguracao.ActiveTab := TabItemConfiguracao;
end;

procedure TF_Configuracao.ListViewClienteItemClickEx(const Sender: TObject;
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
                 FAbre                        := false;
                 EditClientePadrao.Text       := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('nome').AsString;
                 EditClientePadrao.TagString  := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('id').AsString;
                 FAbre                        := true;
               end;
            TabControlConfiguracao.ActiveTab  := TabItemConfiguracao;
          end;
     end;
end;

procedure TF_Configuracao.ListViewCondicaoItemClickEx(const Sender: TObject;
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
                 FAbre                         := false;
                 EditCondicaoPadrao.Text       := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('descricao').AsString;
                 EditCondicaoPadrao.TagString  := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString;
                 FAbre                         := true;
               end;
            TabControlConfiguracao.ActiveTab  := TabItemConfiguracao;
          end;
     end;
end;

procedure TF_Configuracao.AcionaPesquisaCliente(XCliente: string);
var wimgmore: TMemoryStream;
    wbmp: TBitmap;
begin
  try
      ListViewCliente.BeginUpdate;
      ListViewCliente.items.Clear;

      wimgmore          := TMemoryStream.Create;
      ImageDetalhe.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp   := TBitmap.Create;
      wbmp.LoadFromStream(wimgmore);

      TLoading.Show(F_Configuracao,'Aguarde...Carregando lista de clientes');

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
                                                             LabelTotalClientes.Text      := formatfloat('00000 Clientes',F_MeusPedidos.Fprovider.FDMemTableClientes.RecordCount);
                                                             ListViewCliente.EndUpdate;
                                                             if F_MeusPedidos.Fprovider.FDMemTableClientes.RecordCount=1 then
                                                                begin
                                                                  EditClientePadrao.Text       := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('nome').AsString;
                                                                  EditClientePadrao.TagString  := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('id').AsString;
                                                                end
                                                             else if F_MeusPedidos.Fprovider.FDMemTableClientes.RecordCount>0 then
                                                                TabControlConfiguracao.ActiveTab := TabItemPesquisaCliente;
                                                             TLoading.Hide;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Nenhum cliente localizado');
                                                           end);
                                     end;
                                end).Start;

  finally
{    LabelTotalClientes.Text      := formatfloat('00000 Clientes',F_MeusPedidos.Fprovider.FDMemTableClientes.RecordCount);
    ListViewCliente.EndUpdate;
    if F_MeusPedidos.Fprovider.FDMemTableClientes.RecordCount=1 then
       begin
         EditClientePadrao.Text       := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('nome').AsString;
         EditClientePadrao.TagString  := F_MeusPedidos.Fprovider.FDMemTableClientes.FieldByName('id').AsString;
       end
    else if F_MeusPedidos.Fprovider.FDMemTableClientes.RecordCount>0 then
       TabControlConfiguracao.ActiveTab := TabItemPesquisaCliente;}
  end;
end;

procedure TF_Configuracao.AcionaPesquisaCondicao(XCondicao: string);
var wimgmore: TMemoryStream;
    wbmp: TBitmap;
begin
  try
      ListViewCondicao.BeginUpdate;
      ListViewCondicao.items.Clear;

      wimgmore          := TMemoryStream.Create;
      ImageDetalhe.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp   := TBitmap.Create;
      wbmp.LoadFromStream(wimgmore);

      TLoading.Show(F_Configuracao,'Aguarde...Carregando lista de condições');

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
                                                             LabelTotalCondicoes.Text      := formatfloat('00000 Condições',F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount);
                                                             ListViewCondicao.EndUpdate;
                                                             if F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount=1 then
                                                                begin
                                                                  EditCondicaoPadrao.Text      := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('descricao').AsString;
                                                                  EditCondicaoPadrao.TagString := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString;
                                                                end
                                                             else if F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount>0 then
                                                                TabControlConfiguracao.ActiveTab := TabItemPesquisaCondicao;
                                                             TLoading.Hide;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Nenhuma condição localizada');
                                                           end);
                                     end;
                                end).Start;

  finally
{    LabelTotalCondicoes.Text      := formatfloat('00000 Condições',F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount);
    ListViewCondicao.EndUpdate;
    if F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount=1 then
       begin
         EditCondicaoPadrao.Text      := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('descricao').AsString;
         EditCondicaoPadrao.TagString := F_MeusPedidos.Fprovider.FDMemTableCondicoes.FieldByName('id').AsString;
       end
    else if F_MeusPedidos.Fprovider.FDMemTableCondicoes.RecordCount>0 then
       TabControlConfiguracao.ActiveTab := TabItemPesquisaCondicao;}
  end;
end;

function TF_Configuracao.RetornaTipoCondicao(XTipo: string): string;
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

function TF_Configuracao.SalvaConfiguracao: boolean;
var wret: boolean;
begin
  try
//    prvComuns.FechaConexaoLocal;
    prvComuns.AbreConexaoLocal;
    with prvComuns.FDQueryConfigura do
    begin
      DisableControls;
      Close;
      Open;
      EnableControls;
    end;

    prvComuns.FDQueryConfigura.Edit;
    prvComuns.FDQueryConfiguraidCliente.AsInteger   := strtointdef(EditClientePadrao.TagString,0);
    prvComuns.FDQueryConfiguranomeCliente.AsString  := EditClientePadrao.Text;
    prvComuns.FDQueryConfiguraidCondicao.AsInteger  := strtointdef(EditCondicaoPadrao.TagString,0);
    prvComuns.FDQueryConfiguranomeCondicao.AsString := EditCondicaoPadrao.Text;
    prvComuns.FDQueryConfiguraipAPI.AsString        := EditIP.Text;
    prvComuns.FDQueryConfiguraportaAPI.AsString     := EditPorta.Text;
    prvComuns.FDQueryConfiguralerEtiquetaCodBarra.AsBoolean          := SwitchCodBarra.IsChecked;
    prvComuns.FDQueryConfiguramostrarSomentePedidoVendedor.AsBoolean := SwitchPedVendedor.IsChecked;
    prvComuns.FDQueryConfiguratipoLeitorCodBarra.AsString            := ifthen(RadioButtonBarcodeScanner.IsChecked,'BarcodeScanner','CodeReader');
    prvComuns.FDQueryConfigura.Post;
    wret := true;
  except
    On E: Exception do
    begin
      wret := false;
//      showmessage('Problema ao salvar configuração'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

end.

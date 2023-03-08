unit uMeusPedidos;

interface

uses
  System.SysUtils, System.Types, System.UIConsts, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, System.Math, System.StrUtils,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.DateTimeCtrls, pComuns, System.JSON, FMX.Ani;

type
  TF_MeusPedidos = class(TForm)
    RectangleFundo: TRectangle;
    LayoutTopo: TLayout;
    LayoutBottom: TLayout;
    LayoutCliente: TLayout;
    RectangleTopo: TRectangle;
    ImageMenu: TImage;
    LabelTitulo: TLabel;
    RectangleBottom: TRectangle;
    ImageNovo: TImage;
    ListViewPedidos: TListView;
    Image1: TImage;
    Image2: TImage;
    ImageReload: TImage;
    DateEditPeriodo: TDateEdit;
    StyleBook1: TStyleBook;
    LayoutTotais: TLayout;
    LabelQtde: TLabel;
    LabelValor: TLabel;
    ImagePedidoPendente: TImage;
    ImagePedidoBloqueado: TImage;
    ImagePedidoLiberado: TImage;
    ImagePedidoImportado: TImage;
    LayoutMenuPedido: TLayout;
    RectangleFundoMenu: TRectangle;
    LayoutMenuPrincipal: TLayout;
    RectangleFundoMenuPrincipal: TRectangle;
    RectangleMenuPrincipal: TRectangle;
    Layout6: TLayout;
    LabelFecharMenuPrincipal: TLabel;
    Line4: TLine;
    Layout7: TLayout;
    LabelNovoPedido: TLabel;
    Line5: TLine;
    Layout9: TLayout;
    LabelConfiguracao: TLabel;
    LabelDadosPedido: TLabel;
    Line6: TLine;
    RoundRect1: TRoundRect;
    Image3: TImage;
    RectangleMenuDeslizante: TRectangle;
    Image4: TImage;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Rectangle2: TRectangle;
    Label2: TLabel;
    aniFundoMenuDeslizante: TFloatAnimation;
    aniMenuDeslizante: TFloatAnimation;
    Layout5: TLayout;
    Label3: TLabel;
    LabelVendedorLogado: TLabel;
    Rectangle3: TRectangle;
    aniFundoMenuPedido: TFloatAnimation;
    RectangleMenuPedido: TRectangle;
    RectangleExcluiPedido: TRectangle;
    Label5: TLabel;
    RectangleFinalizaPedido: TRectangle;
    LabelFinalizaPedido: TLabel;
    aniMenuPedido: TFloatAnimation;
    Rectangle7: TRectangle;
    Layout8: TLayout;
    Label7: TLabel;
    Label8: TLabel;
    Rectangle4: TRectangle;
    LabelPedido: TLabel;
    Layout10: TLayout;
    LabelEmpresa: TLabel;
    procedure FormShow(Sender: TObject);
    procedure DateEditPeriodoChange(Sender: TObject);
    procedure ListViewPedidosItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure ImageNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageReloadClick(Sender: TObject);
    procedure LabelFecharMenuPrincipalClick(Sender: TObject);
    procedure ImageMenuClick(Sender: TObject);
    procedure LabelConfiguracaoClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Image4Click(Sender: TObject);
    procedure aniFundoMenuDeslizanteFinish(Sender: TObject);
    procedure aniFundoMenuPedidoFinish(Sender: TObject);
    procedure Rectangle7Click(Sender: TObject);
    procedure RectangleExcluiPedidoClick(Sender: TObject);
    procedure RectangleFinalizaPedidoClick(Sender: TObject);

  private
    FInicio,FMeusPedidos,FPedSequencial: boolean;
    FIdCliente,FIdCondicao: integer;
    function IncluiNovoPedido: boolean;
    procedure EscondeMenuPedido;
    procedure EscondeMenuPrincipal;
    procedure MostraMenuPedido;
    procedure MostraMenuPrincipal;
    procedure CarregaValoresPadrao;
    procedure CriaPedido;
    procedure Carrega;
    procedure DeletaPedido;
    procedure FinalizaPedido;
    function RetornaIdCobranca(XIdCondicao: integer): integer;
    { Private declarations }
  public
    Fprovider: TprvComuns;
    procedure CarregaMeusPedidos(XData: tdatetime);
    { Public declarations }
  end;

var
  F_MeusPedidos: TF_MeusPedidos;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses uPedido, uNovoPedido, uConfiguracao, Loading, uLogin;
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TF_MeusPedidos.DateEditPeriodoChange(Sender: TObject);
begin
  if not FInicio then
     Carrega;
//     CarregaMeusPedidos(DateEditPeriodo.Date);
end;

procedure TF_MeusPedidos.FormCreate(Sender: TObject);
begin
  FInicio := true;
end;

procedure TF_MeusPedidos.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key = vkHardwareBack then
     begin
       Image3.OnClick(Image3);
//       ImageReload.OnClick(ImageReload);
       key := 0;
     end;
end;

procedure TF_MeusPedidos.FormShow(Sender: TObject);
begin
  CarregaValoresPadrao;
  if prvComuns.PesquisaEmpresa(0) then
     LabelEmpresa.text := prvComuns.FDMemTableEmpresa.FieldByName('razaosocial').AsString;

  if FMeusPedidos then
     LabelTitulo.Text := 'Meus Pedidos'
  else
     LabelTitulo.Text := 'Pedidos';
  LayoutMenuPedido.Visible    := false;
  LayoutMenuPrincipal.Visible := false;
  DateEditPeriodo.Date        := date;
//  CarregaMeusPedidos(DateEditPeriodo.Date);
  Carrega;
  FInicio := false;
  RectangleMenuDeslizante.Height := F_MeusPedidos.Height;
  RectangleMenuPedido.Height     := F_MeusPedidos.Height;
end;

procedure TF_MeusPedidos.aniFundoMenuDeslizanteFinish(Sender: TObject);
begin
  if aniFundoMenuDeslizante.Inverse then
     LayoutMenuPrincipal.Visible := false;

end;

procedure TF_MeusPedidos.aniFundoMenuPedidoFinish(Sender: TObject);
begin
  if aniFundoMenuPedido.Inverse then
     LayoutMenuPedido.Visible := false;
end;

procedure TF_MeusPedidos.Carrega;
begin
  TLoading.Show(F_MeusPedidos,'Aguarde...Carregando meus pedidos');

  TThread.CreateAnonymousThread(procedure
                                begin
                                  TThread.Synchronize(nil, procedure
                                                           begin
                                                              CarregaMeusPedidos(DateEditPeriodo.Date);
                                                              TLoading.Hide;
                                                           end);
                                end).Start;
end;


procedure TF_MeusPedidos.Image3Click(Sender: TObject);
begin
  Carrega;
end;

procedure TF_MeusPedidos.Image4Click(Sender: TObject);
begin
  aniMenuDeslizante.Inverse := true;
  aniMenuDeslizante.Start;
  aniFundoMenuDeslizante.Inverse := true;
  aniFundoMenuDeslizante.Start;
//  LayoutMenuPrincipal.Visible := false;
end;

procedure TF_MeusPedidos.ImageMenuClick(Sender: TObject);
begin
  MostraMenuPrincipal;
end;

procedure TF_MeusPedidos.ImageNovoClick(Sender: TObject);
begin
  try
    EscondeMenuPrincipal;
    if DateEditPeriodo.Date <> date then
       begin
         showmessage('Atenção! Data inválida para inclusão');
         exit;
       end;

    CriaPedido;
  except

  end;
end;

procedure TF_MeusPedidos.CriaPedido;
begin
  TLoading.Show(F_MeusPedidos,'Aguarde...Criando pedido');
  TThread.CreateAnonymousThread(procedure
                                begin
                                  if IncluiNovoPedido then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             if not Assigned(F_NovoPedido) then
                                                                F_NovoPedido := TF_NovoPedido.Create(nil);
                                                             F_NovoPedido.LabelNumero.Text         := 'Pedido '+formatfloat('0000',Fprovider.FDMemTableNovoPedido.FieldByName('numero').AsInteger);
                                                             F_NovoPedido.LabelNumero.TagString    := Fprovider.FDMemTableNovoPedido.FieldByName('id').AsString;
                                                             if Fprovider.FDMemTableNovoPedido.FieldByName('total').IsNull then
                                                                F_NovoPedido.LabelValor.Text       := 'R$ 0,00'
                                                             else
                                                                F_NovoPedido.LabelValor.Text       := formatfloat('R$ #,0.00',Fprovider.FDMemTableNovoPedido.FieldByName('total').AsFloat);
                                                             F_NovoPedido.ImageNumeroItens.Visible := false;
                                                             F_NovoPedido.TabControl1.ActiveTab    := F_NovoPedido.TabItemIncluiItem;
                                                             F_NovoPedido.LabelTitulo.Text         := 'Inclui Ítem';

                                                             CarregaMeusPedidos(DateEditPeriodo.Date);

                                                             if Fprovider.FDMemTableMeusPedidos.Locate('id',F_NovoPedido.LabelNumero.TagString,[]) then
                                                                begin
 //                                                                 F_NovoPedido.CarregaListaItens;
                                                                  F_NovoPedido.Show;
                                                                  F_NovoPedido.ImageCesta.Visible := false;
                                                                end;
                                                             TLoading.Hide;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Problema na inclusão do pedido');
                                                           end);
                                     end;
                                end).Start;
end;

procedure TF_MeusPedidos.ImageReloadClick(Sender: TObject);
begin
//showmessage('voltar');
  if not Assigned(F_Login) then
     F_Login := TF_Login.Create(nil);

  Application.MainForm := F_Login;
  F_Login.Show;
//  Carrega;
//  CarregaMeusPedidos(DateEditPeriodo.Date);
end;

function TF_MeusPedidos.IncluiNovoPedido: boolean;
var wret: boolean;
    wpedido: TJSONObject;
    widcobranca: integer;
begin
  try
  // carrega padrões
    CarregaValoresPadrao;
    widcobranca := RetornaIdCobranca(FIdCondicao);

  // cria JSON do pedido
    wpedido := TJSONObject.Create;
    wpedido.AddPair('dataemissao',datetostr(date));
    wpedido.AddPair('idcliente',IntToStr(FIdCliente));
    wpedido.AddPair('idcondicao',IntToStr(FIdCondicao));
//    wpedido.AddPair('idvendedor',Application.Hint); // id do usuário
    wpedido.AddPair('idvendedor',F_MeusPedidos.TagString); // id do usuário
    wpedido.AddPair('idcobranca',IntToStr(widcobranca));

    if not Assigned(Fprovider) then
       Fprovider := TprvComuns.Create(nil);
    if Fprovider.NovoPedido(wpedido) then
       wret := true
    else
       wret := false;
  except
    On E: Exception do
    begin
      wret := false;
    end;
  end;
  Result := wret;
end;

procedure TF_MeusPedidos.RectangleExcluiPedidoClick(Sender: TObject);
begin
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
                                  end);
end;

procedure TF_MeusPedidos.RectangleFinalizaPedidoClick(Sender: TObject);
begin
   MessageDlg('Deseja finalizar pedido?', System.UITypes.TMsgDlgType.mtInformation,
                                 [System.UITypes.TMsgDlgBtn.mbYes,
                                  System.UITypes.TMsgDlgBtn.mbNo], 0,
                                  procedure(const AResult: System.UITypes.TModalResult)
                                  begin
                                    case AResult of
                                      mrYES: begin
                                                FinalizaPedido;
                                             end;
                                      mrNo:;
                                    end;
                                  end);
end;

procedure TF_MeusPedidos.Rectangle7Click(Sender: TObject);
begin
  EscondeMenuPedido;
end;

function TF_MeusPedidos.RetornaIdCobranca(XIdCondicao: integer): integer;
var wret: integer;
begin
  if F_MeusPedidos.Fprovider.PesquisaCondicao(XIdCondicao) then
     wret := F_MeusPedidos.Fprovider.FDMemTableCondicao.FieldByName('idcobranca').AsInteger
  else
     wret := 0;
  Result := wret;
end;

procedure TF_MeusPedidos.CarregaValoresPadrao;
begin
  prvComuns.AbreConexaoLocal;
  with prvComuns.FDQueryConfigura do
  begin
    DisableControls;
    Close;
    Open;
    EnableControls;
    FIdCliente     := prvComuns.FDQueryConfiguraidCliente.AsInteger;
    FIdCondicao    := prvComuns.FDQueryConfiguraidCondicao.AsInteger;
    FMeusPedidos   := prvComuns.FDQueryConfiguramostrarSomentePedidoVendedor.AsBoolean;
    FPedSequencial := prvComuns.FDQueryConfiguranumeracaoSequencial.AsBoolean;
    prvComuns.FTipoLeitor := prvComuns.FDQueryConfiguratipoLeitorCodBarra.AsString;
  end;
  prvComuns.FechaConexaoLocal;
end;

procedure TF_MeusPedidos.LabelFecharMenuPrincipalClick(Sender: TObject);
begin
  EscondeMenuPrincipal;
end;

procedure TF_MeusPedidos.LabelConfiguracaoClick(Sender: TObject);
begin
  try
    if Fprovider.AbreConexaoLocal then
       begin
         // abre tabela de configuração
         with prvComuns.FDQueryConfigura do
         begin
           DisableControls;
           Close;
           Open;
           EnableControls;
         end;
         if not Assigned(F_Configuracao) then
            F_Configuracao := TF_Configuracao.Create(nil);
         if prvComuns.FDQueryConfigura.RecordCount>0 then
            begin
              F_Configuracao.FAbre                         := false;
              F_Configuracao.EditClientePadrao.Text        := prvComuns.FDQueryConfiguranomeCliente.AsString;
              F_Configuracao.EditClientePadrao.TagString   := prvComuns.FDQueryConfiguraidCliente.AsString;
              F_Configuracao.EditCondicaoPadrao.Text       := prvComuns.FDQueryConfiguranomeCondicao.AsString;
              F_Configuracao.EditCondicaoPadrao.TagString  := prvComuns.FDQueryConfiguraidCondicao.AsString;
              F_Configuracao.EditIP.Text                   := prvComuns.FDQueryConfiguraipAPI.AsString;
              F_Configuracao.EditPorta.Text                := prvComuns.FDQueryConfiguraportaAPI.AsString;
              F_Configuracao.SwitchCodBarra.IsChecked      := prvComuns.FDQueryConfiguralerEtiquetaCodBarra.AsBoolean;
              F_Configuracao.SwitchPedVendedor.IsChecked   := prvComuns.FDQueryConfiguramostrarSomentePedidoVendedor.AsBoolean;
              F_Configuracao.RadioButtonBarcodeScanner.IsChecked := prvComuns.FDQueryConfiguratipoLeitorCodBarra.AsString='BarcodeScanner';
              F_Configuracao.RadioButtonCodeReader.IsChecked     := prvComuns.FDQueryConfiguratipoLeitorCodBarra.AsString='CodeReader';
            end;
         F_Configuracao.Show;
       end
    else
       showmessage('Problema ao abriar conexão local');
  finally
    EscondeMenuPrincipal;
  end;
end;

procedure TF_MeusPedidos.DeletaPedido;
begin
  TLoading.Show(F_MeusPedidos,'Aguarde...Excluindo pedido');

  TThread.CreateAnonymousThread(procedure
                                begin
                                  if Fprovider.ExcluiPedido(Fprovider.FDMemTableMeusPedidos.FieldByName('id').AsInteger) then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             CarregaMeusPedidos(DateEditPeriodo.Date);
                                                             EscondeMenuPedido;
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
end;

procedure TF_MeusPedidos.FinalizaPedido;
var wpedido: TJSONObject;
    widpedido: integer;
begin
  wpedido := TJSONObject.Create;
  wpedido.AddPair('finalizado','true');
  widpedido := Fprovider.FDMemTableMeusPedidos.FieldByName('id').AsInteger;

  TLoading.Show(F_MeusPedidos,'Aguarde...Finalizando pedido');

  TThread.CreateAnonymousThread(procedure
                                begin
                                  if Fprovider.AlteraPedido(widpedido,wpedido) then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             CarregaMeusPedidos(DateEditPeriodo.Date);
                                                             EscondeMenuPedido;
                                                             TLoading.Hide;
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

procedure TF_MeusPedidos.EscondeMenuPedido;
begin
  aniMenuPedido.Inverse := true;
  aniMenuPedido.Start;
  aniFundoMenuPedido.Inverse := true;
  aniFundoMenuPedido.Start;
end;

procedure TF_MeusPedidos.EscondeMenuPrincipal;
begin
  LayoutMenuPrincipal.Visible := false;
end;

procedure TF_MeusPedidos.MostraMenuPedido;
begin
  RectangleMenuPedido.Height  := F_MeusPedidos.Height;

  RectangleFinalizaPedido.Enabled := not Fprovider.FDMemTableMeusPedidos.FieldByName('finalizado').AsBoolean;
  RectangleFinalizaPedido.HitTest := not Fprovider.FDMemTableMeusPedidos.FieldByName('finalizado').AsBoolean;

  RectangleExcluiPedido.Enabled   := Fprovider.FDMemTableMeusPedidos.FieldByName('idnotagerada').IsNull;
  RectangleExcluiPedido.HitTest   := Fprovider.FDMemTableMeusPedidos.FieldByName('idnotagerada').IsNull;

  LayoutMenuPedido.Visible    := true;
  aniFundoMenuPedido.Inverse := false;
  aniFundoMenuPedido.Start;

  aniMenuPedido.Inverse       := false;
  aniMenuPedido.StartValue    := F_MeusPedidos.Width + RectangleMenuPedido.Width;
  aniMenuPedido.StopValue     := F_MeusPedidos.Width - RectangleMenuPedido.Width;
  aniMenuPedido.Start;

{  RectangleMenu.Width        := F_MeusPedidos.Width - 160;
  RectangleMenu.Position.X   := 80;
  RectangleMenu.Position.Y   := F_MeusPedidos.Height + 20;

  RectangleFundoMenu.Opacity := 0;
  RectangleFundoMenu.AnimateFloat('Opacity',0.4,0.2);

  RectangleMenu.AnimateFloat('Position.Y',
                             F_MeusPedidos.Height-350,
                             0.5,
                             TAnimationType.InOut,
                             TInterpolationType.Circular);

  LayoutMenuPedido.Visible := true;}
end;

procedure TF_MeusPedidos.MostraMenuPrincipal;
begin
  RectangleMenuDeslizante.Height := F_MeusPedidos.Height;

  LayoutMenuPrincipal.Visible    := true;
  aniFundoMenuDeslizante.Inverse := false;
  aniFundoMenuDeslizante.Start;

  aniMenuDeslizante.Inverse      := false;
  aniMenuDeslizante.Start;

{  RectangleMenuPrincipal.Width        := F_MeusPedidos.Width - 160;
  RectangleMenuPrincipal.Position.X   := 80;
  RectangleMenuPrincipal.Position.Y   := F_MeusPedidos.Height + 20;

  RectangleFundoMenuPrincipal.Opacity := 0;
  RectangleFundoMenuPrincipal.AnimateFloat('Opacity',0.4,0.2);

  RectangleMenuPrincipal.AnimateFloat('Position.Y',
                             F_MeusPedidos.Height-450,
                             0.5,
                             TAnimationType.InOut,
                             TInterpolationType.Circular);

  LayoutMenuPrincipal.Visible := true;}
end;

procedure TF_MeusPedidos.ListViewPedidosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var witemimage: TListItemImage;
begin
  if ItemObject = nil then
     exit;
  if TListView(Sender).Selected <> nil then
     try
       if ItemObject.Name = 'ImageDetalhe' then
          begin
            if Fprovider.FDMemTableMeusPedidos.Locate('id',ItemObject.TagString,[]) then
               begin
                 LabelPedido.Text := 'Pedido '+formatfloat('0000',Fprovider.FDMemTableMeusPedidos.FieldByName('numero').AsInteger);
                 MostraMenuPedido;
               end;
          end
       else if ItemObject.Name = 'ImageFundo' then
          begin
            Fprovider.FDMemTableMeusPedidos.Locate('id',ItemObject.TagString,[]);

            if not Assigned(F_NovoPedido) then
               F_NovoPedido := TF_NovoPedido.Create(nil);
            F_NovoPedido.LabelNumero.Text      := 'Pedido '+formatfloat('0000',Fprovider.FDMemTableMeusPedidos.FieldByName('numero').AsInteger);
            F_NovoPedido.LabelNumero.TagString := Fprovider.FDMemTableMeusPedidos.FieldByName('id').AsString;
            if Fprovider.FDMemTableMeusPedidos.FieldByName('total').IsNull then
               F_NovoPedido.LabelValor.Text    := 'R$ 0,00'
            else
               F_NovoPedido.LabelValor.Text    := formatfloat('R$ #,0.00',Fprovider.FDMemTableMeusPedidos.FieldByName('total').AsFloat);

            if Fprovider.FDMemTableMeusPedidos.FieldByName('finalizado').AsBoolean then
               F_NovoPedido.LabelValor.TagString := 'Finalizado'
            else
               F_NovoPedido.LabelValor.TagString := 'Pendente';

            F_NovoPedido.AtualizaNumeroItens(strtoint(Fprovider.FDMemTableMeusPedidos.FieldByName('id').AsString));
//            F_NovoPedido.TabControl1.ActiveTab := F_NovoPedido.TabItemIncluiItem;
//            F_NovoPedido.EditPesquisa.SetFocus;
            F_NovoPedido.TabControl1.ActiveTab := F_NovoPedido.TabItemFinalizaPedido;
            F_NovoPedido.EditCliente.Text       := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xcliente').AsString;
            F_NovoPedido.EditCliente.TagString  := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('idcliente').AsString;
            F_NovoPedido.EditCondicao.Text      := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('xcondicao').AsString;
            F_NovoPedido.EditCondicao.TagString := F_MeusPedidos.Fprovider.FDMemTableMeusPedidos.FieldByName('idcondicao').AsString;

// Caso pedido já importado
            F_NovoPedido.RoundRectIncluiItem.Visible     := Fprovider.FDMemTableMeusPedidos.FieldByName('idnotagerada').IsNull;
            F_NovoPedido.RoundRectFinalizaPedido.Visible := Fprovider.FDMemTableMeusPedidos.FieldByName('idnotagerada').IsNull;
            F_NovoPedido.ImageExclui.Visible             := Fprovider.FDMemTableMeusPedidos.FieldByName('idnotagerada').IsNull;
            F_NovoPedido.ImageExclui.TagString           := Fprovider.FDMemTableMeusPedidos.FieldByName('idnotagerada').AsString;
            F_NovoPedido.RoundRectCliente.Enabled        := Fprovider.FDMemTableMeusPedidos.FieldByName('idnotagerada').IsNull;
            F_NovoPedido.RoundRectCondicao.Enabled       := Fprovider.FDMemTableMeusPedidos.FieldByName('idnotagerada').IsNull;

            F_NovoPedido.CarregaListaItens;
            F_NovoPedido.Show;
            F_NovoPedido.TabControl1.ActiveTab       := F_NovoPedido.TabItemFinalizaPedido;
            F_NovoPedido.ImageFinalizaPedido.Visible := true;
            F_NovoPedido.ImageCesta.Visible          := false;
            F_NovoPedido.LabelTitulo.Text      := 'Finaliza Pedido';
            F_NovoPedido.EditPesquisa.Text     := '';

          end;
     except
       On E: Exception do
       begin
         showmessage('Erro ao carregar '+E.Message);
       end;
     end;
end;

procedure TF_MeusPedidos.CarregaMeusPedidos(XData: tdatetime);
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

      wimgpendente        := TMemoryStream.Create;
      ImagePedidoPendente.Bitmap.SaveToStream(wimgpendente);
      wimgbloqueado       := TMemoryStream.Create;
      ImagePedidoBloqueado.Bitmap.SaveToStream(wimgbloqueado);
      wimgliberado        := TMemoryStream.Create;
      ImagePedidoLiberado.Bitmap.SaveToStream(wimgliberado);
      wimgimportado       := TMemoryStream.Create;
      ImagePedidoImportado.Bitmap.SaveToStream(wimgimportado);


      wimgmore           := TMemoryStream.Create;
      Image2.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp  := TBitmap.Create;
      wbmp.LoadFromStream(wimgfundo);

      wbmppendente  := TBitmap.Create;
      wbmppendente.LoadFromStream(wimgpendente);
      wbmpbloqueado := TBitmap.Create;
      wbmpbloqueado.LoadFromStream(wimgbloqueado);
      wbmpliberado  := TBitmap.Create;
      wbmpliberado.LoadFromStream(wimgliberado);
      wbmpimportado  := TBitmap.Create;
      wbmpimportado.LoadFromStream(wimgimportado);

      wbmp2 := TBitmap.Create;
      wbmp2.LoadFromStream(wimgmore);

      ListViewPedidos.BeginUpdate;
      ListViewPedidos.Items.Clear;

//      LabelData.Text := formatdatetime('dd/mm/yyyy',date);

      if FMeusPedidos then
         wvendedor := F_MeusPedidos.ImageNovo.TagString // nome do vendedor
      else
         wvendedor := '';

      if Fprovider.CarregaMeusPedidos(XData, wvendedor) then
         begin
           Fprovider.FDMemTableMeusPedidos.Last;
           while not Fprovider.FDMemTableMeusPedidos.Bof do
           begin
             with ListViewPedidos.Items.Add do
             begin
                if Fprovider.FDMemTableMeusPedidos.FieldByName('finalizado').AsBoolean = false then // pedido não finalizado
                   TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap  := wbmppendente
                else if Fprovider.FDMemTableMeusPedidos.FieldByName('bloqueado').AsBoolean = true then // pedido bloqueado
                   TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap  := wbmpbloqueado
                else if Fprovider.FDMemTableMeusPedidos.FieldByName('idnotagerada').IsNull then // pedido liberado
                   TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap  := wbmpliberado
                else
                   TListItemImage(Objects.FindDrawable('ImageFundo')).Bitmap  := wbmpimportado;
                TListItemImage(Objects.FindDrawable('ImageFundo')).TagString  := Fprovider.FDMemTableMeusPedidos.FieldByName('id').AsString;

                TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap     := wbmp2;
                TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString  := Fprovider.FDMemTableMeusPedidos.FieldByName('id').AsString;

                TListItemText(Objects.FindDrawable('TextNumero')).Text        := formatfloat('0000',Fprovider.FDMemTableMeusPedidos.FieldByName('numero').AsInteger);
                if not Fprovider.FDMemTableMeusPedidos.FieldByName('finalizado').AsBoolean then
                   TListItemText(Objects.FindDrawable('TextNumero')).TextColor   := StringToAlphaColor('black')
                else
                   TListItemText(Objects.FindDrawable('TextNumero')).TextColor   := StringToAlphaColor('white');

                TListItemText(Objects.FindDrawable('TextCliente')).Text       := Fprovider.FDMemTableMeusPedidos.FieldByName('xcliente').AsString;
  //              TListItemText(Objects.FindDrawable('TextCliente')).TextColor  := StringToAlphaColor('#00EBE7E7');

                TListItemText(Objects.FindDrawable('TextCondicao')).Text      := Fprovider.FDMemTableMeusPedidos.FieldByName('xcondicao').AsString;
                TListItemText(Objects.FindDrawable('TextVendedor')).Text      := Fprovider.FDMemTableMeusPedidos.FieldByName('xvendedor').AsString;


                if Fprovider.FDMemTableMeusPedidos.FieldByName('total').IsNull then
                   TListItemText(Objects.FindDrawable('TextValor')).Text         := 'R$ 0,00'
                else
                   TListItemText(Objects.FindDrawable('TextValor')).Text         := formatfloat('R$ #,0.00',Fprovider.FDMemTableMeusPedidos.FieldByName('total').AsFloat);
             end;
             inc(wqtdetotal);
             if not Fprovider.FDMemTableMeusPedidos.FieldByName('total').IsNull then
                wvalortotal := wvalortotal + Fprovider.FDMemTableMeusPedidos.FieldByName('total').AsFloat;
             Fprovider.FDMemTableMeusPedidos.Prior;
           end;
         end;
    finally
      ListViewPedidos.EndUpdate;
      if wqtdetotal > 1 then
         LabelQtde.Text  := formatfloat('#0 Pedidos',wqtdetotal)
      else
         LabelQtde.Text  := formatfloat('#0 Pedido',wqtdetotal);
      LabelValor.Text := FormatFloat('R$ #,0.00',wvalortotal);
      Fprovider.FDMemTableMeusPedidos.First;
    end;
  except
    On E: Exception do
    begin
      showmessage(E.Message);
    end;
  end;
  //
end;

end.

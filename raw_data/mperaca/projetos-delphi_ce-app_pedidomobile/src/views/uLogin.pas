unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, pComuns;

type
  TF_Login = class(TForm)
    RectangleFundo: TRectangle;
    LayoutTopo: TLayout;
    LayoutBottom: TLayout;
    LayoutClient: TLayout;
    EditUsuario: TEdit;
    LabelAcessar: TLabel;
    LayoutAcessar: TLayout;
    Image1: TImage;
    LayoutUsuario: TLayout;
    LayoutSenha: TLayout;
    EditSenha: TEdit;
    StyleBook1: TStyleBook;
    RoundRectUsuario: TRoundRect;
    RoundRectSenha: TRoundRect;
    RoundRectAcessar: TRoundRect;
    Image3: TImage;
    Image2: TImage;
    Image4: TImage;
    TabControlLogin: TTabControl;
    TabItemLogin: TTabItem;
    TabItemVendedores: TTabItem;
    LayoutTopo1: TLayout;
    Rectangle1: TRectangle;
    Image5: TImage;
    Label2: TLabel;
    LayoutBottom3: TLayout;
    Rectangle3: TRectangle;
    LabelTotalClientes: TLabel;
    LayoutCliente1: TLayout;
    ListViewVendedor: TListView;
    ImageDetalhe: TImage;
    Rectangle2: TRectangle;
    Layout1: TLayout;
    RoundRect1: TRoundRect;
    Label1: TLabel;
    LabelPrimeiroAcesso: TLabel;
    Label3: TLabel;
    Line1: TLine;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RoundRectAcessarClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure ListViewVendedorItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure FormActivate(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure EditUsuarioKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure RoundRectSairClick(Sender: TObject);
    procedure RoundRect1Click(Sender: TObject);
    procedure LabelPrimeiroAcessoClick(Sender: TObject);
    procedure EditSenhaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    Fprovider: TprvComuns;
    FAbre: boolean;
    procedure AcionaPesquisaVendedor(XVendedor: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Login: TF_Login;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses  uMeusPedidos, Loading, uConfiguracao;

{$R *.NmXhdpiPh.fmx ANDROID}

procedure TF_Login.EditSenhaKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (key = vkReturn) and (length(trim(EditSenha.Text))>0) then
     RoundRectAcessar.OnClick(RoundRectAcessar);
end;

procedure TF_Login.EditUsuarioKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (key = vkReturn) and (length(trim(EditUsuario.Text))>0) then
     AcionaPesquisaVendedor(EditUsuario.Text);
end;

procedure TF_Login.FormActivate(Sender: TObject);
begin
  FAbre := true;
end;

procedure TF_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  F_Login := nil;
  Action  := TCloseAction.caFree;
end;

procedure TF_Login.Image2Click(Sender: TObject);
begin
  EditUsuario.Text := '';
  EditUsuario.SetFocus;
end;

procedure TF_Login.Image3Click(Sender: TObject);
begin
  AcionaPesquisaVendedor(EditUsuario.Text);
end;

procedure TF_Login.Image4Click(Sender: TObject);
begin
  EditSenha.Text := '';
  EditSenha.SetFocus;
end;

procedure TF_Login.Image5Click(Sender: TObject);
begin
  TabControlLogin.ActiveTab := TabItemLogin;
//  EditUsuario.Text := Fprovider.FDMemTableVendedores.FieldByName('nome').AsString;
//  EditUsuario.
end;

procedure TF_Login.LabelPrimeiroAcessoClick(Sender: TObject);
begin
  if not Assigned(F_Configuracao) then
     F_Configuracao := TF_Configuracao.Create(nil);
  F_Configuracao.LabelTitulo.Text := 'Configuração - Primeiro Acesso';
  F_Configuracao.ImageVoltar.Visible := false;
  F_Configuracao.FAbre                        := false;
  F_Configuracao.EditClientePadrao.Text       := '';
  F_Configuracao.EditClientePadrao.TagString  := '';
  F_Configuracao.EditCondicaoPadrao.Text      := '';
  F_Configuracao.EditCondicaoPadrao.TagString := '';
  F_Configuracao.EditIP.Text                  := '';
  F_Configuracao.EditPorta.Text               := '';
  F_Configuracao.LayoutClientePadrao.Visible  := false;
  F_Configuracao.SwitchCodBarra.IsChecked     := false;
  F_Configuracao.SwitchPedVendedor.IsChecked  := false;
  F_Configuracao.RadioButtonBarcodeScanner.IsChecked := true;
  F_Configuracao.RadioButtonCodeReader.IsChecked     := false;
//  F_Configuracao.RadioButtonBarcodeScanner.Checked
  F_Configuracao.Show;
end;

procedure TF_Login.ListViewVendedorItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
     exit;
  if TListView(Sender).Selected <> nil then
     begin
       if ItemObject.Name = 'ImageDetalhe' then
          begin
            if Fprovider.FDMemTableVendedores.Locate('id',ItemObject.TagString,[]) then
               begin
                 FAbre                        := false;
                 EditUsuario.Text             := Fprovider.FDMemTableVendedores.FieldByName('nome').AsString;
                 EditUsuario.TagString        := Fprovider.FDMemTableVendedores.FieldByName('id').AsString;
                 EditSenha.TagString          := Fprovider.FDMemTableVendedores.FieldByName('senha').AsString;
                 FAbre                        := true;
                 EditSenha.SetFocus;
               end;
            TabControlLogin.ActiveTab  := TabItemLogin;
          end;
     end;
end;

procedure TF_Login.RoundRect1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TF_Login.RoundRectAcessarClick(Sender: TObject);
var wcarregado: boolean;
begin
  if (length(trim(EditUsuario.Text))=0) or (length(trim(EditSenha.Text))=0) then
     begin
       ShowMessage('Usuário e/ou senha inválido!');
       exit;
     end;

  if not prvComuns.ValidaAcesso(strtoint(EditUsuario.TagString),EditUsuario.Text,EditSenha.Text,EditSenha.TagString) then
     ShowMessage('Usuário e/ou senha inválido!')
  else
     begin
       if Assigned(F_MeusPedidos) then
          begin
            wcarregado                             := F_MeusPedidos.ListViewPedidos.Items.Count>0;
            Application.Hint                       := EditUsuario.TagString;
            Application.MainForm                   := F_MeusPedidos;
            F_MeusPedidos.TagString                := EditUsuario.TagString;
            F_MeusPedidos.ImageNovo.TagString      := EditUsuario.Text;
            F_MeusPedidos.LabelVendedorLogado.Text := EditUsuario.Text;
            F_MeusPedidos.label8.Text              := EditUsuario.Text;
            F_MeusPedidos.Show;
            if wcarregado then
               F_MeusPedidos.OnShow(F_MeusPedidos);
            F_Login.Close;
          end;
     end;
end;

procedure TF_Login.RoundRectSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TF_Login.AcionaPesquisaVendedor(XVendedor: string);
var wimgmore: TMemoryStream;
    wbmp: TBitmap;
begin
  try
      Fprovider := TprvComuns.Create(nil);

      ListViewVendedor.BeginUpdate;
      ListViewVendedor.items.Clear;

      wimgmore          := TMemoryStream.Create;
      ImageDetalhe.Bitmap.SaveToStream(wimgmore);
      wimgmore.Position := 0;

      wbmp   := TBitmap.Create;
      wbmp.LoadFromStream(wimgmore);

      TLoading.Show(F_Login,'Aguarde...Carregando lista de vendedores');

      TThread.CreateAnonymousThread(procedure
                                begin
                                  if Fprovider.CarregaVendedores(XVendedor) then
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             while not Fprovider.FDMemTableVendedores.Eof do
                                                             begin
                                                               with ListViewVendedor.Items.Add do
                                                               begin
                                                                  TListItemImage(Objects.FindDrawable('ImageDetalhe')).Bitmap    := wbmp;
                                                                  TListItemImage(Objects.FindDrawable('ImageDetalhe')).TagString := Fprovider.FDMemTableVendedores.FieldByName('id').AsString;

                                                                  TListItemText(Objects.FindDrawable('TextNome')).Text      := Fprovider.FDMemTableVendedores.FieldByName('nome').AsString;
                                                                  TListItemText(Objects.FindDrawable('TextCodigo')).Text    := Fprovider.FDMemTableVendedores.FieldByName('codigo').AsString;
                                                                  TListItemText(Objects.FindDrawable('TextDocumento')).Text := Fprovider.FDMemTableVendedores.FieldByName('cpf').AsString;
                                                               end;
                                                               Fprovider.FDMemTableVendedores.Next;
                                                             end;

                                                             LabelTotalClientes.Text      := formatfloat('00000 Vendedores',Fprovider.FDMemTableVendedores.RecordCount);
                                                             ListViewVendedor.EndUpdate;
                                                             if Fprovider.FDMemTableVendedores.RecordCount=1 then
                                                                begin
                                                                  EditUsuario.BeginUpdate;
                                                                  FAbre                 := false;
                                                                  EditUsuario.Text      := Fprovider.FDMemTableVendedores.FieldByName('nome').AsString;
                                                                  EditUsuario.TagString := Fprovider.FDMemTableVendedores.FieldByName('id').AsString;
                                                                  EditSenha.TagString   := Fprovider.FDMemTableVendedores.FieldByName('senha').AsString;
                                                                  FAbre                 := true;
                                                                  EditUsuario.EndUpdate;
                                                                  EditSenha.SetFocus;
                                                                end
                                                             else if Fprovider.FDMemTableVendedores.RecordCount>0 then
                                                                TabControlLogin.ActiveTab := TabItemVendedores;
                                                             TLoading.Hide;
                                                           end);
                                     end
                                   else
                                     begin
                                       TThread.Synchronize(nil, procedure
                                                           begin
                                                             TLoading.Hide;
                                                             showmessage('Nenhum vendedor localizado');
                                                           end);
                                     end;
                                end).Start;

  except
  end;
end;


end.

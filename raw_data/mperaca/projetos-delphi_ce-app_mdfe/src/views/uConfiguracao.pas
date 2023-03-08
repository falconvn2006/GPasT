unit uConfiguracao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Math, System.StrUtils,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.DateTimeCtrls;

type
  TF_Configuracao = class(TForm)
    LayoutTopo: TLayout;
    RectangleTopo: TRectangle;
    ImageVoltar: TImage;
    LabelTitulo: TLabel;
    LayoutBottom: TLayout;
    RectangleBottom: TRectangle;
    LayoutCliente: TLayout;
    ImageSalva: TImage;
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
    LayoutClienteGeral: TLayout;
    Label5: TLabel;
    Line2: TLine;
    Label1: TLabel;
    RoundRect3: TRoundRect;
    Image2: TImage;
    DateEditDataInicial: TDateEdit;
    procedure ImageVoltarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ImageSalvaClick(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    function SalvaConfiguracao: boolean;
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

uses pComuns, Loading, uPrincipal2;

procedure TF_Configuracao.FormActivate(Sender: TObject);
begin
  FAbre := true;
end;

procedure TF_Configuracao.Image2Click(Sender: TObject);
begin
  DateEditDataInicial.Text := '';
  DateEditDataInicial.SetFocus;
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
//                                                             if Assigned(F_MeusPedidos) then
//                                                                begin
//                                                                  F_MeusPedidos.Show;
//                                                                  F_MeusPedidos.OnShow(F_MeusPedidos);
//                                                                end;
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
     Application.Terminate
  else
     begin
       F_Principal2.TabControlPrincipal.TabIndex := 0;
       Close;
     end;
//  SalvaConfiguracao;
end;

procedure TF_Configuracao.ImageVoltarClick(Sender: TObject);
begin
  F_Principal2.TabControlPrincipal.TabIndex := 0;
  Close;
//  if TabControlConfiguracao.TabIndex=0 then
//     begin
//       if Assigned(F_MeusPedidos) then
//          F_MeusPedidos.Show;
//     end
//  else
//    TabControlConfiguracao.ActiveTab := TabItemConfiguracao;
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

//    showmessage(prvComuns.FDQueryConfiguraipAPI.AsString+' '+prvComuns.FDQueryConfiguraportaAPI.AsString);

    prvComuns.FDQueryConfigura.Edit;
    prvComuns.FDQueryConfiguraipAPI.AsString         := EditIP.Text;
    prvComuns.FDQueryConfiguraportaAPI.AsString      := EditPorta.Text;
    prvComuns.FDQueryConfiguradataInicial.AsDateTime := DateEditDataInicial.Date;
    prvComuns.FDQueryConfigura.Post;
    wret := true;
//    showmessage('salvou');
  except
    On E: Exception do
    begin
      wret := false;
//      showmessage('Erro: '+E.Message);
//      showmessage('Problema ao salvar configuração'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

end.

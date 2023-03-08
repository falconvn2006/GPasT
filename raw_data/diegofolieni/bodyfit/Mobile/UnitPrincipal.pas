unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListBox,
  uLoading, uSession, System.DateUtils;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    lblNome: TLabel;
    ImgPerfil: TImage;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    lblQtdTreino: TLabel;
    rectFundoTreino: TRectangle;
    rectBarraTreino: TRectangle;
    Layout3: TLayout;
    Label4: TLabel;
    Image2: TImage;
    Rectangle4: TRectangle;
    lblPontos: TLabel;
    rectFundoPontos: TRectangle;
    rectBarraPontos: TRectangle;
    Layout4: TLayout;
    Label6: TLabel;
    Image3: TImage;
    Label7: TLabel;
    rectSugestao: TRectangle;
    lblSugestao: TLabel;
    ImgSugestao: TImage;
    Label9: TLabel;
    LbTreinos: TListBox;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure LbTreinosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure ImgPerfilClick(Sender: TObject);
    procedure rectSugestaoClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    procedure CarregarTreinos;
    procedure SincronizarTreinos;
    procedure AddTreino(idTreino: Integer; titulo, subTitulo: string);
    procedure ThreadSincronizarTerminate(Sender: TObject);
    procedure MontarDashBoard;
    procedure MontarBarraProgresso;
    procedure MontarTreinoSugerido;
    procedure DetalhesTreino(IdTreino: Integer; NomeTreino: String);
    procedure ThreadDashboardTerminate(Sender: TObject);

  public

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Frame.Treino, UnitTreinoDetalhe, UnitPerfil, DataModule.Global;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  lblNome.Text := TSession.NOME;
  SincronizarTreinos;
end;

procedure TFrmPrincipal.Image1Click(Sender: TObject);
begin
  MontarDashBoard;
end;

procedure TFrmPrincipal.ImgPerfilClick(Sender: TObject);
begin
  if not(Assigned(FrmPerfil))then
    Application.CreateForm(TFrmPerfil, FrmPerfil);
  FrmPerfil.Show;
end;

procedure TFrmPrincipal.LbTreinosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  DetalhesTreino(Item.Tag, Item.TagString);
end;

procedure TFrmPrincipal.MontarBarraProgresso;
var
  porc: double;
begin
  porc := lblQtdTreino.Text.ToInteger / DaysInMonth(now);
  rectBarraTreino.Width := rectFundoTreino.Width * porc;

  porc := lblPontos.Text.ToInteger / 1000;
  rectBarraPontos.Width := rectFundoPontos.Width * porc;
end;

procedure TFrmPrincipal.MontarDashBoard;
var
  T: TThread;
begin
  TLoading.Show(FrmPrincipal, '');

  T := TThread.CreateAnonymousThread(procedure
  var
    qtd_treino, pontos: integer;
  begin
    qtd_treino := dmGlobal.TreinosMes(now);
    pontos := dmGlobal.Pontuacao();
    dmglobal.TreinoSugerido(now);

    TThread.Synchronize(TThread.CurrentThread, procedure
    begin
      lblQtdTreino.Text := qtd_treino.ToString;
      lblPontos.Text := pontos.ToString;

      MontarBarraProgresso;
      MontarTreinoSugerido;
    end);
  end);

  T.OnTerminate := ThreadDashboardTerminate;
  T.Start;

end;

procedure TFrmPrincipal.MontarTreinoSugerido;
begin
  if(dmGlobal.qryConsEstatistica.RecordCount = 0)then
  begin
    lblSugestao.Text := 'Nenhuma sugestão';
    ImgSugestao.Visible := False;
    rectSugestao.Tag := 0;
  end else
  begin
    lblSugestao.Text := dmGlobal.qryConsEstatistica.FieldByName('descr_treino').AsString;
    ImgSugestao.Visible := True;
    rectSugestao.Tag := dmGlobal.qryConsEstatistica.FieldByName('id_treino').AsInteger;
  end;
end;

procedure TFrmPrincipal.rectSugestaoClick(Sender: TObject);
begin
  if(rectSugestao.Tag > 0)then
    DetalhesTreino(rectSugestao.Tag, lblSugestao.Text);
end;

procedure TFrmPrincipal.ThreadDashboardTerminate(Sender: TObject);
begin
  TLoading.Hide;
  CarregarTreinos;
end;

procedure TFrmPrincipal.ThreadSincronizarTerminate(Sender: TObject);
begin
  TLoading.Hide;

  MontarDashboard;
end;

procedure TFrmPrincipal.SincronizarTreinos;
var
  T: TThread;
begin
  TLoading.Show(FrmPrincipal, '');

  T := TThread.CreateAnonymousThread(procedure
  begin
    dmGlobal.ListarTreinoExercicioOnline(TSession.ID_USUARIO);

    with dmGlobal.TabTreino do
    begin
      if(RecordCount > 0)then
        dmGlobal.ExcluirTreinoExercicio;

      while not(EoF)do
      begin
        dmGlobal.InserirTreinoExercicio(FieldByName('id_treino').AsInteger,
                                        FieldByName('treino').AsString,
                                        FieldByName('descr_treino').AsString,
                                        FieldByName('dia_semana').AsInteger,
                                        FieldByName('id_exercicio').AsInteger,
                                        FieldByName('exercicio').AsString,
                                        FieldByName('descr_exercicio').AsString,
                                        FieldByName('duracao').AsString,
                                        FieldByName('url_video').AsString);
        Next;
      end;
    end;

  end);
  T.OnTerminate := ThreadSincronizarTerminate;
  T.Start;
end;

procedure TFrmPrincipal.CarregarTreinos;
begin
  LbTreinos.Items.Clear;
  dmGlobal.ListarTreinos;

  with dmGlobal.qryConsTreino do
  begin
    while not EoF do
    begin
      AddTreino(FieldByName('id_treino'   ).AsInteger,
                FieldByName('treino'      ).AsString,
                FieldByName('descr_treino').AsString);
      Next;
    end;
  end;
end;

procedure TFrmPrincipal.DetalhesTreino(IdTreino: Integer; NomeTreino: String);
begin
  if not(Assigned(FrmTreinoDetalhe))then
    Application.CreateForm(TFrmTreinoDetalhe, FrmTreinoDetalhe);

  FrmTreinoDetalhe.IdTreino   := IdTreino;
  FrmTreinoDetalhe.NomeTreino := NomeTreino;
  FrmTreinoDetalhe.Show;
end;

procedure TFrmPrincipal.AddTreino(idTreino: Integer; titulo, subTitulo: string);
var
  item: TListBoxItem;
  frame: TFrameTreino;
begin
  item := TListBoxItem.Create(LbTreinos);
  item.Selectable := false;
  item.Text := '';
  item.Height := 90;
  item.Tag := idTreino;
  item.TagString := subTitulo;

  frame := TFrameTreino.Create(item);
  frame.lblTitulo.Text := titulo;
  frame.lblSubtitulo.Text := subTitulo;

  item.AddObject(frame);

  LbTreinos.AddObject(item);
end;

end.

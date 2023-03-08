unit UnitTreinoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Ani;

type
  TFrmTreinoCad = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    Layout1: TLayout;
    lblProgresso: TLabel;
    rectFundoBarra: TRectangle;
    rectBarra: TRectangle;
    recBtnLogin: TRectangle;
    BtnConcluir: TSpeedButton;
    LbExercicios: TListBox;
    procedure imgFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LbExerciciosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure BtnConcluirClick(Sender: TObject);
  private
    FIdTreino: Integer;
    procedure CarregarExercicios;
    procedure AddExercicio(idExercicio: Integer; descricao, series: string; concluido: boolean);
    function StringToBoolean(Str: string): Boolean;
  public
    procedure CalcularProgresso;
    property IdTreino: Integer read FIdTreino write FIdTreino;
  end;

var
  FrmTreinoCad: TFrmTreinoCad;

implementation

{$R *.fmx}

uses Frame.FichaExercicio, UnitExercicio, DataModule.Global, UnitTreinoDetalhe;

{ TFrmTreinoCad }

procedure TFrmTreinoCad.AddExercicio(idExercicio: Integer; descricao, series: string; concluido: boolean);
var
  item: TListBoxItem;
  frame: TFrameFichaExercicio;
begin
  item := TListBoxItem.Create(LbExercicios);
  item.Selectable := False;
  item.Text := '';
  item.Width := Trunc(LbExercicios.Width * 0.85);
  item.Tag := idExercicio;

  frame := TFrameFichaExercicio.Create(item);
  frame.lblTitulo.Text := descricao;
  frame.lblSubtitulo.Text := series;
  frame.ChkIndConcluido.IsChecked := concluido;
  frame.ChkIndConcluido.Tag := idExercicio;

  item.AddObject(frame);

  LbExercicios.AddObject(item);

end;

procedure TFrmTreinoCad.BtnConcluirClick(Sender: TObject);
begin
  dmGlobal.FinalizarTreino(IdTreino);

  FrmTreinoDetalhe.Close;
  Close;
end;

procedure TFrmTreinoCad.CalcularProgresso;
var
  frame: TFrameFichaExercicio;
  i, qtd_concluido: integer;
begin
  qtd_concluido := 0;

  for i:=0 to LbExercicios.Items.Count - 1 do
  begin
    frame := lbExercicios.ItemByIndex(i).Components[0] as TFrameFichaExercicio;

    if(frame.ChkIndConcluido.IsChecked)then
      Inc(qtd_concluido);
  end;

  lblProgresso.Text := qtd_concluido.ToString + ' de ' + LbExercicios.Items.Count.ToString + ' concluídos';

  //Barras...
 // rectBarra.Width := (qtd_concluido / lbExercicios.Items.Count) * rectFundoBarra.Width;

  TAnimator.AnimateFloat(rectBarra, 'Width', (qtd_concluido / lbExercicios.Items.Count) * rectFundoBarra.Width,
                         0.5,
                         TAnimationType.&Out,
                         TInterpolationType.Circular);
end;

procedure TFrmTreinoCad.CarregarExercicios;
begin
  LbExercicios.Items.Clear;
  dmGlobal.ListarExerciciosAtividade;

  with dmGlobal.qryConsExercicio do
  begin
    while not(EoF)do
    begin
      AddExercicio(FieldByName('id_exercicio').AsInteger,
                   FieldByName('exercicio'   ).AsString,
                   FieldByName('duracao'     ).AsString,
                   StringToBoolean(FieldByName('ind_concluido').AsString));
      Next;
    end;
  end;
  CalcularProgresso;
end;

procedure TFrmTreinoCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmTreinoCad := nil;
end;

procedure TFrmTreinoCad.FormShow(Sender: TObject);
begin
  rectBarra.Width := 0;
  CarregarExercicios;
end;

procedure TFrmTreinoCad.imgFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTreinoCad.LbExerciciosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if not(Assigned(FrmExercicio))then
    Application.CreateForm(TFrmExercicio, FrmExercicio);

  FrmExercicio.IdExercicio := Item.Tag;
  FrmExercicio.Show;
end;

function TFrmTreinoCad.StringToBoolean(Str: string): Boolean;
begin
  if(Str = 'S')then
    Result := True
  else
    Result := False;
end;

end.

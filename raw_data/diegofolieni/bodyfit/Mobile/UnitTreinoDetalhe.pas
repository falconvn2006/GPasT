unit UnitTreinoDetalhe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListBox;

type
  TFrmTreinoDetalhe = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    Label7: TLabel;
    LbExercicios: TListBox;
    recBtnLogin: TRectangle;
    BtnIniciar: TSpeedButton;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure LbExerciciosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure BtnIniciarClick(Sender: TObject);
  private
    FIdTreino: Integer;
    FNomeTreino: String;
    procedure AddExercicio(idExercicio: Integer; titulo, subTitulo: string);
    procedure CarregarExercicios;
    procedure SetNomeTreino(const Value: String);
  public
    property IdTreino: Integer read FIdTreino write FIdTreino;
    property NomeTreino: String read FNomeTreino write SetNomeTreino;
  end;

var
  FrmTreinoDetalhe: TFrmTreinoDetalhe;

implementation

{$R *.fmx}

uses Frame.Treino, UnitTreinoCad, UnitExercicio, DataModule.Global;

procedure TFrmTreinoDetalhe.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmTreinoDetalhe := nil;
end;

procedure TFrmTreinoDetalhe.FormShow(Sender: TObject);
begin
  CarregarExercicios;
end;

procedure TFrmTreinoDetalhe.imgFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTreinoDetalhe.LbExerciciosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if not(Assigned(FrmExercicio))then
    Application.CreateForm(TFrmExercicio, FrmExercicio);

  FrmExercicio.IdExercicio := Item.Tag;
  FrmExercicio.Show;
end;

procedure TFrmTreinoDetalhe.SetNomeTreino(const Value: String);
begin
  FNomeTreino := Value;
  lblTitulo.Text := Value;
end;

procedure TFrmTreinoDetalhe.BtnIniciarClick(Sender: TObject);
begin
  try
    dmGlobal.IniciarTreino(IdTreino);

    if not(Assigned(FrmTreinoCad)) then
      Application.CreateForm(TFrmTreinoCad, FrmTreinoCad);

    FrmTreinoCad.IdTreino := IdTreino;
    FrmTreinoCad.Show;
  except
    on E:Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFrmTreinoDetalhe.CarregarExercicios;
begin
  LbExercicios.Items.Clear;
  dmGlobal.ListarExercicios(IdTreino);

  with dmGlobal.qryConsExercicio do
  begin
    while not(EoF)do
    begin
      AddExercicio(FieldByName('id_exercicio').AsInteger,
                   FieldByName('exercicio').AsString,
                   FieldByName('duracao').AsString);
      Next;
    end;
  end;
end;

procedure TFrmTreinoDetalhe.AddExercicio(idExercicio: Integer; titulo, subTitulo: string);
var
  item: TListBoxItem;
  frame: TFrameTreino;
begin
  item := TListBoxItem.Create(LbExercicios);
  item.Selectable := false;
  item.Text := '';
  item.Height := 90;
  item.Tag := idExercicio;

  frame := TFrameTreino.Create(item);
  frame.lblTitulo.Text := titulo;
  frame.lblSubtitulo.Text := subTitulo;

  item.AddObject(frame);

  LbExercicios.AddObject(item);
end;

end.

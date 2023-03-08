unit Frame.FichaExercicio;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TFrameFichaExercicio = class(TFrame)
    rectSugestao: TRectangle;
    lblTitulo: TLabel;
    Image4: TImage;
    lblSubtitulo: TLabel;
    Rectangle1: TRectangle;
    ChkIndConcluido: TCheckBox;
    procedure ChkIndConcluidoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses DataModule.Global, UnitTreinoCad;

procedure TFrameFichaExercicio.ChkIndConcluidoChange(Sender: TObject);
begin
  dmGlobal.MarcarExercicioConcluido(ChkIndConcluido.Tag, ChkIndConcluido.IsChecked);

  //Calcular Progresso...
  FrmTreinoCad.CalcularProgresso;
end;

end.

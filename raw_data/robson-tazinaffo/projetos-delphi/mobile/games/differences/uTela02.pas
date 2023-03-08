unit uTela02;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, System.Actions,
  FMX.ActnList;

type
  TF_Tela02 = class(TForm)
    lytBase: TLayout;
    Image1: TImage;
    Timer1: TTimer;
    lblPontos: TLabel;
    lblTempo: TLabel;
    ActionList1: TActionList;
    actSair: TAction;
    lyt01: TLayout;
    lyt02: TLayout;
    lyt03: TLayout;
    lyt04: TLayout;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lyt01Click(Sender: TObject);
  private
    { Private declarations }
    pontoIni: integer;
    procedure CalcularAcerto(ponto: integer);
  public
    { Public declarations }
  end;

var
  F_Tela02: TF_Tela02;

implementation

{$R *.fmx}

procedure TF_Tela02.CalcularAcerto(ponto: integer);
begin
    pontoIni := pontoIni + 1;
    lblPontos.Text := pontoIni.ToString;

end;


procedure TF_Tela02.FormCreate(Sender: TObject);
begin
    pontoIni := 0;
    Timer1.Enabled := true;

end;

procedure TF_Tela02.lyt01Click(Sender: TObject);
begin
    CalcularAcerto(lyt01.Tag);

end;

procedure TF_Tela02.Timer1Timer(Sender: TObject);
begin
    lblTempo.Text := TimeToStr(now());

end;

end.

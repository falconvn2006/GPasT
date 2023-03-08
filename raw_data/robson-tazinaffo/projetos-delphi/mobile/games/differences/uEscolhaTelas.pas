unit uEscolhaTelas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TF_EscolhaTelas = class(TForm)
    lytBackground: TLayout;
    rectInicio: TRectangle;
    Label1: TLabel;
    lytBotao: TLayout;
    lytImagens: TLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    lytHeader: TLayout;
    Image8: TImage;
    procedure Image1Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_EscolhaTelas: TF_EscolhaTelas;

implementation

{$R *.fmx}

uses uInicial, uTelaJogo01;

procedure TF_EscolhaTelas.Image1Click(Sender: TObject);
begin
    try
        F_TelaJogo := TF_TelaJogo.Create(self);
        F_TelaJogo.Show;
    finally
//        F_TelaJogo.DisposeOf;
    end;

end;

procedure TF_EscolhaTelas.Image8Click(Sender: TObject);
begin
    close;
end;

end.

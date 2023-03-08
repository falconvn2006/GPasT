{ ******************************************************************************
  Title: View Background
  Description: Tela de fundo para efeito

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add
  **************************************************************************** }
unit initialPascal.View.Background;

{$mode objfpc}{$H+}

interface

uses
  Forms;

type

  { TFViewBackground }

  TFViewBackground = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FViewBackground: TFViewBackground;

implementation

{$R *.lfm}

{ TFViewBackground }

procedure TFViewBackground.FormCreate(Sender: TObject);
begin
  Self.WindowState := TWindowState.wsMaximized;
end;

end.


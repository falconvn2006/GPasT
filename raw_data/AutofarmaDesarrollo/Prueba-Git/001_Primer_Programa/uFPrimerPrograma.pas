unit uFPrimerPrograma;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFPrimerPrograma = class(TForm)
    lblSaludar: TLabel;
    btnSaludar: TButton;
    procedure btnSaludarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrimerPrograma: TFPrimerPrograma;

implementation

{$R *.dfm}

procedure TFPrimerPrograma.btnSaludarClick(Sender: TObject);
begin
  lblSaludar.Caption := 'Hola, bienvenido al primer programa de Delphi';
end;

end.

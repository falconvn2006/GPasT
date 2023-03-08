unit frmEscolha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls;

type
  TfrmPrincipalEscolha = class(TForm)
    pnlPrincipal: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipalEscolha: TfrmPrincipalEscolha;

implementation

uses
  frmSAM, frmRAM;

{$R *.dfm}

procedure TfrmPrincipalEscolha.Button1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipalEscolha.SpeedButton1Click(Sender: TObject);
begin
  Application.CreateForm(TfrmTerceiroRAM, frmTerceiroRAM);
  frmTerceiroRAM.ShowModal;
end;

procedure TfrmPrincipalEscolha.SpeedButton2Click(Sender: TObject);
begin
  Application.CreateForm(TfrmSecundarioSAM, frmSecundarioSAM);
  frmSecundarioSAM.ShowModal;
end;

end.

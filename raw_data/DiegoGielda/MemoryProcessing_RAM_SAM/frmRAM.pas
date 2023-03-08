unit frmRAM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, RzGrids, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfrmTerceiroRAM = class(TForm)
    pnlSAM: TPanel;
    gbConfiguracoes: TGroupBox;
    btnImportarRAM: TSpeedButton;
    btnVoltarRAM: TSpeedButton;
    txtImportarRAM: TLabeledEdit;
    gridProcessos: TRzStringGrid;
    gbConsultaSAM: TGroupBox;
    btnConsultar: TSpeedButton;
    txtConsultaCampo: TLabeledEdit;
    gbResultadoSAM: TGroupBox;
    lblRAMResultadoRAM: TLabel;
    lblRAMResultadoSAM: TLabel;
    procedure btnVoltarRAMClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTerceiroRAM: TfrmTerceiroRAM;

implementation

{$R *.dfm}

procedure TfrmTerceiroRAM.btnVoltarRAMClick(Sender: TObject);
begin
  Close;
end;

end.

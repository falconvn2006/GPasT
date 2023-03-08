unit frmSAM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  RzGrids;

type
  TfrmSecundarioSAM = class(TForm)
    pnlSAM: TPanel;
    txtImportar: TLabeledEdit;
    gbConfiguracoes: TGroupBox;
    btnImportarSAM: TSpeedButton;
    btnVoltar: TSpeedButton;
    OpenArquivoTxt: TOpenDialog;
    gridProcessos: TRzStringGrid;
    gbConsultaSAM: TGroupBox;
    txtConsultaCampo: TLabeledEdit;
    btnConsultar: TSpeedButton;
    gbResultadoSAM: TGroupBox;
    lblSAMResultadoSAM: TLabel;
    lblSAMResultadoRAM: TLabel;
    procedure btnVoltarClick(Sender: TObject);
    procedure btnImportarSAMClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
  private
    { Private declarations }
    procedure ImportarConteudo();
    procedure AlteraLabel(pLabel: TLabel; pNovoTexto: String);
  public
    { Public declarations }
  end;

var
  frmSecundarioSAM: TfrmSecundarioSAM;

implementation

{$R *.dfm}

procedure TfrmSecundarioSAM.AlteraLabel(pLabel: TLabel; pNovoTexto: String);
begin
  pLabel.Caption := pNovoTexto;
end;

procedure TfrmSecundarioSAM.btnConsultarClick(Sender: TObject);
var
  lCont: Integer;
  lValorConsulta: string;
begin
  lValorConsulta := txtConsultaCampo.Text;
  for lCont := 0 to Pred(gridProcessos.RowCount) do
  begin
    if(gridProcessos.Cells[0,lCont] = lValorConsulta) then
    begin
      AlteraLabel(lblSAMResultadoSAM, 'Média de busca para SAM foi de: ' +  IntToStr(lCont + 1));
      exit;
    end;
    AlteraLabel(lblSAMResultadoSAM, 'PALAVRA NÃO ENCONTRADA! VERIFIQUE.');
  end;
end;

procedure TfrmSecundarioSAM.btnImportarSAMClick(Sender: TObject);
begin
  if OpenArquivoTxt.Execute then
  begin
    txtImportar.Text := ExtractFileName(OpenArquivoTxt.FileName);
    ImportarConteudo();
  end;
end;

procedure TfrmSecundarioSAM.ImportarConteudo;
var
  lListaInformacao: TStrings;
  lCont: Integer;
begin
  lListaInformacao := TStringList.Create();
  lListaInformacao.LoadFromFile(ExtractFilePath(Application.ExeName) + ExtractFileName(OpenArquivoTxt.FileName));
  gridProcessos.RowCount := lListaInformacao.Count;
  for lCont := 0 to Pred(lListaInformacao.Count) do
  begin
    gridProcessos.Cells[0,lCont] :=  lListaInformacao[lCont];
  end;
  lListaInformacao.Free;
end;

procedure TfrmSecundarioSAM.btnVoltarClick(Sender: TObject);
begin
  Close;
end;

end.

unit uRelCaixa;

interface

uses
{(*}
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  RLReport,
  Data.DB,
  DM.Main,
  Controle.Caixa.Controller.Manager,
  Controle.Caixa.Controller.Manager.Interfaces,
  Manager.Types;
{*)}

type
  TFrmRelCaixa = class(TForm)
    RelCaixa: TRLReport;
    HeaderRel: TRLBand;
    RLLabel2: TRLLabel;
    Data: TRLSystemInfo;
    RLLabel1: TRLLabel;
    TitleRel: TRLBand;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLBand1: TRLBand;
    DSRel: TDataSource;
    FooterRel: TRLBand;
    NPage: TRLSystemInfo;
    DataTitulo: TRLDBText;
    DataEntrada: TRLDBText;
    DataValor: TRLDBText;
    RLLabel6: TRLLabel;
    DataTipoReg: TRLDBText;
    NPageLast: TRLSystemInfo;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLBand2: TRLBand;
    RLLabel9: TRLLabel;
    RLDraw1: TRLDraw;
    RLDBText1: TRLDBText;
    DSTotal: TDataSource;
    procedure RelCaixaBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure DataTipoRegBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
  private
    FControllerManager, FControllerManagerSum: iControllerManager;
  public
    pDTInicio, pDTFim: TDateTime;
    PreviewType: TtpCaixa;
  end;

var
  FrmRelCaixa: TFrmRelCaixa;

implementation

{$R *.dfm}

procedure TFrmRelCaixa.DataTipoRegBeforePrint(Sender: TObject; var AText: string; var PrintIt: Boolean);
begin
  if DataTipoReg.Field.AsBoolean then
    AText := 'ENTRADA'
  else
    AText := 'SAÍDA';
end;

procedure TFrmRelCaixa.FormCreate(Sender: TObject);
begin
  FControllerManager := TControllerManager.New;
  FControllerManagerSum := TControllerManager.New;
end;

procedure TFrmRelCaixa.RelCaixaBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  FControllerManager.Caixa.FindAll.Where('DTENTRADA', tpFilterOperator.Between, FormatDateTime('yyyy-mm-dd', pDTInicio), FormatDateTime('yyyy-mm-dd', pDTFim));
  FControllerManagerSum.Caixa.Sum('VALOR').Where('DTENTRADA', tpFilterOperator.Between, FormatDateTime('yyyy-mm-dd', pDTInicio), FormatDateTime('yyyy-mm-dd', pDTFim));

  case PreviewType of
    TODOS:
      begin
        RLBand2.Visible := False;
      end;
    ENTRADA:
      begin
        FControllerManager.Caixa._And('ENTRADA', tpFilterOperator.Eq, '1');
        FControllerManagerSum.Caixa._And('ENTRADA', tpFilterOperator.Eq, '1');
        RLDBText1.Text := 'R$ ';
      end;
    SAIDA:
      begin
        FControllerManager.Caixa._And('ENTRADA', tpFilterOperator.Eq, '0');
        FControllerManagerSum.Caixa._And('ENTRADA', tpFilterOperator.Eq, '0');
        RLDBText1.Text := 'R$ ';
      end;
  end;

  DSRel.DataSet := FControllerManager.Caixa.DataSource.DataSet;
  DSTotal.DataSet := FControllerManagerSum.Caixa.DataSource.DataSet;
end;

end.


unit RelatorioAbastecimentoImpressao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuickRpt, ExtCtrls, FMTBcd, DB, SqlExpr, QRCtrls;

type
  TfRelatorioAbastecimentoImpressao = class(TForm)
    QuickRep: TQuickRep;
    TitleBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    SummaryBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    lblData: TQRLabel;
    lblTanque: TQRLabel;
    lblBomba: TQRLabel;
    lblValor: TQRLabel;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRShape9: TQRShape;
    QRShape10: TQRShape;
    QRShape13: TQRShape;
    lblValorTotal: TQRLabel;
    Query: TSQLQuery;
    procedure DetailBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure SummaryBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    ValorTotal : Currency;
  public
    
  end;

var
  fRelatorioAbastecimentoImpressao: TfRelatorioAbastecimentoImpressao;

implementation

uses uPrincipal;

{$R *.dfm}

procedure TfRelatorioAbastecimentoImpressao.DetailBand1BeforePrint(
  Sender: TQRCustomBand; var PrintBand: Boolean);
begin
  lblData.Caption := FormatDateTime('dd/mm/yyyy', Query.FieldByName('DATA').AsDateTime);
  lblTanque.Caption := Query.FieldByName('TANQUE').AsString;
  lblBomba.Caption := Query.FieldByName('BOMBA').AsString;
  lblValor.Caption := FormatFloat('0.00', Query.FieldByName('VALOR_ABASTECIMENTO').AsCurrency);

  ValorTotal := ValorTotal + Query.FieldByName('VALOR_ABASTECIMENTO').AsCurrency;
end;

procedure TfRelatorioAbastecimentoImpressao.SummaryBand1BeforePrint(
  Sender: TQRCustomBand; var PrintBand: Boolean);
begin
  lblValorTotal.Caption := FormatFloat('0.00', ValorTotal);
  ValorTotal := 0;
end;

procedure TfRelatorioAbastecimentoImpressao.FormCreate(Sender: TObject);
begin
  ValorTotal := 0;
end;

end.

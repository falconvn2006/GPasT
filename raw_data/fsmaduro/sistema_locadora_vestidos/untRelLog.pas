unit untRelLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QRCtrls, QuickRpt, ExtCtrls, DB, IBCustomDataSet, IBQuery, jpeg;

type
  TfrmRelLog = class(TForm)
    qrLog: TQuickRep;
    PageHeaderBand1: TQRBand;
    QRShape1: TQRShape;
    QRLabel5: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel3: TQRLabel;
    DetailBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel1: TQRLabel;
    QRLabel6: TQRLabel;
    QRDBText2: TQRDBText;
    qryLogImpresso: TIBQuery;
    QRGroup1: TQRGroup;
    QRDBText3: TQRDBText;
    qryLogImpressoCODIGOUSUARIO: TIntegerField;
    qryLogImpressoDATA: TDateField;
    qryLogImpressoHORA: TTimeField;
    qryLogImpressoUSERNAME: TIBStringField;
    qryLogImpressoNOME: TIBStringField;
    QRLabel2: TQRLabel;
    QRDBText5: TQRDBText;
    QRBand1: TQRBand;
    QRShape2: TQRShape;
    QRLabel4: TQRLabel;
    QRSysData3: TQRSysData;
    QRLabel9: TQRLabel;
    QRSysData4: TQRSysData;
    qryLogImpressoTEXTO: TIBStringField;
    QRImage1: TQRImage;
    procedure qrLogBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRelLog: TfrmRelLog;

implementation

uses untDados;

{$R *.dfm}

procedure TfrmRelLog.qrLogBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
var
  arquivo : string;
begin
  arquivo := Dados.UrlLogoEmpresa;

  If FileExists(arquivo) Then
    QRImage1.Picture.LoadFromFile(arquivo)
  else
    QRImage1.Picture := nil;
end;

end.

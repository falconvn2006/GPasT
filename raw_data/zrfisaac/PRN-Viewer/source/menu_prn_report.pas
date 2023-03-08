// # [ about ]
// # - author : Isaac Caires
// # . - email : zrfisaac@gmail.com
// # . - site : https://sites.google.com/view/zrfisaac-en

// # [ lazarus ]
unit menu_prn_report;

{$mode objfpc}
{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls,
  ComCtrls,
  RLReport,
  RLPDFFilter,
  RLXLSFilter,
  RLHTMLFilter,
  RLRichFilter,
  RLPreviewForm,
  RLPrintDialog,
  model_report_form;

type

  { TMenuPrnReport }

  TMenuPrnReport = class(TModelReportForm)
    rlmePortrait: TRLMemo;
    rlmeLandscape: TRLMemo;
    rlPreview: TRLPreviewSetup;
    procedure FormCreate(Sender: TObject);
  end;

var
  MenuPrnReport: TMenuPrnReport;

implementation

{$R *.lfm}

{ TMenuPrnReport }

procedure TMenuPrnReport.FormCreate(Sender: TObject);
begin
  // # : - variable
  if (MenuPrnReport = Nil) then
    MenuPrnReport := Self;

  // # : - inheritance
  inherited;
end;

end.


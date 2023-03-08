unit model_report_form;

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
  model_routine_form;

type

  { TModelReportForm }

  TModelReportForm = class(TModelRoutineForm)
    rlHtml: TRLHTMLFilter;
    rlPdf: TRLPDFFilter;
    rlLandscape: TRLReport;
    rlPortrait: TRLReport;
    rlRich: TRLRichFilter;
    rlXls: TRLXLSFilter;
    sbPortrait: TScrollBox;
    sbLandscape: TScrollBox;
    tsPortrait: TTabSheet;
    tsLandscape: TTabSheet;
  private

  public

  end;

var
  ModelReportForm: TModelReportForm;

implementation

{$R *.lfm}

end.


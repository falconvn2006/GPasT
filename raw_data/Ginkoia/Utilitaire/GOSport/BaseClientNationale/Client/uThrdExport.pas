unit uThrdExport;

interface

uses
  Classes;

type
  TThrdExport = class(TThread)
  private
    FListHoraireExportNow: String;
  protected
    procedure Execute; override;
  public
    property ListHoraireExportNow: String read FListHoraireExportNow write FListHoraireExportNow;
  end;

implementation

uses FrmMain;

{ TThrdExport }

procedure TThrdExport.Execute;
begin
  MainFrm.SetExport(FListHoraireExportNow);
end;

end.

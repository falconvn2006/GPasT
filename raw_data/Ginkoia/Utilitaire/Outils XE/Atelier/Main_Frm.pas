unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActnList, CategoryButtons, ComCtrls, NomenKImpCsv_Frm, Main_DM, uVersion;

type
  Tfrm_Main = class(TForm)
    GridPanel1: TGridPanel;
    CategoryButtons1: TCategoryButtons;
    ActLst_Main: TActionList;
    Ax_ImpCsv: TAction;
    Pan_Contener: TPanel;
    Pgc_Contener: TPageControl;
    procedure Ax_ImpCsvExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure AddToPageControl(AForm : TFormClass);
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.dfm}

{ Tfrm_NomenkImpCsv }

procedure Tfrm_Main.AddToPageControl(AForm: TFormClass);
var
  i, j : integer;
  bFound : Boolean;
  Tab : TTabSheet;
  NewForm : TForm;
begin
  With Pgc_Contener do
  begin
    bFound := False;
    for i := 0 to PageCount -1 do
      for j := 0 to Pgc_Contener.Pages[i].ControlCount -1 do
        if Pgc_Contener.Pages[i].Controls[j] is AForm then
        begin
          bFound := True;
          Pgc_Contener.ActivePageIndex := i;
          Break;
        end;

    if not bFound then
    begin
      Tab := TTabSheet.Create(Pgc_Contener);
      Tab.TabVisible := False;
      Tab.PageControl := Pgc_Contener;

      NewForm := AForm.Create(Tab);
      NewForm.Align := alClient;
      NewForm.Parent := Tab;
      NewForm.BorderIcons := [];
      NewForm.BorderStyle := bsNone;
      NewForm.Visible := True;
      Tab.Visible := True;
    end;

  end;
end;

procedure Tfrm_Main.Ax_ImpCsvExecute(Sender: TObject);
begin
  AddToPageControl(Tfrm_NomenkImpCsv);
end;

procedure Tfrm_Main.FormCreate(Sender: TObject);
begin
  Caption := 'Outil Atelier v' + GetNumVersionSoft;

  GAPPPATH := ExtractFilePath(Application.ExeName);
  GAPPLOGS := GAPPPATH + 'Logs\';

  ForceDirectories(GAPPLOGS);
end;

end.

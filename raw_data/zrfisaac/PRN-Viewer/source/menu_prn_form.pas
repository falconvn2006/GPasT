// # [ about ]
// # - author : Isaac Caires
// # . - email : zrfisaac@gmail.com
// # . - site : https://sites.google.com/view/zrfisaac-en

// # [ lazarus ]
unit menu_prn_form;

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
  StdCtrls,
  Buttons,
  CheckLst,
  LCLType,
  StrUtils,
  RLReport,
  RLPDFFilter,
  RLXLSFilter,
  RLHTMLFilter,
  RLRichFilter,
  model_routine_form;

type

  { TMenuPrnForm }

  TMenuPrnForm = class(TModelRoutineForm)
    btAdd: TBitBtn;
    btClean: TBitBtn;
    btView: TBitBtn;
    btPrint: TBitBtn;
    cklbFile: TCheckListBox;
    pnFile: TPanel;
    pnFooter: TPanel;
    pnFooter01: TPanel;
    pnFooter02: TPanel;
    pnFooter03: TPanel;
    pnRoutine: TPanel;
    sbRoutine: TScrollBox;
    procedure btAddClick(Sender: TObject);
    procedure btCleanClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure btViewClick(Sender: TObject);
    procedure cklbFileKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormCreate(Sender: TObject);
  public
    procedure fnFile_Add;
    procedure fnFile_Clean;
    procedure fnFile_Delete;
    procedure fnFile_View(_pView: Boolean = True);
  end;

var
  MenuPrnForm: TMenuPrnForm;

implementation

uses
  menu_prn_data,
  menu_prn_report;

{$R *.lfm}

{ TMenuPrnForm }

procedure TMenuPrnForm.FormCreate(Sender: TObject);
var
  _vI0: Integer;
begin
  // # : - variable
  if (MenuPrnForm = Nil) then
    MenuPrnForm := Self;

  // # : - inheritance
  inherited;

  // # : - data
  if (MenuPrnData = Nil) then
    TMenuPrnData.Create(Application);

  // # : - report
  if (MenuPrnReport = Nil) then
    TMenuPrnReport.Create(Application);

  // # : - test
  for _vI0 := 0 to Self.cklbFile.Items.Count - 1 do
    Self.cklbFile.Checked[_vI0] := True;
end;

procedure TMenuPrnForm.fnFile_Add;
var
  _vB0: Boolean;
  _vFile: TOpenDialog;
  _vI0,_vI1: Integer;
begin
  // # : - routine
  _vFile := MenuPrnData.dgFile_En;
  if (_vFile.Execute) then
  begin
    for _vI0 := 0 to _vFile.Files.Count - 1 do
    begin
      _vB0 := False;
      for _vI1 := 0 to Self.cklbFile.Items.Count - 1 do
        if (Self.cklbFile.Items[_vI1] = _vFile.Files[_vI0]) then
          _vB0 := True;
      if not(_vB0) then
      begin
        Self.cklbFile.Items.Add(_vFile.Files[_vI0]);
        Self.cklbFile.Checked[Self.cklbFile.Items.Count - 1] := True;
      end;
    end;
  end;
end;

procedure TMenuPrnForm.fnFile_Clean;
begin
  // # : - routine
  Self.cklbFile.Clear;
end;

procedure TMenuPrnForm.fnFile_Delete;
begin
  // # : - routine
end;

procedure TMenuPrnForm.fnFile_View(_pView: Boolean = True);
var
  _vB0: Boolean;
  _vFile,_vFile0: TStrings;
  _vI0,_vI1: Integer;
  _vLandscape_Report: Array of TRLReport;
  _vLandscape_Text: Array of TStrings;
  _vMemo: TRLMemo;
  _vPortrait_Report: Array of TRLReport;
  _vPortrait_Text: Array of TStrings;
  _vReport: TRLReport;
  _vS0: String;
begin
  // # : load file
  for _vI0 := 0 to Self.cklbFile.Items.Count-1 do
  begin
    if (Self.cklbFile.Checked[_vI0]) then
    begin
      _vFile := TStringList.Create;
      _vFile.LoadFromFile(Self.cklbFile.Items[_vI0]);
      _vB0 := True;
      for _vI1 := 0 to _vFile.Count-1 do
        if (_vFile[_vI1].Length >= 100) then
          _vB0 := False;
      if (_vB0) then
      begin
        // # : - portrait
        _vFile0 := Nil;
        for _vI1 := 0 to _vFile.Count-1 do
        begin
          _vS0 := _vFile[_vI1];
          _vS0 := StringReplace(_vS0
            ,#12
            ,#32
            ,[rfReplaceAll,rfIgnoreCase]
          );
          _vS0 := StringReplace(_vS0
            ,#15
            ,#32
            ,[rfReplaceAll,rfIgnoreCase]
          );
          _vS0 := Trim(_vS0);
          if not(ContainsText(_vFile[_vI1], #12))
          and (_vI1 > 0) then
          begin
            if not(_vS0 = '')
            or (_vFile0.Count > 1) then
              _vFile0.Add(_vS0);
          end
          else if (
            (_vS0.Length > 2)
            and
            ((_vFile.Count - _vI1) > 2)
          )
          or (_vFile0 = Nil) then
          begin
            // [begin] : https://github.com/zrfisaac/tool-prn/issues/3
            if (Length(_vPortrait_Text) > 0) then
              _vPortrait_Text[Length(_vPortrait_Text)-1].Add(_vS0);
            // [end]
            SetLength(_vPortrait_Text, Length(_vPortrait_Text)+1);
            _vFile0 := TStringList.Create;
            _vPortrait_Text[Length(_vPortrait_Text)-1] := _vFile0;
          end;
        end;
      end
      else
      begin
        // # : - landscape
        _vFile0 := Nil;
        for _vI1 := 0 to _vFile.Count-1 do
        begin
          _vS0 := _vFile[_vI1];
          _vS0 := StringReplace(_vS0
            ,#12
            ,#32
            ,[rfReplaceAll,rfIgnoreCase]
          );
          _vS0 := StringReplace(_vS0
            ,#15
            ,#32
            ,[rfReplaceAll,rfIgnoreCase]
          );
          _vS0 := Trim(_vS0);
          if not(ContainsText(_vFile[_vI1], #12))
          and (_vI1 > 0) then
          begin
            if not(_vS0 = '')
            or (_vFile0.Count > 1) then
              _vFile0.Add(_vS0);
          end
          else if (
            (_vS0.Length > 2)
            and
            ((_vFile.Count - _vI1) > 2)
          )
          or (_vFile0 = Nil) then
          begin
            // [begin] : https://github.com/zrfisaac/tool-prn/issues/3
            if (Length(_vLandscape_Text) > 0) then
              _vLandscape_Text[Length(_vLandscape_Text)-1].Add(_vS0);
            // [end]
            SetLength(_vLandscape_Text, Length(_vLandscape_Text)+1);
            _vFile0 := TStringList.Create;
            _vLandscape_Text[Length(_vLandscape_Text)-1] := _vFile0;
          end;
        end;
      end;
      _vFile.Free;
    end;
  end;

  // # : construct report portrait
  for _vI0 := 0 to Length(_vPortrait_Text)-1 do
  begin
    SetLength(_vPortrait_Report, Length(_vPortrait_Report)+1);
    _vReport := TRLReport.Create(MenuPrnReport);
    _vPortrait_Report[Length(_vPortrait_Report)-1] := _vReport;
    _vMemo := TRLMemo.Create(_vReport);
    _vMemo.Parent := _vReport;
    _vMemo.Top := MenuPrnReport.rlmePortrait.Top;
    _vMemo.Left := MenuPrnReport.rlmePortrait.Left;
    _vMemo.Width := MenuPrnReport.rlmePortrait.Width;
    _vMemo.Height := MenuPrnReport.rlmePortrait.Height;
    _vMemo.Font := MenuPrnReport.rlmePortrait.Font;
    _vMemo.Lines.Text := _vPortrait_Text[_vI0].Text;
    _vReport.PageSetup := MenuPrnReport.rlPortrait.PageSetup;
    _vReport.Margins := MenuPrnReport.rlPortrait.Margins;
    if (_vI0 > 0) then
      _vPortrait_Report[_vI0-1].NextReport := _vPortrait_Report[_vI0];
  end;

  // # : construct report landscape
  for _vI0 := 0 to Length(_vLandscape_Text)-1 do
  begin
    SetLength(_vLandscape_Report, Length(_vLandscape_Report)+1);
    _vReport := TRLReport.Create(MenuPrnReport);
    _vLandscape_Report[Length(_vLandscape_Report)-1] := _vReport;
    _vMemo := TRLMemo.Create(_vReport);
    _vMemo.Parent := _vReport;
    _vMemo.Top := MenuPrnReport.rlmeLandscape.Top;
    _vMemo.Left := MenuPrnReport.rlmeLandscape.Left;
    _vMemo.Width := MenuPrnReport.rlmeLandscape.Width;
    _vMemo.Height := MenuPrnReport.rlmeLandscape.Height;
    _vMemo.Font := MenuPrnReport.rlmeLandscape.Font;
    _vMemo.Lines.Text := _vLandscape_Text[_vI0].Text;
    _vReport.PageSetup := MenuPrnReport.rlLandscape.PageSetup;
    _vReport.Margins := MenuPrnReport.rlLandscape.Margins;
    if (_vI0 > 0) then
      _vLandscape_Report[_vI0-1].NextReport := _vLandscape_Report[_vI0];
  end;

  // # : show report portrait
  if (Length(_vPortrait_Text) > 0) then
    if (_pView) then
      _vPortrait_Report[0].PreviewModal
    else
      _vPortrait_Report[0].Print;

  // # : show report landscape
  if (Length(_vLandscape_Text) > 0) then
    if (_pView) then
      _vLandscape_Report[0].PreviewModal
    else
      _vLandscape_Report[0].Print;

  // # : clear variables
  for _vI0 := 0 to Length(_vLandscape_Report)-1 do
    _vLandscape_Report[_vI0].Free;
  SetLength(_vLandscape_Report, 0);
  for _vI0 := 0 to Length(_vLandscape_Text)-1 do
    _vLandscape_Text[_vI0].Free;
  SetLength(_vLandscape_Text, 0);
  for _vI0 := 0 to Length(_vPortrait_Report)-1 do
    _vPortrait_Report[_vI0].Free;
  SetLength(_vPortrait_Report, 0);
  for _vI0 := 0 to Length(_vPortrait_Text)-1 do
    _vPortrait_Text[_vI0].Free;
  SetLength(_vPortrait_Text, 0);
end;

procedure TMenuPrnForm.btAddClick(Sender: TObject);
begin
  // # : - routine
  Self.fnFile_Add;
end;

procedure TMenuPrnForm.btCleanClick(Sender: TObject);
begin
  // # : - routine
  Self.fnFile_Clean;
end;

procedure TMenuPrnForm.btPrintClick(Sender: TObject);
begin
  // # : - routine
  Self.fnFile_View(False);
end;

procedure TMenuPrnForm.btViewClick(Sender: TObject);
begin
  // # : - routine
  Self.fnFile_View;
end;

procedure TMenuPrnForm.cklbFileKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // # : - routine
  if (Key = VK_DELETE) then
    Self.fnFile_Delete;
end;

end.


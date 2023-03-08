{Copyright (c) 2023 Stephan Breer

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
}

unit LibraryForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, XMLConf, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, ComCtrls, StdCtrls, Types;

type

  { TfmLibrary }

  TfmLibrary = class(TForm)
    bClose: TButton;
    pnBottom: TPanel;
    sgItemData: TStringGrid;
    tcHeader: TTabControl;
    procedure bCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgItemDataDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgItemDataEditingDone(Sender: TObject);
    procedure sgItemDataGetCellHint(Sender: TObject; ACol, ARow: Integer;
      var HintText: String);
    procedure sgItemDataSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure tcHeaderChange(Sender: TObject);
  private
    StrFileNotFound,
    StrEntryNotFound,
    StrMapsHeader,
    StrTokensHeader,
    StrOverlaysHeader: string;
    procedure ShowMaps;
    procedure ShowTokens;
    procedure ShowOverlays;
    procedure UpdateMaps;
    procedure UpdateTokens;
    procedure UpdateOverlays;
    function ItemExists(path: string): Boolean;
  public

  end;

var
  fmLibrary: TfmLibrary;

implementation

{$R *.lfm}

uses
  FileUtil,
  ControllerForm,
  DisplayConst,
  LangStrings;

{ TfmLibrary }

procedure TfmLibrary.FormCreate(Sender: TObject);
begin
  Caption := GetString(LangStrings.LanguageID, 'LibraryCaption');
  bClose.Caption := GetString(LangStrings.LanguageID, 'ButtonClose');
  tcHeader.Tabs[0] := GetString(LangStrings.LanguageID, 'LibraryHeaderMaps');
  tcHeader.Tabs[1] := GetString(LangStrings.LanguageID, 'LibraryHeaderToken');
  tcHeader.Tabs[2] := GetString(LangStrings.LanguageID, 'LibraryHeaderOverlays');

  StrFileNotFound  := GetString(LangStrings.LanguageID, 'LibraryGridHintFileNotFound');
  StrEntryNotFound := GetString(LangStrings.LanguageID, 'LibraryGridHintEntryNotFound');
  StrMapsHeader    := GetString(LangStrings.LanguageID, 'LibraryGridHeaderMaps');
  StrTokensHeader  := GetString(LangStrings.LanguageID, 'LibraryGridHeaderTokens');
  StrOverlaysHeader:= GetString(LangStrings.LanguageID, 'LibraryGridHeaderOverlays');
end;

procedure TfmLibrary.bCloseClick(Sender: TObject);
begin
  sgItemData.EditingDone;
  fmController.SaveLibraryData;
  Close;
end;


procedure TfmLibrary.ShowMaps;
var
  FileList: TStringList;
  i: Integer;
begin
  FileList := TStringList.Create;
  sgItemData.ColCount := 4;
  sgItemData.ColWidths[0] := 22;
  sgItemData.Rows[0].CommaText := StrMapsHeader;
  try
    FindAllFiles(FileList, fmController.MapDir, PICFILEFILTER, True);
    sgItemData.RowCount := FileList.Count + 1;
    for i := 0 to FileList.Count - 1 do
    begin
      sgItemData.Cells[1, i + 1] := ExtractFileName(FileList[i]);
      sgItemData.Cells[2, i + 1] := FileList[i];
      if fmController.MapLib.IndexOfName(FileList[i]) >= 0 then
        sgItemData.Cells[3, i + 1] := fmController.MapLib.Values[FileList[i]]
      else
        sgItemData.Cells[3, i + 1] := '';
    end;

    // Add orphaned entries from database
    for i := 0 to fmController.MapLib.Count - 1 do
    begin
      if sgItemData.Cols[2].IndexOf(fmController.MapLib.Names[i]) < 0 then
      begin
        sgItemData.RowCount := sgItemData.RowCount + 1;
        sgItemData.Cells[1, sgItemData.RowCount - 1] := ExtractFileName(fmController.MapLib.Names[i]);
        sgItemData.Cells[2, sgItemData.RowCount - 1] := fmController.MapLib.Names[i];
        sgItemData.Cells[3, sgItemData.RowCount - 1] := fmController.MapLib.ValueFromIndex[i];
      end;
    end;
  finally
    FileList.Free;
  end;
end;

procedure TfmLibrary.ShowTokens;  
var
  FileList, ContentList: TStringList;
  i, j: Integer;
begin
  FileList := TStringList.Create;
  ContentList := TStringList.Create;
  ContentList.Delimiter := '|';
  ContentList.StrictDelimiter := True;
  sgItemData.ColCount := 10;
  sgItemData.Rows[0].CommaText := StrTokensHeader;
  try
    FindAllFiles(FileList, fmController.TokenDir, PICFILEFILTER, True);
    sgItemData.RowCount := FileList.Count + 1;
    for i := 0 to FileList.Count - 1 do
    begin
      sgItemData.Cells[1, i + 1] := ExtractFileName(FileList[i]);
      sgItemData.Cells[2, i + 1] := FileList[i];
      if fmController.TokenLib.IndexOfName(FileList[i]) >= 0 then
      begin
        ContentList.DelimitedText := fmController.TokenLib.Values[FileList[i]];
        if ContentList.Count = 7 then
        begin
          for j := 0 to ContentList.Count - 1 do
            sgItemData.Cells[3 + j, i + 1] := ContentList[j];
        end
        else
        begin
          sgItemData.Cells[3, i + 1] := '';
          sgItemData.Cells[4, i + 1] := '0';
          sgItemData.Cells[5, i + 1] := '100';
          sgItemData.Cells[6, i + 1] := '100';
          sgItemData.Cells[7, i + 1] := '1';
          sgItemData.Cells[8, i + 1] := '1';
          sgItemData.Cells[9, i + 1] := '0';
        end;
      end
      else
      begin
        sgItemData.Cells[3, i + 1] := '';
        sgItemData.Cells[4, i + 1] := '0';
        sgItemData.Cells[5, i + 1] := '100';
        sgItemData.Cells[6, i + 1] := '100';
        sgItemData.Cells[7, i + 1] := '1';
        sgItemData.Cells[8, i + 1] := '1';
        sgItemData.Cells[9, i + 1] := '0';
      end;
    end;

    // Add orphaned entries from database
    for i := 0 to fmController.TokenLib.Count - 1 do
    begin
      if sgItemData.Cols[2].IndexOf(fmController.TokenLib.Names[i]) < 0 then
      begin
        sgItemData.RowCount := sgItemData.RowCount + 1;
        ContentList.DelimitedText := fmController.TokenLib.ValueFromIndex[i];
        for j := 0 to ContentList.Count - 1 do
          sgItemData.Cells[3 + j, i + 1] := ContentList[j];
        sgItemData.Cells[1, sgItemData.RowCount - 1] := ExtractFileName(fmController.TokenLib.Names[i]);
        sgItemData.Cells[2, sgItemData.RowCount - 1] := fmController.TokenLib.Names[i];
      end;
    end;
  finally
    FileList.Free;
    ContentList.Free;
  end;
end;

procedure TfmLibrary.ShowOverlays;
var
  FileList, ContentList: TStringList;
  i, j: Integer;
begin
  FileList := TStringList.Create; 
  ContentList := TStringList.Create;
  ContentList.Delimiter := '|';
  ContentList.StrictDelimiter := True;
  sgItemData.ColCount := 6;
  sgItemData.Rows[0].CommaText := StrOverlaysHeader;
  try
    FindAllFiles(FileList, fmController.OverlayDir, PICFILEFILTER, True);
    sgItemData.RowCount := FileList.Count + 1;
    for i := 0 to FileList.Count - 1 do
    begin
      sgItemData.Cells[1, i + 1] := ExtractFileName(FileList[i]);
      sgItemData.Cells[2, i + 1] := FileList[i];
      if fmController.TokenLib.IndexOfName(FileList[i]) >= 0 then
      begin
        ContentList.DelimitedText := fmController.OverlayLib.Values[FileList[i]];
        if ContentList.Count = 3 then
        begin
          for j := 0 to ContentList.Count - 1 do
            sgItemData.Cells[3 + j, i + 1] := ContentList[j];
        end
        else
        begin
          sgItemData.Cells[3, i + 1] := '';
          sgItemData.Cells[4, i + 1] := '32';
          sgItemData.Cells[5, i + 1] := '32';
        end;
      end
      else
      begin
          sgItemData.Cells[3, i + 1] := '';
          sgItemData.Cells[4, i + 1] := '32';
          sgItemData.Cells[5, i + 1] := '32';
      end;
    end;

    // Add orphaned entries from database
    for i := 0 to fmController.OverlayLib.Count - 1 do
    begin
      if sgItemData.Cols[2].IndexOf(fmController.OverlayLib.Names[i]) < 0 then
      begin
        sgItemData.RowCount := sgItemData.RowCount + 1;
        ContentList.DelimitedText := fmController.OverlayLib.ValueFromIndex[i];
        for j := 0 to ContentList.Count - 1 do
          sgItemData.Cells[3 + j, i + 1] := ContentList[j];
        sgItemData.Cells[1, sgItemData.RowCount - 1] := ExtractFileName(fmController.TokenLib.Names[i]);
        sgItemData.Cells[2, sgItemData.RowCount - 1] := fmController.TokenLib.Names[i];
      end;
    end;
  finally
    FileList.Free;
    ContentList.Free;
  end;
end;
   
procedure TfmLibrary.UpdateMaps;
var i: Integer;
begin
  for i := 1 to sgItemData.RowCount - 1 do
    fmController.MapLib.Values[sgItemData.Cells[2, i]] := sgItemData.Cells[3,i];
end;

procedure TfmLibrary.UpdateTokens;
var
  i, j: Integer;
  ContentList: TStringList;
begin
  ContentList := TStringList.Create;
  try
    ContentList.Delimiter := '|';
    ContentList.StrictDelimiter := True;
    for i := 1 to sgItemData.RowCount - 1 do
    begin
      ContentList.Clear;
      for j := 3 to sgItemData.ColCount - 1 do
      begin
        ContentList.Add(sgItemData.Cells[j, i]);
      end;
      fmController.TokenLib.Values[sgItemData.Cells[2, i]] := ContentList.DelimitedText;
    end;
  finally
    ContentList.Free;
  end;
end;

procedure TfmLibrary.UpdateOverlays;
var
  i, j: Integer;
  ContentList: TStringList;
begin
  ContentList := TStringList.Create;
  try
    ContentList.Delimiter := '|';
    ContentList.StrictDelimiter := True;
    for i := 1 to sgItemData.RowCount - 1 do
    begin
      ContentList.Clear;
      for j := 3 to sgItemData.ColCount - 1 do
      begin
        ContentList.Add(sgItemData.Cells[j, i]);
      end;
      fmController.OverlayLib.Values[sgItemData.Cells[2, i]] := ContentList.DelimitedText;
    end;
  finally
    ContentList.Free;
  end;
end;

procedure TfmLibrary.FormShow(Sender: TObject);
begin
  tcHeader.TabIndex := 0;
  ShowMaps;
end;

function TfmLibrary.ItemExists(path: string): Boolean;
begin
  Result := False;
  case tcHeader.TabIndex of
    0: Result := (fmController.MapLib.IndexOfName(path) >= 0);
    1: Result := (fmController.TokenLib.IndexOfName(path) >= 0);
    2: Result := (fmController.OverlayLib.IndexOfName(path) >= 0);
  end;
end;

procedure TfmLibrary.sgItemDataDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if (aCol = 0) and (aRow > 0) then
  begin
    if (Length(sgItemData.Cells[2, aRow]) > 0) and not ItemExists(sgItemData.Cells[2, aRow]) then
      sgItemData.Canvas.Brush.Color := clYellow
    else if (Length(sgItemData.Cells[2, aRow]) > 0) and not FileExists(sgItemData.Cells[2, aRow]) then
      sgItemData.Canvas.Brush.Color := clRed
    else
      sgItemData.Canvas.Brush.Color := clGreen;
    sgItemData.Canvas.Ellipse(aRect);
  end;
end;

procedure TfmLibrary.sgItemDataEditingDone(Sender: TObject);
begin
  case tcHeader.TabIndex of
    0: UpdateMaps;
    1: UpdateTokens;
    2: UpdateOverlays;
  end;
end;

procedure TfmLibrary.sgItemDataGetCellHint(Sender: TObject; ACol,
  ARow: Integer; var HintText: String);
begin
  if (aCol = 0) and (aRow > 0) then
  begin
    if (Length(sgItemData.Cells[2, aRow]) > 0) and not ItemExists(sgItemData.Cells[2, aRow]) then
      HintText := StrEntryNotFound
    else if (Length(sgItemData.Cells[2, aRow]) > 0) and not FileExists(sgItemData.Cells[2, aRow]) then
      HintText := StrFileNotFound
    else
      HintText := '';
  end;
end;

procedure TfmLibrary.sgItemDataSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := aCol >= 3;
end;

procedure TfmLibrary.tcHeaderChange(Sender: TObject);
begin
  Case tcHeader.TabIndex of
    0: ShowMaps;
    1: ShowTokens;
    2: ShowOverlays;
  end;
end;

end.


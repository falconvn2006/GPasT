unit AddrEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Grids, Buttons, HUtil32, ExtCtrls;

type
  TFrmEditAddr = class(TForm)
    AddrGrid:    TStringGrid;
    Panel1:      TPanel;
    BtnApplyAndClose: TButton;
    ERowCount:   TSpinEdit;
    Label1:      TLabel;
    BtnApplyRow: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnApplyRowClick(Sender: TObject);
    procedure BtnApplyAndCloseClick(Sender: TObject);
  private
  public
    procedure Execute;
  end;

var
  FrmEditAddr: TFrmEditAddr;

implementation

{$R *.DFM}

procedure TFrmEditAddr.FormCreate(Sender: TObject);
begin
  ERowCount.Value := 8;
  with AddrGrid do begin
    Cells[0, 0] := 'LocalAddr';
    Cells[1, 0] := 'PublicAddr1';
    Cells[2, 0] := 'Port1';
    Cells[3, 0] := 'PublicAddr2';
    Cells[4, 0] := 'Port2';
    Cells[5, 0] := 'PublicAddr3';
    Cells[6, 0] := 'Port3';
  end;
end;

procedure TFrmEditAddr.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TFrmEditAddr.BtnApplyRowClick(Sender: TObject);
begin
  if ERowCount.Value < 1 then
    ERowCount.Value := 1;
  AddrGrid.RowCount := ERowCount.Value + 1;
end;

procedure TFrmEditAddr.Execute;

  procedure ClearGrid;
  var
    i, j: integer;
  begin
    with AddrGrid do begin
      for i := 1 to RowCount - 1 do
        for j := 0 to ColCount - 1 do
          Cells[j, i] := '';
    end;
  end;

var
  strlist:   TStringList;
  str, Data: string;
  i, j, n:   integer;
begin
  ClearGrid;
  //기존 파일 읽기
  strlist := TStringList.Create;
  try
    strlist.LoadFromFile('!serverinfo.txt');
  except
    ShowMessage('!serverinfo.txt  read fail..');
  end;

  n := 1;
  for i := 0 to strlist.Count - 1 do begin
    str := Trim(strlist[i]);
    if str <> '' then begin
      if str[1] = ';' then
        continue;
      str := GetValidStr3(str, Data, [' ', #9]);
      AddrGrid.Cells[0, n] := Data; //private addr
      for j := 0 to 2 do begin
        if str = '' then
          break;
        str := GetValidStr3(str, Data, [' ', #9]);
        AddrGrid.Cells[j * 2 + 1, n] := Data;
        str := GetValidStr3(str, Data, [' ', #9]);
        AddrGrid.Cells[j * 2 + 2, n] := Data;
      end;
      Inc(n);
      if n >= AddrGrid.RowCount then
        AddrGrid.RowCount := n + 1;
    end;
  end;
  strlist.Free;

  FrmEditAddr.Show;

end;

procedure TFrmEditAddr.BtnApplyAndCloseClick(Sender: TObject);
var
  strlist: TStringList;
  i, j:    integer;
  str:     string;
begin
  strlist := TStringList.Create;
  with AddrGrid do begin
    for i := 1 to RowCount - 1 do begin
      str := Trim(Cells[0, i]);
      if str <> '' then begin
        str := str + '  ';
        for j := 1 to ColCount - 1 do begin
          str := str + Trim(Cells[j, i]) + ' ';
        end;
        strlist.Add(str);
      end;
    end;
  end;
  try
    strlist.SaveToFile('!serverinfo.txt');
  except
    ShowMessage('!serverinfo.txt  save fail');
  end;
  strlist.Free;
  FrmEditAddr.Close;
end;

end.

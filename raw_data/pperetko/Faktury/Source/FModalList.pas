unit FModalList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,FTypes, Data.DB, Data.Win.ADODB;

type


  TModalList = class(TForm)
    sgList: TStringGrid;
    plTop: TPanel;
    plBottom: TPanel;
    btnZakoncz: TButton;
    BaseQuery: TADOQuery;
    BaseDS: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    procedure setGrid;
  public
     constructor Create(AOwner: TComponent);override;
     procedure SetColumnCount(Acount:integer);
     procedure SetColumnName(AList:TArrayOfString);
     procedure SetRowsCount(Acount:integer);
     procedure AddRow(No:integer;ARow:TArrayOfString);
     procedure AddValue(Acolumn,Arow:integer;Avalue:string);
     procedure SetColumnWidth(Alist:TArrayOfInteger);
     procedure Clear;
     procedure AddRowQuery(Aquery:TADOQuery;Aid:integer=-1);
     function GetID:integer;
  end;

var
  ModalList: TModalList;

implementation
uses Main;
{$R *.dfm}

{ TModalList }


procedure TModalList.SetColumnCount(Acount: integer);
begin
  sgList.ColCount := Acount+1;
end;

procedure TModalList.SetColumnName(AList: TArrayOfString);
var
  i:integer;
begin
  if Length(AList)< sgList.ColCount-1 then begin
    ShowMessage('Liczba nazw column jest mniejsza od liczby kolumn');
    exit;
  end else begin
    for i := 1 to sgList.ColCount-1 do  begin
      sgList.Cells[i,0]:= AList[i - 1];
    end;
  end;
end;

procedure TModalList.SetColumnWidth(Alist: TArrayOfInteger);
var
  i:integer;
begin
   if Length(AList)< sgList.ColCount-1 then begin
    ShowMessage('Liczba szerokoœci column jest mniejsza od liczby kolumn');
    exit;
  end else begin
    for i := 1 to sgList.ColCount-1 do  begin
      sgList.ColWidths[i]:= AList[i - 1];
    end;
  end;
end;

procedure TModalList.setGrid;
begin
  SetRowsCount(1);
  sgList.ColWidths[0]:=0;//Pierwsza kolumna bêdzie na id
  sgList.Options := sgList.Options - [goEditing, goRangeSelect];
end;

procedure TModalList.SetRowsCount(Acount: integer);
begin
  sgList.BeginUpdate;
  if Acount=0 then
    sgList.RowCount:= Acount + 2 else
    sgList.RowCount:= Acount + 1;
  sgList.EndUpdate;
end;

procedure TModalList.AddRow(No: integer; ARow: TArrayOfString);
var
  i:integer;
begin
  if no > sgList.RowCount then begin
    ShowMessage('Wybrano pozycjê wiêksz¹ od liczby wierszy');
    exit;
  end else if Length(ARow)< sgList.ColCount then  begin
    ShowMessage('Liczba wartoœci jest mniejsza od liczby kolumn');
    exit;
  end else begin
    for i:= Low(ARow) to High(arow) do begin
     sgList.Cells[i,no]:= ARow[i];
    end;
  end;
end;

procedure TModalList.AddRowQuery(Aquery: TADOQuery;Aid:integer=-1);
var
  iPosRow,iPosSelect:integer;
  i:integer;
begin
  clear;
  if Aquery.Active=false then exit;
  Aquery.First;
  iPosRow:=1;
  iPosSelect:=-1;
  while not Aquery.Eof do begin
    for i:= 0 to sgList.ColCount-1 do begin
      sgList.Cells[i,iPosRow]:=Aquery.Fields[i].AsString;
    end;
    if (Aid<>-1) and (Aid= Aquery.FieldByName('id').AsInteger) then
      iPosSelect:= iPosRow;
    inc(iPosRow);
    Aquery.Next;
  end;
  if iPosSelect<>-1 then begin
     sgList.FixedRows:= iPosSelect;
  end;
end;

procedure TModalList.AddValue(Acolumn, Arow: integer;Avalue:string);
begin
  if Acolumn> sgList.ColCount then begin
    ShowMessage('Numer kolumny poza zakresem');
    exit;
  end else if Arow > sgList.RowCount then  begin
    ShowMessage('Numer wiersza poza zakresem');
    exit;
  end else begin
    sgList.Cells[Acolumn,Arow]:= Avalue;
  end;
end;


procedure TModalList.Clear;
begin
  setGrid;
end;

constructor TModalList.Create(AOwner: TComponent);
begin
  Inherited create(AOwner);
  setGrid;
end;

procedure TModalList.FormCreate(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to self.ComponentCount-1 do begin
    if self.Components[i] is TADOQuery then begin
     TADOQuery(self.Components[i]).Connection :=FormMain.ADOConnection;
    end;
  end;
end;

function TModalList.GetID: integer;
begin
  result:=-1;
  if  sgList.Row >-1 then begin
    TryStrToInt(sgList.Cells[0,sgList.Row], result);
  end;
end;

end.

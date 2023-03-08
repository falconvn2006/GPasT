unit fKontrahenciLista;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FModalList, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ComCtrls, Vcl.ToolWin, AListBox;

type
  TKontrahenciListaForm = class(TModalList)
    ToolBar1: TToolBar;
    tbAdd: TToolButton;
    tbDelete: TToolButton;
    tbUpdate: TToolButton;
    ToolButton1: TToolButton;
    tbRefresh: TToolButton;
    qtmp: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure tbAddClick(Sender: TObject);
    procedure tbRefreshClick(Sender: TObject);
    procedure tbUpdateClick(Sender: TObject);
    procedure tbDeleteClick(Sender: TObject);
    procedure sgListDblClick(Sender: TObject);
  private
    fid:integer;
    procedure ConfigureSSg;
    procedure refresh;
  public
    class procedure Show;
    class function Wybierz:integer;
  end;



implementation
uses ftypes, fkontrahent;
Const
  cCountCol=9;
{$R *.dfm}

{ TKontrahenciListaForm }

procedure TKontrahenciListaForm.ConfigureSSg;
var
  cols:TArrayOfString;
  colsWidth:TArrayOfInteger;
begin
  SetColumnCount(cCountCol);
  setlength(cols,cCountCol);
  setlength(colsWidth,cCountCol);
  cols[0]:= 'Nazwa';
  cols[1]:= 'Ulica';
  cols[2]:= 'Nr domu';
  cols[3]:= 'Nr lokalu';
  cols[4]:= 'Kod pocztowy';
  Cols[5]:= 'Miejscowoœæ';
  cols[6]:= 'Gmina';
  cols[7]:= 'Powiat';
  Cols[8]:= 'Województwo';
  colsWidth[0]:=100;
  colsWidth[1]:=80;
  colsWidth[2]:=40;
  colsWidth[3]:=40;
  colsWidth[4]:=40;
  colsWidth[5]:=80;
  colsWidth[6]:=80;
  colsWidth[7]:=80;
  colsWidth[8]:=80;
  SetColumnName(cols);
  SetColumnWidth(colsWidth);
end;

procedure TKontrahenciListaForm.FormCreate(Sender: TObject);
begin
  inherited;
  ConfigureSSg;
  refresh;
end;

procedure TKontrahenciListaForm.refresh;
begin
  BaseQuery.SQL.Text:= 'SELECT k.id,k.nazwa,A.Ulica,A.NrBudynku,A.NrLokalu,A.kod,A.Miejscowosc,A.Gmina,A.Powiat,A.Wojewodztwo '+
    ' from Kontrahent K LEFT JOIN Adres A on k.AdresID=A.id WHERE K.Aktywny=1';
  BaseQuery.Open;
  SetRowsCount(10{BaseQuery.RecordCount});
  AddRowQuery(BaseQuery);
  A1Lista1.
end;

procedure TKontrahenciListaForm.sgListDblClick(Sender: TObject);
begin
  inherited;
  fid := GetID;
end;

class procedure TKontrahenciListaForm.Show;
var
  f: TKontrahenciListaForm;
begin
  f:=TKontrahenciListaForm.Create(Application);
  f.ShowModal;
  f.Free;
end;

procedure TKontrahenciListaForm.tbAddClick(Sender: TObject);
begin
 if TKontrahentForm.Show(-1)<>-1 then
   refresh;
end;

procedure TKontrahenciListaForm.tbDeleteClick(Sender: TObject);
begin
  inherited;
  //Sprawdziæ czy nie jest na fakturach
  if Komunikat.WyswietlKomunikatF('Pytanie','czy usun¹æ wskazanego kontrahenta?')=1 then
  begin
    qtmp.SQL.Text :=format('Delete from Adres where id in(Select AdresID from Kontrahent where id=%d)',[Getid]);
    qtmp.ExecSQL;
    refresh;
  end;
end;

procedure TKontrahenciListaForm.tbRefreshClick(Sender: TObject);
begin
  inherited;
  refresh;
end;

procedure TKontrahenciListaForm.tbUpdateClick(Sender: TObject);
begin
  inherited;
  if getid()<>-1 then
    TKontrahentForm.Show(GetID);
end;

class function TKontrahenciListaForm.Wybierz: integer;
var
  f: TKontrahenciListaForm;
begin
  f:=TKontrahenciListaForm.Create(Application);
  f.ShowModal;
  result:= f.fid;
  f.Free;
end;

end.

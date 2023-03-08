unit WeightSelect;

interface

uses
  Windows, Messages, SysUtils,  Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Grids, Xls2grid, Buttons, ConstAndUtils;

type
  TWSelect = class(TForm)
    StringGrid1: TStringGrid;
    OpenExcelfiles: TOpenDialog;
    SEffect: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    procedure Open_DataClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1Enter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public

    SelectedRow :integer;
    WeightName  : ShortString;
    { Public declarations }
  end;

var
  WSelect: TWSelect;

implementation

{$R *.dfm}

procedure TWSelect.Open_DataClick(Sender: TObject);
begin
 if OpenExcelfiles.Execute  then
   if Xls_To_StringGrid(StringGrid1, OpenExcelfiles.FileName) then
    begin
     StringGrid1.Rows[StringGrid1.RowCount - 1].Clear;
     StringGrid1.RowCount := StringGrid1.RowCount - 2;
     StringGrid1.Visible:=true;
   end;
end;

procedure TWSelect.CancelClick(Sender: TObject);
begin
 close;
end;

procedure TWSelect.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    if StringGrid1.Cells[0, Arow] <> '' then
                                       begin
                                         SEffect.Text:=StringGrid1.Cells[0, ARow];
                                         SelectedRow := ARow;
                                        end
                                       else
                                         begin
                                          SEffect.Text:='Please Select  Weight to ponderate';
                                          SelectedRow :=-1;
                                         end;

end;

procedure TWSelect.Button3Click(Sender: TObject);
var
 I:Integer;
begin
 if WeightList = nil then Weightlist:=TStringList.Create
                      else WeightList.Clear;

 If SelectedRow >= 0 then
 begin
  For I:=1 to Pred(StringGrid1.ColCount) do
  begin
   WeightList.Add(StringGrid1.Cells[I,0]);
   WeightList.Add(StringGrid1.Cells[I,SelectedRow])
  end;
  //ShowMessage(WeightList[0]+' '+ WeightList[1] + ' '+
 // WeightList[2]+ WeightList[3]+' '+WeightList[4]+ WeightList[5]);
  //ShowMessage(WeightList[6]+ WeightList[7]);

 end;


end;

procedure TWSelect.FormCreate(Sender: TObject);
begin
 SelectedRow :=-1;
 WeightName :='none';
end;

procedure TWSelect.StringGrid1Enter(Sender: TObject);
begin
 Button3Click(Sender);
end;

procedure TWSelect.SpeedButton1Click(Sender: TObject);
begin

 if OpenExcelfiles.Execute  then
   if Xls_To_StringGrid(StringGrid1, OpenExcelfiles.FileName) then
    begin
     StringGrid1.Rows[StringGrid1.RowCount - 1].Clear;
     StringGrid1.RowCount := StringGrid1.RowCount - 2;
     StringGrid1.Visible:=true;
   end;

end;

procedure TWSelect.SpeedButton2Click(Sender: TObject);
begin
 WeightName :='none';
 close;
end;

procedure TWSelect.SpeedButton3Click(Sender: TObject);
var
 I:Integer;
begin

 if WeightList = nil then Weightlist:=TStringList.Create
                      else WeightList.Clear;

 If SelectedRow >= 0 then
 begin
  For I:=1 to Pred(StringGrid1.ColCount) do
  begin
   WeightList.Add(StringGrid1.Cells[I,0]);
   WeightList.Add(StringGrid1.Cells[I,SelectedRow])
  end;
  WeightName := StringGrid1.Cells[0,SelectedRow];

  ModalResult := mrOK;
 end
 else
  ShowMessage (' Please first select one weight..');

end;
end.

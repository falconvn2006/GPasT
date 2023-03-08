unit FIDHum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DB, DBTables, HumDb, MudUtil, HUtil32, Grids;

type
  TFrmIDHum = class(TForm)
    Query1:     TQuery;
    Label1:     TLabel;
    Edit1:      TEdit;
    Edit2:      TEdit;
    Label3:     TLabel;
    EdChrName:  TEdit;
    Label4:     TLabel;
    Label5:     TLabel;
    BtnCreateChr: TSpeedButton;
    BtnEraseChr: TSpeedButton;
    BtnChrNameSearch: TSpeedButton;
    IdGrid:     TStringGrid;
    ChrGrid:    TStringGrid;
    BtnSelAll:  TSpeedButton;
    CbShowDelChr: TCheckBox;
    BtnDeleteChr: TSpeedButton;
    BtnRevival: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Button1:    TButton;
    Label2:     TLabel;
    EdUserId:   TEdit;
    BtnDeleteChrAllInfo: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure EdUserIdKeyPress(Sender: TObject; var Key: char);
    procedure EdChrNameKeyPress(Sender: TObject; var Key: char);
    procedure BtnChrNameSearchClick(Sender: TObject);
    procedure BtnSelAllClick(Sender: TObject);
    procedure BtnEraseChrClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ChrGridClick(Sender: TObject);
    procedure ChrGridDblClick(Sender: TObject);
    procedure BtnDeleteChrClick(Sender: TObject);
    procedure BtnRevivalClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnCreateChrClick(Sender: TObject);
    procedure BtnDeleteChrAllInfoClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    procedure DoHumConvert;
    function MakeHumStr(idx: integer; rcd: FHumRcd): string;
  public
  end;

var
  FrmIDHum: TFrmIDHum;

implementation

uses
  DBSMain, CreateId, CreateChr, viewrcd, MFdbDef, FDBexpl, FSMemo, FeeUtil,
  CliMain;

{$R *.DFM}


procedure TFrmIDHum.FormCreate(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';
  with IdGrid do begin
    Cells[0, 0] := 'ID';
    Cells[1, 0] := 'Password';
    Cells[2, 0] := 'UserName';
    Cells[3, 0] := 'SSNo';
    Cells[4, 0] := 'Telephone';
    Cells[5, 0] := 'Password';
    Cells[6, 0] := 'User addr.';
    Cells[7, 0] := 'Memo';
  end;
  with ChrGrid do begin
    Cells[0, 0] := 'Index';
    Cells[1, 0] := 'chr. name';
    Cells[2, 0] := 'ID';
    Cells[3, 0] := 'del';
    Cells[4, 0] := 'del date';
    Cells[5, 0] := 'del change';
  end;
end;

procedure TFrmIDHum.DoHumConvert;
var
  i, success, fail: integer;
  fhum: FHumRcd;
begin
  if FrmDBSrv.FDBLoading then
    exit;
  with Query1 do begin
    Close;
    SQL.Clear;
    SQL.Add('select * from Human_Tbl');
    try
      Open;
    except
      ShowMessage('Error..');
      exit;
    end;
    success := 0;
    fail    := 0;
    FillChar(fhum, sizeof(FHumRcd), #0);
    try
      if FHumDB.OpenWr then begin
        for i := 0 to RecordCount - 1 do begin
          fhum.Block.ChrName := FieldByName('NAME').AsString;
          fhum.Block.UserId := FieldByName('USER_ID').AsString;
          fhum.Block.Delete := FieldByName('DEL_MARK').AsBoolean;
          fhum.Block.DeleteDate :=
            PackDouble(ShortDateToDate(FieldByName('DEL_DATE').AsString));
          fhum.Block.Mark := 0;
          fhum.Key := fhum.Block.ChrName;
          if fhum.Key <> '' then begin
            if FHumDb.AddRecord(fhum) then
              Inc(success)
            else
              Inc(fail);
            if (i mod 100) = 0 then begin
              Label1.Caption := IntToStr(success) + '/' + IntToStr(fail);
              Application.ProcessMessages;
            end;
          end;
          Next;
        end;
      end;
    finally
      FHumDB.Close;
    end;
    Close;
  end;
  Label1.Caption := IntToStr(success) + '/' + IntToStr(fail);
end;

procedure TFrmIDHum.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then begin
    if Edit2.Text = 'humconvert' then begin
      Edit2.Text := '';
      DoHumConvert;
    end;
    Edit2.Text := '';
  end;
end;

procedure TFrmIDHum.EdUserIdKeyPress(Sender: TObject; var Key: char);
var
  i, idx: integer;
  uid:    string;
  flist:  TStringList;
  rcd:    FhumRcd;
begin
  if Key = #13 then begin
    Key := #0;
    uid := Trim(EdUserId.Text);
    ChrGrid.RowCount := 1;
    if uid = '' then
      exit;
    flist := TStringList.Create;
    with FHumDb do begin
      try
        if OpenRd then begin
          FindUserId(uid, flist);
          for i := 0 to flist.Count - 1 do begin
            idx := PTIdInfo(flist.Objects[i]).ridx;
            if idx >= 0 then begin
              GetRecordDr(idx, rcd);
              MakehumStr(idx, rcd);
            end;
          end;
        end;
      finally
        Close;
      end;
    end;
    flist.Free;
  end;
end;

function TFrmIDHum.MakeHumStr(idx: integer; rcd: FHumRcd): string;
var
  n: integer;
begin
  ChrGrid.RowCount := ChrGrid.RowCount + 1;
  ChrGrid.FixedRows := 1;
  n := ChrGrid.RowCount - 1;
  with ChrGrid do begin
    Cells[0, n] := IntToStr(idx);
    Cells[1, n] := rcd.Block.ChrName;
    Cells[2, n] := rcd.Block.UserId;
    Cells[3, n] := BoolToStr(rcd.Block.Delete);
    if rcd.Block.Delete then
      Cells[4, n] := DateToStr(SolveDouble(rcd.Block.DeleteDate))
    else
      Cells[4, n] := '';
    Cells[5, n] := IntToStr(rcd.Block.Mark);
  end;
end;

procedure TFrmIDHum.EdChrNameKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then begin
    Key := #0;
    BtnChrNameSearchClick(self);
  end;
end;

procedure TFrmIDHum.BtnChrNameSearchClick(Sender: TObject);
var
  i, idx, ridx: integer;
  uname: string;
  rcd:   FhumRcd;
begin
  uname := Trim(EdChrName.Text);
  ChrGrid.RowCount := 1;
  with FHumDb do begin
    try
      if OpenRd then begin
        idx := Find(uname);
        if idx >= 0 then begin
          ridx := GetRecord(idx, rcd);
          if ridx >= 0 then begin
            MakehumStr(ridx, rcd);
          end;
        end;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TFrmIDHum.BtnSelAllClick(Sender: TObject);
var
  i, idx:  integer;
  uname:   string;
  rcd:     FhumRcd;
  strlist: TStringList;
begin
  uname   := Trim(EdChrName.Text);
  ChrGrid.RowCount := 1;
  strlist := TStringList.Create;
  with FHumDb do begin
    try
      if OpenRd then begin
        if FindLike(uname, strlist) > 0 then begin
          for i := 0 to strlist.Count - 1 do begin
            idx := integer(strlist.Objects[i]);
            if GetRecordDr(idx, rcd) then begin
              MakehumStr(idx, rcd);
            end;
          end;
        end;
      end;
    finally
      Close;
    end;
  end;
  strlist.Free;
end;

procedure TFrmIDHum.BtnEraseChrClick(Sender: TObject);
var
  uname: string;
  idx:   integer;
begin
  if EdChrName.Text = '' then
    exit;
  if MessageDlg(EdChrName.Text +
    ' : Would you want delete ? (this chracter link can not be recovered)',
    mtConfirmation, mbOkCancel, 0) = mrOk then begin
    uname := EdChrName.Text;
    try
      if FHumDB.OpenWr then
        FHumDb.Delete(uname);
    finally
      FHumDb.Close;
    end;
  end;
end;

procedure TFrmIDHum.BtnDeleteChrAllInfoClick(Sender: TObject);
var
  uname: string;
  idx:   integer;
begin
  if EdChrName.Text = '' then
    exit;
  if MessageDlg(EdChrName.Text +
    ' : Would you want to delete related all record ? (this character can not be recoverd)',
    mtConfirmation, mbOkCancel, 0) = mrOk then begin
    if MessageDlg(EdChrName.Text + ' : Really delete ?', mtConfirmation,
      mbOkCancel, 0) = mrOk then begin
      uname := EdChrName.Text;
      try
        if FHumDB.OpenWr then
          FHumDb.Delete(uname);
      finally
        FHumDb.Close;
      end;

      try
        if FDB.OpenWr then begin
          FDB.Delete(uname);
        end;
      finally
        FDB.Close;
      end;
    end;
  end;
end;

procedure TFrmIDHum.FormShow(Sender: TObject);
begin
  EdChrName.SetFocus;
end;

procedure TFrmIDHum.ChrGridClick(Sender: TObject);
var
  n: integer;
begin
  n := ChrGrid.Row;
  if n >= 1 then begin
    if n <= ChrGrid.RowCount - 1 then begin
      EdChrName.Text := ChrGrid.Cells[1, n];
    end;
  end;
end;

procedure TFrmIDHum.ChrGridDblClick(Sender: TObject);
var
  n, idx: integer;
  uname:  string;
  rcd:    FDBRecord;
begin
  n := ChrGrid.Row;
  if n >= 1 then begin
    if n <= ChrGrid.RowCount - 1 then begin
      uname := ChrGrid.Cells[1, n];
    end;
  end;
  try
    if Fdb.OpenRd then begin
      idx := Fdb.Find(uname);
      if idx >= 0 then begin
        if Fdb.GetRecord(idx, rcd) >= 0 then begin
          FrmFDBViewer.RecordIndex := idx;
          FrmFDBViewer.UserName := uname;
          FrmFDBViewer.VRcd := rcd; //UserData := rcd.Block;
          FrmFDBViewer.Show;
          FrmFDBViewer.Refresh;
        end;
      end;
    end;
  finally
    Fdb.Close;
  end;
end;

procedure TFrmIDHum.BtnDeleteChrClick(Sender: TObject);
var
  idx:    integer;
  uname:  string;
  humrcd: FHumRcd;
begin
  uname := EdChrName.Text;
  if MessageDlg(uname + ' : Would you want to delete ?', mtConfirmation,
    mbOkCancel, 0) <> mrOk then
    exit;
  with FHumDB do begin
    try
      if OpenWr then begin
        idx := Find(uname);
        if idx >= 0 then begin
          GetRecord(idx, humrcd);
          humrcd.Block.Delete := True;
          humrcd.Block.DeleteDate := PackDouble(Date);
          humrcd.Block.Mark := humrcd.Block.Mark + 1;  //��ڰ� ����
          SetRecord(idx, humrcd);
        end;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TFrmIDHum.SpeedButton2Click(Sender: TObject);
var
  delidx: integer;
  uname:  string;
  humrcd: FHumRcd;
begin
  if ChrGrid.Row >= ChrGrid.RowCount then
    exit;
  delidx := Str_ToInt(ChrGrid.Cells[0, ChrGrid.Row], 0);
  uname  := EdChrName.Text;
  if MessageDlg('[Caution]' + IntToStr(delidx) +
    ' : Would you want to delete this number ?', mtConfirmation,
    mbOkCancel, 0) <> mrOk then
    exit;
  with FHumDB do begin
    try
      if OpenWr then begin
        if GetRecordDr(delidx, humrcd) then begin
          //if humrcd.Key = uname then begin
          humrcd.Block.Delete := True;
          humrcd.Block.DeleteDate := PackDouble(Date);
          humrcd.Block.Mark := humrcd.Block.Mark + 1;  //��ڰ� ����
          SetRecordDr(delidx, humrcd);
        end;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TFrmIDHum.BtnRevivalClick(Sender: TObject);
var
  idx:    integer;
  uname:  string;
  humrcd: FHumRcd;
begin
  uname := EdChrName.Text;
  if MessageDlg(uname + ' : Would you want to restore ?', mtConfirmation,
    mbOkCancel, 0) <> mrOk then
    exit;
  with FHumDB do begin
    try
      if OpenWr then begin
        idx := Find(uname);
        if idx >= 0 then begin
          GetRecord(idx, humrcd);
          humrcd.Block.Delete := False;
          //humrcd.Block.DeleteDate := Date;
          humrcd.Block.Mark   := humrcd.Block.Mark + 1;  //��ڰ� ����
          SetRecord(idx, humrcd);
        end;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TFrmIDHum.SpeedButton1Click(Sender: TObject);
begin
  FrmFDBExplore.Show;
end;

procedure TFrmIDHum.Button1Click(Sender: TObject);
begin
  FrmAccServer.LoadIdPasswd;
end;

procedure TFrmIDHum.BtnCreateChrClick(Sender: TObject);
var
  error: integer;
  fhum:  FHumRcd;
begin
  if FrmCreateChr.Execute then begin
    error := 0;
    with FHumDB do begin
      try
        if OpenWr then begin
          if FindUserIdCount(FrmCreateChr.UserId) < 2 then begin
            fhum.Block.ChrName := FrmCreateChr.ChrName;
            fhum.Block.UserId := FrmCreateChr.UserId;
            fhum.Block.Delete := False;
            fhum.Block.Mark := 0;
            fhum.Key := FrmCreateChr.ChrName;
            if fhum.Key <> '' then begin
              if not AddRecord(fhum) then
                error := 2; //already exists
            end;
          end else
            error := 3;
        end;
      finally
        Close;
      end;
    end;
    if error = 0 then
      ShowMessage('It created correctly.')
    else
      ShowMessage('creation fail !!');
  end;
end;

end.

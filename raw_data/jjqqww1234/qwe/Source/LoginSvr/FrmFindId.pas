unit FrmFindId;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, IDDb, Grobal2, HUtil32;

type
  TFrmFindUserId = class(TForm)
    IdGrid:     TStringGrid;
    Panel1:     TPanel;
    EdFindId:   TEdit;
    Label1:     TLabel;
    BtnFindAll: TButton;
    Button1:    TButton;
    BtnEdit:    TButton;
    Button2:    TButton;
    procedure EdFindIdKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure BtnFindAllClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    function MakeHumStr(nrow: integer; rcd: FIdRcd): string;
  public
  end;

var
  FrmFindUserId: TFrmFindUserId;

implementation

{$R *.DFM}

uses
  LMain, MasSock, EditUserInfo;

procedure TFrmFindUserId.FormCreate(Sender: TObject);
var
  i: integer;
begin
  IdGrid.RowCount := 2;
  with IdGrid do begin
    Cells[0, 0]  := 'ID';
    Cells[1, 0]  := 'Passwd';
    Cells[2, 0]  := 'UserName';
    Cells[3, 0]  := 'SSNo';     //�ֹε�Ϲ�ȣ
    Cells[4, 0]  := 'Birthday'; //����
    Cells[5, 0]  := 'Quiz1';
    Cells[6, 0]  := 'Answer1';
    Cells[7, 0]  := 'Quiz2';
    Cells[8, 0]  := 'Answer2';
    Cells[9, 0]  := 'Phone';
    Cells[10, 0] := 'MobilePhone';
    Cells[11, 0] := 'Memo-1';
    Cells[12, 0] := 'Memo-2';
    Cells[13, 0] := 'Create Date';    //ó�� ���� �ð�
    Cells[14, 0] := 'Latest Access';  //�ֱ� ���� �ð�
    Cells[15, 0] := 'E-Mail';
  end;

end;

function TFrmFindUserId.MakeHumStr(nrow: integer; rcd: FIdRcd): string;
var
  n: integer;
begin
  if nrow <= 0 then begin
    IdGrid.RowCount := IdGrid.RowCount + 1;
    IdGrid.FixedRows := 1;
    n := IdGrid.RowCount - 1;
  end else
    n := nrow;
  with IdGrid do begin
    Cells[0, n]  := rcd.Block.UInfo.LoginId;
    Cells[1, n]  := rcd.Block.UInfo.Password;
    Cells[2, n]  := rcd.Block.UInfo.UserName;
    Cells[3, n]  := rcd.Block.UInfo.SSNo;
    Cells[4, n]  := rcd.Block.UAdd.BirthDay;
    Cells[5, n]  := rcd.Block.UInfo.Quiz;
    Cells[6, n]  := rcd.Block.UInfo.Answer;
    Cells[7, n]  := rcd.Block.UAdd.Quiz2;
    Cells[8, n]  := rcd.Block.UAdd.Answer2;
    Cells[9, n]  := rcd.Block.UInfo.Phone;
    Cells[10, n] := rcd.Block.UAdd.MobilePhone;
    Cells[11, n] := rcd.Block.UAdd.Memo1;
    Cells[12, n] := rcd.Block.UAdd.Memo2;
    Cells[13, n] := DateTimeToStr(SolveDouble(rcd.MakeRcdDateTime));
    Cells[14, n] := DateTimeToStr(SolveDouble(rcd.UpdateDateTime));
    Cells[15, n] := rcd.Block.UInfo.EMail;
  end;
end;

procedure TFrmFindUserId.EdFindIdKeyPress(Sender: TObject; var Key: char);
var
  idx:  integer;
  uid:  string;
  ircd: FIdRcd;
begin
  if Key = #13 then begin
    Key := #0;
    IdGrid.RowCount := 1;
    uid := Trim(EdFindId.Text);
    if uid = '' then
      exit;
    with FIdDb do begin
      try
        if OpenWr then begin
          idx := Find(uid);
          if idx >= 0 then begin
            if GetRecord(idx, ircd) >= 0 then begin
              MakeHumStr(-1, ircd);
            end;
          end;
        end;
      finally
        Close;
      end;
    end;
  end;
end;

procedure TFrmFindUserId.BtnFindAllClick(Sender: TObject);
var
  i, idx: integer;
  uid:    string;
  flist:  TStringList;
  ircd:   FIdRcd;
begin
  IdGrid.RowCount := 1;
  uid := Trim(EdFindId.Text);
  if uid = '' then
    exit;
  flist := TStringList.Create;
  with FIdDb do begin
    try
      if OpenWr then begin
        FindLike(uid, flist);
        for i := 0 to flist.Count - 1 do begin
          idx := integer(flist.Objects[i]);
          if idx >= 0 then begin
            GetRecordDr(idx, ircd);
            MakeHumStr(-1, ircd);
          end;
        end;
      end;
    finally
      Close;
    end;
  end;
  flist.Free;
end;

procedure TFrmFindUserId.Button1Click(Sender: TObject);
begin
  FrmMasSoc.LoadServerAddrs;
end;

procedure TFrmFindUserId.BtnEditClick(Sender: TObject);
var
  i, n, idx: integer;
  ircd: FIdRcd;
  uid: string;
  flag, bosuccess: boolean;
  ue:  TUserEntryInfo;
  ua:  TUserEntryAddInfo;
begin
  n := IdGrid.Row;
  if n <= 0 then
    exit;
  uid := IdGrid.Cells[0, n];
  if uid = '' then
    exit;

  bosuccess := False;
  with FIdDb do begin
    flag := False;
    try
      if OpenRd then begin
        idx := Find(uid);
        if idx >= 0 then begin
          if GetRecord(idx, ircd) >= 0 then begin
            flag := True;
          end;
        end;
      end;
    finally
      Close;
    end;

    if FrmUserInfoEdit.Execute(ircd) then begin
      try
        if OpenWr then begin
          idx := Find(uid);
          if idx >= 0 then begin
            if SetRecord(idx, ircd) then begin
              ue := ircd.Block.UInfo;
              ua := ircd.Block.UAdd;
              MakeHumStr(n, ircd);
              bosuccess := True;
            end;
          end;
        end;
      finally
        Close;
      end;
    end;
  end;
  if bosuccess then
    FrmMain.WriteLog('ch2', ue, ua);
end;

procedure TFrmFindUserId.Button2Click(Sender: TObject);
var
  i, n, idx: integer;
  ircd: FIdRcd;
  uid: string;
  flag, bosuccess: boolean;
  ue:  TUserEntryInfo;
  ua:  TUserEntryAddInfo;
begin
  FillChar(ircd, sizeof(FIdRcd), #0);
  bosuccess := False;
  if FrmUserInfoEdit.ExecuteEdit(True, ircd) then begin
    if ircd.Block.UInfo.LoginId <> '' then begin
      uid      := ircd.Block.UInfo.LoginId;
      ircd.Key := uid;
      with FIdDb do begin
        try
          if OpenWr then begin
            idx := Find(uid);
            if idx < 0 then begin
              ircd.Key := uid;
              if ircd.Key <> '' then begin
                if AddRecord(ircd) then
                  bosuccess := True;
              end;
            end;
          end;
        finally
          Close;
        end;
      end;
    end;
  end;
  if bosuccess then begin
    FrmMain.Memo1.Lines.Add('Making id success : ' + uid);
    FrmMain.WriteLog('ch2', ue, ua);
  end;
end;

end.

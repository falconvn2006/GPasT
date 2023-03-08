unit FeeDb;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, HUtil32, FileCtrl, Grobal2, MudUtil, MfdbDef;

type
  TFeeInfo = record
    Valid: boolean;
    UserKey: string[15];    //userid or 210.121.121.121
    GroupKey: string[30];   //PC�� �̸�
    OwnerName: string[10];
    AccountMode: byte;      //0: ����, 1: ����, 2:����,
    DupCount: word;
    EntryDate: TDateTime;   //�����
    NCount: integer;        //������¥
    EnableDate: TDateTime;  //��밡�� ����
    Memo: string[20];
  end;

  FFeeRcd = record
    Deleted: boolean; {delete mark}
    UpdateDateTime: TDateTime;
    Key:     string[15];
    Block:   TFeeInfo;
  end;
  PFFeeRcd = ^FFeeRcd;

  FFeeRcdInfo = record
    Deleted: boolean; {delete mark}
    UpdateDateTime: TDateTime;
    Key:     string[15];
    NextSpace: integer;
  end;
  PFFeeRcdInfo = ^FFeeRcdInfo;

  FDBTemp = record
    Deleted: boolean; {delete mark}
    UpdateDateTime: TDateTime;
    Key:     string[15];
  end;
  PFDBTemp = ^FDBTemp;

  FDBHeader = record
    Title:      string[100];
    MaxCount:   integer; {record count}
    BlockSize:  integer; {record unit size}
    FirstSpace: integer; {first space record position}
    UpdateDateTime: TDateTime;
  end;
  PFDBHeader = ^FDBHeader;

  TFileFeeDB = class
  private
    CurIndex:   integer;
    FirstSpace: integer;
    fhandle:    integer;
    FRefresh:   TNotifyEvent;
    Updated:    boolean;
    function ReadRecord(index: integer; var rcd: FFeeRcd): boolean;
    function FindBlankRecord: integer;
    function WriteRecord(index: integer; rcd: FFeeRcd; asnew: boolean): boolean;
    function SetRecordDate(index: integer; setdate: TDateTime): boolean; // curtion..
    function DeleteRecord(index: integer): boolean;
  public
    DBHeader:   FDBHeader;
    FeeIndex:   TQuickList; {username + data position}
    GroupIndex: TQuickIdList;
    DBFileName: string;
    constructor Create(flname: string);
    destructor Destroy; override;
    procedure BuildIndex;
    procedure ReBuild;
    procedure LockDB;
    procedure UnlockDB;
    function OpenRd: boolean;
    function OpenWr: boolean;
    procedure Close;
    function First: integer;
    function Next: integer;
    function Prior: integer;
    function Get(var rcd: FFeeRcd): integer;
    function Delete(uname: string): boolean;
    procedure GetBlankList(blist: TStrings);
    function GetRecordCount: integer;
    function GetRecord(index: integer; var rcd: FFeeRcd): integer;
    function GetRecordDr(index: integer; var rcd: FFeeRcd): boolean;
    function SetRecord(index: integer; rcd: FFeeRcd): boolean;
    function SetRecordDr(index: integer; rcd: FFeeRcd): boolean;
    function SetRecordTime(index: integer; settime: TDateTime): boolean;
    function AddRecord(rcd: FFeeRcd): boolean;
    function Find(uname: string): integer; {find by name only/find from index table}
    function FindLike(uname: string; flist: TStrings): integer; {found count}
    function FindByGroupKey(gkey: string; flist: TStrings): integer; {found count}
    function FindLikeByGroupKey(gkey: string; flist: TStrings): integer;
    {found count}
    function FindRecord(uname: string; var rcd: FFeeRcd): boolean;
    function CheckValidDate(var rcd: FFeeRcd): boolean;
    function GetDBUpdateDateTime(dbname: string): TDateTime;
    procedure UpdateDBTime(dbname: string);
    function DBSaveAs(dbname, targname: string; backuptime: integer): boolean;
    function GetRcdFromFile(dbfile, uname: string; idx: integer;
      var rcd: FFeeRcd): boolean;
  published
    property OnRefresh: TNotifyEvent Read FRefresh Write FRefresh;
  end;

var
  CurFeeLoading, ValidFeeLoading, MaxFeeLoading: integer;
  FeeLoaded: boolean;

implementation


constructor TFileFeeDB.Create(flname: string);
begin
  CurIndex      := 0;
  DBFileName    := flname;
  FeeIndex      := TQuickList.Create;
  FeeIndex.CaseSensitive := True;
  GroupIndex    := TQuickIdList.Create;
  CurFeeLoading := 0;
  MaxFeeLoading := 0;
  FeeLoaded     := False;
  BuildIndex;
end;

destructor TFileFeeDB.Destroy;
begin
  FeeIndex.Free;
  GroupIndex.Free;
  //   FIndex.Free;
end;

procedure TFileFeeDB.LockDB;
begin
  EnterCriticalSection(CSDBLock);
end;

procedure TFileFeeDB.UnlockDB;
begin
  LeaveCriticalSection(CSDBLock);
end;

function TFileFeeDB.OpenRd: boolean;
var
  header: FDBHeader;
begin
  LockDB;
   {$I-}
  Updated := False;
  fhandle := FileOpen(DBFileName, fmOpenRead or fmShareDenyNone);
  if fhandle > 0 then begin
    Result := True;
    if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then
      DBHeader := header;
    CurIndex := 0;
  end else
    Result := False;
end;

function TFileFeeDB.OpenWr: boolean;
var
  header: FDBHeader;
begin
  LockDB;
   {$I-}
  CurIndex := 0;
  Updated  := False;
  if FileExists(DBFileName) then begin
    fhandle := FileOpen(DBFileName, fmOpenReadWrite or fmShareDenyNone);
    if fhandle > 0 then
      FileRead(fhandle, DBHeader, sizeof(FDBHeader));
  end else begin
    fhandle      := FileCreate(DBFileName);
    header.Title := 'legend of mir database file 1999/1';
    header.MaxCount := 0;
    header.BlockSize := 0;
    header.FirstSpace := -1;
    FileWrite(fhandle, header, sizeof(FDBHeader));
  end;
  if fhandle > 0 then
    Result := True
  else
    Result := False;
end;

procedure TFileFeeDB.Close;
begin
  FileClose(fhandle);
   {$I+}
  if Updated then begin
    if Assigned(FRefresh) then
      FRefresh(self);
  end;
  UnlockDB;
end;

procedure TFileFeeDB.BuildIndex;
var
  i, j, curidx, oldpos: integer;
  rcd:     FFeeRcd;
  header:  FDBHeader;
  rcdinfo: FFeeRcdInfo;
begin
  CurIndex   := 0;
  FirstSpace := -1;
  FeeIndex.Clear;
  GroupIndex.Clear;
  curidx := 0;
  CurFeeLoading := 0;
  ValidFeeLoading := 0;
  MaxFeeLoading := 0;
  try
    if OpenWr then begin
      FileSeek(fhandle, 0, 0);
      if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        MaxFeeLoading := header.MaxCount;
        for i := 0 to header.MaxCount - 1 do begin
          Inc(CurFeeLoading);
          if FileRead(fhandle, rcd, sizeof(FFeeRcd)) = sizeof(FFeeRcd) then begin
            if not rcd.Deleted then begin
              FeeIndex.QAddObject(rcd.Key, TObject(curidx));
              GroupIndex.QAdd(rcd.Block.GroupKey, rcd.Block.UserKey, curidx);
              Inc(ValidFeeLoading);
            end else begin
              oldpos := FileSeek(fhandle, 0, 1);
              FileSeek(fhandle, -sizeof(FFeeRcd), 1);
              FileRead(fhandle, rcdinfo, sizeof(FFeeRcdInfo));
              FileSeek(fhandle, -sizeof(FFeeRcdInfo), 1);
              rcdinfo.NextSpace := FirstSpace;
              FirstSpace := curidx;
              FileWrite(fhandle, rcdinfo, sizeof(FFeeRcdInfo));
              FileSeek(fhandle, oldpos, 0);
            end;
          end else
            break;
          Inc(curidx);
          Application.ProcessMessages;
          if Application.Terminated then begin
            Close;
            exit;
          end;
        end;
      end;
    end;
  finally
    Close;
  end;
  FeeLoaded := True;
end;

procedure TFileFeeDB.Rebuild;
var
  tempfile: string;
  fh, total: integer;
  header: FDBHeader;
  rcd: FFeeRcd;
begin
  tempfile := 'Mir#$00.DB';
  if FileExists(tempfile) then
    DeleteFile(tempfile);
  fh    := FileCreate(tempfile);
  total := 0;
  if fh > 0 then begin
    try
      if OpenWr then begin
        FileSeek(fhandle, 0, 0);
        if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then
        begin
          FileWrite(fh, header, sizeof(FDBHeader));
          while True do begin
            if FileRead(fhandle, rcd, sizeof(FFeeRcd)) = sizeof(FFeeRcd) then
            begin
              if not rcd.Deleted then begin
                FileWrite(fh, rcd, sizeof(FFeeRcd));
                Inc(total);
              end;
            end else
              break;
          end;
        end;
        header.MaxCount   := total;
        header.FirstSpace := -1;
        header.UpdateDateTime := Now;
        FileSeek(fh, 0, 0);
        FileWrite(fh, header, sizeof(FDBHeader));
      end;
    finally
      Close;
    end;
    FileClose(fh);
    FileCopy(tempfile, DBFileName);
    DeleteFile(tempfile);
  end;
  BuildIndex;
end;

function TFileFeeDB.First: integer;
begin
  CurIndex := 0;
  Result   := CurIndex;
end;

function TFileFeeDB.Next: integer;
begin
  if CurIndex < GetRecordCount - 1 then
    Inc(CurIndex);
  Result := CurIndex;
end;

function TFileFeeDB.Prior: integer;
begin
  if CurIndex >= 0 then
    Dec(CurIndex);
  Result := CurIndex;
end;

function TFileFeeDB.Get(var rcd: FFeeRcd): integer;
begin
  //FileRead (fhandle, rcd, sizeof(FFeeRcd));
  //FileSeek (fhandle, - sizeof(FFeeRcd), 1);
  Result := 0;
end;

 {private}
 {���� ����� ���ڵ��ȣ ����, ������ -1}
 {index is must zero or lager then zero}
function TFileFeeDB.DeleteRecord(index: integer): boolean;
var
  oldpos:  integer;
  rcdinfo: FFeeRcdInfo;
begin
  Result := False; //Error;
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FFeeRcd) * index, 0) <> -1 then begin
    rcdinfo.Deleted := True;
    rcdinfo.UpdateDateTime := now;
    rcdinfo.NextSpace := FirstSpace;
    FirstSpace := index;
    FileWrite(fhandle, rcdinfo, sizeof(FFeeRcdInfo));

    DBHeader.FirstSpace     := FirstSpace;
    DBHeader.UpdateDateTime := Now;
    FileSeek(fhandle, 0, 0);
    FileWrite(fhandle, DBHeader, sizeof(FDBHeader));
    Updated := True;

    Result := True;
  end;
end;

function TFileFeeDB.Delete(uname: string): boolean;
var
  n, m, idx: integer;
  rcd:  FFeeRcd;
  temp: TList;
begin
  Result := False;
  n      := FeeIndex.FFind(uname);
  if n >= 0 then begin
    GetRecord(n, rcd);
    idx := integer(FeeIndex.Objects[n]);
    if DeleteRecord(idx) then begin
      FeeIndex.Delete(n);
      Result := True;
    end;
    m := GroupIndex.FFind(rcd.Block.GroupKey, temp);
    if m >= 0 then begin
      GroupIndex.DDelete(m, rcd.Block.UserKey);
    end;
  end;
end;

procedure TFileFeeDB.GetBlankList(blist: TStrings);
var
  fspace, i: integer;
  rcdinfo:   FFeeRcdInfo;
begin
  fspace := FirstSpace;
  for i := 0 to 10000000 do begin
    if fspace = -1 then
      break;
    blist.Add(IntToStr(fspace));
    FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FFeeRcd) * fspace, 0);
    if FileRead(fhandle, rcdinfo, sizeof(FFeeRcdInfo)) = sizeof(FFeeRcdInfo) then
    begin
      fspace := rcdinfo.NextSpace;
    end else
      fspace := -1;
  end;
end;

function TFileFeeDB.GetRecordCount: integer;
begin
  Result := FeeIndex.Count;
end;

function TFileFeeDB.ReadRecord(index: integer; var rcd: FFeeRcd): boolean;
begin
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FFeeRcd) * index, 0) <> -1 then begin
    FileRead(fhandle, rcd, sizeof(FFeeRcd));
    FileSeek(fhandle, -sizeof(FFeeRcd), 1);
    CurIndex := index;
    Result   := True;
  end else
    Result := False;
end;

function TFileFeeDB.SetRecordDate(index: integer; setdate: TDateTime): boolean;
var
  opos:    integer;
  rcdinfo: FFeeRcdInfo;
begin
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FFeeRcd) * index, 0) <> -1 then begin
    opos := FileSeek(fhandle, 0, 1);
    if FileRead(fhandle, rcdinfo, sizeof(FFeeRcdInfo)) = sizeof(FFeeRcdInfo) then
    begin
      rcdinfo.UpdateDateTime := setdate;
      FileSeek(fhandle, opos, 0);
      FileWrite(fhandle, rcdinfo, sizeof(FFeeRcdInfo));
    end;
    Updated := True;
    Result  := True;
  end else
    Result := False;
end;

function TFileFeeDB.FindBlankRecord: integer;
var
  icount:  integer;
  rcdinfo: FFeeRcdInfo;
begin
  icount := 0;
  FileSeek(fhandle, sizeof(FDBHeader), 0);
  while True do begin
    if FileRead(fhandle, rcdinfo, sizeof(FFeeRcdInfo)) = sizeof(FFeeRcdInfo) then
    begin
      if rcdinfo.Deleted then
        Result := icount;
    end else begin
      icount := -1;
      break;
    end;
    Inc(icount);
  end;
  Result := icount;
end;

function TFileFeeDB.WriteRecord(index: integer; rcd: FFeeRcd; asnew: boolean): boolean;
var
  opos, rpos: integer;
  rcdinfo:    FFeeRcdInfo;
begin
  rpos := sizeof(FDBHeader) + sizeof(FFeeRcd) * index;
  if FileSeek(fhandle, rpos, 0) = rpos then begin
    opos := FileSeek(fhandle, 0, 1);
    if asnew then begin //�߰�
      if FileRead(fhandle, rcdinfo, sizeof(FFeeRcdInfo)) = sizeof(FFeeRcdInfo) then
      begin
        if rcdinfo.Deleted then begin
          FirstSpace := rcdinfo.NextSpace;
        end else begin
          FirstSpace := -1;
          Result     := True;
          exit;
        end;
      end;
    end;
    rcd.Deleted := False;
    rcd.UpdateDateTime := now;
    DBHeader.FirstSpace := FirstSpace;
    DBHeader.UpdateDateTime := Now;
    FileSeek(fhandle, 0, 0);
    FileWrite(fhandle, DBHeader, sizeof(FDBHeader));
    FileSeek(fhandle, opos, 0);
    FileWrite(fhandle, rcd, sizeof(FFeeRcd));
    FileSeek(fhandle, -sizeof(FFeeRcd), 1);
    CurIndex := index;
    Updated  := True;
    Result   := True;
  end else
    Result := False;
end;

{ used with 'Find' }
function TFileFeeDB.GetRecord(index: integer; var rcd: FFeeRcd): integer;
var
  idx: integer;
begin
  idx := integer(FeeIndex.Objects[index]);
  if ReadRecord(idx, rcd) then
    Result := idx
  else
    Result := -1;
end;

{���� �ȵ�... ���� �ݵ�� Ȯ���� ��}
function TFileFeeDB.GetRecordDr(index: integer; var rcd: FFeeRcd): boolean;
begin
  if (index >= 0) then ////and (index < FeeIndex.Count) then
    Result := ReadRecord(Index, rcd)
  else
    Result := False;
end;

function TFileFeeDB.SetRecordTime(index: integer; settime: TDateTime): boolean;
begin
  Result := SetRecordDate(integer(FeeIndex.Objects[index]), settime);
end;

 { used with 'Find' }
 { SetRecord�� �߰��� �ǹ̷δ� ����ؼ��� �ȵȴ�. }
 { Key�� �ٲ� �� ����. }
function TFileFeeDB.SetRecord(index: integer; rcd: FFeeRcd): boolean;
begin
  Result := False;
  if (index < 0) or (index >= FeeIndex.Count) then
    exit;
   {**���� i := FeeIndex.Find (rcd.Key);
   if i >= 0 then begin
      if i <> index then begin
         Result := FALSE;
         exit;
      end;
   end;**}

   {flag := TRUE;
   if ReadRecord (Integer (FeeIndex.Objects[index]), orcd) then begin
      if rcd.Block.DBHuman.Abilitys.Level = orcd.Block.DBHuman.Abilitys.Level then
         flag := FALSE;
   end;}
  if WriteRecord(integer(FeeIndex.Objects[index]), rcd, False) then begin
    Result := True;
    ///FeeIndex[index] := rcd.Key; <= Ű�� �ٲ� �� ����.
      {if flag then
         with FIndex do begin
            try
               if OpenWr then begin
                  UpdateIndex (rcd.Key, Integer (FeeIndex.Objects[index]), rcd.Block.DBHuman.Abilitys.Level);
               end;
            finally
               Close;
            end;
         end;}
  end;
end;

function TFileFeeDB.SetRecordDr(index: integer; rcd: FFeeRcd): boolean;
begin
  Result := False;
  if WriteRecord(index, rcd, False) then begin
    Result := True;
  end;
end;

 { �ݵ�� �߰��� �ǹ̷θ� ���ȴ�. }
 { ���� Key�� ����� �� ����. }
function TFileFeeDB.AddRecord(rcd: FFeeRcd): boolean;
var
  i:      integer;
  rcdpos: integer;
  oldheader: FDBHeader;
begin
  if FeeIndex.FFind(rcd.Key) >= 0 then begin
    Result := False;
    exit;
  end;
  oldheader := DBHeader;
  if FirstSpace = -1 then begin
    rcdpos := DBHeader.MaxCount;
    DBHeader.MaxCount := DBHeader.MaxCount + 1;
  end else begin
    //���� ����� �� ������ ã�´�.
    rcdpos := FirstSpace;
  end;
  if WriteRecord(rcdpos, rcd, True) then begin
    FeeIndex.QAddObject(rcd.Key, TObject(rcdpos));
    GroupIndex.QAdd(rcd.Block.GroupKey, rcd.Block.UserKey, rcdpos);
      {with FIndex do begin
         try
            if OpenWr then begin
               AddIndex (rcd.Key, rcdpos, rcd.Block.DBHuman.Abilitys.Level);
            end;
         finally
            Close;
         end;
      end;}
    Result := True;
  end else begin
    DBHeader := oldheader;
    Result   := False;
  end;
end;

function TFileFeeDB.Find(uname: string): integer;
  {find by name only/find from index table}
begin
  Result := FeeIndex.FFind(uname);
end;

function TFileFeeDB.FindLike(uname: string; flist: TStrings): integer; {found count}
var
  i: integer;
begin
  Result := -1;
  for i := 0 to FeeIndex.Count - 1 do begin
    if CompareLStr(FeeIndex[i], uname, Length(uname)) or (uname = '*') then begin
      flist.AddObject(FeeIndex[i], FeeIndex.Objects[i]);
    end;
  end;
  Result := flist.Count;
end;

function TFileFeeDB.FindByGroupKey(gkey: string; flist: TStrings): integer;
  {found count}
var
  i:    integer;
  list: TList;
begin
  Result := -1;
  list   := nil;
  GroupIndex.FFind(gkey, list);
  if list <> nil then
    for i := 0 to list.Count - 1 do begin
      flist.AddObject(PTIdInfo(list[i]).uid, TObject(list[i]));
    end;
  Result := flist.Count;
end;

function TFileFeeDB.FindLikeByGroupKey(gkey: string; flist: TStrings): integer;
  {found count}
var
  i, j: integer;
  list: TList;
begin
  Result := 0;
  for i := 0 to GroupIndex.Count - 1 do begin
    if CompareLStr(GroupIndex[i], gkey, Length(gkey)) or (gkey = '*') then begin
      list := TList(GroupIndex.Objects[i]);
      for j := 0 to list.Count - 1 do
        flist.AddObject(PTIdInfo(list[j]).uid, TObject(list[j]));
    end;
  end;
  Result := flist.Count;
end;

function TFileFeeDB.FindRecord(uname: string; var rcd: FFeeRcd): boolean;
var
  i, index: integer;
begin
  Result := False;
  i      := FeeIndex.FFind(uname);
  if i >= 0 then begin
    index  := integer(FeeIndex.Objects[i]);
    Result := ReadRecord(index, rcd);
  end;
end;

function TFileFeeDB.CheckValidDate(var rcd: FFeeRcd): boolean;
begin
  rcd.Block.EnableDate := CalcDay(rcd.Block.EntryDate, rcd.Block.NCount);
  if (rcd.Block.EnableDate >= Date) or (rcd.Block.AccountMode = 2) then begin
    rcd.Block.Valid := True;
    Result := True;
  end else begin
    rcd.Block.Valid := False;
    Result := False;
  end;
end;

function TFileFeeDB.GetDBUpdateDateTime(dbname: string): TDateTime;
var
  i, fh:  integer;
  rcd:    FFeeRcd;
  header: FDBHeader;
begin
  fh     := 0;
  Result := 0;
  try
    fh := FileOpen(dbname, fmOpenRead or fmShareDenyNone);
    if fh > 0 then begin
      if FileRead(fh, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        Result := header.UpdateDateTime;
      end;
    end;
  finally
    if fh > 0 then
      FileClose(fh);
  end;
end;

procedure TFileFeeDB.UpdateDBTime(dbname: string);
var
  i, fh:  integer;
  rcd:    FFeeRcd;
  header: FDBHeader;
begin
  fh := FileOpen(dbname, fmOpenReadWrite or fmShareDenyNone);
  try
    if fh > 0 then begin
      if FileRead(fh, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        header.UpdateDateTime := Now;
        FileSeek(fh, 0, 0);
        FileWrite(fh, header, sizeof(FDBHeader));
      end;
    end;
  finally
    FileClose(fh);
  end;
end;

function TFileFeeDB.DBSaveAs(dbname, targname: string; backuptime: integer): boolean;
var
  utime: TDateTime;
begin
  Result := False;
  if (DBFileName <> targname) and FileExists(dbname) then begin
    if FileExists(targname) then begin
      utime := GetDBUpdateDateTime(targname);
      if TimeIsOut(utime, backuptime, 0) then begin
        //try
        //   LockDB;
        FileCopyEx(dbname, targname);
        //finally
        //   UnlockDB;
        //end;
        UpdateDBTime(targname);
        Result := True;
      end;
    end else begin
      //try
      //   LockDB;
      FileCopyEx(dbname, targname);
      //finally
      //   UnlockDB;
      //end;
      UpdateDBTime(targname);
      Result := True;
    end;
  end;
end;

function TFileFeeDB.GetRcdFromFile(dbfile, uname: string; idx: integer;
  var rcd: FFeeRcd): boolean;
var
  i:    integer;
  head: FDBHeader;
  temp: FDBTemp;
begin
  Result := False;
  if dbfile = DBFileName then
    exit;
  fhandle := FileOpen(dbfile, fmOpenRead or fmShareDenyNone);
  if fhandle > 0 then begin
    Result := True;
    if FileRead(fhandle, head, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
      if idx < head.MaxCount then begin
        idx := idx - 1;
        if idx < 0 then
          idx := 0;
      end;
      for i := idx to idx + 2 do begin
        if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FFeeRcd) * i, 0) <> -1 then
        begin
          if FileRead(fhandle, temp, sizeof(FDBTemp)) = sizeof(FDBTemp) then begin
            if temp.Key = uname then begin
              FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FFeeRcd) * i, 0);
              FileRead(fhandle, rcd, sizeof(FFeeRcd));
              Result := True;
              break;
            end;
          end;
        end;
      end;

    end;
  end;
end;

end.

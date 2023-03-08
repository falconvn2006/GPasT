unit HumDb;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, HUtil32, FileCtrl, Grobal2, MudUtil, MfdbDef;

type
  THumanInfo = record
    ChrName:  string[14]; //key
    UserId:   string[10];
    Delete:   boolean;
    DeleteDate: TDouble; //TDateTime;
    Mark:     byte;
    Selected: boolean;
    Demmy:    array[0..2] of byte;
  end;

  FHumRcd = record
    Deleted: boolean; {delete mark}
    UpdateDateTime: TDouble;
    Key:     string[14];
    Block:   THumanInfo;
  end;
  PFHumRcd = ^FHumRcd;

  FHumRcdInfo = record
    Deleted:  boolean; {delete mark}
    UpdateDateTime: TDouble;
    Key:      string[14];
    Reserved: integer; //NextSpace: integer;
  end;
  PFHumRcdInfo = ^FHumRcdInfo;

  FDBTemp = record
    Deleted: boolean; {delete mark}
    UpdateDateTime: TDouble;
    Key:     string[14];
  end;
  PFDBTemp = ^FDBTemp;

  FDBHeader = record
    Title:     string[100];
    MaxCount:  integer; {record count}
    BlockSize: integer; {record unit size}
    Reserved:  integer; //FirstSpace: integer; {first space record position}
    UpdateDateTime: TDouble;
  end;
  PFDBHeader = ^FDBHeader;

  TFileHumDB = class
  private
    CurIndex: integer;
    //FirstSpace: integer;
    fhandle:  integer;
    FRefresh: TNotifyEvent;
    Updated:  boolean;
    function ReadRecord(index: integer; var rcd: FHumRcd): boolean;
    //function  FindBlankRecord: integer;
    function WriteRecord(index: integer; rcd: FHumRcd; asnew: boolean): boolean;
    function SetRecordDate(index: integer; setdate: TDateTime): boolean; // curtion..
    function DeleteRecord(index: integer): boolean;
  public
    DBHeader:   FDBHeader;
    HumIndex:   TQuickList; {username + data position}
    UidIndex:   TQuickIdList;
    BlankList:  TList;
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
    function Get(var rcd: FHumRcd): integer;
    function Delete(uname: string): boolean;
    procedure GetBlankList(blist: TStrings);
    function GetRecordCount: integer;
    function GetRecord(index: integer; var rcd: FHumRcd): integer;
    function GetRecordDr(index: integer; var rcd: FHumRcd): boolean;
    function SetRecord(index: integer; rcd: FHumRcd): boolean;
    function SetRecordDr(index: integer; rcd: FHumRcd): boolean;
    function SetRecordTime(index: integer; settime: TDateTime): boolean;
    function AddRecord(rcd: FHumRcd): boolean;
    function Find(uname: string): integer; {find by name only/find from index table}
    function FindLike(uname: string; flist: TStrings): integer; {found count}
    function FindUserId(uid: string; flist: TStrings): integer; {found count}
    function FindUserIdCount(uid: string): integer; {found count}
    function FindRecord(uname: string; var rcd: FHumRcd): boolean;
    function GetDBUpdateDateTime(dbname: string): TDateTime;
    procedure UpdateDBTime(dbname: string);
    function DBSaveAs(dbname, targname: string; backuptime: integer): boolean;
    function GetRcdFromFile(dbfile, uname: string; idx: integer;
      var rcd: FHumRcd): boolean;
  published
    property OnRefresh: TNotifyEvent Read FRefresh Write FRefresh;
  end;

var
  CurHumLoading, ValidHumLoading, MaxHumLoading: integer;
  HumLoaded: boolean;

implementation


constructor TFileHumDB.Create(flname: string);
begin
  CurIndex      := 0;
  DBFileName    := flname;
  HumIndex      := TQuickList.Create;
  UidIndex      := TQuickIdList.Create;
  BlankList     := TList.Create;
  CurHumLoading := 0;
  MaxHumLoading := 0;
  HumLoaded     := False;
  BuildIndex;
end;

destructor TFileHumDB.Destroy;
begin
  HumIndex.Free;
  UidIndex.Free;
  BlankList.Free;
  //   FIndex.Free;
end;

procedure TFileHumDB.LockDB;
begin
  EnterCriticalSection(CSDBLock);
end;

procedure TFileHumDB.UnlockDB;
begin
  LeaveCriticalSection(CSDBLock);
end;

function TFileHumDB.OpenRd: boolean;
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

function TFileHumDB.OpenWr: boolean;
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
    //header.FirstSpace:= -1;
    FileWrite(fhandle, header, sizeof(FDBHeader));
  end;
  if fhandle > 0 then
    Result := True
  else
    Result := False;
end;

procedure TFileHumDB.Close;
begin
  FileClose(fhandle);
   {$I+}
  if Updated then begin
    if Assigned(FRefresh) then
      FRefresh(self);
  end;
  UnlockDB;
end;

procedure TFileHumDB.BuildIndex;
var
  i, j, curidx, oldpos: integer;
  rcd:      FHumRcd;
  header:   FDBHeader;
  rcdinfo:  FHumRcdInfo;
  idlist:   TStringList;
  namelist: TStringList;
begin
  CurIndex := 0;
  //FirstSpace := -1;
  HumIndex.Clear;
  UidIndex.Clear;
  BlankList.Clear;
  curidx   := 0;
  CurHumLoading := 0;
  ValidHumLoading := 0;
  MaxHumLoading := 0;
  idlist   := TStringList.Create;
  namelist := TStringList.Create;
  try
    if OpenWr then begin
      FileSeek(fhandle, 0, 0);
      if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        MaxHumLoading := header.MaxCount;
        for i := 0 to header.MaxCount - 1 do begin
          Inc(CurHumLoading);
          if FileRead(fhandle, rcd, sizeof(FHumRcd)) = sizeof(FHumRcd) then begin
            if not rcd.Deleted then begin
              HumIndex.AddObject(rcd.Key, TObject(curidx));
              //QAddObject (rcd.Key, TObject(curidx));
              //UidIndex.QAdd (rcd.Block.UserId, rcd.Block.ChrName, curidx);
              idlist.Add(rcd.Block.UserId);
              namelist.AddObject(rcd.Block.ChrName, TObject(curidx));
              Inc(ValidHumLoading);
            end else begin
              BlankList.Add(pointer(curidx));
                     {oldpos := FileSeek (fhandle, 0, 1);
                     FileSeek (fhandle, - sizeof(FHumRcd), 1);
                     FileRead (fhandle, rcdinfo, sizeof(FHumRcdInfo));
                     FileSeek (fhandle, - sizeof(FHumRcdInfo), 1);
                     rcdinfo.NextSpace := FirstSpace;
                     FirstSpace := curidx;
                     FileWrite (fhandle, rcdinfo, sizeof(FHumRcdInfo));
                     FileSeek (fhandle, oldpos, 0);
                     }
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
  for i := 0 to idlist.Count - 1 do begin
    UidIndex.QAdd(idlist[i], namelist[i], integer(namelist.Objects[i]));
    if i mod 100 = 0 then
      Application.ProcessMessages;
  end;
  idlist.Free;
  namelist.Free;
  QuickSortStrListNoCase(HumIndex, 0, HumIndex.Count - 1);
  HumLoaded := True;
end;

procedure TFileHumDB.Rebuild;
var
  tempfile: string;
  fh, total: integer;
  header: FDBHeader;
  rcd: FHumRcd;
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
            if FileRead(fhandle, rcd, sizeof(FHumRcd)) = sizeof(FHumRcd) then
            begin
              if not rcd.Deleted then begin
                FileWrite(fh, rcd, sizeof(FHumRcd));
                Inc(total);
              end;
            end else
              break;
          end;
        end;
        header.MaxCount := total;
        //header.FirstSpace := -1;
        header.UpdateDateTime := PackDouble(Now);
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

function TFileHumDB.First: integer;
begin
  CurIndex := 0;
  Result   := CurIndex;
end;

function TFileHumDB.Next: integer;
begin
  if CurIndex < GetRecordCount - 1 then
    Inc(CurIndex);
  Result := CurIndex;
end;

function TFileHumDB.Prior: integer;
begin
  if CurIndex >= 0 then
    Dec(CurIndex);
  Result := CurIndex;
end;

function TFileHumDB.Get(var rcd: FHumRcd): integer;
begin
  //FileRead (fhandle, rcd, sizeof(FHumRcd));
  //FileSeek (fhandle, - sizeof(FHumRcd), 1);
  Result := 0;
end;

 {private}
 {���� ����� ���ڵ��ȣ ����, ������ -1}
 {index is must zero or lager then zero}
function TFileHumDB.DeleteRecord(index: integer): boolean;
var
  oldpos:  integer;
  rcdinfo: FHumRcdInfo;
begin
  Result := False; //Error;
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FHumRcd) * index, 0) <> -1 then begin
    rcdinfo.Deleted := True;
    rcdinfo.UpdateDateTime := PackDouble(Now);
    //rcdinfo.NextSpace := FirstSpace;
    //FirstSpace := index;
    FileWrite(fhandle, rcdinfo, sizeof(FHumRcdInfo));

      {DBHeader.FirstSpace  := FirstSpace;
      DBHeader.UpdateDateTime := PackDouble(Now);
      FileSeek (fhandle, 0, 0);
      FileWrite (fhandle, DBHeader, sizeof(FDBHeader)); }
    BlankList.Add(pointer(index));

    Updated := True;

    Result := True;
  end;
end;

function TFileHumDB.Delete(uname: string): boolean;
var
  n, m, idx: integer;
  rcd:  FHumRcd;
  temp: TList;
begin
  Result := False;
  n      := HumIndex.FFind(uname);
  if n >= 0 then begin
    GetRecord(n, rcd);
    idx := integer(HumIndex.Objects[n]);
    if DeleteRecord(idx) then begin
      HumIndex.Delete(n);
      Result := True;
    end;
    m := UidIndex.FFind(rcd.Block.UserId, temp);
    if m >= 0 then begin
      UidIndex.DDelete(m, rcd.Block.ChrName);
    end;
  end;
end;

procedure TFileHumDB.GetBlankList(blist: TStrings);
var
  fspace, i: integer;
  rcdinfo:   FHumRcdInfo;
begin
  for i := 0 to BlankList.Count - 1 do
    blist.Add(IntToStr(integer(BlankList[i])));
   {fspace := FirstSpace;
   for i:=0 to 10000000 do begin
      if fspace = -1 then break;
      blist.Add (IntToStr(fspace));
      FileSeek (fhandle, sizeof(FDBHeader) + sizeof(FHumRcd) * fspace, 0);
      if FileRead (fhandle, rcdinfo, sizeof(FHumRcdInfo)) = sizeof(FHumRcdInfo) then begin
         fspace := rcdinfo.NextSpace;
      end else
         fspace := -1;
   end;}
end;

function TFileHumDB.GetRecordCount: integer;
begin
  Result := HumIndex.Count;
end;

function TFileHumDB.ReadRecord(index: integer; var rcd: FHumRcd): boolean;
begin
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FHumRcd) * index, 0) <> -1 then begin
    FileRead(fhandle, rcd, sizeof(FHumRcd));
    FileSeek(fhandle, -sizeof(FHumRcd), 1);
    CurIndex := index;
    Result   := True;
  end else
    Result := False;
end;

function TFileHumDB.SetRecordDate(index: integer; setdate: TDateTime): boolean;
var
  opos:    integer;
  rcdinfo: FHumRcdInfo;
begin
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FHumRcd) * index, 0) <> -1 then begin
    opos := FileSeek(fhandle, 0, 1);
    if FileRead(fhandle, rcdinfo, sizeof(FHumRcdInfo)) = sizeof(FHumRcdInfo) then
    begin
      rcdinfo.UpdateDateTime := PackDouble(setdate);
      FileSeek(fhandle, opos, 0);
      FileWrite(fhandle, rcdinfo, sizeof(FHumRcdInfo));
    end;
    Updated := True;
    Result  := True;
  end else
    Result := False;
end;

{function  TFileHumDB.FindBlankRecord: integer;
var
   icount: integer;
   rcdinfo: FHumRcdInfo;
begin
   icount := 0;
   FileSeek (fhandle, sizeof(FDBHeader), 0);
   while TRUE do begin
      if FileRead (fhandle, rcdinfo, sizeof(FHumRcdInfo)) = sizeof(FHumRcdInfo) then begin
         if rcdinfo.Deleted then Result := icount;
      end else begin
         icount := -1;
         break;
      end;
      Inc (icount);
   end;
   Result := icount;
end;  }

function TFileHumDB.WriteRecord(index: integer; rcd: FHumRcd; asnew: boolean): boolean;
var
  opos, rpos: integer;
  rcdinfo: FHumRcdInfo;
  rcd2: FHumRcd;
begin
  rpos := sizeof(FDBHeader) + sizeof(FHumRcd) * index;
  if FileSeek(fhandle, rpos, 0) = rpos then begin
    opos := FileSeek(fhandle, 0, 1);
    if asnew then begin //�߰�
      if FileRead(fhandle, rcd2, sizeof(FHumRcd)) = sizeof(FHumRcd) then begin
        if not rcd2.Deleted then begin  //�������� ���� ����Ÿ�� �߸� ��ũ��
          Result := True;
          exit;
        end;
      end;
         {if FileRead (fhandle, rcdinfo, sizeof(FHumRcdInfo)) = sizeof(FHumRcdInfo) then begin
            if rcdinfo.Deleted then begin
               FirstSpace := rcdinfo.NextSpace;
            end else begin
               FirstSpace := -1;
               Result := TRUE;
               exit;
            end;
         end; }
    end;
    rcd.Deleted := False;
    rcd.UpdateDateTime := PackDouble(Now);
    //DBHeader.FirstSpace  := FirstSpace;
    DBHeader.UpdateDateTime := PackDouble(Now);
    FileSeek(fhandle, 0, 0);
    FileWrite(fhandle, DBHeader, sizeof(FDBHeader));
    FileSeek(fhandle, opos, 0);
    FileWrite(fhandle, rcd, sizeof(FHumRcd));
    FileSeek(fhandle, -sizeof(FHumRcd), 1);
    CurIndex := index;
    Updated  := True;
    Result   := True;
  end else
    Result := False;
end;

{ used with 'Find' }
function TFileHumDB.GetRecord(index: integer; var rcd: FHumRcd): integer;
var
  idx: integer;
begin
  idx := integer(HumIndex.Objects[index]);
  if ReadRecord(idx, rcd) then
    Result := idx
  else
    Result := -1;
end;

{���� �ȵ�... ���� �ݵ�� Ȯ���� ��}
function TFileHumDB.GetRecordDr(index: integer; var rcd: FHumRcd): boolean;
begin
  if (index >= 0) then ////and (index < HumIndex.Count) then
    Result := ReadRecord(Index, rcd)
  else
    Result := False;
end;

function TFileHumDB.SetRecordTime(index: integer; settime: TDateTime): boolean;
begin
  Result := SetRecordDate(integer(HumIndex.Objects[index]), settime);
end;

 { used with 'Find' }
 { SetRecord�� �߰��� �ǹ̷δ� ����ؼ��� �ȵȴ�. }
 { Key�� �ٲ� �� ����. }
function TFileHumDB.SetRecord(index: integer; rcd: FHumRcd): boolean;
begin
  Result := False;
  if (index < 0) or (index >= HumIndex.Count) then
    exit;
   {**���� i := HumIndex.Find (rcd.Key);
   if i >= 0 then begin
      if i <> index then begin
         Result := FALSE;
         exit;
      end;
   end;**}

   {flag := TRUE;
   if ReadRecord (Integer (HumIndex.Objects[index]), orcd) then begin
      if rcd.Block.DBHuman.Abilitys.Level = orcd.Block.DBHuman.Abilitys.Level then
         flag := FALSE;
   end;}
  if WriteRecord(integer(HumIndex.Objects[index]), rcd, False) then begin
    Result := True;
    ///HumIndex[index] := rcd.Key; <= Ű�� �ٲ� �� ����.
      {if flag then
         with FIndex do begin
            try
               if OpenWr then begin
                  UpdateIndex (rcd.Key, Integer (HumIndex.Objects[index]), rcd.Block.DBHuman.Abilitys.Level);
               end;
            finally
               Close;
            end;
         end;}
  end;
end;

function TFileHumDB.SetRecordDr(index: integer; rcd: FHumRcd): boolean;
begin
  Result := False;
  if WriteRecord(index, rcd, False) then
    Result := True;
end;

 { �ݵ�� �߰��� �ǹ̷θ� ���ȴ�. }
 { ���� Key�� ����� �� ����. }
function TFileHumDB.AddRecord(rcd: FHumRcd): boolean;
var
  i:      integer;
  rcdpos: integer;
  oldheader: FDBHeader;
begin
  if HumIndex.FFind(rcd.Key) >= 0 then begin
    Result := False;
    exit;
  end;
  oldheader := DBHeader;
   {if FirstSpace = -1 then begin
      rcdpos := DBHeader.MaxCount;
      DBHeader.MaxCount := DBHeader.MaxCount + 1;
   end else begin
      //���� ����� �� ������ ã�´�.
      rcdpos := FirstSpace;
   end; }
  if BlankList.Count > 0 then begin
    rcdpos := integer(BlankList[0]);
    BlankList.Delete(0);
  end else begin
    rcdpos := DBHeader.MaxCount;
    DBHeader.MaxCount := DBHeader.MaxCount + 1;
  end;

  if WriteRecord(rcdpos, rcd, True) then begin
    HumIndex.QAddObject(rcd.Key, TObject(rcdpos));
    UidIndex.QAdd(rcd.Block.UserId, rcd.Block.ChrName, rcdpos);
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

function TFileHumDB.Find(uname: string): integer;
  {find by name only/find from index table}
begin
  Result := HumIndex.FFind(uname);
end;

function TFileHumDB.FindLike(uname: string; flist: TStrings): integer; {found count}
var
  i: integer;
begin
  Result := -1;
  for i := 0 to HumIndex.Count - 1 do begin
    if CompareLStr(HumIndex[i], uname, Length(uname)) then begin
      flist.AddObject(HumIndex[i], HumIndex.Objects[i]);
    end;
  end;
  Result := flist.Count;
end;

function TFileHumDB.FindUserId(uid: string; flist: TStrings): integer; {found count}
var
  i:    integer;
  list: TList;
begin
  Result := -1;
  list   := nil;
  UIdIndex.FFind(uid, list);
  if list <> nil then
    for i := 0 to list.Count - 1 do begin
      flist.AddObject(PTIdInfo(list[i]).uid, TObject(list[i]));
    end;
  Result := flist.Count;
end;

function TFileHumDB.FindUserIdCount(uid: string): integer; {found count}
var
  i, idx, rcount: integer;
  list: TList;
  rcd:  FHumRcd;
begin
  rcount := 0;
  list   := nil;
  UIdIndex.FFind(uid, list);
  if list <> nil then begin
    for i := 0 to list.Count - 1 do begin
      idx := PTIdInfo(list[i]).ridx;
      if GetRecordDr(idx, rcd) then begin
        if not rcd.Block.Delete then
          Inc(rcount);
      end;
    end;
  end;
  Result := rcount;
end;

function TFileHumDB.FindRecord(uname: string; var rcd: FHumRcd): boolean;
var
  i, index: integer;
begin
  Result := False;
  i      := HumIndex.FFind(uname);
  if i >= 0 then begin
    index  := integer(HumIndex.Objects[i]);
    Result := ReadRecord(index, rcd);
  end;
end;

function TFileHumDB.GetDBUpdateDateTime(dbname: string): TDateTime;
var
  i, fh:  integer;
  rcd:    FHumRcd;
  header: FDBHeader;
begin
  Result := 0;
  fh     := 0;
  try
    fh := FileOpen(dbname, fmOpenRead or fmShareDenyNone);
    if fh > 0 then begin
      if FileRead(fh, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        Result := SolveDouble(header.UpdateDateTime);
      end;
    end;
  finally
    if fh > 0 then
      FileClose(fh);
  end;
end;

procedure TFileHumDB.UpdateDBTime(dbname: string);
var
  i, fh:  integer;
  rcd:    FHumRcd;
  header: FDBHeader;
begin
  fh := FileOpen(dbname, fmOpenReadWrite or fmShareDenyNone);
  try
    if fh > 0 then begin
      if FileRead(fh, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        header.UpdateDateTime := PackDouble(Now);
        FileSeek(fh, 0, 0);
        FileWrite(fh, header, sizeof(FDBHeader));
      end;
    end;
  finally
    FileClose(fh);
  end;
end;

function TFileHumDB.DBSaveAs(dbname, targname: string; backuptime: integer): boolean;
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

function TFileHumDB.GetRcdFromFile(dbfile, uname: string; idx: integer;
  var rcd: FHumRcd): boolean;
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
        if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FHumRcd) * i, 0) <> -1 then
        begin
          if FileRead(fhandle, temp, sizeof(FDBTemp)) = sizeof(FDBTemp) then begin
            if temp.Key = uname then begin
              FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FHumRcd) * i, 0);
              FileRead(fhandle, rcd, sizeof(FHumRcd));
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

unit IDDB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, HUtil32, FileCtrl, Grobal2, MudUtil;

type
   {TUserInfo = record
      UInfo: TUserEntryInfo;
      ServerIndex: integer;  //�ֱ� ������ ���� �ε���
      PasswdFail: integer;  //��й�ȣ Ʋ��Ƚ��
      PasswdFailTime: longword; //��й�ȣ�� ���������� Ʋ�� �ð�
      Memo: string[20];
      Demmy: array[0..9] of byte;
   end;}

  TUserInfo = record      //���� ���� �Ǵ� ����� ���� ���ڵ�
    UInfo: TUserEntryInfo;
    UAdd:  TUserEntryAddInfo;
    ServerIndex: integer;     //�ֱ� ������ ���� �ε���
    PasswdFail: integer;      //��й�ȣ Ʋ��Ƚ��
    PasswdFailTime: longword; //��й�ȣ�� ���������� Ʋ�� �ð�
    Memo:  string[20];
    Demmy: array[0..9] of byte;
  end;

   {FIdRcd = record
      Deleted: Boolean; //delete mark
      UpdateDateTime: TDouble; //TDateTime;
      Key: string[10];
      Block: TUserInfo;
   end;
   PFIdRcd = ^FIdRcd;}

  FIdRcd = record              //���� ����� ���� ��ũ��
    Deleted: boolean;          {delete mark}
    MakeRcdDateTime: TDouble;  //������ ������� �ð�
    UpdateDateTime: TDouble;   //TDateTime;
    Key:     string[10];
    Block:   TUserInfo;
  end;
  PFIdRcd = ^FIdRcd;

  FIdRcdInfo = record
    Deleted: boolean; {delete mark}
    UpdateDateTime: TDouble; //TDateTime;
    Key:     string[10];
    NextSpace: integer;
  end;
  PFIdRcdInfo = ^FIdRcdInfo;

  FDBTemp = record
    Deleted: boolean; {delete mark}
    UpdateDateTime: TDouble; //TDateTime;
    Key:     string[10];
  end;
  PFDBTemp = ^FDBTemp;

  FDBHeader = record
    Title:      string[88];
    LastChangeRecordPosition: integer;  //���������� ��ģ ���ڵ��� �ε���
    LastChangeDateTime: TDouble;  //���������� ��ģ ���ڵ��� �ð�
    MaxCount:   integer;          {record count}
    BlockSize:  integer;          {record unit size}
    FirstSpace: integer;          {first space record position}
    UpdateDateTime: TDouble;      //TDateTime;
  end;
  PFDBHeader = ^FDBHeader;


  //�ε��� ���� ������ ���, DB������ ���� �ϴ� ���� �ε����� �����Ѵ�.
  //�ε��� ������ ���������� ��ģ ���ڵ�� ������ ������ ���������� ��ģ ���ڵ带 ��,
  //�ε��� ������ ���������� ��ģ ���ڵ��� ���� ������ ������ �ð��� �˻� �Ͽ�
  //��ȿ������ �˻��Ѵ�.
  //�ε����� ��ȿ�ϰ� ������� �ʾҴٸ� Rebuild�Ѵ�.

  FDBIndexHeader = record
    Title:    string[96];
    IdxCount: integer;   //�ε��� ��
    MaxCount: integer;   //FDBHeader�� MaxCount�� ��ġ�ؾ� �Ѵ�.
    LastChangeRecordPosition: integer;  //���������� ��ģ ���ڵ��� �ε���
    LastChangeDateTime: TDouble;  //���������� ��ģ ���ڵ��� �ð�
  end;
  PFDBIndexHeader = ^FDBIndexHeader;

  FIndexRcd = record
    Key:      string[10];
    Position: integer;
  end;


  TFileIDDB = class
  private
    CurIndex:   integer;
    FirstSpace: integer;
    FRefresh:   TNotifyEvent;
    Updated:    boolean;
    LatestRecordIndex: integer;   //���������� ����� ���ڵ� ��ȣ
    LatestUpdateTime: TDateTime;  //���������� ����� ���ڵ��� �÷� �ð�
    function ReadRecord(index: integer; var rcd: FIdRcd): boolean;
    function FindBlankRecord: integer;
    function WriteRecord(index: integer; rcd: FIdRcd; asnew: boolean): boolean;
    function SetRecordDate(index: integer; setdate: TDateTime): boolean; // curtion..
    function DeleteRecord(index: integer): boolean;
    procedure SaveIndexs;
    function LoadIndexs: boolean;
  public
    fhandle:     integer;
    DBHeader:    FDBHeader;
    IdIndex:     TQuickList; {username + data position}
    DBFileName:  string;
    IDXFileName: string;
    constructor Create(flname: string);
    destructor Destroy; override;
    //procedure ConvertBuildIndex;
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
    function Get(var rcd: FIdRcd): integer;
    function Delete(uname: string): boolean;
    procedure GetBlankList(blist: TStrings);
    function GetRecordCount: integer;
    function GetRecord(index: integer; var rcd: FIdRcd): integer;
    function GetRecordDr(index: integer; var rcd: FIdRcd): boolean;
    function SetRecord(index: integer; rcd: FIdRcd): boolean;
    function SetRecordTime(index: integer; settime: TDateTime): boolean;
    function AddRecord(rcd: FIdRcd): boolean;
    function Find(uname: string): integer; {find by name only/find from index table}
    function FindLike(uname: string; flist: TStrings): integer; {found count}
    function FindRecord(uname: string; var rcd: FIdRcd): boolean;
    function GetDBUpdateDateTime(dbname: string): TDateTime;
    procedure UpdateDBTime(dbname: string);
    function DBSaveAs(dbname, targname: string; backuptime: integer): boolean;
    function GetRcdFromFile(dbfile, uname: string; idx: integer;
      var rcd: FIdRcd): boolean;
  published
    property OnRefresh: TNotifyEvent Read FRefresh Write FRefresh;
  end;

var
  CSDBLock:  TRTLCriticalSection;
  CurIdLoading, ValidIdLoading, MaxIdLoading: integer;
  IdLoaded: boolean;


implementation


constructor TFileIDDB.Create(flname: string);
begin
  CurIndex     := 0;
  DBFileName   := flname;
  IDXFileName  := flname + '.idx';
  IdIndex      := TQuickList.Create;
  IdIndex.CaseSensitive := False;
  CurIdLoading := 0;
  MaxIdLoading := 0;
  IdLoaded     := False;
  LatestRecordIndex := -1;  //���� ���� ǥ��(�ʱ�ȭ)
  if LoadIndexs then begin
    IdLoaded := True;
  end else
    BuildIndex;
end;

destructor TFileIDDB.Destroy;
begin
  if IdLoaded then
    SaveIndexs;
  IdIndex.Free;
  //   FIndex.Free;
end;

procedure TFileIDDB.LockDB;
begin
  EnterCriticalSection(CSDBLock);
end;

procedure TFileIDDB.UnlockDB;
begin
  LeaveCriticalSection(CSDBLock);
end;

function TFileIDDB.OpenRd: boolean;
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

function TFileIDDB.OpenWr: boolean;
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

procedure TFileIDDB.Close;
begin
  FileClose(fhandle);
   {$I+}
  if Updated then begin
    if Assigned(FRefresh) then
      FRefresh(self);
  end;
  UnlockDB;
end;

(*procedure TFileIDDB.ConvertBuildIndex;
var
   i, j, curidx, oldpos: integer;
   rcd: FIdRcd;
   newrcd: FNewIdRcd;
   header: FDBHeader;
   fID: TFileIDDB;
begin
   CurIndex := 0;
   FirstSpace := -1;
   IdIndex.Clear;
   curidx := 0;
   CurIdLoading := 0;
   ValidIdLoading := 0;
   MaxIdLoading := 0;

   fID := TFileIdDB.Create (DBFileName + '.NEW');

   try
      if OpenWr then begin
         fID.OpenWr;
         FileSeek (fhandle, 0, 0);
         FileSeek (fID.fhandle, sizeof(FDBHeader), 0);
         if FileRead (fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
            MaxIdLoading := header.MaxCount;
            for i:=0 to header.MaxCount-1 do begin
               Inc (CurIdLoading);
               if FileRead (fhandle, rcd, sizeof(FIdRcd)) = sizeof(FIdRcd) then begin
                  //if not rcd.Deleted then begin
                     //IdIndex.AddObject (rcd.Key, TObject(curidx));  //QAddObject (rcd.Key, TObject(curidx));
                     FillChar (newrcd, sizeof(FNewIdRcd), #0);
                     newrcd.Deleted := FALSE;
                     newrcd.MakeRcdDateTime := PackDouble(Now); //������ ������� �ð�
                     newrcd.UpdateDateTime := rcd.UpdateDateTime;
                     newrcd.Key := rcd.Key;
                     newrcd.Block.UInfo := rcd.Block.UInfo;
                     //UAdd: TUserEntryAddInfo;
                     newrcd.Block.ServerIndex := rcd.Block.ServerIndex;
                     newrcd.Block.PasswdFail := rcd.Block.PasswdFail;
                     newrcd.Block.PasswdFailTime := rcd.Block.PasswdFailTime;
                     newrcd.Block.Memo := rcd.Block.Memo;
                     Move (rcd.Block.Demmy, newrcd.Block.Demmy, 10);

                     FileWrite (fID.fhandle, newrcd, sizeof(FNewIdRcd));

                     Inc (ValidIdLoading);
                  //end;
               end else
                  break;
               Inc (curidx);
               Application.ProcessMessages;
               if Application.Terminated then begin
                  Close;
                  exit;
               end;
            end;
         end;

         header.MaxCount := ValidIdLoading;
         FileSeek (fID.fhandle, 0, 0);
         FileWrite (fID.fhandle, header, sizeof(FDBHeader));
      end;
   finally
      Close;
      fID.Close;
   end;

   fID.Free;
   IdLoaded := TRUE;
end;   *)

procedure TFileIDDB.BuildIndex;
var
  i, j, curidx, oldpos: integer;
  rcd:     FIdRcd;
  header:  FDBHeader;
  rcdinfo: FIdRcdInfo;
begin
  CurIndex   := 0;
  FirstSpace := -1;
  IdIndex.Clear;
  curidx := 0;
  CurIdLoading := 0;
  ValidIdLoading := 0;
  MaxIdLoading := 0;
  try
    if OpenWr then begin
      FileSeek(fhandle, 0, 0);
      if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        MaxIdLoading := header.MaxCount;
        for i := 0 to header.MaxCount - 1 do begin
          Inc(CurIdLoading);
          if FileRead(fhandle, rcd, sizeof(FIdRcd)) = sizeof(FIdRcd) then begin
            if not rcd.Deleted then begin
              IdIndex.AddObject(rcd.Key, TObject(curidx));
              //QAddObject (rcd.Key, TObject(curidx));
              Inc(ValidIdLoading);
            end else begin
              oldpos := FileSeek(fhandle, 0, 1);
              FileSeek(fhandle, -sizeof(FIdRcd), 1);
              FileRead(fhandle, rcdinfo, sizeof(FIdRcdInfo));
              FileSeek(fhandle, -sizeof(FIdRcdInfo), 1);
              rcdinfo.NextSpace := FirstSpace;
              FirstSpace := curidx;
              FileWrite(fhandle, rcdinfo, sizeof(FIdRcdInfo));
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
  QuickSortStrListNoCase(IdIndex, 0, IdIndex.Count - 1);
  LatestRecordIndex := DBHeader.LastChangeRecordPosition;
  LatestUpdateTime := SolveDouble(DBHeader.LastChangeDateTime);
  IdLoaded := True;
end;

procedure TFileIDDB.Rebuild;
var
  tempfile: string;
  fh, total: integer;
  header: FDBHeader;
  rcd: FIdRcd;
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
            if FileRead(fhandle, rcd, sizeof(FIdRcd)) = sizeof(FIdRcd) then begin
              if not rcd.Deleted then begin
                FileWrite(fh, rcd, sizeof(FIdRcd));
                Inc(total);
              end;
            end else
              break;
          end;
        end;
        header.MaxCount   := total;
        header.FirstSpace := -1;
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

procedure TFileIDDB.SaveIndexs;
var
  IdxFileHeader: FDBIndexHeader;
  f, i:   integer;
  IdxRcd: FIndexRcd;
begin
  FillChar(IdxFileHeader, sizeof(FDBIndexHeader), #0);
  with IdxFileHeader do begin
    Title    := 'legend of mir database index file 2001/3';
    MaxCount := DBHeader.MaxCount;
    IdxCount := IdIndex.Count;
    LastChangeRecordPosition := LatestRecordIndex;
    LastChangeDateTime := PackDouble(LatestUpdateTime);
  end;
   {$I-}
  if FileExists(IDXFileName) then begin
    f := FileOpen(IDXFileName, fmOpenReadWrite or fmShareDenyNone);
  end else begin
    f := FileCreate(IDXFileName);
  end;
  if f > 0 then begin
    FileWrite(f, IdxFileHeader, sizeof(FDBIndexHeader));
    for i := 0 to IdIndex.Count - 1 do begin
      IdxRcd.Key      := IdIndex[i];
      IdxRcd.Position := integer(IdIndex.Objects[i]);
      FileWrite(f, IdxRcd, sizeof(FIndexRcd));
    end;
    FileClose(f);
  end;
   {$I+}
end;

 //����� �ε��� ������ �о� �´�.
 //äũ ����
 //  1) Index->MaxCount = FDB->MaxCount
 //  2) ������ �＼���� ���ڵ��� �簣�� ������ ����
function TFileIDDB.LoadIndexs: boolean;
var
  IdxFileHeader: FDBIndexHeader;
  f, i:   integer;
  IdxRcd: FIndexRcd; //�ε��� ���
  header: FDBHeader; //������ ���
  rcd:    FIdRcd;
begin
  Result := False;
  f      := 0;
  FillChar(IdxFileHeader, sizeof(FDBIndexHeader), #0);
   {$I-}
  if FileExists(IDXFileName) then begin
    f := FileOpen(IDXFileName, fmOpenReadWrite or fmShareDenyNone);
  end;
  if f > 0 then begin
    Result := True;
    FileRead(f, IdxFileHeader, sizeof(FDBIndexHeader));
    //DB������ ����� ������ Ȯ���� �Ѵ�.
    try
      if OpenWr then begin
        FileSeek(fhandle, 0, 0);
        if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then
        begin
          if IdxFileHeader.MaxCount <> header.MaxCount then
            Result := False;
        end;
        if IdxFileHeader.LastChangeRecordPosition <>
          header.LastChangeRecordPosition then begin
          Result := False;
        end;
        if IdxFileHeader.LastChangeRecordPosition > -1 then begin
          FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FIdRcd) *
            IdxFileHeader.LastChangeRecordPosition, 0);
          if FileRead(fhandle, rcd, sizeof(FIdRcd)) = sizeof(FIdRcd) then begin
            if SolveDouble(IdxFileHeader.LastChangeDateTime) <>
              SolveDouble(rcd.UpdateDateTime) then
              Result := False;
          end;
        end;
      end;
    finally
      Close;
    end;

    if Result then begin
      LatestRecordIndex := IdxFileHeader.LastChangeRecordPosition;
      LatestUpdateTime  := SolveDouble(IdxFileHeader.LastChangeDateTime);
      for i := 0 to IdxFileHeader.IdxCount - 1 do begin
        if FileRead(f, IdxRcd, sizeof(FIndexRcd)) = sizeof(FIndexRcd) then begin
          IdIndex.AddObject(IdxRcd.Key, TObject(IdxRcd.Position));
        end else begin
          Result := False;
          break;
        end;
      end;
    end;
    FileClose(f);
  end;
   {$I+}
  if Result then begin
    CurIdLoading := header.MaxCount;
    MaxIdLoading := header.MaxCount;
    //QuickSortStrListNoCase(IdIndex, 0, IdIndex.Count-1);
  end else
    IdIndex.Clear;
end;


function TFileIDDB.First: integer;
begin
  CurIndex := 0;
  Result   := CurIndex;
end;

function TFileIDDB.Next: integer;
begin
  if CurIndex < GetRecordCount - 1 then
    Inc(CurIndex);
  Result := CurIndex;
end;

function TFileIDDB.Prior: integer;
begin
  if CurIndex >= 0 then
    Dec(CurIndex);
  Result := CurIndex;
end;

function TFileIDDB.Get(var rcd: FIdRcd): integer;
begin
  //FileRead (fhandle, rcd, sizeof(FIdRcd));
  //FileSeek (fhandle, - sizeof(FIdRcd), 1);
  Result := 0;
end;

 {private}
 {���� ����� ���ڵ��ȣ ����, ������ -1}
 {index is must zero or lager then zero}
function TFileIDDB.DeleteRecord(index: integer): boolean;
var
  oldpos:  integer;
  rcdinfo: FIdRcdInfo;
  nowtime: TDateTime;
begin
  Result := False; //Error;
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FIdRcd) * index, 0) <> -1 then begin
    //���������� ���ŵ� ���ڵ��� ��ȣ�� �ð�(�ε��� ���忡 ����)
    nowtime := Now;
    LatestRecordIndex := index;
    LatestUpdateTime := nowtime;

    rcdinfo.Deleted := True;
    rcdinfo.UpdateDateTime := PackDouble(nowtime);
    rcdinfo.NextSpace := FirstSpace;
    FirstSpace := index;
    FileWrite(fhandle, rcdinfo, sizeof(FIdRcdInfo));

    DBHeader.LastChangeRecordPosition := LatestRecordIndex;
    DBHeader.LastChangeDateTime := PackDouble(LatestUpdateTime);
    DBHeader.FirstSpace     := FirstSpace;
    DBHeader.UpdateDateTime := PackDouble(Now);
    FileSeek(fhandle, 0, 0);
    FileWrite(fhandle, DBHeader, sizeof(FDBHeader));
    Updated := True;

    Result := True;
  end;
end;

function TFileIDDB.Delete(uname: string): boolean;
var
  n: integer;
begin
  Result := False;
  n      := IdIndex.FFind(uname);
  if n >= 0 then begin
    if DeleteRecord(integer(IdIndex.Objects[n])) then begin
      IdIndex.Delete(n);
      Result := True;
    end;
  end;
end;

procedure TFileIDDB.GetBlankList(blist: TStrings);
var
  fspace, i: integer;
  rcdinfo:   FIdRcdInfo;
begin
  fspace := FirstSpace;
  for i := 0 to 10000000 do begin
    if fspace = -1 then
      break;
    blist.Add(IntToStr(fspace));
    FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FIdRcd) * fspace, 0);
    if FileRead(fhandle, rcdinfo, sizeof(FIdRcdInfo)) = sizeof(FIdRcdInfo) then begin
      fspace := rcdinfo.NextSpace;
    end else
      fspace := -1;
  end;
end;

function TFileIDDB.GetRecordCount: integer;
begin
  Result := IdIndex.Count;
end;

function TFileIDDB.ReadRecord(index: integer; var rcd: FIdRcd): boolean;
begin
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FIdRcd) * index, 0) <> -1 then begin
    FileRead(fhandle, rcd, sizeof(FIdRcd));
    FileSeek(fhandle, -sizeof(FIdRcd), 1);
    CurIndex := index;
    Result   := True;
  end else
    Result := False;
end;

function TFileIDDB.SetRecordDate(index: integer; setdate: TDateTime): boolean;
var
  opos:    integer;
  rcdinfo: FIdRcdInfo;
begin
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FIdRcd) * index, 0) <> -1 then begin
    opos := FileSeek(fhandle, 0, 1);
    if FileRead(fhandle, rcdinfo, sizeof(FIdRcdInfo)) = sizeof(FIdRcdInfo) then begin
      rcdinfo.UpdateDateTime := PackDouble(setdate);
      FileSeek(fhandle, opos, 0);
      FileWrite(fhandle, rcdinfo, sizeof(FIdRcdInfo));
    end;
    Updated := True;
    Result  := True;
  end else
    Result := False;
end;

function TFileIDDB.FindBlankRecord: integer;
var
  icount:  integer;
  rcdinfo: FIdRcdInfo;
begin
  icount := 0;
  FileSeek(fhandle, sizeof(FDBHeader), 0);
  while True do begin
    if FileRead(fhandle, rcdinfo, sizeof(FIdRcdInfo)) = sizeof(FIdRcdInfo) then begin
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

function TFileIDDB.WriteRecord(index: integer; rcd: FIdRcd; asnew: boolean): boolean;
var
  opos, rpos: integer;
  rcdinfo:    FIdRcdInfo;
  nowtime:    TDateTime;
begin
  rpos := sizeof(FDBHeader) + sizeof(FIdRcd) * index;
  if FileSeek(fhandle, rpos, 0) = rpos then begin
    //���������� ���ŵ� ���ڵ��� ��ȣ�� �ð�(�ε��� ���忡 ����)
    nowtime := Now;
    LatestRecordIndex := index;
    LatestUpdateTime := nowtime;

    opos := FileSeek(fhandle, 0, 1);
    if asnew then begin //�߰�
      if FileRead(fhandle, rcdinfo, sizeof(FIdRcdInfo)) = sizeof(FIdRcdInfo) then
      begin
        if rcdinfo.Deleted then begin
          FirstSpace := rcdinfo.NextSpace;
        end else begin
          FirstSpace := -1;
          Result     := False;
          exit;
        end;
      end;
      rcd.MakeRcdDateTime := PackDouble(nowtime); //������ ������� �ð�
    end;
    rcd.Deleted := False;
    rcd.UpdateDateTime := PackDouble(nowtime);

    DBHeader.LastChangeRecordPosition := LatestRecordIndex;
    DBHeader.LastChangeDateTime := PackDouble(LatestUpdateTime);
    DBHeader.FirstSpace     := FirstSpace;
    DBHeader.UpdateDateTime := PackDouble(Now);

    FileSeek(fhandle, 0, 0);
    FileWrite(fhandle, DBHeader, sizeof(FDBHeader));
    FileSeek(fhandle, opos, 0);
    FileWrite(fhandle, rcd, sizeof(FIdRcd));
    FileSeek(fhandle, -sizeof(FIdRcd), 1);

    CurIndex := index;
    Updated  := True;
    Result   := True;
  end else
    Result := False;
end;

{ used with 'Find' }
function TFileIDDB.GetRecord(index: integer; var rcd: FIdRcd): integer;
var
  idx: integer;
begin
  idx := integer(IdIndex.Objects[index]);
  if ReadRecord(idx, rcd) then
    Result := idx
  else
    Result := -1;
end;

{���� �ȵ�... ���� �ݵ�� Ȯ���� ��}
function TFileIDDB.GetRecordDr(index: integer; var rcd: FIdRcd): boolean;
begin
  if (index >= 0) then ////and (index < IdIndex.Count) then
    Result := ReadRecord(Index, rcd)
  else
    Result := False;
end;

function TFileIDDB.SetRecordTime(index: integer; settime: TDateTime): boolean;
begin
  Result := SetRecordDate(integer(IdIndex.Objects[index]), settime);
end;

 { used with 'Find' }
 { SetRecord�� �߰��� �ǹ̷δ� ����ؼ��� �ȵȴ�. }
 { Key�� �ٲ� �� ����. }
function TFileIDDB.SetRecord(index: integer; rcd: FIdRcd): boolean;
begin
  Result := False;
  if (index < 0) or (index >= IdIndex.Count) then
    exit;
   {**���� i := IdIndex.Find (rcd.Key);
   if i >= 0 then begin
      if i <> index then begin
         Result := FALSE;
         exit;
      end;
   end;**}

   {flag := TRUE;
   if ReadRecord (Integer (IdIndex.Objects[index]), orcd) then begin
      if rcd.Block.DBHuman.Abilitys.Level = orcd.Block.DBHuman.Abilitys.Level then
         flag := FALSE;
   end;}
  if WriteRecord(integer(IdIndex.Objects[index]), rcd, False) then begin
    Result := True;
    ///IdIndex[index] := rcd.Key; <= Ű�� �ٲ� �� ����.
      {if flag then
         with FIndex do begin
            try
               if OpenWr then begin
                  UpdateIndex (rcd.Key, Integer (IdIndex.Objects[index]), rcd.Block.DBHuman.Abilitys.Level);
               end;
            finally
               Close;
            end;
         end;}
  end;
end;

 { �ݵ�� �߰��� �ǹ̷θ� ���ȴ�. }
 { ���� Key�� ����� �� ����. }
function TFileIDDB.AddRecord(rcd: FIdRcd): boolean;
var
  i:      integer;
  rcdpos: integer;
  oldheader: FDBHeader;
begin
  if IdIndex.FFind(rcd.Key) >= 0 then begin
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
    IdIndex.QAddObject(rcd.Key, TObject(rcdpos));
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

function TFileIDDB.Find(uname: string): integer;
  {find by name only/find from index table}
begin
  Result := IdIndex.FFind(uname);
end;

function TFileIDDB.FindLike(uname: string; flist: TStrings): integer; {found count}
var
  i: integer;
begin
  Result := -1;
  for i := 0 to IdIndex.Count - 1 do begin
    if CompareLStr(IdIndex[i], uname, Length(uname)) then begin
      flist.AddObject(IdIndex[i], IdIndex.Objects[i]);
    end;
  end;
  Result := flist.Count;
end;

function TFileIDDB.FindRecord(uname: string; var rcd: FIdRcd): boolean;
var
  i, index: integer;
begin
  Result := False;
  i      := IdIndex.FFind(uname);
  if i >= 0 then begin
    index  := integer(IdIndex.Objects[i]);
    Result := ReadRecord(index, rcd);
  end;
end;

function TFileIDDB.GetDBUpdateDateTime(dbname: string): TDateTime;
var
  i, fh:  integer;
  rcd:    FIdRcd;
  header: FDBHeader;
begin
  fh     := 0;
  Result := 0;
  try
    fh := FileOpen(dbname, fmOpenRead or fmShareDenyNone);
    if fh > 0 then begin
      if FileRead(fh, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        Result := SolveDouble(header.UpdateDateTime); //header.UpdateDateTime;
      end;
    end;
  finally
    if fh > 0 then
      FileClose(fh);
  end;
end;

procedure TFileIDDB.UpdateDBTime(dbname: string);
var
  i, fh:  integer;
  rcd:    FIdRcd;
  header: FDBHeader;
begin
  fh := 0;
  try
    fh := FileOpen(dbname, fmOpenReadWrite or fmShareDenyNone);
    if fh > 0 then begin
      if FileRead(fh, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        header.UpdateDateTime := PackDouble(Now);
        FileSeek(fh, 0, 0);
        FileWrite(fh, header, sizeof(FDBHeader));
      end;
    end;
  finally
    if fh > 0 then
      FileClose(fh);
  end;
end;

function TFileIDDB.DBSaveAs(dbname, targname: string; backuptime: integer): boolean;
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

function TFileIDDB.GetRcdFromFile(dbfile, uname: string; idx: integer;
  var rcd: FIdRcd): boolean;
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
        if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FIdRcd) * i, 0) <> -1 then
        begin
          if FileRead(fhandle, temp, sizeof(FDBTemp)) = sizeof(FDBTemp) then begin
            if temp.Key = uname then begin
              FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FIdRcd) * i, 0);
              FileRead(fhandle, rcd, sizeof(FIdRcd));
              Result := True;
              break;
            end;
          end;
        end;
      end;

    end;
  end;
end;


initialization
begin
  InitializeCriticalSection(CSDBLock);
end;

finalization
begin
  DeleteCriticalSection(CSDBLock);
end;

end.

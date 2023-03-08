unit FDBexpl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MfdbDef, Grobal2, HUtil32, qrfilename, Spin, IniFiles,
  MudUtil, ExtCtrls, Buttons;

type
  TFrmFDBExplore = class(TForm)
    ListBox1:   TListBox;
    EdFind:     TEdit;
    Label1:     TLabel;
    BtnViewRecord: TButton;
    BtnAdd:     TButton;
    BtnDel:     TButton;
    ListBox2:   TListBox;
    BtnRebuild: TButton;
    BtnBlankCount: TButton;
    GroupBox1:  TGroupBox;
    BtnAutoClean: TButton;
    BtnReloadDir: TButton;
    Timer1:     TTimer;
    BtnCopyRcd: TButton;
    BtnCopyNew: TButton;
    BtnViewBackup: TButton;
    BtnIDHum:   TSpeedButton;
    CkLv1:      TCheckBox;
    CkLv7:      TCheckBox;
    CkLv14:     TCheckBox;
    CkEnableMakeNewChar: TCheckBox;
    procedure EdFindKeyPress(Sender: TObject; var Key: char);
    procedure ListBox1Click(Sender: TObject);
    procedure BtnViewRecordClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnRebuildClick(Sender: TObject);
    procedure BtnBlankCountClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnAddFromFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAutoCleanClick(Sender: TObject);
    procedure BtnReloadDirClick(Sender: TObject);
    procedure BtnRecoverClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnCopyRcdClick(Sender: TObject);
    procedure BtnCopyNewClick(Sender: TObject);
    procedure BtnViewBackupClick(Sender: TObject);
    procedure BtnIDHumClick(Sender: TObject);
    procedure CkEnableMakeNewCharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    DeleteList:     TStringList;
    AutoCleanIndex: integer;
    CleanCount:     integer;
  public
    RecordData: TMirDBBlockData;
    procedure UpdateWorkRecord;
  end;


var
  FrmFDBExplore: TFrmFDBExplore;
  f: TFileDB;

implementation

uses viewrcd, DBSMain, newchr, frmcpyrcd, FIDHum, UsrSoc;

{$R *.DFM}


procedure TFrmFDBExplore.FormCreate(Sender: TObject);
begin
  DeleteList     := TStringList.Create;
  AutoCleanIndex := 0;
  CleanCount     := 0;
end;

procedure TFrmFDBExplore.FormShow(Sender: TObject);
begin
  FrmFDBExplore.CkEnableMakeNewChar.Checked := BoEnableNewChar;
end;

procedure TFrmFDBExplore.EdFindKeyPress(Sender: TObject; var Key: char);
var
  i, idx: integer;
  rcd:    FDBRecord;
begin
  if (Key = #13) and (Trim(EdFind.Text) <> '') then begin
    ListBox1.Clear;
    ListBox2.Clear;
    with FDB do begin
      if OpenRd then begin
        idx := FindLike(EdFind.Text, ListBox1.Items);
        for i := 0 to ListBox1.Items.Count - 1 do
          ListBox2.Items.Add(IntToStr(integer(ListBox1.Items.Objects[i])));
        Close;
      end;
    end;
    Key := #0;
  end;
end;

procedure TFrmFDBExplore.ListBox1Click(Sender: TObject);
var
  idx:   integer;
  rcd:   FDBRecord;
  uname: string;
begin
  //LbRecordIndex.Caption := IntToStr(ListBox1.ItemIndex) + '/' + IntToStr(ListBox1.Items.Count);
  ListBox2.ItemIndex := ListBox1.ItemIndex;
  idx := -1;
  with FDB do begin
    if OpenWr then begin
      idx := Find(ListBox1.Items[ListBox1.ItemIndex]);
      if idx >= 0 then begin
        GetRecord(idx, rcd);
        RecordData := rcd.Block;
        uname      := rcd.Key;
      end;
      Close;
    end;
  end;
  if FrmFDBViewer.Visible and (idx >= 0) then begin
    FrmFDBViewer.RecordIndex := idx;
    FrmFDBViewer.UserName := ListBox1.Items[ListBox1.ItemIndex];
    FrmFDBViewer.VRcd := rcd; //UserData := RecordData;
    FrmFDBViewer.Refresh;
  end;
end;

procedure TFrmFDBExplore.UpdateWorkRecord;
var
  idx: integer;
  rcd: FDBRecord;
begin
  with FDB do begin
    if OpenWr then begin
      idx := Find(FrmFDBViewer.UserName);
      if idx >= 0 then begin
        GetRecord(idx, rcd);
        rcd := FrmFDBViewer.VRcd; //.Block := FrmFDBViewer.UserData;
        SetRecord(idx, rcd);
      end;
      Close;
    end;
  end;
end;

procedure TFrmFDBExplore.BtnViewRecordClick(Sender: TObject);
begin
  FrmFDBViewer.Show;
end;

procedure TFrmFDBExplore.BtnViewBackupClick(Sender: TObject);
var
  idx:   integer;
  rcd:   FDBRecord;
  uname: string;
begin      (*
   if ListBox1.ItemIndex < 0 then exit;
   FrmFDBViewer.Show;
   uname := '';
   idx := -1;
   with FDB do begin
      if OpenRd then begin
         idx := Find (ListBox1.Items[ListBox1.ItemIndex]);
         if idx >= 0 then begin
            uname := ListBox1.Items[ListBox1.ItemIndex]
         end;
         Close;
      end;
   end;
   if (uname <> '') and (idx >= 0) then begin
      if FDB.GetRcdFromFile (EdBackupDir.Text, uname, idx, rcd) then begin
         RecordData := rcd.Block;
         FrmFDBViewer.UserName := uname + '(Backup)';
         FrmFDBViewer.VRcd := rcd; //UserData := RecordData;
         FrmFDBViewer.Refresh;
      end else
         ShowMessage ('Can not be found.');
   end;  *)
end;

procedure TFrmFDBExplore.BtnDelClick(Sender: TObject);
var
  delidx: integer;
begin
  if ListBox1.ItemIndex = -1 then
    exit;
  delidx := integer(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  if MessageDlg(IntToStr(delidx) + ' no. Would Delete ?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then begin
    try
      if FDB.OpenWr then begin
        FDB.DeleteIndex(delidx);
      end;
    finally
      FDB.Close;
    end;
  end;
end;

procedure TFrmFDBExplore.BtnRebuildClick(Sender: TObject);
begin
  if MessageDlg(
    'If you do Rebuild the service will be stopped and you should restart the program.  Do you still want to Rebuild ?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    FDB.Rebuild;
    MessageDlg('Restart program now', mtWarning, [mbOK], 0);
  end;
end;

procedure TFrmFDBExplore.BtnBlankCountClick(Sender: TObject);
begin
  ListBox1.Clear;
  ListBox2.Clear;
  try
    if FDB.OpenWr then begin
      FDB.GetBlankList(ListBox2.Items);
    end;
  finally
    FDB.Close;
  end;
end;

procedure TFrmFDBExplore.BtnAddClick(Sender: TObject);
var
  uname: string;
begin
  if FrmNewChr.NewChar(uname) then begin
    FrmUserSoc.CreateNewFDB(uname, 0, 0, 0);
  end;
end;

procedure TFrmFDBExplore.BtnAddFromFileClick(Sender: TObject);
begin
end;


{===============================================================}


procedure TFrmFDBExplore.BtnAutoCleanClick(Sender: TObject);
begin
  AutoClean := not AutoClean;
  if AutoClean then
    BtnAutoClean.Caption := 'Auto Cleaning..'
  else
    BtnAutoClean.Caption := 'Auto Clean Stoped';
end;

procedure TFrmFDBExplore.BtnReloadDirClick(Sender: TObject);
begin
  //if MessageDlg ('Reload envirnoment values ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
  //   ReloadEnvirDir;
  //end;
end;


procedure TFrmFDBExplore.BtnRecoverClick(Sender: TObject);
var
  uname: string;
  idx, recidx: integer;
  rcd:   FDBRecord;
  flag:  boolean;
begin
(*   flag := FALSE;
   uname := ListBox1.Items[ListBox1.ItemIndex];
   recidx := Integer (ListBox1.Items.Objects[ListBox1.ItemIndex]);
   if MessageDlg (uname + ' : restore his(her)  data ?', mtConfirmation,
       [mbYes, mbNo, mbCancel], 0) = mrYes then begin
      with FDB do begin
         if GetRcdFromFile (EdBackupDir.Text, uname, recidx, rcd) then begin
            try
               if OpenWr then begin
                  idx := Find (uname);
                  if idx >= 0 then begin
                     SetRecord (idx, rcd);
                     flag := TRUE;
                  end;
               end;
            finally
               Close;
            end;
         end;
      end;
   end;
   if flag then
      ShowMessage (uname + ' : restoring his(her) data was completed.')
   else ShowMessage (uname + ' : data recovery fail !');
   *)
end;

procedure TFrmFDBExplore.Timer1Timer(Sender: TObject);

  function GetDelDate(a_mon, a_day: word): TDateTime;
  var
    i: integer;
    ayear, amon, aday: word;
  begin
    DecodeDate(Date, ayear, amon, aday);
    for i := 0 to a_mon - 1 do begin
      if amon > 1 then
        Dec(amon)
      else begin
        amon  := 12;
        ayear := ayear - 1;
      end;
    end;
    for i := 0 to a_day - 1 do begin
      if aday > 1 then
        Dec(aday)
      else begin
        aday := 28;
        if amon > 1 then
          Dec(amon)
        else begin
          amon  := 12;
          ayear := ayear - 1;
        end;
      end;
    end;
    Result := EncodeDate(ayear, amon, aday);
  end;

var
  i, rcount, idx, idxcount, cleanrecord, maxrecord: integer;
  delname: string;
  deldate, deldate2, deldate3: TDateTime;
  DelMon, DelDay, DelLevel, DelMon2, DelDay2, DelLevel2, DelMon3,
  DelDay3, DelLevel3: word;
  rcd:     FDBRecord;
begin
  if AutoClean then begin
    DelMon    := 0;
    DelMon2   := 0;
    DelMon3   := 0;
    DelDay    := 14;
    DelDay2   := 31 * 2;
    DelDay3   := 31 * 4;
    DelLevel  := 1;
    DelLevel2 := 0;
    DelLevel3 := 0;
    if CkLv1.Checked then begin
      DelMon   := 0;
      DelDay   := 14;
      DelLevel := 1;
    end;
    if CkLv7.Checked then begin
      DelMon2   := 0;
      DelDay2   := 31 * 2;
      DelLevel2 := 7;
    end;
    if CkLv14.Checked then begin
      DelMon3   := 0;
      DelDay3   := 31 * 4;
      DelLevel3 := 14;
    end;

    deldate  := GetDelDate(DelMon, DelDay);
    deldate2 := GetDelDate(DelMon2, DelDay2);
    deldate3 := GetDelDate(DelMon3, DelDay3);

    idxcount    := 0;
    maxrecord   := 0;
    cleanrecord := -1;
    delname     := '';
    with FDB do begin
      try
        if OpenWr then begin
          maxrecord := GetRecordCount;
          if AutoCleanIndex < maxrecord then begin
            idx := GetRecord(AutoCleanIndex, rcd);
            if idx >= 0 then begin
              if ((SolveDouble(rcd.UpdateDateTime) <= deldate) and
                (rcd.Block.DBHuman.Abil.Level <= DelLevel)) or
                ((SolveDouble(rcd.UpdateDateTime) <= deldate2) and
                (rcd.Block.DBHuman.Abil.Level <= DelLevel2)) or
                ((SolveDouble(rcd.UpdateDateTime) <= deldate3) and
                (rcd.Block.DBHuman.Abil.Level <= DelLevel3)) then begin
                cleanrecord := idx;
                delname     := rcd.Key;
                DeleteIndex(cleanrecord);
                Inc(CleanCount);
              end;
            end;
            Inc(AutoCleanIndex);
          end else begin
            AutoCleanIndex := 0;
          end;
        end;
      finally
        Close;
      end;
    end;
    if delname <> '' then
      FrmDbSrv.EraseHumDb(delname);
    FrmDBSrv.LbAutoClean.Caption :=
      IntToStr(AutoCleanIndex) + '/' + IntToStr(CleanCount) + '/' +
      IntToStr(maxrecord);
  end;
end;

procedure TFrmFDBExplore.BtnCopyRcdClick(Sender: TObject);
var
  sourcename, targetname: string;
begin
  if FrmCopyRcd.Execute then begin
    sourcename := FrmCopyRcd.SrcName;
    targetname := FrmCopyRcd.TargName;
    if FrmDBSrv.CopyFDB2(sourcename, targetname, FrmCopyRcd.WithID) then
      ShowMessage(sourcename + '->' + targetname + ' Copy success.');
  end;
end;

procedure TFrmFDBExplore.BtnCopyNewClick(Sender: TObject);
var
  sourcename, targetname: string;
begin
  if FrmCopyRcd.Execute then begin
    sourcename := FrmCopyRcd.SrcName;
    targetname := FrmCopyRcd.TargName;
    if FrmUserSoc.CreateNewFDB(targetname, 0, 0, 0) then begin
      if FrmDBSrv.CopyFDB2(sourcename, targetname, FrmCopyRcd.WithID) then
        ShowMessage(sourcename + '->' + targetname + ' Copy success.');
    end;
  end;
end;

procedure TFrmFDBExplore.BtnIDHumClick(Sender: TObject);
begin
  FrmIDHum.Show;
end;

procedure TFrmFDBExplore.CkEnableMakeNewCharClick(Sender: TObject);
begin
  FrmDBSrv.SaveDBSrvINI;
end;

end.

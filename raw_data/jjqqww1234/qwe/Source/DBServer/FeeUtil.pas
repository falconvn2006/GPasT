unit FeeUtil;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls, HUtil32, mudutil, FeeDb, Buttons;

type
  TFrmFeeUtil = class(TForm)
    Panel1:     TPanel;
    FGrid:      TStringGrid;
    EdFindID:   TEdit;
    Label1:     TLabel;
    Label2:     TLabel;
    EdFindPC:   TEdit;
    OpenDialog1: TOpenDialog;
    Label3:     TLabel;
    BtnConvert: TSpeedButton;
    BtnFindId:  TSpeedButton;
    BtnFindIdAll: TSpeedButton;
    BtnFindGroup: TSpeedButton;
    BtnFindPCAll: TSpeedButton;
    BtnAddRcd:  TSpeedButton;
    BtnDelRcd:  TSpeedButton;
    BtnChangeRcd: TSpeedButton;
    BtnBack:    TSpeedButton;
    LbPlus:     TLabel;
    procedure BtnConvertClick(Sender: TObject);
    procedure BtnFindIDClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnFindIDAllClick(Sender: TObject);
    procedure FGridDrawCell(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState);
    procedure BtnFindGroupClick(Sender: TObject);
    procedure BtnFindPCAllClick(Sender: TObject);
    procedure FGridDblClick(Sender: TObject);
    procedure FGridKeyPress(Sender: TObject; var Key: char);
    procedure EdFindIDKeyPress(Sender: TObject; var Key: char);
    procedure EdFindPCKeyPress(Sender: TObject; var Key: char);
    procedure BtnAddRcdClick(Sender: TObject);
    procedure FGridClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure BtnBackClick(Sender: TObject);
    procedure BtnDelRcdClick(Sender: TObject);
    procedure BtnChangeRcdClick(Sender: TObject);
  private
    FindList:   TStringList;
    OverNCount: integer;
    procedure DoConvert(flname: string);
    procedure ClearGrid;
    procedure UpdateGrid(idx: integer; rcd: FFeeRcd);
    procedure RefreshRow(arow: integer);
    procedure UpdateGridNCount(arow, nc: integer);
    procedure FGridPlusNCount(grow: integer);
    procedure FGridMinusNCount(grow: integer);
  public
    function GetFeeInfo(uid, uip: string; var remdate: TDateTime;
      var dupcount: integer; var isIPad: boolean; var Specific: boolean): boolean;
  end;

var
  FrmFeeUtil: TFrmFeeUtil;

implementation

uses
  DBSMain, FAccount;

{$R *.DFM}


function TFrmFeeUtil.GetFeeInfo(uid, uip: string; var remdate: TDateTime;
  var dupcount: integer; var isIPad: boolean; var Specific: boolean): boolean;
var
  idx: integer;
  rcd: FFeeRcd;
  fin: boolean;
begin
  fin    := False;
(*   Specific := FALSE;
   with FFeeDB do begin
      try
         if OpenRd then begin
            idx := -1;
            if uid <> '' then
               idx := Find (uid);
            if idx >= 0 then begin
               if GetRecord (idx, rcd) >= 0 then begin
                  CheckValidDate (rcd);
                  if rcd.Block.Valid then begin
                     remdate := rcd.Block.EnableDate;
                     dupcount := rcd.Block.DupCount;
                     isIPad := FALSE;
                     Specific := FALSE;
                     fin := TRUE;
                  end;
               end;
            end;
            if not fin then begin
               idx := -1;
               if uip <> '' then
                  idx := Find (uip);
               if idx >= 0 then begin
                  if GetRecord (idx, rcd) >= 0 then begin
                     CheckValidDate (rcd);
                     if rcd.Block.Valid then begin
                        remdate := rcd.Block.EnableDate;
                        dupcount := rcd.Block.DupCount;
                        isIPad := TRUE;
                        if rcd.Block.AccountMode = 2 then Specific := TRUE //������
                        else Specific := FALSE;
                        fin := TRUE;
                     end;
                  end;
               end;
            end;
         end;
      finally
         Close;
      end;
   end;*)
  Result := fin;
end;

function GetGroupIP(ipstr: string): string;
var
  temp: string;
begin
  if CharCount(ipstr, '.') > 2 then begin
    Result := DivTailString(ipstr, '.', temp) + '.';
  end else
    Result := ipstr;
end;

procedure TFrmFeeUtil.FormCreate(Sender: TObject);
begin
  FGrid.Cells[0, 0] := '#';
  FGrid.Cells[1, 0] := 'ID / IP';
  FGrid.Cells[2, 0] := 'PC cafe / chr. name';
  FGrid.Cells[3, 0] := 'Representative';
  FGrid.Cells[4, 0] := 'FeeSelection';
  FGrid.Cells[5, 0] := 'Duplication';
  FGrid.Cells[6, 0] := 'RegistrationDate';
  FGrid.Cells[7, 0] := 'Quantity';
  FGrid.Cells[8, 0] := 'ExpiryDate';
  FGrid.Cells[9, 0] := 'Memo';
  FindList   := TStringList.Create;
  OverNCount := 0;
end;

procedure TFrmFeeUtil.FGridDrawCell(Sender: TObject; ACol, ARow: integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow <= 0 then
    exit;
  with FGrid do begin
    if FGrid.Cells[0, ARow] = '' then begin
      if State = [] then
        FGrid.Canvas.Font.Color := clSilver
      else
        FGrid.Canvas.Font.Color := clGray;
      FGrid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, FGrid.Cells[ACol, ARow]);
    end else begin
      if ACol = 4 then begin
        with FGrid do begin
          if FGrid.Cells[ACol, ARow] = 'FixedTimeAccount' then begin
            if State = [] then
              FGrid.Canvas.Font.Color := clNavy
            else
              FGrid.Canvas.Font.Color := clBlue;
            FGrid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, 'FixedTimeAccount');
          end;
          if FGrid.Cells[ACol, ARow] = 'Free' then begin
            FGrid.Canvas.Font.Color := clGreen;
            FGrid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, 'Free');
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmFeeUtil.DoConvert(flname: string);
var
  i, r, success, fail: integer;
  str, syear, smon, sday, latestname: string;
  fhandle: integer;
  ayear, amon, aday: word;
  feed:    TFeedInfo;
  header:  TFeedHeader;
  rdate:   TDateTime;
  feercd:  FFeeRcd;
begin (*
   fhandle := -1;
   success := 0;
   fail := 0;
   latestname := '';
   try
      {$I-}
      fhandle := FileOpen (flname, fmOpenRead or fmShareDenyNone); // Write or fmShareDenyRead);
      if fhandle > 0 then begin
         try
            if FFeeDB.OpenWr then begin
               FillChar (feercd, sizeof(FFeeRcd), #0);
               FileRead (fhandle, header, sizeof(TFeedHeader));
               for i:=0 to header.RecCount-1 do begin
                  r := FileRead (fhandle, feed, sizeof(TFeedInfo));
                  if r < sizeof(TFeedInfo) then break;
                  str := GetValidStr3 (feed.EntryDate, syear, ['/']);
                  str := GetValidStr3 (str, smon, ['/']);
                  str := GetValidStr3 (str, sday, ['/']);
                  ayear := Str_ToInt (syear, 0);
                  amon  := Str_ToInt (smon, 0);
                  aday  := Str_ToInt (sday, 0);
                  rdate := 0;
                  if (ayear >= 1998) and (amon in [1..12]) and (aday in [1..31]) then begin
                     rdate := CalcDay (EncodeDate (ayear, amon, aday), feed.EntryCount);
                     feercd.Block.EntryDate := EncodeDate(ayear, amon, aday);
                     feercd.Block.EnableDate := rdate;
                  end;
                  if feed.EntryDate = 'FixedTimeAccount' then begin
                     feercd.Block.AccountMode := 2;
                  end else begin
                     if feed.Etc = 'Free' then
                        feercd.Block.AccountMode := 0
                     else feercd.Block.AccountMode := 1;
                  end;
                  if (Date <= rdate) or (feercd.Block.AccountMode = 2) then begin //��밡��
                     feercd.Block.Valid := TRUE;
                  end else
                     feercd.Block.Valid := FALSE;
                  feercd.Block.OwnerName := feed.RealName;
                  feercd.Block.NCount := feed.EntryCount;
                  feercd.Block.UserKey := Trim(feed.FeedId);
                  if feercd.Block.UserKey = '' then continue;
                  if (feercd.Block.UserKey[1] = '*') or
                     (feercd.Block.UserKey[1] = '-') then
                     continue;
                  feed.ChrName := RemoveSpace(feed.ChrName);
                  if feed.ChrName <> '' then latestname := feed.ChrName + ',' + feed.FeeMan;
                  //else feed.ChrName := latestname;
                  feercd.Block.GroupKey := latestname;
                  feercd.Block.DupCount := feed.EntryOnce;
                  feercd.Key := feercd.Block.UserKey;
                  if feercd.Key <> '' then begin
                     if FFeeDb.AddRecord (feercd) then
                        Inc (success)
                     else begin
                        Inc (fail);
                     end;
                     if (i mod 100) = 0 then begin
                        Label3.Caption := IntToStr(success) + '/' + IntToStr(fail);
                        Application.ProcessMessages;
                     end;
                  end;
               end;
            end;
         finally
            FFeeDb.Close;
         end;
      end;
      {$I+}
   finally
      if fhandle >= 0 then
         FileClose (fhandle);
   end;  *)
end;

procedure TFrmFeeUtil.BtnConvertClick(Sender: TObject);
begin
  with OpenDialog1 do begin
    if Execute then begin
      DoConvert(FileName);
    end;
  end;
end;

procedure TFrmFeeUtil.ClearGrid;
begin
  FGrid.RowCount := 1;
  //   FGrid.RowCount := 2;
  //   FGrid.FixedRows := 1;
end;

procedure TFrmFeeUtil.UpdateGridNCount(arow, nc: integer);
var
  idx: integer;
  str: string;
  rcd: FFeeRcd;
begin      (*
   str := FGrid.Cells[1, arow];
   with FFeeDB do begin
      try
         if OpenWr then begin
            idx := Find (str);
            if idx >= 0 then begin
               if GetRecord (idx, rcd) >= 0 then begin
                  rcd.Block.NCount := nc;
                  SetRecord (idx, rcd);
                  UpdateGrid (arow, rcd);
               end;
            end;
         end;
      finally
         Close;
      end;
   end;      *)
end;

procedure TFrmFeeUtil.RefreshRow(arow: integer);
var
  idx: integer;
  str: string;
  rcd: FFeeRcd;
begin         (*
   str := FGrid.Cells[1, arow];
   with FFeeDB do begin
      try
         if OpenRd then begin
            idx := Find (str);
            if idx >= 0 then begin
               if GetRecord (idx, rcd) >= 0 then
                  UpdateGrid (arow, rcd);
            end;
         end;
      finally
         Close;
      end;
   end;         *)
end;

procedure TFrmFeeUtil.UpdateGrid(idx: integer; rcd: FFeeRcd);
var
  n, m: integer;
begin         (*
   FFeeDb.CheckValidDate (rcd);
   if idx <= 0 then begin                    // add
      FGrid.RowCount := FGrid.RowCount + 1;
      n := FGrid.RowCount - 1;
   end else
      n := idx;
   FGrid.FixedRows := 1;
   if rcd.Block.Valid then FGrid.Cells[0, n] := '*'
   else FGrid.Cells[0, n] := '';
   FGrid.Cells[1, n] := rcd.Block.UserKey;
   FGrid.Cells[2, n] := rcd.Block.GroupKey;
   FGrid.Cells[3, n] := rcd.Block.OwnerName;
   m := rcd.Block.AccountMode;
   case m of
      0: FGrid.Cells[4, n] := 'Free';
      1: FGrid.Cells[4, n] := 'FixedAmountAccount';
      2: FGrid.Cells[4, n] := 'FixedTimeAccount';
   end;
   FGrid.Cells[5, n] := IntToStr (rcd.Block.DupCount);
   FGrid.Cells[6, n] := DateToStr (rcd.Block.EntryDate);
   if m <> 2 then begin
      FGrid.Cells[7, n] := IntToStr  (rcd.Block.NCount);
      FGrid.Cells[8, n] := DateToStr (rcd.Block.EnableDate);
   end else begin
      FGrid.Cells[7, n] := '';
      FGrid.Cells[8, n] := '';
   end;
   FGrid.Cells[9, n] := rcd.Block.Memo; *)
end;

procedure TFrmFeeUtil.BtnFindIDClick(Sender: TObject);
var
  idx: integer;
  str: string;
  rcd: FFeeRcd;
begin (*
   str := Trim (EdFindId.Text);
   ClearGrid;
   with FFeeDB do begin
      try
         if OpenRd then begin
            idx := Find (str);
            if idx >= 0 then begin
               if GetRecord (idx, rcd) >= 0 then
                  UpdateGrid (0, rcd);
            end;
         end;
      finally
         Close;
      end;
   end;  *)
end;

procedure TFrmFeeUtil.BtnFindIDAllClick(Sender: TObject);
var
  i, idx:  integer;
  str:     string;
  rcd:     FFeeRcd;
  strlist: TStringList;
begin      (*
   str := Trim (EdFindId.Text);
   ClearGrid;
   FGrid.Visible := FALSE;
   strlist := TStringList.Create;
   with FFeeDB do begin
      try
         if OpenRd then begin
            if FindLike (str, strlist) > 0 then begin
               for i:=0 to strlist.Count-1 do begin
                  idx := Integer(strlist.Objects[i]);
                  if GetRecordDr (idx, rcd) then
                     UpdateGrid (0, rcd);
               end;
            end;
         end;
      finally
         Close;
      end;
   end;
   Label3.Caption := IntToStr(strlist.Count);
   strlist.Free;
   FGrid.Visible := TRUE;  *)
end;

procedure TFrmFeeUtil.BtnFindGroupClick(Sender: TObject);
var
  i, idx, Count: integer;
  gkey:    string;
  strlist: TStringList;
  rcd:     FFeeRcd;
begin (*
   gkey := EdFindPC.Text;
   if gkey = 'Extension of additional 1 day for every account' then begin
      if MessageDlg ('Extend additional 1 day for every account?', mtConfirmation, mbOkCancel, 0) = mrOk then begin
         count := 0;
         with FFeeDB do begin
            try
               if OpenWr then begin
                  for i:=0 to FeeIndex.Count-1 do begin
                     if GetRecordDr (Integer (FeeIndex.Objects[i]), rcd) then begin
                        if rcd.Block.AccountMode = 1 then begin //����
                           CheckValidDate (rcd);
                           if rcd.Block.Valid then begin
                              rcd.Block.NCount := rcd.Block.NCount + 1;
                              SetRecordDr (Integer (FeeIndex.Objects[i]), rcd);
                              Inc (count);
                           end;
                        end;
                     end;
                  end;
               end;
            finally
               Close;
            end;
         end;
         ShowMessage (IntToStr(count) + ' account extended 1 day more');
      end;
      exit;
   end;
   ClearGrid;
   FGrid.Visible := FALSE;
   strlist := TStringList.Create;
   with FFeeDB do begin
      try
         if OpenRd then begin
            if FindByGroupKey (gkey, strlist) > 0 then begin
               for i:=0 to strlist.Count-1 do begin
                  idx := PTIdInfo (strlist.Objects[i]).ridx;
                  if GetRecordDr (idx, rcd) then
                     UpdateGrid (0, rcd);
               end;
            end;
         end;
      finally
         Close;
      end;
   end;
   Label3.Caption := IntToStr(strlist.Count);
   strlist.Free;
   FGrid.Visible := TRUE;  *)
end;

procedure TFrmFeeUtil.BtnFindPCAllClick(Sender: TObject);
var
  i, idx:  integer;
  gkey:    string;
  strlist: TStringList;
  rcd:     FFeeRcd;
begin (*
   gkey := EdFindPC.Text;
   FindList.Insert (0, gkey);
   ClearGrid;
   FGrid.Visible := FALSE;
   strlist := TStringList.Create;
   with FFeeDB do begin
      try
         if OpenRd then begin
            if FindLikeByGroupKey (gkey, strlist) > 0 then begin
               for i:=0 to strlist.Count-1 do begin
                  idx := PTIdInfo (strlist.Objects[i]).ridx;
                  if GetRecordDr (idx, rcd) then
                     UpdateGrid (0, rcd);
               end;
            end;
         end;
      finally
         Close;
      end;
   end;
   Label3.Caption := IntToStr(strlist.Count);
   strlist.Free;
   FGrid.Visible := TRUE;  *)
end;

procedure TFrmFeeUtil.FGridDblClick(Sender: TObject);
var
  key:  string;
  idx:  integer;
  rcd:  FFeeRcd;
  flag: boolean;
begin (*
   key := FGrid.Cells[1, FGrid.Row];
   if key = '' then exit;
   flag := FALSE;
   with FFeeDB do begin
      try
         if OpenRd then begin
            idx := Find (key);
            if idx >= 0 then begin
               if GetRecord (idx, rcd) >= 0 then begin
                  FrmAccountForm.FeeInfo := rcd.Block;
                  flag := TRUE;
               end;
            end;
         end;
      finally
         Close;
      end;
      if flag then begin
         if FrmAccountForm.Execute then begin
            try
               if OpenWr then begin
                  idx := Find (key);
                  if idx >= 0 then begin
                     if GetRecord(idx, rcd) >= 0 then begin
                        rcd.Block := FrmAccountForm.FeeInfo;
                        SetRecord (idx, rcd);
                        UpdateGrid (FGrid.Row, rcd);
                     end;
                  end;
               end;
            finally
               Close;
            end;
         end;
      end;
   end;   *)
end;

procedure TFrmFeeUtil.FGridKeyPress(Sender: TObject; var Key: char);
begin
  case byte(key) of
    13: begin
      key := #0;
      FGridDblClick(self);
    end;
    byte('+'): begin
      FGridPlusNCount(FGrid.Row);
    end;
    byte('-'): begin
      FGridMinusNCount(FGrid.Row);
    end;
  end;
end;

procedure TFrmFeeUtil.EdFindIDKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then begin
    Key := #0;
    BtnFindIDAllClick(self);
    FGrid.SetFocus;
  end;
end;

procedure TFrmFeeUtil.EdFindPCKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then begin
    Key := #0;
    BtnFindPCAllClick(self);
    FGrid.SetFocus;
  end;
end;

procedure TFrmFeeUtil.FGridPlusNCount(grow: integer);
var
  n: integer;
begin
  if OverNCount <= 0 then begin
    Beep;
    exit;
  end;
  if (FGrid.Cells[4, grow] <> 'FixedTimeAccount') and (FGrid.Cells[0, grow] = '*') then
  begin
    n := Str_ToInt(FGrid.Cells[7, grow], 0);
    Inc(n);
    Dec(OverNCount);
    UpdateGridNCount(grow, n);
  end else
    Beep;
  LbPlus.Caption := IntToStr(OverNCount);
end;

procedure TFrmFeeUtil.FGridMinusNCount(grow: integer);
var
  n: integer;
begin
  if (FGrid.Cells[4, grow] <> 'FixedTimeAccount') and (FGrid.Cells[0, grow] = '*') then
  begin
    n := Str_ToInt(FGrid.Cells[7, grow], 0);
    if n > 0 then begin
      Dec(n);
      if Date <= CalcDay(StrToDate(FGrid.Cells[6, grow]), n) then begin
        Inc(OverNCount);
        UpdateGridNCount(grow, n);
      end else
        Beep;
    end;
  end else
    Beep;
  LbPlus.Caption := IntToStr(OverNCount);
end;

procedure TFrmFeeUtil.BtnAddRcdClick(Sender: TObject);
var
  feercd: FFeeRcd;
  oldrow, oldtop: integer;
  flag:   boolean;
begin (*
   oldtop := FGrid.TopRow;
   oldrow := FGrid.Row;
   flag := FALSE;
   FillChar (feercd, sizeof(FFeeRcd), #0);
   feercd.Block.UserKey := GetGroupIP (FGrid.Cells[1, FGrid.Row]);
   feercd.Block.GroupKey := FGrid.Cells[2, FGrid.Row];
   feercd.Block.DupCount  := 1;//Str_ToInt (FGrid.Cells[2, FGrid.Row];
   feercd.Block.EntryDate := Date;
   FrmAccountForm.FeeInfo := feercd.Block;
   if FrmAccountForm.ExecuteAdd then begin
      feercd.Block := FrmAccountForm.FeeInfo;
      feercd.Key := feercd.Block.UserKey;
      if (feercd.Key <> '') and (feercd.Block.GroupKey <> '') then begin
         try
            if FFeeDB.OpenWr then begin
               if FFeeDB.AddRecord (feercd) then
                  flag := TRUE;
            end;
         finally
            FFeeDB.Close;
         end;
      end;
      if flag then begin
         BtnFindPCAllClick (self);
         if FGrid.RowCount <= oldtop then oldtop := 0;
         FGrid.TopRow := oldtop;
         if FGrid.RowCount <= oldrow then oldrow := FGrid.RowCount-1;
         FGrid.Row := oldrow;
      end else
         Beep;
   end;  *)
end;

procedure TFrmFeeUtil.BtnDelRcdClick(Sender: TObject);
var
  ukey: string;
  oldrow, oldtop: integer;
  flag: boolean;
begin      (*
   oldtop := FGrid.TopRow;
   oldrow := FGrid.Row;
   flag := FALSE;
   ukey := FGrid.Cells[1, FGrid.Row];
   if MessageDlg (ukey + ' : Would Delete ?' + #13 + 'Want delete press OK', mtConfirmation, [mbYes, mbCancel, mbOk], 0) = mrOk then begin
      try
         if FFeeDB.OpenWr then begin
            if FFeeDB.Delete (ukey) then
               flag := TRUE;
         end;
      finally
         FFeeDB.Close;
      end;
      if flag then begin
         BtnFindPCAllClick (self);
         if FGrid.RowCount <= oldtop then oldtop := 0;
         FGrid.TopRow := oldtop;
         if FGrid.RowCount <= oldrow then oldrow := FGrid.RowCount-1;
         FGrid.Row := oldrow;
      end else
         Beep;
   end;      *)
end;

procedure TFrmFeeUtil.BtnChangeRcdClick(Sender: TObject);
var
  key:  string;
  idx:  integer;
  oldrow, oldtop: integer;
  rcd:  FFeeRcd;
  flag: boolean;
begin (*
   oldtop := FGrid.TopRow;
   oldrow := FGrid.Row;
   flag := FALSE;
   key := FGrid.Cells[1, FGrid.Row];
   if key = '' then exit;
   flag := FALSE;
   with FFeeDB do begin
      try
         if OpenRd then begin
            idx := Find (key);
            if idx >= 0 then begin
               if GetRecord (idx, rcd) >= 0 then begin
                  FrmAccountForm.FeeInfo := rcd.Block;
                  flag := TRUE;
               end;
            end;
         end;
      finally
         Close;
      end;
      if flag then begin
         flag := FALSE;
         if FrmAccountForm.ExecuteAdd then begin
            try
               if OpenWr then begin
                  if Delete (key) then begin
                     rcd.Block := FrmAccountForm.FeeInfo;
                     rcd.Key := rcd.Block.UserKey;
                     if (rcd.Key <> '') and (rcd.Block.GroupKey <> '') then
                        if AddRecord (rcd) then
                           flag := TRUE;
                  end;
               end;
            finally
               Close;
            end;
            if flag then begin
               BtnFindPCAllClick (self);
               if FGrid.RowCount <= oldtop then oldtop := 0;
               FGrid.TopRow := oldtop;
               if FGrid.RowCount <= oldrow then oldrow := FGrid.RowCount-1;
               FGrid.Row := oldrow;
            end else
               Beep;
         end;
      end else
         Beep;
   end;  *)
end;

procedure TFrmFeeUtil.FGridClick(Sender: TObject);
begin      (*
   with FGrid do begin
      EdFindID.Text := GetGroupIP (Cells[1, Row]);
      EdFindPc.Text := Cells[2, Row];
   end;      *)
end;

procedure TFrmFeeUtil.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  case Key of
    VK_F6: begin
      BtnFindIDAllClick(self);
    end;
    VK_F5: begin
      BtnFindPCAllClick(self);
    end;
    VK_F4: begin
      BtnBackClick(self);
    end;
    VK_INSERT: begin
      BtnAddRcdClick(self);
    end;
    VK_DELETE: begin
      if ssCtrl in Shift then
        BtnDelRcdClick(self);
    end;
    VK_RETURN: begin
      if ssCtrl in Shift then
        BtnChangeRcdClick(self);
    end;
  end;
end;

procedure TFrmFeeUtil.BtnBackClick(Sender: TObject);
begin
  if FindList.Count > 1 then begin
    FindList.Delete(0);
    EdFindPC.Text := FindList[0];
    BtnFindPCAllClick(self);
    FindList.Delete(0);
  end else
    Beep;
end;

{------------------------------------------------------------------------}

end.

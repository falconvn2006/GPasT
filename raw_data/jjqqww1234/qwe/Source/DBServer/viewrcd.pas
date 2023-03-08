unit viewrcd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ComCtrls, TabNotBk, MfdbDef, Grobal2, Buttons, ExtCtrls,
  HUtil32;

type
  TFrmFDBViewer = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    HumanGrid:   TStringGrid;
    BagItemGrid: TStringGrid;
    UseMagicGrid: TStringGrid;
    SaveItemGrid: TStringGrid;
    Panel1:      TPanel;
    BtnApply:    TButton;
    BtnReadOnly: TSpeedButton;
    Label1:      TLabel;
    ResetPosition: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnReadOnlyClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure ResetPositionClick(Sender: TObject);
  private
  public
    RecordIndex: integer;
    UserName: string;
    VRcd: FDBRecord; //UserData: TMirDBBlockData;
    procedure Refresh;
    procedure InitHumanGrid;
    procedure InitBagItemGrid;
    procedure InitSaveItemGrid;
    procedure InitUseMagicGrid;
    procedure RefreshHumanGrid;
    procedure RefreshBagItemGrid;
    procedure RefreshUseMagicGrid;
    procedure RefreshSaveItemGrid;
  end;

var
  FrmFDBViewer: TFrmFDBViewer;

implementation

uses passwd, FDBexpl;

{$R *.DFM}


procedure TFrmFDBViewer.FormCreate(Sender: TObject);
begin
  InitHumanGrid;
  InitBagItemGrid;
  InitSaveItemGrid;
  InitUseMagicGrid;
end;

procedure TFrmFDBViewer.Refresh;
var
  i: integer;
begin
  if HumanGrid.Visible then
    RefreshHumanGrid;
  if BagItemGrid.Visible then
    RefreshBagItemGrid;
  if UseMagicGrid.Visible then
    RefreshUseMagicGrid;
  if SaveItemGrid.Visible then
    RefreshSaveItemGrid;
end;

procedure TFrmFDBViewer.InitHumanGrid;
begin
  with HumanGrid do begin
    Cells[0, 1]   := 'Idx';
    Cells[1, 1]   := 'Name';
    Cells[2, 1]   := 'Map';
    Cells[3, 1]   := 'CX';
    Cells[4, 1]   := 'CY';
    Cells[5, 1]   := 'Dir';
    Cells[6, 1]   := 'Job';
    Cells[7, 1]   := 'Sex';
    Cells[8, 1]   := 'Hair';
    Cells[9, 1]   := 'Gold';
    Cells[10, 1]  := 'NeckName';
    Cells[11, 1]  := 'Home';
    Cells[0, 3]   := 'HomeX';
    Cells[1, 3]   := 'HomeY';
    Cells[2, 3]   := 'Level';
    Cells[3, 3]   := 'AC';
    Cells[4, 3]   := 'MAC';
    Cells[5, 3]   := 'Reserved1';
    Cells[6, 3]   := 'DC/1';
    Cells[7, 3]   := 'DC/2';
    Cells[8, 3]   := 'MC/1';
    Cells[9, 3]   := 'MC/2';
    Cells[10, 3]  := 'SC/1';
    Cells[11, 3]  := 'SC/2';
    Cells[0, 5]   := 'Reserved2';
    Cells[1, 5]   := 'HP';
    Cells[2, 5]   := 'MaxHP';
    Cells[3, 5]   := 'MP';
    Cells[4, 5]   := 'MaxMP';
    Cells[5, 5]   := 'Reserved2';
    Cells[6, 5]   := 'Exp';
    Cells[7, 5]   := 'MaxExp';
    Cells[8, 5]   := 'PK-Point';
    Cells[9, 5]   := '';
    Cells[10, 5]  := 'ID';
    Cells[11, 5]  := 'Latest';
    Cells[0, 7]   := '';
    Cells[1, 7]   := '';
    Cells[2, 7]   := '';
    Cells[3, 7]   := '';
    Cells[4, 7]   := '';
    Cells[5, 7]   := '';
    Cells[6, 7]   := '';
    Cells[7, 7]   := '';
    Cells[8, 7]   := '';
    Cells[9, 7]   := '';
    Cells[10, 7]  := '';
    Cells[11, 7]  := '';
    Cells[0, 9]   := '';
    Cells[1, 9]   := '';
    Cells[2, 9]   := '';
    Cells[3, 9]   := '';
    Cells[4, 9]   := '';
    Cells[5, 9]   := '';
    Cells[6, 9]   := '';
    Cells[7, 9]   := '';
    Cells[8, 9]   := '';
    Cells[9, 9]   := '';
    Cells[10, 9]  := '';
    Cells[11, 9]  := '';
    Cells[0, 11]  := '';
    Cells[1, 11]  := '';
    Cells[2, 11]  := '';
    Cells[3, 11]  := '';
    Cells[4, 11]  := '';
    Cells[5, 11]  := '';
    Cells[6, 11]  := '';
    Cells[7, 11]  := '';
    Cells[8, 11]  := '';
    Cells[9, 11]  := '';
    Cells[10, 11] := '';
    Cells[11, 11] := '';
    Cells[0, 13]  := '';
    Cells[1, 13]  := '';
    Cells[2, 13]  := '';
    Cells[3, 13]  := '';
    Cells[4, 13]  := '';
    Cells[5, 13]  := '-';
    Cells[6, 13]  := '-';
    Cells[7, 13]  := '-';
    Cells[8, 13]  := '-';
    Cells[9, 13]  := '-';
    Cells[10, 13] := '-';
    Cells[11, 13] := '-';
  end;
end;

procedure TFrmFDBViewer.InitBagItemGrid;
begin
  with BagItemGrid do begin
    Cells[0, 0] := 'IDX';
    Cells[1, 0] := 'ID';
    Cells[2, 0] := 'Item Index';
    Cells[3, 0] := 'Durability';
  end;
end;

procedure TFrmFDBViewer.InitSaveItemGrid;
begin
  with SaveItemGrid do begin
    Cells[0, 0] := 'Make Serial';
    Cells[1, 0] := 'Index';
    Cells[2, 0] := 'Durablilty';
  end;
end;

procedure TFrmFDBViewer.InitUseMagicGrid;
begin
  with UseMagicGrid do begin
    Cells[0, 0] := 'MagicName';
    Cells[1, 0] := 'UseKey';
    Cells[2, 0] := 'CurTrain';
  end;
end;

procedure TFrmFDBViewer.RefreshHumanGrid;
begin
  with VRcd.Block.DBHuman, HumanGrid do begin
    Cells[0, 2]  := IntToStr(RecordIndex);
    Cells[1, 2]  := UserName;
    Cells[2, 2]  := MapName;
    Cells[3, 2]  := IntToStr(CX);
    Cells[4, 2]  := IntToStr(CY);
    Cells[5, 2]  := IntToStr(Dir);
    Cells[6, 2]  := IntToStr(Job);
    Cells[7, 2]  := IntToStr(Sex);
    Cells[8, 2]  := IntToStr(Hair);
    Cells[9, 2]  := IntToStr(Gold);
    Cells[10, 2] := NeckName;
    Cells[11, 2] := HomeMap;
    Cells[0, 4]  := IntToStr(HomeX);
    Cells[1, 4]  := IntToStr(HomeY);
    Cells[2, 4]  := IntToStr(Abil.Level);
    Cells[3, 4]  := IntToStr(Abil.AC);
    Cells[4, 4]  := IntToStr(Abil.MAC);
    Cells[5, 4]  := IntToStr(Abil.Reserved1);
    Cells[6, 4]  := IntToStr(Lobyte(Abil.DC));
    Cells[7, 4]  := IntToStr(Hibyte(Abil.DC));
    Cells[8, 4]  := IntToStr(Lobyte(Abil.MC));
    Cells[9, 4]  := IntToStr(Hibyte(Abil.MC));
    Cells[10, 4] := IntToStr(Lobyte(Abil.SC));
    Cells[11, 4] := IntToStr(Hibyte(Abil.SC));
    Cells[0, 6]  := IntToStr(Abil.ExpCount);
    Cells[1, 6]  := IntToStr(Abil.HP);
    Cells[2, 6]  := IntToStr(Abil.MaxHP);
    Cells[3, 6]  := IntToStr(Abil.MP);
    Cells[4, 6]  := IntToStr(Abil.MaxMP);
    Cells[5, 6]  := IntToStr(Abil.ExpCount);
    Cells[6, 6]  := IntToStr(Abil.Exp);
    Cells[7, 6]  := IntToStr(Abil.MaxExp);
    Cells[8, 6]  := IntToStr(PKPoint);
    Cells[9, 6]  := '';
    Cells[10, 6] := UserId;
    Cells[11, 6] := DateTimeToStr(SolveDouble(VRcd.UpdateDateTime));

  end;
end;

procedure TFrmFDBViewer.RefreshBagItemGrid;

  procedure DrawCell(idx: string; r: integer; uitem: TUserItem);
  begin
    with BagItemGrid do begin
      Cells[0, r] := idx;
      Cells[1, r] := IntToStr(uitem.MakeIndex);
      Cells[2, r] := IntToStr(uitem.Index);
      Cells[3, r] := IntToStr(uitem.Dura) + '/' + IntToStr(uitem.DuraMax);
    end;
  end;

var
  i, j: integer;
begin
  with BagItemGrid do
    for i := 1 to RowCount - 1 do begin
      for j := 0 to ColCount - 1 do
        Cells[j, i] := '';
    end;
  with VRcd.Block.DBBagItem, BagItemGrid do begin
    DrawCell('Dress', 1, uDress);
    DrawCell('Weapon', 2, uWeapon);
    DrawCell('Helmet', 3, uHelmet);
    DrawCell('Necklace', 4, uNecklace);
    DrawCell('ArmRL', 5, uArmRingL);
    DrawCell('ArmRR', 6, uArmRingR);
    DrawCell('RingL', 7, uRingL);
    DrawCell('RingR', 8, uRingR);
    for i := 0 to MAXBAGITEM - 1 do begin
      if Bags[i].Index = 0 then
        break;  //Index = 0 ����
      DrawCell(IntToStr(i + 1), 9 + i, Bags[i]);
    end;
  end;
end;

procedure TFrmFDBViewer.RefreshUseMagicGrid;
var
  i, j: integer;
begin
  with UseMagicGrid do
    for i := 1 to RowCount - 1 do begin
      for j := 0 to ColCount - 1 do
        Cells[j, i] := '';
    end;
  with VRcd.Block.DBUseMagic, UseMagicGrid do begin
    for i := 0 to 19 do begin
      if Magics[i].MagicId <= 0 then
        break;
      Cells[0, 1 + i] := IntToStr(Magics[i].MagicId);
      Cells[1, 1 + i] := Magics[i].Key;
      Cells[2, 1 + i] := IntToStr(Magics[i].CurTrain);
    end;
  end;
end;

procedure TFrmFDBViewer.RefreshSaveItemGrid;
var
  i, j: integer;
begin
  with SaveItemGrid do
    for i := 1 to RowCount - 1 do begin
      for j := 0 to ColCount - 1 do
        Cells[j, i] := '';
    end;
  with VRcd.Block.DBSaveItem, SaveItemGrid do begin
    for i := 0 to MAXSAVEITEM - 1 do begin
      if Items[i].MakeIndex > 0 then begin
        Cells[0, 1 + i] := IntToStr(Items[i].MakeIndex);
        Cells[1, 1 + i] := IntToStr(Items[i].Index);
        Cells[2, 1 + i] := IntToStr(Items[i].Dura) + '/' +
          IntToStr(Items[i].DuraMax);
      end;
    end;
  end;
end;

procedure TFrmFDBViewer.BtnReadOnlyClick(Sender: TObject);
begin
  if BtnReadOnly.Down then begin
    if PasswordDlg.Execute then begin
      HumanGrid.Options    := HumanGrid.Options + [goEditing];
      BagItemGrid.Options  := BagItemGrid.Options + [goEditing];
      UseMagicGrid.Options := UseMagicGrid.Options + [goEditing];
      SaveItemGrid.Options := SaveItemGrid.Options + [goEditing];
      HumanGrid.Color      := clOlive;
      BagItemGrid.Color    := clOlive;
      UseMagicGrid.Color   := clOlive;
      SaveItemGrid.Color   := clOlive;
    end else
      BtnReadOnly.Down := False;
  end else begin
    HumanGrid.Options    := HumanGrid.Options - [goEditing];
    BagItemGrid.Options  := BagItemGrid.Options - [goEditing];
    UseMagicGrid.Options := UseMagicGrid.Options - [goEditing];
    SaveItemGrid.Options := SaveItemGrid.Options - [goEditing];
    HumanGrid.Color      := clWindow;
    BagItemGrid.Color    := clWindow;
    UseMagicGrid.Color   := clWindow;
    SaveItemGrid.Color   := clWindow;
  end;
end;

procedure TFrmFDBViewer.BtnApplyClick(Sender: TObject);

  procedure ReadCell(r: integer; var uitem: TUserItem);
  begin
    with BagItemGrid do begin
    end;
  end;

var
  i: integer;
begin
  with VRcd.Block.DBHuman, HumanGrid do begin
  end;

  with VRcd.Block.DBBagItem, BagItemGrid do begin
    ReadCell(1, uDress);
    ReadCell(2, uWeapon);
    ReadCell(3, uHelmet);
    ReadCell(4, uNecklace);
    ReadCell(5, uArmRingL);
    ReadCell(6, uArmRingR);
    ReadCell(7, uRingL);
    ReadCell(8, uRingR);
    for i := 0 to MAXBAGITEM - 1 do begin
      ReadCell(9 + i, Bags[i]);
    end;
  end;

  with VRcd.Block.DBUseMagic, UseMagicGrid do begin
  end;

  ///FrmFDBExplore.UpdateWorkRecord;
end;


procedure TFrmFDBViewer.ResetPositionClick(Sender: TObject);
begin
  VRcd.Block.DBHuman.Abil.HP := 0;  //�������� �ٽ� �����Ѵ�.
  VRcd.Block.DBHuman.HomeMap := '';
  FrmFDBExplore.UpdateWorkRecord;
end;

end.

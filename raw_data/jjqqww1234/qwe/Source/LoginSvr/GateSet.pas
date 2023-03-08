unit GateSet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, HUtil32, mudutil;

type
  TFrmGateSetting = class(TForm)
    CbGateList: TComboBox;
    Label2:     TLabel;
    Label3:     TLabel;
    Label4:     TLabel;
    EdPrivateAddr: TEdit;
    EdPublicAddr: TEdit;
    Label5:     TLabel;
    CkGate1:    TCheckBox;
    EdGate1:    TEdit;
    CkGate2:    TCheckBox;
    EdGate2:    TEdit;
    CkGate3:    TCheckBox;
    EdGate3:    TEdit;
    CkGate4:    TCheckBox;
    EdGate4:    TEdit;
    Label6:     TLabel;
    CkGate5:    TCheckBox;
    EdGate5:    TEdit;
    Label7:     TLabel;
    CkGate6:    TCheckBox;
    EdGate6:    TEdit;
    CkGate7:    TCheckBox;
    EdGate7:    TEdit;
    CkGate8:    TCheckBox;
    EdGate8:    TEdit;
    CkGate9:    TCheckBox;
    EdGate9:    TEdit;
    Label8:     TLabel;
    CkGate10:   TCheckBox;
    EdGate10:   TEdit;
    Label9:     TLabel;
    Label10:    TLabel;
    Label11:    TLabel;
    Label12:    TLabel;
    Label13:    TLabel;
    Label14:    TLabel;
    Label15:    TLabel;
    Label16:    TLabel;
    Label17:    TLabel;
    Label18:    TLabel;
    BtnOk:      TBitBtn;
    BtnClose:   TBitBtn;
    BtnChangeTitle: TSpeedButton;
    EdTitle:    TEdit;
    Label1:     TLabel;
    CbServerList: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CbGateListChange(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnChangeTitleClick(Sender: TObject);
    procedure CbServerListChange(Sender: TObject);
  private
    EdGates: array[0..9] of TEdit;
    CkGates: array[0..9] of TCheckBox;
  public
    procedure Execute;
  end;

var
  FrmGateSetting: TFrmGateSetting;

implementation

uses
  LMain;

{$R *.DFM}


procedure TFrmGateSetting.FormCreate(Sender: TObject);
begin
  EdGates[0] := EdGate1;
  EdGates[1] := EdGate2;
  EdGates[2] := EdGate3;
  EdGates[3] := EdGate4;
  EdGates[4] := EdGate5;
  EdGates[5] := EdGate6;
  EdGates[6] := EdGate7;
  EdGates[7] := EdGate8;
  EdGates[8] := EdGate9;
  EdGates[9] := EdGate10;

  CkGates[0] := CkGate1;
  CkGates[1] := CkGate2;
  CkGates[2] := CkGate3;
  CkGates[3] := CkGate4;
  CkGates[4] := CkGate5;
  CkGates[5] := CkGate6;
  CkGates[6] := CkGate7;
  CkGates[7] := CkGate8;
  CkGates[8] := CkGate9;
  CkGates[9] := CkGate10;
end;

procedure TFrmGateSetting.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TFrmGateSetting.Execute;
var
  i, j: integer;
  flag: boolean;
begin
  if MaxPubAddr <= 0 then
    exit;
  CBServerList.Items.Clear;
  for i := 0 to MaxPubAddr - 1 do begin
    flag := True;
    for j := 0 to CbServerList.Items.Count - 1 do begin
      if CbServerList.Items[j] = PubAddrTable[i].ServerName then
        flag := False;
    end;
    if flag then
      CbServerList.Items.Add(PubAddrTable[i].ServerName);
  end;

  CBServerList.ItemIndex := 0;
  CbServerListChange(self);
  ShowModal;
end;


procedure TFrmGateSetting.CbServerListChange(Sender: TObject);
var
  i, sidx: integer;
  sname:   string;
begin
  sidx := CbServerList.ItemIndex;
  if sidx < 0 then
    exit;
  sname := CbServerList.Items[sidx];

  CbGateList.Items.Clear;
  for i := 0 to MaxPubAddr - 1 do
    if PubAddrTable[i].ServerName = sname then
      CbGateList.Items.Add(PubAddrTable[i].Title);
  CbGateList.ItemIndex := 0;
  CbGateListChange(self);
end;

procedure TFrmGateSetting.CbGateListChange(Sender: TObject);
var
  i, n, gn, sidx: integer;
  gname, svname:  string;
begin
  sidx := CbServerList.ItemIndex;
  if sidx < 0 then
    exit;
  svname := CbServerList.Items[sidx];

  n := CbGateList.ItemIndex;
  if n < 0 then
    exit;
  gname := CbGateList.Items[n];
  EdTitle.Text := gname;
  gn    := -1;
  for i := 0 to MAX_PUBADDR - 1 do begin
    if PubAddrTable[i].Title = gname then begin
      gn := i;
      break;
    end;
  end;
  if gn >= 0 then begin
    EdPrivateAddr.Text := PubAddrTable[gn].RemoteAddr;
    EdPublicAddr.Text  := PubAddrTable[gn].PublicAddr;
    for i := 0 to 9 do begin
      if PubAddrTable[gn].PubGates[i].Addr <> '' then
        EdGates[i].Text :=
          PubAddrTable[gn].PubGates[i].Addr + ':' +
          IntToStr(PubAddrTable[gn].PubGates[i].Port)
      else
        EdGates[i].Text := '';
      CkGates[i].Checked := PubAddrTable[gn].PubGates[i].Enabled;
    end;
  end;
end;

procedure TFrmGateSetting.BtnOkClick(Sender: TObject);
var
  i, n, gn, nport: integer;
  gname, addrstr, portstr: string;
begin
  n := CbGateList.ItemIndex;
  if n < 0 then
    exit;
  for i := 0 to 9 do begin
    if EdGates[i].Text <> '' then begin
      portstr := GetValidStr3(Trim(EdGates[i].Text), addrstr, [':']);
      if addrstr <> '' then
        if Str_ToInt(portstr, 0) = 0 then begin
          Beep;
          exit;
        end;
    end;
  end;

  n := CbGateList.ItemIndex;
  if n < 0 then
    exit;
  gname := CbGateList.Items[n];
  gn    := -1;
  for i := 0 to MAX_PUBADDR - 1 do begin
    if PubAddrTable[i].Title = gname then begin
      gn := i;
      break;
    end;
  end;

  if gn >= 0 then begin
    PubAddrTable[gn].RemoteAddr := EdPrivateAddr.Text;
    PubAddrTable[gn].PublicAddr := EdPublicAddr.Text;
    for i := 0 to 9 do begin
      portstr := GetValidStr3(Trim(EdGates[i].Text), addrstr, [':']);
      if addrstr <> '' then begin
        PubAddrTable[gn].PubGates[i].Addr    := addrstr;
        PubAddrTable[gn].PubGates[i].Port    := Str_ToInt(portstr, 0);
        PubAddrTable[gn].PubGates[i].Enabled := CkGates[i].Checked;
      end;
    end;
    SaveAddressTable;
  end;
end;

procedure TFrmGateSetting.BtnChangeTitleClick(Sender: TObject);
var
  n:   integer;
  str: string;
begin
  n := CbGateList.ItemIndex;
  if n < 0 then
    exit;
  str := ReplaceChar(Trim(EdTitle.Text), ' ', '_');
  CbGateList.Items[n] := str;
  PubAddrTable[n].Title := str;
  CbGateList.ItemIndex := n;
end;

end.

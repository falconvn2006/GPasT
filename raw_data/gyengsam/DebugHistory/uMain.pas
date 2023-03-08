unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, VirtualTrees;

const
  MaxPostMsgLength = 2048;

type
  PDebugMessage = ^TDebugMessage;
  TDebugMessage = record
    Time : string;
    Level1 : string;
    Level2 : string;
    InspTime : string;
    FuncType : string;
    Mode : string;
    OkNg: String;
    DebugMsg : String;
    OkNgFontColor : TColor;
    FuncFontColor : TColor;
  end;

  PDefectData = ^TDefectData;
  TDefectData = record
    MachineNo : Integer;
    Time : TDateTime;
    Level1 : Integer;//ThreadNo
    Level2 : Integer;//Level
    InspTime : Integer;
    FuncType : array [0..255] of AnsiChar;//DefectName
    Mode : array [0..30] of AnsiChar;
    OkNg : array [0..30] of AnsiChar;
    DebugMsg : array [0..1024] of AnsiChar;
  end;

  TfmLog = class(TForm)
    Panel1: TPanel;
    btLoadToOldLogData: TButton;
    cbSetNo: TComboBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    VST1: TVirtualStringTree;
    VST2: TVirtualStringTree;
    VST3: TVirtualStringTree;
    VST5: TVirtualStringTree;
    VST4: TVirtualStringTree;
    lbVersion: TLabel;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btLoadToOldLogDataClick(Sender: TObject);
    procedure VST1BeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure VST2BeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure VST3BeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure VST4BeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure VST5BeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure VST5FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VST4FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VST3FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VST2FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VST1FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VST1GetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VST2GetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VST3GetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VST4GetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VST5GetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VST5GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VST4GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VST3GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VST2GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VST1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VST1PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure VST2PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure VST3PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure VST4PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure VST5PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
  public
    { Public declarations }
    tList : TStringList;
    function StringParserType(orgStr, SepStr: string; Strings: TStringList): Integer;
  end;

var
  fmLog: TfmLog;
  cDir : string;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfmLog.btLoadToOldLogDataClick(Sender: TObject);
var
  LogFile, sData : string;
  VST : TVirtualStringTree;
  i, x : Integer;
  Data: PDebugMessage;
  Node : PVirtualNode;
  tempList : TStringList;
begin
  btLoadToOldLogData.Enabled := false;
  tempList := TStringList.Create;

  try
    LogFile := format('%s\NewInspLog\Temp\SET_%d.txt', [cDir, cbSetNo.ItemIndex + 1]);
    if not FileExists(LogFile) then
    begin
      ShowMessage('Do not have a Old Log Info File');
      exit;
    end;

    tList.LoadFromFile(LogFile);

    case cbSetNo.ItemIndex of
      0 : VST := VST1;
      1 : VST := VST2;
      2 : VST := VST3;
      3 : VST := VST4;
      4 : VST := VST5;
    end;

    VST.Clear;
    for i := 0 to tList.Count-1 do
    begin
      sData := tList.Strings[i];
      StringParserType(sData, #$9 ,tempList);
      if tempList.Count <> 8 then
          Continue;

      Node := VST.AddChild(nil);
      if Assigned(Node) then
      begin
        Data := VST.GetNodeData(Node);

        Data.Time := tempList.Strings[0];
        Data.Level1 := tempList.Strings[1];
        Data.Level2 := tempList.Strings[2];
        Data.InspTime := tempList.Strings[3];
        Data.FuncType := tempList.Strings[4];
        Data.Mode := tempList.Strings[5];
        Data.OkNg := tempList.Strings[6];
        Data.DebugMsg := tempList.Strings[7];

        if Data.OkNg = 'OK' then
          Data.OkNgFontColor := clBlue
        else if Data.OkNg = 'NG' then
          Data.OkNgFontColor := clRed
        else if Data.OkNg = 'NG(NoCheck)' then
          Data.OkNgFontColor := clPurple
        else if Data.OkNg = 'Skip' then
          Data.OkNgFontColor := clGray
        else
          Data.OkNgFontColor := clBlack;

        if Data.OkNg = 'TotalOK' then
          Data.FuncFontColor := clBlue
        else if Data.OkNg = 'TotalNG' then
          Data.FuncFontColor := clRed
        else if Data.OkNg = 'NG(NoCheck)' then
          Data.FuncFontColor := clPurple
        else if Data.OkNg = 'Skip' then
          Data.FuncFontColor := clGray
        else
          Data.FuncFontColor := clBlack;
      end;
    end;

    Node := VST.GetLast;
    VST.Selected[Node] := True;
  finally
    btLoadToOldLogData.Enabled := true;
    tempList.Free;
  end;
end;

procedure TfmLog.Button1Click(Sender: TObject);
begin
  case cbSetNo.ItemIndex of
    0 : VST1.Clear;
    1 : VST2.Clear;
    2 : VST3.Clear;
    3 : VST4.Clear;
    4 : VST5.Clear;
  end;
end;

procedure TfmLog.FormCreate(Sender: TObject);
begin
  tList := TStringList.Create;
  cDir := GetCurrentDir;
end;

procedure TfmLog.FormDestroy(Sender: TObject);
begin
  tList.Free;
end;

procedure TfmLog.FormShow(Sender: TObject);
begin
  cbSetNo.ItemIndex := 0;
  PageControl1.ActivePage := TabSheet1;
end;


function TfmLog.StringParserType(orgStr, SepStr: string;
  Strings: TStringList): Integer;
var
  i, No : Integer;
  str, FieldSep, strData : string;
  Det : Boolean;
begin
  i := 0;
  str := orgStr;
  Det := false;

  Strings.Clear;

  repeat
    FieldSep := SepStr;
    No := Pos(FieldSep, str);

    if No >= 1 then
    begin
      Det := true;
      strData := copy(str,1, No - 1);

      //if strData = '' then
      //  Strings.Add('.')
      //else
        Strings.Add(strData);
    end else
    begin
      if Length(str) = 0 then
      begin
        if Det then
          Strings.Add('');

        break;
      end else
      begin
        Strings.Add(str);
        break;
      end;
    end;

    delete(str,1,No);
    Inc(i);
  until false;

  Result := i;
end;

procedure TfmLog.VST1BeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Data.OkNg = 'Exception' then
    begin
      TargetCanvas.Brush.Color := clRed;
      TargetCanvas.FillRect(CellRect);
    end else
    begin
      if Node.Index mod 2 = 0 then
      begin
        TargetCanvas.Brush.Color := clWindow;//$E0E0E0;
        TargetCanvas.FillRect(CellRect);
      end else
      begin
        TargetCanvas.Brush.Color := clCream;//$E0E0E0;
        TargetCanvas.FillRect(CellRect);
      end;
    end;
  end;
end;

procedure TfmLog.VST1FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  // Explicitely free the string, the VCL cannot know that there is one but needs to free
  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
  // every member individually.
  Finalize(Data^);
end;

procedure TfmLog.VST1GetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  VST1.NodeDataSize := sizeof(TDebugMessage);
end;

procedure TfmLog.VST1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 : CellText := Data.Level1;//Data.Level1.ToString;
      1 : CellText := Data.Level2;//Data.Level2.ToString;
      2 : CellText := Data.Time;//FormatDateTime('hh:nn:ss.zzz', Data.Time);
      3 : CellText := Data.InspTime;//if Data.InspTime = -1 then CellText := '--' else CellText := Data.InspTime.ToString;
      4 : CellText := Data.FuncType;
      5 : CellText := Data.Mode;
      6 : CellText := Data.OkNg;
      7 : CellText := Data.DebugMsg;
    end;
  end;
end;

procedure TfmLog.VST1PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Column = 6 then
      TargetCanvas.Font.Color := Data.OkNgFontColor;

    if (Column = 4) or (Column = 7) then
      TargetCanvas.Font.Color := Data.FuncFontColor;
  end;
end;

procedure TfmLog.VST2BeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Node.Index mod 2 = 0 then
    begin
      TargetCanvas.Brush.Color := clWindow;//$E0E0E0;
      TargetCanvas.FillRect(CellRect);
    end else
    begin
      TargetCanvas.Brush.Color := clCream;//$E0E0E0;
      TargetCanvas.FillRect(CellRect);
    end;
  end;
end;

procedure TfmLog.VST2FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  // Explicitely free the string, the VCL cannot know that there is one but needs to free
  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
  // every member individually.
  Finalize(Data^);
end;

procedure TfmLog.VST2GetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  VST2.NodeDataSize := sizeof(TDebugMessage);
end;

procedure TfmLog.VST2GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 : CellText := Data.Level1;//Data.Level1.ToString;
      1 : CellText := Data.Level2;//Data.Level2.ToString;
      2 : CellText := Data.Time;//FormatDateTime('hh:nn:ss.zzz', Data.Time);
      3 : CellText := Data.InspTime;//if Data.InspTime = -1 then CellText := '--' else CellText := Data.InspTime.ToString;
      4 : CellText := Data.FuncType;
      5 : CellText := Data.Mode;
      6 : CellText := Data.OkNg;
      7 : CellText := Data.DebugMsg;
    end;
  end;
end;

procedure TfmLog.VST2PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Column = 6 then
      TargetCanvas.Font.Color := Data.OkNgFontColor;

    if (Column = 4) or (Column = 7) then
      TargetCanvas.Font.Color := Data.FuncFontColor;
  end;
end;

procedure TfmLog.VST3BeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Node.Index mod 2 = 0 then
    begin
      TargetCanvas.Brush.Color := clWindow;//$E0E0E0;
      TargetCanvas.FillRect(CellRect);
    end else
    begin
      TargetCanvas.Brush.Color := clCream;//$E0E0E0;
      TargetCanvas.FillRect(CellRect);
    end;
  end;
end;

procedure TfmLog.VST3FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  // Explicitely free the string, the VCL cannot know that there is one but needs to free
  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
  // every member individually.
  Finalize(Data^);
end;

procedure TfmLog.VST3GetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  VST3.NodeDataSize := sizeof(TDebugMessage);
end;

procedure TfmLog.VST3GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 : CellText := Data.Level1;//Data.Level1.ToString;
      1 : CellText := Data.Level2;//Data.Level2.ToString;
      2 : CellText := Data.Time;//FormatDateTime('hh:nn:ss.zzz', Data.Time);
      3 : CellText := Data.InspTime;//if Data.InspTime = -1 then CellText := '--' else CellText := Data.InspTime.ToString;
      4 : CellText := Data.FuncType;
      5 : CellText := Data.Mode;
      6 : CellText := Data.OkNg;
      7 : CellText := Data.DebugMsg;
    end;
  end;
end;

procedure TfmLog.VST3PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Column = 6 then
      TargetCanvas.Font.Color := Data.OkNgFontColor;

    if (Column = 4) or (Column = 7) then
      TargetCanvas.Font.Color := Data.FuncFontColor;
  end;
end;

procedure TfmLog.VST4BeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Node.Index mod 2 = 0 then
    begin
      TargetCanvas.Brush.Color := clWindow;//$E0E0E0;
      TargetCanvas.FillRect(CellRect);
    end else
    begin
      TargetCanvas.Brush.Color := clCream;//$E0E0E0;
      TargetCanvas.FillRect(CellRect);
    end;
  end;
end;

procedure TfmLog.VST4FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  // Explicitely free the string, the VCL cannot know that there is one but needs to free
  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
  // every member individually.
  Finalize(Data^);
end;

procedure TfmLog.VST4GetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  VST4.NodeDataSize := sizeof(TDebugMessage);
end;

procedure TfmLog.VST4GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 : CellText := Data.Level1;//Data.Level1.ToString;
      1 : CellText := Data.Level2;//Data.Level2.ToString;
      2 : CellText := Data.Time;//FormatDateTime('hh:nn:ss.zzz', Data.Time);
      3 : CellText := Data.InspTime;//if Data.InspTime = -1 then CellText := '--' else CellText := Data.InspTime.ToString;
      4 : CellText := Data.FuncType;
      5 : CellText := Data.Mode;
      6 : CellText := Data.OkNg;
      7 : CellText := Data.DebugMsg;
    end;
  end;
end;

procedure TfmLog.VST4PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Column = 6 then
      TargetCanvas.Font.Color := Data.OkNgFontColor;

    if (Column = 4) or (Column = 7) then
      TargetCanvas.Font.Color := Data.FuncFontColor;
  end;
end;

procedure TfmLog.VST5BeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Node.Index mod 2 = 0 then
    begin
      TargetCanvas.Brush.Color := clWindow;//$E0E0E0;
      TargetCanvas.FillRect(CellRect);
    end else
    begin
      TargetCanvas.Brush.Color := clCream;//$E0E0E0;
      TargetCanvas.FillRect(CellRect);
    end;

    if Data.OkNg = 'Exception' then
    begin
      TargetCanvas.Brush.Color := clRed;
      TargetCanvas.FillRect(CellRect);
    end;
  end;
end;

procedure TfmLog.VST5FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  // Explicitely free the string, the VCL cannot know that there is one but needs to free
  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
  // every member individually.
  Finalize(Data^);
end;

procedure TfmLog.VST5GetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  VST5.NodeDataSize := sizeof(TDebugMessage);
end;

procedure TfmLog.VST5GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 : CellText := Data.Level1;//Data.Level1.ToString;
      1 : CellText := Data.Level2;//Data.Level2.ToString;
      2 : CellText := Data.Time;//FormatDateTime('hh:nn:ss.zzz', Data.Time);
      3 : CellText := Data.InspTime;//if Data.InspTime = -1 then CellText := '--' else CellText := Data.InspTime.ToString;
      4 : CellText := Data.FuncType;
      5 : CellText := Data.Mode;
      6 : CellText := Data.OkNg;
      7 : CellText := Data.DebugMsg;
    end;
  end;
end;

procedure TfmLog.VST5PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PDebugMessage;
begin
  Data := Sender.GetNodeData(Node);

  if Assigned(Data) then
  begin
    if Column = 6 then
      TargetCanvas.Font.Color := Data.OkNgFontColor;

    if (Column = 4) or (Column = 7) then
      TargetCanvas.Font.Color := Data.FuncFontColor;
  end;
end;


procedure TfmLog.WMCopyData(var Msg: TMessage);
var
  pRecData : PDefectData;
  DataBuf : TCopyDataStruct;
  DefectData : TDefectData;
  Data: PDebugMessage;
  Node : PVirtualNode;
  VST : TVirtualStringTree;
begin
  DefectData:= TDefectData(PCopyDataStruct(Msg.lparam)^.lpData^);

  case DefectData.MachineNo of
    0 : VST := VST1;
    1 : VST := VST2;
    2 : VST := VST3;
    3 : VST := VST4;
    4 : VST := VST5;
  end;

  if DefectData.Level2 = 100 then
  begin
    VST.Clear;
    exit;
  end;

  Node := VST.AddChild(nil);
  if Assigned(Node) then
    Data := VST.GetNodeData(Node);

  if Assigned(Node) then
  begin
    Data.Time := FormatDateTime('hh:nn:ss.zzz', DefectData.Time);
    Data.Level1 := DefectData.Level1.ToString;//DefectData.ThreadNo
    Data.Level2 := DefectData.Level2.ToString;
    if DefectData.InspTime = -1 then
      Data.InspTime := '--'
    else
      Data.InspTime := DefectData.InspTime.ToString;

    Data.FuncType := String(DefectData.FuncType);
    Data.Mode := String(DefectData.Mode);
    Data.OkNg := String(DefectData.OkNg);
    Data.DebugMsg := String(DefectData.DebugMsg);

    if Data.OkNg = 'OK' then
      Data.OkNgFontColor := clBlue
    else if Data.OkNg = 'NG' then
      Data.OkNgFontColor := clRed
    else if Data.OkNg = 'NG(NoCheck)' then
      Data.OkNgFontColor := clPurple
    else if Data.OkNg = 'Skip' then
      Data.OkNgFontColor := clGray
    else
      Data.OkNgFontColor := clBlack;

    if Data.OkNg = 'TotalOK' then
      Data.FuncFontColor := clBlue
    else if Data.OkNg = 'TotalNG' then
      Data.FuncFontColor := clRed
    else if Data.OkNg = 'NG(NoCheck)' then
      Data.FuncFontColor := clPurple
    else if Data.OkNg = 'Skip' then
      Data.FuncFontColor := clGray
    else
      Data.FuncFontColor := clBlack;
  end;

  case DefectData.MachineNo of
    0 : begin
          Node := VST1.GetLast;
          VST1.Selected[Node] := True;
    end;
    1 : begin
          Node := VST2.GetLast;
          VST2.Selected[Node] := True;
    end;
    2 : begin
          Node := VST3.GetLast;
          VST3.Selected[Node] := True;
    end;
    3 : begin
          Node := VST4.GetLast;
          VST4.Selected[Node] := True;
    end;
    4 : begin
          Node := VST5.GetLast;
          VST5.Selected[Node] := True;
    end;
  end;
end;



end.

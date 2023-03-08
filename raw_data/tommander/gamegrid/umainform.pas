unit umainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Spin, ugamegrid, GR32_Image, GR32_Layers, ugamecommon;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bitmap32List1: TBitmap32List;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Image32_1: TImage32;
    ImageList1: TImageList;
    Label1: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    tmrRepaint: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image32_1MouseLeave(Sender: TObject);
    procedure Image32_1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure Image32_1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image32_1Resize(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ScrollBar2Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure tmrRepaintTimer(Sender: TObject);
    procedure GGChangeMapSize(Sender: TObject);
    procedure GGChangeViewport(Sender: TObject);
    procedure GGLog(Sender: TObject);
  private
    var gg: TGameGrid;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
//  PaintBox32_1.;
  gg := TGameGrid.Create(Image32_1,Bitmap32List1);
  gg.OnChangeMapSize := @GGChangeMapSize;
  gg.OnChangeViewport := @GGChangeViewport;
  gg.OnLog := @GGLog;
  gg.MapSize := TMapSize.Make(3,2);
  gg.Viewport := TMapRect.Make(TMapPos.Make(0,0),3,2);
end;

procedure TForm1.Image32_1MouseLeave(Sender: TObject);
begin
  gg.FieldCursor.Create(0,0,false);
end;

procedure TForm1.Image32_1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
var fld: TMapPos;
    lidx: integer;
begin
  fld := gg.FieldFromXY(X,Y);
  lidx := -1;
  if Assigned(Layer) then
  begin
    lidx := Layer.Index;
  end;
  gg.FieldCursor := fld;
  Label1.Caption := Format('[%d;%d]=>[%d;%d;%d]', [X,Y,lidx,fld.X,fld.Y]);
end;

procedure TForm1.Image32_1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);

  procedure SetLayerInfo(TheLayer: TCustomLayer);
  var gn: TGameNeighbours;
      i: integer;
      s: string;
  begin
    Memo2.Lines.Clear;
    if not Assigned(TheLayer) then
    begin
      Memo2.Lines.Add('<nil>');
      Exit;
    end;
    if TheLayer is TGameLayer then
    begin
      Memo2.Lines.Add('Game Layer');
      Memo2.Lines.Add('Pos: %s', [(TheLayer as TGameLayer).Pos.ToStr()]);
      Memo2.Lines.Add('Size: %s', [(TheLayer as TGameLayer).Size.ToStr()]);
      Memo2.Lines.Add('Rect: %s', [(TheLayer as TGameLayer).Rect.ToStr()]);
      Memo2.Lines.Add('Data: %p', [(TheLayer as TGameLayer).Data]);
      Memo2.Lines.Add('Neighbours:');
      gn := gg.LayerNeighbours(TheLayer as TGameLayer);
      for i := Low(gn) to High(gn) do
      begin
        s := '<nil>';
        if Assigned(gn[i].Layer) then
        begin
          s := gn[i].Layer.Rect.ToStr();
        end;
        Memo2.Lines.Add('  %d: %s%d %s', [i, MapDirToStr(gn[i].Direction), gn[i].Index, s]);
      end;
      Exit;
    end;
  end;

  procedure UpdateFieldSelected();
  begin
    if Assigned(Layer) and (Layer is TGameLayer) then
    begin
      gg.FieldSelected := (Layer as TGameLayer).Pos;
    end
    else
    begin
      gg.FieldSelected.Create(0,0,false);
    end;
  end;

begin
  UpdateFieldSelected();

  if (Button = mbLeft) then
  begin
    SetLayerInfo(Layer);
    Exit;
  end;
  if (Button = mbMiddle) then
  begin
    if gg.AddObject(Random(Bitmap32List1.Bitmaps.Count), gg.FieldFromXY(X,Y), TMapSize.Make(1,1), nil) = -1 then
    begin
      showmessage('Cannot');
    end;
    Exit;
  end;
  if (Button = mbRight) then
  begin
    if gg.AddObject(Random(Bitmap32List1.Bitmaps.Count), gg.FieldFromXY(X,Y), TMapSize.Make(2,1), nil) = -1 then
    begin
      showmessage('Cannot');
    end;
    Exit;
  end;
end;

procedure TForm1.Image32_1Resize(Sender: TObject);
begin
  tmrRepaint.Enabled := false;
  tmrRepaint.Enabled := true;
end;

procedure TForm1.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
//var vw: QWord;
begin
//  vw := gg.Viewport.Width;
  gg.Viewport := TMapRect.Make(TMapPos.Make(ScrollPos, gg.Viewport.Top), gg.Viewport.Width, gg.Viewport.Height);
//  gg.Viewport.Width := vw;
end;

procedure TForm1.ScrollBar2Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
//var vh: QWord;
begin
//  vh := gg.Viewport.Height;
  gg.Viewport := TMapRect.Make(TMapPos.Make(gg.Viewport.Left, ScrollPos), gg.Viewport.Width, gg.Viewport.Height);
//  gg.Viewport.Height := vh;
end;

procedure TForm1.tmrRepaintTimer(Sender: TObject);
begin
  gg.UpdateLayers;
  tmrRepaint.Enabled := false;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Image32_1.Invalidate;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  gg.MapSize := TMapSize.Make(SpinEdit1.Value, SpinEdit2.Value);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  gg.Viewport := TMapRect.Make(TMapPos.Make(gg.Viewport.Left, gg.Viewport.Top), SpinEdit5.Value, SpinEdit6.Value);
end;

procedure TForm1.GGChangeMapSize(Sender: TObject);
begin
  SpinEdit1.Value := gg.MapSize.Width;
  SpinEdit2.Value := gg.MapSize.Height;
end;

procedure TForm1.GGChangeViewport(Sender: TObject);
begin
  SpinEdit5.Value := gg.Viewport.Width;
  SpinEdit6.Value := gg.Viewport.Height;
  ScrollBar1.Max := gg.MapSize.Width-gg.Viewport.Width;
  ScrollBar2.Max := gg.MapSize.Height-gg.Viewport.Height;
end;

procedure TForm1.GGLog(Sender: TObject);
begin
  Memo1.Lines.Text := gg.Log;
end;

end.


unit ugamecommon;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TMapDir = (mdLeft,mdBottom,mdRight,mdTop);
  TMapPos = object
    X: QWord;
    Y: QWord;
    Valid: boolean;

    function Make(AX,AY: QWord; AValid: boolean = true): TMapPos; static;
    procedure Create(AX,AY: QWord; AValid: boolean = true);
    procedure FromPoint(APoint: TPoint; AValid: boolean = true);
    function ToPoint(): TPoint;
    function ToStr(): string;
  end;
  TMapSize = object
    Width: QWord;
    Height: QWord;
    Valid: boolean;

    function Make(AWidth,AHeight: QWord; AValid: boolean = true): TMapSize; static;
    procedure Create(AWidth,AHeight: QWord; AValid: boolean = true);
    procedure FromPoint(APoint: TPoint; AValid: boolean = true);
    function ToPoint(): TPoint;
    function ToStr(): string;
  end;
  TMapRect = object
    Left: QWord;
    Right: QWord;
    Top: QWord;
    Bottom: QWord;
    private
      procedure SetWidth(AWidth: QWord);
      function GetWidth(): QWord;
      procedure SetHeight(AHeight: QWord);
      function GetHeight(): QWord;
    public
      property Width: QWord read GetWidth write SetWidth;
      property Height: QWord read GetHeight write SetHeight;

      function Make(): TMapRect; static;
      function Make(ALeft,ATop,ARight,ABottom: QWord): TMapRect; static;
      function Make(ALeftTop: TMapPos; AWidth,AHeight: QWord): TMapRect; static;
      function Make(ALeftTop: TMapPos; ASize: TMapSize): TMapRect;
      procedure Create();
      procedure Create(ALeft,ATop,ARight,ABottom: QWord);
      procedure Create(ALeftTop: TMapPos; AWidth,AHeight: QWord);
      procedure Create(ALeftTop: TMapPos; ASize: TMapSize);
      procedure FromRect(ARect: TRect);
      function ToRect(): TRect;
      function ToStr(): string;
      function Contains(APos: TMapPos): boolean;
      function Contains(ARect: TMapRect; var FDebug: string): boolean;
      function Overflow(ARect: TMapRect): boolean;
  end;

operator =(a,b: TMapPos): boolean;
operator =(a,b: TMapSize): boolean;
operator =(a,b: TMapRect): boolean;

function MapDirToStr(ADir: TMapDir): string;

implementation

{ Global }

function MapDirToStr(ADir: TMapDir): string;
begin
  result := '';
  case ADir of
    mdLeft: result := 'L';
    mdBottom: result := 'B';
    mdRight: result := 'R';
    mdTop: result := 'T';
  end;
end;

{ TMapPos }

operator =(a,b: TMapPos): boolean;
begin
  result := (
    (a.X = b.X) and
    (a.Y = b.Y)
  );
end;

function TMapPos.Make(AX,AY: QWord; AValid: boolean = true): TMapPos; static;
begin
  result.Create(AX,AY,AValid);
end;

procedure TMapPos.Create(AX,AY: QWord; AValid: boolean = true);
begin
  X := AX;
  Y := AY;
  Valid := AValid;
end;

procedure TMapPos.FromPoint(APoint: TPoint; AValid: boolean = true);
begin
  X := APoint.X;
  Y := APoint.Y;
  Valid := AValid;
end;

function TMapPos.ToPoint(): TPoint;
begin
  if not Valid then
  begin
    raise Exception.Create('Trying to convert invalid TMapPos to TPoint');
  end;
  result.Create(X,Y);
end;

function TMapPos.ToStr(): string;
begin
  result := '['+UIntToStr(X)+';'+UIntToStr(Y)+';'+BoolToStr(Valid,'valid','invalid')+']';
end;

{ TMapSize }

operator =(a,b: TMapSize): boolean;
begin
  result := (
    (a.Width = b.Width) and
    (a.Height = b.Height)
  );
end;

function TMapSize.Make(AWidth,AHeight: QWord; AValid: boolean = true): TMapSize;
begin
  result.Create(AWidth, AHeight, AValid);
end;

procedure TMapSize.Create(AWidth,AHeight: QWord; AValid: boolean = true);
begin
  Width := AWidth;
  Height := AHeight;
  Valid := AValid;
end;

procedure TMapSize.FromPoint(APoint: TPoint; AValid: boolean = true);
begin
  Width := APoint.X;
  Height := APoint.Y;
  Valid := AValid;
end;

function TMapSize.ToPoint(): TPoint;
begin
  if not Valid then
  begin
    raise Exception.Create('Trying to convert invalid TMapSize to TPoint');
  end;
  result.Create(Width, Height);
end;

function TMapSize.ToStr(): string;
begin
  result := '['+UIntToStr(Width)+';'+UIntToStr(Height)+';'+BoolToStr(Valid,'valid','invalid')+']';
end;

{ TMapRect }

operator =(a,b: TMapRect): boolean;
begin
  result := (
    (a.Left = b.Left) and
    (a.Top = b.Top) and
    (a.Right = b.Right) and
    (a.Bottom = b.Bottom)
  );
end;

procedure TMapRect.SetWidth(AWidth: QWord);
begin
  if AWidth = 0 then
  begin
    Right := Left;
    Exit;
  end;
  Right := Left+AWidth-1;
//Left := Right-AWidth+1;
end;

function TMapRect.GetWidth(): QWord;
begin
  if Right < Left then
  begin
    result := 0;
    Exit;
  end;
  result := Right-Left+1;
end;

procedure TMapRect.SetHeight(AHeight: QWord);
begin
  if AHeight = 0 then
  begin
    Bottom := Top;
    Exit;
  end;
  Bottom := Top+AHeight-1;
end;

function TMapRect.GetHeight(): QWord;
begin
  if Bottom < Top then
  begin
    result := 0;
    Exit;
  end;
  result := Bottom-Top+1;
end;

function TMapRect.Make(): TMapRect;
begin
  result.Create();
end;

function TMapRect.Make(ALeft,ATop,ARight,ABottom: QWord): TMapRect;
begin
  result.Create(ALeft,ATop,ARight,ABottom);
end;

function TMapRect.Make(ALeftTop: TMapPos; AWidth,AHeight: QWord): TMapRect;
begin
  result.Create(ALeftTop,AWidth,AHeight);
end;

function TMapRect.Make(ALeftTop: TMapPos; ASize: TMapSize): TMapRect;
begin
  result.Create(ALeftTop,ASize);
end;

procedure TMapRect.Create();
begin
  Create(0,0,0,0);
end;

procedure TMapRect.Create(ALeft,ATop,ARight,ABottom: QWord);
begin
  Left := ALeft;
  Top := ATop;
  Right := ARight;
  Bottom := ABottom;
end;

procedure TMapRect.Create(ALeftTop: TMapPos; AWidth,AHeight: QWord);
begin
  Left := ALeftTop.X;
  Top := ALeftTop.Y;
  SetWidth(AWidth);
  SetHeight(AHeight);
end;

procedure TMapRect.Create(ALeftTop: TMapPos; ASize: TMapSize);
begin
  Create(ALeftTop, ASize.Width, ASize.Height);
end;

procedure TMapRect.FromRect(ARect: TRect);
begin
  Left := ARect.Left;
  Top := ARect.Top;
  Right := ARect.Right;
  Bottom := ARect.Bottom;
end;

function TMapRect.ToRect(): TRect;
begin
  result.Create(Left, Top, Right, Bottom);
end;

function TMapRect.ToStr(): string;
begin
  result := '['+UIntToStr(Left)+';'+UIntToStr(Top)+';'+UIntToStr(Right)+';'+UIntToStr(Bottom)+']';
end;

function TMapRect.Contains(APos: TMapPos): boolean;
begin
  result := (APos.X >= Left) and (APos.X <= Right) and (APos.Y >= Top) and (APos.Y <= Bottom);
end;

function TMapRect.Contains(ARect: TMapRect; var FDebug: string): boolean;
begin
  result := (not ((ARect.Left > Right) or (ARect.Right < Left) or (ARect.Top > Bottom) or (ARect.Bottom < Top)));
  FDebug := Format('[%d;%d;%d;%d]^[%d;%d;%d;%d] => %s', [Left, Top, Right, Bottom, ARect.Left, ARect.Top, ARect.Right, ARect.Bottom, BoolToStr(result, 'Contains', 'No contains')]);
end;

function TMapRect.Overflow(ARect: TMapRect): boolean;
begin
  result := ((ARect.Left < Left) or (ARect.Right > Right) or (ARect.Top < Top) or (ARect.Bottom > Bottom));
end;

end.


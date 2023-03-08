unit readers;

{$mode objfpc}{$H+}
interface
  uses Classes;

  type
  { TReader }

  TReader = class
    function ReadBuf(p:pointer; cnt:integer):integer; virtual; abstract;
    function Remains():cardinal; virtual; abstract;
    function Pos():cardinal; virtual; abstract;

    function ReadByte():byte;
    function ReadUWord():word;
    function ReadSWord():smallint;
    function ReadUDword():cardinal;
    function ReadSDword():integer;
    function ReadFloat():single;
    function ReadZString():string;
  end;

  { TFileReader }

  TFileReader = class(TReader)
  protected
    _fs:TFileStream;
    _sz:integer;
  public
    constructor Create(path:string);
    destructor Destroy; override;

    function ReadBuf(p:pointer; cnt:integer):integer; override;
    function Remains():cardinal; override;
    function Pos():cardinal; override;
  end;

implementation
uses SysUtils;

{ TFileReader }

constructor TFileReader.Create(path: string);
begin
  _fs:=TFileStream.Create(path, fmOpenRead);
  _sz:=_fs.Seek(0, soFromEnd);
  _fs.Seek(0, soFromBeginning);
end;

destructor TFileReader.Destroy;
begin
  _fs.Free;
  inherited Destroy;
end;

function TFileReader.ReadBuf(p: pointer; cnt: integer): integer;
var
  cur:integer;
begin
  cur:=_fs.Seek(0, soFromCurrent);
  if (_sz-cur < cnt) then begin
    cnt:=_sz-cur;
  end;
  result:=_fs.Read(PAnsiChar(p)^, cnt);
end;

function TFileReader.Remains(): cardinal;
begin
  result:=_sz - _fs.Seek(0, soFromCurrent);
end;

function TFileReader.Pos(): cardinal;
begin
  result:=_fs.Seek(0, soFromCurrent);
end;

{ TReader }

function TReader.ReadByte(): byte;
var
  cnt:integer;
begin
  result:=0;
  cnt:=ReadBuf(@result, sizeof(result));

  if cnt<>sizeof(result) then begin
    Raise Exception.Create('TReader.ReadByte result has invalid size');
  end;
end;

function TReader.ReadUWord(): word;
var
  cnt:integer;
begin
  result:=0;
  cnt:=ReadBuf(@result, sizeof(result));

  if cnt<>sizeof(result) then begin
    Raise Exception.Create('TReader.ReadByte result has invalid size');
  end;
end;

function TReader.ReadSWord(): smallint;
var
  cnt:integer;
begin
  result:=0;
  cnt:=ReadBuf(@result, sizeof(result));

  if cnt<>sizeof(result) then begin
    Raise Exception.Create('TReader.ReadByte result has invalid size');
  end;
end;

function TReader.ReadUDword(): cardinal;
var
  cnt:integer;
begin
  result:=0;
  cnt:=ReadBuf(@result, sizeof(result));

  if cnt<>sizeof(result) then begin
    Raise Exception.Create('TReader.ReadByte result has invalid size');
  end;
end;

function TReader.ReadSDword(): integer;
var
  cnt:integer;
begin
  result:=0;
  cnt:=ReadBuf(@result, sizeof(result));

  if cnt<>sizeof(result) then begin
    Raise Exception.Create('TReader.ReadByte result has invalid size');
  end;
end;

function TReader.ReadFloat(): single;
var
  cnt:integer;
begin
  result:=0;
  cnt:=ReadBuf(@result, sizeof(result));

  if cnt<>sizeof(result) then begin
    Raise Exception.Create('TReader.ReadByte result has invalid size');
  end;
end;

function TReader.ReadZString(): string;
var
  c:char;
begin
  result:='';
  while true do begin
    c:=chr(ReadByte());
    if c <> chr(0) then begin
      result:=result+c;
    end else begin
      break
    end;
  end;
end;

end.

